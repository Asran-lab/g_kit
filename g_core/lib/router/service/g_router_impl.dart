import 'dart:async';
import 'package:flutter/material.dart';
import 'package:g_common/g_common.dart';
import 'package:g_core/router/common/g_router_state.dart' show GRouterState;
import 'package:g_core/router/service/g_router_service.dart';
import 'package:g_core/router/common/g_router_config.dart';
import 'package:g_lib/g_lib.dart';

/// 라우터 서비스 구현체
/// go_router를 사용하여 라우터를 관리합니다.
class GRouterImpl extends GRouterService {
  late GoRouter _goRouter;
  GoRouter get goRouter => _goRouter;
  final List<GRouteConfig> _configs = [];
  final List<GShellRouteConfig> _shellConfigs = [];
  final _routerStateController = StreamController<GRouterState>.broadcast();

  bool _isInitialized = false;

  @override
  RouterConfig<Object?> get routerConfig => _goRouter;

  @override
  bool get isInitialized => _isInitialized;

  @override
  String get currentPath => _goRouter.routeInformationProvider.value.uri.path;

  @override
  RouteInformation? get currentRouteInformation =>
      _goRouter.routeInformationProvider.value;

  @override
  Stream<GRouterState> get routerStateStream => _routerStateController.stream;

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

      final routes = <RouteBase>[];

      // 일반 라우트 추가
      routes.addAll(_configs.map(
        (config) => GoRoute(
          path: '/${config.path}',
          name: config.name,
          pageBuilder: (context, state) {
            final arguments = state.extra as GJson?;
            final child = config.builder(context, arguments);

            // transitionBuilder가 있으면 적용, 없으면 기본 페이지 반환
            if (config.transition != null) {
              return CustomTransitionPage(
                key: state.pageKey,
                child: child,
                transitionDuration: const Duration(milliseconds: 400),
                reverseTransitionDuration: const Duration(milliseconds: 400),
                transitionsBuilder: config.transition!,
              );
            } else {
              return MaterialPage(
                key: state.pageKey,
                child: child,
              );
            }
          },
        ),
      ));

      // 쉘 라우트 추가
      routes.addAll(_shellConfigs.map(
        (shellConfig) => ShellRoute(
          builder: (context, state, child) =>
              shellConfig.builder(context, child),
          routes: shellConfig.children
              .map(
                (childConfig) => GoRoute(
                  path: '/${childConfig.path}',
                  name: childConfig.name,
                  pageBuilder: (context, state) {
                    final arguments = state.extra as GJson?;
                    final child = childConfig.builder(context, arguments);

                    // transitionBuilder가 있으면 적용, 없으면 기본 페이지 반환
                    if (childConfig.transition != null) {
                      return CustomTransitionPage(
                        key: state.pageKey,
                        child: child,
                        transitionDuration: const Duration(milliseconds: 400),
                        reverseTransitionDuration:
                            const Duration(milliseconds: 400),
                        transitionsBuilder: childConfig.transition!,
                      );
                    } else {
                      return MaterialPage(
                        key: state.pageKey,
                        child: child,
                      );
                    }
                  },
                ),
              )
              .toList(),
        ),
      ));

      _goRouter = GoRouter(
        initialLocation: initialPath,
        routes: routes,
      );

      _isInitialized = true;
      Logger.i('✅ GRouter 초기화 완료');
    });
  }

  @override
  Future<void> dispose() async {
    await guardFuture(() async {
      Logger.i('🧹 GRouter 정리 중...');

      _routerStateController.close();
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

      _goRouter.go(path, extra: arguments);
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

      _goRouter.push(path, extra: arguments);
      _updateRouterState();

      Logger.d('✅ 라우터 이동 완룬: $path');
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

      _goRouter.pop();
      _updateRouterState();

      Logger.d('✅ 라우터 뒤로 가기 완료');
    });
  }

  @override
  Future<bool> canGoBack() async {
    return _goRouter.canPop();
  }

  @override
  Future<void> goBackUntil(String path) async {
    await guardFuture(() async {
      Logger.d('⬅️ 라우터 뒤로 가기 (until: $path)');

      while (_goRouter.canPop() && currentPath != path) {
        _goRouter.pop();
      }

      _updateRouterState();

      Logger.d('✅ 라우터 뒤로 가기 완료: $path');
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

      _goRouter.go(path, extra: arguments);
      _updateRouterState();

      Logger.d('✅ 라우터 교체 완료: $path');
    });
  }

  /// MaterialApp.router를 빌드하는 메서드
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
    return MaterialApp.router(
      title: title ?? 'Flutter App',
      theme: theme,
      darkTheme: darkTheme,
      themeMode: themeMode ?? ThemeMode.system,
      locale: locale,
      supportedLocales: supportedLocales ?? const [Locale('ko', 'KR')],
      localizationsDelegates: localizationsDelegates,
      debugShowCheckedModeBanner: debugShowCheckedModeBanner,
      routerConfig: _goRouter,
    );
  }

  /// 라우터 상태 업데이트
  void _updateRouterState() {
    final state = GRouterState(
      currentPath: currentPath,
      routeInformation: currentRouteInformation,
      canGoBack: _goRouter.canPop(),
      navigationStack: [], // go_router에서는 사용하지 않음
    );

    _routerStateController.add(state);
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

  @override
  Future<void> goNamed(String name, {GJson? arguments}) async {
    await guardFuture(() async {
      Logger.d('📤 라우터 이동: $name');

      _goRouter.goNamed(name, extra: arguments);
    });
  }
}
