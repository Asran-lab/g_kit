// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'g_exception.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GException {

 int? get statusCode; String? get message; DateTime? get timestamp;
/// Create a copy of GException
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GExceptionCopyWith<GException> get copyWith => _$GExceptionCopyWithImpl<GException>(this as GException, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GException&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode)&&(identical(other.message, message) || other.message == message)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,statusCode,message,timestamp);

@override
String toString() {
  return 'GException(statusCode: $statusCode, message: $message, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $GExceptionCopyWith<$Res>  {
  factory $GExceptionCopyWith(GException value, $Res Function(GException) _then) = _$GExceptionCopyWithImpl;
@useResult
$Res call({
 int? statusCode, String? message, DateTime? timestamp
});




}
/// @nodoc
class _$GExceptionCopyWithImpl<$Res>
    implements $GExceptionCopyWith<$Res> {
  _$GExceptionCopyWithImpl(this._self, this._then);

  final GException _self;
  final $Res Function(GException) _then;

/// Create a copy of GException
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? statusCode = freezed,Object? message = freezed,Object? timestamp = freezed,}) {
  return _then(_self.copyWith(
statusCode: freezed == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [GException].
extension GExceptionPatterns on GException {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GException value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GException() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GException value)  $default,){
final _that = this;
switch (_that) {
case _GException():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GException value)?  $default,){
final _that = this;
switch (_that) {
case _GException() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? statusCode,  String? message,  DateTime? timestamp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GException() when $default != null:
return $default(_that.statusCode,_that.message,_that.timestamp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? statusCode,  String? message,  DateTime? timestamp)  $default,) {final _that = this;
switch (_that) {
case _GException():
return $default(_that.statusCode,_that.message,_that.timestamp);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? statusCode,  String? message,  DateTime? timestamp)?  $default,) {final _that = this;
switch (_that) {
case _GException() when $default != null:
return $default(_that.statusCode,_that.message,_that.timestamp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(createToJson: false)

class _GException implements GException {
  const _GException({this.statusCode, this.message, this.timestamp});
  factory _GException.fromJson(Map<String, dynamic> json,) => _$GExceptionFromJson(json,);

@override final  int? statusCode;
@override final  String? message;
@override final  DateTime? timestamp;

/// Create a copy of GException
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GExceptionCopyWith<_GException> get copyWith => __$GExceptionCopyWithImpl<_GException>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GException&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode)&&(identical(other.message, message) || other.message == message)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,statusCode,message,timestamp);

@override
String toString() {
  return 'GException(statusCode: $statusCode, message: $message, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class _$GExceptionCopyWith<$Res> implements $GExceptionCopyWith<$Res> {
  factory _$GExceptionCopyWith(_GException value, $Res Function(_GException) _then) = __$GExceptionCopyWithImpl;
@override @useResult
$Res call({
 int? statusCode, String? message, DateTime? timestamp
});




}
/// @nodoc
class __$GExceptionCopyWithImpl<$Res>
    implements _$GExceptionCopyWith<$Res> {
  __$GExceptionCopyWithImpl(this._self, this._then);

  final _GException _self;
  final $Res Function(_GException) _then;

/// Create a copy of GException
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? statusCode = freezed,Object? message = freezed,Object? timestamp = freezed,}) {
  return _then(_GException(
statusCode: freezed == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
