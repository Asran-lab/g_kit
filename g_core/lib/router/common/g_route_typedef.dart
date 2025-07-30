import 'package:flutter/material.dart';

typedef GRedirect = String? Function();
typedef GRouteGuard = bool Function();
typedef GRouteTransition = Widget Function(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
);

/// 라우터 에러 핸들러
typedef GRouterErrorHandler = Widget Function(
    BuildContext context, Object error);

/// 라우터 리다이렉트 핸들러
typedef GRouterRedirectHandler = String? Function(
    BuildContext context, String path);

/// 라우터 경로 타입
typedef GRoutePath = String;
