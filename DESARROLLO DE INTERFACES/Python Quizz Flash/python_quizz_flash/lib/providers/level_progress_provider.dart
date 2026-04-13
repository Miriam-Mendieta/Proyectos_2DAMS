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

// ═══ IMPORTS: Dependencias de progreso de niveles ═══

import 'package:flutter/foundation.dart';  // importa debugPrint para mensajes de debugging
import 'package:riverpod_annotation/riverpod_annotation.dart';  // importa riverpod_annotation para generar providers
import 'package:firebase_auth/firebase_auth.dart';  // importa Firebase Auth para identificar al usuario
import 'package:cloud_firestore/cloud_firestore.dart';  // importa Firestore para persistencia de progreso
import 'package:freezed_annotation/freezed_annotation.dart';  // importa freezed para clases inmutables

part 'level_progress_provider.freezed.dart';  // archivo generado por freezed con implementación inmutable
part 'level_progress_provider.g.dart';  // archivo generado por json_serializable

/// ═══ CLASE: LevelProgress ═══
/// Modelo inmutable que representa el progreso de cada nivel del usuario.
/// Generado con @freezed. Almacena estado de completado, desbloqueos
/// y checkpoints de monedas por nivel.
@freezed  // anotación que indica a freezed que genere la clase inmutable
abstract class LevelProgress with _$LevelProgress {  // clase abstracta que mezcla el mixin generado
  const factory LevelProgress({  // factory constructor que define la estructura del progreso
    @Default(false) bool basicCompleted,  // true si completó los 20 ejercicios del nivel básico
    @Default(false) bool challengeBasicCompleted,  // true si superó el reto del nivel básico
    @Default(false) bool intermediateUnlocked,  // true si desbloqueó el nivel intermedio
    @Default(false) bool intermediateCompleted,  // true si completó los 20 ejercicios del nivel intermedio
    @Default(false) bool challengeIntermediateCompleted,  // true si superó el reto del nivel intermedio
    @Default(false) bool advancedUnlocked,  // true si desbloqueó el nivel avanzado
    @Default(false) bool advancedCompleted,  // true si completó los 20 ejercicios del nivel avanzado
    @Default(0) int coinsAfterBasicChallenge,  // monedas guardadas tras pasar el reto básico
    @Default(0) int coinsAfterIntermediateChallenge,  // monedas guardadas tras pasar el reto intermedio
    @Default(0) int coinsAfterBasicLevel,  // monedas al completar nivel básico (sin reto)
    @Default(0) int coinsAfterIntermediateLevel,  // monedas al completar nivel intermedio (sin reto)
    @Default(0) int coinsAfterAdvancedLevel,  // monedas al completar nivel avanzado (sin reto)
  }) = _LevelProgress;  // nombre de la clase concreta generada por freezed
}

/// ═══ CLASE: LevelProgressNotifier ═══
/// Notifier de Riverpod que gestiona el estado de desbloqueo y progreso de niveles.
/// Carga el progreso desde Firestore y proporciona métodos para marcar niveles
/// como completados, desbloquear siguientes niveles y resetear progreso.
@riverpod  // anotación que genera el provider automáticamente
class LevelProgressNotifier extends _$LevelProgressNotifier {  // extiende el generado _$LevelProgressNotifier
  @override  // sobrescribe el método build del notifier
  FutureOr<LevelProgress> build() async {  // retorna FutureOr porque carga datos asíncronamente
    return _loadProgress();  // carga el progreso del usuario desde Firestore
  }

  /// ═══ MÉTODO: _loadProgress ═══
  /// Carga el progreso del usuario desde Firestore.
  /// Si no hay usuario o hay error, retorna estado inicial (todo false/0).
  Future<LevelProgress> _loadProgress() async {
    final user = FirebaseAuth.instance.currentUser;  // obtiene el usuario autenticado actual
    if (user == null) {  // si no hay usuario logueado
      return const LevelProgress();  // retorna estado inicial (solo básico disponible)
    }

    try {  // try-catch para manejar errores de red o permisos
      final doc = await FirebaseFirestore.instance  // obtiene documento del usuario
          .collection('users')  // en la colección 'users'
          .doc(user.uid)  // documento con el UID
          .get();  // lee el documento

      if (!doc.exists) {  // si el documento no existe
        return const LevelProgress();  // retorna estado inicial
      }

      final data = doc.data() ?? {};  // obtiene los datos o mapa vacío

      return LevelProgress(  // crea instancia de LevelProgress con los datos cargados
        basicCompleted: data['basic_completed'] ?? false,  // lee estado del nivel básico
        challengeBasicCompleted: data['challenge_basic_completed'] ?? false,  // lee estado del reto básico
        intermediateUnlocked: data['intermediate_unlocked'] ?? false,  // lee desbloqueo intermedio
        intermediateCompleted: data['intermediate_completed'] ?? false,  // lee estado del nivel intermedio
        challengeIntermediateCompleted: data['challenge_intermediate_completed'] ?? false,  // lee estado del reto intermedio
        advancedUnlocked: data['advanced_unlocked'] ?? false,  // lee desbloqueo avanzado
        advancedCompleted: data['advanced_completed'] ?? false,  // lee estado del nivel avanzado
        coinsAfterBasicChallenge: data['coins_after_basic_challenge'] ?? 0,  // lee monedas tras reto básico
        coinsAfterIntermediateChallenge: data['coins_after_intermediate_challenge'] ?? 0,  // lee monedas tras reto intermedio
        coinsAfterBasicLevel: data['coins_after_basic_level'] ?? 0,  // lee monedas tras nivel básico
        coinsAfterIntermediateLevel: data['coins_after_intermediate_level'] ?? 0,  // lee monedas tras nivel intermedio
        coinsAfterAdvancedLevel: data['coins_after_advanced_level'] ?? 0,  // lee monedas tras nivel avanzado
      );
    } catch (e) {  // captura errores de red o permisos
      return const LevelProgress();  // en caso de error, retorna estado vacío
    }
  }

  /// ═══ MÉTODO: completeBasicLevel ═══
  /// Marca el nivel básico como completado (al terminar los 20 ejercicios).
  /// Guarda las monedas actuales como checkpoint parcial.
  Future<void> completeBasicLevel() async {
    final user = FirebaseAuth.instance.currentUser;  // obtiene usuario actual
    if (user == null) return;  // si no hay usuario, sale

    final currentCoins = await _getCurrentCoins();  // obtiene monedas actuales del usuario

    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({  // actualiza documento en Firestore
      'basic_completed': true,  // marca nivel básico como completado
      'coins_after_basic_level': currentCoins,  // guarda checkpoint de monedas al completar nivel
    });

    ref.invalidateSelf();  // invalida el provider para recargar el estado actualizado
  }

  /// ═══ MÉTODO: completeChallengeBasic ═══
  /// Marca el reto básico como completado y desbloquea el nivel intermedio.
  /// Guarda las monedas actuales como checkpoint tras superar el reto.
  Future<void> completeChallengeBasic() async {
    final user = FirebaseAuth.instance.currentUser;  // obtiene usuario actual
    if (user == null) return;  // si no hay usuario, sale

    final currentCoins = await _getCurrentCoins();  // obtiene monedas actuales

    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({  // actualiza en Firestore
      'challenge_basic_completed': true,  // marca reto básico como completado
      'intermediate_unlocked': true,  // desbloquea nivel intermedio
      'coins_after_basic_challenge': currentCoins,  // guarda checkpoint de monedas tras reto
    });

    ref.invalidateSelf();  // invalida para recargar el estado actualizado
  }

  /// ═══ MÉTODO: completeIntermediateLevel ═══
  /// Marca el nivel intermedio como completado (20 ejercicios).
  /// Guarda las monedas actuales como checkpoint parcial.
  Future<void> completeIntermediateLevel() async {
    final user = FirebaseAuth.instance.currentUser;  // obtiene usuario actual
    if (user == null) return;  // si no hay usuario, sale

    final currentCoins = await _getCurrentCoins();  // obtiene monedas actuales

    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({  // actualiza en Firestore
      'intermediate_completed': true,  // marca nivel intermedio como completado
      'coins_after_intermediate_level': currentCoins,  // guarda checkpoint de monedas
    });

    ref.invalidateSelf();  // invalida para recargar el estado
  }

  /// ═══ MÉTODO: completeChallengeIntermediate ═══
  /// Marca el reto intermedio como completado y desbloquea el nivel avanzado.
  /// Guarda las monedas actuales como checkpoint tras superar el reto.
  Future<void> completeChallengeIntermediate() async {
    final user = FirebaseAuth.instance.currentUser;  // obtiene usuario actual
    if (user == null) return;  // si no hay usuario, sale

    final currentCoins = await _getCurrentCoins();  // obtiene monedas actuales

    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({  // actualiza en Firestore
      'challenge_intermediate_completed': true,  // marca reto intermedio como completado
      'advanced_unlocked': true,  // desbloquea nivel avanzado
      'coins_after_intermediate_challenge': currentCoins,  // guarda checkpoint de monedas
    });

    ref.invalidateSelf();  // invalida para recargar el estado
  }

  /// ═══ MÉTODO: completeAdvancedLevel ═══
  /// Marca el nivel avanzado como completado (20 ejercicios).
  /// Guarda las monedas actuales como checkpoint parcial.
  Future<void> completeAdvancedLevel() async {
    final user = FirebaseAuth.instance.currentUser;  // obtiene usuario actual
    if (user == null) return;  // si no hay usuario, sale

    final currentCoins = await _getCurrentCoins();  // obtiene monedas actuales

    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({  // actualiza en Firestore
      'advanced_completed': true,  // marca nivel avanzado como completado
      'coins_after_advanced_level': currentCoins,  // guarda checkpoint de monedas
    });

    ref.invalidateSelf();  // invalida para recargar el estado
  }

  /// ═══ MÉTODO: _getCurrentCoins ═══
  /// Obtiene las monedas actuales del usuario directamente desde Firestore.
  Future<int> _getCurrentCoins() async {
    final user = FirebaseAuth.instance.currentUser;  // obtiene usuario actual
    if (user == null) return 0;  // si no hay usuario, retorna 0

    final doc = await FirebaseFirestore.instance  // obtiene documento del usuario
        .collection('users')  // en la colección 'users'
        .doc(user.uid)  // documento con el UID
        .get();  // lee el documento

    return doc.data()?['coins'] ?? 0;  // retorna el campo 'coins' o 0 si no existe
  }

  /// ═══ MÉTODO: isLevelUnlocked ═══
  /// Verifica si un nivel está desbloqueado según el progreso actual.
  /// El nivel básico siempre está disponible.
  bool isLevelUnlocked(String difficulty) {  // recibe la dificultad a verificar
    final progress = state.value;  // obtiene el valor actual del estado
    if (progress == null) return false;  // si no hay estado, retorna false

    switch (difficulty) {  // evalúa según la dificultad
      case 'basic': return true;  // el básico siempre está disponible
      case 'intermediate': return progress.challengeBasicCompleted;  // intermedio requiere superar reto básico
      case 'advanced': return progress.challengeIntermediateCompleted;  // avanzado requiere superar reto intermedio
      default: return false;  // cualquier otro nivel no está disponible
    }
  }

  /// ═══ MÉTODO: isLevelCompleted ═══
  /// Verifica si un nivel está completamente terminado (nivel + reto).
  bool isLevelCompleted(String difficulty) {  // recibe la dificultad a verificar
    final progress = state.value;  // obtiene el valor actual del estado
    if (progress == null) return false;  // si no hay estado, retorna false

    switch (difficulty) {  // evalúa según la dificultad
      case 'basic': return progress.challengeBasicCompleted;  // básico completado = reto básico superado
      case 'intermediate': return progress.challengeIntermediateCompleted;  // intermedio completado = reto intermedio superado
      case 'advanced': return progress.advancedCompleted;  // avanzado completado = nivel avanzado superado
      default: return false;  // cualquier otro nivel no está completado
    }
  }

  /// ═══ MÉTODO: resetAllProgressLocal ═══
  /// Resetea TODO el progreso del usuario solo en memoria (sin sync con Firestore).
  /// Versión rápida para UX instantánea, sincronizar después en background.
  Future<void> resetAllProgressLocal() async {
    final user = FirebaseAuth.instance.currentUser;  // obtiene usuario actual
    if (user == null) {  // si no hay usuario
      throw Exception('Usuario no autenticado');  // lanza excepción
    }

    /// Actualiza el estado local inmediatamente con valores a cero/falso.
    state = AsyncData(  // establece nuevo estado asíncrono
      const LevelProgress(  // nueva instancia con todo en falso/cero
        basicCompleted: false,  // nivel básico no completado
        challengeBasicCompleted: false,  // reto básico no superado
        intermediateUnlocked: false,  // intermedio bloqueado
        intermediateCompleted: false,  // intermedio no completado
        challengeIntermediateCompleted: false,  // reto intermedio no superado
        advancedUnlocked: false,  // avanzado bloqueado
        advancedCompleted: false,  // avanzado no completado
        coinsAfterBasicChallenge: 0,  // sin monedas de checkpoint básico
        coinsAfterIntermediateChallenge: 0,  // sin monedas de checkpoint intermedio
        coinsAfterBasicLevel: 0,  // sin monedas de nivel básico
        coinsAfterIntermediateLevel: 0,  // sin monedas de nivel intermedio
        coinsAfterAdvancedLevel: 0,  // sin monedas de nivel avanzado
      ),
    );
  }

  /// ═══ MÉTODO: resetAllProgress ═══
  /// Resetea TODO el progreso del usuario (niveles, challenges y desbloqueos).
  /// Versión completa: reset local + sincronización con Firestore.
  /// Usa FieldValue.increment() para evitar condiciones de carrera en monedas.
  Future<void> resetAllProgress() async {
    final user = FirebaseAuth.instance.currentUser;  // obtiene usuario actual
    if (user == null) {  // si no hay usuario
      throw Exception('Usuario no autenticado');  // lanza excepción
    }

    /// Obtiene las monedas actuales para calcular el decremento.
    final userDoc = await FirebaseFirestore.instance  // obtiene documento del usuario
        .collection('users')  // en la colección 'users'
        .doc(user.uid)  // documento con el UID
        .get();  // lee el documento

    /// Si el documento no existe, lo crea con valores por defecto.
    if (!userDoc.exists) {  // si el documento no existe
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({  // crea documento nuevo
        'username': 'Usuario',  // nombre por defecto
        'username_search': 'usuario',  // versión en minúsculas para búsqueda
        'email': user.email ?? '',  // email del usuario o vacío
        'createdAt': FieldValue.serverTimestamp(),  // marca de tiempo del servidor
        'coins': 0,  // monedas a cero
        'level': 1,  // nivel inicial 1
        'basic_completed': false,  // básico no completado
        'challenge_basic_completed': false,  // reto básico no superado
        'intermediate_unlocked': false,  // intermedio bloqueado
        'intermediate_completed': false,  // intermedio no completado
        'challenge_intermediate_completed': false,  // reto intermedio no superado
        'advanced_unlocked': false,  // avanzado bloqueado
        'advanced_completed': false,  // avanzado no completado
        'progress_basic': 0,  // progreso básico a cero
        'progress_intermediate': 0,  // progreso intermedio a cero
        'progress_advanced': 0,  // progreso avanzado a cero
      });
      return;  // sale tras crear el documento
    }

    final currentCoins = userDoc.data()?['coins'] ?? 0;  // obtiene monedas actuales del documento

    /// Resetea todos los campos de progreso en Firestore.
    /// Usa increment negativo para evitar condiciones de carrera en monedas.
    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({  // actualiza documento
      'basic_completed': false,  // marca básico como no completado
      'challenge_basic_completed': false,  // marca reto básico como no superado
      'intermediate_unlocked': false,  // bloquea intermedio
      'intermediate_completed': false,  // marca intermedio como no completado
      'challenge_intermediate_completed': false,  // marca reto intermedio como no superado
      'advanced_unlocked': false,  // bloquea avanzado
      'advanced_completed': false,  // marca avanzado como no completado
      'progress_basic': 0,  // progreso básico a cero
      'progress_intermediate': 0,  // progreso intermedio a cero
      'progress_advanced': 0,  // progreso avanzado a cero
      'coins': FieldValue.increment(-currentCoins),  // resta todas las monedas actuales de forma atómica
    });

    ref.invalidateSelf();  // invalida para recargar el estado actualizado
  }
}
