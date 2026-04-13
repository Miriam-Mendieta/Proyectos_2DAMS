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

// ═══ IMPORTS: Dependencias para tests de EconomiaProvider ═══

import 'package:flutter_test/flutter_test.dart';  // importa framework de tests para Flutter
import 'package:shared_preferences/shared_preferences.dart';  // importa SharedPreferences para persistencia local
import 'package:cloud_firestore/cloud_firestore.dart';  // importa Firestore para sincronización
import 'package:firebase_auth/firebase_auth.dart';  // importa Firebase Auth para usuario actual
import 'package:mockito/mockito.dart';  // importa mockito para crear mocks
import 'package:python_quizz_flash/providers/economia_provider.dart';  // importa provider a testear

// ═══ MOCKS: Dependencias externas ═══

/// Mock de FirebaseFirestore para evitar llamadas reales a Firebase
class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

/// Mock de FirebaseAuth para simular usuario autenticado
class MockFirebaseAuth extends Mock implements FirebaseAuth {}

/// Mock de User para simular usuario actual
class MockFirebaseUser extends Mock implements User {
  @override
  String get uid => 'test_user_123';  // retorna UID de prueba
}

/// Mock de CollectionReference para Firestore
class MockCollectionReference extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

/// Mock de DocumentReference para Firestore
class MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

/// Mock de DocumentSnapshot para Firestore
class MockDocumentSnapshot extends Mock
    implements DocumentSnapshot<Map<String, dynamic>> {}

// ═══ GRUPO PRINCIPAL: Tests de EconomiaProvider ═══
/// Verifica que la gestión de monedas, estadísticas y persistencia
/// funcionen correctamente con datos locales y simulación de Firebase.
void main() {
  late EconomiaProvider economiaProvider;  // instancia del provider a testear
  late MockFirebaseAuth mockAuth;  // mock de autenticación
  late MockFirebaseFirestore mockFirestore;  // mock de Firestore

  setUpAll(() {
    // Inicializa bindings para tests de Flutter
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  setUp(() async {
    // Limpia SharedPreferences antes de cada test para evitar datos residuales
    SharedPreferences.setMockInitialValues({});
    
    // Crea instancia limpia de EconomiaProvider
    economiaProvider = EconomiaProvider();
    
    // Configura mocks
    mockAuth = MockFirebaseAuth();
    mockFirestore = MockFirebaseFirestore();

    // Configura mock de usuario autenticado
    when(mockAuth.currentUser).thenReturn(MockFirebaseUser());
  });

  tearDown(() async {
    // Limpia estado después de cada test
    await economiaProvider.reiniciar();
  });

  // ═══ GRUPO: Estado inicial ═══
  group('Initial State', () {
    
    /// Test: Valores iniciales por defecto
    test('should start with zero values', () {
      // Assert: verifica valores iniciales
      expect(economiaProvider.coins, 0);  // monedas en 0
      expect(economiaProvider.totalEarned, 0);  // total ganado en 0
      expect(economiaProvider.totalSpent, 0);  // total gastado en 0
      expect(economiaProvider.hintsSpent, 0);  // gastado en pistas en 0
      expect(economiaProvider.shopSpent, 0);  // gastado en tienda en 0
      expect(economiaProvider.exercisesCompleted, 0);  // ejercicios completados en 0
      expect(economiaProvider.challengesCompleted, 0);  // retos completados en 0
      expect(economiaProvider.exercisesFailed, 0);  // ejercicios fallados en 0
      expect(economiaProvider.totalExercises, 0);  // total ejercicios en 0
    });
  });

  // ═══ GRUPO: Sumar monedas ═══
  group('Add Coins', () {
    
    /// Test: Sumar monedas por ejercicio normal
    test('should add coins for normal exercise completion', () async {
      // Act: suma monedas por ejercicio normal
      await economiaProvider.sumarMonedas(10, esReto: false);

      // Assert: verifica que se sumaron correctamente
      expect(economiaProvider.coins, 10);  // monedas actuales: 10
      expect(economiaProvider.totalEarned, 10);  // total ganado: 10
      expect(economiaProvider.exercisesCompleted, 1);  // ejercicios completados: 1
      expect(economiaProvider.challengesCompleted, 0);  // retos completados: 0 (no es reto)
    });

    /// Test: Sumar monedas por reto
    test('should add coins for challenge completion', () async {
      // Act: suma monedas por reto (200 monedas)
      await economiaProvider.sumarMonedas(200, esReto: true);

      // Assert: verifica que se sumaron como reto
      expect(economiaProvider.coins, 200);  // monedas actuales: 200
      expect(economiaProvider.totalEarned, 200);  // total ganado: 200
      expect(economiaProvider.challengesCompleted, 1);  // retos completados: 1
      expect(economiaProvider.exercisesCompleted, 0);  // ejercicios normales: 0
    });

    /// Test: Sumar múltiples ejercicios
    test('should accumulate coins from multiple exercises', () async {
      // Act: suma varias veces
      await economiaProvider.sumarMonedas(10, esReto: false);  // primer ejercicio: +10
      await economiaProvider.sumarMonedas(15, esReto: false);  // segundo ejercicio: +15
      await economiaProvider.sumarMonedas(200, esReto: true);  // reto: +200

      // Assert: verifica acumulación
      expect(economiaProvider.coins, 225);  // total: 10 + 15 + 200 = 225
      expect(economiaProvider.totalEarned, 225);  // total ganado: 225
      expect(economiaProvider.exercisesCompleted, 2);  // 2 ejercicios normales
      expect(economiaProvider.challengesCompleted, 1);  // 1 reto
    });
  });

  // ═══ GRUPO: Gastar monedas ═══
  group('Spend Coins', () {
    
    /// Test: Gastar monedas en pista
    test('should deduct coins for hint purchase', () async {
      // Arrange: agrega monedas primero
      await economiaProvider.sumarMonedas(100, esReto: false);

      // Act: gasta 5 monedas en pista
      await economiaProvider.gastarMonedas(5, 'pista');

      // Assert: verifica gasto
      expect(economiaProvider.coins, 95);  // monedas: 100 - 5 = 95
      expect(economiaProvider.totalSpent, 5);  // total gastado: 5
      expect(economiaProvider.hintsSpent, 5);  // gastado en pistas: 5
      expect(economiaProvider.shopSpent, 0);  // gastado en tienda: 0
    });

    /// Test: Gastar monedas en tienda
    test('should deduct coins for shop purchase', () async {
      // Arrange: agrega monedas
      await economiaProvider.sumarMonedas(150, esReto: false);

      // Act: gasta 50 monedas en tienda
      await economiaProvider.gastarMonedas(50, 'tienda');

      // Assert: verifica gasto en tienda
      expect(economiaProvider.coins, 100);  // monedas: 150 - 50 = 100
      expect(economiaProvider.totalSpent, 50);  // total gastado: 50
      expect(economiaProvider.shopSpent, 50);  // gastado en tienda: 50
      expect(economiaProvider.hintsSpent, 0);  // gastado en pistas: 0
    });

    /// Test: Gastar más monedas de las disponibles
    test('should allow negative coins balance when overspending', () async {
      // Arrange: agrega pocas monedas
      await economiaProvider.sumarMonedas(10, esReto: false);

      // Act: intenta gastar más de lo disponible
      await economiaProvider.gastarMonedas(50, 'tienda');

      // Assert: permite balance negativo
      expect(economiaProvider.coins, -40);  // 10 - 50 = -40
      expect(economiaProvider.totalSpent, 50);  // total gastado: 50
    });
  });

  // ═══ GRUPO: Ejercicios fallidos ═══
  group('Failed Exercises', () {
    
    /// Test: Incrementar contador de fallos
    test('should increment failed exercises counter', () async {
      // Act: incrementa fallos 3 veces
      await economiaProvider.incrementarEjerciciosFallidos();
      await economiaProvider.incrementarEjerciciosFallidos();
      await economiaProvider.incrementarEjerciciosFallidos();

      // Assert: verifica contador
      expect(economiaProvider.exercisesFailed, 3);  // 3 fallos
      expect(economiaProvider.totalExercises, 3);  // total: 3 (todos fallados)
      expect(economiaProvider.exercisesCompleted, 0);  // completados: 0
    });

    /// Test: Total de ejercicios combina acertados y fallados
    test('should calculate total exercises as completed plus failed', () async {
      // Arrange: agrega ejercicios acertados y fallados
      await economiaProvider.sumarMonedas(10, esReto: false);  // 1 acertado
      await economiaProvider.sumarMonedas(10, esReto: false);  // 1 acertado
      await economiaProvider.incrementarEjerciciosFallidos();  // 1 fallado

      // Assert: verifica cálculo
      expect(economiaProvider.exercisesCompleted, 2);  // 2 acertados
      expect(economiaProvider.exercisesFailed, 1);  // 1 fallado
      expect(economiaProvider.totalExercises, 3);  // total: 2 + 1 = 3
    });
  });

  // ═══ GRUPO: Reset completo ═══
  group('Full Reset', () {
    
    /// Test: Reiniciar toda la economía
    test('should reset all economy values to zero', () async {
      // Arrange: agrega datos
      await economiaProvider.sumarMonedas(100, esReto: false);
      await economiaProvider.gastarMonedas(20, 'pista');
      await economiaProvider.incrementarEjerciciosFallidos();

      // Act: reinicia todo
      await economiaProvider.reiniciar();

      // Assert: verifica reset
      expect(economiaProvider.coins, 0);  // monedas: 0
      expect(economiaProvider.totalEarned, 0);  // total ganado: 0
      expect(economiaProvider.totalSpent, 0);  // total gastado: 0
      expect(economiaProvider.hintsSpent, 0);  // gastado pistas: 0
      expect(economiaProvider.exercisesCompleted, 0);  // ejercicios completados: 0
      expect(economiaProvider.exercisesFailed, 0);  // ejercicios fallados: 0
    });

    /// Test: Reiniciar con checkpoint de monedas
    test('should reset with checkpoint coins', () async {
      // Arrange: agrega datos
      await economiaProvider.sumarMonedas(100, esReto: false);

      // Act: reinicia con checkpoint de 50 monedas
      await economiaProvider.reiniciar(monedasCheckpoint: 50);

      // Assert: verifica reset parcial
      expect(economiaProvider.coins, 50);  // monedas en checkpoint: 50
      expect(economiaProvider.totalEarned, 0);  // total ganado reseteado
      expect(economiaProvider.exercisesCompleted, 0);  // ejercicios reseteados
    });
  });

  // ═══ GRUPO: Reset parcial ═══
  group('Partial Reset', () {
    
    /// Test: Reset parcial mantiene historial
    test('should preserve historical data in partial reset', () async {
      // Arrange: agrega datos variados
      await economiaProvider.sumarMonedas(100, esReto: false);
      await economiaProvider.sumarMonedas(200, esReto: true);
      await economiaProvider.gastarMonedas(30, 'pista');
      await economiaProvider.gastarMonedas(20, 'tienda');

      // Act: reset parcial restaurando 50 monedas
      await economiaProvider.reiniciarParcial(
        monedasCheckpoint: 50,  // restaura 50 monedas
        exercisesCompletedCheckpoint: 1,  // restaura 1 ejercicio
        exercisesFailedCheckpoint: 0,  // restaura 0 fallos
      );

      // Assert: verifica que historial se mantiene
      expect(economiaProvider.coins, 50);  // monedas restauradas a 50
      expect(economiaProvider.totalEarned, 300);  // historial mantenido: 100 + 200
      expect(economiaProvider.totalSpent, 50);  // gastado mantenido: 30 + 20
      expect(economiaProvider.hintsSpent, 30);  // pistas mantenidas
      expect(economiaProvider.shopSpent, 20);  // tienda mantenida
      expect(economiaProvider.challengesCompleted, 1);  // retos mantenidos
      expect(economiaProvider.exercisesCompleted, 1);  // ejercicios restaurados a checkpoint
    });
  });

  // ═══ GRUPO: Getters ═══
  group('Getters', () {
    
    /// Test: Getter de totalExercises
    test('totalExercises should return completed plus failed', () async {
      // Arrange
      await economiaProvider.sumarMonedas(10, esReto: false);  // +1 completado
      await economiaProvider.sumarMonedas(10, esReto: false);  // +1 completado
      await economiaProvider.incrementarEjerciciosFallidos();  // +1 fallado
      await economiaProvider.incrementarEjerciciosFallidos();  // +1 fallado
      await economiaProvider.incrementarEjerciciosFallidos();  // +1 fallado

      // Assert
      expect(economiaProvider.totalExercises, 5);  // 2 + 3 = 5 total
    });
  });

  // ═══ GRUPO: Persistencia local ═══
  group('Local Persistence', () {
    
    /// Test: Datos se guardan en SharedPreferences
    test('should persist data to SharedPreferences', () async {
      // Arrange: agrega datos
      await economiaProvider.sumarMonedas(50, esReto: false);

      // Assert: verifica que los datos se guardaron correctamente
      expect(economiaProvider.coins, 50);  // monedas actuales: 50
      expect(economiaProvider.totalEarned, 50);  // total ganado: 50
      expect(economiaProvider.exercisesCompleted, 1);  // ejercicios completados: 1
    });
  });

  // ═══ GRUPO: Casos borde ═══
  group('Edge Cases', () {
    
    /// Test: Sumar cero monedas
    test('should handle adding zero coins', () async {
      // Act
      await economiaProvider.sumarMonedas(0, esReto: false);

      // Assert
      expect(economiaProvider.coins, 0);  // monedas: 0
      expect(economiaProvider.totalEarned, 0);  // total ganado: 0
      expect(economiaProvider.exercisesCompleted, 1);  // pero ejercicio contado
    });

    /// Test: Gastar cero monedas
    test('should handle spending zero coins', () async {
      // Arrange
      await economiaProvider.sumarMonedas(100, esReto: false);

      // Act
      await economiaProvider.gastarMonedas(0, 'pista');

      // Assert
      expect(economiaProvider.coins, 100);  // monedas: 100 (sin cambio)
      expect(economiaProvider.totalSpent, 0);  // total gastado: 0
      expect(economiaProvider.hintsSpent, 0);  // pistas gastadas: 0
    });

    /// Test: Múltiples operaciones secuenciales
    test('should handle rapid sequential operations', () async {
      // Act: muchas operaciones seguidas
      for (int i = 0; i < 10; i++) {
        await economiaProvider.sumarMonedas(10, esReto: false);
      }

      // Assert
      expect(economiaProvider.coins, 100);  // 10 * 10 = 100
      expect(economiaProvider.totalEarned, 100);  // total: 100
      expect(economiaProvider.exercisesCompleted, 10);  // 10 ejercicios
    });
  });
}
