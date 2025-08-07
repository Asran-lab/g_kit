import 'package:flutter/material.dart';

/// 앱 라이프사이클 상태 관리
class GAppLifecycleState {
  /// 현재 앱 상태
  final AppLifecycleState currentState;

  /// 이전 앱 상태
  final AppLifecycleState? previousState;

  /// 상태 변경 시간
  final DateTime timestamp;

  const GAppLifecycleState({
    required this.currentState,
    this.previousState,
    required this.timestamp,
  });

  /// 상태가 포그라운드인지 확인
  bool get isResumed => currentState == AppLifecycleState.resumed;

  /// 상태가 백그라운드인지 확인
  bool get isPaused => currentState == AppLifecycleState.paused;

  /// 상태가 비활성인지 확인
  bool get isInactive => currentState == AppLifecycleState.inactive;

  /// 상태가 분리된지 확인
  bool get isDetached => currentState == AppLifecycleState.detached;

  /// 상태가 포그라운드로 전환되었는지 확인
  bool get isResumedFromBackground =>
      currentState == AppLifecycleState.resumed &&
      previousState == AppLifecycleState.paused;

  /// 상태가 백그라운드로 전환되었는지 확인
  bool get isPausedFromForeground =>
      currentState == AppLifecycleState.paused &&
      previousState == AppLifecycleState.resumed;

  GAppLifecycleState copyWith({
    AppLifecycleState? currentState,
    AppLifecycleState? previousState,
    DateTime? timestamp,
  }) {
    return GAppLifecycleState(
      currentState: currentState ?? this.currentState,
      previousState: previousState ?? this.previousState,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  String toString() {
    return 'GAppLifecycleState(currentState: $currentState, previousState: $previousState, timestamp: $timestamp)';
  }
}
