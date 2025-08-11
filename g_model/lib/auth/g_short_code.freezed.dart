// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'g_short_code.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GShortCode {

 String get code; String get hashedCode; DateTime get createdAt; DateTime get expiresAt; int get attempts; int get maxAttempts; bool get isActive;
/// Create a copy of GShortCode
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GShortCodeCopyWith<GShortCode> get copyWith => _$GShortCodeCopyWithImpl<GShortCode>(this as GShortCode, _$identity);

  /// Serializes this GShortCode to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GShortCode&&(identical(other.code, code) || other.code == code)&&(identical(other.hashedCode, hashedCode) || other.hashedCode == hashedCode)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.attempts, attempts) || other.attempts == attempts)&&(identical(other.maxAttempts, maxAttempts) || other.maxAttempts == maxAttempts)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,hashedCode,createdAt,expiresAt,attempts,maxAttempts,isActive);

@override
String toString() {
  return 'GShortCode(code: $code, hashedCode: $hashedCode, createdAt: $createdAt, expiresAt: $expiresAt, attempts: $attempts, maxAttempts: $maxAttempts, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $GShortCodeCopyWith<$Res>  {
  factory $GShortCodeCopyWith(GShortCode value, $Res Function(GShortCode) _then) = _$GShortCodeCopyWithImpl;
@useResult
$Res call({
 String code, String hashedCode, DateTime createdAt, DateTime expiresAt, int attempts, int maxAttempts, bool isActive
});




}
/// @nodoc
class _$GShortCodeCopyWithImpl<$Res>
    implements $GShortCodeCopyWith<$Res> {
  _$GShortCodeCopyWithImpl(this._self, this._then);

  final GShortCode _self;
  final $Res Function(GShortCode) _then;

/// Create a copy of GShortCode
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? hashedCode = null,Object? createdAt = null,Object? expiresAt = null,Object? attempts = null,Object? maxAttempts = null,Object? isActive = null,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,hashedCode: null == hashedCode ? _self.hashedCode : hashedCode // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,attempts: null == attempts ? _self.attempts : attempts // ignore: cast_nullable_to_non_nullable
as int,maxAttempts: null == maxAttempts ? _self.maxAttempts : maxAttempts // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [GShortCode].
extension GShortCodePatterns on GShortCode {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GShortCode value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GShortCode() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GShortCode value)  $default,){
final _that = this;
switch (_that) {
case _GShortCode():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GShortCode value)?  $default,){
final _that = this;
switch (_that) {
case _GShortCode() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  String hashedCode,  DateTime createdAt,  DateTime expiresAt,  int attempts,  int maxAttempts,  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GShortCode() when $default != null:
return $default(_that.code,_that.hashedCode,_that.createdAt,_that.expiresAt,_that.attempts,_that.maxAttempts,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  String hashedCode,  DateTime createdAt,  DateTime expiresAt,  int attempts,  int maxAttempts,  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _GShortCode():
return $default(_that.code,_that.hashedCode,_that.createdAt,_that.expiresAt,_that.attempts,_that.maxAttempts,_that.isActive);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  String hashedCode,  DateTime createdAt,  DateTime expiresAt,  int attempts,  int maxAttempts,  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _GShortCode() when $default != null:
return $default(_that.code,_that.hashedCode,_that.createdAt,_that.expiresAt,_that.attempts,_that.maxAttempts,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GShortCode implements GShortCode {
   _GShortCode({required this.code, required this.hashedCode, required this.createdAt, required this.expiresAt, this.attempts = 0, this.maxAttempts = 3, this.isActive = true});
  factory _GShortCode.fromJson(Map<String, dynamic> json) => _$GShortCodeFromJson(json);

@override final  String code;
@override final  String hashedCode;
@override final  DateTime createdAt;
@override final  DateTime expiresAt;
@override@JsonKey() final  int attempts;
@override@JsonKey() final  int maxAttempts;
@override@JsonKey() final  bool isActive;

/// Create a copy of GShortCode
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GShortCodeCopyWith<_GShortCode> get copyWith => __$GShortCodeCopyWithImpl<_GShortCode>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GShortCodeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GShortCode&&(identical(other.code, code) || other.code == code)&&(identical(other.hashedCode, hashedCode) || other.hashedCode == hashedCode)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.attempts, attempts) || other.attempts == attempts)&&(identical(other.maxAttempts, maxAttempts) || other.maxAttempts == maxAttempts)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,hashedCode,createdAt,expiresAt,attempts,maxAttempts,isActive);

@override
String toString() {
  return 'GShortCode(code: $code, hashedCode: $hashedCode, createdAt: $createdAt, expiresAt: $expiresAt, attempts: $attempts, maxAttempts: $maxAttempts, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$GShortCodeCopyWith<$Res> implements $GShortCodeCopyWith<$Res> {
  factory _$GShortCodeCopyWith(_GShortCode value, $Res Function(_GShortCode) _then) = __$GShortCodeCopyWithImpl;
@override @useResult
$Res call({
 String code, String hashedCode, DateTime createdAt, DateTime expiresAt, int attempts, int maxAttempts, bool isActive
});




}
/// @nodoc
class __$GShortCodeCopyWithImpl<$Res>
    implements _$GShortCodeCopyWith<$Res> {
  __$GShortCodeCopyWithImpl(this._self, this._then);

  final _GShortCode _self;
  final $Res Function(_GShortCode) _then;

/// Create a copy of GShortCode
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? hashedCode = null,Object? createdAt = null,Object? expiresAt = null,Object? attempts = null,Object? maxAttempts = null,Object? isActive = null,}) {
  return _then(_GShortCode(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,hashedCode: null == hashedCode ? _self.hashedCode : hashedCode // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,attempts: null == attempts ? _self.attempts : attempts // ignore: cast_nullable_to_non_nullable
as int,maxAttempts: null == maxAttempts ? _self.maxAttempts : maxAttempts // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$GShortCodeRequest {

 String get code; String get deviceKeyHash;
/// Create a copy of GShortCodeRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GShortCodeRequestCopyWith<GShortCodeRequest> get copyWith => _$GShortCodeRequestCopyWithImpl<GShortCodeRequest>(this as GShortCodeRequest, _$identity);

  /// Serializes this GShortCodeRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GShortCodeRequest&&(identical(other.code, code) || other.code == code)&&(identical(other.deviceKeyHash, deviceKeyHash) || other.deviceKeyHash == deviceKeyHash));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,deviceKeyHash);

@override
String toString() {
  return 'GShortCodeRequest(code: $code, deviceKeyHash: $deviceKeyHash)';
}


}

/// @nodoc
abstract mixin class $GShortCodeRequestCopyWith<$Res>  {
  factory $GShortCodeRequestCopyWith(GShortCodeRequest value, $Res Function(GShortCodeRequest) _then) = _$GShortCodeRequestCopyWithImpl;
@useResult
$Res call({
 String code, String deviceKeyHash
});




}
/// @nodoc
class _$GShortCodeRequestCopyWithImpl<$Res>
    implements $GShortCodeRequestCopyWith<$Res> {
  _$GShortCodeRequestCopyWithImpl(this._self, this._then);

  final GShortCodeRequest _self;
  final $Res Function(GShortCodeRequest) _then;

/// Create a copy of GShortCodeRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? deviceKeyHash = null,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,deviceKeyHash: null == deviceKeyHash ? _self.deviceKeyHash : deviceKeyHash // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GShortCodeRequest].
extension GShortCodeRequestPatterns on GShortCodeRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GShortCodeRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GShortCodeRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GShortCodeRequest value)  $default,){
final _that = this;
switch (_that) {
case _GShortCodeRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GShortCodeRequest value)?  $default,){
final _that = this;
switch (_that) {
case _GShortCodeRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  String deviceKeyHash)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GShortCodeRequest() when $default != null:
return $default(_that.code,_that.deviceKeyHash);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  String deviceKeyHash)  $default,) {final _that = this;
switch (_that) {
case _GShortCodeRequest():
return $default(_that.code,_that.deviceKeyHash);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  String deviceKeyHash)?  $default,) {final _that = this;
switch (_that) {
case _GShortCodeRequest() when $default != null:
return $default(_that.code,_that.deviceKeyHash);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GShortCodeRequest implements GShortCodeRequest {
   _GShortCodeRequest({required this.code, required this.deviceKeyHash});
  factory _GShortCodeRequest.fromJson(Map<String, dynamic> json) => _$GShortCodeRequestFromJson(json);

@override final  String code;
@override final  String deviceKeyHash;

/// Create a copy of GShortCodeRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GShortCodeRequestCopyWith<_GShortCodeRequest> get copyWith => __$GShortCodeRequestCopyWithImpl<_GShortCodeRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GShortCodeRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GShortCodeRequest&&(identical(other.code, code) || other.code == code)&&(identical(other.deviceKeyHash, deviceKeyHash) || other.deviceKeyHash == deviceKeyHash));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,deviceKeyHash);

@override
String toString() {
  return 'GShortCodeRequest(code: $code, deviceKeyHash: $deviceKeyHash)';
}


}

/// @nodoc
abstract mixin class _$GShortCodeRequestCopyWith<$Res> implements $GShortCodeRequestCopyWith<$Res> {
  factory _$GShortCodeRequestCopyWith(_GShortCodeRequest value, $Res Function(_GShortCodeRequest) _then) = __$GShortCodeRequestCopyWithImpl;
@override @useResult
$Res call({
 String code, String deviceKeyHash
});




}
/// @nodoc
class __$GShortCodeRequestCopyWithImpl<$Res>
    implements _$GShortCodeRequestCopyWith<$Res> {
  __$GShortCodeRequestCopyWithImpl(this._self, this._then);

  final _GShortCodeRequest _self;
  final $Res Function(_GShortCodeRequest) _then;

/// Create a copy of GShortCodeRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? deviceKeyHash = null,}) {
  return _then(_GShortCodeRequest(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,deviceKeyHash: null == deviceKeyHash ? _self.deviceKeyHash : deviceKeyHash // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$GNonceResponse {

 String get nonce; DateTime get expiresAt;
/// Create a copy of GNonceResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GNonceResponseCopyWith<GNonceResponse> get copyWith => _$GNonceResponseCopyWithImpl<GNonceResponse>(this as GNonceResponse, _$identity);

  /// Serializes this GNonceResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GNonceResponse&&(identical(other.nonce, nonce) || other.nonce == nonce)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nonce,expiresAt);

@override
String toString() {
  return 'GNonceResponse(nonce: $nonce, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class $GNonceResponseCopyWith<$Res>  {
  factory $GNonceResponseCopyWith(GNonceResponse value, $Res Function(GNonceResponse) _then) = _$GNonceResponseCopyWithImpl;
@useResult
$Res call({
 String nonce, DateTime expiresAt
});




}
/// @nodoc
class _$GNonceResponseCopyWithImpl<$Res>
    implements $GNonceResponseCopyWith<$Res> {
  _$GNonceResponseCopyWithImpl(this._self, this._then);

  final GNonceResponse _self;
  final $Res Function(GNonceResponse) _then;

/// Create a copy of GNonceResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? nonce = null,Object? expiresAt = null,}) {
  return _then(_self.copyWith(
nonce: null == nonce ? _self.nonce : nonce // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [GNonceResponse].
extension GNonceResponsePatterns on GNonceResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GNonceResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GNonceResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GNonceResponse value)  $default,){
final _that = this;
switch (_that) {
case _GNonceResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GNonceResponse value)?  $default,){
final _that = this;
switch (_that) {
case _GNonceResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String nonce,  DateTime expiresAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GNonceResponse() when $default != null:
return $default(_that.nonce,_that.expiresAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String nonce,  DateTime expiresAt)  $default,) {final _that = this;
switch (_that) {
case _GNonceResponse():
return $default(_that.nonce,_that.expiresAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String nonce,  DateTime expiresAt)?  $default,) {final _that = this;
switch (_that) {
case _GNonceResponse() when $default != null:
return $default(_that.nonce,_that.expiresAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GNonceResponse implements GNonceResponse {
   _GNonceResponse({required this.nonce, required this.expiresAt});
  factory _GNonceResponse.fromJson(Map<String, dynamic> json) => _$GNonceResponseFromJson(json);

@override final  String nonce;
@override final  DateTime expiresAt;

/// Create a copy of GNonceResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GNonceResponseCopyWith<_GNonceResponse> get copyWith => __$GNonceResponseCopyWithImpl<_GNonceResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GNonceResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GNonceResponse&&(identical(other.nonce, nonce) || other.nonce == nonce)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nonce,expiresAt);

@override
String toString() {
  return 'GNonceResponse(nonce: $nonce, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class _$GNonceResponseCopyWith<$Res> implements $GNonceResponseCopyWith<$Res> {
  factory _$GNonceResponseCopyWith(_GNonceResponse value, $Res Function(_GNonceResponse) _then) = __$GNonceResponseCopyWithImpl;
@override @useResult
$Res call({
 String nonce, DateTime expiresAt
});




}
/// @nodoc
class __$GNonceResponseCopyWithImpl<$Res>
    implements _$GNonceResponseCopyWith<$Res> {
  __$GNonceResponseCopyWithImpl(this._self, this._then);

  final _GNonceResponse _self;
  final $Res Function(_GNonceResponse) _then;

/// Create a copy of GNonceResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? nonce = null,Object? expiresAt = null,}) {
  return _then(_GNonceResponse(
nonce: null == nonce ? _self.nonce : nonce // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$GSignatureRequest {

 String get code; String get deviceKeyHash; String get nonce; String get signature;
/// Create a copy of GSignatureRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GSignatureRequestCopyWith<GSignatureRequest> get copyWith => _$GSignatureRequestCopyWithImpl<GSignatureRequest>(this as GSignatureRequest, _$identity);

  /// Serializes this GSignatureRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GSignatureRequest&&(identical(other.code, code) || other.code == code)&&(identical(other.deviceKeyHash, deviceKeyHash) || other.deviceKeyHash == deviceKeyHash)&&(identical(other.nonce, nonce) || other.nonce == nonce)&&(identical(other.signature, signature) || other.signature == signature));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,deviceKeyHash,nonce,signature);

@override
String toString() {
  return 'GSignatureRequest(code: $code, deviceKeyHash: $deviceKeyHash, nonce: $nonce, signature: $signature)';
}


}

/// @nodoc
abstract mixin class $GSignatureRequestCopyWith<$Res>  {
  factory $GSignatureRequestCopyWith(GSignatureRequest value, $Res Function(GSignatureRequest) _then) = _$GSignatureRequestCopyWithImpl;
@useResult
$Res call({
 String code, String deviceKeyHash, String nonce, String signature
});




}
/// @nodoc
class _$GSignatureRequestCopyWithImpl<$Res>
    implements $GSignatureRequestCopyWith<$Res> {
  _$GSignatureRequestCopyWithImpl(this._self, this._then);

  final GSignatureRequest _self;
  final $Res Function(GSignatureRequest) _then;

/// Create a copy of GSignatureRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? deviceKeyHash = null,Object? nonce = null,Object? signature = null,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,deviceKeyHash: null == deviceKeyHash ? _self.deviceKeyHash : deviceKeyHash // ignore: cast_nullable_to_non_nullable
as String,nonce: null == nonce ? _self.nonce : nonce // ignore: cast_nullable_to_non_nullable
as String,signature: null == signature ? _self.signature : signature // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GSignatureRequest].
extension GSignatureRequestPatterns on GSignatureRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GSignatureRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GSignatureRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GSignatureRequest value)  $default,){
final _that = this;
switch (_that) {
case _GSignatureRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GSignatureRequest value)?  $default,){
final _that = this;
switch (_that) {
case _GSignatureRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  String deviceKeyHash,  String nonce,  String signature)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GSignatureRequest() when $default != null:
return $default(_that.code,_that.deviceKeyHash,_that.nonce,_that.signature);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  String deviceKeyHash,  String nonce,  String signature)  $default,) {final _that = this;
switch (_that) {
case _GSignatureRequest():
return $default(_that.code,_that.deviceKeyHash,_that.nonce,_that.signature);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  String deviceKeyHash,  String nonce,  String signature)?  $default,) {final _that = this;
switch (_that) {
case _GSignatureRequest() when $default != null:
return $default(_that.code,_that.deviceKeyHash,_that.nonce,_that.signature);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GSignatureRequest implements GSignatureRequest {
   _GSignatureRequest({required this.code, required this.deviceKeyHash, required this.nonce, required this.signature});
  factory _GSignatureRequest.fromJson(Map<String, dynamic> json) => _$GSignatureRequestFromJson(json);

@override final  String code;
@override final  String deviceKeyHash;
@override final  String nonce;
@override final  String signature;

/// Create a copy of GSignatureRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GSignatureRequestCopyWith<_GSignatureRequest> get copyWith => __$GSignatureRequestCopyWithImpl<_GSignatureRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GSignatureRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GSignatureRequest&&(identical(other.code, code) || other.code == code)&&(identical(other.deviceKeyHash, deviceKeyHash) || other.deviceKeyHash == deviceKeyHash)&&(identical(other.nonce, nonce) || other.nonce == nonce)&&(identical(other.signature, signature) || other.signature == signature));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,deviceKeyHash,nonce,signature);

@override
String toString() {
  return 'GSignatureRequest(code: $code, deviceKeyHash: $deviceKeyHash, nonce: $nonce, signature: $signature)';
}


}

/// @nodoc
abstract mixin class _$GSignatureRequestCopyWith<$Res> implements $GSignatureRequestCopyWith<$Res> {
  factory _$GSignatureRequestCopyWith(_GSignatureRequest value, $Res Function(_GSignatureRequest) _then) = __$GSignatureRequestCopyWithImpl;
@override @useResult
$Res call({
 String code, String deviceKeyHash, String nonce, String signature
});




}
/// @nodoc
class __$GSignatureRequestCopyWithImpl<$Res>
    implements _$GSignatureRequestCopyWith<$Res> {
  __$GSignatureRequestCopyWithImpl(this._self, this._then);

  final _GSignatureRequest _self;
  final $Res Function(_GSignatureRequest) _then;

/// Create a copy of GSignatureRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? deviceKeyHash = null,Object? nonce = null,Object? signature = null,}) {
  return _then(_GSignatureRequest(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,deviceKeyHash: null == deviceKeyHash ? _self.deviceKeyHash : deviceKeyHash // ignore: cast_nullable_to_non_nullable
as String,nonce: null == nonce ? _self.nonce : nonce // ignore: cast_nullable_to_non_nullable
as String,signature: null == signature ? _self.signature : signature // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$GDeviceInfo {

 String get deviceId; String get platform; String get osVersion; String get appVersion; DateTime? get lastActiveAt;
/// Create a copy of GDeviceInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GDeviceInfoCopyWith<GDeviceInfo> get copyWith => _$GDeviceInfoCopyWithImpl<GDeviceInfo>(this as GDeviceInfo, _$identity);

  /// Serializes this GDeviceInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GDeviceInfo&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.osVersion, osVersion) || other.osVersion == osVersion)&&(identical(other.appVersion, appVersion) || other.appVersion == appVersion)&&(identical(other.lastActiveAt, lastActiveAt) || other.lastActiveAt == lastActiveAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,deviceId,platform,osVersion,appVersion,lastActiveAt);

@override
String toString() {
  return 'GDeviceInfo(deviceId: $deviceId, platform: $platform, osVersion: $osVersion, appVersion: $appVersion, lastActiveAt: $lastActiveAt)';
}


}

/// @nodoc
abstract mixin class $GDeviceInfoCopyWith<$Res>  {
  factory $GDeviceInfoCopyWith(GDeviceInfo value, $Res Function(GDeviceInfo) _then) = _$GDeviceInfoCopyWithImpl;
@useResult
$Res call({
 String deviceId, String platform, String osVersion, String appVersion, DateTime? lastActiveAt
});




}
/// @nodoc
class _$GDeviceInfoCopyWithImpl<$Res>
    implements $GDeviceInfoCopyWith<$Res> {
  _$GDeviceInfoCopyWithImpl(this._self, this._then);

  final GDeviceInfo _self;
  final $Res Function(GDeviceInfo) _then;

/// Create a copy of GDeviceInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? deviceId = null,Object? platform = null,Object? osVersion = null,Object? appVersion = null,Object? lastActiveAt = freezed,}) {
  return _then(_self.copyWith(
deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String,osVersion: null == osVersion ? _self.osVersion : osVersion // ignore: cast_nullable_to_non_nullable
as String,appVersion: null == appVersion ? _self.appVersion : appVersion // ignore: cast_nullable_to_non_nullable
as String,lastActiveAt: freezed == lastActiveAt ? _self.lastActiveAt : lastActiveAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [GDeviceInfo].
extension GDeviceInfoPatterns on GDeviceInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GDeviceInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GDeviceInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GDeviceInfo value)  $default,){
final _that = this;
switch (_that) {
case _GDeviceInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GDeviceInfo value)?  $default,){
final _that = this;
switch (_that) {
case _GDeviceInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String deviceId,  String platform,  String osVersion,  String appVersion,  DateTime? lastActiveAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GDeviceInfo() when $default != null:
return $default(_that.deviceId,_that.platform,_that.osVersion,_that.appVersion,_that.lastActiveAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String deviceId,  String platform,  String osVersion,  String appVersion,  DateTime? lastActiveAt)  $default,) {final _that = this;
switch (_that) {
case _GDeviceInfo():
return $default(_that.deviceId,_that.platform,_that.osVersion,_that.appVersion,_that.lastActiveAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String deviceId,  String platform,  String osVersion,  String appVersion,  DateTime? lastActiveAt)?  $default,) {final _that = this;
switch (_that) {
case _GDeviceInfo() when $default != null:
return $default(_that.deviceId,_that.platform,_that.osVersion,_that.appVersion,_that.lastActiveAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GDeviceInfo implements GDeviceInfo {
   _GDeviceInfo({required this.deviceId, required this.platform, required this.osVersion, required this.appVersion, this.lastActiveAt});
  factory _GDeviceInfo.fromJson(Map<String, dynamic> json) => _$GDeviceInfoFromJson(json);

@override final  String deviceId;
@override final  String platform;
@override final  String osVersion;
@override final  String appVersion;
@override final  DateTime? lastActiveAt;

/// Create a copy of GDeviceInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GDeviceInfoCopyWith<_GDeviceInfo> get copyWith => __$GDeviceInfoCopyWithImpl<_GDeviceInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GDeviceInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GDeviceInfo&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.osVersion, osVersion) || other.osVersion == osVersion)&&(identical(other.appVersion, appVersion) || other.appVersion == appVersion)&&(identical(other.lastActiveAt, lastActiveAt) || other.lastActiveAt == lastActiveAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,deviceId,platform,osVersion,appVersion,lastActiveAt);

@override
String toString() {
  return 'GDeviceInfo(deviceId: $deviceId, platform: $platform, osVersion: $osVersion, appVersion: $appVersion, lastActiveAt: $lastActiveAt)';
}


}

/// @nodoc
abstract mixin class _$GDeviceInfoCopyWith<$Res> implements $GDeviceInfoCopyWith<$Res> {
  factory _$GDeviceInfoCopyWith(_GDeviceInfo value, $Res Function(_GDeviceInfo) _then) = __$GDeviceInfoCopyWithImpl;
@override @useResult
$Res call({
 String deviceId, String platform, String osVersion, String appVersion, DateTime? lastActiveAt
});




}
/// @nodoc
class __$GDeviceInfoCopyWithImpl<$Res>
    implements _$GDeviceInfoCopyWith<$Res> {
  __$GDeviceInfoCopyWithImpl(this._self, this._then);

  final _GDeviceInfo _self;
  final $Res Function(_GDeviceInfo) _then;

/// Create a copy of GDeviceInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? deviceId = null,Object? platform = null,Object? osVersion = null,Object? appVersion = null,Object? lastActiveAt = freezed,}) {
  return _then(_GDeviceInfo(
deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String,osVersion: null == osVersion ? _self.osVersion : osVersion // ignore: cast_nullable_to_non_nullable
as String,appVersion: null == appVersion ? _self.appVersion : appVersion // ignore: cast_nullable_to_non_nullable
as String,lastActiveAt: freezed == lastActiveAt ? _self.lastActiveAt : lastActiveAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
