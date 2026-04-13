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

part of 'level_progress_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LevelProgress implements DiagnosticableTreeMixin {

 bool get basicCompleted;// Nivel básico completado (20 ejercicios)
 bool get challengeBasicCompleted;// Reto del básico superado
 bool get intermediateUnlocked;// Nivel intermedio desbloqueado
 bool get intermediateCompleted;// Nivel intermedio completado
 bool get challengeIntermediateCompleted;// Reto del intermedio superado
 bool get advancedUnlocked;// Nivel avanzado desbloqueado
 bool get advancedCompleted;// Nivel avanzado completado
 int get coinsAfterBasicChallenge;// Monedas guardadas tras pasar reto básico
 int get coinsAfterIntermediateChallenge;// Monedas guardadas tras pasar reto intermedio
 int get coinsAfterBasicLevel;// Monedas al completar nivel básico (sin reto)
 int get coinsAfterIntermediateLevel;// Monedas al completar nivel intermedio (sin reto)
 int get coinsAfterAdvancedLevel;
/// Create a copy of LevelProgress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LevelProgressCopyWith<LevelProgress> get copyWith => _$LevelProgressCopyWithImpl<LevelProgress>(this as LevelProgress, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'LevelProgress'))
    ..add(DiagnosticsProperty('basicCompleted', basicCompleted))..add(DiagnosticsProperty('challengeBasicCompleted', challengeBasicCompleted))..add(DiagnosticsProperty('intermediateUnlocked', intermediateUnlocked))..add(DiagnosticsProperty('intermediateCompleted', intermediateCompleted))..add(DiagnosticsProperty('challengeIntermediateCompleted', challengeIntermediateCompleted))..add(DiagnosticsProperty('advancedUnlocked', advancedUnlocked))..add(DiagnosticsProperty('advancedCompleted', advancedCompleted))..add(DiagnosticsProperty('coinsAfterBasicChallenge', coinsAfterBasicChallenge))..add(DiagnosticsProperty('coinsAfterIntermediateChallenge', coinsAfterIntermediateChallenge))..add(DiagnosticsProperty('coinsAfterBasicLevel', coinsAfterBasicLevel))..add(DiagnosticsProperty('coinsAfterIntermediateLevel', coinsAfterIntermediateLevel))..add(DiagnosticsProperty('coinsAfterAdvancedLevel', coinsAfterAdvancedLevel));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LevelProgress&&(identical(other.basicCompleted, basicCompleted) || other.basicCompleted == basicCompleted)&&(identical(other.challengeBasicCompleted, challengeBasicCompleted) || other.challengeBasicCompleted == challengeBasicCompleted)&&(identical(other.intermediateUnlocked, intermediateUnlocked) || other.intermediateUnlocked == intermediateUnlocked)&&(identical(other.intermediateCompleted, intermediateCompleted) || other.intermediateCompleted == intermediateCompleted)&&(identical(other.challengeIntermediateCompleted, challengeIntermediateCompleted) || other.challengeIntermediateCompleted == challengeIntermediateCompleted)&&(identical(other.advancedUnlocked, advancedUnlocked) || other.advancedUnlocked == advancedUnlocked)&&(identical(other.advancedCompleted, advancedCompleted) || other.advancedCompleted == advancedCompleted)&&(identical(other.coinsAfterBasicChallenge, coinsAfterBasicChallenge) || other.coinsAfterBasicChallenge == coinsAfterBasicChallenge)&&(identical(other.coinsAfterIntermediateChallenge, coinsAfterIntermediateChallenge) || other.coinsAfterIntermediateChallenge == coinsAfterIntermediateChallenge)&&(identical(other.coinsAfterBasicLevel, coinsAfterBasicLevel) || other.coinsAfterBasicLevel == coinsAfterBasicLevel)&&(identical(other.coinsAfterIntermediateLevel, coinsAfterIntermediateLevel) || other.coinsAfterIntermediateLevel == coinsAfterIntermediateLevel)&&(identical(other.coinsAfterAdvancedLevel, coinsAfterAdvancedLevel) || other.coinsAfterAdvancedLevel == coinsAfterAdvancedLevel));
}


@override
int get hashCode => Object.hash(runtimeType,basicCompleted,challengeBasicCompleted,intermediateUnlocked,intermediateCompleted,challengeIntermediateCompleted,advancedUnlocked,advancedCompleted,coinsAfterBasicChallenge,coinsAfterIntermediateChallenge,coinsAfterBasicLevel,coinsAfterIntermediateLevel,coinsAfterAdvancedLevel);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'LevelProgress(basicCompleted: $basicCompleted, challengeBasicCompleted: $challengeBasicCompleted, intermediateUnlocked: $intermediateUnlocked, intermediateCompleted: $intermediateCompleted, challengeIntermediateCompleted: $challengeIntermediateCompleted, advancedUnlocked: $advancedUnlocked, advancedCompleted: $advancedCompleted, coinsAfterBasicChallenge: $coinsAfterBasicChallenge, coinsAfterIntermediateChallenge: $coinsAfterIntermediateChallenge, coinsAfterBasicLevel: $coinsAfterBasicLevel, coinsAfterIntermediateLevel: $coinsAfterIntermediateLevel, coinsAfterAdvancedLevel: $coinsAfterAdvancedLevel)';
}


}

/// @nodoc
abstract mixin class $LevelProgressCopyWith<$Res>  {
  factory $LevelProgressCopyWith(LevelProgress value, $Res Function(LevelProgress) _then) = _$LevelProgressCopyWithImpl;
@useResult
$Res call({
 bool basicCompleted, bool challengeBasicCompleted, bool intermediateUnlocked, bool intermediateCompleted, bool challengeIntermediateCompleted, bool advancedUnlocked, bool advancedCompleted, int coinsAfterBasicChallenge, int coinsAfterIntermediateChallenge, int coinsAfterBasicLevel, int coinsAfterIntermediateLevel, int coinsAfterAdvancedLevel
});




}
/// @nodoc
class _$LevelProgressCopyWithImpl<$Res>
    implements $LevelProgressCopyWith<$Res> {
  _$LevelProgressCopyWithImpl(this._self, this._then);

  final LevelProgress _self;
  final $Res Function(LevelProgress) _then;

/// Create a copy of LevelProgress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? basicCompleted = null,Object? challengeBasicCompleted = null,Object? intermediateUnlocked = null,Object? intermediateCompleted = null,Object? challengeIntermediateCompleted = null,Object? advancedUnlocked = null,Object? advancedCompleted = null,Object? coinsAfterBasicChallenge = null,Object? coinsAfterIntermediateChallenge = null,Object? coinsAfterBasicLevel = null,Object? coinsAfterIntermediateLevel = null,Object? coinsAfterAdvancedLevel = null,}) {
  return _then(_self.copyWith(
basicCompleted: null == basicCompleted ? _self.basicCompleted : basicCompleted // ignore: cast_nullable_to_non_nullable
as bool,challengeBasicCompleted: null == challengeBasicCompleted ? _self.challengeBasicCompleted : challengeBasicCompleted // ignore: cast_nullable_to_non_nullable
as bool,intermediateUnlocked: null == intermediateUnlocked ? _self.intermediateUnlocked : intermediateUnlocked // ignore: cast_nullable_to_non_nullable
as bool,intermediateCompleted: null == intermediateCompleted ? _self.intermediateCompleted : intermediateCompleted // ignore: cast_nullable_to_non_nullable
as bool,challengeIntermediateCompleted: null == challengeIntermediateCompleted ? _self.challengeIntermediateCompleted : challengeIntermediateCompleted // ignore: cast_nullable_to_non_nullable
as bool,advancedUnlocked: null == advancedUnlocked ? _self.advancedUnlocked : advancedUnlocked // ignore: cast_nullable_to_non_nullable
as bool,advancedCompleted: null == advancedCompleted ? _self.advancedCompleted : advancedCompleted // ignore: cast_nullable_to_non_nullable
as bool,coinsAfterBasicChallenge: null == coinsAfterBasicChallenge ? _self.coinsAfterBasicChallenge : coinsAfterBasicChallenge // ignore: cast_nullable_to_non_nullable
as int,coinsAfterIntermediateChallenge: null == coinsAfterIntermediateChallenge ? _self.coinsAfterIntermediateChallenge : coinsAfterIntermediateChallenge // ignore: cast_nullable_to_non_nullable
as int,coinsAfterBasicLevel: null == coinsAfterBasicLevel ? _self.coinsAfterBasicLevel : coinsAfterBasicLevel // ignore: cast_nullable_to_non_nullable
as int,coinsAfterIntermediateLevel: null == coinsAfterIntermediateLevel ? _self.coinsAfterIntermediateLevel : coinsAfterIntermediateLevel // ignore: cast_nullable_to_non_nullable
as int,coinsAfterAdvancedLevel: null == coinsAfterAdvancedLevel ? _self.coinsAfterAdvancedLevel : coinsAfterAdvancedLevel // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [LevelProgress].
extension LevelProgressPatterns on LevelProgress {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LevelProgress value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LevelProgress() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LevelProgress value)  $default,){
final _that = this;
switch (_that) {
case _LevelProgress():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LevelProgress value)?  $default,){
final _that = this;
switch (_that) {
case _LevelProgress() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool basicCompleted,  bool challengeBasicCompleted,  bool intermediateUnlocked,  bool intermediateCompleted,  bool challengeIntermediateCompleted,  bool advancedUnlocked,  bool advancedCompleted,  int coinsAfterBasicChallenge,  int coinsAfterIntermediateChallenge,  int coinsAfterBasicLevel,  int coinsAfterIntermediateLevel,  int coinsAfterAdvancedLevel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LevelProgress() when $default != null:
return $default(_that.basicCompleted,_that.challengeBasicCompleted,_that.intermediateUnlocked,_that.intermediateCompleted,_that.challengeIntermediateCompleted,_that.advancedUnlocked,_that.advancedCompleted,_that.coinsAfterBasicChallenge,_that.coinsAfterIntermediateChallenge,_that.coinsAfterBasicLevel,_that.coinsAfterIntermediateLevel,_that.coinsAfterAdvancedLevel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool basicCompleted,  bool challengeBasicCompleted,  bool intermediateUnlocked,  bool intermediateCompleted,  bool challengeIntermediateCompleted,  bool advancedUnlocked,  bool advancedCompleted,  int coinsAfterBasicChallenge,  int coinsAfterIntermediateChallenge,  int coinsAfterBasicLevel,  int coinsAfterIntermediateLevel,  int coinsAfterAdvancedLevel)  $default,) {final _that = this;
switch (_that) {
case _LevelProgress():
return $default(_that.basicCompleted,_that.challengeBasicCompleted,_that.intermediateUnlocked,_that.intermediateCompleted,_that.challengeIntermediateCompleted,_that.advancedUnlocked,_that.advancedCompleted,_that.coinsAfterBasicChallenge,_that.coinsAfterIntermediateChallenge,_that.coinsAfterBasicLevel,_that.coinsAfterIntermediateLevel,_that.coinsAfterAdvancedLevel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool basicCompleted,  bool challengeBasicCompleted,  bool intermediateUnlocked,  bool intermediateCompleted,  bool challengeIntermediateCompleted,  bool advancedUnlocked,  bool advancedCompleted,  int coinsAfterBasicChallenge,  int coinsAfterIntermediateChallenge,  int coinsAfterBasicLevel,  int coinsAfterIntermediateLevel,  int coinsAfterAdvancedLevel)?  $default,) {final _that = this;
switch (_that) {
case _LevelProgress() when $default != null:
return $default(_that.basicCompleted,_that.challengeBasicCompleted,_that.intermediateUnlocked,_that.intermediateCompleted,_that.challengeIntermediateCompleted,_that.advancedUnlocked,_that.advancedCompleted,_that.coinsAfterBasicChallenge,_that.coinsAfterIntermediateChallenge,_that.coinsAfterBasicLevel,_that.coinsAfterIntermediateLevel,_that.coinsAfterAdvancedLevel);case _:
  return null;

}
}

}

/// @nodoc


class _LevelProgress with DiagnosticableTreeMixin implements LevelProgress {
  const _LevelProgress({this.basicCompleted = false, this.challengeBasicCompleted = false, this.intermediateUnlocked = false, this.intermediateCompleted = false, this.challengeIntermediateCompleted = false, this.advancedUnlocked = false, this.advancedCompleted = false, this.coinsAfterBasicChallenge = 0, this.coinsAfterIntermediateChallenge = 0, this.coinsAfterBasicLevel = 0, this.coinsAfterIntermediateLevel = 0, this.coinsAfterAdvancedLevel = 0});
  

@override@JsonKey() final  bool basicCompleted;
// Nivel básico completado (20 ejercicios)
@override@JsonKey() final  bool challengeBasicCompleted;
// Reto del básico superado
@override@JsonKey() final  bool intermediateUnlocked;
// Nivel intermedio desbloqueado
@override@JsonKey() final  bool intermediateCompleted;
// Nivel intermedio completado
@override@JsonKey() final  bool challengeIntermediateCompleted;
// Reto del intermedio superado
@override@JsonKey() final  bool advancedUnlocked;
// Nivel avanzado desbloqueado
@override@JsonKey() final  bool advancedCompleted;
// Nivel avanzado completado
@override@JsonKey() final  int coinsAfterBasicChallenge;
// Monedas guardadas tras pasar reto básico
@override@JsonKey() final  int coinsAfterIntermediateChallenge;
// Monedas guardadas tras pasar reto intermedio
@override@JsonKey() final  int coinsAfterBasicLevel;
// Monedas al completar nivel básico (sin reto)
@override@JsonKey() final  int coinsAfterIntermediateLevel;
// Monedas al completar nivel intermedio (sin reto)
@override@JsonKey() final  int coinsAfterAdvancedLevel;

/// Create a copy of LevelProgress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LevelProgressCopyWith<_LevelProgress> get copyWith => __$LevelProgressCopyWithImpl<_LevelProgress>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'LevelProgress'))
    ..add(DiagnosticsProperty('basicCompleted', basicCompleted))..add(DiagnosticsProperty('challengeBasicCompleted', challengeBasicCompleted))..add(DiagnosticsProperty('intermediateUnlocked', intermediateUnlocked))..add(DiagnosticsProperty('intermediateCompleted', intermediateCompleted))..add(DiagnosticsProperty('challengeIntermediateCompleted', challengeIntermediateCompleted))..add(DiagnosticsProperty('advancedUnlocked', advancedUnlocked))..add(DiagnosticsProperty('advancedCompleted', advancedCompleted))..add(DiagnosticsProperty('coinsAfterBasicChallenge', coinsAfterBasicChallenge))..add(DiagnosticsProperty('coinsAfterIntermediateChallenge', coinsAfterIntermediateChallenge))..add(DiagnosticsProperty('coinsAfterBasicLevel', coinsAfterBasicLevel))..add(DiagnosticsProperty('coinsAfterIntermediateLevel', coinsAfterIntermediateLevel))..add(DiagnosticsProperty('coinsAfterAdvancedLevel', coinsAfterAdvancedLevel));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LevelProgress&&(identical(other.basicCompleted, basicCompleted) || other.basicCompleted == basicCompleted)&&(identical(other.challengeBasicCompleted, challengeBasicCompleted) || other.challengeBasicCompleted == challengeBasicCompleted)&&(identical(other.intermediateUnlocked, intermediateUnlocked) || other.intermediateUnlocked == intermediateUnlocked)&&(identical(other.intermediateCompleted, intermediateCompleted) || other.intermediateCompleted == intermediateCompleted)&&(identical(other.challengeIntermediateCompleted, challengeIntermediateCompleted) || other.challengeIntermediateCompleted == challengeIntermediateCompleted)&&(identical(other.advancedUnlocked, advancedUnlocked) || other.advancedUnlocked == advancedUnlocked)&&(identical(other.advancedCompleted, advancedCompleted) || other.advancedCompleted == advancedCompleted)&&(identical(other.coinsAfterBasicChallenge, coinsAfterBasicChallenge) || other.coinsAfterBasicChallenge == coinsAfterBasicChallenge)&&(identical(other.coinsAfterIntermediateChallenge, coinsAfterIntermediateChallenge) || other.coinsAfterIntermediateChallenge == coinsAfterIntermediateChallenge)&&(identical(other.coinsAfterBasicLevel, coinsAfterBasicLevel) || other.coinsAfterBasicLevel == coinsAfterBasicLevel)&&(identical(other.coinsAfterIntermediateLevel, coinsAfterIntermediateLevel) || other.coinsAfterIntermediateLevel == coinsAfterIntermediateLevel)&&(identical(other.coinsAfterAdvancedLevel, coinsAfterAdvancedLevel) || other.coinsAfterAdvancedLevel == coinsAfterAdvancedLevel));
}


@override
int get hashCode => Object.hash(runtimeType,basicCompleted,challengeBasicCompleted,intermediateUnlocked,intermediateCompleted,challengeIntermediateCompleted,advancedUnlocked,advancedCompleted,coinsAfterBasicChallenge,coinsAfterIntermediateChallenge,coinsAfterBasicLevel,coinsAfterIntermediateLevel,coinsAfterAdvancedLevel);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'LevelProgress(basicCompleted: $basicCompleted, challengeBasicCompleted: $challengeBasicCompleted, intermediateUnlocked: $intermediateUnlocked, intermediateCompleted: $intermediateCompleted, challengeIntermediateCompleted: $challengeIntermediateCompleted, advancedUnlocked: $advancedUnlocked, advancedCompleted: $advancedCompleted, coinsAfterBasicChallenge: $coinsAfterBasicChallenge, coinsAfterIntermediateChallenge: $coinsAfterIntermediateChallenge, coinsAfterBasicLevel: $coinsAfterBasicLevel, coinsAfterIntermediateLevel: $coinsAfterIntermediateLevel, coinsAfterAdvancedLevel: $coinsAfterAdvancedLevel)';
}


}

/// @nodoc
abstract mixin class _$LevelProgressCopyWith<$Res> implements $LevelProgressCopyWith<$Res> {
  factory _$LevelProgressCopyWith(_LevelProgress value, $Res Function(_LevelProgress) _then) = __$LevelProgressCopyWithImpl;
@override @useResult
$Res call({
 bool basicCompleted, bool challengeBasicCompleted, bool intermediateUnlocked, bool intermediateCompleted, bool challengeIntermediateCompleted, bool advancedUnlocked, bool advancedCompleted, int coinsAfterBasicChallenge, int coinsAfterIntermediateChallenge, int coinsAfterBasicLevel, int coinsAfterIntermediateLevel, int coinsAfterAdvancedLevel
});




}
/// @nodoc
class __$LevelProgressCopyWithImpl<$Res>
    implements _$LevelProgressCopyWith<$Res> {
  __$LevelProgressCopyWithImpl(this._self, this._then);

  final _LevelProgress _self;
  final $Res Function(_LevelProgress) _then;

/// Create a copy of LevelProgress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? basicCompleted = null,Object? challengeBasicCompleted = null,Object? intermediateUnlocked = null,Object? intermediateCompleted = null,Object? challengeIntermediateCompleted = null,Object? advancedUnlocked = null,Object? advancedCompleted = null,Object? coinsAfterBasicChallenge = null,Object? coinsAfterIntermediateChallenge = null,Object? coinsAfterBasicLevel = null,Object? coinsAfterIntermediateLevel = null,Object? coinsAfterAdvancedLevel = null,}) {
  return _then(_LevelProgress(
basicCompleted: null == basicCompleted ? _self.basicCompleted : basicCompleted // ignore: cast_nullable_to_non_nullable
as bool,challengeBasicCompleted: null == challengeBasicCompleted ? _self.challengeBasicCompleted : challengeBasicCompleted // ignore: cast_nullable_to_non_nullable
as bool,intermediateUnlocked: null == intermediateUnlocked ? _self.intermediateUnlocked : intermediateUnlocked // ignore: cast_nullable_to_non_nullable
as bool,intermediateCompleted: null == intermediateCompleted ? _self.intermediateCompleted : intermediateCompleted // ignore: cast_nullable_to_non_nullable
as bool,challengeIntermediateCompleted: null == challengeIntermediateCompleted ? _self.challengeIntermediateCompleted : challengeIntermediateCompleted // ignore: cast_nullable_to_non_nullable
as bool,advancedUnlocked: null == advancedUnlocked ? _self.advancedUnlocked : advancedUnlocked // ignore: cast_nullable_to_non_nullable
as bool,advancedCompleted: null == advancedCompleted ? _self.advancedCompleted : advancedCompleted // ignore: cast_nullable_to_non_nullable
as bool,coinsAfterBasicChallenge: null == coinsAfterBasicChallenge ? _self.coinsAfterBasicChallenge : coinsAfterBasicChallenge // ignore: cast_nullable_to_non_nullable
as int,coinsAfterIntermediateChallenge: null == coinsAfterIntermediateChallenge ? _self.coinsAfterIntermediateChallenge : coinsAfterIntermediateChallenge // ignore: cast_nullable_to_non_nullable
as int,coinsAfterBasicLevel: null == coinsAfterBasicLevel ? _self.coinsAfterBasicLevel : coinsAfterBasicLevel // ignore: cast_nullable_to_non_nullable
as int,coinsAfterIntermediateLevel: null == coinsAfterIntermediateLevel ? _self.coinsAfterIntermediateLevel : coinsAfterIntermediateLevel // ignore: cast_nullable_to_non_nullable
as int,coinsAfterAdvancedLevel: null == coinsAfterAdvancedLevel ? _self.coinsAfterAdvancedLevel : coinsAfterAdvancedLevel // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
