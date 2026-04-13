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
import 'dart:async';  // importa la biblioteca de timers para operaciones temporizadas
import 'package:flutter/material.dart';  // importa el framework base de Flutter para construir la UI
import 'package:flutter_riverpod/flutter_riverpod.dart';  // importa Riverpod para gestión de estado reactivo
import 'package:go_router/go_router.dart';  // importa el sistema de enrutamiento declarativo go_router
import 'package:google_fonts/google_fonts.dart';  // importa Google Fonts para usar tipografías personalizadas
import '../theme/app_theme.dart';  // importa las definiciones de colores y estilos globales de la app
import '../widgets/typewriter_text.dart';  // importa el widget de texto con efecto de máquina de escribir
import '../widgets/pixel_clip_logo.dart';  // importa el widget del logo pixelado decorativo
import '../providers/firebase_providers.dart';  // importa los providers de Firebase para verificar autenticación

/// ═══════════════════════════════════════════════════════
/// CLASE: SplashScreen
/// Pantalla de carga con estética retro IBM/Terminal.
/// Fondo uniforme #0D1B2A con barra de progreso y logs.
/// Muestra un logo animado, barra de progreso animada,
/// texto typewriter, logs de consola simulados y un
/// indicador de espera parpadeante.
/// Navega automáticamente al verificar el estado de auth.
/// ═══════════════════════════════════════════════════════
class SplashScreen extends ConsumerStatefulWidget {  // widget con estado que puede leer providers de Riverpod
  const SplashScreen({super.key});  // constructor constante que pasa la key al padre

  @override  // sobrescribe el método createState del StatefulWidget
  ConsumerState<SplashScreen> createState() => _SplashScreenState();  // crea el estado asociado a esta pantalla
}

/// ═══════════════════════════════════════════════════════
/// CLASE: _SplashScreenState
/// Estado privado de SplashScreen.
/// Maneja la animación del logo, el parpadeo del cursor,
/// el timer de la barra de progreso y la navegación
/// automática según el estado de autenticación.
/// Usa TickerProviderStateMixin para múltiples animaciones
/// (logo rotatorio y cursor parpadeante).
/// ═══════════════════════════════════════════════════════
class _SplashScreenState extends ConsumerState<SplashScreen>  // estado que tiene acceso al ref de Riverpod
    with TickerProviderStateMixin {  // mixin que proporciona TickerProvider para múltiples animaciones
  double _progress = 0.0;  // valor de progreso de la barra de carga (de 0.0 a 1.0)
  int _secondsLeft = 3;  // contador regresivo de segundos restantes
  late AnimationController _logoAnimationController;  // controlador de animación para el logo rotatorio (se inicializa en initState)
  late AnimationController _blinkController;  // controlador de animación para el parpadeo del cursor (se inicializa en initState)
  late Timer _timer;  // timer periódico que actualiza la barra de progreso (se inicializa en initState)
  bool _startTypewriter = false;  // bandera que controla cuándo iniciar el efecto typewriter

  @override  // sobrescribe el método de inicialización del estado
  void initState() {  // se ejecuta una vez cuando el estado se crea
    super.initState();  // llama al initState del padre para mantener el ciclo de vida

    _logoAnimationController = AnimationController(  // crea el controlador de animación para el logo rotatorio
      vsync: this,  // usa este estado como vsync para sincronizar con la tasa de refresco de la pantalla
      duration: const Duration(seconds: 4),  // duración de 4 segundos por rotación completa
    )..repeat();  // repite la animación infinitamente sin inversión

    _blinkController = AnimationController(  // crea el controlador de animación para el parpadeo
      vsync: this,  // usa este estado como vsync para sincronizar con la tasa de refresco de la pantalla
      duration: const Duration(milliseconds: 500),  // duración de medio segundo por ciclo de animación
    )..repeat(reverse: true);  // repite la animación infinitamente invirtiendo la dirección en cada ciclo

    Future.delayed(const Duration(milliseconds: 500), () {  // programa una acción con retraso de medio segundo
      if (mounted) setState(() => _startTypewriter = true);  // activa el typewriter si el widget sigue montado
    });

    _startLoading();  // inicia la secuencia de carga con el timer de progreso
  }

  /// ═══════════════════════════════════════════════════════
  /// MÉTODO: _startLoading
  /// Inicia un timer periódico que actualiza la barra de
  /// progreso cada 50ms durante 3 segundos totales.
  /// Al completar, llama a _checkAuthAndNavigate().
  /// ═══════════════════════════════════════════════════════
  void _startLoading() {  // inicia la secuencia de carga con timer
    const totalDuration = Duration(seconds: 3);  // duración total de la carga es de 3 segundos
    const tick = Duration(milliseconds: 50);  // intervalo de actualización de 50 milisegundos
    int elapsed = 0;  // contador de milisegundos transcurridos

    _timer = Timer.periodic(tick, (timer) {  // crea un timer que se ejecuta cada 50ms
      if (!mounted) {  // verifica si el widget ya fue desmontado
        timer.cancel();  // cancela el timer para evitar operaciones en widget desmontado
        return;  // sale del callback sin hacer nada más
      }
      elapsed += 50;  // incrementa el tiempo transcurrido en 50 milisegundos
      setState(() {  // actualiza el estado para reconstruir la UI
        _progress = elapsed / totalDuration.inMilliseconds;  // calcula el progreso como fracción (0.0 a 1.0)
        _secondsLeft = 3 - (elapsed ~/ 1000);  // calcula los segundos restantes dividiendo elapsed entre 1000
      });

      if (elapsed >= totalDuration.inMilliseconds) {  // verifica si se alcanzó la duración total
        timer.cancel();  // cancela el timer periódico
        _checkAuthAndNavigate();  // verifica la autenticación y navega a la pantalla correspondiente
      }
    });
  }

  /// ═══════════════════════════════════════════════════════
  /// MÉTODO: _checkAuthAndNavigate
  /// Verifica el estado de autenticación del usuario y
  /// navega al main_menu si está logueado, o a inicio
  /// si no lo está (o hay error/loading).
  /// ═══════════════════════════════════════════════════════
  void _checkAuthAndNavigate() {  // verifica auth y decide a dónde navegar
    final authState = ref.read(authStateProvider);  // lee el estado actual del provider de autenticación de Firebase

    authState.when(  // patrón when para manejar los diferentes estados async del provider
      data: (user) {  // caso cuando los datos están disponibles
        if (user != null) {  // si existe un usuario autenticado
          context.go('/main_menu');  // navega al menú principal reemplazando la ruta actual
        } else {  // si no hay usuario autenticado
          context.go('/inicio');  // navega a la pantalla de inicio
        }
      },
      loading: () => context.go('/inicio'),  // si aún está cargando, navega a inicio
      error: (_, __) => context.go('/inicio'),  // si hay error, navega a inicio ignorando los parámetros de error
    );
  }

  @override  // sobrescribe el método de limpieza del estado
  void dispose() {  // se ejecuta cuando el estado se destruye
    _logoAnimationController.dispose();  // libera los recursos del controlador de animación del logo
    _blinkController.dispose();  // libera los recursos del controlador de animación del parpadeo
    _timer.cancel();  // cancela el timer para evitar fugas de memoria
    super.dispose();  // llama al dispose del padre para mantener el ciclo de vida
  }

  @override  // sobrescribe el método build para construir la interfaz visual
  Widget build(BuildContext context) {  // construye la pantalla de splash
    return Scaffold(  // widget raíz que proporciona la estructura básica de la pantalla
      backgroundColor: AppTheme.darkBg,  // establece el color de fondo oscuro definido en el tema
      body: Stack(  // apila widgets uno encima de otro (logo de fondo oculto + contenido visible)
        children: [  // lista de widgets apilados
          const Offstage(offstage: true, child: PixelClipLogo()),  // logo pixelado oculto (solo para carga de recursos)
          Center(  // centra el contenido principal horizontal y verticalmente
            child: Column(  // dispone los elementos en columna vertical
              children: [  // lista de widgets del splash en orden
                const Spacer(flex: 10),  // espacio flexible que empuja el contenido hacia abajo con flex 10
                _buildPixelArtLogo(),  // construye el logo animado con rotación y esquinas decorativas
                const SizedBox(height: 60),  // espacio vertical de 60 píxeles debajo del logo
                Text(  // texto con el nombre de la aplicación
                  'Python_Quizz_Flash',  // nombre de la app
                  style: GoogleFonts.pressStart2p(  // aplica la fuente pixelada Press Start 2P
                    color: AppTheme.brightCyan,  // color cian brillante del tema
                    fontSize: 22,  // tamaño de fuente de 22 píxeles
                  ),
                ),
                const SizedBox(height: 60),  // espacio vertical de 60 píxeles debajo del título
                _buildProgressBar(),  // construye la barra de progreso animada con porcentaje
                const SizedBox(height: 24),  // espacio vertical de 24 píxeles debajo de la barra
                if (_startTypewriter)  // condicional que verifica si debe mostrar el typewriter
                  TypewriterText(  // widget de texto con efecto de escritura progresiva
                    text: 'Cargando sistema ...',  // texto que se escribe carácter por carácter
                    speed: const Duration(milliseconds: 100),  // velocidad de escritura de 100ms por carácter
                    style: GoogleFonts.ibmPlexMono(  // aplica la fuente IBM Plex Mono
                      color: AppTheme.consoleGrey,  // color gris de consola del tema
                      fontSize: 12,  // tamaño de fuente de 12 píxeles
                      fontWeight: FontWeight.w500,  // peso de fuente medio
                    ),
                  ),
                const SizedBox(height: 40),  // espacio vertical de 40 píxeles debajo del typewriter
                _buildConsoleLogs(),  // construye los logs de consola simulados
                const SizedBox(height: 60),  // espacio vertical de 60 píxeles debajo de los logs
                _buildWaitIndicator(),  // construye el indicador de espera parpadeante
                const Spacer(flex: 12),  // espacio flexible que empuja el contenido superior con flex 12
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ═══════════════════════════════════════════════════════
  /// MÉTODO: _buildWaitIndicator
  /// Construye un indicador de espera con un cuadrado
  /// parpadeante y el texto "WAIT ..." estilo retro.
  /// ═══════════════════════════════════════════════════════
  Widget _buildWaitIndicator() {  // construye el indicador de espera con cursor parpadeante
    return Row(  // dispone los elementos en fila horizontal
      mainAxisAlignment: MainAxisAlignment.center,  // centra los elementos horizontalmente
      children: [  // lista de widgets del indicador
        FadeTransition(  // transición de opacidad para el efecto de parpadeo
          opacity: _blinkController,  // vincula la opacidad al controlador de animación de parpadeo
          child: Container(width: 12, height: 12, color: AppTheme.brightCyan),  // cuadrado cian de 12x12 píxeles
        ),
        const SizedBox(width: 15),  // espacio horizontal de 15 píxeles entre cuadrado y texto
        Text(  // texto de espera estilo retro
          'WAIT ...',  // texto con puntos suspensivos
          style: GoogleFonts.pressStart2p(  // aplica la fuente pixelada Press Start 2P
            color: AppTheme.brightCyan,  // color cian brillante del tema
            fontSize: 12,  // tamaño de fuente de 12 píxeles
            letterSpacing: 4,  // espaciado entre letras de 4 píxeles para efecto retro
          ),
        ),
      ],
    );
  }

  /// ═══════════════════════════════════════════════════════
  /// MÉTODO: _buildPixelArtLogo
  /// Construye el logo animado con rotación continua,
  /// marco cuadrado con esquinas decorativas y texto "</>"
  /// centrado, todo con estética cyberpunk/cian.
  /// ═══════════════════════════════════════════════════════
  Widget _buildPixelArtLogo() {  // construye el logo pixelado animado
    return AnimatedBuilder(  // widget que reconstruye cuando cambia la animación
      animation: _logoAnimationController,  // vincula la reconstrucción al controlador de animación del logo
      builder: (context, child) {  // función builder que se ejecuta en cada frame de la animación
        const double boxSize = 140.0;  // tamaño constante del contenedor cuadrado del logo
        return Stack(  // apila los elementos del logo (cuadro rotatorio + marco fijo)
          alignment: Alignment.center,  // centra los elementos apilados
          children: [  // lista de widgets apilados del logo
            Transform.rotate(  // aplica una transformación de rotación
              angle: _logoAnimationController.value * 2 * 3.14159,  // calcula el ángulo como fracción de vuelta completa (2*pi)
              child: Container(  // contenedor que rota con la animación
                width: boxSize - 15,  // ancho 15 píxeles menor que el contenedor exterior
                height: boxSize - 15,  // alto 15 píxeles menor que el contenedor exterior
                decoration: BoxDecoration(  // decoración del contenedor rotatorio
                  color: AppTheme.brightCyan.withValues(alpha: 0.1),  // color cian muy transparente al 10%
                  border: Border.all(  // borde del contenedor
                    color: AppTheme.brightCyan.withValues(alpha: 0.2),  // cian semitransparente al 20%
                    width: 1,  // grosor del borde de 1 píxel
                  ),
                ),
              ),
            ),
            Container(  // contenedor exterior fijo que forma el marco del logo
              width: boxSize,  // ancho de 140 píxeles
              height: boxSize,  // alto de 140 píxeles
              decoration: BoxDecoration(  // decoración del marco exterior
                border: Border.all(color: AppTheme.brightCyan, width: 2),  // borde cian sólido de 2 píxeles
              ),
              child: Stack(  // apila las esquinas y el texto central dentro del marco
                children: [  // lista de elementos dentro del marco
                  _buildCorner(top: 0, left: 0, isTop: true, isLeft: true),  // esquina superior izquierda
                  _buildCorner(top: 0, right: 0, isTop: true, isLeft: false),  // esquina superior derecha
                  _buildCorner(bottom: 0, left: 0, isTop: false, isLeft: true),  // esquina inferior izquierda
                  _buildCorner(  // esquina inferior derecha
                    bottom: 0,  // posicionada en la parte inferior
                    right: 0,  // posicionada en el lado derecho
                    isTop: false,  // indica que no es esquina superior
                    isLeft: false,  // indica que no es esquina izquierda
                  ),

                  const Center(  // centra el texto de código en el medio del logo
                    child: Text(  // texto con símbolos de código
                      '</>',  // símbolos de apertura y cierre de etiqueta HTML/XML
                      style: TextStyle(  // estilo del texto de código
                        color: AppTheme.brightCyan,  // color cian brillante del tema
                        fontSize: 50,  // tamaño de fuente grande de 50 píxeles
                        fontWeight: FontWeight.bold,  // peso de fuente en negrita
                        fontFamily: 'monospace',  // familia de fuente monoespaciada
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  /// ═══════════════════════════════════════════════════════
  /// MÉTODO: _buildCorner
  /// Construye una esquina decorativa tipo marco pixelado
  /// con líneas horizontales y verticales de 4 píxeles
  /// de grosor. Se posiciona según los parámetros.
  /// ═══════════════════════════════════════════════════════
  Widget _buildCorner({  // construye una esquina decorativa del marco
    double? top,  // posición opcional desde la parte superior
    double? bottom,  // posición opcional desde la parte inferior
    double? left,  // posición opcional desde la izquierda
    double? right,  // posición opcional desde la derecha
    required bool isTop,  // indica si la esquina está en la parte superior (obligatorio)
    required bool isLeft,  // indica si la esquina está en el lado izquierdo (obligatorio)
  }) {
    return Positioned(  // widget que posiciona un hijo dentro de un Stack
      top: top,  // posición desde arriba (null si no aplica)
      bottom: bottom,  // posición desde abajo (null si no aplica)
      left: left,  // posición desde la izquierda (null si no aplica)
      right: right,  // posición desde la derecha (null si no aplica)
      child: SizedBox(  // contenedor de tamaño fijo para la esquina
        width: 15,  // ancho de 15 píxeles
        height: 15,  // alto de 15 píxeles
        child: Stack(  // apila las líneas horizontal y vertical de la esquina
          children: [  // lista de elementos de la esquina
            Positioned(  // posiciona la línea horizontal
              top: isTop ? 0 : null,  // si es esquina superior, se fija en top 0
              bottom: isTop ? null : 0,  // si es esquina inferior, se fija en bottom 0
              left: 0,  // alineado a la izquierda del contenedor de esquina
              right: 0,  // alineado a la derecha del contenedor de esquina
              child: Container(height: 4, color: AppTheme.brightCyan),  // línea horizontal de 4 píxeles de grosor en cian
            ),
            Positioned(  // posiciona la línea vertical
              top: 0,  // fijada en la parte superior del contenedor
              bottom: 0,  // fijada en la parte inferior del contenedor
              left: isLeft ? 0 : null,  // si es esquina izquierda, se fija en left 0
              right: isLeft ? null : 0,  // si es esquina derecha, se fija en right 0
              child: Container(width: 4, color: AppTheme.brightCyan),  // línea vertical de 4 píxeles de grosor en cian
            ),
          ],
        ),
      ),
    );
  }

  /// ═══════════════════════════════════════════════════════
  /// MÉTODO: _buildProgressBar
  /// Construye la barra de progreso con borde cian, relleno
  /// animado según _progress y porcentaje centrado que
  /// cambia de color según el avance (negro o cian).
  /// ═══════════════════════════════════════════════════════
  Widget _buildProgressBar() {  // construye la barra de progreso visual
    return Container(  // contenedor principal de la barra
      width: 320,  // ancho fijo de 320 píxeles
      height: 28,  // alto fijo de 28 píxeles
      decoration: BoxDecoration(  // decoración del borde exterior
        border: Border.all(color: AppTheme.primaryCyan, width: 2),  // borde cyan del tema de 2 píxeles
      ),
      child: Stack(  // apila el fondo de progreso y el texto de porcentaje
        children: [  // lista de elementos de la barra
          FractionallySizedBox(  // widget que ocupa una fracción del ancho disponible
            widthFactor: _progress,  // factor de ancho basado en el valor de progreso (0.0 a 1.0)
            child: Container(color: AppTheme.brightCyan),  // relleno cian brillante de la barra
          ),
          Center(  // centra el texto de porcentaje
            child: Text(  // muestra el porcentaje numérico actual
              '${(_progress * 100).toInt()}%',  // convierte el progreso a porcentaje entero (ej: "75%")
              style: GoogleFonts.pressStart2p(  // aplica la fuente pixelada Press Start 2P
                fontSize: 10,  // tamaño de fuente de 10 píxeles
                color: _progress > 0.5 ? Colors.black : AppTheme.brightCyan,  // cambia a negro si pasa del 50% para contraste
                fontWeight: FontWeight.bold,  // peso de fuente en negrita
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ═══════════════════════════════════════════════════════
  /// MÉTODO: _buildConsoleLogs
  /// Construye los mensajes de consola simulados que
  /// simulan la carga de módulos, base de datos y
  /// entorno Python, mostrando también el countdown.
  /// ═══════════════════════════════════════════════════════
  Widget _buildConsoleLogs() {  // construye los logs de consola simulados
    final style = GoogleFonts.ibmPlexMono(  // define el estilo base para todos los logs
      color: AppTheme.brightCyan,  // color cian brillante del tema
      fontSize: 11,  // tamaño de fuente de 11 píxeles
    );
    return SizedBox(  // contenedor de ancho fijo para los logs
      width: 320,  // ancho de 320 píxeles
      child: Column(  // dispone los mensajes de log en columna vertical
        crossAxisAlignment: CrossAxisAlignment.start,  // alinea los textos a la izquierda
        children: [  // lista de mensajes de log
          Text('> Inicializando módulos ...', style: style),  // primer mensaje de log de inicialización
          const SizedBox(height: 6),  // espacio vertical de 6 píxeles entre mensajes
          Text('> Cargando base de datos ...', style: style),  // segundo mensaje de log de carga de BD
          const SizedBox(height: 6),  // espacio vertical de 6 píxeles entre mensajes
          Text('> Preparando entorno Python ...', style: style),  // tercer mensaje de log de preparación
          const SizedBox(height: 12),  // espacio vertical de 12 píxeles antes del countdown
          Text(  // mensaje de countdown con los segundos restantes
            '> Sistema listo en ${_secondsLeft}s',  // muestra los segundos que faltan dinámicamente
            style: style.copyWith(fontWeight: FontWeight.bold),  // usa el mismo estilo pero con negrita
          ),
        ],
      ),
    );
  }
}
