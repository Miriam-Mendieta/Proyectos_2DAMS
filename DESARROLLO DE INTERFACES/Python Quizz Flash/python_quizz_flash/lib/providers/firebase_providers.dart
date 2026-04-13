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

// ═══ IMPORTS: Dependencias de Firebase y Riverpod ═══

import 'package:cloud_firestore/cloud_firestore.dart';  // importa Firestore para base de datos en la nube
import 'package:firebase_auth/firebase_auth.dart';  // importa Firebase Auth para gestión de autenticación
import 'package:flutter_riverpod/flutter_riverpod.dart';  // importa Riverpod para gestión de estado reactivo

/// ═══ PROVIDER: firebaseAuthProvider ═══
/// Provider que expone la instancia singleton de FirebaseAuth.
/// Permite inyectar Firebase Auth en otros providers de Riverpod.
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {  // crea provider que retorna
  return FirebaseAuth.instance;  // la instancia global singleton de Firebase Auth
});

/// ═══ PROVIDER: firestoreProvider ═══
/// Provider que expone la instancia singleton de FirebaseFirestore.
/// Permite inyectar Firestore en otros providers de Riverpod.
final firestoreProvider = Provider<FirebaseFirestore>((ref) {  // crea provider que retorna
  return FirebaseFirestore.instance;  // la instancia global singleton de Firestore
});

/// ═══ PROVIDER: authStateProvider ═══
/// StreamProvider reactivo que escucha cambios en el estado de autenticación.
/// Emite un nuevo valor cada vez que un usuario inicia o cierra sesión.
final authStateProvider = StreamProvider<User?>((ref) {  // crea stream provider que retorna
  return ref.watch(firebaseAuthProvider).authStateChanges();  // stream de cambios en auth (User o null)
});

/// ═══ PROVIDER: userProfileProvider ═══
/// StreamProvider reactivo que escucha cambios en el perfil del usuario en Firestore.
/// Retorna los datos del documento del usuario en tiempo real, o null si no hay usuario.
final userProfileProvider = StreamProvider<Map<String, dynamic>?>((ref) {  // crea stream provider de perfil
  final user = ref.watch(authStateProvider).value;  // observa el usuario actual de forma reactiva

  if (user == null) return Stream.value(null);  // si no hay usuario, retorna stream null

  /// Retorna los datos del documento del usuario en tiempo real.
  /// Maneja errores de permisos gracefulmente (retorna null en lugar de lanzar).
  return ref
      .watch(firestoreProvider)  // observa la instancia de Firestore
      .collection('users')  // en la colección 'users'
      .doc(user.uid)  // documento con el UID del usuario actual
      .snapshots()  // stream de snapshots en tiempo real
      .handleError((_) => null)  // si hay error (ej: permisos), retorna null sin lanzar excepción
      .map((snapshot) => snapshot.data());  // extrae los datos del snapshot (Map o null)
});
