// Este archivo es parte de Python Quizz Flash.
//
// Python Quizz Flash es software libre: puede redistribuirlo y/o modificarlo
// bajo los términos de la Mozilla Public License 2.0 (MPL-2.0).
//
// Copyright (c) 2026 Miriam Carmen Mendieta Racedo
//
// Esta Licencia Pública está disponible en:
// https://mozilla.org/MPL/2.0/
//
// NOTA: Las modificaciones de este archivo deben distribuirse bajo MPL-2.0.
// El código nuevo en archivos separados puede tener otra licencia.
//
// This file is part of Python Quizz Flash.
// Python Quizz Flash is free software: you can redistribute it and/or modify it
// under the terms of the Mozilla Public License 2.0 (MPL-2.0).

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserProfile {

 String get uid; String get name; int get coins; Map<Difficulty, int> get highScores; List<String> get completedExerciseIds; int get currentLevel;
/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserProfileCopyWith<UserProfile> get copyWith => _$UserProfileCopyWithImpl<UserProfile>(this as UserProfile, _$identity);

  /// Serializes this UserProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserProfile&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.name, name) || other.name == name)&&(identical(other.coins, coins) || other.coins == coins)&&const DeepCollectionEquality().equals(other.highScores, highScores)&&const DeepCollectionEquality().equals(other.completedExerciseIds, completedExerciseIds)&&(identical(other.currentLevel, currentLevel) || other.currentLevel == currentLevel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,name,coins,const DeepCollectionEquality().hash(highScores),const DeepCollectionEquality().hash(completedExerciseIds),currentLevel);

@override
String toString() {
  return 'UserProfile(uid: $uid, name: $name, coins: $coins, highScores: $highScores, completedExerciseIds: $completedExerciseIds, currentLevel: $currentLevel)';
}


}

/// @nodoc
abstract mixin class $UserProfileCopyWith<$Res>  {
  factory $UserProfileCopyWith(UserProfile value, $Res Function(UserProfile) _then) = _$UserProfileCopyWithImpl;
@useResult
$Res call({
 String uid, String name, int coins, Map<Difficulty, int> highScores, List<String> completedExerciseIds, int currentLevel
});




}
/// @nodoc
class _$UserProfileCopyWithImpl<$Res>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._self, this._then);

  final UserProfile _self;
  final $Res Function(UserProfile) _then;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uid = null,Object? name = null,Object? coins = null,Object? highScores = null,Object? completedExerciseIds = null,Object? currentLevel = null,}) {
  return _then(_self.copyWith(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,coins: null == coins ? _self.coins : coins // ignore: cast_nullable_to_non_nullable
as int,highScores: null == highScores ? _self.highScores : highScores // ignore: cast_nullable_to_non_nullable
as Map<Difficulty, int>,completedExerciseIds: null == completedExerciseIds ? _self.completedExerciseIds : completedExerciseIds // ignore: cast_nullable_to_non_nullable
as List<String>,currentLevel: null == currentLevel ? _self.currentLevel : currentLevel // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [UserProfile].
extension UserProfilePatterns on UserProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserProfile value)  $default,){
final _that = this;
switch (_that) {
case _UserProfile():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserProfile value)?  $default,){
final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uid,  String name,  int coins,  Map<Difficulty, int> highScores,  List<String> completedExerciseIds,  int currentLevel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that.uid,_that.name,_that.coins,_that.highScores,_that.completedExerciseIds,_that.currentLevel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uid,  String name,  int coins,  Map<Difficulty, int> highScores,  List<String> completedExerciseIds,  int currentLevel)  $default,) {final _that = this;
switch (_that) {
case _UserProfile():
return $default(_that.uid,_that.name,_that.coins,_that.highScores,_that.completedExerciseIds,_that.currentLevel);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uid,  String name,  int coins,  Map<Difficulty, int> highScores,  List<String> completedExerciseIds,  int currentLevel)?  $default,) {final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that.uid,_that.name,_that.coins,_that.highScores,_that.completedExerciseIds,_that.currentLevel);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserProfile implements UserProfile {
  const _UserProfile({required this.uid, this.name = "Coder", this.coins = 0, required final  Map<Difficulty, int> highScores, final  List<String> completedExerciseIds = const [], this.currentLevel = 1}): _highScores = highScores,_completedExerciseIds = completedExerciseIds;
  factory _UserProfile.fromJson(Map<String, dynamic> json) => _$UserProfileFromJson(json);

@override final  String uid;
@override@JsonKey() final  String name;
@override@JsonKey() final  int coins;
 final  Map<Difficulty, int> _highScores;
@override Map<Difficulty, int> get highScores {
  if (_highScores is EqualUnmodifiableMapView) return _highScores;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_highScores);
}

 final  List<String> _completedExerciseIds;
@override@JsonKey() List<String> get completedExerciseIds {
  if (_completedExerciseIds is EqualUnmodifiableListView) return _completedExerciseIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_completedExerciseIds);
}

@override@JsonKey() final  int currentLevel;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserProfileCopyWith<_UserProfile> get copyWith => __$UserProfileCopyWithImpl<_UserProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserProfile&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.name, name) || other.name == name)&&(identical(other.coins, coins) || other.coins == coins)&&const DeepCollectionEquality().equals(other._highScores, _highScores)&&const DeepCollectionEquality().equals(other._completedExerciseIds, _completedExerciseIds)&&(identical(other.currentLevel, currentLevel) || other.currentLevel == currentLevel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,name,coins,const DeepCollectionEquality().hash(_highScores),const DeepCollectionEquality().hash(_completedExerciseIds),currentLevel);

@override
String toString() {
  return 'UserProfile(uid: $uid, name: $name, coins: $coins, highScores: $highScores, completedExerciseIds: $completedExerciseIds, currentLevel: $currentLevel)';
}


}

/// @nodoc
abstract mixin class _$UserProfileCopyWith<$Res> implements $UserProfileCopyWith<$Res> {
  factory _$UserProfileCopyWith(_UserProfile value, $Res Function(_UserProfile) _then) = __$UserProfileCopyWithImpl;
@override @useResult
$Res call({
 String uid, String name, int coins, Map<Difficulty, int> highScores, List<String> completedExerciseIds, int currentLevel
});




}
/// @nodoc
class __$UserProfileCopyWithImpl<$Res>
    implements _$UserProfileCopyWith<$Res> {
  __$UserProfileCopyWithImpl(this._self, this._then);

  final _UserProfile _self;
  final $Res Function(_UserProfile) _then;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uid = null,Object? name = null,Object? coins = null,Object? highScores = null,Object? completedExerciseIds = null,Object? currentLevel = null,}) {
  return _then(_UserProfile(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,coins: null == coins ? _self.coins : coins // ignore: cast_nullable_to_non_nullable
as int,highScores: null == highScores ? _self._highScores : highScores // ignore: cast_nullable_to_non_nullable
as Map<Difficulty, int>,completedExerciseIds: null == completedExerciseIds ? _self._completedExerciseIds : completedExerciseIds // ignore: cast_nullable_to_non_nullable
as List<String>,currentLevel: null == currentLevel ? _self.currentLevel : currentLevel // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
