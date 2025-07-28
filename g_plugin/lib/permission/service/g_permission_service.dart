import '../models/permission_type.dart';
import '../models/permission_status.dart';
import '../models/permission_request.dart';
import '../models/permission_result.dart';

/// 권한 서비스 추상 인터페이스
///
/// 권한 관리의 핵심 기능들을 정의합니다.
abstract class GPermissionService {
  /// 서비스 초기화
  ///
  /// 권한 서비스를 초기화합니다.
  Future<void> initialize();

  /// 서비스 정리
  ///
  /// 권한 서비스를 정리합니다.
  Future<void> dispose();

  /// 단일 권한 상태 확인
  ///
  /// [type] - 확인할 권한 타입
  ///
  /// 특정 권한의 현재 상태를 확인합니다.
  Future<PermissionStatus> checkPermission(PermissionType type);

  /// 다중 권한 상태 확인
  ///
  /// [types] - 확인할 권한 타입 목록
  ///
  /// 여러 권한의 현재 상태를 한 번에 확인합니다.
  Future<Map<PermissionType, PermissionStatus>> checkMultiplePermissions(
      List<PermissionType> types);

  /// 단일 권한 요청
  ///
  /// [request] - 권한 요청 정보
  ///
  /// 사용자에게 권한을 요청합니다.
  Future<PermissionResult> requestPermission(PermissionRequest request);

  /// 다중 권한 요청
  ///
  /// [requests] - 권한 요청 정보 목록
  ///
  /// 사용자에게 여러 권한을 요청합니다.
  Future<Map<PermissionType, PermissionResult>> requestMultiplePermissions(
      List<PermissionRequest> requests);

  /// 권한 허용 여부 확인
  ///
  /// [type] - 확인할 권한 타입
  ///
  /// 권한이 허용되었는지 확인합니다.
  Future<bool> isPermissionGranted(PermissionType type);

  /// 권한 거부 여부 확인
  ///
  /// [type] - 확인할 권한 타입
  ///
  /// 권한이 거부되었는지 확인합니다.
  Future<bool> isPermissionDenied(PermissionType type);

  /// 권한 영구 거부 여부 확인
  ///
  /// [type] - 확인할 권한 타입
  ///
  /// 권한이 영구적으로 거부되었는지 확인합니다.
  Future<bool> isPermissionPermanentlyDenied(PermissionType type);

  /// 권한 제한 여부 확인
  ///
  /// [type] - 확인할 권한 타입
  ///
  /// 권한이 제한되었는지 확인합니다.
  Future<bool> isPermissionRestricted(PermissionType type);

  /// 권한 사용 불가 여부 확인
  ///
  /// [type] - 확인할 권한 타입
  ///
  /// 권한이 사용 불가능한지 확인합니다.
  Future<bool> isPermissionUnavailable(PermissionType type);

  /// 앱 설정 화면 열기
  ///
  /// 앱의 설정 화면을 엽니다.
  Future<void> openAppSettings();

  /// 권한 설정 화면 열기
  ///
  /// 시스템의 권한 설정 화면을 엽니다.
  Future<void> openPermissionSettings();

  /// 권한 요청 rationale 표시 여부 확인
  ///
  /// [type] - 확인할 권한 타입
  ///
  /// 권한 요청 전에 rationale을 표시해야 하는지 확인합니다.
  Future<bool> shouldShowRequestRationale(PermissionType type);

  /// 현재 플랫폼에서 사용 가능한 권한 목록
  ///
  /// 현재 플랫폼에서 지원하는 권한 타입 목록을 반환합니다.
  List<PermissionType> getAvailablePermissionsForPlatform();

  /// 권한 상태 추적기 가져오기
  ///
  /// 권한 상태를 추적하는 객체를 반환합니다.
  PermissionStateTracker get stateTracker;

  /// 권한 요청 전략 가져오기
  ///
  /// 권한 요청 전략을 관리하는 객체를 반환합니다.
  PermissionRequestStrategy get requestStrategy;
}

/// 권한 상태 추적기
///
/// 권한 상태를 추적하고 관리합니다.
abstract class PermissionStateTracker {
  /// 권한 상태 업데이트
  ///
  /// [type] - 권한 타입
  /// [status] - 권한 상태
  void updatePermissionState(PermissionType type, PermissionStatus status);

  /// 권한 상태 가져오기
  ///
  /// [type] - 권한 타입
  ///
  /// 특정 권한의 현재 상태를 반환합니다.
  PermissionStatus? getPermissionState(PermissionType type);

  /// 거부된 권한 목록
  ///
  /// 현재 거부된 권한들의 목록을 반환합니다.
  List<PermissionType> getDeniedPermissions();

  /// 허용된 권한 목록
  ///
  /// 현재 허용된 권한들의 목록을 반환합니다.
  List<PermissionType> getGrantedPermissions();

  /// 영구 거부된 권한 목록
  ///
  /// 현재 영구적으로 거부된 권한들의 목록을 반환합니다.
  List<PermissionType> getPermanentlyDeniedPermissions();

  /// 모든 권한 상태 초기화
  ///
  /// 추적 중인 모든 권한 상태를 초기화합니다.
  void clearAllStates();
}

/// 권한 요청 전략
///
/// 권한 요청 방식을 관리합니다.
abstract class PermissionRequestStrategy {
  /// 점진적 권한 요청
  ///
  /// [permissions] - 요청할 권한 목록
  ///
  /// 권한들을 점진적으로 요청합니다.
  Future<Map<PermissionType, PermissionResult>> requestPermissionsProgressively(
      List<PermissionRequest> permissions);

  /// 컨텍스트 기반 권한 요청
  ///
  /// [request] - 권한 요청 정보
  /// [context] - 요청 컨텍스트
  ///
  /// 특정 컨텍스트에서 권한을 요청합니다.
  Future<PermissionResult> requestPermissionWithContext(
      PermissionRequest request, String context);

  /// 최적 타이밍 권한 요청
  ///
  /// [request] - 권한 요청 정보
  ///
  /// 최적의 타이밍에 권한을 요청합니다.
  Future<PermissionResult> requestPermissionAtOptimalTime(
      PermissionRequest request);

  /// 권한 요청 재시도
  ///
  /// [request] - 권한 요청 정보
  /// [maxRetries] - 최대 재시도 횟수
  ///
  /// 권한 요청을 재시도합니다.
  Future<PermissionResult> retryPermissionRequest(
      PermissionRequest request, int maxRetries);
}
