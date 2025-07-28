import '../g_permission_initializer.dart';
import '../service/g_permission_service.dart';
import '../models/permission_type.dart';
import '../models/permission_status.dart';
import '../models/permission_request.dart';
import '../models/permission_result.dart';

/// 권한 모듈의 Facade 클래스
///
/// 권한 기능을 쉽게 사용할 수 있도록 정적 메서드를 제공합니다.
///
/// ## 사용 예제
///
/// ```dart
/// // 기본 초기화
/// await GPermission.initialize();
///
/// // 권한 상태 확인
/// final status = await GPermission.checkPermission(PermissionType.camera);
///
/// // 권한 요청
/// final result = await GPermission.requestPermission(
///   PermissionRequest.basic(PermissionType.camera),
/// );
///
/// // 다중 권한 요청
/// final results = await GPermission.requestMultiplePermissions([
///   PermissionRequest.basic(PermissionType.camera),
///   PermissionRequest.basic(PermissionType.microphone),
/// ]);
/// ```
class GPermission {
  static final GPermissionInitializer _initializer = GPermissionInitializer();

  /// 초기화 상태 확인
  static bool get isInitialized => _initializer.isInitialized;

  /// 권한 초기화
  ///
  /// 앱 시작 시 한 번만 호출해야 합니다.
  static Future<void> initialize() async {
    await _initializer.initialize();
  }

  /// 서비스 정리
  ///
  /// 앱 종료 시 호출하여 리소스를 정리합니다.
  static Future<void> dispose() async {
    await _initializer.dispose();
  }

  /// 단일 권한 상태 확인
  ///
  /// [type] - 확인할 권한 타입
  ///
  /// 특정 권한의 현재 상태를 확인합니다.
  static Future<PermissionStatus> checkPermission(PermissionType type) async {
    return await _initializer.service.checkPermission(type);
  }

  /// 다중 권한 상태 확인
  ///
  /// [types] - 확인할 권한 타입 목록
  ///
  /// 여러 권한의 현재 상태를 한 번에 확인합니다.
  static Future<Map<PermissionType, PermissionStatus>> checkMultiplePermissions(
      List<PermissionType> types) async {
    return await _initializer.service.checkMultiplePermissions(types);
  }

  /// 단일 권한 요청
  ///
  /// [request] - 권한 요청 정보
  ///
  /// 사용자에게 권한을 요청합니다.
  static Future<PermissionResult> requestPermission(
      PermissionRequest request) async {
    return await _initializer.service.requestPermission(request);
  }

  /// 다중 권한 요청
  ///
  /// [requests] - 권한 요청 정보 목록
  ///
  /// 사용자에게 여러 권한을 요청합니다.
  static Future<Map<PermissionType, PermissionResult>>
      requestMultiplePermissions(List<PermissionRequest> requests) async {
    return await _initializer.service.requestMultiplePermissions(requests);
  }

  /// 권한 허용 여부 확인
  ///
  /// [type] - 확인할 권한 타입
  ///
  /// 권한이 허용되었는지 확인합니다.
  static Future<bool> isPermissionGranted(PermissionType type) async {
    return await _initializer.service.isPermissionGranted(type);
  }

  /// 권한 거부 여부 확인
  ///
  /// [type] - 확인할 권한 타입
  ///
  /// 권한이 거부되었는지 확인합니다.
  static Future<bool> isPermissionDenied(PermissionType type) async {
    return await _initializer.service.isPermissionDenied(type);
  }

  /// 권한 영구 거부 여부 확인
  ///
  /// [type] - 확인할 권한 타입
  ///
  /// 권한이 영구적으로 거부되었는지 확인합니다.
  static Future<bool> isPermissionPermanentlyDenied(PermissionType type) async {
    return await _initializer.service.isPermissionPermanentlyDenied(type);
  }

  /// 권한 제한 여부 확인
  ///
  /// [type] - 확인할 권한 타입
  ///
  /// 권한이 제한되었는지 확인합니다.
  static Future<bool> isPermissionRestricted(PermissionType type) async {
    return await _initializer.service.isPermissionRestricted(type);
  }

  /// 권한 사용 불가 여부 확인
  ///
  /// [type] - 확인할 권한 타입
  ///
  /// 권한이 사용 불가능한지 확인합니다.
  static Future<bool> isPermissionUnavailable(PermissionType type) async {
    return await _initializer.service.isPermissionUnavailable(type);
  }

  /// 앱 설정 화면 열기
  ///
  /// 앱의 설정 화면을 엽니다.
  static Future<void> openAppSettings() async {
    await _initializer.service.openAppSettings();
  }

  /// 권한 설정 화면 열기
  ///
  /// 시스템의 권한 설정 화면을 엽니다.
  static Future<void> openPermissionSettings() async {
    await _initializer.service.openPermissionSettings();
  }

  /// 권한 요청 rationale 표시 여부 확인
  ///
  /// [type] - 확인할 권한 타입
  ///
  /// 권한 요청 전에 rationale을 표시해야 하는지 확인합니다.
  static Future<bool> shouldShowRequestRationale(PermissionType type) async {
    return await _initializer.service.shouldShowRequestRationale(type);
  }

  /// 현재 플랫폼에서 사용 가능한 권한 목록
  ///
  /// 현재 플랫폼에서 지원하는 권한 타입 목록을 반환합니다.
  static List<PermissionType> getAvailablePermissionsForPlatform() {
    return _initializer.service.getAvailablePermissionsForPlatform();
  }

  /// 권한 상태 추적기 가져오기
  ///
  /// 권한 상태를 추적하는 객체를 반환합니다.
  static PermissionStateTracker get stateTracker {
    return _initializer.service.stateTracker;
  }

  /// 권한 요청 전략 가져오기
  ///
  /// 권한 요청 전략을 관리하는 객체를 반환합니다.
  static PermissionRequestStrategy get requestStrategy {
    return _initializer.service.requestStrategy;
  }

  /// 간편한 권한 요청
  ///
  /// [type] - 요청할 권한 타입
  /// [reason] - 권한 요청 이유 (선택사항)
  ///
  /// 기본 설정으로 권한을 요청합니다.
  static Future<PermissionResult> request(PermissionType type,
      {String? reason}) async {
    final request = reason != null
        ? PermissionRequest.detailed(type: type, reason: reason)
        : PermissionRequest.basic(type);
    return await requestPermission(request);
  }

  /// 간편한 다중 권한 요청
  ///
  /// [types] - 요청할 권한 타입 목록
  /// [reason] - 권한 요청 이유 (선택사항)
  ///
  /// 기본 설정으로 여러 권한을 요청합니다.
  static Future<Map<PermissionType, PermissionResult>> requestMultiple(
    List<PermissionType> types, {
    String? reason,
  }) async {
    final requests = types.map((type) {
      return reason != null
          ? PermissionRequest.detailed(type: type, reason: reason)
          : PermissionRequest.basic(type);
    }).toList();
    return await requestMultiplePermissions(requests);
  }
}
