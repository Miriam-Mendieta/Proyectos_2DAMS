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
import 'package:flutter/material.dart';  // Importa el framework base de Flutter con widgets Material Design
import 'package:go_router/go_router.dart';  // Importa GoRouter para navegación declarativa entre pantallas
import 'package:google_fonts/google_fonts.dart';  // Importa Google Fonts para tipografías personalizadas
import '../theme/app_theme.dart';  // Importa el tema centralizado de la aplicación (colores, estilos)
import '../widgets/retro_button.dart';  // Importa el widget de botón con estilo retro
import '../widgets/retro_container.dart';  // Importa el widget de contenedor con estilo retro
import '../widgets/pixel_clip_logo.dart';  // Importa el widget del logo PixelClip con estilo pixelado

/// ═══ CLASE: OnboardingScreen ═══
/// Pantalla de Introducción (Onboarding) - Guía al usuario en sus primeros pasos.
/// Presenta una serie de diapositivas explicativas sobre la app antes de acceder al menú principal.
/// Extiende StatefulWidget porque maneja estado interno (página actual, animaciones).
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});  // Constructor con key opcional para optimización de Flutter

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();  // Crea el estado asociado a esta pantalla
}

/// ═══ CLASE: _OnboardingScreenState ═══
/// Estado de la pantalla de onboarding que gestiona la navegación entre diapositivas
/// y las animaciones de flotación del logo.
/// Usa TickerProviderStateMixin para múltiples controladores de animación.
class _OnboardingScreenState extends State<OnboardingScreen> with TickerProviderStateMixin {
  final PageController _pageController = PageController();  // Controlador para manejar la navegación del PageView
  int _currentPage = 0;  // Índice de la página actualmente visible (inicia en 0)
  late AnimationController _floatingController;  // Controlador de animación para efecto flotante (inicializado en initState)
  late Animation<Offset> _floatingAnimation;  // Animación de desplazamiento para el efecto flotante del logo

  @override
  void initState() {  // Método llamado al inicializar el estado
    super.initState();  // Llama al initState de la clase padre
    _floatingController = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);  // Crea controlador de 2s que se repite inversamente para animación de flotación
    _floatingAnimation = Tween<Offset>(begin: Offset.zero, end: const Offset(0, 0.08)).animate(CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut));  // Crea animación de offset desde origen hasta 8% abajo con curva suave
  }

  @override
  void dispose() { _floatingController.dispose(); _pageController.dispose(); super.dispose(); }  // Libera recursos de controladores al destruir el widget

  final List<OnboardingData> _pages = [  // Lista de datos para cada diapositiva del onboarding
    OnboardingData(title: '¡HOLA! SOY PIXEL_CLIP', body: 'Tu asistente en esta aventura de aprendizaje. Estoy aquí para guiarte en cada paso de este viaje con Python.', icon: Icons.bolt),  // Diapositiva 1: Presentación del asistente PixelClip con ícono de rayo
    OnboardingData(title: '</>¿QUÉ ES PYTHON_QUIZZ_FLASH?', body: 'Una aplicación interactiva diseñada para aprender Python de forma divertida. Combina quiz, ejercicios prácticos y desafios, todo en un ambiente retro-tech inspirado en los clásicos terminales', icon: Icons.code),  // Diapositiva 2: Descripción de la app con ícono de código
    OnboardingData(title: 'SISTEMA DE NIVELES', body: 'Desde Básico hasta Avanzado. Supera desafíos para desbloquear nuevos niveles y demostrar tu maestría.', icon: Icons.emoji_events),  // Diapositiva 3: Explicación del sistema de niveles con ícono de trofeos
    OnboardingData(title: 'PYTHON-COINS', body: 'Gana monedas al responder correctamente. Úsalas en la terminal para obtener pistas o personalizar tu experiencia.', icon: Icons.monetization_on),  // Diapositiva 4: Explicación del sistema de monedas con ícono de dinero
    OnboardingData(title: '¡COMENCEMOS!', body: 'El compilador está listo, el kernel inicializado. ¿Estás preparado para el desafío, coder? Recuerda: la práctica constante es la clave del éxito.', icon: Icons.rocket_launch),  // Diapositiva 5: Mensaje de inicio motivacional con ícono de cohete
  ];

  @override
  Widget build(BuildContext context) {  // Método de construcción del widget tree
    const Color mainBorderColor = AppTheme.borderBlue;  // Color principal de borde desde el tema de la app
    const Color neonCian = AppTheme.primaryCyan;  // Color cian neón desde el tema de la app

    return Scaffold(  // Estructura base de la pantalla Material
      backgroundColor: AppTheme.darkBg,  // Fondo oscuro desde el tema de la app
      body: SafeArea(  // Asegura que el contenido no quede detrás de barras del sistema
        child: Center(  // Centra el contenido horizontal y verticalmente
          child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 550), child: RetroContainer(isWin95: false, borderColor: mainBorderColor, backgroundColor: AppTheme.darkBg, padding: const EdgeInsets.all(4), child: SingleChildScrollView(child: Column(children: [  // Caja con ancho máximo de 550px, contenedor retro con scroll vertical
            Padding(padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20), child: Column(children: [  // Padding horizontal de 15px y vertical de 20px para la sección superior
              SlideTransition(position: _floatingAnimation, child: const PixelClipLogo(size: 160)),  // Logo PixelClip de 160px con animación de desplazamiento flotante
              const SizedBox(height: 25),  // Espacio vertical de 25px tras el logo
              RetroContainer(isWin95: false, borderColor: neonCian, backgroundColor: Colors.black.withValues(alpha: 0.6), padding: EdgeInsets.zero, child: Column(mainAxisSize: MainAxisSize.min, children: [  // Contenedor retro con borde cian y fondo negro semitransparente para el área de contenido
                Container(padding: const EdgeInsets.symmetric(vertical: 10), width: double.infinity, decoration: BoxDecoration(border: Border(bottom: BorderSide(color: neonCian, width: 1.5))), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(_pages[_currentPage].icon, color: neonCian, size: 20), const SizedBox(width: 8), Text(_pages[_currentPage].title, style: GoogleFonts.pressStart2p(color: neonCian, fontSize: 9))])),  // Barra de título con ícono y texto de la página actual, borde inferior cian
                Container(padding: const EdgeInsets.all(15), height: 130, child: PageView.builder(controller: _pageController, onPageChanged: (int page) => setState(() => _currentPage = page), itemCount: _pages.length, itemBuilder: (context, index) { return Center(child: Text(_pages[index].body, textAlign: TextAlign.center, style: GoogleFonts.robotoMono(color: Colors.white, fontSize: 13, height: 1.4, fontWeight: FontWeight.w500))); })),  // PageView de 130px de alto que muestra el cuerpo de cada diapositiva y actualiza _currentPage al cambiar
              ])),
              const SizedBox(height: 20),  // Espacio vertical de 20px tras el contenedor de contenido
              Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(_pages.length, (index) {  // Fila centrada con indicadores de página generados dinámicamente
                bool isActive = index == _currentPage;  // Determina si este indicador corresponde a la página activa
                return GestureDetector(  // Detector de gestos para cada indicador de página
                  onTap: () => _pageController.animateToPage(index, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut),  // Navega a la página correspondiente con animación de 400ms
                  child: Container(  // Contenedor visual del indicador
                    width: 12,  // Ancho: 12px
                    height: 12,  // Alto: 12px
                    margin: const EdgeInsets.symmetric(horizontal: 6),  // Margen horizontal: 6px
                    decoration: BoxDecoration(  // Decoración del indicador
                      color: isActive ? neonCian : Colors.transparent,  // Relleno cian si activo, transparente si no
                      border: Border.all(color: neonCian, width: 2),  // Borde cian de 2px siempre visible
                    ),
                  ),
                );
              })),
            ])),
            const SizedBox(height: 40),  // Espacio vertical de 40px antes de los botones de navegación
            Padding(padding: const EdgeInsets.fromLTRB(20, 10, 20, 20), child: _currentPage == _pages.length - 1 ? RetroButton(text: 'COMENZAR', style: RetroButtonStyle.primary, width: 250, onPressed: () => context.go('/main_menu')) : Row(mainAxisAlignment: MainAxisAlignment.center, children: [Expanded(child: RetroButton(text: 'Anterior', style: RetroButtonStyle.purple, onPressed: _currentPage > 0 ? () => _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.ease) : null)), const SizedBox(width: 15), Expanded(child: RetroButton(text: 'Siguiente', style: RetroButtonStyle.primary, onPressed: () => _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease)))])),  // Botón "COMENZAR" en última página (navega a /main_menu) o botones Anterior/Siguiente en las demás
            Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 10), decoration: BoxDecoration(color: mainBorderColor.withValues(alpha: 0.05), border: Border(top: BorderSide(color: mainBorderColor.withValues(alpha: 0.4), width: 2))), child: Column(children: [Text('Python_Quizz_Flash v1.0.0', textAlign: TextAlign.center, style: GoogleFonts.robotoMono(color: Colors.grey.shade500, fontSize: 11, fontWeight: FontWeight.bold)), const SizedBox(height: 2), Text('Una experiencia retro-tech para repasar Python', textAlign: TextAlign.center, style: GoogleFonts.robotoMono(color: Colors.grey.shade600, fontSize: 8))])),  // Pie de página con versión y descripción en gris, borde superior sutil
          ])))),
        ),
      ),
    );
  }
}

/// ═══ CLASE: OnboardingData ═══
/// Estructura de datos para las diapositivas del Onboarding.
/// Modelo inmutable que agrupa título, cuerpo e ícono de cada diapositiva.
class OnboardingData {
  final String title;  // Título de la diapositiva (texto superior)
  final String body;  // Cuerpo/descripción de la diapositiva (texto explicativo)
  final IconData icon;  // Ícono Material representativo de la diapositiva
  OnboardingData({required this.title, required this.body, required this.icon});  // Constructor con parámetros requeridos para todos los campos
}
