import 'dart:io';
import 'package:flutter/services.dart';
import 'package:workmanager/workmanager.dart';
import 'package:g_common/utils/g_guard.dart' show guardFuture;
import 'package:g_common/utils/g_logger.dart' show Logger;
import 'package:g_model/initializer/g_initializer.dart';
import 'service/g_home_widget_service.dart';
import 'service/g_home_widget_impl.dart';
import 'facade/g_home_widget.dart';
import 'package:g_lib/g_lib_plugin.dart';

/// HomeWidget 초기화 클래스
///
/// GInitializer를 상속하여 플러그인 초기화 시스템과 통합됩니다.
/// WorkManager를 사용한 백그라운드 업데이트 기능을 포함합니다.
/// 사용 예시
/// ```dart
/// final homeWidgetInitializer = GHomeWidgetInitializer(
///   appGroupId: 'group.mome.app',
///   iOSWidgetKind: 'Mome',
///   androidProviderSimpleName: 'StickyNoteWidgetProvider',
/// );
/// ```
class GHomeWidgetInitializer extends GInitializer {
  GHomeWidgetService? _service;
  bool _isInitialized = false;
  final String appGroupId;
  final String iOSWidgetKind;
  final String androidProviderSimpleName;
  final bool enableBackgroundUpdates;

  GHomeWidgetInitializer({
    required this.appGroupId,
    required this.iOSWidgetKind,
    required this.androidProviderSimpleName,
    this.enableBackgroundUpdates = true,
  });

  @override
  String get name => 'home_widget';

  @override
  Future<void> initialize() async {
    if (_isInitialized) return;

    await guardFuture<void>(() async {
      _service = GHomeWidgetImpl(
        appGroupId: appGroupId,
        iOSWidgetKind: iOSWidgetKind,
        androidProviderSimpleName: androidProviderSimpleName,
      );

      await _service!.initialize();

      // Facade에 서비스 등록
      GHomeWidget.registerService(_service!);

      // WorkManager 초기화 (Android에서 백그라운드 업데이트용)
      if (Platform.isAndroid && enableBackgroundUpdates) {
        await _initializeWorkManager();
      }

      _isInitialized = true;
      Logger.d('🏠 GHomeWidgetInitializer 초기화 및 Facade 등록 완료');
    }, typeHandlers: {
      PlatformException: (e, s) {
        Logger.e('GHomeWidgetInitializer initialize failed', error: e);
        throw e;
      },
    });
  }

  /// WorkManager 초기화 (Android 백그라운드 업데이트용)
  Future<void> _initializeWorkManager() async {
    try {
      await Workmanager().initialize(
        _callbackDispatcher,
      );
      Logger.d('🏠 WorkManager 초기화 완료');
    } catch (e) {
      Logger.w('🏠 WorkManager 초기화 실패 (무시): $e');
    }
  }

  /// 백그라운드 업데이트 시작
  Future<void> startBackgroundUpdates(
      {Duration frequency = const Duration(minutes: 15)}) async {
    if (!_isInitialized) {
      throw StateError(
          'GHomeWidgetInitializer is not initialized. Call initialize() first.');
    }

    if (Platform.isAndroid && enableBackgroundUpdates) {
      try {
        await Workmanager().registerPeriodicTask(
          'home_widget_update',
          'homeWidgetBackgroundUpdate',
          frequency: frequency,
        );
        Logger.d('🏠 백그라운드 업데이트 시작: ${frequency.inMinutes}분 간격');
      } catch (e) {
        Logger.e('🏠 백그라운드 업데이트 시작 실패: $e');
      }
    }
  }

  /// 백그라운드 업데이트 중지
  Future<void> stopBackgroundUpdates() async {
    if (Platform.isAndroid && enableBackgroundUpdates) {
      try {
        await Workmanager().cancelByUniqueName('home_widget_update');
        Logger.d('🏠 백그라운드 업데이트 중지');
      } catch (e) {
        Logger.e('🏠 백그라운드 업데이트 중지 실패: $e');
      }
    }
  }

  GHomeWidgetService get service {
    if (!_isInitialized) {
      throw StateError(
          'GHomeWidgetInitializer is not initialized. Call initialize() first.');
    }
    return _service!;
  }

  bool get isInitialized => _isInitialized;

  Future<void> dispose() async {
    if (_service != null) {
      // 백그라운드 업데이트 중지
      await stopBackgroundUpdates();

      // Facade에서 서비스 해제
      GHomeWidget.unregisterService();

      await _service!.dispose();
      _service = null;
    }

    _isInitialized = false;
    Logger.d('🏠 GHomeWidgetInitializer 정리 완료');
  }
}

/// WorkManager 콜백 디스패처 (Android 백그라운드 업데이트용)
@pragma("vm:entry-point")
void _callbackDispatcher() async {
  Workmanager().executeTask((taskName, inputData) async {
    if (taskName == 'homeWidgetBackgroundUpdate') {
      try {
        // 백그라운드에서 위젯 데이터 업데이트
        final now = DateTime.now();
        await Future.wait([
          GHomeWidget.saveData('last_updated', now.toIso8601String()),
          GHomeWidget.saveData('background_update', 'true'),
        ]);

        // 위젯 업데이트 요청
        await GHomeWidget.requestUpdate();

        Logger.d('🏠 백그라운드 위젯 업데이트 완료: $now');
        return true;
      } catch (e) {
        Logger.e('🏠 백그라운드 위젯 업데이트 실패: $e');
        return false;
      }
    }
    return false;
  });
}
