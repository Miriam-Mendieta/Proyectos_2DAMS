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
import 'package:google_fonts/google_fonts.dart';  // Importa Google Fonts para usar fuentes personalizadas (Roboto, SourceCodePro)

/// ═══ CLASE: NeonTextField ═══
/// Campo de texto con estilo de neon cyan y bordes cuadrados.
/// Soporta validacion, modo password y tipos de teclado personalizables.
class NeonTextField extends StatelessWidget {  // Extiende StatelessWidget porque no necesita estado interno
  final String label;  // Etiqueta que se muestra encima del campo de texto
  final String hintText;  // Texto de sugerencia dentro del campo
  final TextEditingController? controller;  // Controlador opcional para manejar el texto del campo
  final String? Function(String?)? validator;  // Funcion de validacion opcional para formularios
  final bool isPassword;  // Si es true, oculta el texto como campo de contrasena
  final TextInputType keyboardType;  // Tipo de teclado a mostrar (texto, numero, email, etc.)

  /// ═══ MÉTODO: Constructor de NeonTextField ═══
  /// Inicializa el campo de texto neon con todos sus parametros
  const NeonTextField({
    super.key,  // Clave del widget para identificacion en el arbol
    required this.label,  // Parametro obligatorio: etiqueta del campo
    required this.hintText,  // Parametro obligatorio: texto de sugerencia
    this.controller,  // Controlador opcional del texto
    this.validator,  // Funcion de validacion opcional
    this.isPassword = false,  // Por defecto no oculta el texto
    this.keyboardType = TextInputType.text,  // Por defecto teclado de texto normal
  });

  @override
  Widget build(BuildContext context) {  // Construye la interfaz visual del campo de texto
    const Color cian = Color(0xFF00FFFF);  // Color cyan neon para bordes, etiqueta y cursor

    return Column(  // Columna vertical para organizar etiqueta y campo
      crossAxisAlignment: CrossAxisAlignment.start,  // Alineacion horizontal: inicio (izquierda)
      children: [  // Lista de widgets hijos
        Text(  // Widget de texto para la etiqueta
          label,  // Texto de la etiqueta desde el widget
          style: GoogleFonts.roboto(  // Estilo de fuente: Roboto
            color: cian,  // Color cyan neon
            fontSize: 14,  // Tamano de fuente: 14
            fontWeight: FontWeight.bold,  // Peso de fuente: negrita
          ),
        ),
        const SizedBox(height: 8),  // Espacio vertical de 8px entre etiqueta y campo
        TextFormField(  // Campo de texto con soporte de validacion para formularios
          controller: controller,  // Controlador del texto
          obscureText: isPassword,  // Modo de texto oculto para contrasenas
          keyboardType: keyboardType,  // Tipo de teclado definido
          validator: validator,  // Funcion de validacion si se proporciono
          cursorColor: cian,  // Color del cursor: cyan neon
          style: GoogleFonts.sourceCodePro(color: Colors.white, fontSize: 14),  // Estilo del texto: Source Code Pro, blanco, tamano 14
          decoration: InputDecoration(  // Decoracion del campo de texto
            hintText: hintText,  // Texto de sugerencia
            hintStyle: GoogleFonts.sourceCodePro(  // Estilo del texto de sugerencia
              color: Colors.grey,  // Color gris para el hint
              fontSize: 12,  // Tamano de fuente del hint: 12
            ),
            filled: true,  // Habilita el color de fondo
            fillColor: Colors.black,  // Color de fondo: negro
            contentPadding: const EdgeInsets.symmetric(  // Relleno interno del campo
              horizontal: 16,  // Relleno horizontal: 16px
              vertical: 14,  // Relleno vertical: 14px
            ),
            enabledBorder: const OutlineInputBorder(  // Borde cuando el campo esta habilitado pero no enfocado
              borderRadius: BorderRadius.zero,  // Sin redondeo de esquinas (esquinas cuadradas)
              borderSide: BorderSide(color: cian, width: 1.5),  // Borde cyan neon, grosor 1.5
            ),
            focusedBorder: const OutlineInputBorder(  // Borde cuando el campo tiene foco (seleccionado)
              borderRadius: BorderRadius.zero,  // Sin redondeo de esquinas (esquinas cuadradas)
              borderSide: BorderSide(color: cian, width: 1.5),  // Borde cyan neon, grosor 1.5
            ),
            errorBorder: const OutlineInputBorder(  // Borde cuando hay error de validacion
              borderRadius: BorderRadius.zero,  // Sin redondeo de esquinas (esquinas cuadradas)
              borderSide: BorderSide(color: Colors.red, width: 1.5),  // Borde rojo, grosor 1.5
            ),
            focusedErrorBorder: const OutlineInputBorder(  // Borde cuando hay error y el campo tiene foco
              borderRadius: BorderRadius.zero,  // Sin redondeo de esquinas (esquinas cuadradas)
              borderSide: BorderSide(color: Colors.red, width: 1.5),  // Borde rojo, grosor 1.5
            ),
            errorStyle: const TextStyle(color: Colors.red, fontSize: 10),  // Estilo del texto de error: rojo, tamano 10
          ),
        ),
      ],
    );
  }
}
