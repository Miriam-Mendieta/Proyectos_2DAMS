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

// ═══ IMPORTS: Dependencias de economía y persistencia ═══

import 'package:flutter/material.dart';  // importa ChangeNotifier para notificación de cambios
import 'package:flutter_riverpod/flutter_riverpod.dart';  // importa Riverpod para gestión de estado
import 'package:shared_preferences/shared_preferences.dart';  // importa SharedPreferences para persistencia local rápida
import 'package:cloud_firestore/cloud_firestore.dart';  // importa Firestore para sincronización en la nube
import 'package:firebase_auth/firebase_auth.dart';  // importa Firebase Auth para identificar al usuario actual

/// ═══ CLASE: EconomiaProvider ═══
/// Gestiona la economía del juego (monedas, puntos, gastos) con persistencia
/// local para actualizaciones instantáneas y sincronización en segundo plano
/// con Firebase. Usa patrón Singleton con ChangeNotifier.
class EconomiaProvider extends ChangeNotifier {
  static final EconomiaProvider _instance = EconomiaProvider._internal();  // instancia única singleton
  factory EconomiaProvider() => _instance;  // factory que retorna siempre la misma instancia
  EconomiaProvider._internal();  // constructor privado para patrón singleton

  int _coins = 0;  // monedas actuales del usuario
  int _totalEarned = 0;  // total de monedas ganadas históricamente
  int _totalSpent = 0;  // total de monedas gastadas históricamente
  int _hintsSpent = 0;  // monedas gastadas en pistas
  int _shopSpent = 0;  // monedas gastadas en la tienda
  int _exercisesCompleted = 0;  // contador de ejercicios completados (aciertos)
  int _challengesCompleted = 0;  // contador de retos completados
  int _exercisesFailed = 0;  // contador de ejercicios fallados

  String? _currentUserId;  // UID del usuario actual para persistencia
  bool _initialized = false;  // indica si ya se inicializó para este usuario

  /// Getters públicos de solo lectura
  int get coins => _coins;  // retorna las monedas actuales
  int get totalEarned => _totalEarned;  // retorna total ganado
  int get totalSpent => _totalSpent;  // retorna total gastado
  int get hintsSpent => _hintsSpent;  // retorna gastado en pistas
  int get shopSpent => _shopSpent;  // retorna gastado en tienda
  int get exercisesCompleted => _exercisesCompleted;  // retorna ejercicios acertados
  int get challengesCompleted => _challengesCompleted;  // retorna retos completados
  int get exercisesFailed => _exercisesFailed;  // retorna ejercicios fallados
  int get totalExercises => _exercisesCompleted + _exercisesFailed;  // retorna total intentados (aciertos + errores)

  /// ═══ MÉTODO: initialize ═══
  /// Inicializa la economía para el usuario actual cargando datos locales
  /// y sincronizando con Firebase en segundo plano.
  Future<void> initialize() async {
    if (_initialized) return;  // si ya está inicializado, sale inmediatamente

    final user = FirebaseAuth.instance.currentUser;  // obtiene el usuario autenticado actual
    if (user == null) return;  // si no hay usuario, no inicializa

    _currentUserId = user.uid;  // almacena el UID para operaciones de persistencia

    await _loadFromLocal();  // carga datos desde SharedPreferences (rápido)
    await _forceSyncWithFirebase();  // sincroniza FORZOSAMENTE con Firebase para asegurar datos correctos

    _initialized = true;  // marca como inicializado
    notifyListeners();  // notifica a los listeners que los datos cambiaron
  }

  /// ═══ MÉTODO: _forceSyncWithFirebase ═══
  /// Sincroniza FORZOSAMENTE con Firebase Firestore sin verificar si los datos son mayores.
  /// Se usa durante la inicialización para asegurar que los datos locales coincidan con Firebase.
  Future<void> _forceSyncWithFirebase() async {
    if (_currentUserId == null) return;  // si no hay usuario, no sincroniza

    try {  // try-catch para manejar errores de red o permisos
      final doc = await FirebaseFirestore.instance  // obtiene documento del usuario
          .collection('users')  // en la colección 'users'
          .doc(_currentUserId)  // documento con el UID
          .get();  // lee el documento

      if (doc.exists) {  // si el documento existe en Firestore
        final data = doc.data() ?? {};  // obtiene los datos o mapa vacío

        _coins = data['coins'] as int? ?? 0;  // lee monedas desde Firebase
        _totalEarned = data['totalEarned'] as int? ?? 0;  // lee total ganado
        _totalSpent = data['totalSpent'] as int? ?? 0;  // lee total gastado
        _hintsSpent = data['hints_spent'] as int? ?? 0;  // lee gastado en pistas
        _shopSpent = data['shop_spent'] as int? ?? 0;  // lee gastado en tienda
        _exercisesCompleted = data['exercises_completed'] as int? ?? 0;  // lee ejercicios completados
        _challengesCompleted = data['challenges_completed'] as int? ?? 0;  // lee retos completados
        _exercisesFailed = data['exercises_failed'] as int? ?? 0;  // lee ejercicios fallados

        await _saveToLocal();  // guarda los datos de Firebase en SharedPreferences
      }
    } catch (e) {  // captura errores de red o permisos
      // Error silencioso - no exponer detalles en consola
    }
  }

  /// ═══ MÉTODO: reset ═══
  /// Resetea COMPLETAMENTE el provider para un nuevo usuario.
  /// Se llama al eliminar la cuenta para permitir que un nuevo usuario se inicialice desde cero.
  /// También limpia los datos locales de SharedPreferences para evitar que persistan.
  Future<void> reset() async {
    // Limpia datos locales de SharedPreferences del usuario anterior
    if (_currentUserId != null) {
      try {
        final prefs = await SharedPreferences.getInstance();  // obtiene instancia
        final prefix = 'economia_${_currentUserId}_';  // prefijo del usuario anterior
        
        // Elimina todas las claves del usuario anterior
        await prefs.remove('${prefix}coins');
        await prefs.remove('${prefix}totalEarned');
        await prefs.remove('${prefix}totalSpent');
        await prefs.remove('${prefix}hintsSpent');
        await prefs.remove('${prefix}shopSpent');
        await prefs.remove('${prefix}exercisesCompleted');
        await prefs.remove('${prefix}challengesCompleted');
        await prefs.remove('${prefix}exercisesFailed');
      } catch (e) {
        // Error silencioso - no exponer detalles en consola
      }
    }

    _coins = 0;  // resetea monedas
    _totalEarned = 0;  // resetea total ganado
    _totalSpent = 0;  // resetea total gastado
    _hintsSpent = 0;  // resetea gastado en pistas
    _shopSpent = 0;  // resetea gastado en tienda
    _exercisesCompleted = 0;  // resetea ejercicios completados
    _challengesCompleted = 0;  // resetea retos completados
    _exercisesFailed = 0;  // resetea ejercicios fallados
    _currentUserId = null;  // limpia el ID de usuario
    _initialized = false;  // permite re-inicialización para nuevo usuario
    notifyListeners();  // notifica a los listeners del cambio
  }

  /// ═══ MÉTODO: _loadFromLocal ═══
  /// Carga los datos de economía desde SharedPreferences del dispositivo.
  Future<void> _loadFromLocal() async {
    if (_currentUserId == null) return;  // si no hay usuario, no carga

    final prefs = await SharedPreferences.getInstance();  // obtiene instancia de SharedPreferences
    final prefix = 'economia_${_currentUserId}_';  // prefijo único para las claves de este usuario

    _coins = prefs.getInt('${prefix}coins') ?? 0;  // lee monedas o 0 si no existe
    _totalEarned = prefs.getInt('${prefix}totalEarned') ?? 0;  // lee total ganado
    _totalSpent = prefs.getInt('${prefix}totalSpent') ?? 0;  // lee total gastado
    _hintsSpent = prefs.getInt('${prefix}hintsSpent') ?? 0;  // lee gastado en pistas
    _shopSpent = prefs.getInt('${prefix}shopSpent') ?? 0;  // lee gastado en tienda
    _exercisesCompleted = prefs.getInt('${prefix}exercisesCompleted') ?? 0;  // lee ejercicios completados
    _challengesCompleted = prefs.getInt('${prefix}challengesCompleted') ?? 0;  // lee retos completados
    _exercisesFailed = prefs.getInt('${prefix}exercisesFailed') ?? 0;  // lee ejercicios fallados
  }

  /// ═══ MÉTODO: _syncWithFirebase ═══
  /// Sincroniza los datos locales con Firebase Firestore.
  /// Solo actualiza si los datos de Firebase son más recientes/mayores.
  Future<void> _syncWithFirebase() async {
    if (_currentUserId == null) return;  // si no hay usuario, no sincroniza

    try {  // try-catch para manejar errores de red o permisos
      final doc = await FirebaseFirestore.instance  // obtiene documento del usuario
          .collection('users')  // en la colección 'users'
          .doc(_currentUserId)  // documento con el UID
          .get();  // lee el documento

      if (doc.exists) {  // si el documento existe en Firestore
        final data = doc.data() ?? {};  // obtiene los datos o mapa vacío

        final newCoins = data['coins'] as int? ?? 0;  // lee monedas desde Firebase
        final newTotalEarned = data['totalEarned'] as int? ?? 0;  // lee total ganado
        final newTotalSpent = data['totalSpent'] as int? ?? 0;  // lee total gastado
        final newHintsSpent = data['hints_spent'] as int? ?? 0;  // lee gastado en pistas
        final newShopSpent = data['shop_spent'] as int? ?? 0;  // lee gastado en tienda
        final newExercisesCompleted = data['exercises_completed'] as int? ?? 0;  // lee ejercicios completados
        final newChallengesCompleted = data['challenges_completed'] as int? ?? 0;  // lee retos completados
        final newExercisesFailed = data['exercises_failed'] as int? ?? 0;  // lee ejercicios fallados

        /// Solo actualiza si los datos de Firebase son mayores (más recientes).
        if (newCoins > _coins || newTotalEarned > _totalEarned ||
            newExercisesCompleted > _exercisesCompleted || newExercisesFailed > _exercisesFailed) {
          _coins = newCoins;  // actualiza monedas locales
          _totalEarned = newTotalEarned;  // actualiza total ganado
          _totalSpent = newTotalSpent;  // actualiza total gastado
          _hintsSpent = newHintsSpent;  // actualiza gastado en pistas
          _shopSpent = newShopSpent;  // actualiza gastado en tienda
          _exercisesCompleted = newExercisesCompleted;  // actualiza ejercicios completados
          _challengesCompleted = newChallengesCompleted;  // actualiza retos completados
          _exercisesFailed = newExercisesFailed;  // actualiza ejercicios fallados
          await _saveToLocal();  // guarda los nuevos datos en SharedPreferences
          notifyListeners();  // notifica a los listeners del cambio
        }
      }
    } catch (e) {  // captura errores de red o permisos
      // Error silencioso - no exponer detalles en consola
    }
  }

  /// ═══ MÉTODO: _saveToLocal ═══
  /// Guarda todos los datos de economía en SharedPreferences.
  Future<void> _saveToLocal() async {
    if (_currentUserId == null) return;  // si no hay usuario, no guarda

    final prefs = await SharedPreferences.getInstance();  // obtiene instancia de SharedPreferences
    final prefix = 'economia_${_currentUserId}_';  // prefijo único para este usuario

    await prefs.setInt('${prefix}coins', _coins);  // guarda monedas actuales
    await prefs.setInt('${prefix}totalEarned', _totalEarned);  // guarda total ganado
    await prefs.setInt('${prefix}totalSpent', _totalSpent);  // guarda total gastado
    await prefs.setInt('${prefix}hintsSpent', _hintsSpent);  // guarda gastado en pistas
    await prefs.setInt('${prefix}shopSpent', _shopSpent);  // guarda gastado en tienda
    await prefs.setInt('${prefix}exercisesCompleted', _exercisesCompleted);  // guarda ejercicios completados
    await prefs.setInt('${prefix}challengesCompleted', _challengesCompleted);  // guarda retos completados
    await prefs.setInt('${prefix}exercisesFailed', _exercisesFailed);  // guarda ejercicios fallados
  }

  /// ═══ MÉTODO: _syncToFirebase ═══
  /// Envía los datos locales a Firebase Firestore en segundo plano.
  Future<void> _syncToFirebase() async {
    if (_currentUserId == null) return;  // si no hay usuario, no sincroniza

    try {  // try-catch para manejar errores de red
      await FirebaseFirestore.instance
          .collection('users')  // en la colección 'users'
          .doc(_currentUserId)  // documento del usuario actual
          .update({  // actualiza los campos
        'coins': _coins,  // monedas actuales
        'totalEarned': _totalEarned,  // total ganado
        'totalSpent': _totalSpent,  // total gastado
        'hints_spent': _hintsSpent,  // gastado en pistas
        'shop_spent': _shopSpent,  // gastado en tienda
        'exercises_completed': _exercisesCompleted,  // ejercicios completados
        'challenges_completed': _challengesCompleted,  // retos completados
        'exercises_failed': _exercisesFailed,  // ejercicios fallados
        'last_sync': FieldValue.serverTimestamp(),  // marca de tiempo de última sincronización
      });
    } catch (e) {  // captura errores de red o permisos
      // Error silencioso - no exponer detalles en consola
    }
  }

  /// ═══ MÉTODO: sumarMonedas ═══
  /// Suma monedas al completar un ejercicio o reto. Actualización instantánea.
  /// esReto=true otorga +1 al contador de retos, esReto=false al de ejercicios.
  Future<void> sumarMonedas(int cantidad, {bool esReto = false}) async {
    _coins += cantidad;  // suma las monedas al balance actual
    _totalEarned += cantidad;  // suma al total histórico ganado

    if (esReto) {  // si es un reto final
      _challengesCompleted += 1;  // incrementa contador de retos completados
    } else {  // si es un ejercicio normal
      _exercisesCompleted += 1;  // incrementa contador de ejercicios completados
    }

    notifyListeners();  // notifica a los listeners del cambio inmediato
    await _saveToLocal();  // guarda en SharedPreferences
    await _syncToFirebase();  // sincroniza con Firebase y ESPERA a que termine (antes era sin await)
  }

  /// ═══ MÉTODO: incrementarEjerciciosFallidos ═══
  /// Incrementa el contador de ejercicios fallados. Actualización instantánea.
  Future<void> incrementarEjerciciosFallidos() async {
    _exercisesFailed += 1;  // incrementa contador de fallos
    notifyListeners();  // notifica a los listeners
    await _saveToLocal();  // guarda localmente
    await _syncToFirebase();  // sincroniza con Firebase y ESPERA
  }

  /// ═══ MÉTODO: gastarMonedas ═══
  /// Resta monedas por compra de pistas o items de tienda.
  /// tipo='pista' suma a hintsSpent, tipo='tienda' suma a shopSpent.
  Future<void> gastarMonedas(int cantidad, String tipo) async {
    _coins -= cantidad;  // resta las monedas del balance actual
    _totalSpent += cantidad;  // suma al total histórico gastado

    if (tipo == 'pista') {  // si el gasto es en pistas
      _hintsSpent += cantidad;  // suma al contador de pistas compradas
    } else if (tipo == 'tienda') {  // si el gasto es en tienda
      _shopSpent += cantidad;  // suma al contador de compras en tienda
    }

    notifyListeners();  // notifica a los listeners
    await _saveToLocal();  // guarda localmente
    await _syncToFirebase();  // sincroniza con Firebase y ESPERA
  }

  /// ═══ MÉTODO: reiniciar ═══
  /// Reinicia TODA la economía: monedas, ejercicios, retos e historial a cero
  /// (o al checkpoint de monedas especificado).
  Future<void> reiniciar({int monedasCheckpoint = 0}) async {
    _coins = monedasCheckpoint;  // restaura monedas al checkpoint (0 por defecto)
    _totalEarned = 0;  // resetea total ganado
    _totalSpent = 0;  // resetea total gastado
    _hintsSpent = 0;  // resetea gastado en pistas
    _shopSpent = 0;  // resetea gastado en tienda
    _exercisesCompleted = 0;  // resetea ejercicios completados
    _challengesCompleted = 0;  // resetea retos completados
    _exercisesFailed = 0;  // resetea ejercicios fallados
    notifyListeners();  // notifica a los listeners
    await _saveToLocal();  // guarda localmente
    await _syncToFirebase();  // sincroniza con Firebase y ESPERA
  }

  /// ═══ MÉTODO: reiniciarParcial ═══
  /// Reset parcial: restaura monedas y contadores de ejercicios al checkpoint
  /// del nivel anterior. MANTIENE logros de niveles anteriores.
  Future<void> reiniciarParcial({
    int monedasCheckpoint = 0,  // monedas a restaurar
    int exercisesCompletedCheckpoint = 0,  // ejercicios completados a restaurar
    int exercisesFailedCheckpoint = 0,  // ejercicios fallados a restaurar
  }) async {
    _coins = monedasCheckpoint;  // restaura monedas al checkpoint
    _exercisesCompleted = exercisesCompletedCheckpoint;  // restaura ejercicios completados
    _exercisesFailed = exercisesFailedCheckpoint;  // restaura ejercicios fallados
    // NO toca: totalEarned, challengesCompleted, etc. (mantiene historial)
    notifyListeners();  // notifica a los listeners
    await _saveToLocal();  // guarda localmente
    await _syncToFirebase();  // sincroniza con Firebase y ESPERA
  }

  /// ═══ MÉTODO: recargarDesdeFirebase ═══
  /// Fuerza la recarga de datos desde Firebase (ignora caché local).
  Future<void> recargarDesdeFirebase() async {
    await _syncWithFirebase();  // sincroniza con Firebase sobrescribiendo datos locales
  }
}

/// ═══ PROVIDER: economiaProviderNotifier ═══
/// Provider de Riverpod que expone la instancia singleton de EconomiaProvider.
/// Inicializa automáticamente al ser escuchado.
final economiaProviderNotifier = Provider<EconomiaProvider>((ref) {  // crea el provider
  final provider = EconomiaProvider();  // obtiene la instancia singleton
  provider.initialize();  // inicializa cargando datos del usuario actual
  return provider;  // retorna el provider listo para usar
});

/// ═══ MÉTODO: invalidateEconomiaProvider ═══
/// Invalida el provider de economía para forzar su recreación.
/// Se llama tras eliminar una cuenta para que el nuevo usuario obtenga una instancia limpia.
void invalidateEconomiaProvider(ProviderContainer container) {
  container.invalidate(economiaProviderNotifier);  // invalida el provider
  container.read(economiaProviderNotifier).initialize();  // reinicializa para el nuevo usuario
}

// Alias para compatibilidad con código existente que usa 'economiaProvider'.
final economiaProvider = economiaProviderNotifier;  // alias que apunta al mismo provider
