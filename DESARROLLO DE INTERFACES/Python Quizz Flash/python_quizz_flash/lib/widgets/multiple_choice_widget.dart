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

/// ═══ CLASE: MultipleChoiceWidget ═══
/// Widget de estado público que presenta un ejercicio de opción múltiple.
/// Recibe un objeto Exercise y un callback para notificar si la respuesta fue correcta.
class MultipleChoiceWidget extends StatefulWidget {
  final Exercise exercise;  // Objeto Exercise que contiene la pregunta, opciones, respuesta correcta y explicación
  final ValueChanged<bool>
  onAnswerSubmitted; // Callback para notificar si la respuesta fue correcta

  /// Constructor del widget, requiere exercise y onAnswerSubmitted como parámetros obligatorios
  const MultipleChoiceWidget({
    Key? key,  // Clave opcional para identificación del widget en el árbol
    required this.exercise,  // Ejercicio de opción múltiple a renderizar
    required this.onAnswerSubmitted,  // Función callback que recibe true/false según corrección
  }) : super(key: key);  // Pasa la clave al constructor padre

  @override
  State<MultipleChoiceWidget> createState() => _MultipleChoiceWidgetState();  // Crea el estado mutable asociado
}

/// ═══ CLASE: _MultipleChoiceWidgetState ═══
/// Estado privado del MultipleChoiceWidget que maneja la selección, envío y visualización de resultados.
class _MultipleChoiceWidgetState extends State<MultipleChoiceWidget> {
  String? _selectedAnswer;  // Almacena la opción seleccionada por el usuario (null si ninguna)
  bool _showExplanation = false;  // Controla si se muestra la explicación después de enviar
  bool _answerSubmitted = false;  // Indica si el usuario ya envió su respuesta

  /// ═══ MÉTODO: _submitAnswer ═══
  /// Procesa la respuesta seleccionada, verifica si es correcta y actualiza el estado.
  void _submitAnswer() {
    if (_selectedAnswer == null || _answerSubmitted) return;  // Sale temprano si no hay selección o ya se envió
    setState(() {  // Inicia actualización del estado para reconstruir el widget
      _answerSubmitted = true;  // Marca que la respuesta fue enviada
      final isCorrect = _selectedAnswer == widget.exercise.correctAnswer;  // Compara la selección con la respuesta correcta
      widget.onAnswerSubmitted(isCorrect);  // Notifica al padre si la respuesta es correcta o no
      if (widget.exercise.defaultExplanation != null) {  // Verifica si existe una explicación predeterminada
        _showExplanation = true;  // Activa la visualización de la explicación
      }
    });
  }

  @override
  Widget build(BuildContext context) {  // Método de construcción del árbol de widgets
    // ═══ SECCIÓN: Validación de opciones ═══
    // Asegurarse de que las opciones y la respuesta correcta existen
    if (widget.exercise.options == null || widget.exercise.options!.isEmpty) {  // Comprueba que las opciones no sean nulas ni vacías
      return const Center(  // Retorna un widget centrado con mensaje de error
        child: Text('Error: No hay opciones para esta pregunta.'),  // Texto de error informativo
      );
    }

    // ═══ SECCIÓN: Layout principal ═══
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
          const SizedBox(height: 20),  // Espacio vertical de 20 píxeles antes de las opciones
          // ═══ SECCIÓN: Opciones de respuesta ═══
          // Opciones de respuesta
          ...widget.exercise.options!.map((option) {  // Itera sobre cada opción y genera un widget, usando spread
            final isCorrect = option == widget.exercise.correctAnswer;  // Determina si esta opción es la correcta
            final isSelected = option == _selectedAnswer;  // Determina si esta opción fue seleccionada por el usuario
            final bool isDisabled =
                _answerSubmitted; // Deshabilitar si ya se envió una respuesta

            return Padding(  // Padding vertical entre cada opción
              padding: const EdgeInsets.symmetric(vertical: 8.0),  // 8 píxeles arriba y abajo
              child: InkWell(  // Widget detectable a toques/clics
                onTap: isDisabled  // Si está deshabilitado
                    ? null  // No asigna acción (no clickable)
                    : () {  // Si está habilitado, define callback de tap
                        setState(() {  // Actualiza el estado para reflejar el cambio
                          _selectedAnswer = option;  // Guarda la opción seleccionada
                        });
                      },
                child: Container(  // Contenedor visual de la opción
                  padding: const EdgeInsets.all(12.0),  // Padding interno de 12 píxeles
                  decoration: BoxDecoration(  // Decoración del contenedor
                    color: isDisabled  // Si está deshabilitado (respuesta ya enviada)
                        ? (isCorrect  // Si esta opción es la correcta
                              ? Colors.green.withOpacity(0.3)  // Fondo verde semitransparente
                              : (isSelected  // Si no es correcta pero fue seleccionada
                                    ? Colors.red.withOpacity(0.3)  // Fondo rojo semitransparente
                                    : Colors.transparent))  // Si no, fondo transparente
                        : (isSelected  // Si no está deshabilitado pero está seleccionada
                              ? Theme.of(context).primaryColor.withOpacity(0.2)  // Fondo color primario semitransparente
                              : Colors.transparent),  // Si no está seleccionada, fondo transparente
                    border: Border.all(  // Definición del borde del contenedor
                      color: isDisabled  // Si está deshabilitado
                          ? (isCorrect  // Si es la opción correcta
                                ? Colors.green  // Borde verde
                                : (isSelected  // Si fue seleccionada pero incorrecta
                                      ? Colors.red  // Borde rojo
                                      : Colors.grey.shade400))  // Si no, borde gris
                          : (isSelected  // Si no está deshabilitado pero seleccionada
                                ? Theme.of(context).primaryColor  // Borde color primario
                                : Colors.grey.shade400),  // Si no, borde gris
                      width: 1.5,  // Grosor del borde de 1.5 píxeles
                    ),
                    borderRadius: BorderRadius.circular(8.0),  // Bordes redondeados de 8 píxeles
                  ),
                  child: Row(  // Disposición horizontal para texto e icono
                    children: [  // Lista de widgets hijos en fila
                      Expanded(  // Expande el texto para ocupar espacio disponible
                        child: Text(  // Widget de texto para la opción
                          option,  // Texto de la opción
                          style: TextStyle(  // Estilo del texto
                            color: isDisabled  // Si está deshabilitado
                                ? (isCorrect  // Si es la correcta
                                      ? Colors.green.shade800  // Texto verde oscuro
                                      : (isSelected  // Si fue seleccionada pero incorrecta
                                            ? Colors.red.shade800  // Texto rojo oscuro
                                            : Colors.black87))  // Si no, texto negro semiintenso
                                : Colors.black87,  // Si no está deshabilitado, texto negro semiintenso
                            fontWeight: isDisabled  // Si está deshabilitado
                                ? (isCorrect  // Si es la correcta
                                      ? FontWeight.bold  // Negrita
                                      : (isSelected  // Si fue seleccionada pero incorrecta
                                            ? FontWeight.bold  // Negrita
                                            : FontWeight.normal))  // Si no, peso normal
                                : (isSelected  // Si no está deshabilitado pero seleccionada
                                      ? FontWeight.bold  // Negrita
                                      : FontWeight.normal),  // Si no, peso normal
                          ),
                        ),
                      ),
                      // ═══ SECCIÓN: Indicador visual de correcto/incorrecto ═══
                      // Indicador visual de respuesta correcta/incorrecta si ya se ha enviado
                      if (isDisabled)  // Solo muestra el icono si la respuesta fue enviada
                        Icon(  // Widget de icono
                          isCorrect  // Si esta opción es la correcta
                              ? Icons.check_circle_outline  // Icono de círculo con check
                              : Icons.cancel_outlined,  // Icono de círculo con X
                          color: isCorrect  // Color según si es correcta o no
                              ? Colors.green.shade800  // Verde oscuro para correcta
                              : Colors.red.shade800,  // Rojo oscuro para incorrecta
                        ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),  // Convierte el Iterable de widgets en una lista
          const SizedBox(height: 20),  // Espacio vertical de 20 píxeles antes del botón
          // ═══ SECCIÓN: Botón de enviar ═══
          // Botón para enviar respuesta
          if (!_answerSubmitted)  // Solo muestra el botón si aún no se envió respuesta
            Center(  // Centra el botón horizontalmente
              child: ElevatedButton(  // Botón elevado con estilo Material
                onPressed: _selectedAnswer == null ? null : _submitAnswer,  // Habilita solo si hay una selección
                child: const Text('Enviar Respuesta'),  // Texto del botón
              ),
            ),
          // ═══ SECCIÓN: Explicación post-envío ═══
          // Sección de explicación
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
          // Mensaje si no hay explicación
          if (_answerSubmitted &&  // Si ya se envió la respuesta
              !_showExplanation &&  // Y no se muestra explicación
              widget.exercise.defaultExplanation == null)  // Y no hay explicación definida
            const SizedBox(height: 20),  // Espacio vertical de reserva de 20 píxeles
        ],
      ),
    );
  }
}

// ═══ NOTA ═══
// Nota: Necesitarás asegurar que el modelo `Exercise` tenga los campos `options` (List<String>),
// `correctAnswer` (String), y `defaultExplanation` (String?) definidos correctamente.
// También se asume que el modelo `Exercise` se encuentra en `lib/models/exercise.dart`.
