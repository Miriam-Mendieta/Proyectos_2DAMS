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
import '../models/exercise.dart';  // Importa el modelo Exercise que define la estructura de los ejercicios

/// ═══ CLASE: CodingWidget ═══
/// Widget de estado público que presenta un ejercicio de escritura de código.
/// El usuario debe escribir código en un área de texto multilínea.
// Widget para preguntas de escribir código
class CodingWidget extends StatefulWidget {
  final Exercise exercise;  // Objeto Exercise que contiene la pregunta, código correcto y explicación
  final ValueChanged<bool> onAnswerSubmitted;  // Callback para notificar al padre si la respuesta fue correcta

  /// Constructor del widget, requiere exercise y onAnswerSubmitted como parámetros obligatorios
  const CodingWidget({
    Key? key,  // Clave opcional para identificación del widget en el árbol
    required this.exercise,  // Ejercicio de escritura de código a renderizar
    required this.onAnswerSubmitted,  // Función callback que recibe true/false según corrección
  }) : super(key: key);  // Pasa la clave al constructor padre

  @override
  State<CodingWidget> createState() => _CodingWidgetState();  // Crea el estado mutable asociado
}

/// ═══ CLASE: _CodingWidgetState ═══
/// Estado privado del CodingWidget que maneja la entrada de código, envío y visualización de resultados.
class _CodingWidgetState extends State<CodingWidget> {
  final TextEditingController _codeController = TextEditingController();  // Controlador para gestionar el texto del área de código
  bool _showExplanation = false;  // Controla si se muestra la explicación después de enviar
  bool _answerSubmitted = false;  // Indica si el usuario ya envió su respuesta

  /// ═══ MÉTODO: dispose ═══
  /// Libera los recursos del TextEditingController cuando el widget se destruye.
  @override
  void dispose() {  // Sobreescribe el método de limpieza del ciclo de vida
    _codeController.dispose();  // Libera el controlador de texto para evitar memory leaks
    super.dispose();  // Llama al dispose de la clase padre
  }

  /// ═══ MÉTODO: _submitAnswer ═══
  /// Procesa el código escrito, verifica si coincide con el correcto (ignorando espacios) y actualiza el estado.
  void _submitAnswer() {
    if (_codeController.text.trim().isEmpty || _answerSubmitted) return;  // Sale temprano si el campo está vacío o ya se envió
    setState(() {  // Inicia actualización del estado para reconstruir el widget
      _answerSubmitted = true;  // Marca que la respuesta fue enviada
      final userCode = _codeController.text.trim();  // Obtiene el código del usuario sin espacios extremos
      final correctCode = widget.exercise.correctAnswer.trim();  // Obtiene el código correcto sin espacios extremos
      final isCorrect =  // Determina si el código es correcto
          userCode == correctCode ||  // Compara exacta primero
          userCode.replaceAll(' ', '') == correctCode.replaceAll(' ', '');  // Compara ignorando todos los espacios internos
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
          Text(  // Widget de texto para mostrar la pregunta
            widget.exercise.question,  // Obtiene el texto de la pregunta del modelo Exercise
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),  // Aplica estilo de título grande y negrita
          ),
          const SizedBox(height: 20),  // Espacio vertical de 20 píxeles antes del editor de código
          // ═══ SECCIÓN: Editor de código ═══
          Container(  // Contenedor que envuelve el campo de texto con estilo de editor
            padding: const EdgeInsets.all(12.0),  // Padding interno de 12 píxeles
            decoration: BoxDecoration(  // Definición de decoración visual
              color: Colors.grey.shade900,  // Color de fondo gris muy oscuro estilo editor
              borderRadius: BorderRadius.circular(8.0),  // Bordes redondeados de 8 píxeles
              border: Border.all(color: Colors.grey.shade700),  // Borde gris oscuro
            ),
            child: TextField(  // Widget de campo de texto multilinea para escribir código
              controller: _codeController,  // Asocia el controlador para gestionar el texto
              maxLines: 10,  // Máximo de 10 líneas visibles
              minLines: 8,  // Mínimo de 8 líneas visibles
              style: const TextStyle(  // Estilo del texto del código
                fontFamily: 'monospace',  // Fuente monoespaciada para código
                fontSize: 14.0,  // Tamaño de fuente de 14 píxeles
                color: Colors.white,  // Color de texto blanco para contraste con fondo oscuro
              ),
              decoration: const InputDecoration(  // Decoración interna del campo
                border: InputBorder.none,  // Sin borde interno (el contenedor padre ya tiene borde)
                hintText: 'Escribe tu código aquí...',  // Texto de sugerencia cuando está vacío
                hintStyle: TextStyle(color: Colors.white54),  // Texto de sugerencia blanco semitransparente
              ),
              onSubmitted: (_) => _submitAnswer(), // Manejo de tecla Enter (invoca _submitAnswer al presionar Enter)
            ),
          ),
          const SizedBox(height: 20),  // Espacio vertical de 20 píxeles antes del botón
          // ═══ SECCIÓN: Botón de ejecutar ═══
          if (!_answerSubmitted)  // Solo muestra el botón si aún no se envió respuesta
            Center(  // Centra el botón horizontalmente
              child: ElevatedButton(  // Botón elevado con estilo Material
                onPressed: _codeController.text.trim().isEmpty  // Habilita solo si hay texto escrito
                    ? null  // Deshabilitado si el campo está vacío
                    : _submitAnswer,  // Habilitado, ejecuta _submitAnswer
                child: const Text('Ejecutar Código'),  // Texto del botón
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
