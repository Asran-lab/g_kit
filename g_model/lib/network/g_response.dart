import 'package:freezed_annotation/freezed_annotation.dart';

part 'g_response.freezed.dart';
part 'g_response.g.dart';

@Freezed(genericArgumentFactories: true)
sealed class GResponse<T> with _$GResponse<T> {
  factory GResponse({
    int? statusCode,
    String? message,
    DateTime? timestamp,
    T? data,
  }) = _GResponse;

  factory GResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) => _$GResponseFromJson(json, fromJsonT);
}
