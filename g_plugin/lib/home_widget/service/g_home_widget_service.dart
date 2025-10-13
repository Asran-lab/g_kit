import 'package:flutter/material.dart';

/// HomeWidget 서비스 인터페이스
///
/// HomeWidget 기능을 위한 추상 인터페이스입니다.
/// 플랫폼별 구현체는 GHomeWidgetImpl에서 제공됩니다.
abstract class GHomeWidgetService {
  /// 서비스 초기화
  Future<void> initialize();

  /// 위젯 데이터 저장
  Future<void> saveData(String key, String value);

  /// 위젯 데이터 조회
  Future<String?> getData(String key);

  /// 위젯 업데이트 요청
  Future<void> requestUpdate();

  /// 위젯 상호작용 콜백 등록
  Future<void> registerInteractivityCallback(Function(Uri?) callback);

  /// 위젯 클릭 이벤트 스트림
  Stream<Uri?> get widgetClicked;

  /// 앱이 위젯에서 시작되었는지 확인
  Future<Uri?> initiallyLaunchedFromHomeWidget();

  /// 설치된 위젯 목록 조회
  Future<List<HomeWidgetInfo>> getInstalledWidgets();

  /// 위젯 핀 요청 지원 여부 확인
  Future<bool?> isRequestPinWidgetSupported();

  /// 위젯 핀 요청
  Future<void> requestPinWidget({String? qualifiedAndroidName});

  /// Flutter 위젯 렌더링
  Future<void> renderFlutterWidget(
    Widget widget, {
    required Size logicalSize,
    required String key,
  });

  /// 서비스 정리
  Future<void> dispose();
}

/// 위젯 정보 클래스
class HomeWidgetInfo {
  final String? iOSFamily;
  final String? iOSKind;
  final int? androidWidgetId;
  final String? androidClassName;
  final String? androidLabel;

  HomeWidgetInfo({
    this.iOSFamily,
    this.iOSKind,
    this.androidWidgetId,
    this.androidClassName,
    this.androidLabel,
  });

  @override
  String toString() {
    return 'HomeWidgetInfo(iOSFamily: $iOSFamily, iOSKind: $iOSKind, '
        'androidWidgetId: $androidWidgetId, androidClassName: $androidClassName, '
        'androidLabel: $androidLabel)';
  }
}
