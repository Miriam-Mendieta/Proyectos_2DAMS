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

import 'package:flutter/material.dart';  // Importa el framework base de Flutter con widgets Material Design
import 'package:flutter_riverpod/flutter_riverpod.dart';  // Importa Riverpod para gestión de estado reactivo
import 'package:cloud_firestore/cloud_firestore.dart';  // Importa Firestore para acceso a la base de datos en la nube
import 'package:firebase_auth/firebase_auth.dart';  // Importa Firebase Authentication para gestión de usuarios
import 'package:intl/intl.dart';  // Importa la librería intl para formateo de fechas y números
import 'package:google_fonts/google_fonts.dart';  // Importa Google Fonts para tipografías personalizadas
import '../theme/app_theme.dart';  // Importa el tema centralizado de la aplicación (colores, estilos)
import '../widgets/app_header_buttons.dart';  // Importa el widget de botones del encabezado de la app
import '../widgets/crt_overlay.dart';  // Importa el efecto de superposición CRT estilo retro
import '../widgets/app_footer.dart';  // Importa el widget del pie de página de la aplicación
import '../widgets/pixel_clip_logo.dart';  // Importa el widget del logo PixelClip con estilo pixelado
import '../providers/economia_provider.dart';  // Importa el provider de economía para gestionar monedas y estadísticas

/// ═══ CLASE: LogrosScreen ═══
/// Pantalla de Logros - Muestra estadísticas, insignias e historial de transacciones del usuario.
/// Extiende ConsumerWidget para poder acceder a providers de Riverpod.
class LogrosScreen extends ConsumerWidget {
  const LogrosScreen({super.key});  // Constructor con key opcional para optimización de Flutter

  @override
  Widget build(BuildContext context, WidgetRef ref) {  // Método de construcción del widget tree con acceso a Riverpod
    final user = FirebaseAuth.instance.currentUser;  // Obtiene el usuario actualmente autenticado en Firebase
    if (user == null)  // Verifica si no hay usuario autenticado
      return const Scaffold(body: Center(child: CircularProgressIndicator()));  // Retorna indicador de carga si no hay usuario

    const Color neonCian = Color(0xFF00F2FF);  // Define color cian neón para elementos destacados
    const Color pyYellow = Color(0xFFFFB800);  // Define color amarillo estilo Python para acentos
    const Color bgBlue = Color(0xFF0D1B2A);  // Define color azul oscuro para el fondo de la pantalla

    return CRTOverlay(  // Envuelve todo con efecto de overlay CRT retro
      child: Scaffold(  // Crea la estructura base de la pantalla Material
        backgroundColor: bgBlue,  // Establece el color de fondo azul oscuro
        body: LayoutBuilder(  // Widget que permite construir UI basada en las restricciones de tamaño
          builder: (context, constraints) {  // Función constructora que recibe contexto y restricciones
            final bool isMobile = constraints.maxWidth < 700;  // Determina si es vista móvil (ancho menor a 700px)
            final double sidePadding = isMobile ? 16.0 : 80.0;  // Ajusta padding lateral según tipo de dispositivo

            return Stack(  // Widget que permite superponer hijos (para footer posicionado)
              children: [  // Lista de widgets hijos del Stack
                SafeArea(  // Asegura que el contenido no quede detrás de barras del sistema
                  child: SingleChildScrollView(  // Permite scroll vertical para contenido largo
                    padding: EdgeInsets.fromLTRB(sidePadding, 20, sidePadding, 120),  // Padding: izq, arriba, der, abajo (120 para el footer)
                    child: Consumer(  // Widget para acceder a Riverpod dentro del árbol
                      builder: (context, ref, child) {  // Función constructora con acceso a ref
                        final economia = ref.watch(economiaProvider);  // Observa el provider de economía para obtener datos reactivos
                        final int pyCoins = economia.coins;  // Extrae las PyCoins actuales del usuario
                        final int totalEarned = economia.totalEarned;  // Extrae el total de monedas ganadas históricamente
                        final int totalExercises = economia.totalExercises;  // Extrae el total de ejercicios realizados
                        final int exercisesFailed = economia.exercisesFailed;  // Extrae la cantidad de ejercicios fallados
                        final int hintsSpent = economia.hintsSpent;  // Extrae las monedas gastadas en pistas
                        final int shopSpent = economia.shopSpent;  // Extrae las monedas gastadas en la tienda

                        return StreamBuilder<DocumentSnapshot>(  // Escucha cambios en tiempo real del documento del usuario en Firestore
                          stream: FirebaseFirestore.instance  // Obtiene la instancia de Firestore
                              .collection('users')  // Accede a la colección 'users'
                              .doc(user.uid)  // Selecciona el documento con el ID del usuario actual
                              .snapshots(),  // Crea un stream de actualizaciones en tiempo real
                          builder: (context, snapshot) {  // Función constructora que recibe el estado del snapshot
                            final data = snapshot.data?.data() as Map<String, dynamic>? ?? {};  // Extrae los datos del documento o mapa vacío
                            final bool win1 = data['challenge_basic_completed'] == true;  // Verifica si completó el desafío básico
                            final bool win2 = data['challenge_intermediate_completed'] == true;  // Verifica si completó el desafío intermedio
                            final bool win3 = data['challenge_advanced_completed'] == true;  // Verifica si completó el desafío avanzado
                            final int count = (win1 ? 2 : 0) + (win2 ? 2 : 0) + (win3 ? 3 : 0);  // Calcula insignias desbloqueadas (2 por básico/intermedio, 3 por avanzado)
                            final int ejerciciosResueltos = economia.exercisesCompleted;  // Obtiene ejercicios completados del provider de economía
                            final double porcentajeCompletado = economia.exercisesCompleted / 73 * 100;  // Calcula porcentaje del total de 73 ejercicios

                            return Column(  // Columna principal que organiza los elementos verticalmente
                              crossAxisAlignment: CrossAxisAlignment.start,  // Alinea hijos al inicio horizontal (izquierda)
                              children: [  // Lista de widgets hijos de la columna
                                const AppHeaderButtons(),  // Muestra botones de navegación del encabezado
                                const SizedBox(height: 30),  // Espacio vertical de 30px antes del título
                                Text("MIS LOGROS", style: GoogleFonts.pressStart2p(color: neonCian, fontSize: 22)),  // Título principal con fuente pixelada en cian
                                const SizedBox(height: 25),  // Espacio vertical de 25px después del título
                                GridView.count(  // Grid de estadísticas con conteo fijo de columnas
                                  shrinkWrap: true,  // Ajusta el tamaño del grid a su contenido
                                  physics: const NeverScrollableScrollPhysics(),  // Deshabilita scroll propio del grid (usa el del padre)
                                  crossAxisCount: isMobile ? 2 : 4,  // 2 columnas en móvil, 4 en pantallas grandes
                                  mainAxisSpacing: 15,  // Espacio vertical entre items del grid
                                  crossAxisSpacing: 15,  // Espacio horizontal entre items del grid
                                  childAspectRatio: 1.4,  // Relación ancho/alto de cada celda (más ancho que alto)
                                  children: [  // Lista de tarjetas de estadísticas
                                    _buildTopCard("PY-COINS GANADOS", "$totalEarned", Icons.add_circle, neonCian),  // Tarjeta de monedas ganadas con ícono de suma
                                    _buildTopCard("EJERCICIOS COMPLETADOS", "${economia.exercisesCompleted}", Icons.code, neonCian),  // Tarjeta de ejercicios completados
                                    _buildTopCard("PY-COINS GASTADOS", "${hintsSpent + shopSpent}", Icons.remove_circle, neonCian),  // Tarjeta de monedas gastadas (pistas + tienda)
                                    _buildTopCard("PY-COINS TOTALES", "$pyCoins", Icons.monetization_on, pyYellow),  // Tarjeta de monedas actuales en amarillo
                                  ],
                                ),
                                const SizedBox(height: 35),  // Espacio vertical antes de la sección de insignias
                                _sectionTitle("INSIGNIAS / LOGROS:"),  // Título de sección para insignias
                                const SizedBox(height: 15),  // Espacio vertical después del título de sección
                                _insigniaBox([  // Contenedor estilizado para las insignias
                                  Wrap(spacing: 15, runSpacing: 15, alignment: WrapAlignment.start, children: [  // Wrap permite múltiples líneas de badges con espaciado
                                    _badge("MAESTRO BÁSICO", "🎓", win1, isMobile),  // Badge de maestro básico (condicional al win1)
                                    _badge("1RA VICTORIA", "🏆", win1, isMobile),  // Badge de primera victoria (condicional al win1)
                                    _badge("NIVEL INTERMEDIO", "💎", win2, isMobile),  // Badge de nivel intermedio (condicional al win2)
                                    _badge("2DA VICTORIA", "🔥", win2, isMobile),  // Badge de segunda victoria (condicional al win2)
                                    _badge("NIVEL AVANZADO", "⚡", win3, isMobile),  // Badge de nivel avanzado (condicional al win3)
                                    _badge("3RA VICTORIA", "⭐", win3, isMobile),  // Badge de tercera victoria (condicional al win3)
                                    _badge("MAESTRO PYTHON", "👑", win3, isMobile),  // Badge de maestro Python (condicional al win3)
                                  ]),
                                  const SizedBox(height: 15),  // Espacio vertical entre badges y contador
                                  const Divider(color: Colors.white10),  // Línea divisoria sutil blanca
                                  Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Row(  // Fila con padding vertical para el contador de insignias
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,  // Distribuye espacio entre extremos de la fila
                                    children: [  // Hijos de la fila
                                      Text("INSIGNIAS DESBLOQUEADAS:", style: GoogleFonts.shareTechMono(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.bold)),  // Etiqueta en fuente mono blanca semitransparente
                                      Text("$count / 7", style: GoogleFonts.pressStart2p(color: neonCian, fontSize: 12)),  // Contador numérico estilo pixelado en cian
                                    ],
                                  )),
                                ]),
                                const SizedBox(height: 35),  // Espacio vertical antes del historial
                                _sectionTitle("HISTORIAL DE TRANSACCIONES:"),  // Título de sección para el historial
                                const SizedBox(height: 15),  // Espacio vertical después del título
                                _activityContainer([  // Contenedor estilizado para la lista de actividades
                                  // ═══ PUNTOS POR NIVEL COMPLETADO (no totales) ═══
                                  if (win1) _historyItem("NIVEL BÁSICO COMPLETADO", DateFormat('dd/MM/yyyy').format(DateTime.now()), "+200", true),  // Muestra puntos del nivel básico (solo si está completado)
                                  if (win2) _historyItem("NIVEL INTERMEDIO COMPLETADO", DateFormat('dd/MM/yyyy').format(DateTime.now()), "+200", true),  // Muestra puntos del nivel intermedio (solo si está completado)
                                  if (win3) _historyItem("NIVEL AVANZADO COMPLETADO", DateFormat('dd/MM/yyyy').format(DateTime.now()), "+200", true),  // Muestra puntos del nivel avanzado (solo si está completado)
                                  // ═══ PUNTOS POR RETOS COMPLETADOS ═══
                                  if (win1) _historyItem("RETO BÁSICO COMPLETADO", DateFormat('dd/MM/yyyy').format(DateTime.now()), "+200", true),  // Muestra puntos del reto básico (solo si está completado)
                                  if (win2) _historyItem("RETO INTERMEDIO COMPLETADO", DateFormat('dd/MM/yyyy').format(DateTime.now()), "+200", true),  // Muestra puntos del reto intermedio (solo si está completado)
                                  if (win3) _historyItem("RETO AVANZADO COMPLETADO", DateFormat('dd/MM/yyyy').format(DateTime.now()), "+200", true),  // Muestra puntos del reto avanzado (solo si está completado)
                                  // ═══ GASTOS Y FALLOS ═══
                                  if (exercisesFailed > 0) _historyItem("EJERCICIOS FALLIDOS", DateFormat('dd/MM/yyyy').format(DateTime.now()), "$exercisesFailed", false, isError: true),  // Item de ejercicios fallados en naranja (sin signo + o -)
                                  if (hintsSpent > 0) _historyItem("COMPRA DE PISTAS", DateFormat('dd/MM/yyyy').format(DateTime.now()), "-$hintsSpent", false),  // Item de gasto en pistas (solo si hay gasto)
                                  if (shopSpent > 0) _historyItem("COMPRAS EN TIENDA", DateFormat('dd/MM/yyyy').format(DateTime.now()), "-$shopSpent", false),  // Item de gasto en tienda (solo si hay gasto)
                                ]),
                                const SizedBox(height: 40),  // Espacio vertical antes del logo pixel clip
                                _pixelClipQuizStyle(neonCian),  // Widget del PixelClip con mensaje motivacional
                                const SizedBox(height: 30),  // Espacio vertical antes del bloque de log
                                Container(  // Contenedor estilizado como terminal de logs
                                  width: double.infinity,  // Ancho completo disponible
                                  padding: const EdgeInsets.all(12),  // Padding interno de 12px
                                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.4), border: Border.all(color: neonCian.withOpacity(0.2), width: 1.5)),  // Fondo negro semitransparente con borde cian sutil
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [  // Columna alineada a la izquierda para líneas de log
                                    _buildLogText("> ESTADÍSTICAS_GENERADAS: ${DateFormat('dd/MM/yyyy, HH:mm:ss').format(DateTime.now())}"),  // Línea de log con fecha/hora actual
                                    _buildLogText("> EJERCICIOS_RESUELTOS: $ejerciciosResueltos / 73 (${porcentajeCompletado.toStringAsFixed(2)}%)"),  // Línea de log con ejercicios resueltos y porcentaje
                                    _buildLogText("> EJERCICIOS_ERRADOS: $exercisesFailed"),  // Línea de log con ejercicios fallados
                                    _buildLogText("> PORCENTAJE_COMPLETADO: ${porcentajeCompletado.toStringAsFixed(2)}%"),  // Línea de log con porcentaje completado
                                    Row(children: [_buildLogText("> STATUS: PROGRESANDO"), const SizedBox(width: 5), const _BlinkingCursor()]),  // Fila con status y cursor parpadeante
                                  ]),
                                ),
                                const SizedBox(height: 50),  // Espacio vertical final después del log
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                Positioned(bottom: 0, left: 0, right: 0, child: AppFooter(borderColor: AppTheme.borderBlue)),  // Footer posicionado en la parte inferior de la pantalla
              ],
            );
          },
        ),
      ),
    );
  }

  /// ═══ MÉTODO: _sectionTitle ═══
  /// Construye un widget de texto estilizado como título de sección.
  /// Parámetro [t]: texto del título a mostrar.
  Widget _sectionTitle(String t) {
    return Text(t, style: GoogleFonts.shareTechMono(color: const Color(0xFF00F2FF), fontSize: 18, fontWeight: FontWeight.bold));  // Retorna texto en fuente mono, color cian, negrita
  }

  /// ═══ MÉTODO: _buildTopCard ═══
  /// Construye una tarjeta de estadística superior con ícono, valor y etiqueta.
  /// Parámetro [label]: texto descriptivo de la estadística.
  /// Parámetro [value]: valor numérico o texto a mostrar.
  /// Parámetro [icon]: ícono representativo de la estadística.
  /// Parámetro [color]: color del borde y elementos destacados.
  Widget _buildTopCard(String label, String value, IconData icon, Color color) {
    return Container(  // Contenedor principal de la tarjeta
      decoration: BoxDecoration(color: const Color(0xFF14243D), border: Border.all(color: color.withOpacity(0.6), width: 3.5)),  // Fondo azul oscuro con borde coloreado semitransparente
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [  // Columna centrada vertical y horizontalmente
        Icon(icon, color: color, size: 32),  // Ícono con color temático y tamaño 32
        const SizedBox(height: 8),  // Espacio vertical de 8px tras el ícono
        Text(value, style: GoogleFonts.pressStart2p(color: color, fontSize: 20)),  // Valor en fuente pixelada con color destacado
        const SizedBox(height: 8),  // Espacio vertical de 8px tras el valor
        Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: Text(label, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold))),  // Etiqueta centrada en blanco semitransparente
      ]),
    );
  }

  /// ═══ MÉTODO: _insigniaBox ═══
  /// Construye un contenedor estilizado para agrupar las insignias/logros.
  /// Parámetro [children]: lista de widgets hijos dentro del contenedor.
  Widget _insigniaBox(List<Widget> children) {
    return Container(width: double.infinity, padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: const Color(0xFF14243D).withOpacity(0.5), border: Border.all(color: const Color(0xFF1B4965), width: 2.0)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children));  // Contenedor azul semitransparente con borde y columnas alineadas a la izquierda
  }

  /// ═══ MÉTODO: _badge ═══
  /// Construye una insignia individual con ícono emoji y título.
  /// Parámetro [title]: texto descriptivo de la insignia.
  /// Parámetro [icon]: emoji representativo de la insignia.
  /// Parámetro [unlocked]: booleano que indica si la insignia está desbloqueada.
  /// Parámetro [isMobile]: booleano para ajustar tamaños según dispositivo.
  Widget _badge(String title, String icon, bool unlocked, bool isMobile) {
    return Container(  // Contenedor principal de la insignia
      width: isMobile ? 100 : 140,  // Ancho adaptable: 100px móvil, 140px escritorio
      padding: const EdgeInsets.all(12),  // Padding interno uniforme de 12px
      decoration: BoxDecoration(color: unlocked ? Colors.blue.withOpacity(0.15) : Colors.black26, border: Border.all(color: unlocked ? Colors.blue : Colors.white12, width: 2.0)),  // Fondo azul si desbloqueada, oscuro si no; borde correspondiente
      child: Column(mainAxisSize: MainAxisSize.min, children: [  // Columna de tamaño mínimo para los elementos del badge
        Opacity(opacity: unlocked ? 1.0 : 0.2, child: Text(icon, style: TextStyle(fontSize: isMobile ? 24 : 32))),  // Emoji con opacidad completa si desbloqueada, 20% si no
        const SizedBox(height: 10),  // Espacio vertical de 10px entre emoji y título
        Text(title, textAlign: TextAlign.center, style: TextStyle(color: unlocked ? Colors.white : Colors.white24, fontSize: isMobile ? 7 : 9, fontWeight: FontWeight.bold)),  // Título centrado: blanco brillante si desbloqueada, opaco si no
      ]),
    );
  }

  /// ═══ MÉTODO: _activityContainer ═══
  /// Construye un contenedor estilizado para la lista de actividades/historial.
  /// Parámetro [items]: lista de widgets hijos del historial.
  Widget _activityContainer(List<Widget> items) {
    return Container(width: double.infinity, padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: Colors.black26, border: Border.all(color: Colors.white10, width: 1.5)), child: Column(children: items));  // Contenedor oscuro con borde blanco sutil y contenido en columna
  }

  /// ═══ MÉTODO: _historyItem ═══
  /// Construye un item individual del historial de transacciones.
  /// Parámetro [title]: título descriptivo de la transacción.
  /// Parámetro [date]: fecha formateada de la transacción.
  /// Parámetro [value]: valor de la transacción (con signo + o -).
  /// Parámetro [isPositive]: booleano que indica si es una transacción positiva.
  /// Parámetro [isError]: booleano opcional para marcar como error (naranja).
  Widget _historyItem(String title, String date, String value, bool isPositive, {bool isError = false}) {
    Color valColor = isError ? Colors.orangeAccent : (isPositive ? Colors.greenAccent : Colors.redAccent);  // Determina color: naranja si error, verde si positivo, rojo si negativo
    return Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [  // Fila con padding vertical y espacio entre extremos
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)), const SizedBox(height: 2), Text(date, style: const TextStyle(color: Colors.white24, fontSize: 10))]),  // Columna izquierda: título blanco negrita y fecha semitransparente
      Text(value, style: GoogleFonts.pressStart2p(color: valColor, fontSize: 12)),  // Valor en fuente pixelada con color determinado
    ]));
  }

  /// ═══ MÉTODO: _pixelClipQuizStyle ═══
  /// Construye el widget motivacional con el logo PixelClip y un mensaje.
  /// Parámetro [color]: color para elementos estilísticos (actualmente no usado directamente).
  Widget _pixelClipQuizStyle(Color color) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [  // Fila alineada al inicio vertical
      const PixelClipLogo(size: 110),  // Logo PixelClip de tamaño 110px
      const SizedBox(width: 12),  // Espacio horizontal de 12px tras el logo
      Expanded(child: Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.black, width: 2.5), boxShadow: const [BoxShadow(color: Colors.black45, offset: Offset(5, 5))]), child: Text("PIXEL_CLIP: Tus monedas son la llave para desbloquear pistas avanzadas. ¡Sigue codificando y domina Python! 🚀💻🔥", style: GoogleFonts.shareTechMono(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold)))),  // Contenedor blanco con borde negro y sombra, contiene mensaje motivacional en fuente mono negra
    ]);
  }

  /// ═══ MÉTODO: _buildLogText ═══
  /// Construye una línea de texto estilizada como salida de terminal/log.
  /// Parámetro [text]: texto de la línea de log a mostrar.
  Widget _buildLogText(String text) {
    return Text(text, style: GoogleFonts.shareTechMono(color: Colors.greenAccent.withOpacity(0.7), fontSize: 11));  // Retorna texto en fuente mono verde semitransparente estilo terminal
  }
}

/// ═══ CLASE: _BlinkingCursor ═══
/// Widget de estado que muestra un cursor parpadeante estilo terminal.
/// Widget privado (guion bajo) usado solo internamente en LogrosScreen.
class _BlinkingCursor extends StatefulWidget {
  const _BlinkingCursor();  // Constructor sin parámetros
  @override
  State<_BlinkingCursor> createState() => _BlinkingCursorState();  // Crea el estado asociado al widget
}

/// ═══ CLASE: _BlinkingCursorState ═══
/// Estado del cursor parpadeante con animación de fade in/out continua.
/// Usa SingleTickerProviderStateMixin para proporcionar un Ticker a la animación.
class _BlinkingCursorState extends State<_BlinkingCursor> with SingleTickerProviderStateMixin {
  late AnimationController _controller;  // Controlador de animación (inicializado en initState)

  @override
  void initState() {  // Método llamado al inicializar el estado
    super.initState();  // Llama al initState de la clase padre
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500))..repeat(reverse: true);  // Crea controlador de 500ms que se repite inversamente (parpadeo)
  }

  @override
  void dispose() { _controller.dispose(); super.dispose(); }  // Libera recursos del controlador al destruir el widget

  @override
  Widget build(BuildContext context) {  // Construye el widget visual del cursor
    return FadeTransition(opacity: _controller, child: Container(width: 8, height: 12, color: Colors.greenAccent.withOpacity(0.7)));  // Contenedor rectangular verde cuya opacidad es animada por el controlador
  }
}
