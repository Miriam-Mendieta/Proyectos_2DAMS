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

part of 'quiz_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QuizState {

 List<Exercise> get exercises;// Lista de 20 preguntas del nivel
 int get currentIndex;// Índice de la pregunta actual (0 a 19)
 int get score;// Puntos acumulados por respuestas correctas
 int get coins;// Monedas actuales del usuario
 int get errors;// Contador interno de fallos cometidos
 bool get isAnswered;// Indica si ya se contestó la pregunta actual
 bool get isQuizFinished;// Indica si se llegó al final de los 20 ejercicios
 String? get selectedAnswer;// La respuesta que el usuario ha elegido
 bool? get wasCorrect;// Si la última respuesta fue correcta o no
 bool get showHint;// Si se debe mostrar la pista comprada
 List<String> get disabledOptions;// Opciones eliminadas por comodines
 String? get userAnswer;
/// Create a copy of QuizState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuizStateCopyWith<QuizState> get copyWith => _$QuizStateCopyWithImpl<QuizState>(this as QuizState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuizState&&const DeepCollectionEquality().equals(other.exercises, exercises)&&(identical(other.currentIndex, currentIndex) || other.currentIndex == currentIndex)&&(identical(other.score, score) || other.score == score)&&(identical(other.coins, coins) || other.coins == coins)&&(identical(other.errors, errors) || other.errors == errors)&&(identical(other.isAnswered, isAnswered) || other.isAnswered == isAnswered)&&(identical(other.isQuizFinished, isQuizFinished) || other.isQuizFinished == isQuizFinished)&&(identical(other.selectedAnswer, selectedAnswer) || other.selectedAnswer == selectedAnswer)&&(identical(other.wasCorrect, wasCorrect) || other.wasCorrect == wasCorrect)&&(identical(other.showHint, showHint) || other.showHint == showHint)&&const DeepCollectionEquality().equals(other.disabledOptions, disabledOptions)&&(identical(other.userAnswer, userAnswer) || other.userAnswer == userAnswer));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(exercises),currentIndex,score,coins,errors,isAnswered,isQuizFinished,selectedAnswer,wasCorrect,showHint,const DeepCollectionEquality().hash(disabledOptions),userAnswer);

@override
String toString() {
  return 'QuizState(exercises: $exercises, currentIndex: $currentIndex, score: $score, coins: $coins, errors: $errors, isAnswered: $isAnswered, isQuizFinished: $isQuizFinished, selectedAnswer: $selectedAnswer, wasCorrect: $wasCorrect, showHint: $showHint, disabledOptions: $disabledOptions, userAnswer: $userAnswer)';
}


}

/// @nodoc
abstract mixin class $QuizStateCopyWith<$Res>  {
  factory $QuizStateCopyWith(QuizState value, $Res Function(QuizState) _then) = _$QuizStateCopyWithImpl;
@useResult
$Res call({
 List<Exercise> exercises, int currentIndex, int score, int coins, int errors, bool isAnswered, bool isQuizFinished, String? selectedAnswer, bool? wasCorrect, bool showHint, List<String> disabledOptions, String? userAnswer
});




}
/// @nodoc
class _$QuizStateCopyWithImpl<$Res>
    implements $QuizStateCopyWith<$Res> {
  _$QuizStateCopyWithImpl(this._self, this._then);

  final QuizState _self;
  final $Res Function(QuizState) _then;

/// Create a copy of QuizState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? exercises = null,Object? currentIndex = null,Object? score = null,Object? coins = null,Object? errors = null,Object? isAnswered = null,Object? isQuizFinished = null,Object? selectedAnswer = freezed,Object? wasCorrect = freezed,Object? showHint = null,Object? disabledOptions = null,Object? userAnswer = freezed,}) {
  return _then(_self.copyWith(
exercises: null == exercises ? _self.exercises : exercises // ignore: cast_nullable_to_non_nullable
as List<Exercise>,currentIndex: null == currentIndex ? _self.currentIndex : currentIndex // ignore: cast_nullable_to_non_nullable
as int,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,coins: null == coins ? _self.coins : coins // ignore: cast_nullable_to_non_nullable
as int,errors: null == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as int,isAnswered: null == isAnswered ? _self.isAnswered : isAnswered // ignore: cast_nullable_to_non_nullable
as bool,isQuizFinished: null == isQuizFinished ? _self.isQuizFinished : isQuizFinished // ignore: cast_nullable_to_non_nullable
as bool,selectedAnswer: freezed == selectedAnswer ? _self.selectedAnswer : selectedAnswer // ignore: cast_nullable_to_non_nullable
as String?,wasCorrect: freezed == wasCorrect ? _self.wasCorrect : wasCorrect // ignore: cast_nullable_to_non_nullable
as bool?,showHint: null == showHint ? _self.showHint : showHint // ignore: cast_nullable_to_non_nullable
as bool,disabledOptions: null == disabledOptions ? _self.disabledOptions : disabledOptions // ignore: cast_nullable_to_non_nullable
as List<String>,userAnswer: freezed == userAnswer ? _self.userAnswer : userAnswer // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [QuizState].
extension QuizStatePatterns on QuizState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuizState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuizState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuizState value)  $default,){
final _that = this;
switch (_that) {
case _QuizState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuizState value)?  $default,){
final _that = this;
switch (_that) {
case _QuizState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Exercise> exercises,  int currentIndex,  int score,  int coins,  int errors,  bool isAnswered,  bool isQuizFinished,  String? selectedAnswer,  bool? wasCorrect,  bool showHint,  List<String> disabledOptions,  String? userAnswer)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuizState() when $default != null:
return $default(_that.exercises,_that.currentIndex,_that.score,_that.coins,_that.errors,_that.isAnswered,_that.isQuizFinished,_that.selectedAnswer,_that.wasCorrect,_that.showHint,_that.disabledOptions,_that.userAnswer);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Exercise> exercises,  int currentIndex,  int score,  int coins,  int errors,  bool isAnswered,  bool isQuizFinished,  String? selectedAnswer,  bool? wasCorrect,  bool showHint,  List<String> disabledOptions,  String? userAnswer)  $default,) {final _that = this;
switch (_that) {
case _QuizState():
return $default(_that.exercises,_that.currentIndex,_that.score,_that.coins,_that.errors,_that.isAnswered,_that.isQuizFinished,_that.selectedAnswer,_that.wasCorrect,_that.showHint,_that.disabledOptions,_that.userAnswer);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Exercise> exercises,  int currentIndex,  int score,  int coins,  int errors,  bool isAnswered,  bool isQuizFinished,  String? selectedAnswer,  bool? wasCorrect,  bool showHint,  List<String> disabledOptions,  String? userAnswer)?  $default,) {final _that = this;
switch (_that) {
case _QuizState() when $default != null:
return $default(_that.exercises,_that.currentIndex,_that.score,_that.coins,_that.errors,_that.isAnswered,_that.isQuizFinished,_that.selectedAnswer,_that.wasCorrect,_that.showHint,_that.disabledOptions,_that.userAnswer);case _:
  return null;

}
}

}

/// @nodoc


class _QuizState implements QuizState {
  const _QuizState({required final  List<Exercise> exercises, this.currentIndex = 0, this.score = 0, this.coins = 0, this.errors = 0, this.isAnswered = false, this.isQuizFinished = false, this.selectedAnswer, this.wasCorrect, this.showHint = false, final  List<String> disabledOptions = const [], this.userAnswer}): _exercises = exercises,_disabledOptions = disabledOptions;
  

 final  List<Exercise> _exercises;
@override List<Exercise> get exercises {
  if (_exercises is EqualUnmodifiableListView) return _exercises;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_exercises);
}

// Lista de 20 preguntas del nivel
@override@JsonKey() final  int currentIndex;
// Índice de la pregunta actual (0 a 19)
@override@JsonKey() final  int score;
// Puntos acumulados por respuestas correctas
@override@JsonKey() final  int coins;
// Monedas actuales del usuario
@override@JsonKey() final  int errors;
// Contador interno de fallos cometidos
@override@JsonKey() final  bool isAnswered;
// Indica si ya se contestó la pregunta actual
@override@JsonKey() final  bool isQuizFinished;
// Indica si se llegó al final de los 20 ejercicios
@override final  String? selectedAnswer;
// La respuesta que el usuario ha elegido
@override final  bool? wasCorrect;
// Si la última respuesta fue correcta o no
@override@JsonKey() final  bool showHint;
// Si se debe mostrar la pista comprada
 final  List<String> _disabledOptions;
// Si se debe mostrar la pista comprada
@override@JsonKey() List<String> get disabledOptions {
  if (_disabledOptions is EqualUnmodifiableListView) return _disabledOptions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_disabledOptions);
}

// Opciones eliminadas por comodines
@override final  String? userAnswer;

/// Create a copy of QuizState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuizStateCopyWith<_QuizState> get copyWith => __$QuizStateCopyWithImpl<_QuizState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuizState&&const DeepCollectionEquality().equals(other._exercises, _exercises)&&(identical(other.currentIndex, currentIndex) || other.currentIndex == currentIndex)&&(identical(other.score, score) || other.score == score)&&(identical(other.coins, coins) || other.coins == coins)&&(identical(other.errors, errors) || other.errors == errors)&&(identical(other.isAnswered, isAnswered) || other.isAnswered == isAnswered)&&(identical(other.isQuizFinished, isQuizFinished) || other.isQuizFinished == isQuizFinished)&&(identical(other.selectedAnswer, selectedAnswer) || other.selectedAnswer == selectedAnswer)&&(identical(other.wasCorrect, wasCorrect) || other.wasCorrect == wasCorrect)&&(identical(other.showHint, showHint) || other.showHint == showHint)&&const DeepCollectionEquality().equals(other._disabledOptions, _disabledOptions)&&(identical(other.userAnswer, userAnswer) || other.userAnswer == userAnswer));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_exercises),currentIndex,score,coins,errors,isAnswered,isQuizFinished,selectedAnswer,wasCorrect,showHint,const DeepCollectionEquality().hash(_disabledOptions),userAnswer);

@override
String toString() {
  return 'QuizState(exercises: $exercises, currentIndex: $currentIndex, score: $score, coins: $coins, errors: $errors, isAnswered: $isAnswered, isQuizFinished: $isQuizFinished, selectedAnswer: $selectedAnswer, wasCorrect: $wasCorrect, showHint: $showHint, disabledOptions: $disabledOptions, userAnswer: $userAnswer)';
}


}

/// @nodoc
abstract mixin class _$QuizStateCopyWith<$Res> implements $QuizStateCopyWith<$Res> {
  factory _$QuizStateCopyWith(_QuizState value, $Res Function(_QuizState) _then) = __$QuizStateCopyWithImpl;
@override @useResult
$Res call({
 List<Exercise> exercises, int currentIndex, int score, int coins, int errors, bool isAnswered, bool isQuizFinished, String? selectedAnswer, bool? wasCorrect, bool showHint, List<String> disabledOptions, String? userAnswer
});




}
/// @nodoc
class __$QuizStateCopyWithImpl<$Res>
    implements _$QuizStateCopyWith<$Res> {
  __$QuizStateCopyWithImpl(this._self, this._then);

  final _QuizState _self;
  final $Res Function(_QuizState) _then;

/// Create a copy of QuizState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? exercises = null,Object? currentIndex = null,Object? score = null,Object? coins = null,Object? errors = null,Object? isAnswered = null,Object? isQuizFinished = null,Object? selectedAnswer = freezed,Object? wasCorrect = freezed,Object? showHint = null,Object? disabledOptions = null,Object? userAnswer = freezed,}) {
  return _then(_QuizState(
exercises: null == exercises ? _self._exercises : exercises // ignore: cast_nullable_to_non_nullable
as List<Exercise>,currentIndex: null == currentIndex ? _self.currentIndex : currentIndex // ignore: cast_nullable_to_non_nullable
as int,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,coins: null == coins ? _self.coins : coins // ignore: cast_nullable_to_non_nullable
as int,errors: null == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as int,isAnswered: null == isAnswered ? _self.isAnswered : isAnswered // ignore: cast_nullable_to_non_nullable
as bool,isQuizFinished: null == isQuizFinished ? _self.isQuizFinished : isQuizFinished // ignore: cast_nullable_to_non_nullable
as bool,selectedAnswer: freezed == selectedAnswer ? _self.selectedAnswer : selectedAnswer // ignore: cast_nullable_to_non_nullable
as String?,wasCorrect: freezed == wasCorrect ? _self.wasCorrect : wasCorrect // ignore: cast_nullable_to_non_nullable
as bool?,showHint: null == showHint ? _self.showHint : showHint // ignore: cast_nullable_to_non_nullable
as bool,disabledOptions: null == disabledOptions ? _self._disabledOptions : disabledOptions // ignore: cast_nullable_to_non_nullable
as List<String>,userAnswer: freezed == userAnswer ? _self.userAnswer : userAnswer // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
