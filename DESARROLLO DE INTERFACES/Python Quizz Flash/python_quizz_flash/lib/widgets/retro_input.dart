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
import 'package:google_fonts/google_fonts.dart';  // Importa Google Fonts para usar fuentes personalizadas (PressStart2P, FiraCode)
import '../theme/app_theme.dart';  // Importa el tema de la aplicacion para acceder a colores y estilos globales

/// ═══ CLASE: RetroInput ═══
/// Campo de entrada de texto estilo terminal con cursor parpadeante.
/// Simula una consola de comandos con el prefijo '> ' y animacion de cursor.
class RetroInput extends StatefulWidget {  // Extiende StatefulWidget para manejar la animacion del cursor
  final String label;  // Etiqueta que se muestra encima del campo de entrada
  final String hint;  // Texto de sugerencia dentro del campo
  final bool obscureText;  // Si es true, oculta el texto (para contrasenas)
  final TextEditingController? controller;  // Controlador opcional para manejar el texto del campo

  /// ═══ MÉTODO: Constructor de RetroInput ═══
  /// Inicializa el campo de entrada retro con sus parametros
  const RetroInput({
    super.key,  // Clave del widget para identificacion en el arbol
    required this.label,  // Parametro obligatorio: etiqueta del campo
    this.hint = '',  // Texto de sugerencia por defecto: vacio
    this.obscureText = false,  // Por defecto no oculta el texto
    this.controller,  // Controlador opcional del texto
  });

  @override
  State<RetroInput> createState() => _RetroInputState();  // Crea el estado asociado al widget
}

/// ═══ CLASE: _RetroInputState ═══
/// Estado interno del RetroInput que maneja la animacion de parpadeo del cursor
class _RetroInputState extends State<RetroInput>
    with SingleTickerProviderStateMixin {  //Mixin para proveer un solo Ticker de animacion
  late AnimationController _cursorController;  // Controlador de la animacion del cursor (inicializacion tardia)
  bool _showCursor = true;  // Indica si el cursor debe ser visible en este momento

  @override
  void initState() {  // Metodo llamado cuando se inicializa el estado
    super.initState();  // Llama al initState de la clase padre
    _cursorController = AnimationController(  // Crea el controlador de animacion
      vsync: this,  // Sincroniza con el refresh rate de la pantalla para eficiencia
      duration: const Duration(milliseconds: 500),  // Duracion de cada ciclo de parpadeo: 500ms
    )..addStatusListener((status) {  // Agrega un listener para los cambios de estado de la animacion
      if (status == AnimationStatus.completed) {  // Si la animacion llego a su fin (completada)
        setState(() => _showCursor = !_showCursor);  // Inverte la visibilidad del cursor
        _cursorController.reverse();  // Revierte la animacion para el siguiente ciclo
      } else if (status == AnimationStatus.dismissed) {  // Si la animacion se descarto (volvio al inicio)
        _cursorController.forward();  // Avanza la animacion nuevamente
      }
    });
    _cursorController.forward();  // Inicia la animacion hacia adelante
  }

  @override
  void dispose() {  // Metodo llamado cuando se destruye el widget
    _cursorController.dispose();  // Libera los recursos del controlador de animacion
    super.dispose();  // Llama al dispose de la clase padre
  }

  @override
  Widget build(BuildContext context) {  // Construye la interfaz visual del campo de entrada
    return Column(  // Columna vertical para organizar etiqueta y campo
      crossAxisAlignment: CrossAxisAlignment.start,  // Alineacion horizontal: inicio (izquierda)
      children: [  // Lista de widgets hijos
        Text(  // Widget de texto para la etiqueta
          widget.label,  // Texto de la etiqueta desde el widget
          style: GoogleFonts.pressStart2p(  // Estilo de fuente: Press Start 2P (pixel art)
            color: AppTheme.primaryCyan,  // Color cyan primario del tema
            fontSize: 10,  // Tamano de fuente: 10
          ),
        ),
        const SizedBox(height: 8),  // Espacio vertical de 8px entre etiqueta y campo
        Container(  // Contenedor que simula la consola de terminal
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),  // Relleno: 12px horizontal, 4px vertical
          decoration: BoxDecoration(  // Decoracion del contenedor
            color: Colors.black,  // Fondo negro estilo terminal
            border: Border.all(color: AppTheme.borderBlue, width: 2),  // Borde azul, grosor 2
          ),
          child: Row(  // Fila horizontal para el prompt, campo de texto y cursor
            children: [  // Lista de widgets hijos
              const Text(  // Texto fijo del prompt de terminal
                '> ',  // Prefijo de consola estilo terminal
                style: TextStyle(  // Estilo del prompt
                  color: AppTheme.neonGreen,  // Color verde neon
                  fontFamily: 'Fira Code',  // Fuente monoespaciada Fira Code
                ),
              ),
              Expanded(  // Widget que expande el TextField para ocupar espacio disponible
                child: TextField(  // Campo de entrada de texto editable
                  controller: widget.controller,  // Controlador del texto
                  obscureText: widget.obscureText,  // Modo de texto oculto para contrasenas
                  style: GoogleFonts.firaCode(  // Estilo de fuente: Fira Code
                    color: AppTheme.neonGreen,  // Color verde neon
                    fontSize: 14,  // Tamano de fuente: 14
                  ),
                  decoration: InputDecoration(  // Decoracion interna del TextField
                    hintText: widget.hint,  // Texto de sugerencia
                    hintStyle: TextStyle(  // Estilo del texto de sugerencia
                      color: AppTheme.consoleGrey.withValues(alpha: 0.5),  // Gris consola con 50% opacidad
                    ),
                    border: InputBorder.none,  // Sin borde interno (el borde esta en el Container externo)
                    isDense: true,  // Reduce el padding interno para un look mas compacto
                  ),
                ),
              ),
              if (_showCursor)  // Condicional: solo muestra el cursor si _showCursor es true
                Container(width: 8, height: 18, color: AppTheme.neonGreen),  // Rectangulo verde que simula el cursor parpadeante
            ],
          ),
        ),
      ],
    );
  }
}
