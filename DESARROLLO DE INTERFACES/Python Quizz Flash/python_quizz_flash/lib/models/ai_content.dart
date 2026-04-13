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

// ═══ CLASE: AiContent ═══
/// Modelo que representa el contenido generado por IA.
/// Se usa para almacenar y mostrar respuestas generadas
/// por Google Gemini en la tienda de la aplicación.
class AiContent {
  /// Identificador único del contenido generado
  final String id;  // ID único asignado a cada contenido generado

  /// Tipo de contenido: 'explicacion', 'ejercicio', 'mini_curso'
  final String itemType;  // indica qué tipo de IA generó (explicación, ejercicio o mini-curso)

  /// Tema sobre el que se generó el contenido
  final String topic;  // tema específico solicitado por el usuario (ej: "listas", "funciones")

  /// Contenido generado por la IA (texto completo)
  final String content;  // texto completo generado por la IA para mostrar al usuario

  /// Fecha de generación del contenido
  final DateTime createdAt;  // marca de tiempo de cuándo se generó el contenido

  /// Nivel de dificultad del contenido
  final String difficulty;  // dificultad asignada (basic, intermediate, advanced)

  /// Indica si el contenido ya fue visto por el usuario
  final bool isViewed;  // true si el usuario ya abrió y vio este contenido

  /// ═══ CONSTRUCTOR: AiContent ═══
  /// Crea una instancia con todos los campos requeridos.
  /// isViewed por defecto es false (contenido nuevo sin ver).
  AiContent({
    required this.id,  // ID único requerido
    required this.itemType,  // tipo de contenido requerido
    required this.topic,  // tema requerido
    required this.content,  // contenido textual requerido
    required this.createdAt,  // fecha de creación requerida
    required this.difficulty,  // dificultad requerida
    this.isViewed = false,  // por defecto no ha sido visto
  });

  /// ═══ MÉTODO: fromJson ═══
  /// Crea una instancia de AiContent desde un mapa JSON (deserialización).
  /// Se usa al leer datos desde Firebase o archivos locales.
  factory AiContent.fromJson(Map<String, dynamic> json) {
    return AiContent(  // retorna una nueva instancia mapeando cada campo del JSON
      id: json['id'] as String,  // lee el campo 'id' y lo castea a String
      itemType: json['item_type'] as String,  // lee el campo 'item_type' (snake_case en JSON)
      topic: json['topic'] as String,  // lee el campo 'topic'
      content: json['content'] as String,  // lee el campo 'content' con el texto generado
      createdAt: DateTime.parse(json['created_at'] as String),  // parsea la fecha ISO8601 del JSON
      difficulty: json['difficulty'] as String,  // lee el campo 'difficulty'
      isViewed: json['is_viewed'] as bool? ?? false,  // lee 'is_viewed' o false si no existe
    );
  }

  /// ═══ MÉTODO: toJson ═══
  /// Convierte la instancia a un mapa JSON (serialización).
  /// Se usa al guardar datos en Firebase o archivos locales.
  Map<String, dynamic> toJson() {
    return {  // retorna un mapa con los campos en formato snake_case para JSON
      'id': id,  // ID único del contenido
      'item_type': itemType,  // tipo de contenido en snake_case
      'topic': topic,  // tema del contenido
      'content': content,  // texto generado por IA
      'created_at': createdAt.toIso8601String(),  // fecha formateada como string ISO8601
      'difficulty': difficulty,  // nivel de dificultad
      'is_viewed': isViewed,  // estado de visualización
    };
  }

  /// ═══ MÉTODO: copyWith ═══
  /// Crea una copia del contenido con campos opcionales modificados.
  /// Patrón inmutable: no modifica el original, retorna una nueva instancia.
  AiContent copyWith({
    String? id,  // nuevo ID opcional
    String? itemType,  // nuevo tipo de contenido opcional
    String? topic,  // nuevo tema opcional
    String? content,  // nuevo contenido textual opcional
    DateTime? createdAt,  // nueva fecha opcional
    String? difficulty,  // nueva dificultad opcional
    bool? isViewed,  // nuevo estado de visualización opcional
  }) {
    return AiContent(  // retorna una nueva instancia con los campos actualizados
      id: id ?? this.id,  // usa el nuevo valor o mantiene el actual
      itemType: itemType ?? this.itemType,  // usa el nuevo tipo o el actual
      topic: topic ?? this.topic,  // usa el nuevo tema o el actual
      content: content ?? this.content,  // usa el nuevo contenido o el actual
      createdAt: createdAt ?? this.createdAt,  // usa la nueva fecha o la actual
      difficulty: difficulty ?? this.difficulty,  // usa la nueva dificultad o la actual
      isViewed: isViewed ?? this.isViewed,  // usa el nuevo estado o el actual
    );
  }
}
