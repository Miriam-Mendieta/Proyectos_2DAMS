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

import 'package:flutter/material.dart';                            // Widgets Material Design de Flutter
import 'package:flutter_riverpod/flutter_riverpod.dart';           // Gestión de estado con Riverpod (acceso a proveedores)
import 'package:google_fonts/google_fonts.dart';                   // Fuentes personalizadas de Google (Press Start 2P)
import 'package:go_router/go_router.dart';                         // Navegación entre pantallas con GoRouter
import '../theme/app_theme.dart';                                  // Colores y temas definidos para la app
import '../services/music_service.dart';                           // Servicio que controla la reproducción de música

/// ═══════════════════════════════════════════════════════════
/// CLASE: InicioScreen (Widget con estado que usa Riverpod)
/// Representa la pantalla del Menú Principal con diseño PIXEL ART.
/// Incluye activación de música en el primer clic del usuario.
/// ═══════════════════════════════════════════════════════════
class InicioScreen extends ConsumerStatefulWidget {
  const InicioScreen({super.key});                                 // Constructor con clave única del widget

  @override
  ConsumerState<InicioScreen> createState() => _InicioScreenState(); // Crea y retorna el estado privado de esta pantalla
}

/// ═══════════════════════════════════════════════════════════
/// CLASE: _InicioScreenState (Estado privado de InicioScreen)
/// - Extiende ConsumerState para acceder a 'ref' de Riverpod
/// - Mezcla SingleTickerProviderStateMixin para usar animaciones
/// ═══════════════════════════════════════════════════════════
class _InicioScreenState extends ConsumerState<InicioScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _blinkController;                       // Controlador de animación para el parpadeo (se inicializa después)

  /// MÉTODO: initState - Se ejecuta al crear el widget
  @override
  void initState() {
    super.initState();                                             // Llama a la inicialización del padre
    _blinkController = AnimationController(                        // Crea el controlador de animación
      vsync: this,                                                 // Sincroniza con la tasa de refresco de pantalla
      duration: const Duration(milliseconds: 500),                 // Duración de cada ciclo: 500ms (medio segundo)
    )..repeat(reverse: true);                                      // Repite infinitamente en reversa (efecto parpadeo)
  }

  /// MÉTODO: dispose - Se ejecuta al eliminar el widget (limpieza)
  @override
  void dispose() {
    _blinkController.dispose();                                    // Libera recursos de la animación para evitar fugas de memoria
    super.dispose();                                               // Llama a la limpieza del padre
  }

  /// MÉTODO: build - Construye la interfaz visual de la pantalla
  @override
  Widget build(BuildContext context) {
    return GestureDetector(                                        // Detector de gestos que envuelve toda la pantalla
      onTapDown: (_) =>                                            // Al tocar la pantalla: intenta reanudar la música
          ref.read(musicControllerProvider.notifier).resumeIfBlocked(), // Accede al proveedor de música y reanuda si está bloqueada (soluciona autoplay en Chrome Web)
      child: Scaffold(                                             // Estructura visual principal de la pantalla
        backgroundColor: AppTheme.darkBg,                          // Color de fondo oscuro del tema
        body: SafeArea(                                            // Evita que el contenido se superponga con notch o barras del sistema
          child: Center(                                           // Centra todo el contenido vertical y horizontalmente
            child: Column(                                         // Organiza los widgets verticalmente (arriba → abajo)
              children: [                                          // Lista de widgets en la columna
                const Spacer(flex: 4),                             // Espacio flexible superior (4 partes del espacio disponible)

                _buildGeminiPixelTitle('PYTHON'),                  // Título pixel art: "PYTHON"
                _buildGeminiPixelTitle('QUIZZ'),                   // Título pixel art: "QUIZZ"
                _buildGeminiPixelTitle('FLASH'),                   // Título pixel art: "FLASH"

                const SizedBox(height: 30),                        // Espacio vertical de 30px entre título y eslogan

                Text(                                              // Widget de texto para el eslogan
                  'Aprende, Juega y Conquista Python',             // Texto del eslogan
                  textAlign: TextAlign.center,                     // Centra el texto horizontalmente
                  style: GoogleFonts.pressStart2p(                 // Fuente Press Start 2P (estilo retro pixel art)
                    color: AppTheme.primaryCyan,                   // Color cian primario del tema
                    fontSize: 10,                                  // Tamaño: 10px (pequeño para estilo retro)
                  ),
                ),

                const SizedBox(height: 10),                        // Espacio vertical de 10px entre eslogan y versión

                Text(                                              // Widget de texto para la versión
                  'v1.0.0 | SISTEMA LISTO',                        // Texto con versión y estado
                  style: GoogleFonts.pressStart2p(                 // Fuente Press Start 2P
                    color: AppTheme.greyBlue,                      // Color gris azulado (menos destacado)
                    fontSize: 8,                                   // Tamaño: 8px (más pequeño que el eslogan)
                  ),
                ),

                const SizedBox(height: 50),                        // Espacio vertical de 50px antes de los botones

                Row(                                               // Fila horizontal para los botones
                  mainAxisAlignment: MainAxisAlignment.center,     // Centra los botones horizontalmente
                  children: [                                      // Lista de widgets en la fila
                    _buildCompactPixelButton(                      // Botón: "INICIAR SESIÓN"
                      text: 'INICIAR SESIÓN',                      // Texto del botón
                      backgroundColor: AppTheme.surfaceBlue,       // Color de fondo: azul superficie
                      textColor: AppTheme.primaryCyan,             // Color del texto: cian primario
                      onPressed: () {                              // Función al presionar el botón
                        ref.read(musicControllerProvider.notifier).resumeIfBlocked(); // Asegura que la música esté activa
                        context.go('/login');                      // Navega a la pantalla de login
                      },
                    ),
                    const SizedBox(width: 15),                     // Espacio horizontal de 15px entre botones
                    _buildCompactPixelButton(                      // Botón: "REGISTRARSE"
                      text: 'REGISTRARSE',                         // Texto del botón
                      backgroundColor: const Color(0xFFD1D9E6),    // Color de fondo: gris claro
                      textColor: const Color(0xFF0D1B2A),          // Color del texto: azul oscuro
                      onPressed: () {                              // Función al presionar el botón
                        ref.read(musicControllerProvider.notifier).resumeIfBlocked(); // Asegura que la música esté activa
                        context.go('/register');                   // Navega a la pantalla de registro
                      },
                    ),
                  ],
                ),

                const Spacer(flex: 6),                             // Espacio flexible que empuja el footer (6 partes)

                Padding(                                           // Padding para el margen inferior del footer
                  padding: const EdgeInsets.only(bottom: 20),      // Margen solo inferior de 20px
                  child: Row(                                      // Fila horizontal para el footer
                    mainAxisAlignment: MainAxisAlignment.center,   // Centra los elementos del footer
                    children: [                                    // Lista de widgets en la fila
                      FadeTransition(                              // Animación de opacidad (parpadeo)
                        opacity: _blinkController,                 // Controla la opacidad con la animación
                        child: Container(                          // Contenedor cuadrado que parpadea
                          width: 10,                               // Ancho: 10px
                          height: 10,                              // Alto: 10px
                          color: AppTheme.brightCyan,              // Color: cian brillante
                        ),
                      ),
                      const SizedBox(width: 10),                   // Espacio horizontal de 10px entre cuadrado y texto
                      Text(                                        // Widget de texto del footer
                        'LISTO_PARA_ENTRAR',                       // Texto del footer
                        style: GoogleFonts.pressStart2p(           // Fuente Press Start 2P
                          color: AppTheme.primaryCyan,             // Color: cian primario
                          fontSize: 9,                             // Tamaño: 9px
                          letterSpacing: 1,                        // Espaciado entre letras: 1px
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(flex: 1),                             // Espacio flexible inferior (1 parte, ocupa el resto)
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ═══════════════════════════════════════════════════════
  /// MÉTODO: _buildGeminiPixelTitle
  /// Crea el título pixel art con efecto de sombra/reflejo doble.
  /// Usa dos capas: una trasera (reflejo) y una frontal (texto principal).
  /// ═══════════════════════════════════════════════════════
  Widget _buildGeminiPixelTitle(String text) {
    const double fontSize = 52.0;                                  // Tamaño de fuente: 52px
    const double letterSpacing = 6.0;                              // Espaciado entre letras: 6px
    const Offset mirrorOffset = Offset(8, 8);                      // Desplazamiento del reflejo: 8px en X e Y

    return Container(                                              // Contenedor principal del título
      constraints: const BoxConstraints(maxWidth: 360),            // Ancho máximo: 360px (evita desbordamiento)
      margin: const EdgeInsets.only(bottom: 10),                   // Margen inferior: 10px
      child: FittedBox(                                            // Escala el contenido para que quepa
        fit: BoxFit.scaleDown,                                     // Reduce el tamaño si es demasiado grande
        child: Stack(                                              // Superpone capas de texto
          children: [                                              // Lista de capas (de atrás hacia adelante)
            _pixelArtGroup(                                        // Capa trasera: efecto de reflejo/sombra
              text,                                                // Texto a mostrar
              fontSize,                                            // Tamaño de fuente
              letterSpacing,                                       // Espaciado entre letras
              offset: mirrorOffset,                                // Desplazamiento del reflejo
              fillColor: AppTheme.darkBg,                          // Relleno: color de fondo oscuro
              borderColor: AppTheme.primaryCyan,                   // Borde: cian primario
              opacity: 0.8,                                        // Opacidad: 80% (ligeramente transparente)
            ),
            _pixelArtGroup(                                        // Capa frontal: texto principal
              text,                                                // Texto a mostrar
              fontSize,                                            // Tamaño de fuente
              letterSpacing,                                       // Espaciado entre letras
              offset: Offset.zero,                                 // Sin desplazamiento (posición original)
              fillColor: AppTheme.primaryCyan,                     // Relleno: cian primario
              borderColor: Colors.black,                           // Borde: negro
              innerBorderColor: AppTheme.mutedTeal,                // Borde interior: verde azulado apagado
              opacity: 1.0,                                        // Opacidad: 100% (sólido)
            ),
          ],
        ),
      ),
    );
  }

  /// ═══════════════════════════════════════════════════════
  /// MÉTODO: _pixelArtGroup
  /// Construye un grupo de textos que simulan bordes pixelados.
  /// Crea 9 capas de texto desplazadas + 1 capa central = efecto pixel art.
  /// ═══════════════════════════════════════════════════════
  Widget _pixelArtGroup(
    String text,                                                   // Texto a mostrar
    double fontSize,                                               // Tamaño de fuente
    double spacing,                                                // Espaciado entre letras
    {
    required Offset offset,                                        // Desplazamiento del grupo (obligatorio)
    required Color fillColor,                                      // Color de relleno (obligatorio)
    required Color borderColor,                                    // Color del borde (obligatorio)
    Color? innerBorderColor,                                       // Color del borde interior (opcional)
    double opacity = 1.0,                                          // Opacidad: 100% por defecto
  }) {
    final Color border = borderColor.withValues(alpha: opacity);   // Calcula color del borde con opacidad
    final Color inner = (innerBorderColor ?? borderColor).withValues(alpha: opacity); // Color del borde interior (usa borderColor si no se proporciona)

    return Stack(                                                  // Superpone todas las capas de texto
      children: [                                                  // Lista de capas
        _titleText(text, fontSize, spacing, border, offset: offset + const Offset(-2, -2)), // Borde exterior: esquina superior izquierda
        _titleText(text, fontSize, spacing, border, offset: offset + const Offset(2, -2)),  // Borde exterior: esquina superior derecha
        _titleText(text, fontSize, spacing, border, offset: offset + const Offset(-2, 2)),  // Borde exterior: esquina inferior izquierda
        _titleText(text, fontSize, spacing, border, offset: offset + const Offset(2, 2)),   // Borde exterior: esquina inferior derecha
        _titleText(text, fontSize, spacing, inner, offset: offset + const Offset(-1, -1)),  // Borde interior: esquina superior izquierda
        _titleText(text, fontSize, spacing, inner, offset: offset + const Offset(1, -1)),   // Borde interior: esquina superior derecha
        _titleText(text, fontSize, spacing, inner, offset: offset + const Offset(-1, 1)),   // Borde interior: esquina inferior izquierda
        _titleText(text, fontSize, spacing, inner, offset: offset + const Offset(1, 1)),    // Borde interior: esquina inferior derecha

        Transform.translate(                                       // Capa central: texto principal desplazado
          offset: offset,                                          // Aplica el desplazamiento especificado
          child: Text(                                             // Widget de texto central
            text,                                                  // Texto a mostrar
            style: GoogleFonts.pressStart2p(                       // Fuente Press Start 2P
              fontSize: fontSize,                                  // Tamaño de fuente
              fontWeight: FontWeight.bold,                         // Peso: negrita
              letterSpacing: spacing,                              // Espaciado entre letras
              color: fillColor.withValues(alpha: opacity),         // Color de relleno con opacidad
            ),
          ),
        ),
      ],
    );
  }

  /// ═══════════════════════════════════════════════════════
  /// MÉTODO: _titleText
  /// Crea un texto individual con desplazamiento.
  /// Se usa como capa para construir el efecto pixel art.
  /// ═══════════════════════════════════════════════════════
  Widget _titleText(
    String text,                                                   // Texto a mostrar
    double fontSize,                                               // Tamaño de fuente
    double spacing,                                                // Espaciado entre letras
    Color color,                                                   // Color del texto
    {Offset offset = Offset.zero}                                  // Desplazamiento: cero por defecto
  ) {
    return Transform.translate(                                    // Desplaza el texto en X e Y
      offset: offset,                                              // Aplica el desplazamiento especificado
      child: Text(                                                 // Widget de texto
        text,                                                      // Texto a mostrar
        style: GoogleFonts.pressStart2p(                           // Fuente Press Start 2P
          fontSize: fontSize,                                      // Tamaño de fuente
          fontWeight: FontWeight.bold,                             // Peso: negrita
          letterSpacing: spacing,                                  // Espaciado entre letras
          color: color,                                            // Color del texto
        ),
      ),
    );
  }

  /// ═══════════════════════════════════════════════════════
  /// MÉTODO: _buildCompactPixelButton
  /// Construye un botón compacto con estilo pixel art 3D.
  /// Usa dos sombras (luz arriba-izquierda, sombra abajo-derecha).
  /// ═══════════════════════════════════════════════════════
  Widget _buildCompactPixelButton({
    required String text,                                          // Texto del botón (obligatorio)
    required Color backgroundColor,                                // Color de fondo (obligatorio)
    required Color textColor,                                      // Color del texto (obligatorio)
    required VoidCallback onPressed,                               // Función al hacer clic (obligatorio)
    double width = 165,                                            // Ancho: 165px por defecto
  }) {
    return GestureDetector(                                        // Detector de gestos para capturar el clic
      onTap: onPressed,                                            // Ejecuta la función al tocar
      child: Container(                                            // Contenedor visual del botón
        width: width,                                              // Ancho del botón
        padding: const EdgeInsets.symmetric(vertical: 16),         // Relleno vertical: 16px arriba y abajo
        decoration: BoxDecoration(                                 // Decoración del contenedor
          color: backgroundColor,                                  // Color de fondo
          borderRadius: BorderRadius.circular(8),                  // Bordes redondeados: radio 8px
          boxShadow: [                                             // Lista de sombras (efecto 3D)
            BoxShadow(                                             // Sombra superior izquierda (luz)
              color: Colors.white.withValues(alpha: 0.3),          // Color: blanco 30% opacidad
              offset: const Offset(-3, -3),                        // Desplazamiento: 3px arriba e izquierda
              blurRadius: 0,                                       // Sin difuminado (borde duro pixel art)
            ),
            BoxShadow(                                             // Sombra inferior derecha (sombra)
              color: Colors.black.withValues(alpha: 0.4),          // Color: negro 40% opacidad
              offset: const Offset(3, 3),                          // Desplazamiento: 3px abajo y derecha
              blurRadius: 0,                                       // Sin difuminado (borde duro pixel art)
            ),
          ],
        ),
        child: Center(                                             // Centra el texto dentro del botón
          child: Text(                                             // Widget de texto
            text,                                                  // Texto del botón
            style: GoogleFonts.pressStart2p(                       // Fuente Press Start 2P
              color: textColor,                                    // Color del texto
              fontSize: 8,                                         // Tamaño: 8px
              fontWeight: FontWeight.bold,                         // Peso: negrita
            ),
          ),
        ),
      ),
    );
  }
}
