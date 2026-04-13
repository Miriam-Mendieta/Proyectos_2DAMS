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
import 'exercise.dart';  // importa el modelo Exercise para usar el enum Difficulty

part 'user_profile.freezed.dart';  // archivo generado por freezed con la implementación inmutable
part 'user_profile.g.dart';  // archivo generado por json_serializable con métodos fromJson/toJson

/// ═══ CLASE: UserProfile ═══
/// Modelo inmutable que representa el perfil del usuario en la aplicación.
/// Generado con @freezed para inmutabilidad automática.
/// Almacena UID, nombre, monedas, puntuaciones y progreso del usuario.
@freezed  // anotación que indica a freezed que genere la clase inmutable
abstract class UserProfile with _$UserProfile {  // clase abstracta que mezcla el mixin generado
  const factory UserProfile({  // factory constructor que define la estructura del perfil
    required String uid,  // identificador único de Firebase Auth del usuario
    @Default("Coder") String name,  // nombre visible del usuario, "Coder" por defecto
    @Default(0) int coins,  // cantidad de PY-Coins actuales, 0 por defecto
    required Map<Difficulty, int> highScores,  // mejores puntuaciones por nivel de dificultad
    @Default([]) List<String> completedExerciseIds,  // lista de IDs de ejercicios completados
    @Default(1) int currentLevel,  // nivel actual del usuario, 1 por defecto
  }) = _UserProfile;  // nombre de la clase concreta generada por freezed

  /// Factory para deserializar desde JSON. Generado automáticamente por _$UserProfileFromJson.
  factory UserProfile.fromJson(Map<String, dynamic> json) =>  // crea un UserProfile desde un mapa JSON
      _$UserProfileFromJson(json);  // delega en el código generado por json_serializable
}
