/// 권한 상태 enum
///
/// 권한의 현재 상태를 나타냅니다.
enum PermissionStatus {
  /// 권한이 거부됨
  denied,

  /// 권한이 허용됨
  granted,

  /// 권한이 제한됨 (iOS)
  restricted,

  /// 권한이 영구적으로 거부됨
  permanentlyDenied,

  /// 권한이 제한적으로 허용됨 (iOS 14+)
  limited,

  /// 권한이 임시로 허용됨 (iOS 14+)
  provisional,

  /// 권한이 사용 불가능함
  unavailable,

  /// 권한 상태를 알 수 없음
  unknown,
}
