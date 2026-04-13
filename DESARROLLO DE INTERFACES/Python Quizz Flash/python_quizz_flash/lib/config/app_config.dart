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

// ═══ IMPORTS: Dependencias de configuración ═══

import 'package:flutter/foundation.dart';  // importa kIsWeb para detectar si se ejecuta en navegador
import 'package:flutter_dotenv/flutter_dotenv.dart';  // importa dotenv para cargar variables de entorno en móvil/escritorio
import 'dart:js' as js;  // importa interoperabilidad con JavaScript para acceder a window en web

/// ═══ CLASE: AppConfig ═══
/// Configuración unificada para todas las plataformas.
/// - Web: Usa window.flutter_config (inyectado desde web/config.js)
/// - Móvil/Escritorio: Usa archivo .env con flutter_dotenv
/// Almacena las claves de API de Gemini, Groq y Firebase.
class AppConfig {
  static String? _geminiApiKey;  // almacena la clave de API de Gemini (null si no cargada)
  static String? _groqApiKey;  // almacena la clave de API de Groq (null si no cargada)
  static String? _firebaseApiKey;  // almacena la clave de API de Firebase
  static String? _firebaseAuthDomain;  // almacena el dominio de autenticación de Firebase
  static String? _firebaseProjectId;  // almacena el ID del proyecto de Firebase
  static String? _firebaseStorageBucket;  // almacena el bucket de almacenamiento de Firebase
  static String? _firebaseMessagingSenderId;  // almacena el ID del remitente de mensajes de Firebase
  static String? _firebaseAppId;  // almacena el ID de la aplicación de Firebase

  /// ═══ MÉTODO: init ═══
  /// Inicializa la configuración según la plataforma donde se ejecuta la app.
  /// Si es web llama a _initWeb(), si no llama a _initMobileDesktop().
  static Future<void> init() async {
    if (kIsWeb) {  // verifica si la app se ejecuta en un navegador web
      _initWeb();  // inicializa configuración web leyendo desde window.flutter_config
    } else {  // si es móvil o escritorio
      await _initMobileDesktop();  // inicializa leyendo desde archivo .env
    }
  }

  /// ═══ MÉTODO: _initWeb ═══
  /// Inicializa la configuración para Web leyendo las variables desde
  /// window.flutter_config (inyectado por JavaScript en index.html).
  static void _initWeb() {
    try {  // bloque try-catch para manejar errores de acceso a JS
      final config = js.context['flutter_config'];  // accede a window.flutter_config desde JavaScript

      if (config != null) {  // verifica que el objeto de configuración exista
        _geminiApiKey = config['GEMINI_API_KEY'] as String?;  // lee la clave de Gemini del objeto JS
        _groqApiKey = config['GROQ_API_KEY'] as String?;  // lee la clave de Groq del objeto JS
        _firebaseApiKey = config['FIREBASE_API_KEY'] as String?;  // lee la clave de Firebase API
        _firebaseAuthDomain = config['FIREBASE_AUTH_DOMAIN'] as String?;  // lee el dominio de auth
        _firebaseProjectId = config['FIREBASE_PROJECT_ID'] as String?;  // lee el ID del proyecto
        _firebaseStorageBucket = config['FIREBASE_STORAGE_BUCKET'] as String?;  // lee el bucket de storage
        _firebaseMessagingSenderId = config['FIREBASE_MESSAGING_SENDER_ID'] as String?;  // lee el sender ID
        _firebaseAppId = config['FIREBASE_APP_ID'] as String?;  // lee el ID de la app Firebase
      }
    } catch (e) {  // captura cualquier error al acceder a las variables JS
      _geminiApiKey = '';  // establece Gemini API key vacía como fallback
      _groqApiKey = '';  // establece Groq API key vacía como fallback
    }
  }

  /// ═══ MÉTODO: _initMobileDesktop ═══
  /// Inicializa la configuración para Móvil y Escritorio leyendo las
  /// variables de entorno desde el archivo .env usando flutter_dotenv.
  static Future<void> _initMobileDesktop() async {
    try {  // bloque try-catch para manejar errores de carga del .env
      await dotenv.load(fileName: '.env');  // carga las variables de entorno desde el archivo .env

      _geminiApiKey = dotenv.env['GEMINI_API_KEY'];  // lee Gemini API key del archivo .env
      _groqApiKey = dotenv.env['GROQ_API_KEY'];  // lee Groq API key del archivo .env
      _firebaseApiKey = dotenv.env['FIREBASE_API_KEY'];  // lee Firebase API key del .env
      _firebaseAuthDomain = dotenv.env['FIREBASE_AUTH_DOMAIN'];  // lee el dominio de auth
      _firebaseProjectId = dotenv.env['FIREBASE_PROJECT_ID'];  // lee el ID del proyecto
      _firebaseStorageBucket = dotenv.env['FIREBASE_STORAGE_BUCKET'];  // lee el bucket de storage
      _firebaseMessagingSenderId = dotenv.env['FIREBASE_MESSAGING_SENDER_ID'];  // lee el sender ID
      _firebaseAppId = dotenv.env['FIREBASE_APP_ID'];  // lee el ID de la app Firebase
    } catch (e) {  // captura errores de carga o lectura del archivo .env
      _geminiApiKey = '';  // establece Gemini API key vacía como fallback
      _groqApiKey = '';  // establece Groq API key vacía como fallback
    }
  }

  /// Getter público para la clave de API de Gemini
  static String get geminiApiKey => _geminiApiKey ?? '';  // retorna la clave o cadena vacía si es null

  /// Getter público para la clave de API de Groq
  static String get groqApiKey => _groqApiKey ?? '';  // retorna la clave o cadena vacía si es null

  /// Getter público para la clave de API de Firebase
  static String get firebaseApiKey => _firebaseApiKey ?? '';  // retorna la clave o cadena vacía si es null

  /// Getter público para el dominio de autenticación de Firebase
  static String get firebaseAuthDomain => _firebaseAuthDomain ?? '';  // retorna el valor o cadena vacía

  /// Getter público para el ID del proyecto de Firebase
  static String get firebaseProjectId => _firebaseProjectId ?? '';  // retorna el valor o cadena vacía

  /// Getter público para el bucket de almacenamiento de Firebase
  static String get firebaseStorageBucket => _firebaseStorageBucket ?? '';  // retorna el valor o cadena vacía

  /// Getter público para el ID del remitente de mensajes de Firebase
  static String get firebaseMessagingSenderId => _firebaseMessagingSenderId ?? '';  // retorna el valor o vacío

  /// Getter público para el ID de la aplicación de Firebase
  static String get firebaseAppId => _firebaseAppId ?? '';  // retorna el valor o cadena vacía

  /// ═══ GETTER: isConfigured ═══
  /// Verifica si la configuración básica está completa.
  /// Retorna true si Gemini API key fue cargada y no está vacía.
  static bool get isConfigured =>  // indica si la app tiene configuración válida
      _geminiApiKey != null && _geminiApiKey!.isNotEmpty;  // retorna true si la clave existe y tiene contenido
}
