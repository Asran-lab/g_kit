import 'package:freezed_annotation/freezed_annotation.dart';

part 'g_short_code.freezed.dart';
part 'g_short_code.g.dart';

@freezed
sealed class GShortCode with _$GShortCode {
  factory GShortCode({
    required String code,
    required String hashedCode,
    required DateTime createdAt,
    required DateTime expiresAt,
    @Default(0) int attempts,
    @Default(3) int maxAttempts,
    @Default(true) bool isActive,
  }) = _GShortCode;

  factory GShortCode.fromJson(Map<String, dynamic> json) =>
      _$GShortCodeFromJson(json);
}

@freezed
sealed class GShortCodeRequest with _$GShortCodeRequest {
  factory GShortCodeRequest({
    required String code,
    required String deviceKeyHash,
  }) = _GShortCodeRequest;

  factory GShortCodeRequest.fromJson(Map<String, dynamic> json) =>
      _$GShortCodeRequestFromJson(json);
}

@freezed
sealed class GNonceResponse with _$GNonceResponse {
  factory GNonceResponse({required String nonce, required DateTime expiresAt}) =
      _GNonceResponse;

  factory GNonceResponse.fromJson(Map<String, dynamic> json) =>
      _$GNonceResponseFromJson(json);
}

@freezed
sealed class GSignatureRequest with _$GSignatureRequest {
  factory GSignatureRequest({
    required String code,
    required String deviceKeyHash,
    required String nonce,
    required String signature,
  }) = _GSignatureRequest;

  factory GSignatureRequest.fromJson(Map<String, dynamic> json) =>
      _$GSignatureRequestFromJson(json);
}

@freezed
sealed class GDeviceInfo with _$GDeviceInfo {
  factory GDeviceInfo({
    required String deviceId,
    required String platform,
    required String osVersion,
    required String appVersion,
    DateTime? lastActiveAt,
  }) = _GDeviceInfo;

  factory GDeviceInfo.fromJson(Map<String, dynamic> json) =>
      _$GDeviceInfoFromJson(json);
}
