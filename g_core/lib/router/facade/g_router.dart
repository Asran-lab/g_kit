import 'package:flutter/material.dart';
import 'package:g_common/g_common.dart';
import 'package:g_core/router/service/g_router_service.dart';
import 'package:g_core/router/service/g_router_impl.dart';
import 'package:g_core/router/common/g_router_config.dart';
import 'package:g_core/router/common/g_route_typedef.dart';

/// 라우터 Facade
/// 외부에서 사용하는 간단한 라우터 인터페이스
class GRouter {
  static GRouterService? _instance;

  /// 라우터 생성
  static GRouterService create({
    required List<GRouteConfig> routes,
    List<GShellRouteConfig>? shellRoutes,
    String? initialPath,
    GRouterErrorHandler? errorHandler,
    GRouterRedirectHandler? redirectHandler,
    bool debugLogging = false,
  }) {
    final config = GRouterConfig(
      routes: routes,
      shellRoutes: shellRoutes,
      initialPath: initialPath,
      errorHandler: errorHandler,
      redirectHandler: redirectHandler,
      debugLogging: debugLogging,
    );
    return GRouterImpl(config);
  }

  /// 싱글톤 라우터 생성
  static GRouterService createSingleton({
    required List<GRouteConfig> routes,
    List<GShellRouteConfig>? shellRoutes,
    String? initialPath,
    GRouterErrorHandler? errorHandler,
    GRouterRedirectHandler? redirectHandler,
    bool debugLogging = false,
  }) {
    _instance ??= create(
      routes: routes,
      shellRoutes: shellRoutes,
      initialPath: initialPath,
      errorHandler: errorHandler,
      redirectHandler: redirectHandler,
      debugLogging: debugLogging,
    );
    return _instance!;
  }

  /// 싱글톤 인스턴스 가져오기
  static GRouterService? get instance => _instance;

  /// 싱글톤 인스턴스 초기화
  static Future<void> initialize({
    required List<GRouteConfig> routes,
    List<GShellRouteConfig>? shellRoutes,
    String? initialPath,
    GRouterErrorHandler? errorHandler,
    GRouterRedirectHandler? redirectHandler,
    bool debugLogging = false,
  }) async {
    _instance = create(
      routes: routes,
      shellRoutes: shellRoutes,
      initialPath: initialPath,
      errorHandler: errorHandler,
      redirectHandler: redirectHandler,
      debugLogging: debugLogging,
    );
    await _instance!.initialize();
  }

  /// 싱글톤 인스턴스 정리
  static Future<void> dispose() async {
    await _instance?.dispose();
    _instance = null;
  }

  /// 일반 라우트 생성
  static GRouteConfig route({
    required String path,
    required String name,
    required Widget Function(BuildContext context, GJson? arguments) builder,
    GRouteGuard? guard,
    GRedirect? redirect,
    GRouteTransition? transition,
  }) {
    return GRouteConfig(
      path: path,
      name: name,
      builder: builder,
      guard: guard,
      redirect: redirect,
      transition: transition,
    );
  }

  /// 쉘 라우트 생성
  static GShellRouteConfig shellRoute({
    required String name,
    required Widget Function(BuildContext context, Widget child) builder,
    required List<GRouteConfig> children,
    GRedirect? redirect,
    GRouteGuard? guard,
  }) {
    return GShellRouteConfig(
      name: name,
      builder: builder,
      children: children,
      redirect: redirect,
      guard: guard,
    );
  }
}
