import 'package:flutter/material.dart';
import 'package:g_core/app_lifecycle/common/g_app_lifecycle_state.dart';

/// 앱 라이프사이클 서비스
/// 앱 라이프사이클 상태 변경에 따른 비즈니스 로직을 처리합니다.
class GAppLifecycleService {
  GAppLifecycleService();

  /// 상태 변경 시 호출되는 메서드
  void onStateChanged(GAppLifecycleState state) {
    // 여기에 상태 변경 시 필요한 비즈니스 로직을 구현합니다.
    // 예: 백그라운드 전환 시 데이터 저장, 포그라운드 복귀 시 데이터 동기화 등

    switch (state.currentState) {
      case AppLifecycleState.resumed:
        _onResumed(state);
        break;
      case AppLifecycleState.paused:
        _onPaused(state);
        break;
      case AppLifecycleState.inactive:
        _onInactive(state);
        break;
      case AppLifecycleState.detached:
        _onDetached(state);
        break;
      case AppLifecycleState.hidden:
        _onHidden(state);
        break;
    }
  }

  /// 앱이 포그라운드로 복귀했을 때
  void _onResumed(GAppLifecycleState state) {
    // 포그라운드 복귀 시 필요한 로직
    // 예: 데이터 동기화, 알림 처리 등
  }

  /// 앱이 백그라운드로 전환되었을 때
  void _onPaused(GAppLifecycleState state) {
    // 백그라운드 전환 시 필요한 로직
    // 예: 데이터 저장, 리소스 정리 등
  }

  /// 앱이 비활성 상태가 되었을 때
  void _onInactive(GAppLifecycleState state) {
    // 비활성 상태 시 필요한 로직
    // 예: 임시 데이터 저장 등
  }

  /// 앱이 분리되었을 때
  void _onDetached(GAppLifecycleState state) {
    // 앱 분리 시 필요한 로직
    // 예: 중요한 데이터 저장, 리소스 해제 등
  }

  /// 앱이 숨겨졌을 때 (Android 12+)
  void _onHidden(GAppLifecycleState state) {
    // 앱 숨김 시 필요한 로직
    // 예: 백그라운드 작업 중단 등
  }

  /// 서비스 해제
  void dispose() {
    // 서비스 해제 시 필요한 정리 작업
  }
}
