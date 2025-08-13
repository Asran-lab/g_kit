import '../common/permission_type.dart';
import '../common/permission_status.dart';
import '../common/permission_request.dart';
import '../common/permission_result.dart';

/// 플랫폼별 권한 처리 추상화 인터페이스
///
/// 각 플랫폼(Android, iOS, macOS, Web)에서 구현해야 하는 권한 처리 메서드들을 정의합니다.
abstract class PermissionPlatform {
  /// 플랫폼 이름
  String get platformName;

  /// 플랫폼이 지원하는 권한 타입 목록
  List<PermissionType> get supportedPermissions;

  /// 권한 상태 확인
  ///
  /// [type] - 확인할 권한 타입
  ///
  /// 현재 권한의 상태를 반환합니다.
  Future<PermissionStatus> checkPermission(PermissionType type);

  /// 권한 요청
  ///
  /// [request] - 권한 요청 정보
  ///
  /// 사용자에게 권한을 요청하고 결과를 반환합니다.
  Future<PermissionResult> requestPermission(PermissionRequest request);

  /// 권한 요청 rationale 표시 여부 확인
  ///
  /// [type] - 확인할 권한 타입
  ///
  /// 권한 요청 전에 rationale을 표시해야 하는지 확인합니다.
  Future<bool> shouldShowRequestRationale(PermissionType type);

  /// 앱 설정 화면 열기
  ///
  /// 앱의 설정 화면을 엽니다.
  Future<void> openAppSettings();

  /// 권한 설정 화면 열기
  ///
  /// 시스템의 권한 설정 화면을 엽니다.
  Future<void> openPermissionSettings();

  /// 권한이 사용 가능한지 확인
  ///
  /// [type] - 확인할 권한 타입
  ///
  /// 해당 권한이 현재 플랫폼에서 사용 가능한지 확인합니다.
  bool isPermissionAvailable(PermissionType type);

  /// 권한 타입을 플랫폼별 권한으로 변환
  ///
  /// [type] - 변환할 권한 타입
  ///
  /// 내부적으로 사용하는 플랫폼별 권한 객체로 변환합니다.
  dynamic convertToPlatformPermission(PermissionType type);

  /// 플랫폼별 권한 상태를 내부 상태로 변환
  ///
  /// [platformStatus] - 플랫폼별 권한 상태
  ///
  /// 플랫폼에서 반환하는 권한 상태를 내부 상태로 변환합니다.
  PermissionStatus convertFromPlatformStatus(dynamic platformStatus);
}
