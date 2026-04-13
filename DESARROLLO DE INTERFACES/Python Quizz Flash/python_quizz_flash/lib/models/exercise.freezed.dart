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

part of 'exercise.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Exercise {

 String get id;@DifficultyConverter() Difficulty get difficulty; SubDifficulty get subDifficulty;@ExerciseTypeConverter() ExerciseType get type; String get question; String? get codeSnippet; List<String>? get options; String get correctAnswer; String? get expectedOutput; String get defaultExplanation; String get hint;// CAMBIO: Pista obligatoria para cada ejercicio
 int get coinReward; String? get userAnswer;// Respuesta del usuario para ejercicios de texto
 String? get selectedAnswer;// Respuesta seleccionada para multiple choice
 List<String> get disabledOptions;// Opciones deshabilitadas por comodines
 bool get isChallenge;
/// Create a copy of Exercise
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExerciseCopyWith<Exercise> get copyWith => _$ExerciseCopyWithImpl<Exercise>(this as Exercise, _$identity);

  /// Serializes this Exercise to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Exercise&&(identical(other.id, id) || other.id == id)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.subDifficulty, subDifficulty) || other.subDifficulty == subDifficulty)&&(identical(other.type, type) || other.type == type)&&(identical(other.question, question) || other.question == question)&&(identical(other.codeSnippet, codeSnippet) || other.codeSnippet == codeSnippet)&&const DeepCollectionEquality().equals(other.options, options)&&(identical(other.correctAnswer, correctAnswer) || other.correctAnswer == correctAnswer)&&(identical(other.expectedOutput, expectedOutput) || other.expectedOutput == expectedOutput)&&(identical(other.defaultExplanation, defaultExplanation) || other.defaultExplanation == defaultExplanation)&&(identical(other.hint, hint) || other.hint == hint)&&(identical(other.coinReward, coinReward) || other.coinReward == coinReward)&&(identical(other.userAnswer, userAnswer) || other.userAnswer == userAnswer)&&(identical(other.selectedAnswer, selectedAnswer) || other.selectedAnswer == selectedAnswer)&&const DeepCollectionEquality().equals(other.disabledOptions, disabledOptions)&&(identical(other.isChallenge, isChallenge) || other.isChallenge == isChallenge));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,difficulty,subDifficulty,type,question,codeSnippet,const DeepCollectionEquality().hash(options),correctAnswer,expectedOutput,defaultExplanation,hint,coinReward,userAnswer,selectedAnswer,const DeepCollectionEquality().hash(disabledOptions),isChallenge);

@override
String toString() {
  return 'Exercise(id: $id, difficulty: $difficulty, subDifficulty: $subDifficulty, type: $type, question: $question, codeSnippet: $codeSnippet, options: $options, correctAnswer: $correctAnswer, expectedOutput: $expectedOutput, defaultExplanation: $defaultExplanation, hint: $hint, coinReward: $coinReward, userAnswer: $userAnswer, selectedAnswer: $selectedAnswer, disabledOptions: $disabledOptions, isChallenge: $isChallenge)';
}


}

/// @nodoc
abstract mixin class $ExerciseCopyWith<$Res>  {
  factory $ExerciseCopyWith(Exercise value, $Res Function(Exercise) _then) = _$ExerciseCopyWithImpl;
@useResult
$Res call({
 String id,@DifficultyConverter() Difficulty difficulty, SubDifficulty subDifficulty,@ExerciseTypeConverter() ExerciseType type, String question, String? codeSnippet, List<String>? options, String correctAnswer, String? expectedOutput, String defaultExplanation, String hint, int coinReward, String? userAnswer, String? selectedAnswer, List<String> disabledOptions, bool isChallenge
});




}
/// @nodoc
class _$ExerciseCopyWithImpl<$Res>
    implements $ExerciseCopyWith<$Res> {
  _$ExerciseCopyWithImpl(this._self, this._then);

  final Exercise _self;
  final $Res Function(Exercise) _then;

/// Create a copy of Exercise
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? difficulty = null,Object? subDifficulty = null,Object? type = null,Object? question = null,Object? codeSnippet = freezed,Object? options = freezed,Object? correctAnswer = null,Object? expectedOutput = freezed,Object? defaultExplanation = null,Object? hint = null,Object? coinReward = null,Object? userAnswer = freezed,Object? selectedAnswer = freezed,Object? disabledOptions = null,Object? isChallenge = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as Difficulty,subDifficulty: null == subDifficulty ? _self.subDifficulty : subDifficulty // ignore: cast_nullable_to_non_nullable
as SubDifficulty,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ExerciseType,question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,codeSnippet: freezed == codeSnippet ? _self.codeSnippet : codeSnippet // ignore: cast_nullable_to_non_nullable
as String?,options: freezed == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<String>?,correctAnswer: null == correctAnswer ? _self.correctAnswer : correctAnswer // ignore: cast_nullable_to_non_nullable
as String,expectedOutput: freezed == expectedOutput ? _self.expectedOutput : expectedOutput // ignore: cast_nullable_to_non_nullable
as String?,defaultExplanation: null == defaultExplanation ? _self.defaultExplanation : defaultExplanation // ignore: cast_nullable_to_non_nullable
as String,hint: null == hint ? _self.hint : hint // ignore: cast_nullable_to_non_nullable
as String,coinReward: null == coinReward ? _self.coinReward : coinReward // ignore: cast_nullable_to_non_nullable
as int,userAnswer: freezed == userAnswer ? _self.userAnswer : userAnswer // ignore: cast_nullable_to_non_nullable
as String?,selectedAnswer: freezed == selectedAnswer ? _self.selectedAnswer : selectedAnswer // ignore: cast_nullable_to_non_nullable
as String?,disabledOptions: null == disabledOptions ? _self.disabledOptions : disabledOptions // ignore: cast_nullable_to_non_nullable
as List<String>,isChallenge: null == isChallenge ? _self.isChallenge : isChallenge // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Exercise].
extension ExercisePatterns on Exercise {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Exercise value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Exercise() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Exercise value)  $default,){
final _that = this;
switch (_that) {
case _Exercise():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Exercise value)?  $default,){
final _that = this;
switch (_that) {
case _Exercise() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @DifficultyConverter()  Difficulty difficulty,  SubDifficulty subDifficulty, @ExerciseTypeConverter()  ExerciseType type,  String question,  String? codeSnippet,  List<String>? options,  String correctAnswer,  String? expectedOutput,  String defaultExplanation,  String hint,  int coinReward,  String? userAnswer,  String? selectedAnswer,  List<String> disabledOptions,  bool isChallenge)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Exercise() when $default != null:
return $default(_that.id,_that.difficulty,_that.subDifficulty,_that.type,_that.question,_that.codeSnippet,_that.options,_that.correctAnswer,_that.expectedOutput,_that.defaultExplanation,_that.hint,_that.coinReward,_that.userAnswer,_that.selectedAnswer,_that.disabledOptions,_that.isChallenge);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @DifficultyConverter()  Difficulty difficulty,  SubDifficulty subDifficulty, @ExerciseTypeConverter()  ExerciseType type,  String question,  String? codeSnippet,  List<String>? options,  String correctAnswer,  String? expectedOutput,  String defaultExplanation,  String hint,  int coinReward,  String? userAnswer,  String? selectedAnswer,  List<String> disabledOptions,  bool isChallenge)  $default,) {final _that = this;
switch (_that) {
case _Exercise():
return $default(_that.id,_that.difficulty,_that.subDifficulty,_that.type,_that.question,_that.codeSnippet,_that.options,_that.correctAnswer,_that.expectedOutput,_that.defaultExplanation,_that.hint,_that.coinReward,_that.userAnswer,_that.selectedAnswer,_that.disabledOptions,_that.isChallenge);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @DifficultyConverter()  Difficulty difficulty,  SubDifficulty subDifficulty, @ExerciseTypeConverter()  ExerciseType type,  String question,  String? codeSnippet,  List<String>? options,  String correctAnswer,  String? expectedOutput,  String defaultExplanation,  String hint,  int coinReward,  String? userAnswer,  String? selectedAnswer,  List<String> disabledOptions,  bool isChallenge)?  $default,) {final _that = this;
switch (_that) {
case _Exercise() when $default != null:
return $default(_that.id,_that.difficulty,_that.subDifficulty,_that.type,_that.question,_that.codeSnippet,_that.options,_that.correctAnswer,_that.expectedOutput,_that.defaultExplanation,_that.hint,_that.coinReward,_that.userAnswer,_that.selectedAnswer,_that.disabledOptions,_that.isChallenge);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Exercise implements Exercise {
  const _Exercise({required this.id, @DifficultyConverter() required this.difficulty, this.subDifficulty = SubDifficulty.easy, @ExerciseTypeConverter() required this.type, required this.question, this.codeSnippet, final  List<String>? options, required this.correctAnswer, this.expectedOutput, required this.defaultExplanation, required this.hint, this.coinReward = 10, this.userAnswer, this.selectedAnswer, final  List<String> disabledOptions = const [], this.isChallenge = false}): _options = options,_disabledOptions = disabledOptions;
  factory _Exercise.fromJson(Map<String, dynamic> json) => _$ExerciseFromJson(json);

@override final  String id;
@override@DifficultyConverter() final  Difficulty difficulty;
@override@JsonKey() final  SubDifficulty subDifficulty;
@override@ExerciseTypeConverter() final  ExerciseType type;
@override final  String question;
@override final  String? codeSnippet;
 final  List<String>? _options;
@override List<String>? get options {
  final value = _options;
  if (value == null) return null;
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String correctAnswer;
@override final  String? expectedOutput;
@override final  String defaultExplanation;
@override final  String hint;
// CAMBIO: Pista obligatoria para cada ejercicio
@override@JsonKey() final  int coinReward;
@override final  String? userAnswer;
// Respuesta del usuario para ejercicios de texto
@override final  String? selectedAnswer;
// Respuesta seleccionada para multiple choice
 final  List<String> _disabledOptions;
// Respuesta seleccionada para multiple choice
@override@JsonKey() List<String> get disabledOptions {
  if (_disabledOptions is EqualUnmodifiableListView) return _disabledOptions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_disabledOptions);
}

// Opciones deshabilitadas por comodines
@override@JsonKey() final  bool isChallenge;

/// Create a copy of Exercise
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExerciseCopyWith<_Exercise> get copyWith => __$ExerciseCopyWithImpl<_Exercise>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExerciseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Exercise&&(identical(other.id, id) || other.id == id)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.subDifficulty, subDifficulty) || other.subDifficulty == subDifficulty)&&(identical(other.type, type) || other.type == type)&&(identical(other.question, question) || other.question == question)&&(identical(other.codeSnippet, codeSnippet) || other.codeSnippet == codeSnippet)&&const DeepCollectionEquality().equals(other._options, _options)&&(identical(other.correctAnswer, correctAnswer) || other.correctAnswer == correctAnswer)&&(identical(other.expectedOutput, expectedOutput) || other.expectedOutput == expectedOutput)&&(identical(other.defaultExplanation, defaultExplanation) || other.defaultExplanation == defaultExplanation)&&(identical(other.hint, hint) || other.hint == hint)&&(identical(other.coinReward, coinReward) || other.coinReward == coinReward)&&(identical(other.userAnswer, userAnswer) || other.userAnswer == userAnswer)&&(identical(other.selectedAnswer, selectedAnswer) || other.selectedAnswer == selectedAnswer)&&const DeepCollectionEquality().equals(other._disabledOptions, _disabledOptions)&&(identical(other.isChallenge, isChallenge) || other.isChallenge == isChallenge));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,difficulty,subDifficulty,type,question,codeSnippet,const DeepCollectionEquality().hash(_options),correctAnswer,expectedOutput,defaultExplanation,hint,coinReward,userAnswer,selectedAnswer,const DeepCollectionEquality().hash(_disabledOptions),isChallenge);

@override
String toString() {
  return 'Exercise(id: $id, difficulty: $difficulty, subDifficulty: $subDifficulty, type: $type, question: $question, codeSnippet: $codeSnippet, options: $options, correctAnswer: $correctAnswer, expectedOutput: $expectedOutput, defaultExplanation: $defaultExplanation, hint: $hint, coinReward: $coinReward, userAnswer: $userAnswer, selectedAnswer: $selectedAnswer, disabledOptions: $disabledOptions, isChallenge: $isChallenge)';
}


}

/// @nodoc
abstract mixin class _$ExerciseCopyWith<$Res> implements $ExerciseCopyWith<$Res> {
  factory _$ExerciseCopyWith(_Exercise value, $Res Function(_Exercise) _then) = __$ExerciseCopyWithImpl;
@override @useResult
$Res call({
 String id,@DifficultyConverter() Difficulty difficulty, SubDifficulty subDifficulty,@ExerciseTypeConverter() ExerciseType type, String question, String? codeSnippet, List<String>? options, String correctAnswer, String? expectedOutput, String defaultExplanation, String hint, int coinReward, String? userAnswer, String? selectedAnswer, List<String> disabledOptions, bool isChallenge
});




}
/// @nodoc
class __$ExerciseCopyWithImpl<$Res>
    implements _$ExerciseCopyWith<$Res> {
  __$ExerciseCopyWithImpl(this._self, this._then);

  final _Exercise _self;
  final $Res Function(_Exercise) _then;

/// Create a copy of Exercise
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? difficulty = null,Object? subDifficulty = null,Object? type = null,Object? question = null,Object? codeSnippet = freezed,Object? options = freezed,Object? correctAnswer = null,Object? expectedOutput = freezed,Object? defaultExplanation = null,Object? hint = null,Object? coinReward = null,Object? userAnswer = freezed,Object? selectedAnswer = freezed,Object? disabledOptions = null,Object? isChallenge = null,}) {
  return _then(_Exercise(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as Difficulty,subDifficulty: null == subDifficulty ? _self.subDifficulty : subDifficulty // ignore: cast_nullable_to_non_nullable
as SubDifficulty,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ExerciseType,question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,codeSnippet: freezed == codeSnippet ? _self.codeSnippet : codeSnippet // ignore: cast_nullable_to_non_nullable
as String?,options: freezed == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<String>?,correctAnswer: null == correctAnswer ? _self.correctAnswer : correctAnswer // ignore: cast_nullable_to_non_nullable
as String,expectedOutput: freezed == expectedOutput ? _self.expectedOutput : expectedOutput // ignore: cast_nullable_to_non_nullable
as String?,defaultExplanation: null == defaultExplanation ? _self.defaultExplanation : defaultExplanation // ignore: cast_nullable_to_non_nullable
as String,hint: null == hint ? _self.hint : hint // ignore: cast_nullable_to_non_nullable
as String,coinReward: null == coinReward ? _self.coinReward : coinReward // ignore: cast_nullable_to_non_nullable
as int,userAnswer: freezed == userAnswer ? _self.userAnswer : userAnswer // ignore: cast_nullable_to_non_nullable
as String?,selectedAnswer: freezed == selectedAnswer ? _self.selectedAnswer : selectedAnswer // ignore: cast_nullable_to_non_nullable
as String?,disabledOptions: null == disabledOptions ? _self._disabledOptions : disabledOptions // ignore: cast_nullable_to_non_nullable
as List<String>,isChallenge: null == isChallenge ? _self.isChallenge : isChallenge // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
