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
import 'dart:math';  // Importa la librería estándar de Dart para funciones matemáticas como Random
import 'package:flutter/material.dart';  // Importa el framework principal de Flutter para widgets UI
import 'package:flutter_riverpod/flutter_riverpod.dart';  // Importa Riverpod para gestión de estado reactivo
import 'package:google_fonts/google_fonts.dart';  // Importa Google Fonts para tipografías personalizadas
import 'package:go_router/go_router.dart';  // Importa GoRouter para navegación y enrutamiento
import 'package:cloud_firestore/cloud_firestore.dart';  // Importa Cloud Firestore para base de datos en la nube
import 'package:firebase_auth/firebase_auth.dart';  // Importa Firebase Auth para autenticación de usuarios
import '../models/exercise.dart';  // Importa el modelo Exercise que define la estructura de ejercicios
import '../providers/quiz_provider.dart';  // Importa el provider de quiz que gestiona el estado del cuestionario
import '../providers/economia_provider.dart';  // Importa EconomiaProvider para gestionar monedas y reset de economía
import '../theme/app_theme.dart';  // Importa el tema de la aplicación con colores y estilos predefinidos
import '../widgets/retro_button.dart';  // Importa el widget personalizado de botón retro
import '../widgets/retro_container.dart';  // Importa el widget personalizado de contenedor retro
import '../widgets/retro_progress_bar.dart';  // Importa el widget personalizado de barra de progreso retro
import '../widgets/pixel_clip_logo.dart';  // Importa el widget del logo pixelado de Clip
import '../widgets/app_footer.dart';  // Importa el widget del footer/pie de página de la app
import '../widgets/crt_overlay.dart';  // Importa el widget de overlay efecto CRT (monitor antiguo)

/// ═══ CLASE: QuizScreen ═══
/// Widget principal de la pantalla de quiz. Recibe la dificultad como parámetro
/// y observa el estado del quiz a través de Riverpod. Según el estado, muestra
/// la pantalla de carga, un error, o delega en _ErrorResultScreen, _SuccessResultScreen
/// o _QuizContent dependiendo de si el quiz terminó y si hubo muchos errores.
class QuizScreen extends ConsumerWidget {
  final Difficulty difficulty;  // Almacena el nivel de dificultad seleccionado para el quiz
  const QuizScreen({super.key, required this.difficulty});  // Constructor que requiere la dificultad

  @override
  Widget build(BuildContext context, WidgetRef ref) {  // Método build que construye la UI reactiva
    final quizAsync = ref.watch(quizProvider(difficulty));  // Observa el estado asíncrono del quiz según dificultad

    return quizAsync.when(  // Maneja los tres estados posibles del AsyncValue de Riverpod
      loading: () => const Scaffold(  // Estado de carga: muestra scaffold con spinner
        backgroundColor: AppTheme.darkBg,  // Fondo oscuro del tema
        body: Center(  // Centra el indicador de carga
          child: CircularProgressIndicator(color: AppTheme.primaryCyan),  // Spinner color cyan
        ),
      ),
      error: (err, stack) => Scaffold(  // Estado de error: muestra scaffold con mensaje de error
        backgroundColor: AppTheme.darkBg,  // Fondo oscuro del tema
        body: Center(  // Centra el mensaje de error
          child: Text(  // Texto que muestra el error del sistema
            'ERROR_SISTEMA: $err',  // Muestra el mensaje de error interpolado
            style: const TextStyle(color: AppTheme.neonRed),  // Estilo en rojo neón
          ),
        ),
      ),
      data: (quizState) {  // Estado exitoso: recibe los datos del quiz
        if (quizState.isQuizFinished) {  // Verifica si el quiz ha terminado
          if (quizState.errors >= 5) {  // Si hay 5 o más errores, muestra pantalla de fallo
            return _ErrorResultScreen(  // Pantalla de resultado con error
              difficulty: difficulty,  // Pasa la dificultad actual
              errors: quizState.errors,  // Pasa el número de errores cometidos
            );
          } else {  // Si hay menos de 5 errores, muestra pantalla de éxito
            return _SuccessResultScreen(difficulty: difficulty);  // Pantalla de resultado exitoso
          }
        }
        return _QuizContent(difficulty: difficulty, state: quizState);  // Si no terminó, muestra contenido del quiz
      },
    );
  }
}

/// ═══ CLASE: _QuizContent ═══
/// StatefulWidget privado que gestiona todo el contenido interactivo del quiz:
/// el editor de código, las preguntas de opción múltiple, las pistas,
/// las explicaciones, la barra de progreso y el asistente virtual.
/// Maneja el estado local del controlador de código y los mensajes aleatorios.
class _QuizContent extends ConsumerStatefulWidget {
  final Difficulty difficulty;  // Almacena el nivel de dificultad del quiz
  final QuizState state;  // Almacena el estado actual del quiz (ejercicios, índice, respuestas, etc.)
  const _QuizContent({required this.difficulty, required this.state});  // Constructor que requiere dificultad y estado

  @override
  ConsumerState<_QuizContent> createState() => _QuizContentState();  // Crea el estado asociado a este widget
}

/// ═══ CLASE: _QuizContentState ═══
/// Estado del _QuizContent. Gestiona el TextEditingController para inputs de código,
/// genera mensajes aleatorios de éxito/error, y construye toda la interfaz del quiz
/// incluyendo layout responsive, paneles IDE/Consola, opciones múltiples, y áreas de ayuda.
class _QuizContentState extends ConsumerState<_QuizContent> {
  late TextEditingController _codeController;  // Controlador tardío para el campo de entrada de código
  final Random _random = Random();  // Generador de números aleatorios para seleccionar mensajes

  final List<String> _successMessages = [  // Lista de mensajes motivacionales para respuestas correctas
    "¡BRUTAL! Tu lógica es impecable. ¡Sigue así! 🌟",  // Mensaje de éxito 1
    "¡BOOM! Código perfecto. ¡Eres una estrella de Python! 🚀",  // Mensaje de éxito 2
    "¡SISTEMA OPTIMIZADO! Tu cerebro es un procesador de alto nivel. 🧠",  // Mensaje de éxito 3
    "¡EXCELENTE! Has dominado este reto como un profesional. ✨",  // Mensaje de éxito 4
    "¡CÓDIGO LIMPIO! Tu eficiencia es inspiradora. 🔥",  // Mensaje de éxito 5
  ];

  final List<String> _errorMessages = [  // Lista de mensajes de ánimo para respuestas incorrectas
    "¡No te preocupes! Hasta los mejores hackers tienen glitches. 💪",  // Mensaje de error 1
    "¡Casi lo tienes! Un pequeño ajuste y será perfecto. 🛠️",  // Mensaje de error 2
    "¡BUEN INTENTO! Cada error es un bit de aprendizaje. 📊",  // Mensaje de error 3
    "¡GLITCH DETECTADO! Reinicia tu lógica y vuelve a la carga. 🔄",  // Mensaje de error 4
    "¡TRANQUILO! Analiza el código con calma, tú puedes. 🧭",  // Mensaje de error 5
  ];

  @override
  void initState() {  // Método llamado cuando se inicializa el widget
    super.initState();  // Llama al initState de la clase padre
    _codeController = TextEditingController();  // Inicializa el controlador de texto
    _updateController();  // Actualiza el contenido inicial del controlador
  }

  @override
  void didUpdateWidget(_QuizContent oldWidget) {  // Método llamado cuando el widget padre se reconstruye con nuevos parámetros
    super.didUpdateWidget(oldWidget);  // Llama al didUpdateWidget de la clase padre
    if (oldWidget.state.currentIndex != widget.state.currentIndex) {  // Verifica si cambió el índice del ejercicio actual
      _updateController();  // Actualiza el controlador si cambió el ejercicio
    }
  }

  void _updateController() {  // Método privado para actualizar el texto del controlador
    final exercise = widget.state.exercises[widget.state.currentIndex];  // Obtiene el ejercicio actual del estado
    if (exercise.type != ExerciseType.multipleChoice) {  // Si no es de opción múltiple (es de escribir código)
      _codeController.text = "";  // Limpia el campo de texto para el nuevo ejercicio
    }
  }

  @override
  void dispose() {  // Método llamado cuando el widget se destruye
    _codeController.dispose();  // Libera los recursos del controlador de texto
    super.dispose();  // Llama al dispose de la clase padre
  }

  @override
  Widget build(BuildContext context) {  // Método build que construye la UI completa del quiz
    const Color neonCian = AppTheme.primaryCyan;  // Alias para el color cyan neón del tema
    final currentExercise = widget.state.exercises[widget.state.currentIndex];  // Obtiene el ejercicio actual
    final int totalQuestions = widget.state.exercises.length;  // Obtiene el total de ejercicios del quiz
    final double progressPercent =  // Calcula el porcentaje de progreso actual
        (widget.state.currentIndex / totalQuestions) * 100;  // Fórmula: (índice actual / total) * 100

    final double screenWidth = MediaQuery.of(context).size.width;  // Obtiene el ancho de la pantalla del dispositivo
    final bool isMobile = screenWidth < 700;  // Determina si es dispositivo móvil (< 700px)
    final double sidePadding = isMobile ? 20.0 : 100.0;  // Padding lateral: 20px en móvil, 100px en desktop

    final notifier = ref.read(quizProvider(widget.difficulty).notifier);  // Obtiene el notifier del quiz para enviar acciones

    return CRTOverlay(  // Envuelve todo en el overlay efecto CRT (monitor antiguo)
      child: Scaffold(  // Estructura principal de la pantalla
        backgroundColor: AppTheme.darkBg,  // Fondo oscuro del tema
        body: SafeArea(  // Evita que el contenido se superponga con barras del sistema
          child: Padding(  // Añade padding lateral configurable
            padding: EdgeInsets.symmetric(horizontal: sidePadding),  // Padding horizontal según tipo de dispositivo
            child: Column(  // Columna vertical para organizar los elementos
              children: [  // Lista de widgets hijos
                Expanded(  // Expande para ocupar todo el espacio disponible
                  child: SingleChildScrollView(  // Permite scroll vertical cuando el contenido excede
                    padding: const EdgeInsets.symmetric(vertical: 20),  // Padding vertical de 20px
                    child: Column(  // Columna interna para todos los elementos del quiz
                      crossAxisAlignment: CrossAxisAlignment.start,  // Alineación horizontal al inicio (izquierda)
                      children: [  // Lista de widgets en orden vertical
                        _buildHeader(context),  // Construye la barra superior con botones Volver/Salir
                        const SizedBox(height: 35),  // Espaciador vertical de 35px
                        Text(  // Texto que muestra el título del nivel de dificultad
                          _getDifficultyTitle(),  // Obtiene el título según la dificultad actual
                          style: GoogleFonts.pressStart2p(  // Fuente pixelada retro
                            color: neonCian,  // Color cyan neón
                            fontSize: isMobile ? 12 : 16,  // Tamaño: 12px en móvil, 16px en desktop
                            letterSpacing: 2,  // Espaciado entre letras de 2px
                          ),
                        ),
                        const SizedBox(height: 35),  // Espaciador vertical de 35px
                        _buildProgressSection(  // Construye la sección de progreso con barra y contador
                          widget.state,  // Pasa el estado actual del quiz
                          totalQuestions,  // Pasa el total de preguntas
                          progressPercent,  // Pasa el porcentaje calculado
                        ),
                        const SizedBox(height: 35),  // Espaciador vertical de 35px

                        // Tarjeta de Pregunta ajustada al ancho total - Renderiza según tipo de ejercicio
                        if (currentExercise.type == ExerciseType.coding)  // Si es ejercicio de escribir código
                          _buildIDEDoublePanelLayout(  // Construye layout de doble panel (Editor + Consola)
                            currentExercise,  // Pasa el ejercicio actual
                            widget.state,  // Pasa el estado del quiz
                            notifier,  // Pasa el notifier para acciones
                            neonCian,  // Pasa el color cyan
                            isMobile,  // Pasa flag de dispositivo móvil
                          )
                        else if (currentExercise.type ==  // Si es ejercicio de opción múltiple
                            ExerciseType.multipleChoice)
                          _buildMultipleChoiceLayout(  // Construye layout de opciones múltiples
                            currentExercise,  // Pasa el ejercicio actual
                            widget.state,  // Pasa el estado del quiz
                            notifier,  // Pasa el notifier para acciones
                            neonCian,  // Pasa el color cyan
                            isMobile,  // Pasa flag de dispositivo móvil
                          )
                        else  // Para cualquier otro tipo de ejercicio
                          _buildDefaultExerciseLayout(  // Construye layout por defecto
                            currentExercise,  // Pasa el ejercicio actual
                            widget.state,  // Pasa el estado del quiz
                            notifier,  // Pasa el notifier para acciones
                            neonCian,  // Pasa el color cyan
                          ),

                        if (widget.state.showHint)  // Si el usuario activó la pista
                          _buildHintBox(currentExercise.hint, neonCian),  // Muestra la caja de pista
                        if (widget.state.isAnswered)  // Si ya se respondió la pregunta
                          _buildExplanationBox(widget.state, currentExercise),  // Muestra la caja de explicación

                        const SizedBox(height: 40),  // Espaciador vertical de 40px
                        _buildActionButton(  // Construye el botón de acción principal (Enviar/Siguiente)
                          context,  // Pasa el context para navegación
                          widget.state,  // Pasa el estado del quiz
                          notifier,  // Pasa el notifier para acciones
                          neonCian,  // Pasa el color cyan
                        ),

                        const SizedBox(height: 60),  // Espaciador vertical de 60px
                        _buildAssistantArea(widget.state, isMobile),  // Construye el área del asistente virtual (Clip)
                        const SizedBox(height: 30),  // Espaciador vertical de 30px
                      ],
                    ),
                  ),
                ),
                AppFooter(borderColor: AppTheme.borderBlue),  // Footer de la app con borde azul
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ═══ MÉTODO: _getDifficultyTitle ═══
  /// Devuelve el título del nivel de dificultad actual como string.
  /// Se usa para mostrar en la cabecera del quiz qué nivel se está jugando.
  String _getDifficultyTitle() {  // Método privado que retorna el título según dificultad
    switch (widget.difficulty) {  // Switch sobre el enum de dificultad
      case Difficulty.basic:  // Caso dificultad básica
        return "NIVEL BÁSICO";  // Retorna título del nivel básico
      case Difficulty.intermediate:  // Caso dificultad intermedia
        return "NIVEL INTERMEDIO";  // Retorna título del nivel intermedio
      case Difficulty.advanced:  // Caso dificultad avanzada
        return "NIVEL AVANZADO";  // Retorna título del nivel avanzado
      case Difficulty.expert:  // Caso dificultad experto
        return "🏆 RETO FINAL GG 🏆";  // Retorna título especial del reto final
    }
  }

  /// ═══ MÉTODO: _buildProgressSection ═══
  /// Construye la sección de progreso que incluye el contador de preguntas,
  /// las monedas del usuario, la barra de progreso y el subtítulo del reto.
  /// Maneja lógica especial para el ejercicio de reto (último ejercicio).
  Widget _buildProgressSection(QuizState state, int total, double percent) {  // Método que construye la UI de progreso
    // Detectar si el ejercicio actual es el reto (último ejercicio, isChallenge = true)
    final currentExercise = state.exercises[state.currentIndex];  // Obtiene el ejercicio actual del estado
    final isChallengeExercise = currentExercise.isChallenge;  // Verifica si es un ejercicio tipo reto

    // Texto del contador según nivel y si es reto
    String counterText;  // Variable para almacenar el texto del contador
    if (isChallengeExercise) {  // Si es ejercicio de reto
      // Mostrar el nivel del reto
      switch (widget.difficulty) {  // Switch según dificultad actual
        case Difficulty.basic:  // Caso básico
          counterText = "🏆 RETO NIVEL BÁSICO";  // Texto de reto básico
          break;  // Sale del switch
        case Difficulty.intermediate:  // Caso intermedio
          counterText = "🏆 RETO NIVEL INTERMEDIO";  // Texto de reto intermedio
          break;  // Sale del switch
        case Difficulty.advanced:  // Caso avanzado
          counterText = "🏆 RETO NIVEL AVANZADO";  // Texto de reto avanzado
          break;  // Sale del switch
        case Difficulty.expert:  // Caso experto
          counterText = "🏆 RETO FINAL GG";  // Texto de reto final
          break;  // Sale del switch
      }
    } else {  // Si no es ejercicio de reto (ejercicio normal)
      counterText = "PREGUNTA ${state.currentIndex + 1} DE 20";  // Texto de pregunta normal (1-20)
    }

    return RetroContainer(  // Contenedor retro para envolver la sección de progreso
      isWin95: false,  // Desactiva estilo Windows 95
      backgroundColor: const Color(0xFF14243D),  // Color de fondo azul oscuro
      padding: const EdgeInsets.all(20),  // Padding interno de 20px
      child: Column(  // Columna vertical para organizar elementos
        children: [  // Lista de widgets hijos
          Row(  // Fila horizontal para contador y monedas
            mainAxisAlignment: MainAxisAlignment.spaceBetween,  // Distribuye espacio entre extremos
            children: [  // Lista de widgets hijos
              Text(  // Texto del contador de preguntas/reto
                counterText,  // Texto calculado arriba
                style: GoogleFonts.pressStart2p(  // Fuente pixelada retro
                  color: isChallengeExercise  // Color según si es reto o normal
                      ? const Color(0xFFFFD700)  // Dorado para retos
                      : Colors.white,  // Blanco para normales
                  fontSize: isChallengeExercise ? 12 : 10,  // Tamaño: 12px para retos, 10px para normales
                ),
              ),
              Row(  // Fila para el icono y contador de monedas
                children: [  // Lista de widgets hijos
                  const Icon(  // Icono de moneda
                    Icons.monetization_on,  // Icono de moneda de Material Design
                    color: Colors.amber,  // Color ámbar
                    size: 18,  // Tamaño de 18px
                  ),
                  const SizedBox(width: 8),  // Espaciador horizontal de 8px
                  Text(  // Texto con el número de monedas
                    "${state.coins}",  // Interpola las monedas del estado
                    style: GoogleFonts.pressStart2p(  // Fuente pixelada retro
                      color: Colors.amber,  // Color ámbar
                      fontSize: 11,  // Tamaño de 11px
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),  // Espaciador vertical de 20px
          // La barra de progreso solo muestra los 20 ejercicios normales
          RetroProgressBar(  // Widget personalizado de barra de progreso
            current: isChallengeExercise ? 20 : state.currentIndex,  // Si es reto muestra 20 (completo), sino índice actual
            total: 20,  // Total siempre 20 ejercicios
          ),
          const SizedBox(height: 10),  // Espaciador vertical de 10px
          Align(  // Alineación del texto de porcentaje
            alignment: Alignment.centerLeft,  // Alineado a la izquierda
            child: Text(  // Texto que muestra el subtítulo o porcentaje
              isChallengeExercise  // Si es ejercicio de reto
                  ? getChallengeSubtitle()  // Muestra subtítulo del reto
                  : "> PROGRESO: ${percent.toInt()}%",  // Sino muestra porcentaje de progreso
              style: GoogleFonts.shareTechMono(  // Fuente monoespaciada técnica
                color: isChallengeExercise  // Color según si es reto o normal
                    ? const Color(0xFFFFD700)  // Dorado para retos
                    : Colors.grey,  // Gris para normales
                fontSize: 13,  // Tamaño de 13px
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ═══ MÉTODO: getChallengeSubtitle ═══
  /// Devuelve el subtítulo para la sección de reto según el nivel de dificultad.
  /// Se muestra debajo de la barra de progreso cuando se está en el ejercicio reto.
  String getChallengeSubtitle() {  // Método público que retorna subtítulo del reto
    switch (widget.difficulty) {  // Switch según dificultad actual
      case Difficulty.basic:  // Caso básico
        return "> ¡DESAFÍA EL NIVEL BÁSICO!";  // Subtítulo reto básico
      case Difficulty.intermediate:  // Caso intermedio
        return "> ¡DESAFÍA EL NIVEL INTERMEDIO!";  // Subtítulo reto intermedio
      case Difficulty.advanced:  // Caso avanzado
        return "> ¡DESAFÍA EL NIVEL AVANZADO!";  // Subtítulo reto avanzado
      case Difficulty.expert:  // Caso experto
        return "> ¡GOOD GAME - VICTORIA FINAL!";  // Subtítulo reto final GG
    }
  }

  /// ═══ MÉTODO: _buildIDEDoublePanelLayout ═══
  /// Construye el layout de doble panel para ejercicios de coding:
  /// panel superior/izquierdo de editor de código y panel inferior/derecho de consola.
  /// Es responsive: en móvil los apila verticalmente, en desktop los pone lado a lado.
  Widget _buildIDEDoublePanelLayout(  // Método que construye layout IDE de doble panel
    Exercise exercise,  // El ejercicio actual con pregunta y datos
    QuizState state,  // El estado actual del quiz
    Quiz notifier,  // El notifier para enviar respuestas
    Color color,  // El color principal para bordes y acentos
    bool isMobile,  // Flag que indica si es dispositivo móvil
  ) {
    const double commonHeight = 280.0;  // Altura común para los paneles en desktop (280px)
    final Widget panels = isMobile  // Si es móvil, apila verticalmente
        ? Column(  // Layout vertical para móvil
            children: [  // Lista de widgets hijos
              _buildIDEPanel(exercise, state, notifier, color, 250),  // Panel IDE con altura 250px
              const SizedBox(height: 25),  // Espaciador vertical de 25px
              _buildConsolePanel(exercise, state, 200),  // Panel consola con altura 200px
            ],
          )
        : Row(  // Si no es móvil, pone lado a lado horizontalmente
            children: [  // Lista de widgets hijos
              Expanded(  // Expande para ocupar mitad del espacio
                child: _buildIDEPanel(  // Panel de editor de código
                  exercise,  // Pasa el ejercicio
                  state,  // Pasa el estado
                  notifier,  // Pasa el notifier
                  color,  // Pasa el color
                  commonHeight,  // Altura común de 280px
                ),
              ),
              const SizedBox(width: 25),  // Espaciador horizontal de 25px
              Expanded(  // Expande para ocupar mitad del espacio
                child: _buildConsolePanel(exercise, state, commonHeight),  // Panel de consola con altura común
              ),
            ],
          );
    return Column(  // Columna que contiene pregunta + paneles
      crossAxisAlignment: CrossAxisAlignment.start,  // Alineación al inicio (izquierda)
      children: [  // Lista de widgets hijos
        _buildQuestionBox(exercise, color),  // Construye la caja de la pregunta
        const SizedBox(height: 30),  // Espaciador vertical de 30px
        panels,  // Los paneles IDE+Consola (responsive)
      ],
    );
  }

  /// ═══ MÉTODO: _buildIDEPanel ═══
  /// Construye el panel del editor de código con barra de título "EDITOR DE CÓDIGO",
  /// botón "EJECUTAR" y un TextField donde el usuario escribe su respuesta en Python.
  Widget _buildIDEPanel(  // Método que construye el panel del editor de código
    Exercise exercise,  // El ejercicio actual (no usado directamente aquí pero pasado por contexto)
    QuizState state,  // El estado actual del quiz para verificar si ya respondió
    Quiz notifier,  // El notifier para enviar la respuesta al ejecutar
    Color color,  // El color principal para la barra de título y botón
    double height,  // La altura total del panel
  ) {
    return RetroContainer(  // Contenedor retro para el panel IDE
      height: height,  // Altura especificada
      isWin95: false,  // Desactiva estilo Windows 95
      borderColor: color.withValues(alpha: 0.6),  // Borde con el color principal y 60% opacidad
      padding: EdgeInsets.zero,  // Sin padding interno (los hijos manejan su propio padding)
      child: Column(  // Columna vertical para barra superior + editor
        children: [  // Lista de widgets hijos
          Container(  // Contenedor para la barra superior del editor
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),  // Padding horizontal 15px, vertical 8px
            color: color.withValues(alpha: 0.1),  // Fondo con color principal y 10% opacidad
            child: Row(  // Fila horizontal para título y botón
              mainAxisAlignment: MainAxisAlignment.spaceBetween,  // Distribuye entre extremos
              children: [  // Lista de widgets hijos
                Text(  // Texto de título del panel
                  "EDITOR DE CÓDIGO",  // Título del editor
                  style: GoogleFonts.pressStart2p(color: color, fontSize: 9),  // Fuente pixelada pequeña
                ),
                RetroButton(  // Botón personalizado para ejecutar código
                  text: "EJECUTAR",  // Texto del botón
                  width: 120,  // Ancho de 120px
                  height: 35,  // Alto de 35px
                  fontSize: 8,  // Tamaño de fuente 8px
                  backgroundColor: color,  // Fondo con color principal
                  onPressed: state.selectedAnswer != null && !state.isAnswered  // Habilitado solo si hay respuesta y no respondida
                      ? () async => await notifier.submitAnswer()  // Envía la respuesta al notifier y ESPERA sincronización
                      : null,  // Deshabilitado si no cumple condiciones
                ),
              ],
            ),
          ),
          Expanded(  // Expande para ocupar el resto del espacio disponible
            child: Container(  // Contenedor negro para el área de texto
              padding: const EdgeInsets.all(15),  // Padding interno de 15px
              color: Colors.black,  // Fondo negro como terminal
              child: TextField(  // Campo de texto para escribir código
                controller: _codeController,  // Vincula el controlador de texto
                enabled: !state.isAnswered,  // Deshabilita si ya fue respondido
                maxLines: null,  // Permite líneas ilimitadas (scroll interno)
                expands: true,  // Se expande para llenar el espacio disponible
                style: GoogleFonts.firaCode(  // Fuente monoespaciada para código
                  color: Colors.greenAccent,  // Color verde como terminal
                  fontSize: 14,  // Tamaño de 14px
                ),
                decoration: const InputDecoration(  // Decoración del campo de texto
                  border: InputBorder.none,  // Sin borde
                  hintText: "escribe aqui",  // Texto de ayuda
                  hintStyle: TextStyle(color: Colors.white24),  // Estilo del hint (blanco tenue)
                ),
                onChanged: (val) => notifier.updateAnswer(val),  // Notifica cada cambio de texto al notifier
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ═══ MÉTODO: _buildConsolePanel ═══
  /// Construye el panel de consola de salida que muestra el resultado de la ejecución:
  /// "EJECUCIÓN COMPLETADA" si acertó, "ERROR: Lógica incorrecta" si falló,
  /// o "la salida aparecerá aqui..." mientras no se haya respondido.
  Widget _buildConsolePanel(Exercise exercise, QuizState state, double height) {  // Método que construye panel de consola
    return Container(  // Contenedor principal del panel
      height: height,  // Altura especificada como parámetro
      decoration: BoxDecoration(  // Decoración del contenedor
        color: const Color(0xFF14243D),  // Color de fondo azul oscuro
        border: Border.all(  // Borde del contenedor
          color: AppTheme.neonGreen.withValues(alpha: 0.6),  // Color verde neón con 60% opacidad
          width: 2,  // Grosor de 2px
        ),
        borderRadius: BorderRadius.circular(4),  // Bordes redondeados de 4px
      ),
      child: Column(  // Columna vertical para barra superior + contenido
        crossAxisAlignment: CrossAxisAlignment.start,  // Alineación al inicio (izquierda)
        children: [  // Lista de widgets hijos
          Container(  // Contenedor para la barra de título
            width: double.infinity,  // Ancho completo
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),  // Padding horizontal 15px, vertical 12px
            color: AppTheme.neonGreen.withValues(alpha: 0.1),  // Fondo verde neón con 10% opacidad
            child: Text(  // Texto del título del panel
              "CONSOLA DE SALIDA",  // Título de la consola
              style: GoogleFonts.pressStart2p(  // Fuente pixelada retro
                color: AppTheme.neonGreen,  // Color verde neón
                fontSize: 9,  // Tamaño de 9px
              ),
            ),
          ),
          Expanded(  // Expande para ocupar el resto del espacio
            child: Container(  // Contenedor interior para el texto de salida
              padding: const EdgeInsets.all(15),  // Padding interno de 15px
              width: double.infinity,  // Ancho completo
              color: const Color(0xFF050A14),  // Color de fondo muy oscuro (casi negro)
              child: Text(  // Texto que muestra el resultado de la ejecución
                state.isAnswered  // Si ya fue respondido
                    ? (state.wasCorrect!  // Si fue correcto
                          ? (exercise.expectedOutput ?? "EJECUCIÓN COMPLETADA.")  // Muestra salida esperada o mensaje por defecto
                          : "> ERROR: Lógica incorrecta detectada.")  // Mensaje de error
                    : "la salida aparecerá aqui...",  // Mensaje placeholder antes de responder
                style: GoogleFonts.firaCode(  // Fuente monoespaciada para código
                  color: state.isAnswered  // Color según si ya respondió
                      ? (state.wasCorrect! ? Colors.white : Colors.redAccent)  // Blanco si correcto, rojo si error
                      : Colors.white24,  // Blanco tenue si no respondido
                  fontSize: 13,  // Tamaño de 13px
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ═══ MÉTODO: _buildMultipleChoiceLayout ═══
  /// Construye el layout para ejercicios de opción múltiple. Incluye la pregunta,
  /// un snippet de código opcional si lo tiene el ejercicio, y los botones de opciones
  /// en grid (2x2 en móvil) o fila horizontal (en desktop).
  Widget _buildMultipleChoiceLayout(  // Método que construye layout de opción múltiple
    Exercise exercise,  // El ejercicio actual con pregunta y opciones
    QuizState state,  // El estado actual del quiz
    Quiz notifier,  // El notifier para seleccionar respuestas
    Color color,  // El color principal para acentos
    bool isMobile,  // Flag que indica si es dispositivo móvil
  ) {
    return Column(  // Columna vertical para organizar elementos
      crossAxisAlignment: CrossAxisAlignment.start,  // Alineación al inicio (izquierda)
      children: [  // Lista de widgets hijos
        _buildQuestionBox(exercise, color),  // Construye la caja de la pregunta
        // CodeSnippet para ejercicios de slicing, listas, etc.
        if (exercise.codeSnippet != null && exercise.codeSnippet!.isNotEmpty) ...[  // Si existe snippet de código no vacío
          const SizedBox(height: 20),  // Espaciador vertical de 20px
          Container(  // Contenedor para el snippet de código
            width: double.infinity,  // Ancho completo
            padding: const EdgeInsets.all(16),  // Padding interno de 16px
            decoration: BoxDecoration(  // Decoración del contenedor
              color: const Color(0xFF050A14),  // Fondo muy oscuro
              border: Border.all(color: color.withValues(alpha: 0.4), width: 2),  // Borde con color principal tenue
              borderRadius: BorderRadius.circular(8),  // Bordes redondeados de 8px
            ),
            child: Column(  // Columna interna para título y código
              crossAxisAlignment: CrossAxisAlignment.start,  // Alineación al inicio
              children: [  // Lista de widgets hijos
                Text(  // Título del snippet
                  "CÓDIGO:",  // Etiqueta de código
                  style: GoogleFonts.pressStart2p(  // Fuente pixelada retro
                    color: color,  // Color principal
                    fontSize: 9,  // Tamaño de 9px
                  ),
                ),
                const SizedBox(height: 12),  // Espaciador vertical de 12px
                Text(  // Texto del snippet de código
                  exercise.codeSnippet!,  // El código del ejercicio (forzadamente no nulo)
                  style: GoogleFonts.firaCode(  // Fuente monoespaciada para código
                    color: Colors.greenAccent,  // Color verde terminal
                    fontSize: 14,  // Tamaño de 14px
                    height: 1.5,  // Interlineado de 1.5
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 30),  // Espaciador vertical de 30px
        isMobile  // Si es dispositivo móvil
            ? GridView.builder(  // Usa grid de 2 columnas
                shrinkWrap: true,  // Ajusta al contenido sin expandir
                physics: const NeverScrollableScrollPhysics(),  // Desactiva scroll propio del grid
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(  // Delegate de grid fijo
                  crossAxisCount: 2,  // 2 columnas
                  crossAxisSpacing: 12,  // Espaciado entre columnas de 12px
                  mainAxisSpacing: 12,  // Espaciado entre filas de 12px
                  mainAxisExtent: 75,  // Altura de cada celda de 75px
                ),
                itemCount: (exercise.options ?? []).length,  // Número de items = cantidad de opciones
                itemBuilder: (context, index) => _buildOptionBtn(  // Construye cada botón de opción
                  exercise.options![index],  // La opción en el índice actual
                  state,  // Pasa el estado
                  notifier,  // Pasa el notifier
                  color,  // Pasa el color
                ),
              )
            : Row(  // Si no es móvil, usa fila horizontal
                children: (exercise.options ?? [])  // Mapea cada opción a un widget
                    .map(  // Transforma cada string de opción
                      (opt) => Expanded(  // Cada opción ocupa espacio igual (expandido)
                        child: Padding(  // Padding horizontal entre botones
                          padding: const EdgeInsets.symmetric(horizontal: 6),  // 6px a cada lado
                          child: _buildOptionBtn(opt, state, notifier, color),  // Construye botón de opción
                        ),
                      ),
                    )
                    .toList(),  // Convierte el iterable a lista
              ),
      ],
    );
  }

  /// ═══ MÉTODO: _buildDefaultExerciseLayout ═══
  /// Construye el layout por defecto para ejercicios que no son coding ni opción múltiple.
  /// Incluye la pregunta, código de soporte opcional, y campo de entrada de texto.
  Widget _buildDefaultExerciseLayout(  // Método que construye layout por defecto
    Exercise exercise,  // El ejercicio actual
    QuizState state,  // El estado actual del quiz
    Quiz notifier,  // El notifier para acciones
    Color color,  // El color principal para acentos
  ) {
    return Column(  // Columna vertical para organizar elementos
      crossAxisAlignment: CrossAxisAlignment.start,  // Alineación al inicio (izquierda)
      children: [  // Lista de widgets hijos
        _buildQuestionBox(exercise, color),  // Construye la caja de la pregunta
        const SizedBox(height: 30),  // Espaciador vertical de 30px
        if (exercise.codeSnippet != null && exercise.codeSnippet!.isNotEmpty)  // Si hay código de soporte
          _buildSupportCodeArea(exercise.codeSnippet!),  // Construye área de código de soporte
        const SizedBox(height: 20),  // Espaciador vertical de 20px
        _buildExerciseInput(exercise, state, notifier, color),  // Construye campo de entrada del ejercicio
      ],
    );
  }

  /// ═══ MÉTODO: _buildSupportCodeArea ═══
  /// Construye un área de código de soporte que muestra código auxiliar relacionado
  /// con el ejercicio, con fondo oscuro y texto blanco semi-transparente.
  Widget _buildSupportCodeArea(String code) {  // Método que construye área de código de soporte
    return Container(  // Contenedor principal
      width: double.infinity,  // Ancho completo
      padding: const EdgeInsets.all(15),  // Padding interno de 15px
      decoration: BoxDecoration(  // Decoración del contenedor
        color: const Color(0xFF050A14),  // Fondo muy oscuro
        border: Border.all(color: Colors.white10),  // Borde blanco tenue (10% opacidad)
      ),
      child: Text(  // Texto que muestra el código
        code,  // El código pasado como parámetro
        style: GoogleFonts.firaCode(color: Colors.white70, fontSize: 13),  // Fuente monoespaciada blanca 70%
      ),
    );
  }

  /// ═══ MÉTODO: _buildQuestionBox ═══
  /// Construye la caja de pregunta que muestra el enunciado del ejercicio
  /// y los botones de acción: PISTA, QUITAR 2 (solo en opción múltiple), y TIENDA.
  Widget _buildQuestionBox(Exercise exercise, Color color) {  // Método que construye la caja de pregunta
    return SizedBox(  // SizedBox para forzar ancho completo
      width: double.infinity, // Ancho como el body solicitado  // Ancho completo del contenedor padre
      child: RetroContainer(  // Contenedor retro para la pregunta
        isWin95: false,  // Desactiva estilo Windows 95
        borderColor: color,  // Borde con color principal
        backgroundColor: Colors.black.withValues(alpha: 0.3),  // Fondo negro con 30% opacidad
        padding: const EdgeInsets.all(25),  // Padding interno de 25px
        child: Column(  // Columna vertical para pregunta + botones
          crossAxisAlignment: CrossAxisAlignment.start,  // Alineación al inicio (izquierda)
          children: [  // Lista de widgets hijos
            Text(  // Texto de la pregunta
              "> ${exercise.question}",  // Interpola la pregunta con prefijo de prompt
              style: GoogleFonts.robotoMono(  // Fuente monoespaciada
                color: Colors.white,  // Color blanco
                fontSize: 16,  // Tamaño de 16px
                height: 1.5,  // Interlineado de 1.5
                fontWeight: FontWeight.bold,  // Negrita
              ),
            ),
            const SizedBox(height: 25),  // Espaciador vertical de 25px
            Wrap(  // Widget Wrap para botones que fluyen en múltiples líneas si es necesario
              spacing: 12,  // Espaciado horizontal entre botones de 12px
              runSpacing: 12,  // Espaciado vertical entre filas de 12px
              children: [  // Lista de widgets hijos
                RetroButton(  // Botón de pista
                  text: "PISTA (-5 🪙)",  // Texto con costo en monedas
                  style: RetroButtonStyle.primary,  // Estilo primario
                  fontSize: 10,  // Tamaño de fuente 10px
                  width: 160,  // Ancho de 160px
                  onPressed: widget.state.coins >= 5 && !widget.state.showHint  // Habilitado si tiene 5+ monedas y no usó pista
                      ? () => ref  // Callback al presionar
                            .read(quizProvider(widget.difficulty).notifier)  // Obtiene el notifier del quiz
                            .useHint()  // Llama al método usar pista
                      : null,  // Deshabilitado si no cumple condiciones
                ),
                if (exercise.type == ExerciseType.multipleChoice)  // Solo en ejercicios de opción múltiple
                  RetroButton(  // Botón de quitar 2 opciones
                    text: "QUITAR 2 (-20 🪙)",  // Texto con costo en monedas
                    style: RetroButtonStyle.secondary,  // Estilo secundario
                    fontSize: 9,  // Tamaño de fuente 9px
                    width: 200,  // Ancho de 200px
                    onPressed:  // Habilitado si tiene 20+ monedas y no usó quitar 2
                        widget.state.coins >= 20 &&  // Verifica monedas suficientes
                            widget.state.disabledOptions.isEmpty  // Verifica que no se haya usado ya
                        ? () => ref  // Callback al presionar
                              .read(quizProvider(widget.difficulty).notifier)  // Obtiene el notifier
                              .useRemoveTwo()  // Llama al método quitar 2 opciones
                        : null,  // Deshabilitado si no cumple condiciones
                  ),
                // Botón de TIENDA añadido junto a las pistas
                RetroButton(  // Botón de tienda
                  text: "TIENDA",  // Texto del botón
                  icon: Icons.shopping_cart,  // Icono de carrito de compras
                  style: RetroButtonStyle.purple,  // Estilo púrpura
                  fontSize: 9,  // Tamaño de fuente 9px
                  width: 140,  // Ancho de 140px
                  onPressed: () => context.push('/tienda'),  // Navega a la ruta /tienda
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// ═══ MÉTODO: _buildOptionBtn ═══
  /// Construye un botón de opción múltiple con estado visual: resaltado si está seleccionado,
  /// deshabilitado con "[---]" si fue eliminado por el power-up "Quitar 2".
  Widget _buildOptionBtn(  // Método que construye botón de opción
    String option,  // El texto de la opción a mostrar
    QuizState state,  // El estado actual del quiz
    Quiz notifier,  // El notifier para seleccionar la respuesta
    Color color,  // El color principal para opción seleccionada
  ) {
    final bool isSelected = state.selectedAnswer == option;  // Verifica si esta opción está seleccionada
    final bool isDisabled = state.disabledOptions.contains(option);  // Verifica si esta opción fue deshabilitada

    return RetroButton(  // Botón personalizado retro
      text: isDisabled ? "[---]" : option,  // Muestra "[---]" si deshabilitada, sino el texto de la opción
      forceUppercase: false, // Respetamos sintaxis de Python solicitado  // No fuerza mayúsculas para respetar sintaxis Python
      height: 75,  // Alto de 75px
      fontSize: 14, // Aumentado de 12 a 14 para mejor visibilidad  // Tamaño de fuente 14px (aumentado para visibilidad)
      fontFamily: 'IBMPlexMono', // Fuente más apta para código  // Fuente IBM Plex Mono para código
      backgroundColor: isSelected ? color : const Color(0xFF162431),  // Fondo cyan si seleccionada, azul oscuro si no
      onPressed: (state.isAnswered || isDisabled)  // Deshabilitado si ya respondió o está deshabilitada
          ? null  // Sin acción (deshabilitado)
          : () => notifier.selectAnswer(option),  // Selecciona esta respuesta en el notifier
    );
  }

  /// ═══ MÉTODO: _buildExerciseInput ═══
  /// Construye el campo de entrada de texto para ejercicios que requieren escribir código.
  /// Usa un TextField con estilo de terminal (fondo negro, texto verde).
  Widget _buildExerciseInput(  // Método que construye campo de entrada
    Exercise exercise,  // El ejercicio actual (no usado directamente pero pasado por contexto)
    QuizState state,  // El estado actual para verificar si ya respondió
    Quiz notifier,  // El notifier para actualizar la respuesta
    Color color,  // El color principal (no usado directamente pero pasado por contexto)
  ) {
    return Container(  // Contenedor principal del input
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),  // Padding horizontal 15px, vertical 10px
      decoration: BoxDecoration(  // Decoración del contenedor
        color: Colors.black,  // Fondo negro
        border: Border.all(color: Colors.white24),  // Borde blanco tenue (24% opacidad)
      ),
      child: TextField(  // Campo de texto para escribir respuesta
        controller: _codeController,  // Vincula el controlador de texto
        enabled: !state.isAnswered,  // Deshabilita si ya fue respondido
        maxLines: null,  // Permite líneas ilimitadas
        style: GoogleFonts.firaCode(color: Colors.greenAccent, fontSize: 15),  // Fuente verde estilo terminal
        decoration: const InputDecoration(  // Decoración del campo
          border: InputBorder.none,  // Sin borde
          hintText: "escribe aqui",  // Texto de ayuda
        ),
        onChanged: (val) => notifier.updateAnswer(val),  // Notifica cada cambio al notifier
      ),
    );
  }

  /// ═══ MÉTODO: _buildAssistantArea ═══
  /// Construye el área del asistente virtual (Clip pixelado) con un mensaje
  /// motivacional aleatorio que cambia según si la respuesta fue correcta o incorrecta.
  Widget _buildAssistantArea(QuizState state, bool isMobile) {  // Método que construye área del asistente
    String message;  // Variable para almacenar el mensaje a mostrar
    if (!state.isAnswered) {  // Si aún no ha respondido
      message =  // Mensaje genérico de ánimo
          "Lee bien las preguntas y piensa antes de responder.\n¡Tú puedes! 💪";  // Mensaje pre-respuesta
    } else {  // Si ya respondió
      message = state.wasCorrect!  // Si fue correcta
          ? _successMessages[_random.nextInt(_successMessages.length)]  // Mensaje aleatorio de éxito
          : _errorMessages[_random.nextInt(_errorMessages.length)];  // Mensaje aleatorio de error
    }
    return Padding(  // Padding para posicionar el asistente
      padding: EdgeInsets.only(left: isMobile ? 10 : 90, right: 20, bottom: 15),  // Padding lateral según dispositivo
      child: Row(  // Fila horizontal para logo + mensaje
        crossAxisAlignment: CrossAxisAlignment.end,  // Alineación vertical al final (abajo)
        children: [  // Lista de widgets hijos
          const PixelClipLogo(size: 90),  // Logo pixelado de Clip de 90px
          const SizedBox(width: 15),  // Espaciador horizontal de 15px
          Flexible(  // Widget flexible para que el mensaje se adapte
            child: IntrinsicWidth(  // Se ajusta al ancho natural del contenido
              child: Container(  // Contenedor tipo burbuja de diálogo
                padding: const EdgeInsets.symmetric(  // Padding interno
                  horizontal: 15,  // 15px horizontal
                  vertical: 12,  // 12px vertical
                ),
                decoration: BoxDecoration(  // Decoración del contenedor
                  color: Colors.white,  // Fondo blanco
                  border: Border.all(color: Colors.black, width: 2),  // Borde negro de 2px
                  boxShadow: const [  // Sombra para efecto 3D
                    BoxShadow(color: Colors.black45, offset: Offset(4, 4)),  // Sombra negra desplazada 4px
                  ],
                ),
                child: Text(  // Texto del mensaje del asistente
                  message,  // El mensaje seleccionado
                  style: GoogleFonts.shareTechMono(  // Fuente monoespaciada técnica
                    color: Colors.black,  // Color negro
                    fontSize: 12,  // Tamaño de 12px
                    height: 1.4,  // Interlineado de 1.4
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ═══ MÉTODO: _buildHeader ═══
  /// Construye la barra superior con los botones "VOLVER" (al menú principal)
  /// y "SALIR" (a la pantalla de inicio).
  Widget _buildHeader(BuildContext context) {  // Método que construye la cabecera con botones
    return Row(  // Fila horizontal para los botones
      mainAxisAlignment: MainAxisAlignment.spaceBetween,  // Distribuye entre extremos
      children: [  // Lista de widgets hijos
        RetroButton(  // Botón de volver
          text: "VOLVER",  // Texto del botón
          icon: Icons.arrow_back,  // Icono de flecha atrás
          width: 140,  // Ancho de 140px
          height: 45,  // Alto de 45px
          style: RetroButtonStyle.secondary,  // Estilo secundario
          onPressed: () => context.go('/main_menu'),  // Navega al menú principal
        ),
        RetroButton(  // Botón de salir
          text: "SALIR",  // Texto del botón
          icon: Icons.close,  // Icono de cerrar
          width: 140,  // Ancho de 140px
          height: 45,  // Alto de 45px
          style: RetroButtonStyle.danger,  // Estilo peligro (rojo)
          onPressed: () => context.go('/inicio'),  // Navega a la pantalla de inicio
        ),
      ],
    );
  }

  /// ═══ MÉTODO: _buildHintBox ═══
  /// Construye la caja de pista que se muestra cuando el usuario gasta 5 monedas
  /// para obtener una ayuda. Muestra el texto de la pista con un icono de bombilla.
  Widget _buildHintBox(String hint, Color color) {  // Método que construye caja de pista
    return Container(  // Contenedor principal de la pista
      margin: const EdgeInsets.only(top: 20),  // Margen superior de 20px
      padding: const EdgeInsets.all(20),  // Padding interno de 20px
      decoration: BoxDecoration(  // Decoración del contenedor
        color: color.withValues(alpha: 0.05),  // Fondo con color principal muy tenue (5%)
        border: Border.all(color: color, width: 1),  // Borde con color principal de 1px
      ),
      child: Row(  // Fila horizontal para icono + texto
        children: [  // Lista de widgets hijos
          Icon(Icons.lightbulb, color: color, size: 20),  // Icono de bombilla con color principal
          const SizedBox(width: 15),  // Espaciador horizontal de 15px
          Expanded(  // Expande para ocupar el resto del espacio
            child: Text(  // Texto de la pista
              "PISTA: $hint",  // Interpola la pista con prefijo
              style: GoogleFonts.shareTechMono(  // Fuente monoespaciada técnica
                color: Colors.white,  // Color blanco
                fontSize: 14,  // Tamaño de 14px
                fontStyle: FontStyle.italic,  // Estilo cursiva
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ═══ MÉTODO: _buildExplanationBox ═══
  /// Construye la caja de explicación que se muestra después de responder.
  /// Muestra "CORRECTO" o "INCORRECTO" según el resultado, y la explicación
  /// predeterminada del ejercicio.
  Widget _buildExplanationBox(QuizState state, Exercise exercise) {  // Método que construye caja de explicación
    final bool isCorrect = state.wasCorrect ?? false;  // Verifica si la respuesta fue correcta (default false)
    final Color color = isCorrect ? AppTheme.neonGreen : AppTheme.neonRed;  // Verde si correcto, rojo si incorrecto
    return Container(  // Contenedor principal de la explicación
      width: double.infinity,  // Ancho completo
      padding: const EdgeInsets.all(20),  // Padding interno de 20px
      margin: const EdgeInsets.only(top: 30),  // Margen superior de 30px
      decoration: BoxDecoration(  // Decoración del contenedor
        color: color.withValues(alpha: 0.05),  // Fondo con color muy tenue (5%)
        border: Border.all(color: color, width: 2),  // Borde con color de 2px
      ),
      child: Column(  // Columna vertical para título + explicación
        crossAxisAlignment: CrossAxisAlignment.start,  // Alineación al inicio (izquierda)
        children: [  // Lista de widgets hijos
          Text(  // Texto de estado (correcto/incorrecto)
            isCorrect ? "> CORRECTO" : "> INCORRECTO",  // Mensaje según resultado
            style: GoogleFonts.pressStart2p(color: color, fontSize: 10),  // Fuente pixelada con color
          ),
          const SizedBox(height: 15),  // Espaciador vertical de 15px
          Text(  // Texto de la explicación del ejercicio
            exercise.defaultExplanation,  // Explicación predeterminada del ejercicio
            style: GoogleFonts.robotoMono(  // Fuente monoespaciada
              color: Colors.white,  // Color blanco
              fontSize: 13,  // Tamaño de 13px
              height: 1.4,  // Interlineado de 1.4
            ),
          ),
        ],
      ),
    );
  }

  /// ═══ MÉTODO: _buildActionButton ═══
  /// Construye el botón de acción principal: "SIGUIENTE EJERCICIO" si ya respondió,
  /// "[ ENVIAR RESPUESTA ]" si es opción múltiple y no envió, o vacío para ejercicios de código.
  Widget _buildActionButton(  // Método que construye botón de acción
    BuildContext context,  // Context de build para navegación
    QuizState state,  // Estado actual del quiz
    Quiz notifier,  // Notifier para enviar respuestas
    Color color,  // Color principal para el botón
  ) {
    if (state.isAnswered) {  // Si ya respondió la pregunta
      return SizedBox(  // SizedBox para forzar ancho completo
        width: double.infinity,  // Ancho completo
        child: RetroButton(  // Botón de siguiente ejercicio
          text: "SIGUIENTE EJERCICIO",  // Texto del botón
          height: 55,  // Alto de 55px
          backgroundColor: color,  // Fondo con color principal
          textColor: Colors.black, // Letras en negro solicitado  // Texto en negro
          onPressed: () => notifier.nextQuestion(),  // Avanza a la siguiente pregunta
        ),
      );
    }
    if (widget.state.exercises[widget.state.currentIndex].type !=  // Si el ejercicio actual NO es de código
        ExerciseType.coding) {  // Abre bloque if
      return SizedBox(  // SizedBox para forzar ancho completo
        width: double.infinity,  // Ancho completo
        child: RetroButton(  // Botón de enviar respuesta
          text: "[ ENVIAR RESPUESTA ]",  // Texto del botón
          height: 55,  // Alto de 55px
          backgroundColor: state.selectedAnswer != null  // Color según si hay selección
              ? color  // Color principal si hay respuesta seleccionada
              : color.withValues(alpha: 0.3),  // Color tenue si no hay selección
          onPressed: state.selectedAnswer != null  // Habilitado solo si hay respuesta seleccionada
              ? () async => await notifier.submitAnswer()  // Envía la respuesta al notifier y ESPERA sincronización
              : null,  // Deshabilitado si no hay selección
        ),
      );
    }  // Cierra bloque if
    return const SizedBox.shrink();  // Widget vacío (0x0) para ejercicios de código (ya tienen botón EJECUTAR)
  }
}

/// ═══ CLASE: _ErrorResultScreen ═══
/// Pantalla de resultado cuando el usuario comete 5 o más errores.
/// Muestra un mensaje de fallo, explica que se necesitan menos de 5 fallos,
/// y ofrece botones de REINICIAR (que resetea progreso conservando monedas
/// de niveles anteriores según checkpoint) y SALIR (va a pantalla de inicio).
class _ErrorResultScreen extends ConsumerWidget {
  final Difficulty difficulty;  // Almacena la dificultad del quiz fallido
  final int errors;  // Almacena el número de errores cometidos
  const _ErrorResultScreen({required this.difficulty, required this.errors});  // Constructor que requiere dificultad y errores

  @override
  Widget build(BuildContext context, WidgetRef ref) {  // Método build que construye la UI
    return CRTOverlay(  // Envuelve en overlay efecto CRT
      child: Scaffold(  // Estructura principal de la pantalla
        backgroundColor: AppTheme.darkBg,  // Fondo oscuro del tema
        body: LayoutBuilder(  // Builder que responde a cambios de tamaño de layout
          builder: (context, constraints) {  // Función builder con constraints
            final bool isMobile = constraints.maxWidth < 700;  // Determina si es móvil (< 700px)
            final double sidePadding = isMobile ? 20.0 : 100.0;  // Padding: 20px móvil, 100px desktop
            return SafeArea(  // Evita superposición con barras del sistema
              child: Padding(  // Padding lateral configurable
                padding: EdgeInsets.symmetric(horizontal: sidePadding),  // Padding horizontal
                child: Center(  // Centra todo el contenido
                  child: Column(  // Columna vertical para elementos
                    mainAxisAlignment: MainAxisAlignment.center,  // Centra verticalmente
                    children: [  // Lista de widgets hijos
                      const PixelClipLogo(size: 150),  // Logo pixelado de 150px
                      const SizedBox(height: 30),  // Espaciador vertical de 30px
                      RetroContainer(  // Contenedor retro para mensaje de fallo
                        borderColor: Colors.white,  // Borde blanco
                        backgroundColor: const Color(0xFFFF4C4C),  // Fondo rojo claro
                        isWin95: false,  // Desactiva estilo Windows 95
                        padding: const EdgeInsets.all(20),  // Padding de 20px
                        child: Text(  // Texto de mensaje de fallo
                          "¡ INTENTO FALLIDO !\nHAS COMETIDO $errors ERRORES.",  // Mensaje con número de errores
                          textAlign: TextAlign.center,  // Texto centrado
                          style: GoogleFonts.pressStart2p(  // Fuente pixelada retro
                            color: Colors.white,  // Color blanco
                            fontSize: 12,  // Tamaño de 12px
                            height: 1.5,  // Interlineado de 1.5
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),  // Espaciador vertical de 20px
                      Text(  // Texto explicativo del requisito
                        "EL PROTOCOLO EXIGE MENOS DE 5 FALLOS PARA SUPERAR EL NIVEL.",  // Mensaje de requisito
                        textAlign: TextAlign.center,  // Texto centrado
                        style: GoogleFonts.shareTechMono(  // Fuente monoespaciada técnica
                          color: Colors.white70,  // Color blanco 70%
                          fontSize: 14,  // Tamaño de 14px
                        ),
                      ),
                      const SizedBox(height: 10),  // Espaciador vertical de 10px
                      Text(  // Texto informativo sobre reset de monedas
                        difficulty == Difficulty.basic  // Si es nivel básico
                            ? "Presiona REINICIAR para volver a intentar (monedas y progreso reseteados)."  // Mensaje básico
                            : "Presiona REINICIAR para volver a intentar (conservarás monedas y logros del nivel anterior).",  // Mensaje otros niveles
                        textAlign: TextAlign.center,  // Texto centrado
                        style: GoogleFonts.shareTechMono(  // Fuente monoespaciada técnica
                          color: Colors.white54,  // Color blanco 54%
                          fontSize: 12,  // Tamaño de 12px
                        ),
                      ),
                      const SizedBox(height: 40),  // Espaciador vertical de 40px
                      Row(  // Fila horizontal para botones
                        mainAxisAlignment: MainAxisAlignment.center,  // Centra los botones
                        children: [  // Lista de widgets hijos
                          RetroButton(  // Botón de reiniciar
                            text: "REINICIAR",  // Texto del botón
                            height: 50,  // Alto de 50px
                            width: 300,  // Ancho de 300px
                            style: RetroButtonStyle.primary,  // Estilo primario
                            fontSize: 9,  // Tamaño de fuente 9px
                            onPressed: () async {  // Callback asíncrono al presionar
                              // Resetea monedas y progreso en Firestore Y en el Provider
                              final user = FirebaseAuth.instance.currentUser;  // Obtiene usuario actual de Firebase
                              if (user != null) {  // Si hay usuario autenticado
                                // 1. Obtener datos actuales para calcular checkpoint
                                final levelData = await FirebaseFirestore.instance  // Consulta Firestore
                                    .collection('users')  // Colección de usuarios
                                    .doc(user.uid)  // Documento del usuario actual
                                    .get();  // Obtiene los datos

                                final data = levelData.data() ?? {};  // Extrae datos o mapa vacío si nulo
                                int coinsToRestore = 0;  // Variable para monedas a restaurar
                                int exercisesCompletedToRestore = 0;  // Variable para ejercicios completados a restaurar
                                int exercisesFailedToRestore = 0;  // Variable para ejercicios fallados a restaurar

                                // 2. Calcular monedas a conservar según el nivel
                                switch (difficulty) {  // Switch según dificultad
                                  case Difficulty.basic:  // Caso básico
                                    // Si fallas en básico, pierdes TODO (no hay nivel anterior)
                                    coinsToRestore = 0;  // Cero monedas a conservar
                                    exercisesCompletedToRestore = 0;  // Cero ejercicios a conservar
                                    exercisesFailedToRestore = 0;  // Cero fallos a conservar
                                    break;  // Sale del switch
                                  case Difficulty.intermediate:  // Caso intermedio
                                    // Si fallas en intermedio, conservas monedas del básico completado
                                    coinsToRestore = data['coins_after_basic_level']  // Intenta obtener monedas tras nivel básico
                                                  ?? data['coins_after_basic_challenge']  // O tras reto básico
                                                  ?? 0;  // Default 0 si no existe
                                    exercisesCompletedToRestore = data['exercises_completed_after_basic'] ?? 0;  // Conserva ejercicios del básico
                                    exercisesFailedToRestore = data['exercises_failed_after_basic'] ?? 0;  // Conserva fallos del básico
                                    break;  // Sale del switch
                                  case Difficulty.advanced:  // Caso avanzado
                                    // Si fallas en avanzado, conservas monedas de básico + intermedio
                                    coinsToRestore = data['coins_after_intermediate_level']  // Intenta obtener monedas tras intermedio
                                                  ?? data['coins_after_intermediate_challenge']  // O tras reto intermedio
                                                  ?? 0;  // Default 0 si no existe
                                    exercisesCompletedToRestore = data['exercises_completed_after_intermediate'] ?? 0;  // Conserva ejercicios del intermedio
                                    exercisesFailedToRestore = data['exercises_failed_after_intermediate'] ?? 0;  // Conserva fallos del intermedio
                                    break;  // Sale del switch
                                  case Difficulty.expert:  // Caso experto
                                    // Si fallas en expert, conservas monedas de todos los niveles
                                    coinsToRestore = data['coins_after_advanced_level']  // Intenta obtener monedas tras avanzado
                                                  ?? data['coins_after_intermediate_challenge']  // O tras reto intermedio (fallback)
                                                  ?? 0;  // Default 0 si no existe
                                    exercisesCompletedToRestore = data['exercises_completed_after_advanced'] ?? 0;  // Conserva ejercicios del avanzado
                                    exercisesFailedToRestore = data['exercises_failed_after_advanced'] ?? 0;  // Conserva fallos del avanzado
                                    break;  // Sale del switch
                                }

                                // 3. Resetear EconomiaProvider
                                final economia = ref.read(economiaProvider);  // Obtiene el provider de economía

                                // EN NIVEL BÁSICO: Reset completo (borra ejercicios, retos, todo)
                                // EN OTROS NIVELES: Reset parcial (mantiene logros de niveles anteriores)
                                if (difficulty == Difficulty.basic) {  // Si es nivel básico
                                  await economia.reiniciar(monedasCheckpoint: 0);  // Reset completo con 0 monedas
                                } else {  // Si es otro nivel
                                  await economia.reiniciarParcial(  // Reset parcial con checkpoint completo
                                    monedasCheckpoint: coinsToRestore,  // Restaura monedas del checkpoint
                                    exercisesCompletedCheckpoint: exercisesCompletedToRestore,  // Restaura ejercicios del nivel anterior
                                    exercisesFailedCheckpoint: exercisesFailedToRestore,  // Restaura fallos del nivel anterior
                                  );
                                }

                                final currentCoins = data['coins'] ?? 0;  // Obtiene monedas actuales o 0
                                final difference = coinsToRestore - currentCoins;  // Calcula diferencia a ajustar

                                // 4. Actualizar monedas y progreso en Firestore
                                Map<String, dynamic> updateData = {  // Mapa de datos a actualizar
                                  'coins': FieldValue.increment(difference),  // Incrementa monedas por diferencia
                                  'progress_${difficulty.name}': 0,  // Resetea progreso del nivel actual a 0
                                  'total_errors': 0,  // Resetea errores totales a 0
                                };

                                // EN NIVEL BÁSICO: Resetear también ejercicios y retos completados
                                if (difficulty == Difficulty.basic) {  // Si es nivel básico
                                  updateData['exercises_completed'] = 0;  // Resetea ejercicios completados a 0
                                  updateData['challenges_completed'] = 0;  // Resetea retos completados a 0
                                }

                                await FirebaseFirestore.instance  // Actualiza Firestore
                                    .collection('users')  // Colección de usuarios
                                    .doc(user.uid)  // Documento del usuario
                                    .update(updateData);  // Aplica las actualizaciones

                                if (difficulty == Difficulty.basic) {  // Si es nivel básico
                                  // Nivel básico: todo reseteado  // (comentario placeholder)
                                } else {  // Si es otro nivel
                                  // Otros niveles: se mantienen logros  // (comentario placeholder)
                                }
                              }

                              // Pequeña pausa para asegurar que Firestore se actualice
                              await Future.delayed(  // Espera asíncrona
                                const Duration(milliseconds: 500),  // 500 milisegundos
                              );

                              // Navega al menú principal para reintentar
                              if (context.mounted) context.go('/main_menu');  // Navega al menú principal si el context sigue válido
                            },
                          ),
                          const SizedBox(width: 15),  // Espaciador horizontal de 15px
                          RetroButton(  // Botón de salir
                            text: "SALIR",  // Texto del botón
                            height: 50,  // Alto de 50px
                            width: 300,  // Ancho de 300px
                            style: RetroButtonStyle.purple,  // Estilo púrpura
                            fontSize: 9,  // Tamaño de fuente 9px
                            onPressed: () async {  // Callback asíncrono al presionar
                              // Resetea monedas y progreso en Firestore Y en el Provider
                              final user = FirebaseAuth.instance.currentUser;  // Obtiene usuario actual de Firebase
                              if (user != null) {  // Si hay usuario autenticado
                                // 1. Obtener datos actuales para calcular checkpoint
                                final levelData = await FirebaseFirestore.instance  // Consulta Firestore
                                    .collection('users')  // Colección de usuarios
                                    .doc(user.uid)  // Documento del usuario actual
                                    .get();  // Obtiene los datos

                                final data = levelData.data() ?? {};  // Extrae datos o mapa vacío si nulo
                                int coinsToRestore = 0;  // Variable para monedas a restaurar
                                int exercisesCompletedToRestore = 0;  // Variable para ejercicios completados a restaurar
                                int exercisesFailedToRestore = 0;  // Variable para ejercicios fallados a restaurar

                                // 2. Calcular monedas a conservar según el nivel
                                switch (difficulty) {  // Switch según dificultad
                                  case Difficulty.basic:  // Caso básico
                                    // Si fallas en básico, pierdes TODO (no hay nivel anterior)
                                    coinsToRestore = 0;  // Cero monedas a conservar
                                    exercisesCompletedToRestore = 0;  // Cero ejercicios a conservar
                                    exercisesFailedToRestore = 0;  // Cero fallos a conservar
                                    break;  // Sale del switch
                                  case Difficulty.intermediate:  // Caso intermedio
                                    // Si fallas en intermedio, conservas monedas del básico completado
                                    coinsToRestore = data['coins_after_basic_level']  // Intenta obtener monedas tras nivel básico
                                                  ?? data['coins_after_basic_challenge']  // O tras reto básico
                                                  ?? 0;  // Default 0 si no existe
                                    exercisesCompletedToRestore = data['exercises_completed_after_basic'] ?? 0;  // Conserva ejercicios del básico
                                    exercisesFailedToRestore = data['exercises_failed_after_basic'] ?? 0;  // Conserva fallos del básico
                                    break;  // Sale del switch
                                  case Difficulty.advanced:  // Caso avanzado
                                    // Si fallas en avanzado, conservas monedas de básico + intermedio
                                    coinsToRestore = data['coins_after_intermediate_level']  // Intenta obtener monedas tras intermedio
                                                  ?? data['coins_after_intermediate_challenge']  // O tras reto intermedio
                                                  ?? 0;  // Default 0 si no existe
                                    exercisesCompletedToRestore = data['exercises_completed_after_intermediate'] ?? 0;  // Conserva ejercicios del intermedio
                                    exercisesFailedToRestore = data['exercises_failed_after_intermediate'] ?? 0;  // Conserva fallos del intermedio
                                    break;  // Sale del switch
                                  case Difficulty.expert:  // Caso experto
                                    // Si fallas en expert, conservas monedas de todos los niveles
                                    coinsToRestore = data['coins_after_advanced_level']  // Intenta obtener monedas tras avanzado
                                                  ?? data['coins_after_intermediate_challenge']  // O tras reto intermedio (fallback)
                                                  ?? 0;  // Default 0 si no existe
                                    exercisesCompletedToRestore = data['exercises_completed_after_advanced'] ?? 0;  // Conserva ejercicios del avanzado
                                    exercisesFailedToRestore = data['exercises_failed_after_advanced'] ?? 0;  // Conserva fallos del avanzado
                                    break;  // Sale del switch
                                }

                                // 3. Resetear EconomiaProvider
                                final economia = ref.read(economiaProvider);  // Obtiene el provider de economía

                                // EN NIVEL BÁSICO: Reset completo (borra ejercicios, retos, todo)
                                // EN OTROS NIVELES: Reset parcial (mantiene logros de niveles anteriores)
                                if (difficulty == Difficulty.basic) {  // Si es nivel básico
                                  await economia.reiniciar(monedasCheckpoint: 0);  // Reset completo con 0 monedas
                                } else {  // Si es otro nivel
                                  await economia.reiniciarParcial(  // Reset parcial con checkpoint completo
                                    monedasCheckpoint: coinsToRestore,  // Restaura monedas del checkpoint
                                    exercisesCompletedCheckpoint: exercisesCompletedToRestore,  // Restaura ejercicios del nivel anterior
                                    exercisesFailedCheckpoint: exercisesFailedToRestore,  // Restaura fallos del nivel anterior
                                  );
                                }

                                final currentCoins = data['coins'] ?? 0;  // Obtiene monedas actuales o 0
                                final difference = coinsToRestore - currentCoins;  // Calcula diferencia a ajustar

                                // 4. Actualizar monedas y progreso en Firestore
                                Map<String, dynamic> updateData = {  // Mapa de datos a actualizar
                                  'coins': FieldValue.increment(difference),  // Incrementa monedas por diferencia
                                  'progress_${difficulty.name}': 0,  // Resetea progreso del nivel actual a 0
                                  'total_errors': 0,  // Resetea errores totales a 0
                                };

                                // EN NIVEL BÁSICO: Resetear también ejercicios y retos completados
                                if (difficulty == Difficulty.basic) {  // Si es nivel básico
                                  updateData['exercises_completed'] = 0;  // Resetea ejercicios completados a 0
                                  updateData['challenges_completed'] = 0;  // Resetea retos completados a 0
                                }

                                await FirebaseFirestore.instance  // Actualiza Firestore
                                    .collection('users')  // Colección de usuarios
                                    .doc(user.uid)  // Documento del usuario
                                    .update(updateData);  // Aplica las actualizaciones

                                if (difficulty == Difficulty.basic) {  // Si es nivel básico
                                  // Nivel básico: todo reseteado  // (comentario placeholder)
                                } else {  // Si es otro nivel
                                  // Otros niveles: se mantienen logros  // (comentario placeholder)
                                }
                              }

                              // Pequeña pausa para asegurar que Firestore se actualice
                              await Future.delayed(  // Espera asíncrona
                                const Duration(milliseconds: 500),  // 500 milisegundos
                              );

                              // Navega a la pantalla de INICIO (no al menú principal)
                              if (context.mounted) context.go('/inicio');  // Navega a inicio si el context sigue válido
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// ═══ CLASE: _SuccessResultScreen ═══
/// Pantalla de resultado exitoso cuando el usuario completa el nivel con menos
/// de 5 errores. Muestra felicitación y botón para ir al reto del nivel actual.
/// Si es el nivel expert, delega en _GGVictoryScreen en lugar de mostrar esta pantalla.
class _SuccessResultScreen extends ConsumerWidget {
  final Difficulty difficulty;  // Almacena la dificultad del nivel completado
  const _SuccessResultScreen({required this.difficulty});  // Constructor que requiere la dificultad

  @override
  Widget build(BuildContext context, WidgetRef ref) {  // Método build que construye la UI
    const Color neonCian = AppTheme.primaryCyan;  // Alias para color cyan neón

    // Si completo el nivel expert, muestra pantalla GG especial
    if (difficulty == Difficulty.expert) {  // Verifica si es nivel experto
      return _GGVictoryScreen(difficulty: difficulty);  // Delega en pantalla de victoria GG
    }

    return CRTOverlay(  // Envuelve en overlay efecto CRT
      child: Scaffold(  // Estructura principal de la pantalla
        backgroundColor: AppTheme.darkBg,  // Fondo oscuro del tema
        body: LayoutBuilder(  // Builder que responde a cambios de tamaño
          builder: (context, constraints) {  // Función builder con constraints
            final bool isMobile = constraints.maxWidth < 700;  // Determina si es móvil (< 700px)
            final double sidePadding = isMobile ? 20.0 : 100.0;  // Padding: 20px móvil, 100px desktop
            return SafeArea(  // Evita superposición con barras del sistema
              child: Padding(  // Padding lateral configurable
                padding: EdgeInsets.symmetric(horizontal: sidePadding),  // Padding horizontal
                child: Center(  // Centra todo el contenido
                  child: Column(  // Columna vertical para elementos
                    mainAxisAlignment: MainAxisAlignment.center,  // Centra verticalmente
                    children: [  // Lista de widgets hijos
                      const PixelClipLogo(size: 200),  // Logo pixelado de 200px
                      const SizedBox(height: 30),  // Espaciador vertical de 30px
                      RetroContainer(  // Contenedor retro para mensaje de éxito
                        isWin95: false,  // Desactiva estilo Windows 95
                        borderColor: Colors.black,  // Borde negro
                        backgroundColor: Colors.white,  // Fondo blanco
                        child: Text(  // Texto de felicitación
                          "¡ ENHORABUENA !\nHAS SUPERADO EL NIVEL.",  // Mensaje de éxito
                          textAlign: TextAlign.center,  // Texto centrado
                          style: GoogleFonts.pressStart2p(  // Fuente pixelada retro
                            color: Colors.black,  // Color negro
                            fontSize: 14,  // Tamaño de 14px
                            height: 1.5,  // Interlineado de 1.5
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),  // Espaciador vertical de 25px
                      Text(  // Texto informativo sobre siguiente nivel
                        "PARA PASAR AL PRÓXIMO NIVEL DEBES RESOLVER EL SIGUIENTE RETO. ¡ÉXITO!",  // Mensaje sobre el reto
                        textAlign: TextAlign.center,  // Texto centrado
                        style: GoogleFonts.shareTechMono(  // Fuente monoespaciada técnica
                          color: neonCian,  // Color cyan neón
                          fontSize: 16,  // Tamaño de 16px
                          fontWeight: FontWeight.bold,  // Negrita
                        ),
                      ),
                      const SizedBox(height: 40),  // Espaciador vertical de 40px
                      Row(  // Fila horizontal para botones
                        mainAxisAlignment: MainAxisAlignment.center,  // Centra los botones
                        children: [  // Lista de widgets hijos
                          RetroButton(  // Botón de ir al reto
                            text: "IR AL RETO",  // Texto del botón
                            height: 50,  // Alto de 50px
                            width: 300,  // Ancho de 300px
                            style: RetroButtonStyle.primary,  // Estilo primario
                            fontSize: 9,  // Tamaño de fuente 9px
                            onPressed: () {  // Callback al presionar
                              // Pasamos la dificultad actual al challenge
                              context.go(  // Navega a la ruta del challenge
                                '/challenge?difficulty=${difficulty.name}',  // Ruta con parámetro de dificultad
                              );
                            },
                          ),
                          const SizedBox(width: 15),  // Espaciador horizontal de 15px
                          RetroButton(  // Botón de volver
                            text: "VOLVER",  // Texto del botón
                            height: 50,  // Alto de 50px
                            width: 300,  // Ancho de 300px
                            style: RetroButtonStyle.secondary,  // Estilo secundario
                            fontSize: 9,  // Tamaño de fuente 9px
                            onPressed: () => context.go('/main_menu'),  // Navega al menú principal
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// ═══ CLASE: _GGVictoryScreen ═══
/// Pantalla de victoria final GG (Good Game). Se muestra cuando el usuario
/// completa exitosamente el nivel EXPERT. Muestra trofeos, felicitación de
/// "MAESTRO DE PYTHON", resumen de todos los niveles completados, y botones
/// para reiniciar o salir.
class _GGVictoryScreen extends ConsumerWidget {
  final Difficulty difficulty;  // Almacena la dificultad (siempre expert en este caso)
  const _GGVictoryScreen({required this.difficulty});  // Constructor que requiere la dificultad

  @override
  Widget build(BuildContext context, WidgetRef ref) {  // Método build que construye la UI
    return CRTOverlay(  // Envuelve en overlay efecto CRT
      child: Scaffold(  // Estructura principal de la pantalla
        backgroundColor: AppTheme.darkBg,  // Fondo oscuro del tema
        body: LayoutBuilder(  // Builder que responde a cambios de tamaño
          builder: (context, constraints) {  // Función builder con constraints
            final bool isMobile = constraints.maxWidth < 700;  // Determina si es móvil (< 700px)
            final double sidePadding = isMobile ? 20.0 : 100.0;  // Padding: 20px móvil, 100px desktop
            return SafeArea(  // Evita superposición con barras del sistema
              child: Padding(  // Padding lateral configurable
                padding: EdgeInsets.symmetric(horizontal: sidePadding),  // Padding horizontal
                child: Center(  // Centra todo el contenido
                  child: SingleChildScrollView(  // Permite scroll vertical
                    child: Column(  // Columna vertical para elementos
                      mainAxisAlignment: MainAxisAlignment.center,  // Centra verticalmente
                      children: [  // Lista de widgets hijos
                        const PixelClipLogo(size: 250),  // Logo pixelado de 250px
                        const SizedBox(height: 40),  // Espaciador vertical de 40px
                        // Contenedor especial GG
                        RetroContainer(  // Contenedor retro para trofeo GG
                          isWin95: false,  // Desactiva estilo Windows 95
                          borderColor: Colors.amber,  // Borde ámbar
                          backgroundColor: const Color(0xFFFFD700),  // Fondo dorado
                          padding: const EdgeInsets.all(30),  // Padding de 30px
                          child: Column(  // Columna interna para textos
                            children: [  // Lista de widgets hijos
                              Text(  // Texto principal GG
                                "🏆 GG 🏆",  // Trofeos + GG
                                style: GoogleFonts.pressStart2p(  // Fuente pixelada retro
                                  color: Colors.black,  // Color negro
                                  fontSize: 48,  // Tamaño grande de 48px
                                ),
                              ),
                              const SizedBox(height: 20),  // Espaciador vertical de 20px
                              Text(  // Texto GOOD GAME
                                "GOOD GAME",  // Mensaje GOOD GAME
                                style: GoogleFonts.pressStart2p(  // Fuente pixelada retro
                                  color: Colors.black,  // Color negro
                                  fontSize: 24,  // Tamaño de 24px
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),  // Espaciador vertical de 30px
                        // Mensaje de victoria
                        RetroContainer(  // Contenedor retro para mensaje de felicitación
                          isWin95: false,  // Desactiva estilo Windows 95
                          borderColor: AppTheme.primaryCyan,  // Borde cyan principal
                          backgroundColor: const Color(0xFF14243D),  // Fondo azul oscuro
                          padding: const EdgeInsets.all(25),  // Padding de 25px
                          child: Column(  // Columna interna para textos
                            children: [  // Lista de widgets hijos
                              Text(  // Texto de felicitación
                                "¡ FELICIDADES MAESTRO DE PYTHON !",  // Mensaje de maestro
                                textAlign: TextAlign.center,  // Texto centrado
                                style: GoogleFonts.pressStart2p(  // Fuente pixelada retro
                                  color: AppTheme.primaryCyan,  // Color cyan
                                  fontSize: isMobile ? 10 : 14,  // 10px móvil, 14px desktop
                                  height: 1.8,  // Interlineado de 1.8
                                ),
                              ),
                              const SizedBox(height: 20),  // Espaciador vertical de 20px
                              Text(  // Lista de niveles completados
                                "Has completado todos los niveles:\n✅ BÁSICO\n✅ INTERMEDIO\n✅ AVANZADO\n🏆 EXPERT",  // Lista de niveles
                                textAlign: TextAlign.center,  // Texto centrado
                                style: GoogleFonts.shareTechMono(  // Fuente monoespaciada técnica
                                  color: Colors.white,  // Color blanco
                                  fontSize: 14,  // Tamaño de 14px
                                  height: 1.8,  // Interlineado de 1.8
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),  // Espaciador vertical de 30px
                        // Estadisticas
                        Text(  // Texto motivacional final
                          "Has demostrado ser un verdadero desarrollador Python.\n¡El camino del aprendizaje nunca termina!",  // Mensaje final
                          textAlign: TextAlign.center,  // Texto centrado
                          style: GoogleFonts.shareTechMono(  // Fuente monoespaciada técnica
                            color: Colors.white70,  // Color blanco 70%
                            fontSize: 12,  // Tamaño de 12px
                            height: 1.6,  // Interlineado de 1.6
                          ),
                        ),
                        const SizedBox(height: 40),  // Espaciador vertical de 40px
                        // Botones de accion
                        Row(  // Fila horizontal para botones
                          mainAxisAlignment: MainAxisAlignment.center,  // Centra los botones
                          children: [  // Lista de widgets hijos
                            RetroButton(  // Botón de reiniciar
                              text: "REINICIAR",  // Texto del botón
                              height: 50,  // Alto de 50px
                              width: isMobile ? 140 : 200,  // Ancho: 140px móvil, 200px desktop
                              style: RetroButtonStyle.primary,  // Estilo primario
                              fontSize: 9,  // Tamaño de fuente 9px
                              onPressed: () async {  // Callback asíncrono
                                await ref  // Obtiene el notifier del quiz
                                    .read(quizProvider(difficulty).notifier)  // Accede al notifier
                                    .resetLevelAndCoins();  // Resetea nivel y monedas
                                if (context.mounted) context.go('/main_menu');  // Navega al menú principal si context válido
                              },
                            ),
                            const SizedBox(width: 15),  // Espaciador horizontal de 15px
                            RetroButton(  // Botón de salir
                              text: "SALIR",  // Texto del botón
                              height: 50,  // Alto de 50px
                              width: isMobile ? 140 : 200,  // Ancho: 140px móvil, 200px desktop
                              style: RetroButtonStyle.purple,  // Estilo púrpura
                              fontSize: 9,  // Tamaño de fuente 9px
                              onPressed: () async {  // Callback asíncrono
                                await ref  // Obtiene el notifier del quiz
                                    .read(quizProvider(difficulty).notifier)  // Accede al notifier
                                    .resetLevelAndCoins();  // Resetea nivel y monedas
                                if (context.mounted) context.go('/inicio');  // Navega a inicio si context válido
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
