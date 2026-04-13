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

/// ═══ CLASE: RetroProgressBar ═══
/// Barra de progreso estilo terminal mas gruesa (18px).
/// Muestra el avance actual sobre un total con apariencia de consola retro.
class RetroProgressBar extends StatelessWidget {  // Extiende StatelessWidget porque no necesita estado interno
  final int current;  // Valor actual de progreso
  final int total;  // Valor total para calcular el porcentaje de avance

  /// ═══ MÉTODO: Constructor de RetroProgressBar ═══
  /// Inicializa la barra de progreso con valores actual y total
  const RetroProgressBar({super.key, required this.current, this.total = 15});  // current es obligatorio, total por defecto 15

  @override
  Widget build(BuildContext context) {  // Construye la interfaz visual de la barra de progreso
    const Color neonCian = Color(0xFF00F2FF);  // Color cyan neon para la barra de progreso
    const Color borderColor = Colors.grey;  // Color gris para el borde de la barra

    return Container(  // Contenedor externo que proporciona el borde
      decoration: BoxDecoration(  // Decoracion del contenedor
        border: Border.all(color: borderColor, width: 1.5),  // Borde gris con grosor de 1.5px
      ),
      child: ClipRRect(  // Recorta el contenido hijo con bordes definidos
        borderRadius: BorderRadius.zero,  // Sin redondeo de esquinas (esquinas cuadradas estilo retro)
        child: LinearProgressIndicator(  // Indicador de progreso lineal de Material
          value: current / total,  // Valor de progreso: division entre actual y total (0.0 a 1.0)
          minHeight: 18,  // Altura minima de la barra: 18px (mas gruesa que el default)
          backgroundColor: Colors.black,  // Color de fondo de la porcion no completada: negro
          valueColor: const AlwaysStoppedAnimation<Color>(neonCian),  // Color de la porcion completada: cyan neon fijo
        ),
      ),
    );
  }
}
