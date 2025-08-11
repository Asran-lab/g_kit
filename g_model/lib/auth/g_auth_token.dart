import 'package:freezed_annotation/freezed_annotation.dart';

part 'g_auth_token.freezed.dart';
part 'g_auth_token.g.dart';

@Freezed(genericArgumentFactories: true)
sealed class GAuthToken with _$GAuthToken {
  factory GAuthToken({
    required String userId,
    required String accessToken,
    required String refreshToken,
    DateTime? accessTokenExpiry,
    DateTime? refreshTokenExpiry,
  }) = _GAuthToken;

  factory GAuthToken.fromJson(Map<String, dynamic> json) =>
      _$GAuthTokenFromJson(json);
}
