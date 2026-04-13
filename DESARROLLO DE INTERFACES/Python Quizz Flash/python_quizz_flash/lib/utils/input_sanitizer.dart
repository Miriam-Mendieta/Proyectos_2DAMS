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

/// ═══ CLASE: InputSanitizer ═══
/// Servicio de sanitización de inputs para proteger contra Prompt Injection.
/// Valida y limpia los inputs del usuario antes de enviarlos a APIs de IA,
/// previniendo ataques de inyección de prompts y ejecución de código malicioso.
class InputSanitizer {
  /// Lista de patrones regex peligrosos que indican intento de Prompt Injection.
  /// Se verifican contra cada input del usuario antes de enviarlo a la IA.
  static final List<RegExp> _dangerousPatterns = [
    // ═══ Intentos de ignorar instrucciones del sistema ═══
    RegExp(r'ignore.*instructions', caseSensitive: false),  // detecta "ignore instructions"
    RegExp(r'ignore.*previous', caseSensitive: false),  // detecta "ignore previous"
    RegExp(r'forget.*instructions', caseSensitive: false),  // detecta "forget instructions"
    RegExp(r'bypass.*rules', caseSensitive: false),  // detecta "bypass rules"
    RegExp(r'override.*system', caseSensitive: false),  // detecta "override system"
    RegExp(r'disregard.*rules', caseSensitive: false),  // detecta "disregard rules"
    
    // ═══ Patrones en español ═══
    RegExp(r'ignora.*instrucciones', caseSensitive: false),  // detecta "ignora instrucciones"
    RegExp(r'ignora.*instruccion', caseSensitive: false),  // detecta "ignora instruccion"
    RegExp(r'olvida.*instrucciones', caseSensitive: false),  // detecta "olvida instrucciones"
    RegExp(r'omite.*reglas', caseSensitive: false),  // detecta "omite reglas"
    RegExp(r'ignora.*reglas', caseSensitive: false),  // detecta "ignora reglas"
    RegExp(r'ignora.*anterior', caseSensitive: false),  // detecta "ignora anterior"
    RegExp(r'no hagas? caso', caseSensitive: false),  // detecta "no hagas caso" / "no hacer caso"

    // ═══ Intentos de revelar información sensible ═══
    RegExp(r'print.*key', caseSensitive: false),  // detecta "print key"
    RegExp(r'print.*token', caseSensitive: false),  // detecta "print token"
    RegExp(r'print.*secret', caseSensitive: false),  // detecta "print secret"
    RegExp(r'print.*password', caseSensitive: false),  // detecta "print password"
    RegExp(r'print.*api', caseSensitive: false),  // detecta "print api"
    RegExp(r'reveal.*key', caseSensitive: false),  // detecta "reveal key"
    RegExp(r'reveal.*token', caseSensitive: false),  // detecta "reveal token"
    RegExp(r'reveal.*secret', caseSensitive: false),  // detecta "reveal secret"
    RegExp(r'show.*credentials', caseSensitive: false),  // detecta "show credentials"
    RegExp(r'expose.*key', caseSensitive: false),  // detecta "expose key"

    // ═══ Intentos de ejecutar código arbitrario ═══
    RegExp(r'execute.*code', caseSensitive: false),  // detecta "execute code"
    RegExp(r'run.*code', caseSensitive: false),  // detecta "run code"
    RegExp(r'eval\('),  // detecta llamada eval(
    RegExp(r'exec\('),  // detecta llamada exec(
    RegExp(r'__import__'),  // detecta importación dinámica Python
    RegExp(r'subprocess'),  // detecta módulo subprocess
    RegExp(r'os\.'),  // detecta acceso a módulo os
    RegExp(r'system\('),  // detecta llamada system(

    // ═══ Intentos de cambiar el rol del sistema ═══
    RegExp(r'you are now', caseSensitive: false),  // detecta "you are now"
    RegExp(r'act as', caseSensitive: false),  // detecta "act as"
    RegExp(r'pretend to be', caseSensitive: false),  // detecta "pretend to be"
    RegExp(r'role.*change', caseSensitive: false),  // detecta "role change"
    RegExp(r'system prompt', caseSensitive: false),  // detecta "system prompt"

    // ═══ Caracteres especiales peligrosos ═══
    RegExp(r'[<>{}|]'),  // detecta caracteres < > { } | (usados en inyección)
  ];

  /// Lista de palabras reservadas que no deberían aparecer en inputs de usuario.
  /// Indican intento de manipular el comportamiento del sistema de IA.
  static final List<String> _reservedWords = [
    'system prompt',  // intento de acceder al prompt del sistema
    'system message',  // intento de acceder al mensaje del sistema
    'developer message',  // intento de acceder a mensajes de desarrollador
    'assistant message',  // intento de manipular mensajes del asistente
    'user message',  // intento de manipular mensajes de usuario
    'instruction set',  // intento de acceder al set de instrucciones
    'base instructions',  // intento de acceder a instrucciones base
    'core directives',  // intento de acceder a directivas centrales
  ];

  /// ═══ MÉTODO: isSafe ═══
  /// Verifica si un input es seguro (no contiene patrones de Prompt Injection).
  /// Retorna true si el input es seguro, false si contiene patrones peligrosos.
  static bool isSafe(String input) {  // recibe el string a verificar
    if (input.isEmpty) return true;  // input vacío se considera seguro

    final lowerInput = input.toLowerCase();  // convierte a minúsculas para comparación case-insensitive

    /// Verificar si contiene palabras reservadas prohibidas.
    for (final word in _reservedWords) {  // para cada palabra reservada
      if (lowerInput.contains(word)) {  // si el input la contiene
        return false;  // no es seguro
      }
    }

    /// Verificar si coincide con patrones regex peligrosos.
    for (final pattern in _dangerousPatterns) {  // para cada patrón peligroso
      if (pattern.hasMatch(input)) {  // si el input coincide con el patrón
        return false;  // no es seguro
      }
    }

    return true;  // si pasó todas las verificaciones, es seguro
  }

  /// ═══ MÉTODO: sanitize ═══
  /// Sanitiza un input removiendo patrones peligrosos y caracteres especiales.
  /// Normaliza el texto y trunca a longitud máxima segura (500 chars por defecto).
  static String sanitize(String input, {int maxLength = 500}) {  // recibe input y longitud máxima opcional
    if (input.isEmpty) return input;  // si está vacío, retorna tal cual

    String sanitized = input;  // copia del input para sanitizar

    /// Remover patrones de inyección encontrados en el input.
    for (final pattern in _dangerousPatterns) {  // para cada patrón peligroso
      sanitized = sanitized.replaceAll(pattern, '');  // reemplaza coincidencias con string vacío
    }

    /// Remover caracteres especiales potencialmente peligrosos.
    sanitized = sanitized
        .replaceAll(RegExp(r'[<>]'), '')  // elimina < y > (previene tags HTML/XML)
        .replaceAll(RegExp(r'[{}]'), '')  // elimina { y } (previene bloques de código)
        .replaceAll(RegExp(r'[|]'), '')  // elimina | (previene pipes)
        .replaceAll(RegExp(r'[/]'), '');  // elimina / y \ (previene rutas y escapes)

    /// Normalizar espacios múltiples a un solo espacio.
    sanitized = sanitized.replaceAll(RegExp(r'\s+'), ' ');  // reemplaza secuencias de whitespace con un solo espacio

    /// Truncar a longitud máxima para evitar inputs excesivamente largos.
    if (sanitized.length > maxLength) {  // si supera el límite
      sanitized = sanitized.substring(0, maxLength);  // corta al tamaño máximo
    }

    return sanitized.trim();  // retorna el input limpio sin espacios al inicio/final
  }

  /// ═══ MÉTODO: validateTopic ═══
  /// Valida un topic para generación de contenido IA.
  /// Verifica longitud (2-200 chars), ausencia de patrones de inyección y sanitiza.
  /// Retorna mapa con: isValid (bool), sanitizedTopic (String), error (String?).
  static Map<String, dynamic> validateTopic(String topic) {  // recibe el topic a validar
    if (topic.trim().isEmpty) {  // si el topic está vacío o solo tiene espacios
      return {  // retorna resultado de validación fallida
        'isValid': false,  // no es válido
        'sanitizedTopic': '',  // sin topic sanitizado
        'error': 'El tema no puede estar vacío',  // mensaje de error
      };
    }

    if (topic.length < 2) {  // si el topic tiene menos de 2 caracteres
      return {  // retorna resultado de validación fallida
        'isValid': false,  // no es válido
        'sanitizedTopic': '',  // sin topic sanitizado
        'error': 'El tema debe tener al menos 2 caracteres',  // mensaje de error
      };
    }

    if (topic.length > 200) {  // si el topic supera 200 caracteres
      return {  // retorna resultado de validación fallida
        'isValid': false,  // no es válido
        'sanitizedTopic': '',  // sin topic sanitizado
        'error': 'El tema es demasiado largo (máximo 200 caracteres)',  // mensaje de error
      };
    }

    /// Verificar si contiene patrones de Prompt Injection.
    if (!isSafe(topic)) {  // si el topic NO es seguro
      return {  // retorna resultado de validación fallida
        'isValid': false,  // no es válido
        'sanitizedTopic': '',  // sin topic sanitizado
        'error': 'El tema contiene contenido no permitido',  // mensaje de error
      };
    }

    /// Sanitizar el topic removiendo caracteres verdaderamente peligrosos.
    final sanitized = sanitize(topic, maxLength: 200);  // sanitiza con límite de 200 chars

    return {'isValid': true, 'sanitizedTopic': sanitized, 'error': null};  // retorna validación exitosa con topic limpio
  }

  /// ═══ MÉTODO: isCodeSafe ═══
  /// Verifica que código Python no contenga llamadas peligrosas.
  /// Bloquea acceso a sistema operativo, evaluación dinámica y ejecución arbitraria.
  static bool isCodeSafe(String code) {  // recibe el código Python a verificar
    if (code.isEmpty) return true;  // código vacío se considera seguro

    final dangerousCalls = [  // lista de llamadas peligrosas a detectar
      'os.system(',  // ejecución de comandos del sistema
      'os.popen(',  // apertura de pipe al sistema
      'os.exec',  // ejecución directa vía os
      'subprocess.',  // módulo de subprocesos del sistema
      'eval(',  // evaluación de expresiones arbitrarias
      'exec(',  // ejecución de código arbitrario
      '__import__',  // importación dinámica de módulos
      'compile(',  // compilación de código en runtime
      'open(',  // apertura de archivos del sistema
    ];

    final lowerCode = code.toLowerCase();  // convierte código a minúsculas para búsqueda

    for (final call in dangerousCalls) {  // para cada llamada peligrosa
      if (lowerCode.contains(call.toLowerCase())) {  // si el código la contiene
        return false;  // no es seguro
      }
    }

    return true;  // si no contiene llamadas peligrosas, es seguro
  }
}
