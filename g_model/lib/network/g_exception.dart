import 'package:freezed_annotation/freezed_annotation.dart';

part 'g_exception.freezed.dart';
part 'g_exception.g.dart';

@Freezed(genericArgumentFactories: true, fromJson: true, toJson: false)
sealed class GException with _$GException {
  const factory GException({
    int? statusCode,
    String? message,
    DateTime? timestamp,
  }) = _GException;

  factory GException.fromJson(Map<String, dynamic> json) =>
      _$GExceptionFromJson(json);
}
