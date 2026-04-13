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
import 'package:go_router/go_router.dart';  // Paquete para la navegación declarativa entre pantallas
import '../theme/app_theme.dart';  // Tema de la aplicación con colores oficiales (Cian, Rojo, etc.)
import 'retro_button.dart';  // Widget de botón personalizado con estilo retro del sistema de diseño

/// ═══ CLASE: AppHeaderButtons ═══
/// Widget reutilizable que contiene los botones de VOLVER y SALIR.
/// Diseñado para mantener la consistencia visual en toda la aplicación.
class AppHeaderButtons extends StatelessWidget {
  /// Acción personalizada para el botón VOLVER. Si es null, hace context.pop().
  final VoidCallback? onBack;  // callback opcional para acción de volver

  /// Acción personalizada para el botón SALIR. Si es null, va a '/inicio'.
  final VoidCallback? onExit;  // callback opcional para acción de salir

  /// Color del texto para el botón VOLVER (Por defecto Cian Neón).
  final Color backTextColor;  // color del texto del botón volver, por defecto cian

  /// Color del texto para el botón SALIR (Por defecto Rojo Neón).
  final Color exitTextColor;  // color del texto del botón salir, por defecto rojo

  const AppHeaderButtons({  // constructor con parámetros opcionales
    super.key,  // clave del widget
    this.onBack,  // callback opcional para volver
    this.onExit,  // callback opcional para salir
    this.backTextColor = AppTheme.primaryCyan,  // color por defecto: cian del tema
    this.exitTextColor = AppTheme.neonRed,  // color por defecto: rojo neón del tema
  });

  @override
  Widget build(BuildContext context) {  // ═══ MÉTODO: build ═══
    // Construye la fila de botones VOLVER y SALIR con tamaño adaptativo
    // Obtenemos el ancho de la pantalla para ajustar el tamaño de los botones
    final double screenWidth = MediaQuery.of(context).size.width;  // ancho actual de la pantalla
    final bool isMobile = screenWidth < 700;  // determina si es dispositivo móvil (< 700px)

    return Row(  // fila horizontal para los botones
      mainAxisAlignment: MainAxisAlignment.spaceBetween,  // botones separados a los extremos
      crossAxisAlignment: CrossAxisAlignment.start,  // alineación superior
      children: [  // ═══ SECCIÓN: botón VOLVER ═══
        // --- BOTÓN VOLVER ---
        // Usamos RetroButton con el estilo secundario para una acción de retroceso
        RetroButton(  // botón personalizado de volver
          text: "VOLVER",  // texto visible del botón
          icon: Icons.arrow_back,  // ícono de flecha hacia atrás
          width: isMobile ? 120 : 140,  // tamaño adaptativo según el dispositivo
          height: 45,  // alto estándar de la cabecera
          style: RetroButtonStyle.secondary,  // estilo secundario del botón retro
          onPressed:  // acción al presionar
              onBack ??  // si hay callback personalizado, úsalo
              () {  // ═══ SECCIÓN: acción por defecto de volver ═══
                // Verificar si hay algo que hacer pop
                if (Navigator.of(context).canPop()) {  // si hay pantallas anteriores en el stack
                  context.pop();  // regresa a la pantalla anterior
                } else {  // si no hay pantallas anteriores
                  // Si no hay nada que hacer pop, ir al main menu
                  context.go('/main_menu');  // navega al menú principal
                }
              },
        ),

        // --- BOTÓN SALIR ---  // ═══ SECCIÓN: botón SALIR ═══
        // Usamos RetroButton con el estilo danger para indicar una salida del flujo actual
        RetroButton(  // botón personalizado de salir
          text: "SALIR",  // texto visible del botón
          icon: Icons.close,  // ícono de cerrar (X)
          width: isMobile ? 120 : 140,  // tamaño adaptativo
          height: 45,  // alto estándar
          style: RetroButtonStyle.danger,  // estilo danger (rojo) del botón retro
          onPressed:  // acción al presionar
              onExit ??  // si hay callback personalizado, úsalo
              () => context.go('/inicio'),  // de lo contrario navega al inicio por defecto
        ),
      ],
    );
  }
}
