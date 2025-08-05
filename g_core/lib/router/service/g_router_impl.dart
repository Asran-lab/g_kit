import 'dart:async';
import 'package:flutter/material.dart';
import 'package:g_common/g_common.dart';
import 'package:g_core/router/service/g_router_service.dart';
import 'package:g_core/router/common/g_router_config.dart';
import 'package:g_lib/g_lib.dart';

/// 라우터 서비스 구현체
/// go_router를 사용하여 라우터를 관리합니다.
class GRouterImpl implements GRouterService {
  late GoRouter _goRouter;
  final List<GRouteConfig> _configs = [];
  final List<GShellRouteConfig> _shellConfigs = [];
  GoRouter get goRouter => _goRouter;

  @override
  void initialize(
    List<GRouteConfig> configs, {
    List<GShellRouteConfig>? shellConfigs,
    String initialPath = '/splash',
  }) {
    _configs.clear();
    _configs.addAll(configs);

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
        builder: (context, state, child) => shellConfig.builder(context, child),
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
  }

  @override
  Future<void> go(String path, {GJson? arguments}) async => _goRouter.push(
        path,
        extra: arguments,
      );

  @override
  Future<void> goNamed(String name, {GJson? arguments}) async =>
      _goRouter.pushNamed(name, extra: arguments);

  @override
  Future<void> goUntil(String path, {GJson? arguments}) async =>
      _goRouter.pushReplacement(
        path,
        extra: arguments,
      );

  @override
  Future<void> goBack() async => _goRouter.pop();

  @override
  Future<bool> canGoBack() async => _goRouter.canPop();

  @override
  Future<void> replace(String path, {GJson? arguments}) async =>
      _goRouter.go(path, extra: arguments);

  @override
  Widget buildRouter({
    ThemeMode? themeMode,
    Brightness? brightness,
    ThemeData? lightTheme,
    ThemeData? darkTheme,
    Locale? locale,
    Iterable<Locale>? supportedLocales,
    Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
    bool? debugShowCheckedModeBanner,
  }) {
    return MaterialApp.router(
      routerConfig: _goRouter,
      debugShowCheckedModeBanner: debugShowCheckedModeBanner ?? true,

      // 테마 설정
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode ?? ThemeMode.system,

      // 로케일 설정
      locale: locale,
      supportedLocales: supportedLocales ?? const [Locale('ko', 'KR')],
      localizationsDelegates: localizationsDelegates,
    );
  }
}
