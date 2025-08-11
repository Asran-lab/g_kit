import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:g_common/g_common.dart';
import 'package:g_core/auth/common/g_auth_strategy_type.dart';
import 'package:g_core/auth/strategy/g_auth_strategy.dart';
import 'package:g_core/network/facade/g_network.dart';
import 'package:g_core/storage/facade/g_storage.dart';
import 'package:g_lib/g_lib_common.dart';
import 'package:g_model/base/g_either.dart';
import 'package:g_model/network/g_exception.dart';
import 'package:g_model/auth/g_auth_token.dart';
import 'package:g_model/auth/g_short_code.dart';

class GShortCodeAuthStrategy implements GAuthStrategy {
  static const String _deviceKeyStorageKey = 'device_key';
  static const String _tokenStorageKey = 'auth_token';
  static const String _shortCodeStorageKey = 'kUserCode';

  @override
  GAuthStrategyType get type => GAuthStrategyType.shortCode;

  @override
  bool get isAuthenticated => _currentToken != null;

  GAuthToken? _currentToken;
  String? _deviceKey;

  @override
  Future<void> initialize() async {
    // 디바이스 키 로드 또는 생성
    _deviceKey = await _getOrCreateDeviceKey();

    // 저장된 토큰 로드
    await _loadStoredToken();
  }

  @override
  Future<GEither<GException, GAuthToken>> signIn(GJson data) async {
    try {
      final shortCode = data['shortCode'] as String?;
      if (shortCode == null || shortCode.isEmpty) {
        return GEither.left(
          GException(message: 'Short code is required'),
        );
      }

      if (_deviceKey == null) {
        return GEither.left(
          GException(message: 'Device key not initialized'),
        );
      }

      // API 연동 전까지는 mock 토큰으로 처리
      try {
        // 1단계: 디바이스 키 해시와 숏코드로 nonce 요청
        final deviceKeyHash = _hashDeviceKey(_deviceKey!);
        final nonceResult = await _requestNonce(shortCode, deviceKeyHash);

        return nonceResult.fold(
          (l) => _handleApiFailure(shortCode, l),
          (nonceResponse) async {
            // 2단계: nonce를 디바이스 키로 HMAC 서명
            final signature = _signNonce(nonceResponse.nonce, _deviceKey!);

            // 3단계: 서명으로 토큰 요청
            final tokenResult = await _requestToken(
              shortCode,
              deviceKeyHash,
              nonceResponse.nonce,
              signature,
            );

            return tokenResult.fold(
              (l) => _handleApiFailure(shortCode, l),
              (token) async {
                _currentToken = token;
                // 토큰 저장
                await _storeToken(token);
                // 숏코드 저장
                await _storeShortCode(shortCode);
                return GEither.right(token);
              },
            );
          },
        );
      } catch (e) {
        // API 연동 전이므로 mock 토큰으로 처리
        return _handleApiFailure(shortCode, GException(message: 'API not connected: $e'));
      }
    } catch (e) {
      return GEither.left(
        GException(message: 'Sign in failed: $e'),
      );
    }
  }

  @override
  Future<GEither<GException, void>> signOut() async {
    try {
      _currentToken = null;
      await GStorage.delete(key: _tokenStorageKey);
      return GEither.right(null);
    } catch (e) {
      return GEither.left(
        GException(message: 'Sign out failed: $e'),
      );
    }
  }

  @override
  Future<GEither<GException, GAuthToken>> refreshToken(
      String refreshToken) async {
    try {
      final response = await GNetwork.post<GAuthToken>(
        path: '/auth/refresh',
        data: {'refreshToken': refreshToken},
        fromJsonT: (json) => GAuthToken.fromJson(json as Map<String, dynamic>),
      );

      return response.fold(
        (l) => GEither.left(l),
        (r) {
          final token = r.data ??
              GAuthToken(accessToken: '', refreshToken: '', userId: '');
          _currentToken = token;
          _storeToken(token);
          return GEither.right(token);
        },
      );
    } catch (e) {
      return GEither.left(
        GException(message: 'Token refresh failed: $e'),
      );
    }
  }

  @override
  Future<void> dispose() async {
    _currentToken = null;
    _deviceKey = null;
  }

  /// 디바이스 키 로드 또는 생성
  Future<String> _getOrCreateDeviceKey() async {
    final stored = await GStorage.get(key: _deviceKeyStorageKey);
    if (stored != null && stored is String) {
      return stored;
    }

    // 새 디바이스 키 생성 (UUID 기반)
    final deviceKey = GUuid.generate();
    await GStorage.set(key: _deviceKeyStorageKey, value: deviceKey);
    return deviceKey;
  }

  /// 디바이스 키 해시 생성
  String _hashDeviceKey(String deviceKey) {
    final bytes = utf8.encode(deviceKey);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// nonce를 디바이스 키로 HMAC 서명
  String _signNonce(String nonce, String deviceKey) {
    final key = utf8.encode(deviceKey);
    final message = utf8.encode(nonce);
    final hmac = Hmac(sha256, key);
    final digest = hmac.convert(message);
    return base64.encode(digest.bytes);
  }

  /// nonce 요청
  Future<GEither<GException, GNonceResponse>> _requestNonce(
    String shortCode,
    String deviceKeyHash,
  ) async {
    final response = await GNetwork.post<GNonceResponse>(
      path: '/auth/nonce',
      data: GShortCodeRequest(
        code: shortCode,
        deviceKeyHash: deviceKeyHash,
      ).toJson(),
      fromJsonT: (json) =>
          GNonceResponse.fromJson(json as Map<String, dynamic>),
    );

    return response.fold(
      (l) => GEither.left(l),
      (r) => GEither.right(
        r.data ?? GNonceResponse(nonce: '', expiresAt: DateTime.now()),
      ),
    );
  }

  /// 토큰 요청
  Future<GEither<GException, GAuthToken>> _requestToken(
    String shortCode,
    String deviceKeyHash,
    String nonce,
    String signature,
  ) async {
    final response = await GNetwork.post<GAuthToken>(
      path: '/auth/token',
      data: GSignatureRequest(
        code: shortCode,
        deviceKeyHash: deviceKeyHash,
        nonce: nonce,
        signature: signature,
      ).toJson(),
      fromJsonT: (json) => GAuthToken.fromJson(json as Map<String, dynamic>),
    );
    return response.fold(
      (l) => GEither.left(l),
      (r) => GEither.right(
        r.data ?? GAuthToken(accessToken: '', refreshToken: '', userId: ''),
      ),
    );
  }

  /// 저장된 토큰 로드
  Future<void> _loadStoredToken() async {
    await guardFuture(
      () async {
        final stored = await GStorage.get(key: _tokenStorageKey);
        if (stored != null && stored is String) {
          final tokenJson = jsonDecode(stored) as Map<String, dynamic>;
          _currentToken = GAuthToken.fromJson(tokenJson);
        }
      },
      onError: (e, stackTrace) {
        Logger.w('Failed to load stored token: $e');
      },
    );
  }

  /// 토큰 저장
  Future<void> _storeToken(GAuthToken token) async {
    await guardFuture(
      () async {
        final tokenJson = jsonEncode(token.toJson());
        await GStorage.set(key: _tokenStorageKey, value: tokenJson);
      },
      onError: (e, stackTrace) {
        Logger.w('Failed to store token: $e');
      },
    );
  }

  /// 숏코드 저장
  Future<void> _storeShortCode(String shortCode) async {
    await guardFuture(
      () async {
        await GStorage.set(key: _shortCodeStorageKey, value: shortCode, isSecure: true);
      },
      onError: (e, stackTrace) {
        Logger.w('Failed to store short code: $e');
      },
    );
  }

  /// API 연동 전 mock 처리
  Future<GEither<GException, GAuthToken>> _handleApiFailure(String shortCode, GException error) async {
    Logger.w('API 연동 전이므로 mock 토큰으로 처리: ${error.message}');
    
    // Mock 토큰 생성
    final mockToken = GAuthToken(
      accessToken: 'mock_access_token_${shortCode}_${DateTime.now().millisecondsSinceEpoch}',
      refreshToken: 'mock_refresh_token_${shortCode}_${DateTime.now().millisecondsSinceEpoch}',
      userId: shortCode, // 숏코드를 userId로 사용
    );

    _currentToken = mockToken;
    
    // 토큰과 숏코드 저장
    await _storeToken(mockToken);
    await _storeShortCode(shortCode);
    
    return GEither.right(mockToken);
  }
}
