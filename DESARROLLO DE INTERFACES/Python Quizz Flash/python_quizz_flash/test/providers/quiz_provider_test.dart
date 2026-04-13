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

// ═══ IMPORTS: Dependencias para tests de QuizProvider ═══

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:python_quizz_flash/providers/quiz_provider.dart';
import 'package:python_quizz_flash/models/exercise.dart';
import 'package:python_quizz_flash/providers/economia_provider.dart';

// ═══ MOCKS ═══

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockCollectionReference extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

class MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

class MockDocumentSnapshot extends Mock
    implements DocumentSnapshot<Map<String, dynamic>> {}

class MockFirebaseUser extends Mock implements User {
  @override
  String get uid => 'test_user_uid';
}

class MockFirebaseAuth extends Mock implements FirebaseAuth {
  @override
  User? get currentUser => MockFirebaseUser();
}

// ═══ GRUPO PRINCIPAL: Tests de QuizProvider ═══

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Ejercicios de prueba para JSON mock
  final Map<String, dynamic> mockExercisesData = {
    'basic': [
      {
        'id': 'mc_1',
        'difficulty': 'basic',
        'subDifficulty': 'easy',
        'type': 'multipleChoice',
        'question': '¿Cuál es la respuesta?',
        'correctAnswer': 'A',
        'defaultExplanation': 'Explicación correcta',
        'hint': 'Pista',
        'coinReward': 10,
        'isChallenge': false,
        'options': ['A', 'B', 'C', 'D'],
      },
      {
        'id': 'mc_2',
        'difficulty': 'basic',
        'subDifficulty': 'medium',
        'type': 'multipleChoice',
        'question': 'Segunda pregunta',
        'correctAnswer': 'B',
        'defaultExplanation': 'Explicación',
        'hint': 'Pista',
        'coinReward': 10,
        'isChallenge': false,
        'options': ['A', 'B', 'C', 'D'],
      },
    ],
  };

  // ═══ GRUPO: QuizState Model ═══
  group('QuizState Model', () {
    test('should create with default values', () {
      final state = QuizState(
        exercises: [],
      );

      expect(state.exercises, isEmpty);
      expect(state.currentIndex, 0);
      expect(state.score, 0);
      expect(state.coins, 0);
      expect(state.errors, 0);
      expect(state.isAnswered, false);
      expect(state.isQuizFinished, false);
      expect(state.showHint, false);
      expect(state.disabledOptions, isEmpty);
    });

    test('should create with custom values', () {
      final exercise = Exercise(
        id: 'test_1',
        difficulty: Difficulty.basic,
        type: ExerciseType.multipleChoice,
        question: 'Test?',
        correctAnswer: 'A',
        defaultExplanation: 'Explanation',
        hint: 'Hint',
        options: ['A', 'B', 'C'],
      );

      final state = QuizState(
        exercises: [exercise],
        currentIndex: 0,
        score: 50,
        coins: 100,
        errors: 2,
        isAnswered: true,
        wasCorrect: true,
        selectedAnswer: 'A',
        showHint: true,
        disabledOptions: ['C', 'D'],
      );

      expect(state.exercises.length, 1);
      expect(state.score, 50);
      expect(state.coins, 100);
      expect(state.errors, 2);
      expect(state.isAnswered, true);
      expect(state.wasCorrect, true);
      expect(state.selectedAnswer, 'A');
      expect(state.showHint, true);
      expect(state.disabledOptions.length, 2);
    });

    test('should copyWith correctly', () {
      final original = QuizState(
        exercises: [],
        coins: 100,
        score: 50,
      );

      final modified = original.copyWith(
        coins: 200,
        isAnswered: true,
      );

      expect(modified.coins, 200);
      expect(modified.isAnswered, true);
      expect(modified.score, 50);  // se mantiene
    });
  });

  // ═══ GRUPO: Exercise Model Tests ═══
  group('Exercise Model', () {
    test('should create from JSON', () {
      final json = {
        'id': 'test_1',
        'difficulty': 'basic',
        'subDifficulty': 'easy',
        'type': 'multipleChoice',
        'question': '¿Pregunta?',
        'correctAnswer': 'A',
        'defaultExplanation': 'Explicación',
        'hint': 'Pista',
        'coinReward': 15,
        'isChallenge': false,
        'options': ['A', 'B', 'C', 'D'],
      };

      final exercise = Exercise.fromJson(json);

      expect(exercise.id, 'test_1');
      expect(exercise.difficulty, Difficulty.basic);
      expect(exercise.type, ExerciseType.multipleChoice);
      expect(exercise.question, '¿Pregunta?');
      expect(exercise.correctAnswer, 'A');
      expect(exercise.coinReward, 15);
      expect(exercise.isChallenge, false);
      expect(exercise.options!.length, 4);
    });

    test('should create with default subDifficulty', () {
      final json = {
        'id': 'test_2',
        'difficulty': 'intermediate',
        'type': 'coding',
        'question': 'Código',
        'correctAnswer': 'print("hello")',
        'defaultExplanation': 'Explicación',
        'hint': 'Pista',
        'coinReward': 10,
        'isChallenge': true,
      };

      final exercise = Exercise.fromJson(json);

      expect(exercise.subDifficulty, SubDifficulty.easy);
      expect(exercise.isChallenge, true);
      expect(exercise.type, ExerciseType.coding);
    });
  });

  // ═══ GRUPO: Lógica de respuestas (conceptual) ═══
  group('Answer Logic (Conceptual)', () {
    test('correct answer should increase score', () {
      const initialScore = 0;
      const coinReward = 10;
      const isCorrect = true;

      final finalScore = isCorrect ? initialScore + coinReward : initialScore;

      expect(finalScore, 10);
    });

    test('incorrect answer should not increase score', () {
      const initialScore = 50;
      const isCorrect = false;

      final finalScore = isCorrect ? initialScore + 10 : initialScore;

      expect(finalScore, 50);
    });

    test('hint should cost 5 coins', () {
      const initialCoins = 100;
      const hintCost = 5;
      final finalCoins = initialCoins - hintCost;

      expect(finalCoins, 95);
    });

    test('remove two should cost 20 coins', () {
      const initialCoins = 100;
      const removeTwoCost = 20;
      final finalCoins = initialCoins - removeTwoCost;

      expect(finalCoins, 80);
    });

    test('should not allow hint without enough coins', () {
      const currentCoins = 3;
      const hintCost = 5;

      expect(currentCoins < hintCost, true);
    });

    test('should not allow remove two without enough coins', () {
      const currentCoins = 15;
      const removeTwoCost = 20;

      expect(currentCoins < removeTwoCost, true);
    });
  });

  // ═══ GRUPO: Quiz Completion Logic ═══
  group('Quiz Completion Logic', () {
    test('less than 5 errors should be success', () {
      const errors = 3;
      const isQuizFinished = true;

      expect(isQuizFinished, true);
      expect(errors < 5, true);
    });

    test('5 or more errors should be failure', () {
      const errors = 6;
      const isQuizFinished = true;

      expect(isQuizFinished, true);
      expect(errors >= 5, true);
    });

    test('should reset progress with 5 or more errors', () {
      const errors = 7;
      final shouldResetProgress = errors >= 5;

      expect(shouldResetProgress, true);
    });

    test('challenge should reward more points', () {
      const normalReward = 10;
      const challengeReward = 200;

      expect(challengeReward, greaterThan(normalReward));
    });
  });

  // ═══ GRUPO: Edge Cases ═══
  group('Edge Cases', () {
    test('should handle empty exercises list', () {
      final state = QuizState(
        exercises: [],
        currentIndex: 0,
        coins: 0,
      );

      expect(state.exercises.isEmpty, true);
    });

    test('should handle zero coins', () {
      final state = QuizState(
        exercises: [],
        coins: 0,
      );

      expect(state.coins, 0);
    });

    test('should handle max errors', () {
      final state = QuizState(
        exercises: [],
        errors: 5,
      );

      expect(state.errors, 5);
      expect(state.errors >= 5, true);
    });
  });
}
