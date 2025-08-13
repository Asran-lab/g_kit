import 'permission_type.dart';

/// 권한 요청 모델
///
/// 권한 요청 시 필요한 정보를 담습니다.
class PermissionRequest {
  /// 요청할 권한 타입
  final PermissionType type;

  /// 권한 요청 이유 (사용자에게 표시)
  final String? reason;

  /// 권한 요청 설명 (상세)
  final String? description;

  /// 권한이 거부되었을 때 표시할 메시지
  final String? deniedMessage;

  /// 권한이 영구적으로 거부되었을 때 표시할 메시지
  final String? permanentlyDeniedMessage;

  /// 권한 요청이 실패했을 때 표시할 메시지
  final String? failedMessage;

  /// 권한 요청 시 rationale 표시 여부
  final bool showRationale;

  /// 권한 요청 시 설정 화면으로 이동할지 여부
  final bool openSettingsOnDenied;

  /// 권한 요청 시 재시도 횟수
  final int maxRetryCount;

  const PermissionRequest({
    required this.type,
    this.reason,
    this.description,
    this.deniedMessage,
    this.permanentlyDeniedMessage,
    this.failedMessage,
    this.showRationale = true,
    this.openSettingsOnDenied = true,
    this.maxRetryCount = 1,
  });

  /// 기본 권한 요청 생성
  factory PermissionRequest.basic(PermissionType type) {
    return PermissionRequest(
      type: type,
      reason: '이 기능을 사용하기 위해 권한이 필요합니다.',
    );
  }

  /// 상세한 권한 요청 생성
  factory PermissionRequest.detailed({
    required PermissionType type,
    required String reason,
    String? description,
    String? deniedMessage,
    String? permanentlyDeniedMessage,
    String? failedMessage,
    bool showRationale = true,
    bool openSettingsOnDenied = true,
    int maxRetryCount = 1,
  }) {
    return PermissionRequest(
      type: type,
      reason: reason,
      description: description,
      deniedMessage: deniedMessage,
      permanentlyDeniedMessage: permanentlyDeniedMessage,
      failedMessage: failedMessage,
      showRationale: showRationale,
      openSettingsOnDenied: openSettingsOnDenied,
      maxRetryCount: maxRetryCount,
    );
  }
}
