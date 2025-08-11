// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'g_short_code.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GShortCode _$GShortCodeFromJson(Map<String, dynamic> json) => _GShortCode(
  code: json['code'] as String,
  hashedCode: json['hashedCode'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  expiresAt: DateTime.parse(json['expiresAt'] as String),
  attempts: (json['attempts'] as num?)?.toInt() ?? 0,
  maxAttempts: (json['maxAttempts'] as num?)?.toInt() ?? 3,
  isActive: json['isActive'] as bool? ?? true,
);

Map<String, dynamic> _$GShortCodeToJson(_GShortCode instance) =>
    <String, dynamic>{
      'code': instance.code,
      'hashedCode': instance.hashedCode,
      'createdAt': instance.createdAt.toIso8601String(),
      'expiresAt': instance.expiresAt.toIso8601String(),
      'attempts': instance.attempts,
      'maxAttempts': instance.maxAttempts,
      'isActive': instance.isActive,
    };

_GShortCodeRequest _$GShortCodeRequestFromJson(Map<String, dynamic> json) =>
    _GShortCodeRequest(
      code: json['code'] as String,
      deviceKeyHash: json['deviceKeyHash'] as String,
    );

Map<String, dynamic> _$GShortCodeRequestToJson(_GShortCodeRequest instance) =>
    <String, dynamic>{
      'code': instance.code,
      'deviceKeyHash': instance.deviceKeyHash,
    };

_GNonceResponse _$GNonceResponseFromJson(Map<String, dynamic> json) =>
    _GNonceResponse(
      nonce: json['nonce'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
    );

Map<String, dynamic> _$GNonceResponseToJson(_GNonceResponse instance) =>
    <String, dynamic>{
      'nonce': instance.nonce,
      'expiresAt': instance.expiresAt.toIso8601String(),
    };

_GSignatureRequest _$GSignatureRequestFromJson(Map<String, dynamic> json) =>
    _GSignatureRequest(
      code: json['code'] as String,
      deviceKeyHash: json['deviceKeyHash'] as String,
      nonce: json['nonce'] as String,
      signature: json['signature'] as String,
    );

Map<String, dynamic> _$GSignatureRequestToJson(_GSignatureRequest instance) =>
    <String, dynamic>{
      'code': instance.code,
      'deviceKeyHash': instance.deviceKeyHash,
      'nonce': instance.nonce,
      'signature': instance.signature,
    };

_GDeviceInfo _$GDeviceInfoFromJson(Map<String, dynamic> json) => _GDeviceInfo(
  deviceId: json['deviceId'] as String,
  platform: json['platform'] as String,
  osVersion: json['osVersion'] as String,
  appVersion: json['appVersion'] as String,
  lastActiveAt: json['lastActiveAt'] == null
      ? null
      : DateTime.parse(json['lastActiveAt'] as String),
);

Map<String, dynamic> _$GDeviceInfoToJson(_GDeviceInfo instance) =>
    <String, dynamic>{
      'deviceId': instance.deviceId,
      'platform': instance.platform,
      'osVersion': instance.osVersion,
      'appVersion': instance.appVersion,
      'lastActiveAt': instance.lastActiveAt?.toIso8601String(),
    };
