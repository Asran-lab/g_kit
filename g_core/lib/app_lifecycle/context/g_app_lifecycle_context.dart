import 'dart:async';

import 'package:flutter/material.dart';
import 'package:g_common/constants/g_typedef.dart';
import 'package:g_common/utils/g_logger.dart';
import 'package:g_core/app_lifecycle/common/g_app_lifecycle_option.dart';
import 'package:g_core/app_lifecycle/common/g_app_lifecycle_state.dart';
import 'package:g_core/app_lifecycle/service/g_app_lifecycle_service.dart';

/// 앱 라이프사이클 컨텍스트
/// 앱 라이프사이클 상태를 관리하고 리스너들에게 알림을 제공합니다.
class GAppLifecycleContext with WidgetsBindingObserver {
  GAppLifecycleContext._();

  static GAppLifecycleContext? _instance;
  static GAppLifecycleContext get instance {
    _instance ??= GAppLifecycleContext._();
    return _instance!;
  }

  final List<GAppLifecycleCallback> _listeners = [];
  final StreamController<GAppLifecycleState> _stateController =
      StreamController<GAppLifecycleState>.broadcast();
  final StreamController<AppLifecycleState> _rawStateController =
      StreamController<AppLifecycleState>.broadcast();

  GAppLifecycleService? _service;
  GAppLifecycleOption? _option;
  bool _initialized = false;
  AppLifecycleState? _previousState;

  /// 초기화
  void initialize({GAppLifecycleOption? option}) {
    if (_initialized) return;

    _option = option ?? const GAppLifecycleOption();
    _service = GAppLifecycleService();

    if (_option!.autoInitialize) {
      WidgetsBinding.instance.addObserver(this);
    }

    _initialized = true;

    if (_option!.debug) {
      Logger.d('[GAppLifecycleContext] Initialized with option: $_option');
    }
  }

  /// 해제
  void dispose() {
    if (!_initialized) return;

    WidgetsBinding.instance.removeObserver(this);
    _listeners.clear();

    if (!_stateController.isClosed) {
      _stateController.close();
    }

    if (!_rawStateController.isClosed) {
      _rawStateController.close();
    }

    _initialized = false;
    _previousState = null;

    if (_option?.debug == true) {
      Logger.d('[GAppLifecycleContext] Disposed');
    }
  }

  /// 리스너 추가
  void addListener(GAppLifecycleCallback callback) {
    if (!_listeners.contains(callback)) {
      _listeners.add(callback);
    }
  }

  /// 리스너 제거
  void removeListener(GAppLifecycleCallback callback) {
    _listeners.remove(callback);
  }

  /// 현재 상태 스트림
  Stream<GAppLifecycleState> get stateStream => _stateController.stream;

  /// 원시 상태 스트림
  Stream<AppLifecycleState> get rawStateStream => _rawStateController.stream;

  /// 현재 상태
  AppLifecycleState? get currentState => _previousState;

  /// 라이프사이클 상태 변경 감지
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final now = DateTime.now();
    final lifecycleState = GAppLifecycleState(
      currentState: state,
      previousState: _previousState,
      timestamp: now,
    );

    // 리스너들에게 알림
    for (final listener in _listeners) {
      listener(state);
    }

    // 스트림에 상태 전송
    if (!_stateController.isClosed) {
      _stateController.add(lifecycleState);
    }

    if (!_rawStateController.isClosed) {
      _rawStateController.add(state);
    }

    // 서비스에 상태 변경 알림
    _service?.onStateChanged(lifecycleState);

    _previousState = state;

    if (_option?.debug == true) {
      Logger.d('[GAppLifecycleContext] State changed: $state');
    }
  }

  /// 서비스 가져오기
  GAppLifecycleService? get service => _service;
}
