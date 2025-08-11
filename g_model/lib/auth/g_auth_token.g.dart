// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'g_auth_token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GAuthToken _$GAuthTokenFromJson(Map<String, dynamic> json) => _GAuthToken(
  userId: json['userId'] as String,
  accessToken: json['accessToken'] as String,
  refreshToken: json['refreshToken'] as String,
  accessTokenExpiry: json['accessTokenExpiry'] == null
      ? null
      : DateTime.parse(json['accessTokenExpiry'] as String),
  refreshTokenExpiry: json['refreshTokenExpiry'] == null
      ? null
      : DateTime.parse(json['refreshTokenExpiry'] as String),
);

Map<String, dynamic> _$GAuthTokenToJson(_GAuthToken instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'accessTokenExpiry': instance.accessTokenExpiry?.toIso8601String(),
      'refreshTokenExpiry': instance.refreshTokenExpiry?.toIso8601String(),
    };
