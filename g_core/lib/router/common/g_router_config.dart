import 'package:flutter/material.dart';
import 'package:g_lib/g_lib_router.dart';
import 'package:g_common/constants/g_typedef.dart';
import 'package:g_core/router/common/g_route_typedef.dart';

/// 라우터 설정 옵션 (기존 구조 활용)
class GRouterConfig {
  final List<GRouteConfig> routes;
  final List<GShellRouteConfig>? shellRoutes;
  final String? initialPath;
  final GRouterErrorHandler? errorHandler;
  final GRouterRedirectHandler? redirectHandler;
  final bool debugLogging;

  const GRouterConfig({
    required this.routes,
    this.shellRoutes,
    this.initialPath,
    this.errorHandler,
    this.redirectHandler,
    this.debugLogging = false,
  });
}

/// 라우터 컨피그 > 라우트 생성하는 컨피그
class GRouteConfig {
  final String path;
  final String name;
  final Widget Function(BuildContext, GJson?) builder;
  final bool Function()? guard;
  final GRedirect? redirect;
  final GRouteTransition? transition;

  GRouteConfig({
    required this.path,
    required this.name,
    required this.builder,
    this.guard,
    this.redirect,
    this.transition,
  });
}

/// 쉘 라우트 전용 컨피그
class GShellRouteConfig {
  final String name;
  final Widget Function(
    BuildContext,
    Widget, {
    int? selectedIndex,
  })? builder;
  final Page Function(
    BuildContext,
    GoRouterState,
    Widget, {
    int? selectedIndex,
  })? pageBuilder;
  final List<GRouteConfig> children;
  final GRedirect? redirect;
  final GRouteGuard? guard;

  GShellRouteConfig({
    required this.name,
    this.builder,
    this.pageBuilder,
    required this.children,
    this.redirect,
    this.guard,
  }) : assert(builder != null || pageBuilder != null,
            'Either builder or pageBuilder must be provided');
}
