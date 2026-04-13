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

// ═══ IMPORTS: Dependencias para tests del modelo Exercise ═══

import 'package:flutter_test/flutter_test.dart';  // importa framework de tests para Flutter
import 'package:python_quizz_flash/models/exercise.dart';  // importa el modelo Exercise a testear

/// ═══ GRUPO PRINCIPAL: Tests del modelo Exercise ═══
/// Verifica que el modelo Exercise funcione correctamente
/// en creación, serialización y deserialización JSON.
void main() {
  // ═══ GRUPO: Creación de ejercicios ═══
  group('Exercise Creation', () {
    
    /// Test: Crear ejercicio de opción múltiple
    test('should create a multiple choice exercise with default values', () {
      // Arrange: prepara datos del ejercicio
      final exercise = Exercise(
        id: 'test_001',  // ID único del ejercicio
        difficulty: Difficulty.basic,  // dificultad básica
        type: ExerciseType.multipleChoice,  // tipo opción múltiple
        question: '¿Cuál es la salida de print(2 + 2)?',  // pregunta
        correctAnswer: '4',  // respuesta correcta
        defaultExplanation: 'La suma de 2 + 2 es 4',  // explicación
        hint: 'Piensa en aritmética básica',  // pista
        options: ['3', '4', '5', '6'],  // opciones disponibles
        coinReward: 10,  // recompensa de 10 monedas
      );

      // Act & Assert: verifica propiedades del ejercicio creado
      expect(exercise.id, 'test_001');  // verifica ID
      expect(exercise.difficulty, Difficulty.basic);  // verifica dificultad
      expect(exercise.type, ExerciseType.multipleChoice);  // verifica tipo
      expect(exercise.question, '¿Cuál es la salida de print(2 + 2)?');  // verifica pregunta
      expect(exercise.correctAnswer, '4');  // verifica respuesta correcta
      expect(exercise.coinReward, 10);  // verifica recompensa
      expect(exercise.isChallenge, false);  // por defecto no es reto
      expect(exercise.subDifficulty, SubDifficulty.easy);  // sub-dificultad por defecto
      expect(exercise.disabledOptions, isEmpty);  // sin opciones deshabilitadas
    });

    /// Test: Crear ejercicio de código
    test('should create a coding exercise', () {
      // Arrange: prepara ejercicio de código
      final exercise = Exercise(
        id: 'code_001',  // ID del ejercicio
        difficulty: Difficulty.intermediate,  // dificultad intermedia
        type: ExerciseType.coding,  // tipo escritura de código
        question: 'Escribe una función que sume dos números',  // pregunta
        correctAnswer: 'def suma(a, b): return a + b',  // respuesta esperada
        defaultExplanation: 'Se usa def para definir función',  // explicación
        hint: 'Usa la palabra clave def',  // pista
        coinReward: 15,  // recompensa mayor
        isChallenge: true,  // es un reto
      );

      // Act & Assert: verifica propiedades
      expect(exercise.type, ExerciseType.coding);  // verifica tipo coding
      expect(exercise.isChallenge, true);  // es reto
      expect(exercise.coinReward, 15);  // verifica recompensa
      expect(exercise.codeSnippet, isNull);  // sin snippet de código
    });

    /// Test: Crear ejercicio de completar
    test('should create a fill in the blank exercise', () {
      // Arrange
      final exercise = Exercise(
        id: 'fill_001',  // ID
        difficulty: Difficulty.advanced,  // dificultad avanzada
        type: ExerciseType.fillInTheBlank,  // tipo completar
        question: 'Completa: for i in ____: print(i)',  // pregunta con hueco
        correctAnswer: 'range(10)',  // respuesta para el hueco
        defaultExplanation: 'range() genera secuencia numérica',  // explicación
        hint: 'Usa range() para secuencias',  // pista
        coinReward: 20,  // recompensa
        subDifficulty: SubDifficulty.hard,  // sub-dificultad difícil
      );

      // Act & Assert
      expect(exercise.type, ExerciseType.fillInTheBlank);  // verifica tipo
      expect(exercise.subDifficulty, SubDifficulty.hard);  // verifica sub-dificultad
      expect(exercise.correctAnswer, 'range(10)');  // verifica respuesta
    });

    /// Test: Crear ejercicio de corrección de bugs
    test('should create a bug fix exercise', () {
      // Arrange
      final exercise = Exercise(
        id: 'bug_001',  // ID
        difficulty: Difficulty.intermediate,  // intermedio
        type: ExerciseType.bugFix,  // tipo corregir bug
        question: 'Encuentra el error en este código',  // pregunta
        codeSnippet: 'for i in range(10)\n  print(i',  // código con error
        correctAnswer: 'Falta cerrar paréntesis en print',  // respuesta correcta
        defaultExplanation: 'print() requiere paréntesis cerrado',  // explicación
        hint: 'Revisa la sintaxis de print()',  // pista
        coinReward: 15,  // recompensa
      );

      // Act & Assert
      expect(exercise.type, ExerciseType.bugFix);  // verifica tipo
      expect(exercise.codeSnippet, isNotNull);  // tiene snippet de código
      expect(exercise.codeSnippet, contains('print(i'));  // snippet contiene error
    });
  });

  // ═══ GRUPO: Serialización JSON ═══
  group('Exercise JSON Serialization', () {
    
    /// Test: Serializar ejercicio a JSON
    test('should serialize exercise to JSON', () {
      // Arrange: crea ejercicio
      final exercise = Exercise(
        id: 'json_test_001',  // ID
        difficulty: Difficulty.basic,  // básica
        type: ExerciseType.multipleChoice,  // opción múltiple
        question: 'Test question?',  // pregunta
        correctAnswer: 'A',  // respuesta
        defaultExplanation: 'Explanation here',  // explicación
        hint: 'Hint here',  // pista
        options: ['A', 'B', 'C', 'D'],  // opciones
        coinReward: 10,  // recompensa
      );

      // Act: convierte a JSON
      final json = exercise.toJson();

      // Assert: verifica campos del JSON
      expect(json['id'], 'json_test_001');  // verifica ID
      expect(json['difficulty'], 'basic');  // dificultad como string
      expect(json['type'], 'multipleChoice');  // tipo como string
      expect(json['question'], 'Test question?');  // verifica pregunta
      expect(json['correctAnswer'], 'A');  // verifica respuesta
      expect(json['coinReward'], 10);  // verifica recompensa
      expect(json['options'], equals(['A', 'B', 'C', 'D']));  // verifica opciones
    });

    /// Test: Deserializar ejercicio desde JSON
    test('should deserialize exercise from JSON', () {
      // Arrange: prepara JSON de entrada
      final json = {
        'id': 'json_parse_001',  // ID en JSON
        'difficulty': 'intermediate',  // dificultad intermedia
        'type': 'coding',  // tipo código
        'question': 'Write a function',  // pregunta
        'correctAnswer': 'def func(): pass',  // respuesta
        'defaultExplanation': 'Function definition',  // explicación
        'hint': 'Use def keyword',  // pista
        'coinReward': 20,  // recompensa
        'isChallenge': true,  // es reto
      };

      // Act: parsea JSON a Exercise
      final exercise = Exercise.fromJson(json);

      // Assert: verifica campos parseados
      expect(exercise.id, 'json_parse_001');  // verifica ID
      expect(exercise.difficulty, Difficulty.intermediate);  // parsea dificultad
      expect(exercise.type, ExerciseType.coding);  // parsea tipo
      expect(exercise.isChallenge, true);  // parsea reto
      expect(exercise.coinReward, 20);  // verifica recompensa
    });

    /// Test: Redondeo serialización/deserialización
    test('should maintain data integrity through serialization round-trip', () {
      // Arrange: crea ejercicio original
      final original = Exercise(
        id: 'roundtrip_001',  // ID
        difficulty: Difficulty.advanced,  // avanzada
        type: ExerciseType.fillInTheBlank,  // completar
        question: 'Complete the code',  // pregunta
        correctAnswer: 'print("hello")',  // respuesta
        defaultExplanation: 'Print statement',  // explicación
        hint: 'Check quotes',  // pista
        coinReward: 15,  // recompensa
        isChallenge: false,  // no es reto
        subDifficulty: SubDifficulty.medium,  // dificultad media
      );

      // Act: serializa y deserializa
      final json = original.toJson();  // convierte a JSON
      final restored = Exercise.fromJson(json);  // restaura desde JSON

      // Assert: verifica que los datos se mantienen
      expect(restored.id, original.id);  // ID igual
      expect(restored.difficulty, original.difficulty);  // dificultad igual
      expect(restored.type, original.type);  // tipo igual
      expect(restored.correctAnswer, original.correctAnswer);  // respuesta igual
      expect(restored.coinReward, original.coinReward);  // recompensa igual
      expect(restored.isChallenge, original.isChallenge);  // reto igual
      expect(restored.subDifficulty, original.subDifficulty);  // sub-dificultad igual
    });
  });

  // ═══ GRUPO: Enumeraciones ═══
  group('Exercise Enums', () {
    
    /// Test: Valores de ExerciseType
    test('should have correct ExerciseType values', () {
      // Verifica que existen todos los tipos
      expect(ExerciseType.values.length, 4);  // 4 tipos
      expect(ExerciseType.values, contains(ExerciseType.multipleChoice));  // opción múltiple
      expect(ExerciseType.values, contains(ExerciseType.fillInTheBlank));  // completar
      expect(ExerciseType.values, contains(ExerciseType.bugFix));  // corregir bug
      expect(ExerciseType.values, contains(ExerciseType.coding));  // escribir código
    });

    /// Test: Valores de Difficulty
    test('should have correct Difficulty values', () {
      // Verifica que existen todos los niveles
      expect(Difficulty.values.length, 4);  // 4 niveles
      expect(Difficulty.values, contains(Difficulty.basic));  // básico
      expect(Difficulty.values, contains(Difficulty.intermediate));  // intermedio
      expect(Difficulty.values, contains(Difficulty.advanced));  // avanzado
      expect(Difficulty.values, contains(Difficulty.expert));  // experto
    });

    /// Test: Valores de SubDifficulty
    test('should have correct SubDifficulty values', () {
      // Verifica que existen todas las sub-dificultades
      expect(SubDifficulty.values.length, 3);  // 3 niveles
      expect(SubDifficulty.values, contains(SubDifficulty.easy));  // fácil
      expect(SubDifficulty.values, contains(SubDifficulty.medium));  // medio
      expect(SubDifficulty.values, contains(SubDifficulty.hard));  // difícil
    });

    /// Test: Conversor de ExerciseType
    test('ExerciseTypeConverter should convert correctly', () {
      // Arrange: crea conversor
      const converter = ExerciseTypeConverter();  // instancia del conversor

      // Act & Assert: verifica conversiones
      expect(converter.fromJson('multipleChoice'), ExerciseType.multipleChoice);  // parsea opción múltiple
      expect(converter.fromJson('fillInTheBlank'), ExerciseType.fillInTheBlank);  // parsea completar
      expect(converter.fromJson('bugFix'), ExerciseType.bugFix);  // parsea bug fix
      expect(converter.fromJson('coding'), ExerciseType.coding);  // parsea coding
      expect(converter.fromJson('invalid'), ExerciseType.multipleChoice);  // fallback a múltiple

      // Verifica conversión inversa
      expect(converter.toJson(ExerciseType.coding), 'coding');  // coding a string
      expect(converter.toJson(ExerciseType.bugFix), 'bugFix');  // bugFix a string
    });

    /// Test: Conversor de Difficulty
    test('DifficultyConverter should convert correctly', () {
      // Arrange: crea conversor
      const converter = DifficultyConverter();  // instancia del conversor

      // Act & Assert: verifica conversiones
      expect(converter.fromJson('basic'), Difficulty.basic);  // parsea básico
      expect(converter.fromJson('intermediate'), Difficulty.intermediate);  // parsea intermedio
      expect(converter.fromJson('advanced'), Difficulty.advanced);  // parsea avanzado
      expect(converter.fromJson('invalid'), Difficulty.basic);  // fallback a básico

      // Verifica conversión inversa
      expect(converter.toJson(Difficulty.expert), 'expert');  // expert a string
      expect(converter.toJson(Difficulty.basic), 'basic');  // basic a string
    });
  });

  // ═══ GRUPO: CopyWith (inmutabilidad) ═══
  group('Exercise CopyWith', () {
    
    /// Test: Modificar ejercicio con copyWith
    test('should create modified copy with copyWith', () {
      // Arrange: ejercicio original
      final original = Exercise(
        id: 'original_001',  // ID original
        difficulty: Difficulty.basic,  // dificultad básica
        type: ExerciseType.multipleChoice,  // tipo múltiple
        question: 'Original question?',  // pregunta original
        correctAnswer: 'A',  // respuesta
        defaultExplanation: 'Original explanation',  // explicación
        hint: 'Original hint',  // pista
        coinReward: 10,  // recompensa original
      );

      // Act: crea copia modificada
      final modified = original.copyWith(
        question: 'Modified question?',  // cambia pregunta
        coinReward: 20,  // cambia recompensa
        isChallenge: true,  // cambia a reto
      );

      // Assert: verifica copia
      expect(modified.id, 'original_001');  // ID se mantiene
      expect(modified.question, 'Modified question?');  // pregunta cambiada
      expect(modified.coinReward, 20);  // recompensa cambiada
      expect(modified.isChallenge, true);  // reto cambiado
      expect(modified.difficulty, Difficulty.basic);  // dificultad original se mantiene
      expect(modified.type, ExerciseType.multipleChoice);  // tipo original se mantiene
    });

    /// Test: CopyWith sin modificaciones
    test('should create identical copy when no changes provided', () {
      // Arrange: ejercicio original
      final original = Exercise(
        id: 'copy_001',  // ID
        difficulty: Difficulty.intermediate,  // intermedio
        type: ExerciseType.coding,  // código
        question: 'Write code',  // pregunta
        correctAnswer: 'print("test")',  // respuesta
        defaultExplanation: 'Test',  // explicación
        hint: 'Hint',  // pista
        coinReward: 15,  // recompensa
      );

      // Act: copia sin cambios
      final copy = original.copyWith();

      // Assert: verifica que es idéntico
      expect(copy.id, original.id);  // mismo ID
      expect(copy.difficulty, original.difficulty);  // misma dificultad
      expect(copy.type, original.type);  // mismo tipo
      expect(copy.question, original.question);  // misma pregunta
      expect(copy.correctAnswer, original.correctAnswer);  // misma respuesta
    });
  });
}
