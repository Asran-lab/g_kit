// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'g_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GResponse<T> {

 int? get statusCode; String? get message; DateTime? get timestamp; T? get data;
/// Create a copy of GResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GResponseCopyWith<T, GResponse<T>> get copyWith => _$GResponseCopyWithImpl<T, GResponse<T>>(this as GResponse<T>, _$identity);

  /// Serializes this GResponse to a JSON map.
  Map<String, dynamic> toJson(Object? Function(T) toJsonT);


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GResponse<T>&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode)&&(identical(other.message, message) || other.message == message)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&const DeepCollectionEquality().equals(other.data, data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,statusCode,message,timestamp,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'GResponse<$T>(statusCode: $statusCode, message: $message, timestamp: $timestamp, data: $data)';
}


}

/// @nodoc
abstract mixin class $GResponseCopyWith<T,$Res>  {
  factory $GResponseCopyWith(GResponse<T> value, $Res Function(GResponse<T>) _then) = _$GResponseCopyWithImpl;
@useResult
$Res call({
 int? statusCode, String? message, DateTime? timestamp, T? data
});




}
/// @nodoc
class _$GResponseCopyWithImpl<T,$Res>
    implements $GResponseCopyWith<T, $Res> {
  _$GResponseCopyWithImpl(this._self, this._then);

  final GResponse<T> _self;
  final $Res Function(GResponse<T>) _then;

/// Create a copy of GResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? statusCode = freezed,Object? message = freezed,Object? timestamp = freezed,Object? data = freezed,}) {
  return _then(_self.copyWith(
statusCode: freezed == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as T?,
  ));
}

}


/// Adds pattern-matching-related methods to [GResponse].
extension GResponsePatterns<T> on GResponse<T> {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GResponse<T> value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GResponse() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GResponse<T> value)  $default,){
final _that = this;
switch (_that) {
case _GResponse():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GResponse<T> value)?  $default,){
final _that = this;
switch (_that) {
case _GResponse() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? statusCode,  String? message,  DateTime? timestamp,  T? data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GResponse() when $default != null:
return $default(_that.statusCode,_that.message,_that.timestamp,_that.data);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? statusCode,  String? message,  DateTime? timestamp,  T? data)  $default,) {final _that = this;
switch (_that) {
case _GResponse():
return $default(_that.statusCode,_that.message,_that.timestamp,_that.data);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? statusCode,  String? message,  DateTime? timestamp,  T? data)?  $default,) {final _that = this;
switch (_that) {
case _GResponse() when $default != null:
return $default(_that.statusCode,_that.message,_that.timestamp,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(genericArgumentFactories: true)

class _GResponse<T> implements GResponse<T> {
   _GResponse({this.statusCode, this.message, this.timestamp, this.data});
  factory _GResponse.fromJson(Map<String, dynamic> json,T Function(Object?) fromJsonT) => _$GResponseFromJson(json,fromJsonT);

@override final  int? statusCode;
@override final  String? message;
@override final  DateTime? timestamp;
@override final  T? data;

/// Create a copy of GResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GResponseCopyWith<T, _GResponse<T>> get copyWith => __$GResponseCopyWithImpl<T, _GResponse<T>>(this, _$identity);

@override
Map<String, dynamic> toJson(Object? Function(T) toJsonT) {
  return _$GResponseToJson<T>(this, toJsonT);
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GResponse<T>&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode)&&(identical(other.message, message) || other.message == message)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&const DeepCollectionEquality().equals(other.data, data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,statusCode,message,timestamp,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'GResponse<$T>(statusCode: $statusCode, message: $message, timestamp: $timestamp, data: $data)';
}


}

/// @nodoc
abstract mixin class _$GResponseCopyWith<T,$Res> implements $GResponseCopyWith<T, $Res> {
  factory _$GResponseCopyWith(_GResponse<T> value, $Res Function(_GResponse<T>) _then) = __$GResponseCopyWithImpl;
@override @useResult
$Res call({
 int? statusCode, String? message, DateTime? timestamp, T? data
});




}
/// @nodoc
class __$GResponseCopyWithImpl<T,$Res>
    implements _$GResponseCopyWith<T, $Res> {
  __$GResponseCopyWithImpl(this._self, this._then);

  final _GResponse<T> _self;
  final $Res Function(_GResponse<T>) _then;

/// Create a copy of GResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? statusCode = freezed,Object? message = freezed,Object? timestamp = freezed,Object? data = freezed,}) {
  return _then(_GResponse<T>(
statusCode: freezed == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as T?,
  ));
}


}

// dart format on
