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
import 'package:google_fonts/google_fonts.dart';  // Paquete para usar fuentes personalizadas como RobotoMono

/// ═══ CLASE: AppFooter ═══
/// Widget que renderiza el pie de página de la aplicación con estilo retro-tech,
/// mostrando el nombre de la app, versión y una descripción corta.
class AppFooter extends StatelessWidget {
  /// Color opcional para el borde superior del footer
  final Color? borderColor;  // si es null se usa el color por defecto

  const AppFooter({super.key, this.borderColor});  // constructor con parámetro opcional borderColor

  @override
  Widget build(BuildContext context) {  // ═══ MÉTODO: build ═══
    // Construye el widget del footer con texto de versión y descripción
    const Color defaultBorderColor = Color(0xFF4BA3C3);  // color azul cian por defecto para el borde
    final Color effectiveBorderColor = borderColor ?? defaultBorderColor;  // color efectivo: usa el proporcionado o el por defecto

    return Container(  // contenedor principal del footer
      width: double.infinity,  // ocupa todo el ancho disponible
      padding: const EdgeInsets.symmetric(vertical: 15),  // padding vertical de 15 píxeles
      decoration: BoxDecoration(  // ═══ SECCIÓN: decoración del contenedor ═══
        color: const Color(0xFF0D1B2A),  // fondo oscuro azulado
        border: Border(  // borde solo en la parte superior
          top: BorderSide(  // línea superior del borde
            color: effectiveBorderColor.withValues(alpha: 0.5),  // color con 50% de opacidad
            width: 2,  // grosor del borde de 2 píxeles
          ),
        ),
      ),
      child: Column(  // columna vertical para los textos
        mainAxisSize: MainAxisSize.min,  // ocupa solo el espacio mínimo necesario
        children: [  // ═══ SECCIÓN: hijos de la columna ═══
          Text(  // texto con nombre y versión de la app
            "> PYTHON_QUIZZ_FLASH V1.0.0",  // título estilo terminal con símbolo ">"
            style: GoogleFonts.robotoMono(  // fuente monoespaciada estilo retro
              color: effectiveBorderColor,  // color del texto igual al borde
              fontWeight: FontWeight.bold,  // texto en negrita
              fontSize: 12,  // tamaño de fuente de 12 píxeles
            ),
          ),
          const SizedBox(height: 4),  // espacio vertical de 4 píxeles entre los textos
          Text(  // texto descriptivo debajo de la versión
            "Una experiencia retro-tech para repasar Python",  // descripción en español
            style: GoogleFonts.robotoMono(color: Colors.grey, fontSize: 10),  // fuente gris de 10 píxeles
          ),
        ],
      ),
    );
  }
}
