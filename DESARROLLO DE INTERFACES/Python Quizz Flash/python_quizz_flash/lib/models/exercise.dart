// ╔════════════════════════════════════════════════════════╗
// ║  PYTHON QUIZZ FLASH - LICENCIA MPL 2.0                 ║
// ║  ====================================================  ║
// ║  Copyright (c) 2026 Miriam Carmen Mendieta Racedo      ║
// ║  ====================================================  ║
// ║  Este archivo es parte de Python Quizz Flash.          ║
// ║  Python Quizz Flash es software libre: puede           ║
// ║  redistribuirlo y/o modificarlo bajo los términos de   ║
// ║  la Mozilla Public License 2.0 (MPL-2.0).              ║
// ║  ====================================================  ║
// ║  Esta Licencia Pública está disponible en:             ║
// ║  https://mozilla.org/MPL/2.0/                          ║
// ║  ====================================================  ║
// ║  NOTA: Las modificaciones de este archivo deben        ║
// ║  distribuirse bajo MPL-2.0. El código nuevo en         ║
// ║  archivos separados puede tener otra licencia.         ║
// ║  ====================================================  ║
// ║  This file is part of Python Quizz Flash.              ║
// ║  Python Quizz Flash is free software: you can          ║
// ║  redistribute it and/or modify it under the terms of   ║
// ║  the Mozilla Public License 2.0 (MPL-2.0).             ║
// ╚════════════════════════════════════════════════════════╝

// ═══ IMPORTS: Dependencias para modelos inmutables con freezed ═══

import 'package:freezed_annotation/freezed_annotation.dart';  // importa freezed para generar clases inmutables automáticamente

part 'exercise.freezed.dart';  // archivo generado por freezed con la implementación inmutable
part 'exercise.g.dart';  // archivo generado por json_serializable con métodos fromJson/toJson

/// ═══ ENUM: ExerciseType ═══
/// Define los tipos de ejercicios disponibles en el quiz.
/// - multipleChoice: selección de una respuesta correcta
/// - fillInTheBlank: completar código faltante
/// - bugFix: encontrar y corregir errores en código
/// - coding: escribir código desde cero
enum ExerciseType { multipleChoice, fillInTheBlank, bugFix, coding }

/// ═══ ENUM: Difficulty ═══
/// Define los niveles de dificultad del quiz.
/// - basic: fundamentos de Python
/// - intermediate: estructuras de control y funciones
/// - advanced: POO y algoritmos complejos
/// - expert: reto final integrador
enum Difficulty { basic, intermediate, advanced, expert }

/// ═══ ENUM: SubDifficulty ═══
/// Define la sub-dificultad dentro de cada nivel de ejercicio.
/// - easy: preguntas introductorias
/// - medium: preguntas intermedias
/// - hard: preguntas desafiantes
enum SubDifficulty { easy, medium, hard }

/// ═══ CLASE: ExerciseTypeConverter ═══
/// Convierte entre el enum ExerciseType y String para serialización JSON.
/// Se usa con @ExerciseTypeConverter() en las clases @freezed.
class ExerciseTypeConverter implements JsonConverter<ExerciseType, String> {
  const ExerciseTypeConverter();  // constructor constante para el converter

  @override  // sobrescribe el método que convierte de JSON a enum
  ExerciseType fromJson(String json) {  // recibe un string del JSON y retorna el enum correspondiente
    switch (json) {  // evalúa el valor del string JSON
      case 'multipleChoice': return ExerciseType.multipleChoice;  // mapea a opción múltiple
      case 'fillInTheBlank': return ExerciseType.fillInTheBlank;  // mapea a completar código
      case 'bugFix': return ExerciseType.bugFix;  // mapea a corrección de errores
      case 'coding': return ExerciseType.coding;  // mapea a escribir código
      default: return ExerciseType.multipleChoice;  // fallback: opción múltiple por defecto
    }
  }

  @override  // sobrescribe el método que convierte de enum a JSON
  String toJson(ExerciseType object) => object.name;  // retorna el nombre del enum como string
}

/// ═══ CLASE: DifficultyConverter ═══
/// Convierte entre el enum Difficulty y String para serialización JSON.
/// Se usa con @DifficultyConverter() en las clases @freezed.
class DifficultyConverter implements JsonConverter<Difficulty, String> {
  const DifficultyConverter();  // constructor constante para el converter

  @override  // sobrescribe el método que convierte de JSON a enum
  Difficulty fromJson(String json) {  // recibe un string del JSON y retorna el enum correspondiente
    switch (json) {  // evalúa el valor del string JSON
      case 'basic': return Difficulty.basic;  // mapea a nivel básico
      case 'intermediate': return Difficulty.intermediate;  // mapea a nivel intermedio
      case 'advanced': return Difficulty.advanced;  // mapea a nivel avanzado
      default: return Difficulty.basic;  // fallback: nivel básico por defecto
    }
  }

  @override  // sobrescribe el método que convierte de enum a JSON
  String toJson(Difficulty object) => object.name;  // retorna el nombre del enum como string
}

/// ═══ CLASE: Exercise ═══
/// Modelo inmutable que representa un ejercicio/pregunta del quiz.
/// Generado con @freezed para inmutabilidad automática.
/// Incluye tipo, dificultad, pregunta, respuestas y recompensas.
@freezed  // anotación que indica a freezed que genere la clase inmutable
abstract class Exercise with _$Exercise {  // clase abstracta que mezcla el mixin generado
  const factory Exercise({  // factory constructor que define la estructura del ejercicio
    required String id,  // identificador único del ejercicio
    @DifficultyConverter() required Difficulty difficulty,  // dificultad del ejercicio (convertida a/from string)
    @Default(SubDifficulty.easy) SubDifficulty subDifficulty,  // sub-dificultad, easy por defecto
    @ExerciseTypeConverter() required ExerciseType type,  // tipo de ejercicio (convertido a/from string)
    required String question,  // texto de la pregunta o problema a resolver
    String? codeSnippet,  // fragmento de código opcional para referencia
    List<String>? options,  // lista de opciones para ejercicios de opción múltiple
    required String correctAnswer,  // respuesta correcta del ejercicio
    String? expectedOutput,  // salida esperada para ejercicios de código
    required String defaultExplanation,  // explicación que se muestra tras responder
    required String hint,  // pista obligatoria para ayudar al usuario
    @Default(10) int coinReward,  // recompensa en monedas, 10 por defecto
    String? userAnswer,  // respuesta escrita por el usuario en ejercicios de texto
    String? selectedAnswer,  // respuesta seleccionada en opción múltiple
    @Default([]) List<String> disabledOptions,  // opciones deshabilitadas por comodinos (quitar 2)
    @Default(false) bool isChallenge,  // indica si este ejercicio es el reto final del nivel
  }) = _Exercise;  // nombre de la clase concreta generada por freezed

  /// Factory para deserializar desde JSON. Generado automáticamente por _$ExerciseFromJson.
  factory Exercise.fromJson(Map<String, dynamic> json) =>  // crea un Exercise desde un mapa JSON
      _$ExerciseFromJson(json);  // delega en el código generado por json_serializable
}
