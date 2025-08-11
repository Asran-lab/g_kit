// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'g_auth_token.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GAuthToken {

 String get userId; String get accessToken; String get refreshToken; DateTime? get accessTokenExpiry; DateTime? get refreshTokenExpiry;
/// Create a copy of GAuthToken
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GAuthTokenCopyWith<GAuthToken> get copyWith => _$GAuthTokenCopyWithImpl<GAuthToken>(this as GAuthToken, _$identity);

  /// Serializes this GAuthToken to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GAuthToken&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.accessTokenExpiry, accessTokenExpiry) || other.accessTokenExpiry == accessTokenExpiry)&&(identical(other.refreshTokenExpiry, refreshTokenExpiry) || other.refreshTokenExpiry == refreshTokenExpiry));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,accessToken,refreshToken,accessTokenExpiry,refreshTokenExpiry);

@override
String toString() {
  return 'GAuthToken(userId: $userId, accessToken: $accessToken, refreshToken: $refreshToken, accessTokenExpiry: $accessTokenExpiry, refreshTokenExpiry: $refreshTokenExpiry)';
}


}

/// @nodoc
abstract mixin class $GAuthTokenCopyWith<$Res>  {
  factory $GAuthTokenCopyWith(GAuthToken value, $Res Function(GAuthToken) _then) = _$GAuthTokenCopyWithImpl;
@useResult
$Res call({
 String userId, String accessToken, String refreshToken, DateTime? accessTokenExpiry, DateTime? refreshTokenExpiry
});




}
/// @nodoc
class _$GAuthTokenCopyWithImpl<$Res>
    implements $GAuthTokenCopyWith<$Res> {
  _$GAuthTokenCopyWithImpl(this._self, this._then);

  final GAuthToken _self;
  final $Res Function(GAuthToken) _then;

/// Create a copy of GAuthToken
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? accessToken = null,Object? refreshToken = null,Object? accessTokenExpiry = freezed,Object? refreshTokenExpiry = freezed,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,accessTokenExpiry: freezed == accessTokenExpiry ? _self.accessTokenExpiry : accessTokenExpiry // ignore: cast_nullable_to_non_nullable
as DateTime?,refreshTokenExpiry: freezed == refreshTokenExpiry ? _self.refreshTokenExpiry : refreshTokenExpiry // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [GAuthToken].
extension GAuthTokenPatterns on GAuthToken {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GAuthToken value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GAuthToken() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GAuthToken value)  $default,){
final _that = this;
switch (_that) {
case _GAuthToken():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GAuthToken value)?  $default,){
final _that = this;
switch (_that) {
case _GAuthToken() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String accessToken,  String refreshToken,  DateTime? accessTokenExpiry,  DateTime? refreshTokenExpiry)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GAuthToken() when $default != null:
return $default(_that.userId,_that.accessToken,_that.refreshToken,_that.accessTokenExpiry,_that.refreshTokenExpiry);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String accessToken,  String refreshToken,  DateTime? accessTokenExpiry,  DateTime? refreshTokenExpiry)  $default,) {final _that = this;
switch (_that) {
case _GAuthToken():
return $default(_that.userId,_that.accessToken,_that.refreshToken,_that.accessTokenExpiry,_that.refreshTokenExpiry);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String accessToken,  String refreshToken,  DateTime? accessTokenExpiry,  DateTime? refreshTokenExpiry)?  $default,) {final _that = this;
switch (_that) {
case _GAuthToken() when $default != null:
return $default(_that.userId,_that.accessToken,_that.refreshToken,_that.accessTokenExpiry,_that.refreshTokenExpiry);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GAuthToken implements GAuthToken {
   _GAuthToken({required this.userId, required this.accessToken, required this.refreshToken, this.accessTokenExpiry, this.refreshTokenExpiry});
  factory _GAuthToken.fromJson(Map<String, dynamic> json,) => _$GAuthTokenFromJson(json,);

@override final  String userId;
@override final  String accessToken;
@override final  String refreshToken;
@override final  DateTime? accessTokenExpiry;
@override final  DateTime? refreshTokenExpiry;

/// Create a copy of GAuthToken
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GAuthTokenCopyWith<_GAuthToken> get copyWith => __$GAuthTokenCopyWithImpl<_GAuthToken>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GAuthTokenToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GAuthToken&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.accessTokenExpiry, accessTokenExpiry) || other.accessTokenExpiry == accessTokenExpiry)&&(identical(other.refreshTokenExpiry, refreshTokenExpiry) || other.refreshTokenExpiry == refreshTokenExpiry));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,accessToken,refreshToken,accessTokenExpiry,refreshTokenExpiry);

@override
String toString() {
  return 'GAuthToken(userId: $userId, accessToken: $accessToken, refreshToken: $refreshToken, accessTokenExpiry: $accessTokenExpiry, refreshTokenExpiry: $refreshTokenExpiry)';
}


}

/// @nodoc
abstract mixin class _$GAuthTokenCopyWith<$Res> implements $GAuthTokenCopyWith<$Res> {
  factory _$GAuthTokenCopyWith(_GAuthToken value, $Res Function(_GAuthToken) _then) = __$GAuthTokenCopyWithImpl;
@override @useResult
$Res call({
 String userId, String accessToken, String refreshToken, DateTime? accessTokenExpiry, DateTime? refreshTokenExpiry
});




}
/// @nodoc
class __$GAuthTokenCopyWithImpl<$Res>
    implements _$GAuthTokenCopyWith<$Res> {
  __$GAuthTokenCopyWithImpl(this._self, this._then);

  final _GAuthToken _self;
  final $Res Function(_GAuthToken) _then;

/// Create a copy of GAuthToken
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? accessToken = null,Object? refreshToken = null,Object? accessTokenExpiry = freezed,Object? refreshTokenExpiry = freezed,}) {
  return _then(_GAuthToken(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,accessTokenExpiry: freezed == accessTokenExpiry ? _self.accessTokenExpiry : accessTokenExpiry // ignore: cast_nullable_to_non_nullable
as DateTime?,refreshTokenExpiry: freezed == refreshTokenExpiry ? _self.refreshTokenExpiry : refreshTokenExpiry // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
