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
import 'package:flutter/material.dart';  // Importa el framework Material de Flutter para widgets y componentes UI
import '../theme/app_theme.dart';  // Importa el tema de la aplicacion para acceder a colores y estilos globales

/// ═══ CLASE: RetroContainer ═══
/// Un contenedor con bordes biselados que simula el estilo de Windows 95 o DOS.
/// Permite alternar entre estilo retro Win95 y estilo Cyberpunk con bordes de neon.
class RetroContainer extends StatelessWidget {  // Extiende StatelessWidget porque no necesita estado interno
  final Widget child;  // El contenido que se muestra dentro del contenedor
  final double? width;  // Ancho opcional del contenedor
  final double? height;  // Alto opcional del contenedor
  final EdgeInsetsGeometry padding;  // Relleno interno del contenedor
  final bool isWin95;  // Si es true usa estilo Win95, si es false usa estilo Cyberpunk
  final Color? borderColor;  // Color del borde personalizado para estilo Cyberpunk
  final Color? backgroundColor;  // Color de fondo personalizado
  final bool showGlow;  // Controla si se muestra el resplandor (glow) en el estilo Cyberpunk

  /// ═══ MÉTODO: Constructor de RetroContainer ═══
  /// Inicializa el contenedor retro con configuracion opcional de estilos
  const RetroContainer({
    super.key,  // Clave del widget para identificacion en el arbol
    required this.child,  // Parametro obligatorio: widget hijo a contener
    this.width,  // Ancho opcional
    this.height,  // Alto opcional
    this.padding = const EdgeInsets.all(12),  // Relleno por defecto: 12px en todos los lados
    this.isWin95 = true,  // Por defecto usa estilo Windows 95
    this.borderColor,  // Color de borde opcional
    this.backgroundColor,  // Color de fondo opcional
    this.showGlow = false,  // Por defecto sin resplandor para estilo pixel puro
  });

  @override
  Widget build(BuildContext context) {  // Construye la interfaz visual del contenedor
    // Renderizado para el estilo clasico de Windows 95 (bordes blancos y negros)
    if (isWin95) {  // Si esta activado el modo Win95
      return Container(  // Contenedor principal estilo Win95
        width: width,  // Ancho del contenedor
        height: height,  // Alto del contenedor
        padding: padding,  // Relleno interno definido
        decoration: BoxDecoration(  // Decoracion del contenedor
          color: backgroundColor ?? AppTheme.win95Grey,  // Color de fondo: personalizado o gris Win95 del tema
          border: const Border(  // Borde con efecto bisel tipico de Windows 95
            top: BorderSide(color: Colors.white, width: 2),  // Borde superior blanco, grosor 2 (luz arriba)
            left: BorderSide(color: Colors.white, width: 2),  // Borde izquierdo blanco, grosor 2 (luz a la izquierda)
            right: BorderSide(color: Colors.black, width: 2),  // Borde derecho negro, grosor 2 (sombra a la derecha)
            bottom: BorderSide(color: Colors.black, width: 2),  // Borde inferior negro, grosor 2 (sombra abajo)
          ),
        ),
        child: child,  // Widget hijo contenido
      );
    }

    // Renderizado para el estilo Terminal / Cyberpunk (bordes de neon)
    final color = borderColor ?? AppTheme.borderBlue;  // Color del borde: personalizado o azul del tema
    return Container(  // Contenedor principal estilo Cyberpunk
      width: width,  // Ancho del contenedor
      height: height,  // Alto del contenedor
      padding: padding,  // Relleno interno definido
      decoration: BoxDecoration(  // Decoracion del contenedor
        color: backgroundColor ?? AppTheme.surfaceBlue.withValues(alpha: 0.8),  // Fondo: personalizado o azul superficie con 80% opacidad
        border: Border.all(color: color, width: 2),  // Borde uniforme con color definido, grosor 2
        // Aplicamos el resplandor solo si showGlow es true
        boxShadow: showGlow  // Si showGlow esta activado
            ? [  // Lista de sombras para efecto glow
                BoxShadow(  // Sombra de resplandor
                  color: color.withValues(alpha: 0.3),  // Color del borde con 30% opacidad
                  blurRadius: 10,  // Radio de desenfoque: 10px para efecto difuso
                  spreadRadius: 1,  // Radio de expansion: 1px mas alla del borde
                ),
              ]
            : null,  // Si showGlow es false, sin sombras
      ),
      child: child,  // Widget hijo contenido
    );
  }
}
