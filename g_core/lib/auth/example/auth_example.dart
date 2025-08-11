import 'package:g_common/g_common.dart';
import 'package:g_core/g_core.dart';

/// GCore Auth 모듈 사용 예시
///
/// 이 예시는 g_core의 auth 모듈을 사용하는 방법을 보여줍니다.
class AuthExample {
  /// 1. 앱 시작 시 초기화
  static Future<void> initializeAuth() async {
    // 방법 1: Auth만 초기화
    await GCoreInitializer([
      GAuthInitializer(),
    ]).initializeAll();
    
    // 방법 2: Auth + 다른 모듈들도 함께 초기화
    // await GCoreInitializer([
    //   GAuthInitializer(),
    //   SomeOtherInitializer(),
    // ]).initializeAll();
  }

  /// 2. 숏코드로 로그인
  static Future<void> signInExample() async {
    final result = await GAuth.signInWithShortCode('UZ1234');

    result.fold(
      (error) => Logger.e('로그인 실패: ${error.message}'),
      (token) => Logger.i('로그인 성공: ${token.accessToken}'),
    );
  }

  /// 3. 인증 상태 확인
  static bool checkAuthStatus() {
    return GAuth.isAuthenticated;
  }

  /// 4. 인증 상태 스트림 구독
  static void subscribeToAuthState() {
    GAuth.stateStream.listen((state) {
      switch (state.status) {
        case GAuthStatus.signedOut:
          Logger.i('로그아웃 상태');
          break;
        case GAuthStatus.signingIn:
          Logger.i('로그인 중...');
          break;
        case GAuthStatus.signedIn:
          Logger.i('로그인 완료: ${state.userId}');
          break;
      }
    });
  }

  /// 5. 로그아웃
  static Future<void> signOutExample() async {
    final result = await GAuth.signOut();

    result.fold(
      (error) => Logger.e('로그아웃 실패: ${error.message}'),
      (_) => Logger.i('로그아웃 성공'),
    );
  }

  /// 6. 토큰 갱신
  static Future<void> refreshTokenExample(String refreshToken) async {
    final result = await GAuth.refreshToken(refreshToken);

    result.fold(
      (error) => Logger.e('토큰 갱신 실패: ${error.message}'),
      (token) => Logger.i('토큰 갱신 성공: ${token.accessToken}'),
    );
  }

  /// 7. 인증 전략 전환 (추후 확장용)
  static Future<void> switchStrategyExample() async {
    // 현재는 shortCode만 지원하지만, 추후 확장 가능
    await GAuth.switchStrategy(GAuthStrategyType.shortCode);

    // 추후 추가될 전략들:
    // await GAuth.switchStrategy(GAuthStrategyType.oauth);
    // await GAuth.switchStrategy(GAuthStrategyType.wallet);
    // await GAuth.switchStrategy(GAuthStrategyType.passkey);
  }
}
