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
import 'dart:math';  // Librería para funciones matemáticas como Random
import 'package:flutter/material.dart';  // Librería base de Flutter para construir la UI
import 'package:google_fonts/google_fonts.dart';  // Paquete para fuentes retro y monoespaciadas
import 'package:go_router/go_router.dart';  // Paquete para navegación entre pantallas
import '../theme/app_theme.dart';  // Colores y tema global de la aplicación
import 'retro_button.dart';  // Widget de botón personalizado con estilo retro del sistema de diseño
import 'retro_container.dart';  // Widget de contenedor personalizado con estilo retro del sistema de diseño

/// ═══ CLASE: ChallengeDialog ═══
/// Diálogo interactivo para los retos rápidos de programación.
/// Presenta desafíos aleatorios de Python que el usuario debe resolver escribiendo la respuesta.
class ChallengeDialog extends StatefulWidget {  // StatefulWidget porque necesita estado mutable
  const ChallengeDialog({super.key});  // constructor sin parámetros adicionales

  @override
  State<ChallengeDialog> createState() => _ChallengeDialogState();  // ═══ MÉTODO: createState ═══
  // Crea el estado mutable asociado a este StatefulWidget
}

/// ═══ CLASE: _ChallengeDialogState ═══
/// Estado del diálogo de desafíos que gestiona la lógica del reto actual y la respuesta del usuario
class _ChallengeDialogState extends State<ChallengeDialog> {
  late Map<String, dynamic>
  _currentChallenge;  // ═══ SECCIÓN: variables de estado ═══
  // El reto seleccionado para esta sesión (se inicializa en initState)
  final TextEditingController _controller =
      TextEditingController();  // controlador del input de texto para la respuesta del usuario
  bool _isAnswered = false;  // indica si el usuario ya envió su respuesta
  bool _isCorrect = false;  // indica si la respuesta fue correcta

  // Lista de posibles retos rápidos
  final List<Map<String, dynamic>> _challenges = [  // ═══ SECCIÓN: lista de desafíos ═══
    {  // ═══ SECCIÓN: desafío de lógica - slicing de listas ═══
      "title": "DESAFÍO DE LÓGICA",  // título del reto
      "question":  // pregunta del reto
          "Escribe el comando corto (slicing) para invertir la lista L:",
      "correct": "L[::-1]",  // respuesta correcta: slicing inverso
      "explanation": "El slicing [::-1] recorre la lista de final a inicio.",  // explicación didáctica
    },
    {  // ═══ SECCIÓN: desafío de concisión - list comprehensions ═══
      "title": "DESAFÍO DE CONCISIÓN",  // título del reto
      "question":  // pregunta del reto
          "Escribe el inicio de una comprensión de lista para la variable 'x':",
      "correct": "[x for x",  // respuesta correcta: inicio de list comprehension
      "explanation":  // explicación didáctica
          "Las comprehensions empiezan definiendo el elemento seguido del bucle for.",
    },
    {  // ═══ SECCIÓN: desafío de memoria - importación de módulos ═══
      "title": "DESAFÍO DE MEMORIA",  // título del reto
      "question":  // pregunta del reto
          "¿Qué palabra falta para importar funciones específicas?: ___ math import sqrt",
      "correct": "from",  // respuesta correcta: keyword 'from'
      "explanation": "Se usa 'from' seguido del módulo y luego 'import'.",  // explicación didáctica
    },
    {  // ═══ SECCIÓN: desafío de sintaxis - diccionarios ═══
      "title": "DESAFÍO DE SINTAXIS",  // título del reto
      "question":  // pregunta del reto
          "Escribe el símbolo que falta en este diccionario: {'a': 1 ___ 'b': 2}",
      "correct": ",",  // respuesta correcta: coma separadora
      "explanation": "Los elementos de un diccionario se separan por comas.",  // explicación didáctica
    },
  ];

  @override
  void initState() {  // ═══ MÉTODO: initState ═══
    // Se ejecuta al crear el estado; selecciona un reto aleatorio
    super.initState();  // llama al initState de la clase padre
    // Seleccionamos un reto al azar al iniciar el diálogo
    _currentChallenge = _challenges[Random().nextInt(_challenges.length)];  // índice aleatorio de la lista
  }

  /// ═══ MÉTODO: _checkAnswer ═══
  /// Compara la respuesta del usuario con la solución correcta
  void _checkAnswer() {
    setState(() {  // actualiza el estado del widget
      _isAnswered = true;  // marca como respondido
      String userAns = _controller.text.trim().replaceAll(' ', '');  // limpia espacios de la respuesta del usuario
      String correctAns = _currentChallenge['correct'].toString().replaceAll(  // limpia espacios de la respuesta correcta
        ' ',  // reemplaza todos los espacios
        '',  // por cadena vacía
      );
      _isCorrect = userAns == correctAns || userAns.contains(correctAns);  // verifica si coincide o contiene la respuesta
    });
  }

  @override
  Widget build(BuildContext context) {  // ═══ MÉTODO: build ═══
    // Construye el diálogo con el desafío actual, input o resultado según estado
    return Dialog(  // widget de diálogo modal
      backgroundColor: Colors
          .transparent,  // fondo transparente para que luzca el RetroContainer
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),  // padding horizontal de 20 píxeles
      child: RetroContainer(  // contenedor con estilo retro cyberpunk
        isWin95: false,  // estilo Cyberpunk neón (no Windows 95)
        borderColor: AppTheme.primaryCyan,  // borde cian eléctrico
        padding: const EdgeInsets.all(25),  // padding uniforme de 25 píxeles
        showGlow: true,  // efecto de resplandor activo
        child: Column(  // ═══ SECCIÓN: contenido del diálogo ═══
          mainAxisSize: MainAxisSize.min,  // ocupa solo el espacio mínimo necesario
          children: [  // ═══ SECCIÓN: título del desafío ═══
            // Título del desafío con fuente pixelada
            Text(  // texto del título del reto
              ">>> ${_currentChallenge['title']} <<<",  // título rodeado por ">>>" y "<<<"
              style: GoogleFonts.pressStart2p(  // fuente pixelada estilo arcade
                color: AppTheme.primaryCyan,  // color cian del tema
                fontSize: 14,  // tamaño de 14 píxeles
              ),
            ),
            const SizedBox(height: 30),  // espacio de 30 píxeles
            // ═══ SECCIÓN: pregunta del reto ═══
            Text(  // texto de la pregunta
              _currentChallenge['question'],  // pregunta del desafío actual
              textAlign: TextAlign.center,  // texto centrado
              style: GoogleFonts.shareTechMono(  // fuente monoespaciada tecnológica
                color: Colors.white,  // color blanco
                fontSize: 16,  // tamaño de 16 píxeles
              ),
            ),
            const SizedBox(height: 30),  // espacio de 30 píxeles
            // ═══ SECCIÓN: estado antes de responder ═══
            if (!_isAnswered) ...[  // spread operator: muestra si NO se ha respondido
              // Input de texto estilo terminal para la respuesta
              TextField(  // campo de entrada de texto
                controller: _controller,  // vinculamos el controlador
                autofocus: true,  // enfoca automáticamente al abrir
                style: GoogleFonts.firaCode(color: Colors.greenAccent),  // fuente de código en verde
                decoration: InputDecoration(  // ═══ SECCIÓN: decoración del campo de texto ═══
                  filled: true,  // fondo relleno
                  fillColor: Colors.black,  // fondo negro estilo terminal
                  hintText: "escribe tu respuesta aquí...",  // texto de ayuda
                  hintStyle: const TextStyle(color: Colors.white24),  // hint semitransparente
                  border: OutlineInputBorder(  // borde con outline
                    borderSide: BorderSide(color: AppTheme.primaryCyan),  // borde color cian
                  ),
                ),
              ),
              const SizedBox(height: 30),  // espacio de 30 píxeles
              // Botón para validar la respuesta
              RetroButton(  // botón retro de validación
                text: "[ VALIDAR RETO ]",  // texto del botón entre corchetes
                height: 50,  // alto de 50 píxeles
                style: RetroButtonStyle.primary,  // estilo primario
                onPressed: _checkAnswer,  // ejecuta la verificación de respuesta
              ),
            ] else ...[  // ═══ SECCIÓN: estado después de responder ═══
              // Resultado visual tras responder
              Text(  // texto de resultado
                _isCorrect ? "¡DESAFÍO SUPERADO!" : "FALLO EN EL SISTEMA",  // mensaje según si acertó o no
                style: GoogleFonts.pressStart2p(  // fuente pixelada
                  color: _isCorrect ? AppTheme.neonGreen : AppTheme.neonRed,  // verde si acertó, rojo si falló
                  fontSize: 12,  // tamaño de 12 píxeles
                ),
              ),
              const SizedBox(height: 15),  // espacio de 15 píxeles
              // Explicación didáctica de la solución
              Text(  // texto de explicación
                _currentChallenge['explanation'],  // explicación del desafío
                textAlign: TextAlign.center,  // texto centrado
                style: GoogleFonts.shareTechMono(  // fuente monoespaciada
                  color: Colors.white70,  // blanco semitransparente
                  fontSize: 14,  // tamaño de 14 píxeles
                ),
              ),
              const SizedBox(height: 35),  // espacio de 35 píxeles
              // Botones de acción final (Reintentar o Avanzar)
              Row(  // fila horizontal para los botones
                mainAxisAlignment: MainAxisAlignment.center,  // centrados horizontalmente
                children: [  // ═══ SECCIÓN: botón REPETIR ═══
                  Expanded(  // ocupa espacio proporcional
                    child: RetroButton(  // botón de reintentar
                      text: "REPETIR",  // texto del botón
                      height: 45,  // alto de 45 píxeles
                      style: RetroButtonStyle.purple,  // estilo morado
                      onPressed: () => context.go('/quiz?difficulty=basic'),  // navega al quiz básico
                    ),
                  ),
                  const SizedBox(width: 15),  // espacio de 15 píxeles
                  // ═══ SECCIÓN: botón SIGUIENTE/VOLVER ═══
                  Expanded(  // ocupa espacio proporcional
                    child: RetroButton(  // botón condicional
                      text: _isCorrect ? "SIGUIENTE NIVEL" : "VOLVER",  // texto según resultado
                      height: 45,  // alto de 45 píxeles
                      style: _isCorrect  // estilo según resultado
                          ? RetroButtonStyle.primary  // si acertó: estilo primario
                          : RetroButtonStyle.danger,  // si falló: estilo danger
                      onPressed: () => context.go('/main_menu'),  // navega al menú principal
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
