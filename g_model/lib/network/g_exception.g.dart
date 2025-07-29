// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'g_exception.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GException _$GExceptionFromJson(Map<String, dynamic> json) => _GException(
  statusCode: (json['statusCode'] as num?)?.toInt(),
  message: json['message'] as String?,
  timestamp: json['timestamp'] == null
      ? null
      : DateTime.parse(json['timestamp'] as String),
);
