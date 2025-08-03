import 'package:flutter/material.dart';
import 'package:g_common/g_common.dart';
import 'package:g_core/router/common/g_router_config.dart';
import 'package:g_core/router/common/g_router_state.dart' show GRouterState;

/// 라우터 서비스 인터페이스
/// Flutter의 표준 RouterConfig를 사용하여 라우터를 관리합니다.
abstract class GRouterService {
  /// RouterConfig 반환
  /// MaterialApp.router의 routerConfig에 등록할 수 있습니다.
  RouterConfig<Object>? get routerConfig;

  /// 라우터 초기화
  /// 앱 시작 시 한 번만 호출됩니다.
  Future<void> initialize(
    List<GRouteConfig>? configs, {
    List<GShellRouteConfig>? shellConfigs,
    String initialPath = '/',
  });

  /// 라우터 정리
  /// 앱 종료 시 호출됩니다.
  Future<void> dispose();

  /// 현재 라우터 상태 확인
  bool get isInitialized;

  /// 현재 경로 가져오기
  String get currentPath;

  /// 현재 라우터 정보 가져오기
  RouteInformation? get currentRouteInformation;

  // 네비게이션 메서드들

  /// 현재 페이지를 새로운 페이지로 교체 (뒤로 가기 불가능)
  /// 로그인 후 메인 페이지로 이동할 때 사용
  Future<void> replace(String path, {GJson? arguments});

  /// 새 페이지를 스택에 추가 (뒤로 가기 가능)
  /// 상세 페이지로 이동할 때 사용
  Future<void> go(String path, {GJson? arguments});

  /// 네임드 라우트로 이동
  Future<void> goNamed(String name, {GJson? arguments});

  /// 이전 페이지로 돌아가기 (go로 이동한 경우에만)
  Future<void> goBack();

  /// 뒤로 갈 수 있는지 확인
  Future<bool> canGoBack();

  /// 특정 경로까지 뒤로 가기
  Future<void> goBackUntil(String path);

  /// 스택을 특정 경로로 교체
  Future<void> goUntil(String path, {GJson? arguments});

  /// 라우터 상태 변경 스트림
  Stream<GRouterState> get routerStateStream;
}
