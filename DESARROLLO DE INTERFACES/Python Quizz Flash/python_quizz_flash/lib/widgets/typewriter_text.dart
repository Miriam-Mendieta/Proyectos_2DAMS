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
import 'dart:async';  // Librería para Timer y utilidades asíncronas
import 'package:flutter/material.dart';  // Librería base de Flutter para widgets Material Design

// ═══ CLASE: TypewriterText ═══
/// Widget que anima el texto apareciendo letra por letra como en una terminal antigua.
class TypewriterText extends StatefulWidget {  // Widget con estado para animación de escritura
  final String text;  // Texto completo que se mostrará con efecto typewriter
  final TextStyle? style;  // Estilo opcional del texto
  final Duration speed;  // Velocidad entre cada carácter mostrado
  final VoidCallback? onComplete;  // Callback opcional al finalizar la animación

  const TypewriterText({  // Constructor con parámetros configurables
    super.key,  // Clave del widget
    required this.text,  // Texto requerido para animar
    this.style,  // Estilo opcional del texto
    this.speed = const Duration(milliseconds: 50),  // Velocidad por defecto: 50ms por carácter
    this.onComplete,  // Callback opcional al completar
  });

  @override
  State<TypewriterText> createState() => _TypewriterTextState();  // Crea el estado del widget
}

// ═══ CLASE: _TypewriterTextState ═══
/// Estado del widget TypewriterText que maneja la animación de escritura letra por letra
class _TypewriterTextState extends State<TypewriterText> {  // Estado para controlar la animación
  String _displayedText = '';  // Texto que se va mostrando progresivamente
  int _currentIndex = 0;  // Índice del próximo carácter a mostrar
  Timer? _timer;  // Temporizador para la animación periódica

  @override
  void initState() {  // Inicialización del estado y arranque de animación
    super.initState();  // Llama al initState de la clase padre
    _startTyping();  // Inicia la animación de escritura
  }

  // ═══ MÉTODO: _startTyping ═══
  /// Inicia el temporizador que agrega caracteres uno a uno al texto visible
  void _startTyping() {  // Configura el Timer periódico para escribir letra por letra
    _timer = Timer.periodic(widget.speed, (timer) {  // Crea timer con la velocidad configurada
      if (_currentIndex < widget.text.length) {  // Verifica si quedan caracteres por mostrar
        setState(() {  // Actualiza el estado para reconstruir el widget
          _displayedText += widget.text[_currentIndex];  // Agrega el siguiente carácter al texto visible
          _currentIndex++;  // Incrementa el índice para el próximo carácter
        });
      } else {  // Se completó todo el texto
        _timer?.cancel();  // Cancela el temporizador
        if (widget.onComplete != null) widget.onComplete!();  // Ejecuta callback si existe
      }
    });
  }

  @override
  void dispose() {  // Limpieza de recursos al destruir el widget
    _timer?.cancel();  // Cancela el temporizador si aún está activo
    super.dispose();  // Llama al dispose de la clase padre
  }

  @override
  Widget build(BuildContext context) {  // Construye la interfaz del widget
    return Text(_displayedText, style: widget.style);  // Muestra el texto acumulado con el estilo dado
  }
}
