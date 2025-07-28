import 'package:flutter/material.dart';

class GRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  static final List<Route<dynamic>> _history = [];

  List<Route<dynamic>> get history => List.unmodifiable(_history);

  Route<dynamic>? get current => _history.isNotEmpty ? _history.last : null;

  Route<dynamic>? get previous =>
      _history.length > 1 ? _history[_history.length - 2] : null;

  @override
  void didPush(Route route, Route? previousRoute) {
    _history.add(route);
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    _history.remove(route);
    super.didPop(route, previousRoute);
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    _history.remove(route);
    super.didRemove(route, previousRoute);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    final index = _history.indexOf(oldRoute!);
    if (index != -1) _history[index] = newRoute!;
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }
}

final GRouteObserver routeObserver = GRouteObserver();
