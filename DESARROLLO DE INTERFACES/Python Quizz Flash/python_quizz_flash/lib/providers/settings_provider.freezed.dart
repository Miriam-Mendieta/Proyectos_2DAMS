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

part of 'settings_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppSettings {

 bool get musicEnabled;// Música activa.
 bool get sfxEnabled;// Efectos activos.
 bool get vibrationEnabled;// Vibración activa.
 bool get notificationsEnabled;// Alertas activas.
 String get language;
/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppSettingsCopyWith<AppSettings> get copyWith => _$AppSettingsCopyWithImpl<AppSettings>(this as AppSettings, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppSettings&&(identical(other.musicEnabled, musicEnabled) || other.musicEnabled == musicEnabled)&&(identical(other.sfxEnabled, sfxEnabled) || other.sfxEnabled == sfxEnabled)&&(identical(other.vibrationEnabled, vibrationEnabled) || other.vibrationEnabled == vibrationEnabled)&&(identical(other.notificationsEnabled, notificationsEnabled) || other.notificationsEnabled == notificationsEnabled)&&(identical(other.language, language) || other.language == language));
}


@override
int get hashCode => Object.hash(runtimeType,musicEnabled,sfxEnabled,vibrationEnabled,notificationsEnabled,language);

@override
String toString() {
  return 'AppSettings(musicEnabled: $musicEnabled, sfxEnabled: $sfxEnabled, vibrationEnabled: $vibrationEnabled, notificationsEnabled: $notificationsEnabled, language: $language)';
}


}

/// @nodoc
abstract mixin class $AppSettingsCopyWith<$Res>  {
  factory $AppSettingsCopyWith(AppSettings value, $Res Function(AppSettings) _then) = _$AppSettingsCopyWithImpl;
@useResult
$Res call({
 bool musicEnabled, bool sfxEnabled, bool vibrationEnabled, bool notificationsEnabled, String language
});




}
/// @nodoc
class _$AppSettingsCopyWithImpl<$Res>
    implements $AppSettingsCopyWith<$Res> {
  _$AppSettingsCopyWithImpl(this._self, this._then);

  final AppSettings _self;
  final $Res Function(AppSettings) _then;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? musicEnabled = null,Object? sfxEnabled = null,Object? vibrationEnabled = null,Object? notificationsEnabled = null,Object? language = null,}) {
  return _then(_self.copyWith(
musicEnabled: null == musicEnabled ? _self.musicEnabled : musicEnabled // ignore: cast_nullable_to_non_nullable
as bool,sfxEnabled: null == sfxEnabled ? _self.sfxEnabled : sfxEnabled // ignore: cast_nullable_to_non_nullable
as bool,vibrationEnabled: null == vibrationEnabled ? _self.vibrationEnabled : vibrationEnabled // ignore: cast_nullable_to_non_nullable
as bool,notificationsEnabled: null == notificationsEnabled ? _self.notificationsEnabled : notificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AppSettings].
extension AppSettingsPatterns on AppSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppSettings value)  $default,){
final _that = this;
switch (_that) {
case _AppSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppSettings value)?  $default,){
final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool musicEnabled,  bool sfxEnabled,  bool vibrationEnabled,  bool notificationsEnabled,  String language)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
return $default(_that.musicEnabled,_that.sfxEnabled,_that.vibrationEnabled,_that.notificationsEnabled,_that.language);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool musicEnabled,  bool sfxEnabled,  bool vibrationEnabled,  bool notificationsEnabled,  String language)  $default,) {final _that = this;
switch (_that) {
case _AppSettings():
return $default(_that.musicEnabled,_that.sfxEnabled,_that.vibrationEnabled,_that.notificationsEnabled,_that.language);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool musicEnabled,  bool sfxEnabled,  bool vibrationEnabled,  bool notificationsEnabled,  String language)?  $default,) {final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
return $default(_that.musicEnabled,_that.sfxEnabled,_that.vibrationEnabled,_that.notificationsEnabled,_that.language);case _:
  return null;

}
}

}

/// @nodoc


class _AppSettings implements AppSettings {
  const _AppSettings({this.musicEnabled = true, this.sfxEnabled = true, this.vibrationEnabled = true, this.notificationsEnabled = true, this.language = 'es'});
  

@override@JsonKey() final  bool musicEnabled;
// Música activa.
@override@JsonKey() final  bool sfxEnabled;
// Efectos activos.
@override@JsonKey() final  bool vibrationEnabled;
// Vibración activa.
@override@JsonKey() final  bool notificationsEnabled;
// Alertas activas.
@override@JsonKey() final  String language;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppSettingsCopyWith<_AppSettings> get copyWith => __$AppSettingsCopyWithImpl<_AppSettings>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppSettings&&(identical(other.musicEnabled, musicEnabled) || other.musicEnabled == musicEnabled)&&(identical(other.sfxEnabled, sfxEnabled) || other.sfxEnabled == sfxEnabled)&&(identical(other.vibrationEnabled, vibrationEnabled) || other.vibrationEnabled == vibrationEnabled)&&(identical(other.notificationsEnabled, notificationsEnabled) || other.notificationsEnabled == notificationsEnabled)&&(identical(other.language, language) || other.language == language));
}


@override
int get hashCode => Object.hash(runtimeType,musicEnabled,sfxEnabled,vibrationEnabled,notificationsEnabled,language);

@override
String toString() {
  return 'AppSettings(musicEnabled: $musicEnabled, sfxEnabled: $sfxEnabled, vibrationEnabled: $vibrationEnabled, notificationsEnabled: $notificationsEnabled, language: $language)';
}


}

/// @nodoc
abstract mixin class _$AppSettingsCopyWith<$Res> implements $AppSettingsCopyWith<$Res> {
  factory _$AppSettingsCopyWith(_AppSettings value, $Res Function(_AppSettings) _then) = __$AppSettingsCopyWithImpl;
@override @useResult
$Res call({
 bool musicEnabled, bool sfxEnabled, bool vibrationEnabled, bool notificationsEnabled, String language
});




}
/// @nodoc
class __$AppSettingsCopyWithImpl<$Res>
    implements _$AppSettingsCopyWith<$Res> {
  __$AppSettingsCopyWithImpl(this._self, this._then);

  final _AppSettings _self;
  final $Res Function(_AppSettings) _then;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? musicEnabled = null,Object? sfxEnabled = null,Object? vibrationEnabled = null,Object? notificationsEnabled = null,Object? language = null,}) {
  return _then(_AppSettings(
musicEnabled: null == musicEnabled ? _self.musicEnabled : musicEnabled // ignore: cast_nullable_to_non_nullable
as bool,sfxEnabled: null == sfxEnabled ? _self.sfxEnabled : sfxEnabled // ignore: cast_nullable_to_non_nullable
as bool,vibrationEnabled: null == vibrationEnabled ? _self.vibrationEnabled : vibrationEnabled // ignore: cast_nullable_to_non_nullable
as bool,notificationsEnabled: null == notificationsEnabled ? _self.notificationsEnabled : notificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
