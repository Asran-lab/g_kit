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

  /// 라우트 이름과 인덱스 매핑 (선택적)
  final Map<String, int>? routeNameToIndex;

  /// 인덱스와 라우트 경로 매핑 (선택적)
  final Map<int, String>? indexToRoutePath;

  GShellRouteConfig({
    required this.name,
    this.builder,
    this.pageBuilder,
    required this.children,
    this.redirect,
    this.guard,
    this.routeNameToIndex,
    this.indexToRoutePath,
  }) : assert(builder != null || pageBuilder != null,
            'Either builder or pageBuilder must be provided');

  /// 자동으로 매핑을 생성하는 getter
  Map<String, int> get autoRouteNameToIndex {
    if (routeNameToIndex != null) return routeNameToIndex!;

    final mapping = <String, int>{};
    for (int i = 0; i < children.length; i++) {
      mapping[children[i].name] = i;
    }
    return mapping;
  }

  Map<int, String> get autoIndexToRoutePath {
    if (indexToRoutePath != null) return indexToRoutePath!;

    final mapping = <int, String>{};
    for (int i = 0; i < children.length; i++) {
      mapping[i] = '/${children[i].path}';
    }
    return mapping;
  }
}
