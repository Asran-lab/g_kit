import 'dart:async';
import 'package:flutter/services.dart';
import 'package:g_common/utils/g_guard.dart' show guardFuture;
import 'package:g_lib/g_lib_common.dart' show AppLinks;
import 'g_app_link_service.dart';

/// 앱 링크 서비스 구현체
///
/// app_links 라이브러리를 사용하여 딥링크를 처리합니다.
class GAppLinkImpl implements GAppLinkService {
  AppLinks? _appLinks;
  StreamSubscription<dynamic>? _subscription;
  bool _isInitialized = false;

  /// 딥링크 처리 콜백
  DeepLinkCallback? _onDeepLink;
  DeepLinkErrorCallback? _onError;

  /// 딥링크 타입 매핑 (동적 설정)
  Map<String, DeepLinkTypeMatcher> _deepLinkTypes = {};

  /// 등록된 리스너들
  final Map<String, DeepLinkCallback> _listeners = {};
  final Map<String, DeepLinkErrorCallback> _errorListeners = {};

  @override
  Future<void> initialize({
    required DeepLinkCallback onDeepLink,
    DeepLinkErrorCallback? onError,
    Map<String, DeepLinkTypeMatcher>? deepLinkTypes,
  }) async {
    if (_isInitialized) {
      throw StateError('GAppLinkImpl is already initialized');
    }

    _onDeepLink = onDeepLink;
    _onError = onError;

    // 딥링크 타입 설정 (사용자 정의만 사용)
    if (deepLinkTypes != null) {
      _deepLinkTypes = Map.from(deepLinkTypes);
    }

    try {
      _appLinks = AppLinks();

      // 초기 딥링크 확인
      await _checkInitialLink();

      // 딥링크 스트림 구독
      await _subscribeToDeepLinks();

      _isInitialized = true;
    } catch (e) {
      _onError?.call('Failed to initialize deep links: $e');
      rethrow;
    }
  }

  /// 초기 딥링크 확인
  Future<void> _checkInitialLink() async {
    await guardFuture(() async {
      final initialLink = await _appLinks?.getInitialLinkString();
      if (initialLink != null && initialLink.isNotEmpty) {
        // 기본 콜백 호출
        _onDeepLink?.call(initialLink);

        // 등록된 모든 리스너에게 알림
        for (final listener in _listeners.values) {
          listener(initialLink);
        }
      }
    }, typeHandlers: {
      PlatformException: (e, s) {
        final errorMessage = 'Initial link error: ${e.toString()}';
        // 기본 에러 콜백 호출
        _onError?.call(errorMessage);

        // 등록된 모든 에러 리스너에게 알림
        for (final errorListener in _errorListeners.values) {
          errorListener(errorMessage);
        }
      },
    });
  }

  /// 딥링크 스트림 구독
  Future<void> _subscribeToDeepLinks() async {
    if (_appLinks == null) return;

    _subscription = _appLinks!.uriLinkStream.listen(
      (uri) {
        final link = uri.toString();
        if (link.isNotEmpty) {
          // 기본 콜백 호출
          _onDeepLink?.call(link);

          // 등록된 모든 리스너에게 알림
          for (final listener in _listeners.values) {
            listener(link);
          }
        }
      },
      onError: (error) {
        final errorMessage = 'Deep link stream error: $error';
        // 기본 에러 콜백 호출
        _onError?.call(errorMessage);

        // 등록된 모든 에러 리스너에게 알림
        for (final errorListener in _errorListeners.values) {
          errorListener(errorMessage);
        }
      },
    );
  }

  @override
  Future<void> dispose() async {
    if (_isInitialized) {
      await _subscription?.cancel();
      _subscription = null;
      _appLinks = null;
      _isInitialized = false;
      _onDeepLink = null;
      _onError = null;
      _deepLinkTypes.clear();
    }
  }

  @override
  bool get isInitialized => _isInitialized;

  @override
  bool get isListening => _subscription != null && !_subscription!.isPaused;

  @override
  void pause() {
    _subscription?.pause();
  }

  @override
  void resume() {
    _subscription?.resume();
  }

  @override
  Map<String, String> parseDeepLink(String link) {
    try {
      final uri = Uri.parse(link);
      final queryParams = uri.queryParameters;

      return {
        'scheme': uri.scheme,
        'host': uri.host,
        'path': uri.path,
        'query': uri.query,
        ...queryParams,
      };
    } catch (e) {
      _onError?.call('Failed to parse deep link: $link');
      return {};
    }
  }

  @override
  String getDeepLinkType(String link) {
    try {
      final uri = Uri.parse(link);
      final host = uri.host.toLowerCase();
      final path = uri.path.toLowerCase();

      // 등록된 타입들 중에서 매칭되는 것 찾기
      for (final entry in _deepLinkTypes.entries) {
        if (entry.value(host) || entry.value(path)) {
          return entry.key;
        }
      }

      return 'unknown';
    } catch (e) {
      return 'unknown';
    }
  }

  @override
  bool isValidDeepLink(String link) {
    try {
      final uri = Uri.parse(link);
      return uri.scheme.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  bool isDeepLinkType(String link, String type) {
    return getDeepLinkType(link) == type;
  }

  @override
  String? extractIdFromDeepLink(String link) {
    try {
      final uri = Uri.parse(link);
      final pathSegments = uri.pathSegments;

      // 먼저 쿼리 파라미터에서 ID 찾기
      if (uri.queryParameters.containsKey('id')) {
        return uri.queryParameters['id'];
      }

      // 마지막 path segment를 ID로 간주 (숫자가 아니어도 포함)
      if (pathSegments.isNotEmpty) {
        final lastSegment = pathSegments.last;
        // 빈 문자열이 아니면 ID로 간주
        if (lastSegment.isNotEmpty) {
          return lastSegment;
        }
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  String? extractParameterFromDeepLink(String link, String parameter) {
    try {
      final uri = Uri.parse(link);
      return uri.queryParameters[parameter];
    } catch (e) {
      return null;
    }
  }

  @override
  void addDeepLinkType(String type, DeepLinkTypeMatcher matcher) {
    _deepLinkTypes[type] = matcher;
  }

  @override
  void removeDeepLinkType(String type) {
    _deepLinkTypes.remove(type);
  }

  @override
  List<String> get registeredDeepLinkTypes => _deepLinkTypes.keys.toList();

  @override
  void handleDeepLink(String link) {
    if (isValidDeepLink(link)) {
      // 기본 콜백 호출
      _onDeepLink?.call(link);

      // 등록된 모든 리스너에게 알림
      for (final listener in _listeners.values) {
        listener(link);
      }
    } else {
      final errorMessage = 'Invalid deep link: $link';
      // 기본 에러 콜백 호출
      _onError?.call(errorMessage);

      // 등록된 모든 에러 리스너에게 알림
      for (final errorListener in _errorListeners.values) {
        errorListener(errorMessage);
      }
    }
  }

  @override
  void listen({
    required DeepLinkCallback onDeepLink,
    DeepLinkErrorCallback? onError,
    String? name,
  }) {
    final listenerName = name ?? 'default';
    _listeners[listenerName] = onDeepLink;
    if (onError != null) {
      _errorListeners[listenerName] = onError;
    }
  }

  @override
  List<String> get registeredListeners {
    return _listeners.keys.toList();
  }

  @override
  void removeListener([String? name]) {
    if (name == null) {
      // 모든 리스너 제거
      _listeners.clear();
      _errorListeners.clear();
    } else {
      // 특정 리스너만 제거
      _listeners.remove(name);
      _errorListeners.remove(name);
    }
  }
}
