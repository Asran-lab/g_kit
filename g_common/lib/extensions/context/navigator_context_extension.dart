import 'package:flutter/material.dart';
import 'package:g_common/utils/g_route_observer.dart';

extension NavigatorContextExtension on BuildContext {
  /// 현재 [NavigatorState]를 반환
  NavigatorState get navigator => Navigator.of(this);

  /// 현재 라우트 위에 새로운 라우트를 스택에 추가합니다
  /// 나중에 Navigator.pop() 하면 이전 페이지로 돌아올 수 있음.
  /// 예: context.push(MaterialPageRoute(builder: (_) => Page()));
  Future<T?> push<T extends Object?>(Route<T> route) =>
      navigator.push<T>(route);

  /// 이름 기반 라우트 푸시
  /// 예: context.pushNamed('/home')
  Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) =>
      navigator.pushNamed(routeName, arguments: arguments);

  /// 기존 라우트를 제거하고 새 라우트로 교체합니다.
  /// 뒤로가기를 하면 이전 라우트가 없기 때문에 앱이 종료될 수 있음 (또는 홈 등으로 복귀)
  /// 예: context.pushReplacement(MaterialPageRoute(builder: (_) => Page()))
  Future<T?> pushReplacement<T extends Object?, TO extends Object?>(
    Route<T> route, {
    TO? result,
  }) =>
      navigator.pushReplacement(route, result: result);

  /// 이름 기반으로 현재 라우트를 교체
  /// 예: context.pushReplacementNamed('/home')
  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) =>
      navigator.pushReplacementNamed(
        routeName,
        result: result,
        arguments: arguments,
      );

  /// 이름 기반으로 현재 라우트를 제거하고 새로운 라우트로 이동
  /// 예: context.pushNamedAndRemoveUntil('/home', (route) => false)
  Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
    String newRouteName,
    RoutePredicate predicate, {
    Object? arguments,
  }) =>
      navigator.pushNamedAndRemoveUntil(
        newRouteName,
        predicate,
        arguments: arguments,
      );

  /// [Route]를 푸시하고 조건까지 기존 라우트 제거
  /// 예: context.pushAndRemoveUntil(route, ModalRoute.withName('/home'))
  Future<T?> pushAndRemoveUntil<T extends Object?>(
    Route<T> newRoute,
    RoutePredicate predicate,
  ) =>
      navigator.pushAndRemoveUntil(newRoute, predicate);

  /// 가장 최근 라우트 제거 (뒤로 가기)
  void pop<T extends Object?>([T? result]) => navigator.pop(result);

  /// 뒤로 가기 - pop 불가능한 경우 무시
  void safePop() {
    if (navigator.canPop()) {
      navigator.pop();
    }
  }

  /// 조건에 따라 뒤로 가기
  Future<bool> maybePop<T extends Object?>([T? result]) =>
      navigator.maybePop(result);

  /// 현재 라우트를 제거하고 지정된 이름의 라우트를 푸시
  /// 예: context.popAndPushNamed('/login')
  Future<T?> popAndPushNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) =>
      navigator.popAndPushNamed(
        routeName,
        result: result,
        arguments: arguments,
      );

  /// 특정 조건까지 pop
  void popUntil(RoutePredicate predicate) => navigator.popUntil(predicate);

  /// 현재 라우터 이름 (route.settings.name)
  String? get currentPath => routeObserver.current?.settings.name;

  /// 이전 라우터 이름
  String? get previousPath => routeObserver.previous?.settings.name;

  /// 라우터 스택 전체 (읽기전용)
  List<String?> get routeStack => routeObserver.history
      .map((r) => r.settings.name)
      .where((name) => name != null)
      .toList();
}
