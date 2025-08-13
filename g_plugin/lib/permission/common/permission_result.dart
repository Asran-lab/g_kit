import 'permission_type.dart';
import 'permission_status.dart';

/// 권한 요청 결과
///
/// 권한 요청의 결과를 담습니다.
class PermissionResult {
  /// 권한 타입
  final PermissionType type;

  /// 권한 상태
  final PermissionStatus status;

  /// 권한 요청 성공 여부
  final bool isGranted;

  /// 권한 요청 실패 여부
  final bool isDenied;

  /// 권한이 영구적으로 거부되었는지 여부
  final bool isPermanentlyDenied;

  /// 에러 메시지 (있는 경우)
  final String? errorMessage;

  /// 권한 요청 시도 횟수
  final int attemptCount;

  const PermissionResult({
    required this.type,
    required this.status,
    required this.isGranted,
    required this.isDenied,
    required this.isPermanentlyDenied,
    this.errorMessage,
    required this.attemptCount,
  });

  /// 성공 결과 생성
  factory PermissionResult.success(PermissionType type, int attemptCount) {
    return PermissionResult(
      type: type,
      status: PermissionStatus.granted,
      isGranted: true,
      isDenied: false,
      isPermanentlyDenied: false,
      attemptCount: attemptCount,
    );
  }

  /// 실패 결과 생성
  factory PermissionResult.failure(
    PermissionType type,
    PermissionStatus status,
    String? errorMessage,
    int attemptCount,
  ) {
    return PermissionResult(
      type: type,
      status: status,
      isGranted: false,
      isDenied: status == PermissionStatus.denied,
      isPermanentlyDenied: status == PermissionStatus.permanentlyDenied,
      errorMessage: errorMessage,
      attemptCount: attemptCount,
    );
  }
}
