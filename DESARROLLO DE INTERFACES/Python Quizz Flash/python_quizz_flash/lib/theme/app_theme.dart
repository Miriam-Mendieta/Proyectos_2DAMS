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

// ═══ IMPORTS: Dependencias del tema visual de la aplicación ═══

import 'package:flutter/material.dart';  // importa framework base de Flutter para ThemeData, ColorScheme y tipografías

/// ═══ CLASE: AppTheme ═══
/// Sistema de diseño centralizado que define la paleta de colores,
/// tipografías y configuraciones visuales globales de la aplicación.
/// Estética retro-tech/cyberpunk con fondo oscuro y acentos en cian neón.
class AppTheme {
  // ═══ PALETA DE COLORES PRINCIPAL ═══

  static const Color darkBg = Color(0xFF0D1B2A);  // fondo principal oscuro azul-marino (uniforme en toda la app)
  static const Color primaryCyan = Color(0xFF00FFFF);  // cian ultra eléctrico (color primario de acentos y títulos)
  static const Color pureWhite = Color(0xFFFFFFFF);  // blanco puro para contrastes máximos
  static const Color mutedTeal = Color(0xFF18A3B7);  // azul/verde apagado para elementos secundarios
  static const Color greyBlue = Color(0xFF6F7FA1);  // gris azulado para detalles sutiles y texto secundario

  static const Color brightCyan = Color(0xFF5FFBF1);  // cian neón con toque de luz para indicadores y logos
  static const Color surfaceBlue = Color(0xFF14243D);  // azul superficie para contenedores y tarjetas
  static const Color borderBlue = Color(0xFF1B4965);  // azul borde para marcos y separadores neón
  static const Color neonGreen = Color(0xFF39FF14);  // verde neón para código y mensajes de éxito
  static const Color neonRed = Color(0xFFFF003C);  // rojo neón para errores y alertas críticas
  static const Color consoleGrey = greyBlue;  // gris consola (alias de greyBlue) para texto de consola

  // ═══ COLORES PARA BOTONES ═══

  static const Color buttonBluePrimary = primaryCyan;  // color primario de botones (cian eléctrico)
  static const Color buttonBlueSecondary = mutedTeal;  // color secundario de botones (teal apagado)
  static const Color darkBlueText = darkBg;  // color de texto sobre botones claros (fondo oscuro)

  // ═══ COLORES ESTILO WINDOWS 95 ═══

  static const Color win95Grey = Color(0xFFC0C0C0);  // gris clásico de interfaz Windows 95
  static const Color win95Blue = Color(0xFF000080);  // azul clásico de barra de título Windows 95

  /// ═══ GETTER: darkTheme ═══
  /// Configura y retorna el tema oscuro global de la aplicación.
  /// Incluye ColorScheme, TextTheme con fuentes personalizadas,
  /// AppBarTheme y ElevatedButtonTheme coherentes con la estética retro.
  static ThemeData get darkTheme {  // getter que construye y retorna el tema
    return ThemeData(  // crea instancia de configuración de tema Material
      useMaterial3: true,  // habilita Material Design 3 (última versión de Material)
      brightness: Brightness.dark,  // establece luminosidad oscura global
      scaffoldBackgroundColor: darkBg,  // color de fondo de Scaffold: azul marino oscuro
      colorScheme: ColorScheme.fromSeed(  // genera esquema de colores desde semilla
        seedColor: primaryCyan,  // color semilla: cian eléctrico (genera tonos derivados)
        brightness: Brightness.dark,  // luminosidad oscura para el esquema
        primary: primaryCyan,  // color primario: cian eléctrico
        surface: surfaceBlue,  // color de superficies: azul superficie
        onSurface: Colors.white,  // color de contenido sobre superficies: blanco
        error: neonRed,  // color de errores: rojo neón
      ),
      textTheme: const TextTheme(  // configura tipografías globales de la app
        // ═══ TÍTULOS: Estilo Pixel Art ═══
        displayLarge: TextStyle(  // estilo para títulos principales (encabezados grandes)
          fontFamily: 'PressStart2P',  // fuente pixel art retro registrada en pubspec.yaml
          fontSize: 24,  // tamaño grande para encabezados
          fontWeight: FontWeight.bold,  // peso negrita para impacto visual
          color: primaryCyan,  // color cian eléctrico
          letterSpacing: 2.0,  // espaciado entre letras para efecto retro
        ),
        titleLarge: TextStyle(  // estilo para títulos secundarios
          fontFamily: 'PressStart2P',  // fuente pixel art
          fontSize: 16,  // tamaño medio
          color: Colors.white,  // color blanco
        ),
        // ═══ CUERPO DE TEXTO: Terminal / Máquina de escribir ═══
        bodyLarge: TextStyle(  // estilo para párrafos y cuerpo principal
          fontFamily: 'IBMPlexMono',  // fuente monoespaciada estilo IBM terminal
          fontSize: 14,  // tamaño legible para lectura
          color: Colors.white,  // color blanco
        ),
        bodyMedium: TextStyle(  // estilo para texto secundario o descripciones
          fontFamily: 'IBMPlexMono',  // fuente monoespaciada
          fontSize: 12,  // tamaño más pequeño
          color: consoleGrey,  // color gris consola
          height: 1.5,  // interlineado de 1.5x para mejor legibilidad
        ),
        // ═══ CÓDIGO: Monospaced con ligaduras ═══
        labelLarge: TextStyle(  // estilo para bloques de código y etiquetas
          fontFamily: 'FiraCode',  // fuente monoespaciada con ligaduras de programación
          fontSize: 13,  // tamaño adecuado para código
          color: neonGreen,  // color verde neón (estilo terminal clásica)
          fontWeight: FontWeight.w500,  // peso medio para claridad
        ),
        labelSmall: TextStyle(  // estilo para etiquetas pequeñas y badges
          fontFamily: 'PressStart2P',  // fuente pixel art
          fontSize: 8,  // tamaño muy pequeño
          color: primaryCyan,  // color cian eléctrico
        ),
      ),
      appBarTheme: const AppBarTheme(  // configura el estilo global de todas las AppBars
        backgroundColor: darkBg,  // fondo oscuro consistente con el resto de la app
        elevation: 0,  // sin sombra (estética plana retro)
        centerTitle: true,  // título centrado en la barra
        titleTextStyle: TextStyle(  // estilo del texto de título en AppBar
          color: primaryCyan,  // color cian eléctrico
          fontSize: 14,  // tamaño compacto para barra
          fontFamily: 'PressStart2P',  // fuente pixel art
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(  // configura el estilo de todos los ElevatedButtons
        style: ButtonStyle(  // define estilo personalizado de botones
          backgroundColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {  // función que resuelve color de fondo según estado
            if (states.contains(WidgetState.hovered)) {  // si el botón está siendo hovered (cursor encima)
              return Colors.grey.shade800;  // cambia a gris oscuro como feedback visual
            }
            return buttonBluePrimary;  // color por defecto: cian eléctrico
          }),
          foregroundColor: WidgetStateProperty.all(Colors.white),  // color de texto: blanco siempre
          shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))),  // forma: rectángulo con bordes redondeados de 8px
          padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 16, vertical: 12)),  // relleno interno: 16px horizontal, 12px vertical
        ),
      ),
    );
  }

  /// ═══ MÉTODO: glow ═══
  /// Crea un efecto de resplandor (glow) como BoxShadow.
  /// Se usa para dar efecto neón brillante a contenedores y textos.
  /// Por defecto usa primaryCyan pero acepta cualquier color.
  static BoxShadow glow({Color color = primaryCyan}) {  // retorna BoxShadow con efecto glow
    return BoxShadow(  // crea sombra con efecto de resplandor
      color: color.withAlpha(150),  // color con 150/255 de opacidad (~59% transparente)
      blurRadius: 15,  // radio de difuminado: 15px para efecto suave
      spreadRadius: 1,  // radio de expansión: 1px para extender el glow
    );
  }

  /// ═══ MÉTODO: neonShadow ═══
  /// Crea una sombra neón usando el efecto glow.
  /// Alias semántico de glow() para claridad en el código.
  static BoxShadow neonShadow({Color color = primaryCyan}) => glow(color: color);  // delega en glow() con el color proporcionado
}
