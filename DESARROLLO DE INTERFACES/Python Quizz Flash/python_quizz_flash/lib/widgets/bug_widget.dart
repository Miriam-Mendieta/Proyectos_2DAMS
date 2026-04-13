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
import '../models/exercise.dart';  // Modelo de datos para los ejercicios del quiz

// ═══ CLASE: BugWidget ═══
// Widget para preguntas de detectar bugs (encontrar el error en el código)
// Muestra un fragmento de código y opciones para identificar cuál contiene el error
class BugWidget extends StatefulWidget {  // StatefulWidget porque necesita manejar estado interno
  final Exercise exercise;  // ejercicio que contiene la pregunta, opciones y respuesta correcta
  final ValueChanged<bool> onAnswerSubmitted;  // callback que informa si la respuesta fue correcta

  const BugWidget({  // constructor con parámetros requeridos
    Key? key,  // clave opcional del widget
    required this.exercise,  // ejercicio obligatorio
    required this.onAnswerSubmitted,  // callback obligatorio
  }) : super(key: key);

  @override
  State<BugWidget> createState() => _BugWidgetState();  // ═══ MÉTODO: createState ═══
  // Crea el estado mutable asociado a este StatefulWidget
}

/// ═══ CLASE: _BugWidgetState ═══
/// Estado interno del BugWidget que gestiona la selección y verificación de respuestas
class _BugWidgetState extends State<BugWidget> {
  String? _selectedAnswer;  // respuesta seleccionada por el usuario (null si no eligió)
  bool _showExplanation = false;  // flag para mostrar u ocultar la explicación
  bool _answerSubmitted = false;  // flag que indica si el usuario ya envió su respuesta

  /// ═══ MÉTODO: _submitAnswer ═══
  /// Procesa la respuesta seleccionada y notifica el resultado al callback
  void _submitAnswer() {
    if (_selectedAnswer == null || _answerSubmitted) return;  // si no hay selección o ya respondió, sale
    setState(() {  // actualiza el estado del widget
      _answerSubmitted = true;  // marca como respuesta enviada
      final isCorrect = _selectedAnswer == widget.exercise.correctAnswer;  // compara con la respuesta correcta
      widget.onAnswerSubmitted(isCorrect);  // notifica al padre si fue correcto o no
      if (widget.exercise.defaultExplanation != null) {  // si hay explicación disponible
        _showExplanation = true;  // activa la visualización de la explicación
      }
    });
  }

  @override
  Widget build(BuildContext context) {  // ═══ MÉTODO: build ═══
    // Construye la UI del widget de bug con código, opciones y feedback visual
    // Asegurarse de que las opciones y la respuesta correcta existen
    if (widget.exercise.options == null || widget.exercise.options!.isEmpty) {  // ═══ SECCIÓN: validación de opciones ═══
      return const Center(  // si no hay opciones, muestra mensaje de error centrado
        child: Text('Error: No hay opciones para esta pregunta.'),  // texto de error
      );
    }

    final codeSnippet =  // obtiene el fragmento de código o un mensaje por defecto
        widget.exercise.codeSnippet ?? 'No hay código disponible.';  // fallback si no hay snippet

    return Padding(  // ═══ SECCIÓN: layout principal ═══
      padding: const EdgeInsets.all(16.0),  // padding uniforme de 16 píxeles
      child: Column(  // columna vertical para los elementos
        crossAxisAlignment: CrossAxisAlignment.start,  // alineación a la izquierda
        children: [  // ═══ SECCIÓN: pregunta ═══
          Text(  // texto de la pregunta
            widget.exercise.question,  // pregunta obtenida del ejercicio
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),  // estilo de título grande en negrita
          ),
          const SizedBox(height: 20),  // espacio de 20 píxeles
          // ═══ SECCIÓN: fragmento de código ═══
          Container(  // contenedor para el código con fondo estilizado
            padding: const EdgeInsets.all(12.0),  // padding interno de 12 píxeles
            decoration: BoxDecoration(  // decoración del contenedor de código
              color: Colors.grey.shade100,  // fondo gris claro
              borderRadius: BorderRadius.circular(8.0),  // esquinas redondeadas de 8 píxeles
              border: Border.all(color: Colors.grey.shade300),  // borde gris suave
            ),
            child: Text(  // texto del código
              codeSnippet,  // fragmento de código a mostrar
              style: const TextStyle(  // estilo monoespaciado para código
                fontFamily: 'monospace',  // fuente monoespaciada
                fontSize: 14.0,  // tamaño de 14 píxeles
                color: Colors.black87,  // color negro con 87% opacidad
              ),
              softWrap: true,  // permite salto de línea automático
            ),
          ),
          const SizedBox(height: 20),  // espacio de 20 píxeles
          // ═══ SECCIÓN: lista de opciones ═══
          ...widget.exercise.options!.map((option) {  // mapea cada opción a un widget interactivo
            final isCorrect = option == widget.exercise.correctAnswer;  // si esta opción es la correcta
            final isSelected = option == _selectedAnswer;  // si esta opción fue seleccionada
            final bool isDisabled = _answerSubmitted;  // si las opciones están deshabilitadas (ya respondió)

            return Padding(  // contenedor con padding vertical para cada opción
              padding: const EdgeInsets.symmetric(vertical: 8.0),  // padding vertical de 8 píxeles
              child: InkWell(  // widget detectable a toques/clics
                onTap: isDisabled  // si está deshabilitado
                    ? null  // no hace nada
                    : () {  // ═══ SECCIÓN: selección de opción ═══
                        setState(() {  // actualiza el estado
                          _selectedAnswer = option;  // guarda la opción seleccionada
                        });
                      },
                child: Container(  // contenedor visual de la opción
                  padding: const EdgeInsets.all(12.0),  // padding interno de 12 píxeles
                  decoration: BoxDecoration(  // ═══ SECCIÓN: decoración condicional de la opción ═══
                    color: isDisabled  // color de fondo según estado
                        ? (isCorrect  // si ya respondió
                              ? Colors.green.withOpacity(0.3)  // la correcta: verde semitransparente
                              : (isSelected  // si no es correcta
                                    ? Colors.red.withOpacity(0.3)  // la seleccionada: rojo semitransparente
                                    : Colors.transparent))  // otras: transparente
                        : (isSelected  // si aún no respondió
                              ? Theme.of(context).primaryColor.withOpacity(0.2)  // seleccionada: color primario suave
                              : Colors.transparent),  // no seleccionada: transparente
                    border: Border.all(  // ═══ SECCIÓN: borde condicional ═══
                      color: isDisabled  // color del borde según estado
                          ? (isCorrect  // si ya respondió
                                ? Colors.green  // la correcta: verde
                                : (isSelected  // si no es correcta
                                      ? Colors.red  // la seleccionada: rojo
                                      : Colors.grey.shade400))  // otras: gris
                          : (isSelected  // si aún no respondió
                                ? Theme.of(context).primaryColor  // seleccionada: color primario
                                : Colors.grey.shade400),  // no seleccionada: gris
                      width: 1.5,  // grosor del borde de 1.5 píxeles
                    ),
                    borderRadius: BorderRadius.circular(8.0),  // esquinas redondeadas de 8 píxeles
                  ),
                  child: Row(  // fila horizontal para texto e ícono
                    children: [  // ═══ SECCIÓN: texto de la opción ═══
                      Expanded(  // ocupa el espacio disponible
                        child: Text(  // texto de la opción
                          option,  // contenido de la opción
                          style: TextStyle(  // estilo condicional del texto
                            color: isDisabled  // color según estado
                                ? (isCorrect  // si ya respondió
                                      ? Colors.green.shade800  // la correcta: verde oscuro
                                      : (isSelected  // si no es correcta
                                            ? Colors.red.shade800  // la seleccionada: rojo oscuro
                                            : Colors.black87))  // otras: negro
                                : Colors.black87,  // si no respondió: negro
                            fontWeight: isDisabled  // peso de fuente según estado
                                ? (isCorrect  // si ya respondió
                                      ? FontWeight.bold  // la correcta: negrita
                                      : (isSelected  // si no es correcta
                                            ? FontWeight.bold  // la seleccionada: negrita
                                            : FontWeight.normal))  // otras: normal
                                : (isSelected  // si aún no respondió
                                      ? FontWeight.bold  // seleccionada: negrita
                                      : FontWeight.normal),  // no seleccionada: normal
                          ),
                        ),
                      ),
                      // ═══ SECCIÓN: ícono de feedback ═══
                      if (isDisabled)  // solo muestra ícono después de responder
                        Icon(  // ícono de check o cancel
                          isCorrect  // si es la respuesta correcta
                              ? Icons.check_circle_outline  // ícono de check circular
                              : Icons.cancel_outlined,  // ícono de cancel circular
                          color: isCorrect  // color del ícono
                              ? Colors.green.shade800  // correcto: verde oscuro
                              : Colors.red.shade800,  // incorrecto: rojo oscuro
                        ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),  // convierte el iterable mapeado en lista de widgets
          const SizedBox(height: 20),  // espacio de 20 píxeles
          // ═══ SECCIÓN: botón de enviar respuesta ═══
          if (!_answerSubmitted)  // solo muestra el botón si aún no respondió
            Center(  // centrado horizontal
              child: ElevatedButton(  // botón elevado estándar
                onPressed: _selectedAnswer == null ? null : _submitAnswer,  // habilitado solo si hay selección
                child: const Text('Identificar Error'),  // texto del botón
              ),
            ),
          // ═══ SECCIÓN: explicación después de responder ═══
          if (_showExplanation && widget.exercise.defaultExplanation != null)  // si hay explicación y debe mostrarse
            Column(  // columna para la sección de explicación
              crossAxisAlignment: CrossAxisAlignment.start,  // alineación izquierda
              children: [
                const SizedBox(height: 20),  // espacio superior de 20 píxeles
                Text(  // título de la explicación
                  'Explicación:',  // etiqueta
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(  // estilo de título mediano
                    fontWeight: FontWeight.bold,  // en negrita
                  ),
                ),
                const SizedBox(height: 8),  // espacio de 8 píxeles
                Text(widget.exercise.defaultExplanation!),  // texto de la explicación del ejercicio
              ],
            ),
          // ═══ SECCIÓN: espacio condicional final ═══
          if (_answerSubmitted &&  // si ya respondió
              !_showExplanation &&  // y no hay explicación visible
              widget.exercise.defaultExplanation == null)  // y no existe explicación
            const SizedBox(height: 20),  // espacio de reserva de 20 píxeles
        ],
      ),
    );
  }
}
