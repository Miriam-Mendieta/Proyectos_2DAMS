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
import 'package:flutter/material.dart';  // Importa el paquete principal de Flutter para construir la UI
import 'package:flutter/services.dart';  // Importa servicios de Flutter como SystemChannels para entrada de teclado
import '../models/exercise.dart';  // Importa el modelo Exercise que define la estructura de los ejercicios

/// ═══ CLASE: FillInTheBlankWidget ═══
/// Widget de estado público que presenta un ejercicio de completar espacios en blanco.
/// El usuario debe escribir la respuesta correcta en un campo de texto.
class FillInTheBlankWidget extends StatefulWidget {
  final Exercise exercise;  // Objeto Exercise que contiene la pregunta, respuesta correcta y explicación
  final ValueChanged<bool> onAnswerSubmitted;  // Callback para notificar al padre si la respuesta fue correcta

  /// Constructor del widget, requiere exercise y onAnswerSubmitted como parámetros obligatorios
  const FillInTheBlankWidget({
    Key? key,  // Clave opcional para identificación del widget en el árbol
    required this.exercise,  // Ejercicio de completar espacio en blanco a renderizar
    required this.onAnswerSubmitted,  // Función callback que recibe true/false según corrección
  }) : super(key: key);  // Pasa la clave al constructor padre

  @override
  State<FillInTheBlankWidget> createState() => _FillInTheBlankWidgetState();  // Crea el estado mutable asociado
}

/// ═══ CLASE: _FillInTheBlankWidgetState ═══
/// Estado privado del FillInTheBlankWidget que maneja la entrada de texto, envío y visualización de resultados.
class _FillInTheBlankWidgetState extends State<FillInTheBlankWidget> {
  final TextEditingController _answerController = TextEditingController();  // Controlador para gestionar el texto del campo de entrada
  bool _showExplanation = false;  // Controla si se muestra la explicación después de enviar
  bool _answerSubmitted = false;  // Indica si el usuario ya envió su respuesta

  /// ═══ MÉTODO: dispose ═══
  /// Libera los recursos del TextEditingController cuando el widget se destruye.
  @override
  void dispose() {  // Sobreescribe el método de limpieza del ciclo de vida
    _answerController.dispose();  // Libera el controlador de texto para evitar memory leaks
    super.dispose();  // Llama al dispose de la clase padre
  }

  /// ═══ MÉTODO: _submitAnswer ═══
  /// Procesa la respuesta escrita, verifica si es correcta (comparación case-insensitive) y actualiza el estado.
  void _submitAnswer() {
    if (_answerController.text.trim().isEmpty || _answerSubmitted) return;  // Sale temprano si el campo está vacío o ya se envió
    setState(() {  // Inicia actualización del estado para reconstruir el widget
      _answerSubmitted = true;  // Marca que la respuesta fue enviada
      final isCorrect =  // Determina si la respuesta es correcta
          _answerController.text.trim().toLowerCase() ==  // Compara el texto del usuario en minúsculas y sin espacios extra
          widget.exercise.correctAnswer.trim().toLowerCase();  // Con la respuesta correcta también normalizada
      widget.onAnswerSubmitted(isCorrect);  // Notifica al padre si la respuesta es correcta o no
      if (widget.exercise.defaultExplanation != null) {  // Verifica si existe una explicación predeterminada
        _showExplanation = true;  // Activa la visualización de la explicación
      }
    });
  }

  @override
  Widget build(BuildContext context) {  // Método de construcción del árbol de widgets
    return Padding(  // Agrega margen alrededor del contenido
      padding: const EdgeInsets.all(16.0),  // Padding de 16 píxeles en todos los lados
      child: Column(  // Disposición vertical de los elementos
        crossAxisAlignment: CrossAxisAlignment.start,  // Alinea los hijos al inicio horizontal
        children: [  // Lista de widgets hijos
          // ═══ SECCIÓN: Pregunta ═══
          // Pregunta
          Text(  // Widget de texto para mostrar la pregunta
            widget.exercise.question,  // Obtiene el texto de la pregunta del modelo Exercise
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),  // Aplica estilo de título grande y negrita
          ),
          // ═══ SECCIÓN: Fragmento de código (opcional) ═══
          // CodeSnippet (si existe)
          if (widget.exercise.codeSnippet != null &&  // Verifica si existe un fragmento de código
              widget.exercise.codeSnippet!.isNotEmpty) ...[  // Verifica que no esté vacío y usa spread operator
            const SizedBox(height: 16),  // Espacio vertical de 16 píxeles antes del código
            Container(  // Contenedor para el bloque de código con estilo personalizado
              width: double.infinity,  // Ancho completo del padre
              padding: const EdgeInsets.all(12),  // Padding interno de 12 píxeles
              decoration: BoxDecoration(  // Definición de decoración visual
                color: const Color(0xFF1E1E1E),  // Color de fondo oscuro estilo editor de código
                borderRadius: BorderRadius.circular(8),  // Bordes redondeados de 8 píxeles
                border: Border.all(color: Colors.grey.shade700),  // Borde gris oscuro
              ),
              child: Text(  // Widget de texto para mostrar el código
                widget.exercise.codeSnippet!,  // Obtiene el fragmento de código del ejercicio
                style: const TextStyle(  // Estilo de texto para código
                  fontFamily: 'FiraCode',  // Fuente monoespaciada para código
                  fontSize: 13,  // Tamaño de fuente de 13 píxeles
                  color: Colors.greenAccent,  // Color verde brillante estilo terminal
                  height: 1.4,  // Altura de línea de 1.4 para legibilidad
                ),
              ),
            ),
          ],
          const SizedBox(height: 20),  // Espacio vertical de 20 píxeles antes del campo de texto
          // ═══ SECCIÓN: Campo de entrada de respuesta ═══
          TextField(  // Widget de campo de texto editable
            controller: _answerController,  // Asocia el controlador para gestionar el texto
            enabled: !_answerSubmitted,  // Deshabilita el campo si ya se envió la respuesta
            decoration: InputDecoration(  // Decoración visual del campo de texto
              hintText: 'Escribe tu respuesta aquí',  // Texto de sugerencia cuando el campo está vacío
              border: OutlineInputBorder(  // Borde rectangular con esquinas redondeadas
                borderRadius: BorderRadius.circular(8.0),  // Bordes redondeados de 8 píxeles
              ),
              filled: true,  // Activa el color de relleno del fondo
              fillColor: _answerSubmitted ? Colors.grey.shade200 : Colors.white,  // Fondo gris si está enviado, blanco si no
            ),
            style: TextStyle(  // Estilo del texto ingresado
              color: _answerSubmitted ? Colors.grey.shade600 : Colors.black87,  // Texto gris si está enviado, negro si no
              fontWeight: _answerSubmitted  // Peso de fuente
                  ? FontWeight.bold  // Negrita si ya fue enviado
                  : FontWeight.normal,  // Normal si aún no se envía
            ),
            onSubmitted: (_) => _submitAnswer(), // Manejo de tecla Enter (invoca _submitAnswer al presionar Enter)
          ),
          const SizedBox(height: 20),  // Espacio vertical de 20 píxeles antes del botón
          // ═══ SECCIÓN: Botón de enviar ═══
          if (!_answerSubmitted)  // Solo muestra el botón si aún no se envió respuesta
            Center(  // Centra el botón horizontalmente
              child: ElevatedButton(  // Botón elevado con estilo Material
                onPressed: _answerController.text.trim().isEmpty  // Habilita solo si hay texto escrito
                    ? null  // Deshabilitado si el campo está vacío
                    : _submitAnswer,  // Habilitado, ejecuta _submitAnswer
                child: const Text('Enviar Respuesta'),  // Texto del botón
              ),
            ),
          // ═══ SECCIÓN: Resultado correcto/incorrecto ═══
          if (_answerSubmitted)  // Muestra el resultado solo después de enviar
            Center(  // Centra el texto de resultado
              child: Text(  // Widget de texto para mostrar el veredicto
                _answerController.text.trim().toLowerCase() ==  // Compara la respuesta del usuario normalizada
                        widget.exercise.correctAnswer.trim().toLowerCase()  // Con la respuesta correcta normalizada
                    ? '¡Correcto!'  // Muestra "¡Correcto!" si coincide
                    : 'Incorrecto',  // Muestra "Incorrecto" si no coincide
                style: TextStyle(  // Estilo del texto de resultado
                  color:  // Color según si es correcto o no
                      _answerController.text.trim().toLowerCase() ==  // Vuelve a comparar para determinar color
                          widget.exercise.correctAnswer.trim().toLowerCase()
                      ? Colors.green.shade800  // Verde oscuro si es correcto
                      : Colors.red.shade800,  // Rojo oscuro si es incorrecto
                  fontWeight: FontWeight.bold,  // Negrita
                  fontSize: 18,  // Tamaño de fuente de 18 píxeles
                ),
              ),
            ),
          // ═══ SECCIÓN: Explicación post-envío ═══
          if (_showExplanation && widget.exercise.defaultExplanation != null)  // Muestra explicación si existe y está activada
            Column(  // Disposición vertical para la sección de explicación
              crossAxisAlignment: CrossAxisAlignment.start,  // Alinea al inicio horizontal
              children: [  // Lista de widgets hijos
                const SizedBox(height: 20),  // Espacio vertical de 20 píxeles antes de la explicación
                Text(  // Título de la sección
                  'Explicación:',  // Texto del título
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(  // Estilo de título mediano
                    fontWeight: FontWeight.bold,  // Negrita
                  ),
                ),
                const SizedBox(height: 8),  // Espacio vertical de 8 píxeles
                Text(widget.exercise.defaultExplanation!),  // Texto de la explicación del ejercicio
              ],
            ),
          // ═══ SECCIÓN: Espacio cuando no hay explicación ═══
          if (_answerSubmitted &&  // Si ya se envió la respuesta
              !_showExplanation &&  // Y no se muestra explicación
              widget.exercise.defaultExplanation == null)  // Y no hay explicación definida
            const SizedBox(height: 20),  // Espacio vertical de reserva de 20 píxeles
        ],
      ),
    );
  }
}
