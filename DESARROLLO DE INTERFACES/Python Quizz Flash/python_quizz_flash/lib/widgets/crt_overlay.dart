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
import 'package:flutter/material.dart';  // Librería base de Flutter para widgets Material Design

// ═══ CLASE: CRTOverlay ═══
/// Widget que aplica un efecto visual de monitor CRT con scanlines y viñeta sobre un hijo
class CRTOverlay extends StatelessWidget {  // Widget sin estado para overlay de efectos CRT
  final Widget child;  // Widget hijo que recibirá los efectos visuales CRT
  const CRTOverlay({super.key, required this.child});  // Constructor con hijo requerido

  @override
  Widget build(BuildContext context) {  // Construye la interfaz con efectos CRT
    return Stack(  // Apila elementos uno sobre otro
      children: [  // Lista de elementos apilados
        child,  // Widget hijo original como capa base
        // ═══ SECCIÓN: Scanlines ═══
        IgnorePointer(  // Ignora eventos de toque para no bloquear interacciones
          child: Container(  // Contenedor con gradiente de scanlines
            decoration: BoxDecoration(  // Decoración con gradiente
              gradient: LinearGradient(  // Gradiente lineal para efecto de líneas de escaneo
                begin: Alignment.topCenter,  // Inicio del gradiente: parte superior centrada
                end: Alignment.bottomCenter,  // Fin del gradiente: parte inferior centrada
                colors: [  // Colores del gradiente alternados
                  Colors.black.withValues(alpha: 0.0),  // Transparente en la primera mitad
                  Colors.black.withValues(alpha: 0.1),  // Negro al 10% en la segunda mitad
                ],
                stops: const [0.5, 0.5],  // Punto de transición exacto al 50%
                tileMode: TileMode.repeated,  // Repite el patrón verticalmente
              ),
            ),
          ),
        ),
        // ═══ SECCIÓN: Vignette ═══
        IgnorePointer(  // Ignora eventos de toque para no bloquear interacciones
          child: Container(  // Contenedor con gradiente radial de viñeta
            decoration: BoxDecoration(  // Decoración con gradiente radial
              gradient: RadialGradient(  // Gradiente radial para efecto de viñeta
                center: Alignment.center,  // Centro del gradiente: centro de la pantalla
                radius: 1.2,  // Radio del gradiente: 120% del tamaño
                colors: [  // Colores del gradiente de viñeta
                  Colors.transparent,  // Centro transparente (sin oscurecer)
                  Colors.black.withValues(alpha: 0.3),  // Borde oscurecido al 30%
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
