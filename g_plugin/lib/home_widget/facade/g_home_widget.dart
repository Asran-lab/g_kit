import 'package:flutter/material.dart';
import 'package:g_common/utils/g_logger.dart' show Logger;
import '../service/g_home_widget_service.dart';

/// HomeWidget Facade 클래스
///
/// HomeWidget 기능에 대한 단일 진입점을 제공합니다.
/// 서비스 구현체를 등록하고 정적 메서드를 통해 기능을 제공합니다.
class GHomeWidget {
  static GHomeWidgetService? _service;

  /// 서비스 등록
  static void registerService(GHomeWidgetService service) {
    _service = service;
    Logger.d('🏠 [GHomeWidget] 서비스 등록 완료');
  }

  /// 서비스 해제
  static void unregisterService() {
    _service = null;
    Logger.d('🏠 [GHomeWidget] 서비스 해제 완료');
  }

  /// 서비스 등록 여부 확인
  static bool get isServiceRegistered => _service != null;

  /// 서비스 인스턴스 반환
  static GHomeWidgetService get _serviceInstance {
    if (_service == null) {
      throw StateError(
          'GHomeWidget service is not registered. Call GHomeWidgetInitializer.initialize() first.');
    }
    return _service!;
  }

  /// 위젯 데이터 저장
  static Future<void> saveData(String key, String value) async {
    return await _serviceInstance.saveData(key, value);
  }

  /// 위젯 데이터 조회
  static Future<String?> getData(String key) async {
    return await _serviceInstance.getData(key);
  }

  /// 위젯 업데이트 요청
  static Future<void> requestUpdate() async {
    return await _serviceInstance.requestUpdate();
  }

  /// 위젯 상호작용 콜백 등록
  static Future<void> registerInteractivityCallback(
      Function(Uri?) callback) async {
    return await _serviceInstance.registerInteractivityCallback(callback);
  }

  /// 위젯 클릭 이벤트 스트림
  static Stream<Uri?> get widgetClicked => _serviceInstance.widgetClicked;

  /// 앱이 위젯에서 시작되었는지 확인
  static Future<Uri?> initiallyLaunchedFromHomeWidget() async {
    return await _serviceInstance.initiallyLaunchedFromHomeWidget();
  }

  /// 설치된 위젯 목록 조회
  static Future<List<HomeWidgetInfo>> getInstalledWidgets() async {
    return await _serviceInstance.getInstalledWidgets();
  }

  /// 위젯 핀 요청 지원 여부 확인
  static Future<bool?> isRequestPinWidgetSupported() async {
    return await _serviceInstance.isRequestPinWidgetSupported();
  }

  /// 위젯 핀 요청
  static Future<void> requestPinWidget({String? qualifiedAndroidName}) async {
    return await _serviceInstance.requestPinWidget(
      qualifiedAndroidName: qualifiedAndroidName,
    );
  }

  /// Flutter 위젯 렌더링
  static Future<void> renderFlutterWidget(
    Widget widget, {
    required Size logicalSize,
    required String key,
  }) async {
    return await _serviceInstance.renderFlutterWidget(
      widget,
      logicalSize: logicalSize,
      key: key,
    );
  }

  /// 편의 메서드: 노트 저장
  static Future<void> saveNote(String key, String text) async {
    return await saveData(key, text);
  }

  /// 편의 메서드: 노트 조회
  static Future<String?> getNote(String key) async {
    return await getData(key);
  }

  /// 편의 메서드: 여러 데이터 한번에 저장
  static Future<void> saveMultipleData(Map<String, String> data) async {
    final futures =
        data.entries.map((entry) => saveData(entry.key, entry.value));
    await Future.wait(futures);
  }

  /// 편의 메서드: 여러 데이터 한번에 조회
  static Future<Map<String, String?>> getMultipleData(List<String> keys) async {
    final futures = keys.map((key) => getData(key));
    final results = await Future.wait(futures);

    final Map<String, String?> data = {};
    for (int i = 0; i < keys.length; i++) {
      data[keys[i]] = results[i];
    }
    return data;
  }

  /// 편의 메서드: 데이터 저장 후 위젯 업데이트
  static Future<void> saveDataAndUpdate(String key, String value) async {
    await saveData(key, value);
    await requestUpdate();
  }

  /// 편의 메서드: 여러 데이터 저장 후 위젯 업데이트
  static Future<void> saveMultipleDataAndUpdate(
      Map<String, String> data) async {
    await saveMultipleData(data);
    await requestUpdate();
  }
}
