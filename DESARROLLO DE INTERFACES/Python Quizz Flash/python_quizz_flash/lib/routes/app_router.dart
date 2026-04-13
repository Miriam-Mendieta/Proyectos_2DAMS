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

// ═══ IMPORTS: Dependencias de enrutamiento y páginas ═══

import 'package:flutter/material.dart';  // importa framework base de Flutter para widgets como Scaffold y CircularProgressIndicator
import 'package:go_router/go_router.dart';  // importa GoRouter para sistema de enrutamiento declarativo
import '../pages/splash_screen.dart';  // importa pantalla de carga inicial (SplashScreen)
import '../pages/inicio_screen.dart';  // importa pantalla de inicio/menú principal (InicioScreen)
import '../pages/login_screen.dart';  // importa pantalla de inicio de sesión (LoginScreen)
import '../pages/register_screen.dart';  // importa pantalla de registro de usuario (RegisterScreen)
import '../pages/main_menu_screen.dart';  // importa pantalla del menú principal del juego (MainMenuScreen)
import '../pages/design_system_screen.dart';  // importa pantalla de demostración del sistema de diseño (DesignSystemScreen)
import '../pages/quiz_screen.dart';  // importa pantalla de preguntas/respuestas del quiz (QuizScreen)
import '../pages/onboarding_screen.dart';  // importa pantalla de introducción/tutorial inicial (OnboardingScreen)
import '../pages/challenge_screen.dart';  // importa pantalla de reto final de programación (ChallengeScreen)
import '../pages/contacto_screen.dart';  // importa pantalla de información de contacto (ContactoScreen)
import '../pages/tienda_screen.dart';  // importa pantalla de la tienda de items (TiendaScreen)
import '../pages/logros_screen.dart';  // importa pantalla de logros y estadísticas (LogrosScreen)
import '../pages/config_screen.dart';  // importa pantalla de configuración de la app (ConfigScreen)
import '../pages/legal_screens.dart';  // importa pantallas legales (Términos, Privacidad, Valoración)
import '../pages/ai_content_viewer_screen.dart';  // importa pantalla de visualización de contenido IA (AiContentViewerScreen)
import '../models/ai_content.dart';  // importa modelo AiContent para contenido generado por IA
import '../models/exercise.dart';  // importa modelo Exercise con enum Difficulty para parámetros del quiz

/// ═══ VARIABLE: appRouter ═══
/// Configuración centralizada de todas las rutas de la aplicación usando GoRouter.
/// Define las rutas, parámetros de navegación y pantallas iniciales.
/// GoRouter permite navegación declarativa con query parameters y datos extra.
final appRouter = GoRouter(  // crea instancia del enrutador GoRouter
  initialLocation: '/',  // ruta inicial de la app (pantalla de carga/splash)
  routes: [  // lista de todas las rutas disponibles en la aplicación

    /// ═══ RUTA: / (Splash Screen) ═══
    /// Pantalla de carga inicial que verifica sesión y navega automáticamente.
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),  // ruta raíz muestra SplashScreen

    /// ═══ RUTA: /config (Configuración) ═══
    /// Pantalla de ajustes y preferencias de la aplicación.
    GoRoute(path: '/config', builder: (context, state) => const ConfigScreen()),  // muestra ConfigScreen

    /// ═══ RUTA: /valorar (Soporte y Feedback) ═══
    /// Pantalla de valoración de la app y envío de feedback.
    GoRoute(path: '/valorar', builder: (context, state) => const ValoracionScreen()),  // muestra ValoracionScreen

    /// ═══ RUTA: /terminos (Términos de Servicio) ═══
    /// Pantalla con los términos y condiciones legales de uso.
    GoRoute(path: '/terminos', builder: (context, state) => const TerminosScreen()),  // muestra TerminosScreen

    /// ═══ RUTA: /privacidad (Política de Privacidad) ═══
    /// Pantalla con la política de privacidad conforme a RGPD.
    GoRoute(path: '/privacidad', builder: (context, state) => const PrivacidadScreen()),  // muestra PrivacidadScreen

    /// ═══ RUTA: /contacto (Información de Contacto) ═══
    /// Pantalla con datos de contacto y redes sociales del desarrollador.
    GoRoute(path: '/contacto', builder: (context, state) => const ContactoScreen()),  // muestra ContactoScreen

    /// ═══ RUTA: /logros (Logros y Estadísticas) ═══
    /// Pantalla que muestra insignias, estadísticas e historial de transacciones.
    GoRoute(path: '/logros', builder: (context, state) => const LogrosScreen()),  // muestra LogrosScreen

    /// ═══ RUTA: /tienda (Tienda de Items) ═══
    /// Pantalla de la tienda donde comprar pistas y contenido generado por IA.
    GoRoute(path: '/tienda', builder: (context, state) => const TiendaScreen()),  // muestra TiendaScreen

    /// ═══ RUTA: /inicio (Pantalla de Inicio) ═══
    /// Menú principal con diseño pixel art y botones de login/registro.
    GoRoute(path: '/inicio', builder: (context, state) => const InicioScreen()),  // muestra InicioScreen

    /// ═══ RUTA: /login (Inicio de Sesión) ═══
    /// Formulario de inicio de sesión con email/nick y contraseña.
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),  // muestra LoginScreen

    /// ═══ RUTA: /register (Registro de Usuario) ═══
    /// Formulario de registro con validaciones de usuario, email y contraseña.
    GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),  // muestra RegisterScreen

    /// ═══ RUTA: /onboarding (Tutorial Inicial) ═══
    /// Pantalla de introducción con diapositivas explicativas para nuevos usuarios.
    GoRoute(path: '/onboarding', builder: (context, state) => const OnboardingScreen()),  // muestra OnboardingScreen

    /// ═══ RUTA: /main_menu (Menú del Juego) ═══
    /// Menú principal del juego con niveles, monedas y navegación a secciones.
    GoRoute(path: '/main_menu', builder: (context, state) => const MainMenuScreen()),  // muestra MainMenuScreen

    /// ═══ RUTA: /design_system (Sistema de Diseño) ═══
    /// Pantalla de demostración de componentes del sistema de diseño.
    GoRoute(path: '/design_system', builder: (context, state) => const DesignSystemScreen()),  // muestra DesignSystemScreen

    /// ═══ RUTA: /quiz (Pantalla de Quiz) ═══
    /// Pantalla principal de preguntas/respuestas. Recibe 'difficulty' como query parameter.
    GoRoute(
      path: '/quiz',  // ruta para acceder al quiz
      builder: (context, state) {  // función constructora que recibe contexto y estado de ruta
        final difficultyStr = state.uri.queryParameters['difficulty'] ?? 'basic';  // lee parámetro 'difficulty' o 'basic' por defecto
        final difficulty = Difficulty.values.firstWhere(  // busca el enum Difficulty correspondiente al string
          (d) => d.name == difficultyStr,  // compara nombre del enum con el string recibido
          orElse: () => Difficulty.basic,  // si no coincide, retorna Difficulty.basic como fallback
        );
        return QuizScreen(difficulty: difficulty);  // retorna QuizScreen con la dificultad seleccionada
      },
    ),

    /// ═══ RUTA: /challenge (Reto Final de Programación) ═══
    /// Pantalla de reto "todo o nada" con temporizador. Recibe 'difficulty' como query parameter.
    GoRoute(
      path: '/challenge',  // ruta para acceder al reto final
      builder: (context, state) {  // función constructora que recibe contexto y estado de ruta
        final difficulty = state.uri.queryParameters['difficulty'] ?? 'basic';  // lee parámetro 'difficulty' o 'basic' por defecto
        return ChallengeScreen(difficulty: difficulty);  // retorna ChallengeScreen con la dificultad seleccionada
      },
    ),

    /// ═══ RUTA: /ai-content (Visor de Contenido IA) ═══
    /// Pantalla para visualizar contenido generado por IA. Recibe el objeto AiContent como dato extra.
    GoRoute(
      path: '/ai-content',  // ruta para acceder al visor de contenido IA
      builder: (context, state) {  // función constructora que recibe contexto y estado de ruta
        final content = state.extra as AiContent?;  // extrae el objeto AiContent pasado como dato extra en la navegación
        if (content == null) {  // si no se proporcionó contenido (caso de error)
          Future.delayed(Duration.zero, () => context.go('/tienda'));  // redirige a la tienda inmediatamente
          return const Scaffold(  // retorna pantalla temporal de carga
            body: Center(child: CircularProgressIndicator()),  // muestra spinner centrado mientras redirige
          );
        }
        return AiContentViewerScreen(content: content);  // retorna visor con el contenido IA recibido
      },
    ),
  ],  // fin de la lista de rutas
);  // fin de la declaración de appRouter
