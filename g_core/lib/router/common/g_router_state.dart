import 'package:flutter/material.dart' show RouteInformation;

/// 라우터 상태
class GRouterState {
  final String currentPath;
  final RouteInformation? routeInformation;
  final bool canGoBack;
  final List<String> navigationStack;

  const GRouterState({
    required this.currentPath,
    this.routeInformation,
    required this.canGoBack,
    required this.navigationStack,
  });

  @override
  String toString() {
    return 'GRouterState(currentPath: $currentPath, canGoBack: $canGoBack, stackSize: ${navigationStack.length})';
  }
}
