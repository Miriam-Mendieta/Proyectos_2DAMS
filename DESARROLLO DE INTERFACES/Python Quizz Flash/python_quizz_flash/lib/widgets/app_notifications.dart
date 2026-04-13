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
import 'package:flutter/material.dart';  // Librería base de Flutter para construir la UI
import 'package:google_fonts/google_fonts.dart';  // Paquete para fuentes retro como PressStart2P
import '../theme/app_theme.dart';  // Colores globales del tema de la aplicación

/// ═══ CLASE: AppNotifications ═══
/// Clase de utilidad para mostrar notificaciones (SnackBars) con estilo unificado.
/// ESTILO: Fondo blanco, texto negro para máxima legibilidad
class AppNotifications {
  /// ═══ MÉTODO: show ═══
  /// Muestra una notificación flotante con fondo blanco y texto negro.
  /// Este estilo asegura que el mensaje sea siempre legible.
  static void show(  // método estático que no requiere instancia
    BuildContext context,  // contexto de construcción actual del widget tree
    String message, {  // mensaje de texto a mostrar en la notificación
    bool isError = false,  // flag opcional: true si es mensaje de error
  }) {
    // Color del borde: cian para éxito, rojo para error
    final Color borderColor = isError ? AppTheme.neonRed : AppTheme.primaryCyan;  // selecciona color según tipo

    // Limpiamos notificaciones previas
    ScaffoldMessenger.of(context).hideCurrentSnackBar();  // oculta cualquier SnackBar visible actualmente

    // Lanzamos la notificación con estilo unificado: fondo blanco, texto negro
    ScaffoldMessenger.of(context).showSnackBar(  // muestra laSnackBar en pantalla
      SnackBar(  // widget de notificación flotante
        backgroundColor: Colors.white,  // fondo blanco para legibilidad
        content: Text(  // texto del mensaje
          message.toUpperCase(),  // convierte el mensaje a mayúsculas
          textAlign: TextAlign.center,  // centrado horizontal del texto
          style: GoogleFonts.pressStart2p(  // fuente pixelada retro
            fontSize: 10,  // tamaño de fuente de 10 píxeles
            color: Colors.black,  // texto negro para contraste máximo
            fontWeight: FontWeight.bold,  // texto en negrita
          ),
        ),
        duration: const Duration(seconds: 2),  // duración visible de 2 segundos
        behavior: SnackBarBehavior.floating,  // comportamiento flotante sobre el contenido
        margin: const EdgeInsets.only(bottom: 25, left: 20, right: 20),  // márgenes alrededor del SnackBar
        shape: RoundedRectangleBorder(  // forma del borde redondeado
          side: BorderSide(color: borderColor, width: 2),  // borde más grueso con color dinámico
          borderRadius: BorderRadius.circular(4),  // esquinas redondeadas de 4 píxeles
        ),
      ),
    );
  }
}
