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

// ═══ IMPORTS: Dependencias del provider de quiz ═══

import 'dart:convert';  // importa decodificación JSON para leer archivos de ejercicios
import 'dart:math';  // importa funciones matemáticas y Random para seleccionar ejercicios aleatorios
import 'package:flutter/material.dart';  // importa framework base de Flutter
import 'package:flutter/services.dart';  // importa rootBundle para cargar archivos desde assets
import 'package:cloud_firestore/cloud_firestore.dart';  // importa Firestore para guardar progreso del usuario
import 'package:firebase_auth/firebase_auth.dart';  // importa Firebase Auth para identificar al usuario
import 'package:riverpod_annotation/riverpod_annotation.dart';  // importa riverpod_annotation para generar providers
import 'package:freezed_annotation/freezed_annotation.dart';  // importa freezed para clases inmutables
import '../models/exercise.dart';  // importa el modelo Exercise con tipos y dificultad
import '../utils/app_logger.dart';  // importa el logger de la aplicación
import 'economia_provider.dart';  // importa el provider de economía para gestionar monedas

part 'quiz_provider.freezed.dart';  // archivo generado por freezed con implementación inmutable
part 'quiz_provider.g.dart';  // archivo generado por json_serializable

/// ═══ CLASE: QuizState ═══
/// Estado inmutable que representa el progreso actual del quiz.
/// Generado con @freezed. Contiene la lista de ejercicios, puntuación,
/// monedas, errores y estado de la pregunta actual.
@freezed  // anotación que indica a freezed que genere la clase inmutable
abstract class QuizState with _$QuizState {  // clase abstracta que mezcla el mixin generado
  const factory QuizState({  // factory constructor que define la estructura del estado
    required List<Exercise> exercises,  // lista de 20 preguntas normales + 1 reto opcional
    @Default(0) int currentIndex,  // índice de la pregunta actual (0 a 20)
    @Default(0) int score,  // puntos acumulados por respuestas correctas
    @Default(0) int coins,  // monedas actuales del usuario durante el quiz
    @Default(0) int errors,  // contador de fallos cometidos en el quiz actual
    @Default(false) bool isAnswered,  // true si ya se contestó la pregunta actual
    @Default(false) bool isQuizFinished,  // true si se llegó al final de todos los ejercicios
    String? selectedAnswer,  // respuesta seleccionada o escrita por el usuario
    bool? wasCorrect,  // indica si la última respuesta fue correcta (null si aún no respondió)
    @Default(false) bool showHint,  // true si se mostró la pista comprada
    @Default([]) List<String> disabledOptions,  // opciones eliminadas por comodín "quitar 2"
    String? userAnswer,  // respuesta del usuario para ejercicios de texto/código
  }) = _QuizState;  // nombre de la clase concreta generada por freezed
}

/// ═══ CLASE: Quiz ═══
/// Notifier de Riverpod que controla toda la lógica del Quiz.
/// Carga ejercicios desde JSON, gestiona respuestas, pistas, comodines,
/// monedas, progreso y checkpoints por nivel de dificultad.
@riverpod  // anotación que genera el provider automáticamente
class Quiz extends _$Quiz {  // extiende el generado _$Quiz para gestión de estado
  @override  // sobrescribe el método build del notifier
  FutureOr<QuizState> build(Difficulty difficulty) async {  // recibe la dificultad como parámetro
    final exercises = await _loadExercises(difficulty);  // carga ejercicios desde archivo JSON

    int savedIndex = 0;  // por defecto empieza en la pregunta 0
    int currentCoins = 0;  // por defecto empieza con 0 monedas

    final user = FirebaseAuth.instance.currentUser;  // obtiene el usuario autenticado actual
    if (user != null) {  // si hay usuario logueado
      final economia = ref.watch(economiaProvider);  // obtiene monedas desde EconomiaProvider (lectura rápida)
      currentCoins = economia.coins;  // almacena las monedas actuales del usuario

      final doc = await FirebaseFirestore.instance  // lee progreso guardado desde Firestore
          .collection('users')  // en la colección 'users'
          .doc(user.uid)  // documento con el UID del usuario
          .get();  // lee el documento
      if (doc.exists) {  // si el documento existe
        final data = doc.data();  // obtiene los datos
        savedIndex = data?['progress_${difficulty.name}'] ?? 0;  // lee el progreso guardado para esta dificultad

        if (savedIndex >= exercises.length) savedIndex = 0;  // asegura que el índice no exceda la lista de ejercicios
      }
    }

    return QuizState(  // retorna el estado inicial del quiz
      exercises: exercises,  // lista de ejercicios cargados
      currentIndex: savedIndex,  // índice donde se quedó el usuario
      coins: currentCoins,  // monedas actuales del usuario
    );
  }

  /// ═══ MÉTODO: _loadExercises ═══
  /// Carga los ejercicios desde el archivo JSON assets/data/exercises_pool.json.
  /// Selecciona 20 ejercicios normales aleatorios + 1 reto aleatorio aparte.
  Future<List<Exercise>> _loadExercises(Difficulty difficulty) async {
    try {  // try-catch para manejar errores de carga
      final String response = await rootBundle.loadString('assets/data/exercises_pool.json');  // carga archivo JSON desde assets
      final data = jsonDecode(response);  // decodifica el JSON a Map
      final List<dynamic> list = data[difficulty.name] ?? [];  // obtiene la lista de ejercicios para esta dificultad
      final allExercises = list  // mapea cada elemento JSON a un Exercise
          .map((e) {  // para cada elemento del JSON
            try {  // intenta parsear
              return Exercise.fromJson(e);  // crea Exercise desde JSON
            } catch (e) {  // si falla el parseo
              return null;  // retorna null para filtrar después
            }
          })
          .where((e) => e != null)  // filtra los ejercicios nulos (errores de parseo)
          .cast<Exercise>()  // castea la lista a tipo Exercise
          .toList();  // convierte a lista

      if (allExercises.isEmpty) return [];  // si no hay ejercicios, retorna lista vacía

      /// Separa ejercicios normales de los de reto final.
      final normalExercises = allExercises.where((e) => !e.isChallenge).toList();  // ejercicios que NO son retos
      final challengeExercises = allExercises.where((e) => e.isChallenge).toList();  // ejercicios que SÍ son retos

      final random = Random();  // generador de números aleatorios
      List<Exercise> selectedExercises = [];  // lista para almacenar los ejercicios seleccionados

      normalExercises.shuffle(random);  // mezcla los ejercicios normales aleatoriamente
      selectedExercises.addAll(normalExercises.take(20));  // toma los primeros 20 normales

      if (challengeExercises.isNotEmpty) {  // si hay ejercicios de reto disponibles
        challengeExercises.shuffle(random);  // mezcla los retos aleatoriamente
        selectedExercises.add(challengeExercises.first);  // agrega 1 reto adicional al final (ejercicio 21)
      }

      return selectedExercises;  // retorna la lista de 20+1 ejercicios seleccionados
    } catch (e) {  // captura errores de carga o parseo
      return [];  // si hay error, retorna lista vacía
    }
  }

  /// ═══ MÉTODO: selectAnswer ═══
  /// Registra la selección del usuario en preguntas de opción múltiple.
  /// No hace nada si ya se respondió la pregunta actual.
  void selectAnswer(String option) {  // recibe la opción seleccionada
    final stateValue = state.value;  // obtiene el estado actual
    if (stateValue == null || stateValue.isAnswered) return;  // si no hay estado o ya respondió, sale
    state = AsyncData(stateValue.copyWith(selectedAnswer: option));  // actualiza la elección del usuario
  }

  /// ═══ MÉTODO: updateAnswer ═══
  /// Registra la respuesta escrita por el usuario en ejercicios de código.
  void updateAnswer(String value) {  // recibe el texto escrito por el usuario
    final stateValue = state.value;  // obtiene el estado actual
    if (stateValue == null || stateValue.isAnswered) return;  // si no hay estado o ya respondió, sale
    state = AsyncData(stateValue.copyWith(selectedAnswer: value));  // actualiza la respuesta escrita
  }

  /// ═══ MÉTODO: useHint ═══
  /// Compra una pista por 5 monedas. Muestra la pista del ejercicio actual.
  void useHint() {  // sin parámetros, usa el ejercicio actual
    final stateValue = state.value;  // obtiene el estado actual
    if (stateValue == null || stateValue.isAnswered || stateValue.showHint) return;  // si ya respondió o ya tiene pista, sale
    if (stateValue.coins < 5) return;  // si no tiene suficientes monedas, sale

    state = AsyncData(stateValue.copyWith(coins: stateValue.coins - 5, showHint: true));  // resta 5 monedas y activa showHint

    final economia = ref.read(economiaProvider);  // obtiene provider de economía
    economia.gastarMonedas(5, 'pista');  // registra gasto de 5 monedas como 'pista'
  }

  /// ═══ MÉTODO: useRemoveTwo ═══
  /// Compra el comodín "quitar 2 opciones incorrectas" por 20 monedas.
  /// Solo funciona en ejercicios de opción múltiple.
  void useRemoveTwo() {  // sin parámetros, usa el ejercicio actual
    final stateValue = state.value;  // obtiene el estado actual
    if (stateValue == null || stateValue.isAnswered || stateValue.disabledOptions.isNotEmpty) return;  // si ya respondió o ya usó comodín, sale
    if (stateValue.coins < 20) return;  // si no tiene 20 monedas, sale
    final exercise = stateValue.exercises[stateValue.currentIndex];  // obtiene el ejercicio actual
    if (exercise.type != ExerciseType.multipleChoice || exercise.options == null) return;  // si no es opción múltiple, sale
    final correct = exercise.correctAnswer;  // obtiene la respuesta correcta
    final incorrectOptions = exercise.options!.where((opt) => opt != correct).toList();  // filtra las opciones incorrectas
    incorrectOptions.shuffle();  // mezcla las incorrectas aleatoriamente
    final toDisable = incorrectOptions.take(2).toList();  // toma 2 para deshabilitar

    state = AsyncData(stateValue.copyWith(coins: stateValue.coins - 20, disabledOptions: toDisable));  // resta 20 monedas y deshabilita opciones

    final economia = ref.read(economiaProvider);  // obtiene provider de economía
    economia.gastarMonedas(20, 'pista');  // registra gasto de 20 monedas como 'pista'
  }

  /// ═══ MÉTODO: submitAnswer ═══
  /// Comprueba si la respuesta enviada es correcta y actualiza monedas, score y progreso.
  /// Lógica de validación adaptada según el tipo de ejercicio.
  Future<void> submitAnswer() async {  // sin parámetros, valida la respuesta actual
    final stateValue = state.value;  // obtiene el estado actual
    if (stateValue == null || stateValue.selectedAnswer == null || stateValue.isAnswered) return;  // si no hay respuesta o ya respondió, sale

    final exercise = stateValue.exercises[stateValue.currentIndex];  // obtiene el ejercicio actual

    /// Limpia ambas respuestas para comparar sin diferencias de formato.
    String cleanUser = stateValue.selectedAnswer!.trim().replaceAll(' ', '').replaceAll('"', "'");  // limpia respuesta del usuario
    String cleanCorrect = exercise.correctAnswer.trim().replaceAll(' ', '').replaceAll('"', "'");  // limpia respuesta correcta

    bool isCorrect = cleanUser == cleanCorrect;  // compara ambas cadenas limpias

    /// Lógica especial para ejercicios de completar huecos (fill in the blank).
    if (exercise.type == ExerciseType.fillInTheBlank) {  // si es tipo completar
      String userResponse = stateValue.selectedAnswer!.trim().replaceAll(' ', '');  // limpia respuesta usuario
      String correctResponse = exercise.correctAnswer.trim().replaceAll(' ', '');  // limpia respuesta correcta
      isCorrect = userResponse == correctResponse || userResponse.endsWith(correctResponse);  // acepta si termina con la respuesta
    }

    /// Lógica especial para ejercicios de programación (verificación de keywords).
    if (exercise.type == ExerciseType.coding) {  // si es tipo código
      final String userCode = stateValue.selectedAnswer!.trim();  // obtiene código del usuario
      final List<String> keywords = ['print', 'len', 'def', 'if', 'for', 'while', 'return'];  // keywords esenciales de Python
      bool hasLogic = true;  // asume que tiene la lógica correcta
      for (var token in keywords) {  // para cada keyword esencial
        if (exercise.correctAnswer.contains(token) && !userCode.contains(token)) {  // si la respuesta correcta la tiene y el usuario no
          hasLogic = false;  // marca como incorrecto
          break;  // sale del loop
        }
      }
      isCorrect = hasLogic && userCode.replaceAll(' ', '').contains(exercise.correctAnswer.replaceAll(' ', ''));  // verifica lógica + contenido
    }

    /// Calcula nuevos errores y score según si acertó o no.
    int newErrors = isCorrect ? stateValue.errors : stateValue.errors + 1;  // incrementa errores si falló
    int newScore = isCorrect ? stateValue.score + exercise.coinReward : stateValue.score;  // suma recompensa si acertó

    /// Actualiza el estado local PRIMERO para UX instantánea.
    state = AsyncData(stateValue.copyWith(
      isAnswered: true,  // marca como respondida
      wasCorrect: isCorrect,  // indica si fue correcta
      errors: newErrors,  // actualiza contador de errores
      score: newScore,  // actualiza puntuación
      coins: stateValue.coins + (isCorrect ? exercise.coinReward : 0),  // suma monedas si acertó
    ));

    /// Gestiona economía y progreso según resultado.
    if (isCorrect) {  // si la respuesta fue correcta
      final economia = ref.read(economiaProvider);  // obtiene provider de economía
      await economia.sumarMonedas(exercise.coinReward, esReto: exercise.isChallenge);  // suma monedas (10 normal, 200 reto) y ESPERA sincronización con Firebase

      final user = FirebaseAuth.instance.currentUser;  // obtiene usuario actual
      if (user != null) {  // si hay usuario logueado
        final nextIndex = stateValue.currentIndex + 1;  // calcula índice del siguiente ejercicio
        FirebaseFirestore.instance.collection('users').doc(user.uid).update({  // guarda progreso en Firestore
          'progress_${difficulty.name}': nextIndex,  // guarda índice siguiente para reanudar
        });
      }
    } else {  // si la respuesta fue incorrecta
      final economia = ref.read(economiaProvider);  // obtiene provider de economía
      await economia.incrementarEjerciciosFallidos();  // incrementa contador de ejercicios fallados y ESPERA sincronización con Firebase

      final user = FirebaseAuth.instance.currentUser;  // obtiene usuario actual
      if (user != null) {  // si hay usuario logueado
        FirebaseFirestore.instance.collection('users').doc(user.uid).update({  // actualiza en Firestore
          'total_errors': FieldValue.increment(1),  // incrementa total de errores en 1
        });
      }
    }
  }

  /// ═══ MÉTODO: submitAnswerManual ═══
  /// Envía respuesta manualmente desde widgets personalizados (fillInTheBlank, etc.).
  /// Recibe directamente si la respuesta fue correcta o no.
  Future<void> submitAnswerManual(String exerciseId, ExerciseType type, String userAnswer, bool isCorrect) async {
    final stateValue = state.value;  // obtiene el estado actual
    if (stateValue == null || stateValue.isAnswered) return;  // si no hay estado o ya respondió, sale

    final exerciseIndex = stateValue.exercises.indexWhere((ex) => ex.id == exerciseId);  // busca el ejercicio por ID
    if (exerciseIndex == -1) return;  // si no encuentra el ejercicio, sale

    final currentExercise = stateValue.exercises[exerciseIndex];  // obtiene el ejercicio encontrado

    /// Calcula las nuevas variables de estado.
    int newScore = isCorrect ? stateValue.score + currentExercise.coinReward : stateValue.score;  // suma recompensa si acertó
    int newErrors = isCorrect ? stateValue.errors : stateValue.errors + 1;  // incrementa errores si falló

    /// Actualiza el estado local PRIMERO para UX instantánea.
    state = AsyncData(stateValue.copyWith(
      isAnswered: true,  // marca como respondida
      wasCorrect: isCorrect,  // indica si fue correcta
      selectedAnswer: type == ExerciseType.multipleChoice ? userAnswer : null,  // guarda respuesta solo si es múltiple
      score: newScore,  // actualiza puntuación
      coins: stateValue.coins + (isCorrect ? currentExercise.coinReward : 0),  // suma monedas si acertó
      errors: newErrors,  // actualiza errores
    ));

    /// Gestiona economía y progreso igual que submitAnswer.
    if (isCorrect) {  // si acertó
      final economia = ref.read(economiaProvider);  // obtiene provider de economía
      await economia.sumarMonedas(currentExercise.coinReward, esReto: currentExercise.isChallenge);  // suma monedas y ESPERA sincronización con Firebase

      final user = FirebaseAuth.instance.currentUser;  // obtiene usuario actual
      if (user != null) {  // si hay usuario
        final nextIndex = stateValue.currentIndex + 1;  // calcula siguiente índice
        FirebaseFirestore.instance.collection('users').doc(user.uid).update({  // guarda progreso
          'progress_${difficulty.name}': nextIndex,  // guarda índice siguiente
        });
      }
    } else {  // si falló
      final economia = ref.read(economiaProvider);  // obtiene provider de economía
      await economia.incrementarEjerciciosFallidos();  // incrementa contador de fallos y ESPERA sincronización con Firebase

      final user = FirebaseAuth.instance.currentUser;  // obtiene usuario actual
      if (user != null) {  // si hay usuario
        FirebaseFirestore.instance.collection('users').doc(user.uid).update({  // actualiza en Firestore
          'total_errors': FieldValue.increment(1),  // incrementa errores totales
        });
      }
    }
  }

  /// ═══ MÉTODO: nextQuestion ═══
  /// Pasa a la siguiente pregunta o evalúa si se completó el nivel.
  /// Si hubo 5+ errores, borra el progreso. Si tuvo éxito, guarda checkpoint.
  void nextQuestion() {  // sin parámetros, avanza al siguiente ejercicio
    final stateValue = state.value;  // obtiene el estado actual
    if (stateValue == null) return;  // si no hay estado, sale

    final int nextIndex = stateValue.currentIndex + 1;  // calcula el índice del siguiente ejercicio

    if (nextIndex < stateValue.exercises.length) {  // si aún quedan ejercicios
      state = AsyncData(stateValue.copyWith(  // actualiza estado para la nueva pregunta
        currentIndex: nextIndex,  // avanza al siguiente índice
        isAnswered: false,  // resetea estado de respuesta
        selectedAnswer: null,  // limpia respuesta anterior
        wasCorrect: null,  // limpia resultado anterior
        showHint: false,  // oculta pista
        disabledOptions: [],  // resetea opciones deshabilitadas
      ));
    } else {  // se acabaron los ejercicios (fin del nivel)
      if (stateValue.errors >= 5) {  // si cometió 5 o más errores
        final user = FirebaseAuth.instance.currentUser;  // obtiene usuario actual
        if (user != null) {  // si hay usuario
          FirebaseFirestore.instance.collection('users').doc(user.uid).update({  // borra progreso en Firestore
            'progress_${difficulty.name}': 0,  // resetea progreso a 0
          });
        }
      } else {  // ¡ÉXITO! Completó el nivel con menos de 5 errores
        _saveLevelCheckpoint();  // guarda checkpoint de monedas según el nivel
      }
      state = AsyncData(stateValue.copyWith(isQuizFinished: true));  // marca quiz como terminado
    }
  }

  /// ═══ MÉTODO: _saveLevelCheckpoint ═══
  /// Guarda el checkpoint de monedas y contadores al completar un nivel exitosamente.
  /// Los checkpoints se usan al fallar niveles superiores para conservar progreso anterior.
  Future<void> _saveLevelCheckpoint() async {
    final user = FirebaseAuth.instance.currentUser;  // obtiene usuario actual
    if (user == null) return;  // si no hay usuario, sale

    final currentCoins = state.value?.coins ?? 0;  // obtiene monedas actuales del estado

    final economia = ref.read(economiaProvider);  // obtiene provider de economía
    final currentExercisesCompleted = economia.exercisesCompleted;  // lee ejercicios completados actuales
    final currentExercisesFailed = economia.exercisesFailed;  // lee ejercicios fallados actuales

    switch (difficulty) {  // evalúa según la dificultad del nivel
      case Difficulty.basic:  // si es nivel básico
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({  // actualiza en Firestore
          'basic_completed': true,  // marca básico como completado
          'coins_after_basic_level': currentCoins,  // guarda monedas tras completar básico
          'exercises_completed_after_basic': currentExercisesCompleted,  // guarda contadores de ejercicios
          'exercises_failed_after_basic': currentExercisesFailed,  // guarda fallos tras básico
        });
        break;
      case Difficulty.intermediate:  // si es nivel intermedio
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({  // actualiza en Firestore
          'intermediate_completed': true,  // marca intermedio como completado
          'coins_after_intermediate_level': currentCoins,  // guarda monedas tras completar intermedio
          'exercises_completed_after_intermediate': currentExercisesCompleted,  // guarda contadores de ejercicios
          'exercises_failed_after_intermediate': currentExercisesFailed,  // guarda fallos tras intermedio
        });
        break;
      case Difficulty.advanced:  // si es nivel avanzado
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({  // actualiza en Firestore
          'advanced_completed': true,  // marca avanzado como completado
          'coins_after_advanced_level': currentCoins,  // guarda monedas tras completar avanzado
          'exercises_completed_after_advanced': currentExercisesCompleted,  // guarda contadores de ejercicios
          'exercises_failed_after_advanced': currentExercisesFailed,  // guarda fallos tras avanzado
        });
        break;
      case Difficulty.expert:  // si es nivel expert (GG)
        break;  // el nivel expert no tiene checkpoint siguiente
    }
  }

  /// ═══ MÉTODO: resetLevelAndCoins ═══
  /// Resetea monedas y progreso al fallar un nivel.
  /// - BÁSICO: Reset completo a 0 (monedas, ejercicios, retos)
  /// - INTERMEDIO: Vuelve a checkpoint del nivel básico (mantiene logros)
  /// - AVANZADO: Vuelve a checkpoint del nivel intermedio (mantiene logros)
  /// - EXPERT: Vuelve a checkpoint del nivel avanzado (mantiene logros)
  /// Usa FieldValue.increment() para evitar condiciones de carrera.
  Future<void> resetLevelAndCoins() async {
    final user = FirebaseAuth.instance.currentUser;  // obtiene usuario actual
    if (user == null) {  // si no hay usuario
      throw Exception('Usuario no autenticado');  // lanza excepción
    }

    /// Obtiene el progreso de niveles para determinar qué checkpoint usar.
    final levelProgressDoc = await FirebaseFirestore.instance  // lee documento del usuario
        .collection('users')  // en la colección 'users'
        .doc(user.uid)  // documento con el UID
        .get();  // lee el documento

    if (!levelProgressDoc.exists) {  // si el documento no existe
      return;  // no hay nada que resetear
    }

    final levelData = levelProgressDoc.data() ?? {};  // obtiene datos del nivel o mapa vacío

    int coinsToRestore = 0;  // monedas a restaurar según checkpoint
    int exercisesCompletedToRestore = 0;  // ejercicios completados a restaurar
    int exercisesFailedToRestore = 0;  // ejercicios fallados a restaurar

    /// Determina a qué nivel volver según la dificultad actual.
    switch (difficulty) {  // evalúa según dificultad
      case Difficulty.basic:  // si es nivel básico
        coinsToRestore = 0;  // pierde todo (no hay nivel anterior)
        exercisesCompletedToRestore = 0;  // resetea ejercicios
        exercisesFailedToRestore = 0;  // resetea fallos
        break;
      case Difficulty.intermediate:  // si es nivel intermedio
        coinsToRestore = levelData['coins_after_basic_level'] ?? levelData['coins_after_basic_challenge'] ?? 0;  // restaura monedas del básico
        exercisesCompletedToRestore = levelData['exercises_completed_after_basic'] ?? 0;  // restaura ejercicios del básico
        exercisesFailedToRestore = levelData['exercises_failed_after_basic'] ?? 0;  // restaura fallos del básico
        break;
      case Difficulty.advanced:  // si es nivel avanzado
        coinsToRestore = levelData['coins_after_intermediate_level'] ?? levelData['coins_after_intermediate_challenge'] ?? 0;  // restaura monedas del intermedio
        exercisesCompletedToRestore = levelData['exercises_completed_after_intermediate'] ?? 0;  // restaura ejercicios del intermedio
        exercisesFailedToRestore = levelData['exercises_failed_after_intermediate'] ?? 0;  // restaura fallos del intermedio
        break;
      case Difficulty.expert:  // si es nivel expert (GG)
        coinsToRestore = levelData['coins_after_advanced_level'] ?? levelData['coins_after_intermediate_challenge'] ?? 0;  // restaura monedas del avanzado
        exercisesCompletedToRestore = levelData['exercises_completed_after_advanced'] ?? 0;  // restaura ejercicios del avanzado
        exercisesFailedToRestore = levelData['exercises_failed_after_advanced'] ?? 0;  // restaura fallos del avanzado
        break;
    }

    /// Calcula diferencias para actualización atómica con FieldValue.increment().
    final currentCoins = levelData['coins'] ?? 0;  // obtiene monedas actuales
    final difference = coinsToRestore - currentCoins;  // calcula diferencia a aplicar

    final economia = ref.read(economiaProvider);  // obtiene provider de economía
    final currentExercisesCompleted = economia.exercisesCompleted;  // lee ejercicios completados actuales
    final currentExercisesFailed = economia.exercisesFailed;  // lee ejercicios fallados actuales

    final exercisesCompletedDiff = exercisesCompletedToRestore - currentExercisesCompleted;  // diferencia de ejercicios
    final exercisesFailedDiff = exercisesFailedToRestore - currentExercisesFailed;  // diferencia de fallos

    /// Prepara datos de actualización para Firestore.
    Map<String, dynamic> updateData = {  // mapa de campos a actualizar
      'coins': FieldValue.increment(difference),  // ajusta monedas atómicamente
      'progress_${difficulty.name}': 0,  // resetea progreso del nivel actual
    };

    if (difficulty == Difficulty.basic) {  // si es nivel básico
      updateData['exercises_completed'] = 0;  // resetea ejercicios completados
      updateData['challenges_completed'] = 0;  // resetea retos completados
      updateData['exercises_failed'] = 0;  // resetea ejercicios fallados
    } else {  // si es otro nivel
      updateData['exercises_completed'] = FieldValue.increment(exercisesCompletedDiff);  // ajusta ejercicios atómicamente
      updateData['exercises_failed'] = FieldValue.increment(exercisesFailedDiff);  // ajusta fallos atómicamente
    }

    await FirebaseFirestore.instance.collection('users').doc(user.uid).update(updateData);  // aplica actualización en Firestore

    /// Resetea economía local según el nivel.
    if (difficulty == Difficulty.basic) {  // si es nivel básico
      await economia.reiniciar(monedasCheckpoint: 0);  // reset completo a cero
      AppLogger.i('RESET COMPLETO: Nivel básico reseteado a cero');  // log de reset completo
    } else {  // si es otro nivel
      await economia.reiniciarParcial(  // reset parcial manteniendo logros anteriores
        monedasCheckpoint: coinsToRestore,  // restaura monedas al checkpoint
        exercisesCompletedCheckpoint: exercisesCompletedToRestore,  // restaura ejercicios completados
        exercisesFailedCheckpoint: exercisesFailedToRestore,  // restaura ejercicios fallados
      );
      AppLogger.i('RESET PARCIAL: Restaurados contadores al nivel anterior');  // log de reset parcial
    }

    ref.invalidateSelf();  // reinicia el estado del provider para que la UI se actualice
  }
}
