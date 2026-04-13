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

// ═══ IMPORTS: Dependencias de logging seguro ═══

import 'package:logger/logger.dart';  // importa la librería logger para logs formateados y con niveles
import 'package:flutter/foundation.dart';  // importa kReleaseMode para detectar modo debug vs producción

/// ═══ CLASE: AppLogger ═══
/// Logger seguro para la aplicación con comportamiento diferenciado por entorno.
/// - En modo DEBUG: muestra todos los niveles de log (trace, debug, info, warning, error)
/// - En modo PRODUCCIÓN: solo muestra errores (evita exponer info sensible)
/// - Nunca loggea información sensible (API keys, tokens, passwords)
/// Incluye método sanitizeForLog para enmascarar datos sensibles antes de loguear.
class AppLogger {
  /// Instancia del logger configurada con PrettyPrinter para salida formateada.
  static final Logger _logger = Logger(  // crea logger con configuración personalizada
    printer: PrettyPrinter(  // configurador de impresión con formato visual atractivo
      methodCount: 2,  // muestra 2 niveles de la pila de llamadas en el log
      errorMethodCount: 8,  // muestra 8 niveles de pila en caso de error para debugging
      lineLength: 120,  // ancho máximo de línea: 120 caracteres antes de wrap
      colors: true,  // habilita colores en la consola para diferenciar niveles
      printEmojis: true,  // muestra emojis identificativos por nivel (💡 INFO, ⚠️ WARNING, etc.)
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,  // muestra hora actual y tiempo desde inicio
    ),
    level: kReleaseMode ? Level.error : Level.trace,  // en producción solo errores, en debug todo
  );

  /// ═══ MÉTODO: t (trace) ═══
  /// Logger para trazas detalladas de ejecución. Solo activo en modo debug.
  /// Se usa para seguimiento granular de flujo de ejecución.
  static void t(String message, [dynamic error]) {  // recibe mensaje y error opcional
    if (!kReleaseMode) {  // solo si NO estamos en modo producción
      _logger.t(message, error: error);  // loguea con nivel trace
    }
  }

  /// ═══ MÉTODO: d (debug) ═══
  /// Logger para información de debugging. Solo activo en modo debug.
  /// Se usa para valores de variables, estados intermedios, etc.
  static void d(String message, [dynamic error]) {  // recibe mensaje y error opcional
    if (!kReleaseMode) {  // solo si NO estamos en modo producción
      _logger.d(message, error: error);  // loguea con nivel debug
    }
  }

  /// ═══ MÉTODO: i (info) ═══
  /// Logger para información general del flujo de la app. Solo activo en modo debug.
  /// Se usa para eventos importantes como inicializaciones, transiciones, etc.
  static void i(String message, [dynamic error]) {  // recibe mensaje y error opcional
    if (!kReleaseMode) {  // solo si NO estamos en modo producción
      _logger.i(message, error: error);  // loguea con nivel info
    }
  }

  /// ═══ MÉTODO: w (warning) ═══
  /// Logger para advertencias. Activo tanto en debug como en producción.
  /// Se usa para situaciones que no son errores pero requieren atención.
  static void w(String message, [dynamic error]) {  // recibe mensaje y error opcional
    _logger.w(message, error: error);  // loguea con nivel warning (siempre activo)
  }

  /// ═══ MÉTODO: e (error) ═══
  /// Logger para errores. Siempre activo en debug y producción.
  /// Acepta mensaje, error y stack trace para diagnóstico completo.
  static void e(String message, [dynamic error, StackTrace? stackTrace]) {  // recibe mensaje, error y stack trace opcionales
    _logger.e(message, error: error, stackTrace: stackTrace);  // loguea con nivel error (siempre activo)
  }

  /// ═══ MÉTODO: sanitizeForLog ═══
  /// Sanitiza un string antes de loguearlo para proteger información sensible.
  /// Enmascara emails, API keys, tokens y passwords.
  static String sanitizeForLog(String input) {  // recibe string de entrada
    if (input.isEmpty) return input;  // si está vacío, retorna tal cual

    String sanitized = input;  // copia del string para ir sanitizando

    /// Enmascarar emails: deja solo primeras 2 letras del usuario y el dominio completo.
    final emailRegex = RegExp(r'[\w\.-]+@[\w\.-]+\.\w+');  // regex para detectar emails
    sanitized = sanitized.replaceAllMapped(emailRegex, (match) {  // reemplaza cada email encontrado
      final email = match.group(0)!;  // obtiene el email completo
      final parts = email.split('@');  // separa usuario y dominio
      if (parts.length == 2) {  // si tiene formato válido usuario@dominio
        final username = parts[0];  // obtiene parte del usuario
        final domain = parts[1];  // obtiene parte del dominio
        if (username.length > 2) {  // si el usuario tiene más de 2 caracteres
          return '${username.substring(0, 2)}***@$domain';  // retorna primeras 2 letras + *** + @dominio
        }
      }
      return '***';  // si no se puede parsear, reemplaza todo con ***
    });

    /// Enmascarar posibles API keys: strings alfanuméricos de 20+ caracteres.
    /// Muestra primeros 4 y últimos 4 caracteres del string original.
    final apiKeyRegex = RegExp(r'[A-Za-z0-9_-]{20,}');  // regex para detectar strings largos tipo API key
    sanitized = sanitized.replaceAllMapped(apiKeyRegex, (match) {  // reemplaza cada key encontrada
      final key = match.group(0)!;  // obtiene la key completa
      return '${key.substring(0, 4)}...${key.substring(key.length - 4)}';  // muestra primer y último segmento de 4 chars
    });

    return sanitized;  // retorna el string con información sensible enmascarada
  }
}
