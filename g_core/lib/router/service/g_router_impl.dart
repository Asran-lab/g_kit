import 'dart:async';
import 'package:flutter/material.dart';
import 'package:g_common/g_common.dart';
import 'package:g_core/router/common/g_router_state.dart' show GRouterState;
import 'package:g_core/router/service/g_router_service.dart';
import 'package:g_core/router/common/g_router_config.dart';

/// 라우터 서비스 구현체
/// Flutter의 표준 RouterConfig를 사용하여 라우터를 관리합니다.
class GRouterImpl extends GRouterService {
  final GRouterConfig _config;
  final _routerStateController = StreamController<GRouterState>.broadcast();
  final _listeners = <VoidCallback>[];

  bool _isInitialized = false;
  String _currentPath = '/';
  List<String> _navigationStack = ['/'];
  RouteInformation? _currentRouteInformation;

  GRouterImpl(this._config);

  @override
  RouterConfig<Object?> get routerConfig => _buildRouterConfig();

  @override
  bool get isInitialized => _isInitialized;

  @override
  String get currentPath => _currentPath;

  @override
  RouteInformation? get currentRouteInformation => _currentRouteInformation;

  @override
  Stream<GRouterState> get routerStateStream => _routerStateController.stream;

  @override
  Future<void> initialize() async {
    if (_isInitialized) return;

    await guardFuture(() async {
      Logger.i('🚀 GRouter 초기화 시작...');

      // 초기 경로 설정
      _currentPath = _config.initialPath ?? '/';
      _navigationStack = [_currentPath];

      // 라우터 상태 업데이트
      _updateRouterState();

      _isInitialized = true;
      Logger.i('✅ GRouter 초기화 완료');
    });
  }

  @override
  Future<void> dispose() async {
    await guardFuture(() async {
      Logger.i('🧹 GRouter 정리 중...');

      _routerStateController.close();
      _listeners.clear();
      _isInitialized = false;

      Logger.i('✅ GRouter 정리 완료');
    });
  }

  @override
  Future<void> replace(String path, {GJson? arguments}) async {
    await guardFuture(() async {
      Logger.d('🔄 라우터 교체: $path');

      // 현재 페이지를 새 페이지로 교체
      _currentPath = path;
      _navigationStack = [path]; // 스택을 새 경로로 교체

      // 라우터 상태 업데이트
      _updateRouterState();

      // 리스너 호출
      _notifyListeners();

      Logger.d('✅ 라우터 교체 완료: $path');
    });
  }

  @override
  Future<void> go(String path, {GJson? arguments}) async {
    await guardFuture(() async {
      Logger.d('📤 라우터 이동: $path');

      // 새 페이지를 스택에 추가
      _currentPath = path;
      _navigationStack.add(path);

      // 라우터 상태 업데이트
      _updateRouterState();

      // 리스너 호출
      _notifyListeners();

      Logger.d('✅ 라우터 이동 완료: $path');
    });
  }

  @override
  Future<void> goBack() async {
    await guardFuture(() async {
      if (!await canGoBack()) {
        Logger.w('⚠️ 뒤로 갈 수 없습니다.');
        return;
      }

      Logger.d('⬅️ 라우터 뒤로 가기');

      // 스택에서 마지막 페이지 제거
      _navigationStack.removeLast();

      // 이전 페이지로 이동
      _currentPath = _navigationStack.last;

      // 라우터 상태 업데이트
      _updateRouterState();

      // 리스너 호출
      _notifyListeners();

      Logger.d('✅ 라우터 뒤로 가기 완료: $_currentPath');
    });
  }

  @override
  Future<bool> canGoBack() async {
    return _navigationStack.length > 1;
  }

  @override
  Future<void> goBackUntil(String path) async {
    await guardFuture(() async {
      Logger.d('⬅️ 라우터 뒤로 가기 (until: $path)');

      // 스택에서 해당 경로까지 제거
      while (_navigationStack.length > 1 && _navigationStack.last != path) {
        _navigationStack.removeLast();
      }

      // 해당 경로로 이동
      _currentPath = _navigationStack.last;

      // 라우터 상태 업데이트
      _updateRouterState();

      // 리스너 호출
      _notifyListeners();

      Logger.d('✅ 라우터 뒤로 가기 완료: $_currentPath');
    });
  }

  @override
  Future<void> goUntil(String path, {GJson? arguments}) async {
    await guardFuture(() async {
      Logger.d('🔄 라우터 교체 (until: $path)');

      // 스택을 새 경로로 교체
      _currentPath = path;
      _navigationStack = [path];

      // 라우터 상태 업데이트
      _updateRouterState();

      // 리스너 호출
      _notifyListeners();

      Logger.d('✅ 라우터 교체 완료: $path');
    });
  }

  @override
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  /// RouterConfig 빌드
  RouterConfig<Object?> _buildRouterConfig() {
    return RouterConfig<Object?>(
      routeInformationParser: _RouteInformationParserImpl(),
      routerDelegate: _RouterDelegateImpl(this),
      routeInformationProvider: _RouteInformationProviderImpl(this),
    );
  }

  /// 라우터 상태 업데이트
  void _updateRouterState() {
    final state = GRouterState(
      currentPath: _currentPath,
      routeInformation: _currentRouteInformation,
      canGoBack: _navigationStack.length > 1,
      navigationStack: List.from(_navigationStack),
    );

    _routerStateController.add(state);
  }

  /// 리스너 호출
  void _notifyListeners() {
    for (final listener in _listeners) {
      listener();
    }
  }

  /// 경로에 해당하는 라우트 찾기
  GRouteConfig? _findRoute(String path) {
    // 일반 라우트에서 찾기
    try {
      return _config.routes.firstWhere(
        (route) => route.path == path,
      );
    } catch (e) {
      // 쉘 라우트의 자식에서 찾기
      if (_config.shellRoutes != null) {
        for (final shellRoute in _config.shellRoutes!) {
          try {
            return shellRoute.children.firstWhere(
              (route) => route.path == path,
            );
          } catch (e) {
            // 계속 다음 쉘 라우트 확인
          }
        }
      }
      return null;
    }
  }

  /// 라우트 빌더 호출
  Widget _buildRoute(BuildContext context, String path, GJson? arguments) {
    final route = _findRoute(path);
    if (route == null) {
      return _buildErrorPage(context, 'Route not found: $path');
    }

    try {
      // 가드 체크
      if (route.guard != null && !route.guard!()) {
        Logger.w('🚫 라우트 가드 실패: $path');
        return _buildErrorPage(context, 'Access denied: $path');
      }

      // 리다이렉트 체크
      if (route.redirect != null) {
        final redirectPath = route.redirect!();
        if (redirectPath != null) {
          Logger.d('🔄 라우트 리다이렉트: $path -> $redirectPath');
          // 리다이렉트 처리 (실제로는 라우터가 처리해야 함)
        }
      }

      // 트랜지션 적용
      final widget = route.builder(context, arguments);
      if (route.transition != null) {
        return route.transition!(
          context,
          const AlwaysStoppedAnimation(1.0),
          const AlwaysStoppedAnimation(0.0),
          widget,
        );
      }

      return widget;
    } catch (e) {
      Logger.e('❌ 라우트 빌드 실패: $path, 에러: $e');
      return _buildErrorPage(context, 'Failed to build route: $path');
    }
  }

  /// 에러 페이지 빌드
  Widget _buildErrorPage(BuildContext context, String message) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(message, style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
      ),
    );
  }
}

/// RouteInformationParser 구현체
class _RouteInformationParserImpl extends RouteInformationParser<Object?> {
  @override
  Future<Object?> parseRouteInformation(
      RouteInformation routeInformation) async {
    return routeInformation.uri.toString();
  }

  @override
  RouteInformation? restoreRouteInformation(Object? configuration) {
    return RouteInformation(uri: Uri.parse(configuration as String));
  }
}

/// RouterDelegate 구현체
class _RouterDelegateImpl extends RouterDelegate<Object?> {
  final GRouterImpl _router;
  final _listeners = <VoidCallback>[];

  _RouterDelegateImpl(this._router) {
    _router.addListener(_notifyListeners);
  }

  @override
  Future<void> setNewRoutePath(Object? configuration) async {
    if (configuration is String) {
      await _router.replace(configuration);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _router._buildRoute(context, _router.currentPath, null);
  }

  @override
  Future<bool> popRoute() async {
    if (await _router.canGoBack()) {
      await _router.goBack();
      return true;
    }
    return false;
  }

  @override
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  void _notifyListeners() {
    for (final listener in _listeners) {
      listener();
    }
  }
}

/// RouteInformationProvider 구현체
class _RouteInformationProviderImpl extends RouteInformationProvider {
  final GRouterImpl _router;
  final _listeners = <VoidCallback>[];

  _RouteInformationProviderImpl(this._router);

  RouteInformation? get initialRouteInformation {
    return RouteInformation(uri: Uri.parse(_router.currentPath));
  }

  void routerDelegate(
      RouterDelegate<Object?> delegate, RouteInformation? routeInformation) {
    // 라우터 정보 업데이트
    if (routeInformation?.uri != null) {
      _router._currentRouteInformation = routeInformation;
    }
  }

  @override
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  @override
  RouteInformation get value {
    return RouteInformation(uri: Uri.parse(_router.currentPath));
  }
}
