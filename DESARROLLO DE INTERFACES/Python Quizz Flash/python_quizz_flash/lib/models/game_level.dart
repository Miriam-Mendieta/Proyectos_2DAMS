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

// ═══ CLASE: GameLevel ═══
/// Modelo de datos que representa cada nivel de aprendizaje en el juego.
/// Contiene el nombre del nivel, progreso actual y total de ejercicios.
/// Proporciona getters para determinar el estado del botón y del nivel.
class GameLevel {
  final String nombre;  // nombre del nivel: 'Básico', 'Intermedio' o 'Avanzado'
  final int ejerciciosResueltos;  // cuántos ejercicios lleva resueltos el usuario (0-15)
  final int totalEjercicios;  // total fijo de ejercicios requeridos para completar el nivel

  /// ═══ CONSTRUCTOR: GameLevel ═══
  /// Crea una instancia del nivel con nombre y progreso.
  /// totalEjercicios por defecto es 15.
  const GameLevel({
    required this.nombre,  // nombre del nivel (requerido)
    required this.ejerciciosResueltos,  // ejercicios ya resueltos (requerido)
    this.totalEjercicios = 15,  // por defecto siempre son 15 ejercicios por nivel
  });

  /// ═══ GETTER: buttonText ═══
  /// Determina el texto del botón según el progreso del nivel.
  /// - 'INICIAR' si no ha empezado (0 ejercicios)
  /// - 'CONTINUAR' si está en progreso (entre 1 y 14)
  /// - 'COMPLETADO' si terminó los 15 ejercicios
  String get buttonText {  // getter de solo lectura que retorna el texto adecuado
    if (ejerciciosResueltos == 0) return 'INICIAR';  // si no ha empezado, muestra INICIAR
    if (ejerciciosResueltos < totalEjercicios) return 'CONTINUAR';  // si está en curso, muestra CONTINUAR
    return 'COMPLETADO';  // si ya terminó todos, muestra COMPLETADO
  }

  /// ═══ GETTER: isCompleted ═══
  /// Verifica si el nivel está completamente terminado.
  bool get isCompleted => ejerciciosResueltos == totalEjercicios;  // true si resolvió todos los ejercicios

  /// ═══ GETTER: isStarted ═══
  /// Verifica si el usuario al menos comenzó el nivel.
  bool get isStarted => ejerciciosResueltos > 0;  // true si resolvió al menos un ejercicio
}
