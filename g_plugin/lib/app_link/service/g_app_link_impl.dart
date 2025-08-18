import 'dart:async';
import 'package:flutter/services.dart';
import 'package:g_common/g_common.dart';
import 'package:g_lib/g_lib_common.dart' show AppLinks;
import 'package:g_lib/g_lib_network.dart';
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

  /// 링크 프리뷰 관련
  final Dio _dio = Dio();
  final Map<String, LinkPreviewData> _linkPreviewCache = {};

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

  // === 링크 프리뷰 구현 ===

  @override
  Future<LinkPreviewData?> extractLinkMetadata(String url) async {
    try {
      // URL 정규화
      final normalizedUrl = _normalizeUrl(url);

      // 캐시 확인
      if (_linkPreviewCache.containsKey(normalizedUrl)) {
        Logger.d('🔗 링크 프리뷰 캐시 사용: $normalizedUrl');
        return _linkPreviewCache[normalizedUrl];
      }

      Logger.d('🔗 링크 메타데이터 추출 시작: $normalizedUrl');

      // HTTP 요청으로 HTML 가져오기
      final response = await _dio.get(
        normalizedUrl,
        options: Options(
          headers: {
            'User-Agent': 'Mozilla/5.0 (compatible; LinkPreview/1.0)',
            'Accept':
                'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
            'Accept-Language': 'ko-KR,ko;q=0.9,en;q=0.8',
            'Accept-Encoding': 'gzip, deflate',
            'Connection': 'keep-alive',
          },
          validateStatus: (status) => status != null && status < 500,
          followRedirects: true,
          maxRedirects: 5,
          receiveTimeout: const Duration(seconds: 15),
        ),
      );

      Logger.d('🔗 HTTP 응답: ${response.statusCode}');

      if (response.statusCode != 200) {
        Logger.w('🔗 HTTP ${response.statusCode} 응답, 기본 데이터 반환');
        throw Exception('HTTP ${response.statusCode}');
      }

      final html = response.data as String;
      Logger.d('🔗 HTML 크기: ${html.length} 문자');

      final metadata = _parseHtml(html, normalizedUrl);
      Logger.d(
          '🔗 파싱 결과 - 제목: ${metadata.title}, 설명: ${metadata.description}, 이미지: ${metadata.imageUrl}');

      // 캐시 저장 (최대 100개)
      if (_linkPreviewCache.length >= 100) {
        _linkPreviewCache.remove(_linkPreviewCache.keys.first);
      }
      _linkPreviewCache[normalizedUrl] = metadata;

      Logger.d('🔗 링크 메타데이터 추출 완료: ${metadata.title}');
      return metadata;
    } catch (e) {
      Logger.e('🔗 링크 메타데이터 추출 실패: $e');

      // 기본 데이터 반환
      final normalizedUrl = _normalizeUrl(url);
      final fallbackData = LinkPreviewData(
        url: normalizedUrl,
        title: _extractDomainFromUrl(normalizedUrl),
        description: '링크 프리뷰를 불러올 수 없습니다.',
      );
      
      // 실패해도 캐시에 저장 (재시도 방지)
      _linkPreviewCache[normalizedUrl] = fallbackData;
      
      return fallbackData;
    }
  }

  @override
  void clearLinkPreviewCache() {
    _linkPreviewCache.clear();
    Logger.d('🔗 링크 프리뷰 캐시 클리어됨');
  }

  @override
  void removeLinkPreviewCache(String url) {
    final normalizedUrl = _normalizeUrl(url);
    _linkPreviewCache.remove(normalizedUrl);
  }

  @override
  int get linkPreviewCacheSize => _linkPreviewCache.length;

  /// HTML에서 메타데이터 파싱
  LinkPreviewData _parseHtml(String html, String url) {
    String? title;
    String? description;
    String? imageUrl;
    String? siteName;
    String? favicon;

    // 더 유연한 정규식 패턴 사용
    // OpenGraph 메타 태그 추출 - content와 property 순서에 관계없이
    final ogTitleMatch = RegExp(
            r'<meta[^>]*(?:property=["\x27]og:title["\x27][^>]*content=["\x27]([^"\x27]*)["\x27]|content=["\x27]([^"\x27]*)["\x27][^>]*property=["\x27]og:title["\x27])',
            caseSensitive: false)
        .firstMatch(html);
    final ogDescMatch = RegExp(
            r'<meta[^>]*(?:property=["\x27]og:description["\x27][^>]*content=["\x27]([^"\x27]*)["\x27]|content=["\x27]([^"\x27]*)["\x27][^>]*property=["\x27]og:description["\x27])',
            caseSensitive: false)
        .firstMatch(html);
    final ogImageMatch = RegExp(
            r'<meta[^>]*(?:property=["\x27]og:image["\x27][^>]*content=["\x27]([^"\x27]*)["\x27]|content=["\x27]([^"\x27]*)["\x27][^>]*property=["\x27]og:image["\x27])',
            caseSensitive: false)
        .firstMatch(html);
    final ogSiteMatch = RegExp(
            r'<meta[^>]*(?:property=["\x27]og:site_name["\x27][^>]*content=["\x27]([^"\x27]*)["\x27]|content=["\x27]([^"\x27]*)["\x27][^>]*property=["\x27]og:site_name["\x27])',
            caseSensitive: false)
        .firstMatch(html);

    // Twitter Card 메타 태그 추출
    final twitterTitleMatch = RegExp(
            r'<meta[^>]*name=["\x27]twitter:title["\x27][^>]*content=["\x27]([^"\x27]*)["\x27]',
            caseSensitive: false)
        .firstMatch(html);
    final twitterDescMatch = RegExp(
            r'<meta[^>]*name=["\x27]twitter:description["\x27][^>]*content=["\x27]([^"\x27]*)["\x27]',
            caseSensitive: false)
        .firstMatch(html);
    final twitterImageMatch = RegExp(
            r'<meta[^>]*name=["\x27]twitter:image["\x27][^>]*content=["\x27]([^"\x27]*)["\x27]',
            caseSensitive: false)
        .firstMatch(html);

    // 기본 메타 태그 추출
    final titleMatch =
        RegExp(r'<title[^>]*>([^<]*)</title>', caseSensitive: false)
            .firstMatch(html);
    final descMatch = RegExp(
            r'<meta[^>]*name=["\x27]description["\x27][^>]*content=["\x27]([^"\x27]*)["\x27]',
            caseSensitive: false)
        .firstMatch(html);
    final faviconMatch = RegExp(
            r'<link[^>]*rel=["\x27][^"\x27]*icon[^"\x27]*["\x27][^>]*href=["\x27]([^"\x27]*)["\x27]',
            caseSensitive: false)
        .firstMatch(html);

    // 우선순위: OpenGraph > Twitter > 기본
    // 정규식 그룹 처리 개선
    title = (ogTitleMatch?.group(1) ?? ogTitleMatch?.group(2)) ??
        twitterTitleMatch?.group(1) ??
        titleMatch?.group(1);
    description = (ogDescMatch?.group(1) ?? ogDescMatch?.group(2)) ??
        twitterDescMatch?.group(1) ??
        descMatch?.group(1);
    imageUrl = (ogImageMatch?.group(1) ?? ogImageMatch?.group(2)) ??
        twitterImageMatch?.group(1);
    siteName = (ogSiteMatch?.group(1) ?? ogSiteMatch?.group(2));
    favicon = faviconMatch?.group(1);

    Logger.d(
        '🔗 파싱된 메타데이터: title=$title, desc=$description, img=$imageUrl, site=$siteName');

    // 상대 URL을 절대 URL로 변환
    if (imageUrl != null && imageUrl.startsWith('/')) {
      final uri = Uri.parse(url);
      imageUrl = '${uri.scheme}://${uri.host}$imageUrl';
    }
    if (favicon != null && favicon.startsWith('/')) {
      final uri = Uri.parse(url);
      favicon = '${uri.scheme}://${uri.host}$favicon';
    }

    // HTML 엔티티 디코딩
    title = _decodeHtmlEntities(title);
    description = _decodeHtmlEntities(description);

    return LinkPreviewData(
      url: url,
      title: title?.trim().isNotEmpty == true
          ? title!.trim()
          : _extractDomainFromUrl(url),
      description:
          description?.trim().isNotEmpty == true ? description!.trim() : null,
      imageUrl: imageUrl?.trim().isNotEmpty == true ? imageUrl!.trim() : null,
      siteName: siteName?.trim().isNotEmpty == true ? siteName!.trim() : null,
      favicon: favicon?.trim().isNotEmpty == true ? favicon!.trim() : null,
    );
  }

  /// URL 정규화
  String _normalizeUrl(String url) {
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }
    return url;
  }

  /// URL에서 도메인 추출
  String _extractDomainFromUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.host;
    } catch (e) {
      return url;
    }
  }

  /// HTML 엔티티 디코딩
  String? _decodeHtmlEntities(String? text) {
    if (text == null) return null;

    return text
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll('&nbsp;', ' ');
  }
}
