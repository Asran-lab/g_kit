import 'dart:async';
import 'package:flutter/material.dart';
import 'package:g_common/g_common.dart';
import 'package:g_core/router/common/g_router_state.dart' show GRouterState;
import 'package:g_core/router/service/g_router_service.dart';
import 'package:g_core/router/common/g_router_config.dart';

/// 라우터 서비스 구현체
/// Flutter의 표준 RouterConfig를 사용하여 라우터를 관리합니다.
class GRouterImpl extends GRouterService {
  final List<GRouteConfig> _configs = [];
  final List<GShellRouteConfig> _shellConfigs = [];
  final _routerStateController = StreamController<GRouterState>.broadcast();
  final _listeners = <VoidCallback>[];
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  bool _isInitialized = false;
  String _currentPath = '/';
  List<String> _navigationStack = ['/'];
  RouteInformation? _currentRouteInformation;

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

  /// Navigator Key 반환 (외부에서 Navigator에 접근할 때 사용)
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  @override
  Future<void> initialize(
    List<GRouteConfig>? configs, {
    List<GShellRouteConfig>? shellConfigs,
    String initialPath = '/',
  }) async {
    if (_isInitialized) return;

    await guardFuture(() async {
      Logger.i('🚀 GRouter 초기화 시작...');

      _configs.clear();
      if (configs != null) {
        _configs.addAll(configs);
      }

      _shellConfigs.clear();
      if (shellConfigs != null) {
        _shellConfigs.addAll(shellConfigs);
      }

      // 초기 경로 설정
      _currentPath = initialPath;
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

      // 라우트 검증
      final route = _findRoute(path);
      if (route == null) {
        Logger.e('❌ 라우트를 찾을 수 없습니다: $path');
        return;
      }

      // 가드 체크
      if (route.guard != null && !route.guard!()) {
        Logger.w('🚫 라우트 가드 실패: $path');
        return;
      }

      // 리다이렉트 체크
      final redirectPath = _checkRedirect(route);
      if (redirectPath != null) {
        return replace(redirectPath, arguments: arguments);
      }

      // 현재 페이지를 새 페이지로 교체
      _currentPath = path;
      _navigationStack = [path]; // 스택을 새 경로로 교체

      // Navigator 상태 업데이트 (있는 경우에만)
      _navigatorKey.currentState?.pushNamedAndRemoveUntil(
        path,
        (route) => false,
        arguments: arguments,
      );

      // 라우터 상태 업데이트
      _updateRouterState();

      Logger.d('✅ 라우터 교체 완료: $path');
    });
  }

  @override
  Future<void> go(String path, {GJson? arguments}) async {
    await guardFuture(() async {
      Logger.d('📤 라우터 이동: $path');

      // 라우트 검증
      final route = _findRoute(path);
      if (route == null) {
        Logger.e('❌ 라우트를 찾을 수 없습니다: $path');
        return;
      }

      // 가드 체크
      if (route.guard != null && !route.guard!()) {
        Logger.w('🚫 라우트 가드 실패: $path');
        return;
      }

      // 리다이렉트 체크
      final redirectPath = _checkRedirect(route);
      if (redirectPath != null) {
        return go(redirectPath, arguments: arguments);
      }

      // 새 페이지를 스택에 추가
      _currentPath = path;
      _navigationStack.add(path);

      // Navigator 상태 업데이트 (있는 경우에만)
      _navigatorKey.currentState?.pushNamed(path, arguments: arguments);

      // 라우터 상태 업데이트
      _updateRouterState();

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

      // Navigator를 사용해서 뒤로 가기 (있는 경우에만)
      if (_navigatorKey.currentState?.canPop() == true) {
        _navigatorKey.currentState?.pop();
      }

      // 스택에서 마지막 페이지 제거
      _navigationStack.removeLast();

      // 이전 페이지로 이동
      _currentPath = _navigationStack.last;

      // 라우터 상태 업데이트
      _updateRouterState();

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

      // Navigator를 사용해서 특정 경로까지 뒤로 가기 (있는 경우에만)
      _navigatorKey.currentState?.popUntil(ModalRoute.withName(path));

      // 스택에서 해당 경로까지 제거
      while (_navigationStack.length > 1 && _navigationStack.last != path) {
        _navigationStack.removeLast();
      }

      // 해당 경로로 이동
      _currentPath = _navigationStack.last;

      // 라우터 상태 업데이트
      _updateRouterState();

      Logger.d('✅ 라우터 뒤로 가기 완료: $_currentPath');
    });
  }

  @override
  Future<void> goUntil(String path, {GJson? arguments}) async {
    await guardFuture(() async {
      Logger.d('🔄 라우터 교체 (until: $path)');

      // 라우트 검증
      final route = _findRoute(path);
      if (route == null) {
        Logger.e('❌ 라우트를 찾을 수 없습니다: $path');
        return;
      }

      // 가드 체크
      if (route.guard != null && !route.guard!()) {
        Logger.w('🚫 라우트 가드 실패: $path');
        return;
      }

      // 리다이렉트 체크
      final redirectPath = _checkRedirect(route);
      if (redirectPath != null) {
        return goUntil(redirectPath, arguments: arguments);
      }

      // 스택을 새 경로로 교체
      _currentPath = path;
      _navigationStack = [path];

      // Navigator 상태 업데이트 (있는 경우에만)
      _navigatorKey.currentState?.pushNamedAndRemoveUntil(
        path,
        (route) => false,
        arguments: arguments,
      );

      // 라우터 상태 업데이트
      _updateRouterState();

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

  /// MaterialApp.router를 대신해서 MaterialApp을 빌드하는 메서드
  Widget buildMaterialApp({
    String? title,
    ThemeData? theme,
    ThemeData? darkTheme,
    ThemeMode? themeMode,
    Locale? locale,
    Iterable<Locale>? supportedLocales,
    Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
    bool debugShowCheckedModeBanner = true,
  }) {
    return MaterialApp(
      title: title ?? 'Flutter App',
      theme: theme,
      darkTheme: darkTheme,
      themeMode: themeMode ?? ThemeMode.system,
      locale: locale,
      supportedLocales: supportedLocales ?? const [Locale('ko', 'KR')],
      localizationsDelegates: localizationsDelegates,
      debugShowCheckedModeBanner: debugShowCheckedModeBanner,
      navigatorKey: _navigatorKey,
      initialRoute: _currentPath,
      onGenerateRoute: _onGenerateRoute,
      onUnknownRoute: _onUnknownRoute,
    );
  }

  /// RouterConfig 빌드
  RouterConfig<Object?> _buildRouterConfig() {
    return RouterConfig<Object?>(
      routeInformationParser: _RouteInformationParserImpl(),
      routerDelegate: _RouterDelegateImpl(this),
      routeInformationProvider: _RouteInformationProviderImpl(this),
    );
  }

  /// 라우트 생성 핸들러
  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    final routeName = settings.name ?? '/';
    final arguments = settings.arguments as GJson?;

    // 쉘 라우트 체크
    final shellRoute = _findShellRoute(routeName);
    if (shellRoute != null) {
      return _buildShellRoute(shellRoute, routeName, arguments);
    }

    // 일반 라우트 체크
    final route = _findRoute(routeName);
    if (route != null) {
      return _buildRoute(route, arguments);
    }

    return null;
  }

  /// 알 수 없는 라우트 핸들러
  Route<dynamic>? _onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => _buildErrorPage(
        context,
        'Route not found: ${settings.name}',
      ),
    );
  }

  /// 일반 라우트 빌드
  MaterialPageRoute _buildRoute(GRouteConfig route, GJson? arguments) {
    return MaterialPageRoute(
      settings: RouteSettings(name: route.path),
      builder: (context) {
        try {
          final widget = route.builder(context, arguments);

          // 트랜지션 적용
          if (route.transition != null) {
            return AnimatedBuilder(
              animation: ModalRoute.of(context)?.animation ??
                  const AlwaysStoppedAnimation(1.0),
              builder: (context, child) {
                return route.transition!(
                  context,
                  ModalRoute.of(context)?.animation ??
                      const AlwaysStoppedAnimation(1.0),
                  ModalRoute.of(context)?.secondaryAnimation ??
                      const AlwaysStoppedAnimation(0.0),
                  widget,
                );
              },
            );
          }

          return widget;
        } catch (e) {
          Logger.e('❌ 라우트 빌드 실패: ${route.path}, 에러: $e');
          return _buildErrorPage(
              context, 'Failed to build route: ${route.path}');
        }
      },
    );
  }

  /// 쉘 라우트 빌드
  MaterialPageRoute _buildShellRoute(
    GShellRouteConfig shellRoute,
    String routeName,
    GJson? arguments,
  ) {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (context) {
        try {
          // 자식 라우트 찾기
          final childRoute = shellRoute.children
              .where((child) => child.path == routeName)
              .firstOrNull;

          if (childRoute == null) {
            return _buildErrorPage(
                context, 'Child route not found: $routeName');
          }

          final childWidget = childRoute.builder(context, arguments);

          // 쉘과 자식을 결합
          return shellRoute.builder(context, childWidget);
        } catch (e) {
          Logger.e('❌ 쉘 라우트 빌드 실패: $routeName, 에러: $e');
          return _buildErrorPage(
              context, 'Failed to build shell route: $routeName');
        }
      },
    );
  }

  /// 라우터 상태 업데이트
  void _updateRouterState() {
    _currentRouteInformation = RouteInformation(
      uri: Uri.parse(_currentPath),
    );

    final state = GRouterState(
      currentPath: _currentPath,
      routeInformation: _currentRouteInformation,
      canGoBack: _navigationStack.length > 1,
      navigationStack: List.from(_navigationStack),
    );

    _routerStateController.add(state);
    _notifyListeners();
  }

  /// 리스너 호출
  void _notifyListeners() {
    for (final listener in _listeners) {
      try {
        listener();
      } catch (e) {
        Logger.e('❌ 리스너 호출 실패: $e');
      }
    }
  }

  /// 경로에 해당하는 라우트 찾기 - 수정됨
  GRouteConfig? _findRoute(String path) {
    // 일반 라우트에서 찾기
    try {
      return _configs.firstWhere(
        (route) => route.path == path,
      );
    } catch (e) {
      // 쉘 라우트의 자식에서 찾기
      for (final shellRoute in _shellConfigs) {
        try {
          return shellRoute.children.firstWhere(
            (route) => route.path == path,
          );
        } catch (e) {
          // 계속 다음 쉘 라우트 확인
        }
      }
      return null;
    }
  }

  /// 쉘 라우트 찾기
  GShellRouteConfig? _findShellRoute(String path) {
    for (final shellRoute in _shellConfigs) {
      if (shellRoute.children.any((child) => child.path == path)) {
        return shellRoute;
      }
    }
    return null;
  }

  /// 리다이렉트 체크
  String? _checkRedirect(GRouteConfig route) {
    if (route.redirect != null) {
      final redirectPath = route.redirect!();
      if (redirectPath != null) {
        Logger.d('🔄 라우트 리다이렉트: ${route.path} -> $redirectPath');
        return redirectPath;
      }
    }
    return null;
  }

  /// 라우트 빌더 호출 (RouterDelegate에서 사용)
  Widget _buildRouteForDelegate(
      BuildContext context, String path, GJson? arguments) {
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
      final redirectPath = _checkRedirect(route);
      if (redirectPath != null) {
        Logger.d('🔄 라우트 리다이렉트: $path -> $redirectPath');
        // 실제 리다이렉트는 라우터 레벨에서 처리해야 하므로 현재 경로 빌드
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
            Text(
              message,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async => await goBack(),
              child: const Text('뒤로 가기'),
            ),
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
    return _router._buildRouteForDelegate(context, _router.currentPath, null);
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
      try {
        listener();
      } catch (e) {
        Logger.e('❌ RouterDelegate 리스너 호출 실패: $e');
      }
    }
  }
}

/// RouteInformationProvider 구현체
class _RouteInformationProviderImpl extends RouteInformationProvider {
  final GRouterImpl _router;
  final _listeners = <VoidCallback>[];

  _RouteInformationProviderImpl(this._router);

  @override
  RouteInformation get value {
    return RouteInformation(uri: Uri.parse(_router.currentPath));
  }

  @override
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }
}
