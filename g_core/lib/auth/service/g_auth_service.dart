import 'package:g_common/g_common.dart';
import 'package:g_core/auth/common/g_auth_strategy_type.dart';
import 'package:g_core/auth/strategy/g_auth_strategy.dart';
import 'package:g_core/auth/strategy/impl/g_short_code_auth_strategy.dart';
import 'package:g_core/auth/context/g_auth_context.dart';
import 'package:g_model/base/g_either.dart';
import 'package:g_model/network/g_exception.dart';
import 'package:g_model/auth/g_auth_token.dart';

class GAuthService {
  GAuthService._();
  static final GAuthService I = GAuthService._();

  GAuthStrategy? _currentStrategy;
  final Map<GAuthStrategyType, GAuthStrategy> _strategies = {};

  /// 서비스 초기화
  Future<void> initialize() async {
    // 기본 전략들 등록
    await _registerStrategies();

    // 기본 전략 설정 (숏코드)
    await switchStrategy(GAuthStrategyType.shortCode);
  }

  /// 전략 등록
  Future<void> _registerStrategies() async {
    // 숏코드 전략
    final shortCodeStrategy = GShortCodeAuthStrategy();
    await shortCodeStrategy.initialize();
    _strategies[GAuthStrategyType.shortCode] = shortCodeStrategy;
    // _strategies[GAuthStrategyType.oauth] = GOAuthStrategy();
    // _strategies[GAuthStrategyType.wallet] = GWalletAuthStrategy();
    // _strategies[GAuthStrategyType.passkey] = GPasskeyAuthStrategy();
  }

  /// 전략 전환
  Future<void> switchStrategy(GAuthStrategyType type) async {
    final strategy = _strategies[type];
    if (strategy == null) {
      throw ArgumentError('Strategy not found: $type');
    }

    // 기존 전략 정리
    if (_currentStrategy != null) {
      await _currentStrategy!.dispose();
    }

    _currentStrategy = strategy;
    await _currentStrategy!.initialize();
  }

  /// 현재 전략 타입
  GAuthStrategyType? get currentStrategyType => _currentStrategy?.type;

  /// 인증 상태 확인
  bool get isAuthenticated => _currentStrategy?.isAuthenticated ?? false;

  /// 로그인
  Future<GEither<GException, GAuthToken>> signIn(GJson data) async {
    if (_currentStrategy == null) {
      return GEither.left(
        GException(message: 'No authentication strategy selected'),
      );
    }

    GAuthContext.I.setSigningIn();

    final result = await _currentStrategy!.signIn(data);

    if (result.fold(
      (error) => false,
      (token) => true,
    )) {
      // 성공 시 context 업데이트
      final token = result.fold(
        (error) => null,
        (token) => token,
      );
      if (token != null) {
        GAuthContext.I.setSignedIn(token.userId);
      }
    } else {
      // 실패 시 로그아웃 상태로
      GAuthContext.I.setSignedOut();
    }

    return result;
  }

  /// 로그아웃
  Future<GEither<GException, void>> signOut() async {
    if (_currentStrategy == null) {
      return GEither.left(
        GException(message: 'No authentication strategy selected'),
      );
    }

    final result = await _currentStrategy!.signOut();

    // context 업데이트
    GAuthContext.I.setSignedOut();

    return result;
  }

  /// 토큰 갱신
  Future<GEither<GException, GAuthToken>> refreshToken(
      String refreshToken) async {
    if (_currentStrategy == null) {
      return GEither.left(
        GException(message: 'No authentication strategy selected'),
      );
    }

    return await _currentStrategy!.refreshToken(refreshToken);
  }

  /// 서비스 종료
  Future<void> dispose() async {
    if (_currentStrategy != null) {
      await _currentStrategy!.dispose();
      _currentStrategy = null;
    }

    for (final strategy in _strategies.values) {
      await strategy.dispose();
    }
    _strategies.clear();
  }
}
