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

// ═══ IMPORTS: Dependencias principales de la aplicación ═══

import 'package:flutter/material.dart';  // importa el framework base de Flutter con widgets Material Design
import 'package:flutter_riverpod/flutter_riverpod.dart';  // importa Riverpod para gestión de estado global
import 'package:firebase_core/firebase_core.dart';  // importa Firebase Core para inicializar Firebase
import 'package:firebase_auth/firebase_auth.dart';  // importa Firebase Auth para gestión de autenticación
import 'package:cloud_firestore/cloud_firestore.dart';  // importa Cloud Firestore para base de datos en la nube
import 'theme/app_theme.dart';  // importa las definiciones de tema y colores de la aplicación
import 'routes/app_router.dart';  // importa el enrutador principal con todas las rutas de la app
import 'services/music_service.dart';  // importa el servicio de música de fondo
import 'config/app_config.dart';  // importa la configuración unificada de API keys y Firebase

/// ═══ FUNCIÓN: main ═══
/// Punto de entrada principal de la aplicación.
/// Inicializa la configuración, Firebase, la música de fondo
/// y lanza el widget raíz con Riverpod como provider scope.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();  // asegura que los bindings de Flutter estén listos antes de cualquier operación asíncrona

  /// Inicializa la configuración según la plataforma (web lee de window.flutter_config, móvil/escritorio lee de .env)
  await AppConfig.init();  // carga las API keys de Gemini, Groq y Firebase desde la fuente correspondiente

  try {  // bloque try-catch para manejar errores de inicialización de Firebase
    await Firebase.initializeApp(  // inicializa la instancia principal de Firebase
      options: FirebaseOptions(  // configura las opciones de Firebase con las claves cargadas desde AppConfig
        apiKey: AppConfig.firebaseApiKey,  // asigna la clave de API de Firebase
        authDomain: AppConfig.firebaseAuthDomain,  // asigna el dominio de autenticación
        projectId: AppConfig.firebaseProjectId,  // asigna el ID del proyecto
        storageBucket: AppConfig.firebaseStorageBucket,  // asigna el bucket de almacenamiento
        messagingSenderId: AppConfig.firebaseMessagingSenderId,  // asigna el ID del remitente de mensajes
        appId: AppConfig.firebaseAppId,  // asigna el ID de la aplicación Firebase
      ),
    );

    /// Configura la persistencia LOCAL para Firebase Auth en Flutter Web.
    /// Esto mantiene la sesión del usuario activa después de recargar la página.
    await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);  // establece que la sesión persista localmente en el navegador
  } catch (e) {  // captura cualquier error durante la inicialización de Firebase
    debugPrint("Firebase error: $e");  // imprime el error en la consola de debugging sin detener la app
  }

  /// Crea un ProviderContainer independiente de Riverpod para gestionar estado global
  /// fuera del árbol de widgets (necesario para iniciar servicios antes de runApp).
  final container = ProviderContainer();  // instancia un contenedor de providers de Riverpod
  container.read(musicControllerProvider.notifier).playBackgroundMusic();  // accede al provider de música e inicia la reproducción de fondo

  /// Lanza la aplicación Flutter envolviéndola en UncontrolledProviderScope
  /// para que el ProviderContainer creado esté disponible en todo el árbol de widgets.
  runApp(  // inicia la aplicación Flutter con el widget raíz
    UncontrolledProviderScope(  // scope que provee el container de Riverpod ya creado a toda la app
      container: container,  // pasa el container con el servicio de música ya iniciado
      child: const PythonQuizzFlashApp(),  // widget raíz de la aplicación como hijo
    ),
  );
}

/// ═══ CLASE: PythonQuizzFlashApp ═══
/// Widget raíz de la aplicación.
/// Configura MaterialApp con tema oscuro, título y el enrutador
/// definido en app_router.dart. Es StatelessWidget porque no
/// necesita gestionar estado interno.
class PythonQuizzFlashApp extends StatelessWidget {
  const PythonQuizzFlashApp({super.key});  // constructor constante con key opcional del padre

  @override  // sobrescribe el método build para construir la interfaz visual
  Widget build(BuildContext context) {  // recibe el contexto de build para crear widgets
    return MaterialApp.router(  // configura MaterialApp con sistema de enrutamiento GoRouter
      title: 'Python Quizz Flash',  // título de la aplicación que muestra el sistema operativo
      debugShowCheckedModeBanner: false,  // oculta la banda de "debug" en la esquina superior derecha
      theme: AppTheme.darkTheme,  // aplica el tema oscuro definido en app_theme.dart
      routerConfig: appRouter,  // asigna la configuración de rutas importada desde app_router.dart
    );
  }
}
