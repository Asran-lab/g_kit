import 'package:g_common/g_common.dart';
import 'package:g_core/auth/common/g_auth_strategy_type.dart';
import 'package:g_model/base/g_either.dart';
import 'package:g_model/network/g_exception.dart';
import 'package:g_model/auth/g_auth_token.dart';

/// 인증 전략의 기본 인터페이스
abstract class GAuthStrategy {
  /// 전략 타입
  GAuthStrategyType get type;

  /// 현재 인증 상태 확인
  bool get isAuthenticated;

  /// 인증 초기화
  Future<void> initialize();

  /// 인증 시작
  Future<GEither<GException, GAuthToken>> signIn(GJson data);

  /// 인증 해제
  Future<GEither<GException, void>> signOut();

  /// 토큰 갱신
  Future<GEither<GException, GAuthToken>> refreshToken(String refreshToken);

  /// 전략 정리
  Future<void> dispose();
}
