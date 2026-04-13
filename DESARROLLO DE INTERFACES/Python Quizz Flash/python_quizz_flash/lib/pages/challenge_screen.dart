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

import 'dart:async';  // Importa la biblioteca para manejo de temporizadores y operaciones asíncronas
import 'dart:convert';  // Importa la biblioteca para codificar y decodificar JSON
import 'dart:math';  // Importa la biblioteca matemática para generar números aleatorios
import 'package:flutter/services.dart';  // Importa servicios de Flutter como rootBundle para cargar assets
import 'package:flutter/material.dart';  // Importa el framework de widgets Material Design de Flutter
import 'package:flutter_riverpod/flutter_riverpod.dart';  // Importa Riverpod para gestión de estado reactivo
import 'package:firebase_auth/firebase_auth.dart';  // Importa Firebase Authentication para gestión de usuarios
import 'package:cloud_firestore/cloud_firestore.dart';  // Importa Cloud Firestore para base de datos en la nube
import 'package:google_fonts/google_fonts.dart';  // Importa Google Fonts para tipografías personalizadas
import 'package:go_router/go_router.dart';  // Importa GoRouter para navegación y enrutamiento
import '../theme/app_theme.dart';  // Importa el tema de colores y estilos de la aplicación
import '../widgets/app_footer.dart';  // Importa el widget del pie de página de la aplicación
import '../widgets/pixel_clip_logo.dart';  // Importa el widget del logo pixelado estilo retro
import '../widgets/crt_overlay.dart';  // Importa el efecto visual de monitor CRT antiguo
import '../widgets/retro_button.dart';  // Importa el botón con estilo retro personalizado
import '../widgets/retro_container.dart';  // Importa el contenedor con estilo retro personalizado
import '../widgets/app_notifications.dart';  // Importa el sistema de notificaciones estandarizadas
import '../providers/economia_provider.dart';  // Importa el proveedor de gestión de economía (monedas)

/// ═══ CLASE: ChallengeData ═══
/// Clase que define la estructura de cada reto de programación
class ChallengeData {
  final String title;  // Almacena el título del reto de programación
  final String description;  // Almacena la explicación de lo que debe hacer el código
  final String initialCode;  // Almacena el código inicial con errores que ve el usuario
  final String solutionPattern;  // Almacena el fragmento clave que resuelve el reto
  final String specificHint;  // Almacena el texto de la pista específica para el reto
  final String fullSolution;  // Almacena el código completo y correcto para la pista 3

  /// ═══ MÉTODO: Constructor de ChallengeData ═══
  ChallengeData({
    required this.title,  // Inicializa el título como parámetro obligatorio
    required this.description,  // Inicializa la descripción como parámetro obligatorio
    required this.initialCode,  // Inicializa el código inicial como parámetro obligatorio
    required this.solutionPattern,  // Inicializa el patrón de solución como parámetro obligatorio
    required this.specificHint,  // Inicializa la pista específica como parámetro obligatorio
    required this.fullSolution,  // Inicializa la solución completa como parámetro obligatorio
  });
}

/// ═══ CLASE: ChallengeScreen ═══
/// Pantalla del reto final con lógica de "todo o nada"
class ChallengeScreen extends ConsumerStatefulWidget {
  final String difficulty;  // Almacena la dificultad del challenge: 'basic', 'intermediate' o 'advanced'
  const ChallengeScreen({super.key, this.difficulty = 'basic'});  // Constructor con dificultad por defecto 'basic'

  @override
  ConsumerState<ChallengeScreen> createState() => _ChallengeScreenState();  // Crea el estado asociado a este StatefulWidget
}

/// ═══ CLASE: _ChallengeScreenState ═══
/// Estado privado de ChallengeScreen que contiene toda la lógica del reto
class _ChallengeScreenState extends ConsumerState<ChallengeScreen> {
  late final Map<String, List<ChallengeData>> _challengePools;  // Mapa de retos organizados por nivel de dificultad
  ChallengeData? _currentChallenge;  // Reto seleccionado actualmente para esta partida
  TextEditingController? _codeController;  // Controlador del campo de texto del editor de código
  int _secondsRemaining = 600;  // Tiempo límite restante en segundos (10 minutos)
  Timer? _timer;  // Temporizador que cuenta regresivamente cada segundo
  bool _isSolved = false;  // Bandera que indica si el reto fue resuelto exitosamente
  String _systemStatus = "> SISTEMA: ERROR_DETECTED";  // Estado textual del sistema mostrado en la UI
  String _criticidadStatus = "> NIVEL_CRITICIDAD: ALTO";  // Nivel de criticidad visual mostrado en la UI

  /// ═══ MÉTODO: initState ═══
  /// Método del ciclo de vida que se ejecuta al crear el estado del widget
  @override
  void initState() {
    super.initState();  // Llama al initState de la clase padre
    _initializeChallenges();  // Inicializa y carga los retos de forma asíncrona
  }

  /// ═══ MÉTODO: _initializeChallenges ═══
  /// Inicializa los retos cargando desde el archivo JSON y selecciona uno aleatorio
  Future<void> _initializeChallenges() async {
    final pools = await _loadChallengePools();  // Carga los pools de retos desde el archivo JSON
    final pool = pools[widget.difficulty] ?? pools['basic']!;  // Selecciona el pool según dificultad o usa 'basic' como fallback
    final selectedChallenge = pool[Random().nextInt(pool.length)];  // Selecciona un reto aleatorio del pool correspondiente
    final controller = TextEditingController(text: selectedChallenge.initialCode);  // Crea un controlador con el código inicial del reto
    setState(() {  // Actualiza el estado del widget de forma reactiva
      _challengePools = pools;  // Asigna los pools de retos cargados
      _currentChallenge = selectedChallenge;  // Asigna el reto seleccionado aleatoriamente
      _codeController = controller;  // Asigna el controlador del editor de código
    });
    _startTimer();  // Inicia la cuenta regresiva del temporizador
  }

  /// ═══ MÉTODO: _loadChallengePools ═══
  /// Carga los retos desde el archivo JSON assets/data/challenges_pool.json
  Future<Map<String, List<ChallengeData>>> _loadChallengePools() async {
    try {  // Bloque try para manejar errores de carga del JSON
      final String response = await rootBundle.loadString('assets/data/challenges_pool.json');  // Carga el contenido del archivo JSON desde assets
      final data = json.decode(response) as Map<String, dynamic>;  // Decodifica el string JSON a un mapa de Dart
      final pools = <String, List<ChallengeData>>{};  // Crea un mapa vacío para almacenar los pools por nivel
      for (final level in ['basic', 'intermediate', 'advanced']) {  // Itera sobre cada nivel de dificultad
        final list = data[level] as List<dynamic>;  // Obtiene la lista de retos para el nivel actual
        pools[level] = list.map((e) {  // Convierte cada elemento del mapa en un objeto ChallengeData
          final map = e as Map<String, dynamic>;  // Convierte el elemento dinámico a un mapa tipado
          return ChallengeData(  // Crea una instancia de ChallengeData con los datos del mapa
            title: map['title'] as String,  // Extrae el título del mapa como String
            description: map['description'] as String,  // Extrae la descripción del mapa como String
            initialCode: map['initialCode'] as String,  // Extrae el código inicial del mapa como String
            solutionPattern: map['solutionPattern'] as String,  // Extrae el patrón de solución del mapa como String
            specificHint: map['specificHint'] as String,  // Extrae la pista específica del mapa como String
            fullSolution: map['fullSolution'] as String,  // Extrae la solución completa del mapa como String
          );
        }).toList();  // Convierte el iterable resultante en una lista
      }
      return pools;  // Retorna el mapa completo de pools de retos
    } catch (e) {  // Captura cualquier excepción durante la carga del JSON
      return _getDefaultPools();  // Retorna los pools por defecto si falla la carga
    }
  }

  /// ═══ MÉTODO: _getDefaultPools ═══
  /// Retorna pools de retos por defecto en caso de error al cargar el JSON
  Map<String, List<ChallengeData>> _getDefaultPools() {
    return {  // Retorna un mapa literal con los pools por defecto
      'basic': [ChallengeData(title: "DOBLE DE NÚMERO", description: "El sistema debe calcular el doble de un número.", initialCode: "def doble(n):\n    pass", solutionPattern: "return n * 2", specificHint: "La función debe retornar el valor multiplicado por 2.", fullSolution: "def doble(n):\n    return n * 2")],  // Pool básico con reto de calcular el doble
      'intermediate': [ChallengeData(title: "CUADRADOS PARES", description: "Crea una lista con los cuadrados solo de los números pares.", initialCode: "def cuadrados_pares(n):\n    pass", solutionPattern: "return [x**2 for x in range(n) if x % 2 == 0]", specificHint: "Usa list comprehension con filtro para solo pares.", fullSolution: "def cuadrados_pares(n):\n    return [x**2 for x in range(n) if x % 2 == 0]")],  // Pool intermedio con reto de cuadrados pares
      'advanced': [ChallengeData(title: "FIBONACCI", description: "Crea un generador que produzca la secuencia de Fibonacci.", initialCode: "def fibonacci(n):\n    pass", solutionPattern: "yield a", specificHint: "yield produce valores uno a uno.", fullSolution: "def fibonacci(n):\n    a, b = 0, 1\n    for _ in range(n):\n        yield a\n        a, b = b, a + b")],  // Pool avanzado con reto de secuencia Fibonacci
    };
  }

  /// ═══ MÉTODO: _startTimer ═══
  /// Inicia el temporizador que decrementa segundo a segundo
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {  // Crea un temporizador periódico que se ejecuta cada segundo
      if (_secondsRemaining > 0) {  // Verifica si aún queda tiempo restante
        setState(() => _secondsRemaining--);  // Decrementa el contador de segundos y actualiza la UI
      } else {  // Si el tiempo llegó a cero
        _timer?.cancel();  // Cancela el temporizador para evitar que siga ejecutándose
        _handleFailure("TIEMPO AGOTADO");  // Maneja el fallo por tiempo agotado
      }
    });
  }

  /// ═══ MÉTODO: _formatTime ═══
  /// Formatea los segundos restantes al formato MM:SS
  String _formatTime(int seconds) {
    int mins = seconds ~/ 60;  // Calcula los minutos usando división entera
    int secs = seconds % 60;  // Calcula los segundos restantes usando módulo
    return "${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";  // Retorna el string formateado con ceros a la izquierda
  }

  /// ═══ MÉTODO: _handleFailure ═══
  /// Maneja el fallo del reto: resetea monedas y progreso en Firebase
  Future<void> _handleFailure(String reason) async {
    _timer?.cancel();  // Cancela el temporizador para detener la cuenta regresiva
    final user = FirebaseAuth.instance.currentUser;  // Obtiene el usuario actualmente autenticado en Firebase
    if (user == null) { throw Exception('Usuario no autenticado'); }  // Lanza excepción si no hay usuario autenticado

    String progressField = 'progress_basic';  // Campo de progreso por defecto para nivel básico
    if (widget.difficulty == 'intermediate') { progressField = 'progress_intermediate'; }  // Cambia el campo si la dificultad es intermedia

    final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();  // Obtiene el documento del usuario desde Firestore
    if (!userDoc.exists) {  // Verifica si el documento del usuario no existe
      if (mounted) {  // Verifica que el widget siga montado en el árbol
        _showResultDialog(title: "SISTEMA COLAPSADO", message: "MOTIVO: $reason.\nCONSECUENCIA: Comenzar nuevamente, pierdes los PY-Coins.", isSuccess: false);  // Muestra diálogo de fallo sin modificar datos inexistentes
      }
      return;  // Sale temprano ya que no hay documento que actualizar
    }

    final currentCoins = userDoc.data()?['coins'] ?? 0;  // Obtiene las monedas actuales del usuario o 0 si no existen
    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({  // Actualiza el documento del usuario en Firestore
      'coins': FieldValue.increment(-currentCoins),  // Resta todas las monedas usando incremento negativo atómico
      progressField: 0,  // Resetea el progreso del nivel actual a cero
    });

    if (mounted) {  // Verifica que el widget siga montado antes de mostrar el diálogo
      _showResultDialog(title: "SISTEMA COLAPSADO", message: "MOTIVO: $reason.\nCONSECUENCIA: Comenzar nuevamente, pierdes los PY-Coins.", isSuccess: false);  // Muestra el diálogo de sistema colapsado
    }
  }

  /// ═══ MÉTODO: _checkSolution ═══
  /// Verifica si el código del usuario contiene el patrón de solución
  void _checkSolution() async {
    if (_currentChallenge == null) return;  // Sale si no hay reto cargado actualmente
    final String userCode = _codeController!.text.replaceAll(" ", "").replaceAll("\n", "");  // Obtiene el código del usuario eliminando espacios y saltos de línea
    final String pattern = _currentChallenge!.solutionPattern.replaceAll(" ", "");  // Obtiene el patrón de solución eliminando espacios

    if (userCode.contains(pattern)) {  // Verifica si el código del usuario contiene el patrón de solución
      setState(() {  // Actualiza el estado del widget
        _isSolved = true;  // Marca el reto como resuelto
        _systemStatus = "> SISTEMA: OPTIMIZADO";  // Actualiza el estado del sistema a optimizado
        _criticidadStatus = "> NIVEL_CRITICIDAD: NINGUNO";  // Actualiza el nivel de criticidad a ninguno
        _timer?.cancel();  // Cancela el temporizador ya que el reto fue completado
      });

      final user = FirebaseAuth.instance.currentUser;  // Obtiene el usuario autenticado actual
      if (user != null) {  // Verifica que exista un usuario autenticado
        String challengeField = 'challenge_basic_completed';  // Campo de completado para nivel básico por defecto
        String nextLevelUnlock = 'intermediate_unlocked';  // Campo de desbloqueo para nivel intermedio por defecto
        if (widget.difficulty == 'intermediate') {  // Si la dificultad actual es intermedia
          challengeField = 'challenge_intermediate_completed';  // Cambia el campo de completado a intermedio
          nextLevelUnlock = 'advanced_unlocked';  // Cambia el desbloqueo a nivel avanzado
        } else if (widget.difficulty == 'advanced') {  // Si la dificultad actual es avanzada
          challengeField = 'challenge_advanced_completed';  // Cambia el campo de completado a avanzado
          nextLevelUnlock = 'expert_unlocked';  // Cambia el desbloqueo a nivel experto
        }

        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({  // Actualiza el documento del usuario en Firestore
          challengeField: true,  // Marca el challenge actual como completado
          nextLevelUnlock: true,  // Desbloquea el siguiente nivel de dificultad
          'coins': FieldValue.increment(200),  // Agrega 200 PY-Coins como recompensa
        });

        // Sincroniza con EconomiaProvider para mantener contadores actualizados localmente
        final economia = ref.read(economiaProviderNotifier);  // Obtiene el provider de economía
        await economia.sumarMonedas(200, esReto: true);  // Suma 200 monedas como reto e incrementa challenges_completed
      }

      _showResultDialog(title: "CÓDIGO DEPURADO", message: "¡ACCESO CONCEDIDO! Sistema desbloqueado.\nRecompensa: +200 PY-Coins.", isSuccess: true);  // Muestra el diálogo de éxito
    } else {  // Si el código no contiene el patrón de solución
      _handleFailure("SOLUCIÓN INCORRECTA");  // Maneja el fallo por solución incorrecta
    }
  }

  /// ═══ MÉTODO: _useHint ═══
  /// Permite al usuario comprar pistas descontando monedas
  Future<void> _useHint(int cost, int type) async {
    final user = FirebaseAuth.instance.currentUser;  // Obtiene el usuario autenticado actual
    if (user == null) return;  // Sale si no hay usuario autenticado

    final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();  // Obtiene el documento del usuario desde Firestore
    final currentCoins = doc.data()?['coins'] ?? 0;  // Obtiene las monedas actuales del usuario o 0 si no existen

    if (currentCoins >= cost) {  // Verifica si el usuario tiene suficientes monedas
      final economia = EconomiaProvider();  // Crea una instancia del proveedor de economía
      await economia.gastarMonedas(cost, 'pista');  // Gasta las monedas a través del proveedor de economía
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({'coins': FieldValue.increment(-cost)});  // Actualiza las monedas en Firebase restando el coste

      if (_currentChallenge != null) {  // Verifica que haya un reto cargado
        setState(() {  // Actualiza el estado del widget
          if (type == 3) _codeController!.text = _currentChallenge!.fullSolution;  // Si es pista tipo 3, revela la solución completa en el editor
        });
      }

      String msg = type == 1 ? (_currentChallenge?.specificHint ?? "") : type == 2 ? "ESTRUCTURA: Revisa el orden de los bucles y retornos." : "SOLUCIÓN INTEGRADA AUTOMÁTICAMENTE.";  // Determina el mensaje según el tipo de pista
      AppNotifications.show(context, "PISTA: $msg");  // Muestra la notificación de pista estandarizada
    } else {  // Si no tiene suficientes monedas
      AppNotifications.show(context, "CRÉDITOS INSUFICIENTES", isError: true);  // Muestra notificación de error por créditos insuficientes
    }
  }

  /// ═══ MÉTODO: _showResultDialog ═══
  /// Muestra un diálogo emergente con el resultado final del reto
  void _showResultDialog({required String title, required String message, required bool isSuccess}) {
    showDialog(context: context, barrierDismissible: false, builder: (context) => AlertDialog(  // Muestra un diálogo modal que no se puede cerrar tocando fuera
      backgroundColor: const Color(0xFF0D1B2A),  // Establece el color de fondo oscuro del diálogo
      actionsAlignment: MainAxisAlignment.center,  // Centra los botones de acción horizontalmente
      shape: RoundedRectangleBorder(side: BorderSide(color: isSuccess ? const Color(0xFF39FF14) : const Color(0xFFFF4C4C), width: 2)),  // Establece borde verde si es éxito o rojo si es fallo
      title: Text(title, textAlign: TextAlign.center, style: GoogleFonts.pressStart2p(color: isSuccess ? const Color(0xFF39FF14) : const Color(0xFFFF4C4C), fontSize: 14)),  // Muestra el título con fuente pixelada y color según resultado
      content: Column(mainAxisSize: MainAxisSize.min, children: [const PixelClipLogo(size: 100), const SizedBox(height: 20), Text(message, textAlign: TextAlign.center, style: GoogleFonts.shareTechMono(color: Colors.white, fontSize: 14))]),  // Contenido con logo, espaciado y mensaje
      actions: [Padding(padding: const EdgeInsets.all(15.0), child: Row(children: [  // Acciones del diálogo dentro de un padding
        if (isSuccess) Expanded(child: RetroButton(text: "SIGUIENTE NIVEL", style: RetroButtonStyle.primary, backgroundColor: const Color(0xFF39FF14), onPressed: () {  // Botón de siguiente nivel solo si tuvo éxito
          String nextDifficulty = 'intermediate';  // Dificultad siguiente por defecto
          if (widget.difficulty == 'intermediate') { nextDifficulty = 'advanced'; }  // Si ya está en intermedio, el siguiente es avanzado
          context.go('/quiz?difficulty=$nextDifficulty');  // Navega a la pantalla de quiz con la nueva dificultad
        })),
        if (isSuccess) const SizedBox(width: 10),  // Espaciado entre botones solo si hay botón de siguiente nivel
        Expanded(child: RetroButton(text: "VOLVER AL MENÚ", style: isSuccess ? RetroButtonStyle.secondary : RetroButtonStyle.danger, onPressed: () => context.go('/main_menu'))),  // Botón para volver al menú principal siempre visible
      ]))],
    ));
  }

  /// ═══ MÉTODO: dispose ═══
  /// Limpia recursos al destruir el widget para evitar memory leaks
  @override
  void dispose() {
    _timer?.cancel();  // Cancela el temporizador para detener las ejecuciones periódicas
    _codeController?.dispose();  // Libera el controlador de texto para evitar memory leaks
    super.dispose();  // Llama al dispose de la clase padre
  }

  /// ═══ MÉTODO: build ═══
  /// Construye la interfaz visual completa de la pantalla de challenge
  @override
  Widget build(BuildContext context) {
    if (_currentChallenge == null || _codeController == null) {  // Verifica si los datos del reto aún no están cargados
      return Scaffold(backgroundColor: AppTheme.darkBg, body: const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [CircularProgressIndicator(color: AppTheme.primaryCyan), SizedBox(height: 20), Text('CARGANDO DESAFÍO...', style: TextStyle(color: AppTheme.primaryCyan, fontFamily: 'PressStart2P', fontSize: 12))])));  // Muestra pantalla de carga con spinner y texto
    }

    const Color neonRed = Color(0xFFFF4C4C);  // Define el color rojo neón para alertas y énfasis
    const Color neonCyan = Color(0xFF00F2FF);  // Define el color cian neón para elementos secundarios
    const Color neonGreen = Color(0xFF39FF14);  // Define el color verde neón para código y éxito
    const Color neonBlue = Color(0xFF4BA3C3);  // Define el color azul neón para pistas y bordes
    const Color darkBg = Color(0xFF0D1B2A);  // Define el color de fondo oscuro principal

    return CRTOverlay(child: Scaffold(backgroundColor: darkBg, body: SafeArea(child: Column(children: [  // Envuelve todo en efecto CRT y Scaffold con área segura
      Expanded(child: SingleChildScrollView(padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [  // Contenido scrolleable con padding lateral
        _buildTopBar(neonRed), const SizedBox(height: 30),  // Construye la barra superior con timer y botón de salir
        Text("EL GRAN DESAFÍO", style: GoogleFonts.pressStart2p(color: neonRed, fontSize: 24, letterSpacing: 2)), const SizedBox(height: 10),  // Título principal en rojo neón con fuente pixelada
        Text("DE PYTHON", style: GoogleFonts.pressStart2p(color: neonCyan, fontSize: 12)), const SizedBox(height: 40),  // Subtítulo en cian neón con fuente pixelada
        _buildAlertBox(neonRed), const SizedBox(height: 30),  // Construye la caja de alerta crítica en rojo
        _buildDescriptionBox(neonCyan), const SizedBox(height: 30),  // Construye la caja de descripción del desafío en cian
        _buildCodeEditor(neonGreen), const SizedBox(height: 30),  // Construye el editor de código en verde
        _buildHintsBox(neonBlue), const SizedBox(height: 40),  // Construye la caja de pistas disponibles en azul
        _buildActionButtons(neonCyan, neonRed), const SizedBox(height: 60),  // Construye los botones de acción principales
      ]))),
      const AppFooter(borderColor: neonBlue),  // Pie de página con borde azul neón
    ]))));
  }

  /// ═══ MÉTODO: _buildTopBar ═══
  /// Construye la barra superior con botón de abandono y temporizador
  Widget _buildTopBar(Color color) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [  // Fila horizontal distribuida a los extremos
      GestureDetector(onTap: () => context.go('/main_menu'), child: Container(padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8), color: const Color(0xFF162431), child: Text("<- Abandonar Desafío", style: GoogleFonts.shareTechMono(color: const Color(0xFF4BA3C3), fontSize: 12)))),  // Botón táctil para volver al menú principal
      Container(padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10), decoration: BoxDecoration(border: Border.all(color: color, width: 2), color: Colors.black.withValues(alpha: 0.3)), child: Row(children: [  // Contenedor del temporizador con borde del color indicado
        Icon(Icons.access_time, color: color, size: 20), const SizedBox(width: 10),  // Icono de reloj con color dinámico
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("Tiempo restante:", style: GoogleFonts.shareTechMono(color: Colors.white60, fontSize: 10)), Text(_formatTime(_secondsRemaining), style: GoogleFonts.pressStart2p(color: color, fontSize: 16))]),  // Columna con etiqueta y tiempo formateado
      ])),
    ]);
  }

  /// ═══ MÉTODO: _buildAlertBox ═══
  /// Construye la caja de alerta crítica con estado del sistema
  Widget _buildAlertBox(Color color) {
    return _retroBox(borderColor: color, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [  // Caja retro con borde del color indicado
      Row(children: [Icon(Icons.bolt, color: color, size: 28), const SizedBox(width: 10), Text("¡ALERTA CRÍTICA!", style: GoogleFonts.pressStart2p(color: color, fontSize: 14))]),  // Fila con icono de rayo y texto de alerta
      const SizedBox(height: 20),  // Espaciado vertical
      Text("Has dominado lo básico... ¿Estás listo para el verdadero reto? El sistema ha detectado errores críticos en este fragmento de código. Tu misión: encontrar y corregir TODOS los errores antes de que se acabe el tiempo.", style: GoogleFonts.shareTechMono(color: Colors.white, fontSize: 13, height: 1.4)),  // Texto descriptivo de la misión
      const SizedBox(height: 20),  // Espaciado vertical
      Container(padding: const EdgeInsets.all(15), width: double.infinity, color: const Color(0xFF162431), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [  // Contenedor oscuro tipo terminal que ocupa todo el ancho
        _terminalLine(_systemStatus, _isSolved ? const Color(0xFF39FF14) : color),  // Línea de estado del sistema con color dinámico
        _terminalLine(_criticidadStatus, _isSolved ? const Color(0xFF39FF14) : color),  // Línea de nivel de criticidad con color dinámico
      ])),
    ]));
  }

  /// ═══ MÉTODO: _buildDescriptionBox ═══
  /// Construye la caja con la descripción del desafío y estadísticas
  Widget _buildDescriptionBox(Color color) {
    if (_currentChallenge == null) return const SizedBox.shrink();  // Retorna widget vacío si no hay reto cargado
    return _retroBox(borderColor: color, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [  // Caja retro con contenido en columna
      Text("DESCRIPCIÓN DEL DESAFÍO:", style: GoogleFonts.pressStart2p(color: color, fontSize: 12)),  // Etiqueta de descripción en fuente pixelada
      const SizedBox(height: 20),  // Espaciado vertical
      Text(_currentChallenge!.description, style: GoogleFonts.shareTechMono(color: Colors.white70, fontSize: 13, height: 1.4)),  // Texto descriptivo del reto actual
      const SizedBox(height: 25),  // Espaciado vertical
      Row(children: [_statBox("1", "Error Crítico", color), _statBox("200", "PY-Coins", color), _statBox("10:00", "Límite", color)]),  // Fila con tres cajas de estadísticas
    ]));
  }

  /// ═══ MÉTODO: _buildCodeEditor ═══
  /// Construye el editor de código donde el usuario escribe su solución
  Widget _buildCodeEditor(Color color) {
    return _retroBox(borderColor: color, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [  // Caja retro conteniendo el editor
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("EDITOR DE CÓDIGO:", style: GoogleFonts.pressStart2p(color: color, fontSize: 11)), Text("challenge.py", style: GoogleFonts.shareTechMono(color: Colors.white24, fontSize: 11))]),  // Fila con título del editor y nombre del archivo
      const SizedBox(height: 20),  // Espaciado vertical
      Container(padding: const EdgeInsets.all(15), color: Colors.black, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [  // Contenedor negro que simula un terminal
        TextField(controller: _codeController, maxLines: null, enabled: !_isSolved, style: GoogleFonts.firaCode(color: color, fontSize: 13, height: 1.5), decoration: const InputDecoration(border: InputBorder.none)),  // Campo de texto multilinea para escribir código
        const SizedBox(height: 20),  // Espaciado vertical
        Text("■ Line 9, Col 0", style: GoogleFonts.shareTechMono(color: color, fontSize: 10)),  // Indicador decorativo de línea y columna
      ])),
    ]));
  }

  /// ═══ MÉTODO: _buildHintsBox ═══
  /// Construye la sección de pistas disponibles con sus botones
  Widget _buildHintsBox(Color color) {
    return SizedBox(width: double.infinity, child: _retroBox(borderColor: color, child: Column(children: [  // Caja de ancho completo con pistas
      Text("PISTAS DISPONIBLES:", style: GoogleFonts.pressStart2p(color: color, fontSize: 11)),  // Título de la sección de pistas
      const SizedBox(height: 20),  // Espaciado vertical
      _hintButton("Pista 1: Revisa el nombre de la variables(costo: 50 PY_coins)", color, () => _useHint(50, 1)),  // Botón de pista 1 con coste de 50 monedas
      _hintButton("Pista 2: Verifica la estructura del bucle (costo: 100 Py_Coins )", color, () => _useHint(100, 2)),  // Botón de pista 2 con coste de 100 monedas
      _hintButton("Pista 3: Revela la solución completa (Costo: 150 Py-coins)", color, () => _useHint(150, 3)),  // Botón de pista 3 con coste de 150 monedas
    ])));
  }

  /// ═══ MÉTODO: _buildActionButtons ═══
  /// Construye los botones de ejecutar código y enviar solución
  Widget _buildActionButtons(Color cian, Color red) {
    return SizedBox(width: double.infinity, child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [  // Fila centrada con botones de acción
      RetroButton(text: "EJECUTAR CÓDIGO", style: RetroButtonStyle.primary, width: 220, height: 55, onPressed: () { AppNotifications.show(context, "COMPILANDO Y EJECUTANDO TEST..."); Future.delayed(const Duration(seconds: 1), _checkSolution); }),  // Botón que muestra notificación y verifica solución tras 1 segundo
      const SizedBox(width: 20),  // Espaciado entre botones
      RetroButton(text: _isSolved ? "FINALIZAR" : "ENVIAR SOLUCIÓN", style: _isSolved ? RetroButtonStyle.primary : RetroButtonStyle.danger, backgroundColor: _isSolved ? const Color(0xFF39FF14) : red, width: 220, height: 55, onPressed: _isSolved ? () => _showResultDialog(title: "CÓDIGO DEPURADO", message: "Acceso concedido. ¿Deseas avanzar?", isSuccess: true) : _checkSolution),  // Botón que cambia texto/color según estado y envía solución o finaliza
    ]));
  }

  /// ═══ MÉTODO: _retroBox ═══
  /// Widget auxiliar que crea una caja con estilo retro usando RetroContainer
  Widget _retroBox({required Color borderColor, required Widget child}) {
    return RetroContainer(isWin95: false, borderColor: borderColor, backgroundColor: Colors.black.withValues(alpha: 0.1), child: child);  // Crea RetroContainer con estética cyberpunk neón y fondo sutil
  }

  /// ═══ MÉTODO: _terminalLine ═══
  /// Crea una línea de texto con estilo de terminal monocromática
  Widget _terminalLine(String text, Color color) {
    return Padding(padding: const EdgeInsets.only(bottom: 5), child: Text(text, style: GoogleFonts.shareTechMono(color: color, fontSize: 12, fontWeight: FontWeight.bold)));  // Texto con fuente monoespaciada y padding inferior
  }

  /// ═══ MÉTODO: _statBox ═══
  /// Crea una caja de estadística con valor y etiqueta
  Widget _statBox(String value, String label, Color color) {
    return Expanded(child: Container(padding: const EdgeInsets.symmetric(vertical: 10), margin: const EdgeInsets.symmetric(horizontal: 5), decoration: BoxDecoration(border: Border.all(color: color.withValues(alpha: 0.3))), child: Column(children: [Text(value, style: GoogleFonts.pressStart2p(color: color, fontSize: 12)), const SizedBox(height: 5), Text(label, style: GoogleFonts.shareTechMono(color: Colors.white60, fontSize: 10))])));  // Caja expandida con valor en fuente pixelada y etiqueta en monoespaciada
  }

  /// ═══ MÉTODO: _hintButton ═══
  /// Crea un botón de pista con icono de bombilla y estilo retro
  Widget _hintButton(String text, Color color, VoidCallback onTap) {
    return Padding(padding: const EdgeInsets.only(bottom: 12), child: SizedBox(width: double.infinity, child: RetroButton(text: text, style: RetroButtonStyle.secondary, icon: Icons.lightbulb, iconColor: Colors.yellow, textColor: Colors.black, fontSize: 9, width: double.infinity, alignment: MainAxisAlignment.start, onPressed: onTap)));  // Botón de pista con icono de bombilla amarilla y texto negro
  }
}
