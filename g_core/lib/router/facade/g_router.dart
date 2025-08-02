import 'package:flutter/material.dart';
import 'package:g_common/g_common.dart';
import 'package:g_core/router/common/g_router_config.dart';
import 'package:g_core/router/service/g_router_service.dart';
import 'package:g_core/router/service/g_router_impl.dart';

/// GRouter Facade 클래스
/// 라우터 기능을 통합하여 제공하는 static 인터페이스
class GRouter {
  static GRouterService? _instance;

  /// Router 인스턴스 반환
  static GRouterService get instance {
    if (_instance == null) {
      throw Exception('GRouter가 초기화되지 않았습니다. GRouter.initialize()를 먼저 호출하세요.');
    }
    return _instance!;
  }

  /// Router 초기화 여부 확인
  static bool get isInitialized => _instance != null;

  /// Router 초기화
  ///
  /// [configs] - 라우트 설정 목록
  /// [shellConfigs] - 쉘 라우트 설정 목록 (선택사항)
  /// [initialPath] - 초기 경로 (기본값: '/')
  static Future<void> initialize(
    List<GRouteConfig> configs, {
    List<GShellRouteConfig>? shellConfigs,
    String initialPath = '/',
  }) async {
    _instance = GRouterImpl();
    await _instance!.initialize(
      configs,
      shellConfigs: shellConfigs,
      initialPath: initialPath,
    );
  }

  /// 지정된 경로로 이동 (push)
  ///
  /// [path] - 이동할 경로
  /// [arguments] - 전달할 인수
  static Future<void> go(String path, {GJson? arguments}) async {
    await instance.go(path, arguments: arguments);
  }

  /// 이름으로 지정된 라우트로 이동
  ///
  /// [name] - 라우트 이름
  /// [arguments] - 전달할 인수
  static Future<void> goNamed(String name, {GJson? arguments}) async {
    await instance.goNamed(name, arguments: arguments);
  }

  /// 현재 경로를 새 경로로 교체
  ///
  /// [path] - 이동할 경로
  /// [arguments] - 전달할 인수
  static Future<void> replace(String path, {GJson? arguments}) async {
    await instance.replace(path, arguments: arguments);
  }

  /// 지정된 경로로 이동하고 이전 스택 제거
  ///
  /// [path] - 이동할 경로
  /// [arguments] - 전달할 인수
  static Future<void> goUntil(String path, {GJson? arguments}) async {
    await instance.goUntil(path, arguments: arguments);
  }

  /// 이전 화면으로 돌아가기
  static Future<void> goBack() async {
    await instance.goBack();
  }

  /// 특정 경로까지 뒤로 가기
  ///
  /// [path] - 돌아갈 경로
  static Future<void> goBackUntil(String path) async {
    await instance.goBackUntil(path);
  }

  /// 뒤로 갈 수 있는지 확인
  static Future<bool> canGoBack() async {
    return await instance.canGoBack();
  }

  /// RouterConfig 반환
  /// 
  /// MaterialApp.router(routerConfig: GRouter.config) 형태로 사용
  static RouterConfig<Object?> get config => instance.routerConfig;

  /// 현재 경로 반환
  static String get currentPath => instance.currentPath;

  /// 현재 라우트 정보 반환
  static RouteInformation? get currentRouteInformation => instance.currentRouteInformation;

  /// 라우터 초기화 여부 확인
  static bool get initialized => instance.isInitialized;

  /// Router 인스턴스 재설정 (테스트용)
  static void reset() {
    _instance = null;
  }

  /// Router 정리
  static Future<void> dispose() async {
    if (_instance != null) {
      await _instance!.dispose();
      _instance = null;
    }
  }
}