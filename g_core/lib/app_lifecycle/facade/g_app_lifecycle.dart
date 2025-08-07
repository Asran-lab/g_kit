import 'dart:async';

import 'package:flutter/material.dart';
import 'package:g_common/constants/g_typedef.dart';
import 'package:g_core/app_lifecycle/common/g_app_lifecycle_option.dart';
import 'package:g_core/app_lifecycle/common/g_app_lifecycle_state.dart';
import 'package:g_core/app_lifecycle/context/g_app_lifecycle_context.dart';

/// 앱 라이프사이클 Facade 클래스
/// 앱 라이프사이클 기능에 대한 간단한 인터페이스를 제공합니다.
class GAppLifecycle {
  static GAppLifecycleContext? _instance;
  static GAppLifecycleContext get instance {
    _instance ??= GAppLifecycleContext.instance;
    return _instance!;
  }

  /// 앱 라이프사이클 초기화
  static void initialize({GAppLifecycleOption? option}) {
    instance.initialize(option: option);
  }

  /// 앱 라이프사이클 해제
  static void dispose() {
    instance.dispose();
  }

  /// 리스너 추가
  static void addListener(GAppLifecycleCallback callback) {
    instance.addListener(callback);
  }

  /// 리스너 제거
  static void removeListener(GAppLifecycleCallback callback) {
    instance.removeListener(callback);
  }

  /// 현재 상태 스트림
  static Stream<GAppLifecycleState> get stateStream => instance.stateStream;

  /// 원시 상태 스트림
  static Stream<AppLifecycleState> get rawStateStream =>
      instance.rawStateStream;

  /// 현재 상태
  static AppLifecycleState? get currentState => instance.currentState;

  /// 상태가 포그라운드인지 확인
  static bool get isResumed => currentState == AppLifecycleState.resumed;

  /// 상태가 백그라운드인지 확인
  static bool get isPaused => currentState == AppLifecycleState.paused;

  /// 상태가 비활성인지 확인
  static bool get isInactive => currentState == AppLifecycleState.inactive;

  /// 상태가 분리된지 확인
  static bool get isDetached => currentState == AppLifecycleState.detached;

  /// 상태가 숨겨진지 확인 (Android 12+)
  static bool get isHidden => currentState == AppLifecycleState.hidden;

  /// 앱이 포그라운드에 있는지 확인
  static bool get isForeground => isResumed;

  /// 앱이 백그라운드에 있는지 확인
  static bool get isBackground =>
      isPaused || isInactive || isDetached || isHidden;
}
