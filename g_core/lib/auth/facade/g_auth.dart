import 'package:g_core/auth/common/g_auth_state.dart';
import 'package:g_core/auth/common/g_auth_strategy_type.dart';
import 'package:g_core/auth/service/g_auth_service.dart';
import 'package:g_core/auth/context/g_auth_context.dart';
import 'package:g_model/base/g_either.dart';
import 'package:g_model/network/g_exception.dart';
import 'package:g_model/auth/g_auth_token.dart';

class GAuth {
  GAuth._();

  /// 현재 인증 상태
  static bool get isAuthenticated => GAuthService.I.isAuthenticated;

  /// 인증 상태 스트림
  static Stream<GAuthState> get stateStream => GAuthContext.I.stateStream;

  /// 현재 인증 전략 타입
  static GAuthStrategyType? get currentStrategy =>
      GAuthService.I.currentStrategyType;

  /// 전략 전환
  static Future<void> switchStrategy(GAuthStrategyType type) async {
    await GAuthService.I.switchStrategy(type);
  }

  /// 숏코드로 로그인
  static Future<GEither<GException, GAuthToken>> signInWithShortCode(
      String shortCode) async {
    return await GAuthService.I.signIn({'shortCode': shortCode});
  }

  /// 로그아웃
  static Future<GEither<GException, void>> signOut() async {
    return await GAuthService.I.signOut();
  }

  /// 토큰 갱신
  static Future<GEither<GException, GAuthToken>> refreshToken(
      String refreshToken) async {
    return await GAuthService.I.refreshToken(refreshToken);
  }
}
