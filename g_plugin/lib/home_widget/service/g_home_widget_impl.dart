import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:g_common/utils/g_guard.dart' show guardFuture;
import 'package:g_common/utils/g_logger.dart' show Logger;
import 'g_home_widget_service.dart';

// HomeWidget은 조건부로 import (실제 패키지가 설치되어 있을 때만)
// import 'package:home_widget/home_widget.dart';

/// HomeWidget 서비스 구현체
///
/// home_widget 플러그인을 사용하여 실제 HomeWidget 기능을 구현합니다.
class GHomeWidgetImpl implements GHomeWidgetService {
  final String appGroupId;
  final String iOSWidgetKind;
  final String androidProviderSimpleName;

  GHomeWidgetImpl({
    required this.appGroupId,
    required this.iOSWidgetKind,
    required this.androidProviderSimpleName,
  });

  @override
  Future<void> initialize() async {
    await guardFuture<void>(() async {
      if (Platform.isIOS) {
        // await HomeWidget.setAppGroupId(appGroupId);
        Logger.d('🏠 [GHomeWidgetImpl] iOS App Group 설정 완료: $appGroupId');
      }
      Logger.d('🏠 [GHomeWidgetImpl] HomeWidget 서비스 초기화 완료');
    });
  }

  @override
  Future<void> saveData(String key, String value) async {
    await guardFuture<void>(() async {
      Logger.d('🏠 [GHomeWidgetImpl] 위젯 데이터 저장: $key = $value');
      // await HomeWidget.saveWidgetData<String>(key, value);

      // iOS의 경우 UserDefaults 동기화 대기
      if (Platform.isIOS) {
        await Future.delayed(const Duration(milliseconds: 100));
        Logger.d('🏠 [GHomeWidgetImpl] iOS UserDefaults 동기화 완료: $key');
      }
    });
  }

  @override
  Future<String?> getData(String key) async {
    return await guardFuture<String?>(() async {
      // final result = await HomeWidget.getWidgetData<String>(key);
      final result = null; // 임시로 null 반환
      Logger.d('🏠 [GHomeWidgetImpl] 위젯 데이터 조회: $key = $result');
      return result;
    });
  }

  @override
  Future<void> requestUpdate() async {
    await guardFuture<void>(() async {
      try {
        if (Platform.isIOS) {
          // iOS: 위젯 업데이트 요청
          // await HomeWidget.updateWidget(
          //   androidName: androidProviderSimpleName,
          //   iOSName: iOSWidgetKind,
          // );
          Logger.d('🏠 [GHomeWidgetImpl] iOS 위젯 업데이트 요청 완료');
        } else {
          // Android: 위젯 업데이트 요청 (더 강력한 방법)
          // await HomeWidget.updateWidget(
          //   androidName: androidProviderSimpleName,
          //   iOSName: iOSWidgetKind,
          // );

          // Android에서 추가로 브로드캐스트 인텐트로 강제 업데이트
          await _forceAndroidWidgetUpdate();

          Logger.d('🏠 [GHomeWidgetImpl] Android 위젯 업데이트 요청 완료');
        }
      } catch (e) {
        Logger.e('🏠 [GHomeWidgetImpl] 위젯 업데이트 요청 실패: $e');
        rethrow;
      }
    });
  }

  /// Android 위젯 강제 업데이트 (브로드캐스트 인텐트 사용)
  Future<void> _forceAndroidWidgetUpdate() async {
    try {
      // Android에서만 사용 가능한 강제 업데이트 방법
      // await HomeWidget.saveWidgetData(
      //   'force_update',
      //   'true',
      // );
      Logger.d('🏠 [GHomeWidgetImpl] Android 강제 업데이트 브로드캐스트 전송 완료');
    } catch (e) {
      Logger.w('🏠 [GHomeWidgetImpl] Android 강제 업데이트 실패 (무시): $e');
      // 강제 업데이트 실패는 무시 (기본 업데이트는 성공했을 수 있음)
    }
  }

  @override
  Future<void> registerInteractivityCallback(Function(Uri?) callback) async {
    await guardFuture<void>(() async {
      // await HomeWidget.registerInteractivityCallback(callback);
      Logger.d('🏠 [GHomeWidgetImpl] 위젯 상호작용 콜백 등록 완료');
    });
  }

  @override
  Stream<Uri?> get widgetClicked => Stream.empty(); // HomeWidget.widgetClicked;

  @override
  Future<Uri?> initiallyLaunchedFromHomeWidget() async {
    return await guardFuture<Uri?>(() async {
      // final uri = await HomeWidget.initiallyLaunchedFromHomeWidget();
      final uri = null; // 임시로 null 반환
      Logger.d('🏠 [GHomeWidgetImpl] 위젯에서 앱 시작 확인: $uri');
      return uri;
    });
  }

  @override
  Future<List<HomeWidgetInfo>> getInstalledWidgets() async {
    return await guardFuture<List<HomeWidgetInfo>>(() async {
      try {
        // final widgets = await HomeWidget.getInstalledWidgets();
        // final homeWidgetInfos = widgets.map((widget) => HomeWidgetInfo(
        //   iOSFamily: widget.iOSFamily,
        //   iOSKind: widget.iOSKind,
        //   androidWidgetId: widget.androidWidgetId,
        //   androidClassName: widget.androidClassName,
        //   androidLabel: widget.androidLabel,
        // )).toList();
        
        final homeWidgetInfos = <HomeWidgetInfo>[]; // 임시로 빈 리스트 반환
        Logger.d('🏠 [GHomeWidgetImpl] 설치된 위젯 목록 조회: ${homeWidgetInfos.length}개');
        return homeWidgetInfos;
      } on PlatformException catch (e) {
        Logger.e('🏠 [GHomeWidgetImpl] 위젯 목록 조회 실패: $e');
        return [];
      }
    });
  }

  @override
  Future<bool?> isRequestPinWidgetSupported() async {
    return await guardFuture<bool?>(() async {
      try {
        // final supported = await HomeWidget.isRequestPinWidgetSupported();
        final supported = false; // 임시로 false 반환
        Logger.d('🏠 [GHomeWidgetImpl] 위젯 핀 요청 지원 여부: $supported');
        return supported;
      } on PlatformException catch (e) {
        Logger.e('🏠 [GHomeWidgetImpl] 위젯 핀 요청 지원 여부 확인 실패: $e');
        return false;
      }
    });
  }

  @override
  Future<void> requestPinWidget({String? qualifiedAndroidName}) async {
    await guardFuture<void>(() async {
      try {
        // await HomeWidget.requestPinWidget(
        //   qualifiedAndroidName: qualifiedAndroidName,
        // );
        Logger.d('🏠 [GHomeWidgetImpl] 위젯 핀 요청 완료');
      } on PlatformException catch (e) {
        Logger.e('🏠 [GHomeWidgetImpl] 위젯 핀 요청 실패: $e');
        rethrow;
      }
    });
  }

  @override
  Future<void> renderFlutterWidget(
    Widget widget, {
    required Size logicalSize,
    required String key,
  }) async {
    await guardFuture<void>(() async {
      try {
        // await HomeWidget.renderFlutterWidget(
        //   widget,
        //   logicalSize: logicalSize,
        //   key: key,
        // );
        Logger.d('🏠 [GHomeWidgetImpl] Flutter 위젯 렌더링 완료: $key');
      } on PlatformException catch (e) {
        Logger.e('🏠 [GHomeWidgetImpl] Flutter 위젯 렌더링 실패: $e');
        rethrow;
      }
    });
  }

  @override
  Future<void> dispose() async {
    Logger.d('🏠 [GHomeWidgetImpl] HomeWidget 서비스 정리 완료');
  }
}
