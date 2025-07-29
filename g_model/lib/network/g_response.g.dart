// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'g_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GResponse<T> _$GResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => _GResponse<T>(
  statusCode: (json['statusCode'] as num?)?.toInt(),
  message: json['message'] as String?,
  timestamp: json['timestamp'] == null
      ? null
      : DateTime.parse(json['timestamp'] as String),
  data: _$nullableGenericFromJson(json['data'], fromJsonT),
);

Map<String, dynamic> _$GResponseToJson<T>(
  _GResponse<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'statusCode': instance.statusCode,
  'message': instance.message,
  'timestamp': instance.timestamp?.toIso8601String(),
  'data': _$nullableGenericToJson(instance.data, toJsonT),
};

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) => input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) => input == null ? null : toJson(input);
