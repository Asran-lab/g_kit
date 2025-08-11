// 인증 상태
enum GAuthStatus {
  signedOut,
  signingIn,
  signedIn,
}

class GAuthState {
  final GAuthStatus status;
  final String? userId;
  const GAuthState._(this.status, this.userId);

  factory GAuthState.signedOut() =>
      const GAuthState._(GAuthStatus.signedOut, null);
  factory GAuthState.signingIn() =>
      const GAuthState._(GAuthStatus.signingIn, null);
  factory GAuthState.signedIn(String userId) =>
      GAuthState._(GAuthStatus.signedIn, userId);
}
