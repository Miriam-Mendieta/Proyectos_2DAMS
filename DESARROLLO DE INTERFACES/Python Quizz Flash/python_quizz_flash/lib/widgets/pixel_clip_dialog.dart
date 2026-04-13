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
import 'package:flutter/material.dart';  // Librería base de Flutter
import 'package:google_fonts/google_fonts.dart';  // Tipografías retro para el diálogo
import 'pixel_clip_logo.dart';  // El widget de la mascota del proyecto

// ═══ CLASE: PixelClipDialog ═══
/// Widget reutilizable que muestra a Pixel Clip con una burbuja de diálogo estilo "Windows clásico/Retro".
/// Replicado exactamente del estilo del Nivel Básico para mantener la coherencia.
class PixelClipDialog extends StatelessWidget {  // Widget sin estado para diálogos estáticos
  final String message;  // Mensaje que se mostrará en el diálogo
  final double iconSize;  // Tamaño de la mascota
  final bool isMobile;  // Indica si estamos en modo móvil para ajustar márgenes

  const PixelClipDialog({  // Constructor con parámetros configurables
    super.key,  // Clave del widget
    required this.message,  // Mensaje requerido para el diálogo
    this.iconSize =
        130,  // MEJORA: Tamaño aumentado para mayor presencia (antes 90)
    this.isMobile = false,  // Por defecto no es modo móvil
  });

  @override
  Widget build(BuildContext context) {  // Construye la interfaz del diálogo
    // Ajustamos el tamaño del icono dinámicamente si es móvil para evitar desbordamientos
    final double effectiveSize = isMobile ? iconSize * 0.7 : iconSize;  // Reduce al 70% en móvil

    return Padding(  // Aplica márgenes internos al contenido
      // Márgenes para dar aire a la sombra y posicionar el widget
      padding: EdgeInsets.only(  // Márgenes específicos por lado
        left: isMobile ? 5 : 40,  // Ajuste de márgenes laterales: 5 en móvil, 40 en desktop
        right: 10,  // Margen derecho fijo de 10
        bottom: 20,  // Margen inferior fijo de 20
      ),
      child: Row(  // Disposición horizontal de los elementos
        crossAxisAlignment: CrossAxisAlignment
            .end,  // Alineación inferior para que parezca que la mascota está en el suelo
        children: [  // Lista de elementos en la fila
          // --- LA MASCOTA PIXEL_CLIP (Tamaño XL) ---
          PixelClipLogo(size: effectiveSize),  // Widget del logo con tamaño ajustado

          const SizedBox(width: 15),  // Espaciador horizontal de 15 píxeles

          // --- BURBUJA DE DIÁLOGO (Estilo Nivel Básico) ---
          Flexible(  // Permite que la burbuja se ajuste al espacio disponible
            child: IntrinsicWidth(  // Ajusta el ancho al contenido mínimo necesario
              child: Container(  // Contenedor de la burbuja de diálogo
                padding: const EdgeInsets.symmetric(  // Padding horizontal y vertical
                  horizontal: 18,  // Padding horizontal de 18 píxeles
                  vertical: 15,  // Padding vertical de 15 píxeles
                ),
                decoration: BoxDecoration(  // Decoración de la burbuja
                  color: Colors.white,  // Fondo blanco sólido para legibilidad
                  border: Border.all(  // Borde exterior de la burbuja
                    color: Colors.black,  // Color negro del borde
                    width: 2.5,  // Grosor del borde: 2.5 píxeles
                  ),  // Borde negro más grueso
                  boxShadow: const [  // Lista de sombras para efecto retro
                    BoxShadow(  // Definición de la sombra
                      color: Colors.black45,  // Color de sombra: negro con 45% opacidad
                      offset: Offset(
                        5,
                        5,
                      ),  // Sombra más profunda para acompañar el tamaño: desplazamiento (5,5)
                    ),
                  ],
                ),
                child: Text(  // Widget de texto del mensaje
                  message,  // Contenido del mensaje a mostrar
                  style: GoogleFonts.shareTechMono(  // Fuente retro monoespaciada
                    color: Colors.black,  // Texto negro clásico
                    fontSize: 13,  // Texto ligeramente más grande
                    fontWeight: FontWeight.bold,  // Peso de fuente: negrita
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
