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

// ═══════════════════════════════════════════════════════════
// IMPORTS - Paquetes y archivos que necesita esta pantalla
// ═══════════════════════════════════════════════════════════
import 'package:flutter/material.dart';  // Importa el paquete principal de Flutter para construir la UI
import '../models/exercise.dart';  // Importa el modelo Exercise que define la estructura y tipos de ejercicios
import 'multiple_choice_widget.dart';  // Importa el widget de opción múltiple
import 'fill_in_the_blank_widget.dart';  // Importa el widget de completar espacio en blanco
import 'bug_widget.dart';  // Importa el widget de corrección de bugs
import 'coding_widget.dart';  // Importa el widget de escritura de código

/// ═══ CLASE: ExerciseWidgetFactory ═══
/// Factory que construye y retorna el widget de ejercicio apropiado según el tipo de Exercise.
/// Actúa como un patrón de diseño Factory Method para la creación de widgets dinámicos.
// --- ExerciseWidgetFactory ---
// Esta factory construye el widget de ejercicio apropiado basado en el tipo.
class ExerciseWidgetFactory {
  /// ═══ MÉTODO: buildWidget ═══
  /// Método estático que recibe un Exercise y un callback, y retorna el widget correspondiente
  /// según el tipo de ejercicio (multipleChoice, fillInTheBlank, bugFix, coding).
  static Widget buildWidget(  // Método de fábrica estático que retorna un Widget
    Exercise exercise,  // Objeto Exercise que determina qué widget construir
    ValueChanged<bool> onAnswerSubmitted,  // Callback compartido para notificar corrección de respuesta
  ) {
    switch (exercise.type) {  // Evalúa el tipo de ejercicio usando un switch
      // ═══ CASO: Opción múltiple ═══
      case ExerciseType.multipleChoice:  // Si el tipo es opción múltiple
        return MultipleChoiceWidget(  // Retorna el widget de opción múltiple
          exercise: exercise,  // Pasa el ejercicio al widget
          onAnswerSubmitted: onAnswerSubmitted,  // Pasa el callback de notificación
        );
      // ═══ CASO: Completar espacio en blanco ═══
      case ExerciseType.fillInTheBlank:  // Si el tipo es completar espacio en blanco
        return FillInTheBlankWidget(  // Retorna el widget de completar espacio en blanco
          exercise: exercise,  // Pasa el ejercicio al widget
          onAnswerSubmitted: onAnswerSubmitted,  // Pasa el callback de notificación
        );
      // ═══ CASO: Corrección de bug ═══
      case ExerciseType
          .bugFix: // Asumiendo que 'bug' en el modelo se mapea a 'bugFix'
        return BugWidget(  // Retorna el widget de corrección de bugs
          exercise: exercise,  // Pasa el ejercicio al widget
          onAnswerSubmitted: onAnswerSubmitted,  // Pasa el callback de notificación
        );
      // ═══ CASO: Escritura de código ═══
      case ExerciseType.coding:  // Si el tipo es escritura de código
        return CodingWidget(  // Retorna el widget de escritura de código
          exercise: exercise,  // Pasa el ejercicio al widget
          onAnswerSubmitted: onAnswerSubmitted,  // Pasa el callback de notificación
        );
      // ═══ CASO: Tipo no soportado ═══
      default:  // Si el tipo no coincide con ninguno de los casos anteriores
        return Center(  // Retorna un widget centrado con mensaje de error
          child: Text(  // Texto informativo sobre el tipo no soportado
            'Tipo de ejercicio no soportado: ${exercise.type.toString()}',  // Muestra el tipo desconocido como string
          ),
        );
    }
  }
}
