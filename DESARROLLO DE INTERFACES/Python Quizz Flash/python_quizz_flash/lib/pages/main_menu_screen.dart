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

// ═══ IMPORTS: Dependencias del módulo ═══
// Se importan los paquetes de Flutter, Riverpod, Firebase, GoRouter y componentes
// retro personalizados necesarios para construir la pantalla del menú principal.

import 'package:flutter/material.dart';  // Framework UI principal de Flutter con widgets Material Design
import 'package:flutter_riverpod/flutter_riverpod.dart';  // Gestión de estado reactivo con Riverpod
import 'package:google_fonts/google_fonts.dart';  // Tipografías personalizadas desde Google Fonts
import 'package:go_router/go_router.dart';  // Sistema de enrutamiento declarativo para navegación
import 'package:cloud_firestore/cloud_firestore.dart';  // Cliente de Firebase Firestore para base de datos en tiempo real
import 'package:firebase_auth/firebase_auth.dart';  // Autenticación de Firebase para gestión de usuarios
import '../widgets/retro_progress_bar.dart';  // Barra de progreso con estilo retro personalizado
import '../widgets/retro_button.dart';  // Componente oficial de botones con estética retro
import '../widgets/retro_container.dart';  // Componente oficial de contenedores con estilo retro
import '../widgets/pixel_clip_logo.dart';  // Logo de la app con estilo pixel art recortable
import '../widgets/app_footer.dart';  // Pie de página reutilizable de la aplicación
import '../theme/app_theme.dart';  // Estilos globales del tema (colores, tipografías, etc.)
import '../providers/firebase_providers.dart';  // Providers de Riverpod para datos de Firebase
import '../providers/level_progress_provider.dart';  // Provider para gestión y seguimiento de niveles
import '../providers/economia_provider.dart';  // Provider para gestión de monedas y economía del juego

/// ═══ CLASE: MainMenuScreen ═══
/// Pantalla del Menú Principal que gestiona la visualización de niveles de aprendizaje,
/// perfil del usuario, balance de monedas (PY-Coins), navegación a secciones secundarias
/// (logros, tienda, info, contacto) y el progreso del usuario en cada nivel.
/// Usa ConsumerStatefulWidget para escuchar cambios reactivos desde Riverpod.
class MainMenuScreen extends ConsumerStatefulWidget {  // Widget con estado que escucha providers de Riverpod
  const MainMenuScreen({super.key});  // Constructor constante con key opcional del padre

  @override  // Sobreescribe el método factory del estado
  ConsumerState<MainMenuScreen> createState() => _MainMenuScreenState();  // Crea el estado privado asociado
}

/// ═══ CLASE: _MainMenuScreenState ═══
/// Estado privado que contiene toda la lógica de construcción y datos del menú principal.
/// Define la estructura estática de niveles, métodos auxiliares de formato y el árbol de widgets.
class _MainMenuScreenState extends ConsumerState<MainMenuScreen> {  // Estado reactivo con acceso a ref (Riverpod)
  // Datos estáticos de los niveles de aprendizaje  // Lista inmutable con la metadata de cada nivel
  final List<Map<String, dynamic>> nivelesData = [  // Colección de mapas con info de cada nivel
    {  // Nivel 1: Básico, siempre disponible desde el inicio
      "nombre": "NIVEL BÁSICO",  // Título visible del nivel
      "sub": "Fundamentos de Python",  // Subtítulo descriptivo del contenido
      "progreso": 0,  // Valor inicial de progreso (se sobreescribe con Firebase)
      "difficulty": "basic",  // Identificador único de dificultad usado en la BD
    },
    {  // Nivel 2: Intermedio, se desbloquea al completar el básico
      "nombre": "NIVEL INTERMEDIO",  // Título visible del nivel
      "sub": "Estructuras y Lógica",  // Subtítulo sobre estructuras de datos y control de flujo
      "progreso": 0,  // Valor inicial de progreso (se sobreescribe con Firebase)
      "difficulty": "intermediate",  // Identificador único de dificultad usado en la BD
    },
    {  // Nivel 3: Avanzado, se desbloquea al completar el intermedio
      "nombre": "NIVEL AVANZADO",  // Título visible del nivel
      "sub": "Objetos y Algoritmos",  // Subtítulo sobre POO y algoritmos complejos
      "progreso": 0,  // Valor inicial de progreso (se sobreescribe con Firebase)
      "difficulty": "advanced",  // Identificador único de dificultad usado en la BD
    },
    {  // Nivel 4: Reto Final (Jefe Final), el más difícil
      "nombre": "🏆 RETO FINAL GG 🏆",  // Título especial con emojis de trofeo
      "sub": "Desafío Experto",  // Subtítulo indicando que es el máximo desafío
      "progreso": 0,  // Valor inicial de progreso (se sobreescribe con Firebase)
      "difficulty": "expert",  // Identificador único de dificultad usado en la BD
      "isFinalBoss": true, // Marcador especial para el jefe final, indica que es el último nivel
    },
  ];

  /// ═══ MÉTODO: _getFormattedTimestamp ═══
  /// Obtiene la fecha y hora actual formateada como DD/MM/AA, HH:MM:SS para mostrar
  /// en el log del sistema con estética de terminal.
  String _getFormattedTimestamp() {  // Método privado que retorna un string con la marca de tiempo
    final now = DateTime.now();  // Obtiene el instante actual del sistema
    // Formato día/mes/año, hora:minuto:segundo  // Cada componente se rellena con ceros a la izquierda
    return "${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}, ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";  // Construye y retorna el string formateado
  }

  @override  // Sobreescribe el método build de State
  Widget build(BuildContext context) {  // Construye el árbol de widgets del menú
    // Obtenemos el usuario autenticado  // Consulta sincrónica a Firebase Auth
    final user = FirebaseAuth.instance.currentUser;  // Usuario actualmente logueado o null

    // Si no hay usuario, mostramos loading  // Protección contra estado no autenticado
    if (user == null) {  // Condición de seguridad por si se pierde la sesión
      return const Scaffold(  // Retorna un Scaffold mínimo con spinner
        backgroundColor: AppTheme.darkBg,  // Fondo oscuro consistente con el tema
        body: Center(child: CircularProgressIndicator()),  // Indicador de carga centrado
      );
    }

    // Obtenemos el perfil del usuario desde Riverpod para mostrar su nick  // Lee el provider de perfil
    final userProfileAsync = ref.watch(userProfileProvider);  // AsyncValue con datos del perfil desde Firestore
    final String actualUsername = userProfileAsync  // Extrae el nombre de usuario del resultado asíncrono
        .when(  // Patrón when para manejar los 3 estados de AsyncValue
          data: (data) => data?['username'] ?? 'USUARIO',  // Si hay datos, usa el campo username o fallback
          loading: () => '...',  // Mientras carga, muestra puntos suspensivos
          error: (_, _) => 'ERROR',  // Si falla, muestra texto de error
        )
        .toUpperCase(); // Forzamos mayúsculas para estética retro  // Convierte todo a mayúsculas para el estilo visual

    // Colores base del diseño retro extraídos del tema  // Alias de colores para legibilidad
    const Color neonCian = AppTheme.primaryCyan;  // Color cian neón principal del tema
    const Color mainBorderColor = AppTheme.borderBlue;  // Color azul para bordes del tema

    return Scaffold(  // Estructura base de la pantalla con fondo oscuro
      backgroundColor: AppTheme.darkBg,  // Fondo oscuro definido en el tema global
      body: LayoutBuilder(  // Builder que responde a cambios de tamaño de pantalla
        builder: (context, constraints) {  // Función constructora con acceso a las restricciones de layout
          final bool isMobile =  // Determina si el ancho es de dispositivo móvil
              constraints.maxWidth < 700; // Detectamos si es móvil  // Umbral de 700px para distinguir móvil de escritorio
          final double sidePadding = isMobile ? 20.0 : 100.0;  // Padding lateral: estrecho en móvil, amplio en escritorio

          return SafeArea(  // Evita que el contenido se solape con barras del sistema o notch
            child: Padding(  // Aplica padding horizontal simétrico
              padding: EdgeInsets.symmetric(horizontal: sidePadding),  // Padding dinámico según tipo de dispositivo
              child: Stack(  // Pila para superponer el contenido scrollable con el footer fijo
                children: [  // Lista de hijos apilados
                  SingleChildScrollView(  // Contenedor scrollable para contenido que excede la pantalla
                    padding: const EdgeInsets.symmetric(vertical: 20),  // Espaciado vertical interno de 20px
                    child: Column(  // Columna vertical que apila todas las secciones del menú
                      crossAxisAlignment: CrossAxisAlignment.start,  // Alineación horizontal a la izquierda
                      children: [  // Lista de widgets hijos en orden vertical
                        // --- CABECERA: PERFIL Y AJUSTES ---  // Sección superior con info del usuario y botones de acción
                        Row(  // Fila horizontal para distribuir elementos de la cabecera
                          children: [  // Hijos de la fila de cabecera
                            // Icono de perfil con marco neón  // Contenedor decorativo para el ícono de persona
                            Container(  // Widget genérico con decoración personalizada
                              padding: const EdgeInsets.all(4),  // Espacio interno de 4px alrededor del ícono
                              decoration: BoxDecoration(  // Caja de decoración con color y borde
                                color: neonCian,  // Fondo cian neón del contenedor del ícono
                                border: Border.all(color: neonCian, width: 2),  // Borde cian de 2px creando efecto marco
                              ),
                              child: const Icon(  // Ícono de Material Design dentro del contenedor
                                Icons.person,  // Ícono de silueta de persona
                                color: Colors.black,  // Color negro para contraste sobre fondo cian
                                size: 28,  // Tamaño del ícono en píxeles lógicos
                              ),
                            ),
                            const SizedBox(width: 15),  // Espaciador horizontal de 15px entre ícono y texto
                            Expanded(  // Ocupa todo el espacio restante disponible en la fila
                              child: Column(  // Columna vertical para saludo y estado del sistema
                                crossAxisAlignment: CrossAxisAlignment.start,  // Texto alineado a la izquierda
                                children: [  // Hijos de la columna de texto
                                  // Saludo personalizado al usuario  // Texto de bienvenida con el nombre del usuario
                                  FittedBox(  // Contenedor que escala su hijo para evitar desbordamiento
                                    fit: BoxFit.scaleDown,  // Solo reduce el tamaño, nunca lo aumenta
                                    child: Text(  // Widget de texto con fuente personalizada
                                      'BIENVENID@, $actualUsername !!',  // Texto interpolado con el nombre de usuario
                                      style: GoogleFonts.pressStart2p(  // Fuente pixel art estilo retro gaming
                                        fontSize: isMobile ? 12 : 16,  // Tamaño adaptativo según dispositivo
                                        color: neonCian,  // Color cian neón para el saludo
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),  // Espaciador vertical de 4px entre saludo y estado
                                  // Estado de conexión del sistema  // Texto informativo del estado de la app
                                  Text(  // Widget de texto con fuente monoespaciada tipo terminal
                                    'ESTADO DEL SISTEMA: EN LINEA',  // Mensaje de estado siempre visible
                                    style: GoogleFonts.shareTechMono(  // Fuente monoespaciada estilo consola
                                      fontSize: 11,  // Tamaño pequeño para texto secundario
                                      color: Colors.grey,  // Color gris para indicar que es info secundaria
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Botones de ajustes y salida para escritorio  // Solo visibles en pantallas anchas
                            if (!isMobile) ...[  // Operador spread condicional: se incluye solo en escritorio
                              RetroButton(  // Botón retro personalizado para configuración
                                icon: Icons.settings,  // Ícono de engranaje para ajustes
                                text: "",  // Sin texto, solo ícono en escritorio
                                width: 48,  // Ancho fijo de 48px
                                height: 48,  // Alto fijo de 48px creando botón cuadrado
                                style: RetroButtonStyle.secondary,  // Estilo secundario del sistema de diseño retro
                                onPressed: () => context.push('/config'),  // Navega a la ruta de configuración sin reemplazar historial
                              ),
                              const SizedBox(width: 10),  // Espaciador horizontal de 10px entre botones
                              RetroButton(  // Botón retro personalizado para salir/cerrar sesión
                                icon: Icons.close,  // Ícono de X para cerrar/salir
                                text: "",  // Sin texto, solo ícono en escritorio
                                width: 48,  // Ancho fijo de 48px
                                height: 48,  // Alto fijo de 48px creando botón cuadrado
                                style: RetroButtonStyle.danger,  // Estilo danger (rojo) indicando acción destructiva
                                onPressed: () => context.go('/inicio'),  // Navega a inicio reemplazando el historial
                              ),
                            ],
                          ],
                        ),
                        // Botones de ajustes y salida para móvil (Mejorado para evitar desborde)  // Versión móvil de los botones de acción
                        if (isMobile) ...[  // Operador spread condicional: se incluye solo en móvil
                          const SizedBox(height: 15),  // Espaciador vertical de 15px antes de los botones
                          Row(  // Fila horizontal para los dos botones de acción
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,  // Distribuye el espacio entre los botones
                            children: [  // Hijos de la fila de botones móvil
                              const SizedBox(width: 4),  // Margen izquierdo de 4px
                              Expanded(  // El botón de ajustes ocupa la mitad disponible
                                child: RetroButton(  // Botón retro con texto para ajustes en móvil
                                  icon: Icons.settings,  // Ícono de engranaje
                                  text: "AJUSTES",  // Texto visible del botón
                                  height: 40,  // Alto de 40px
                                  fontSize: 8,  // Fuente pequeña de 8px para que quepa el texto
                                  style: RetroButtonStyle.secondary,  // Estilo secundario
                                  onPressed: () => context.push('/config'),  // Navega a configuración
                                ),
                              ),
                              const SizedBox(width: 10),  // Espaciador horizontal de 10px entre botones
                              Expanded(  // El botón de salir ocupa la mitad disponible
                                child: RetroButton(  // Botón retro con texto para salir en móvil
                                  icon: Icons.close,  // Ícono de X
                                  text: "SALIR",  // Texto visible del botón
                                  height: 40,  // Alto de 40px
                                  fontSize: 8,  // Fuente pequeña de 8px para que quepa el texto
                                  style: RetroButtonStyle.danger,  // Estilo danger (rojo)
                                  onPressed: () => context.go('/inicio'),  // Navega a inicio
                                ),
                              ),
                            ],
                          ),
                        ],

                        const SizedBox(height: 35),  // Espaciador vertical de 35px antes del logo

                        // --- NUEVA SECCIÓN: LOGO CENTRALIZADO ---  // Sección con logo y mensaje de bienvenida
                        Center(  // Centra horizontalmente el contenido
                          child: Column(  // Columna vertical para logo y mensaje
                            children: [  // Hijos de la columna centrada
                              const PixelClipLogo(size: 160),  // Logo pixel art de 160px
                              const SizedBox(height: 10),  // Espaciador vertical de 10px
                              Container(  // Contenedor con estilo de bocadillo/mensaje
                                padding: const EdgeInsets.symmetric(  // Padding simétrico horizontal y vertical
                                  horizontal: 16,  // 16px a cada lado
                                  vertical: 8,  // 8px arriba y abajo
                                ),
                                decoration: BoxDecoration(  // Decoración tipo etiqueta adhesiva
                                  color: Colors.white,  // Fondo blanco para contraste
                                  border: Border.all(  // Borde negro sólido
                                    color: Colors.black,  // Color negro del borde
                                    width: 2,  // Grosor de 2px
                                  ),
                                  boxShadow: const [  // Sombra proyectada para efecto 3D
                                    BoxShadow(  // Sombra sólida desplazada
                                      color: Colors.black45,  // Color negro semitransparente
                                      offset: Offset(3, 3),  // Desplazamiento de 3px abajo y a la derecha
                                    ),
                                  ],
                                ),
                                child: Text(  // Texto del mensaje motivacional
                                  "Ya estamos listos para repasar Python!! ",  // Mensaje de preparación
                                  style: GoogleFonts.shareTechMono(  // Fuente monoespaciada tipo terminal
                                    color: Colors.black,  // Texto negro sobre fondo blanco
                                    fontSize: 12,  // Tamaño de 12px
                                    fontWeight: FontWeight.bold,  // Negrita para énfasis
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 40),  // Espaciador vertical de 40px antes del panel de monedas

                        // --- PANEL DE MONEDAS (BALANCE) ---  // Sección que muestra las PY-Coins del usuario
                        // Usamos RetroContainer con ancho total  // Contenedor retro que ocupa todo el ancho
                        // Escuchamos los cambios en tiempo real desde EconomiaProvider  // Provider reactivo de economía
                        // Esto asegura actualización INSTANTÁNEA sin esperar a Firebase  // Optimización con caché local
                        SizedBox(  // Widget de tamaño forzado
                          width: double.infinity,  // Ancho completo disponible
                          child: RetroContainer(  // Contenedor con estilo retro
                            isWin95: false,  // No usa estilo Windows 95, usa estilo personalizado
                            borderColor: mainBorderColor.withValues(alpha: 0.6),  // Borde azul semitransparente
                            backgroundColor: Colors.black.withValues(  // Fondo negro semitransparente
                              alpha: 0.4,  // 40% de opacidad
                            ),
                            padding: const EdgeInsets.all(12),  // Padding interno de 12px en todos los lados
                            child: Row(  // Fila horizontal para etiqueta y valor de monedas
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,  // Extremos opuestos
                              children: [  // Hijos de la fila de monedas
                                Text(  // Etiqueta descriptiva del balance
                                  'PY-COINS BALANCE:',  // Texto de la etiqueta
                                  style: GoogleFonts.shareTechMono(  // Fuente monoespaciada
                                    color: mainBorderColor,  // Color azul del borde
                                    fontSize: 14,  // Tamaño de 14px
                                  ),
                                ),
                                // Usamos EconomiaProvider para lectura rápida con persistencia local  // Provider optimizado
                                // Consumer escucha los cambios del ChangeNotifier  // Widget que accede a Riverpod dentro de StatelessWidget
                                Consumer(  // Widget consumidor de Riverpod para acceso al provider
                                  builder: (context, ref, child) {  // Función constructora con acceso a ref
                                    final economia = ref.watch(economiaProvider);  // Obtiene la instancia del provider de economía
                                    // Escuchar cambios manualmente  // ListenableBuilder para reconstruir solo cuando cambien las monedas
                                    return ListenableBuilder(  // Builder que escucha un Listenable (ChangeNotifier)
                                      listenable: economia,  // El provider de economía como fuente de cambios
                                      builder: (context, _) {  // Función constructora que se ejecuta en cada cambio
                                        final int coins = economia.coins;  // Obtiene el balance actual de monedas
                                        return Row(  // Fila horizontal para ícono de moneda y cantidad
                                          children: [  // Hijos de la fila de monedas
                                            const Icon(  // Ícono decorativo de moneda
                                              Icons.monetization_on,  // Ícono de moneda dorada
                                              color: Color(0xFFFFB800),  // Color dorado ámbar personalizado
                                              size: 18,  // Tamaño de 18px
                                            ),
                                            const SizedBox(width: 8),  // Espaciador horizontal de 8px
                                            Text(  // Cantidad numérica de monedas
                                              '$coins',  // Interpolación del valor de coins
                                              style: GoogleFonts.pressStart2p(  // Fuente pixel art retro
                                                color: Color(0xFFFFB800),  // Color dorado ámbar
                                                fontSize: 12,  // Tamaño de 12px
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 25),  // Espaciador vertical de 25px antes de los botones de navegación

                        // --- BOTONES DE NAVEGACIÓN RÁPIDA ---  // Sección de accesos directos a secciones secundarias
                        // Reemplazamos los CyberRetroButton antiguos por los nuevos RetroButton  // Migración de componentes
                        isMobile  // Operador condicional para layout responsivo
                            ? GridView.count(  // En móvil: grid de 2 columnas con celdas cuadradas
                                shrinkWrap: true,  // El grid solo ocupa el espacio necesario
                                physics: const NeverScrollableScrollPhysics(),  // Desactiva scroll interno del grid
                                crossAxisCount: 2,  // 2 columnas en el grid
                                mainAxisSpacing: 15,  // Espacio vertical de 15px entre filas
                                crossAxisSpacing: 15,  // Espacio horizontal de 15px entre columnas
                                childAspectRatio:  // Relación ancho/alto de cada celda
                                    1.3, // Ajustado para layout vertical  // Ligeramente más ancho que alto
                                children: [  // Hijos del grid (4 botones)
                                  _buildNavButton(  // Botón de logros/trofeos
                                    "LOGROS",  // Etiqueta del botón
                                    Icons.emoji_events_outlined,  // Ícono de trofeos
                                    () => context.push('/logros'),  // Navega a la pantalla de logros
                                  ),
                                  _buildNavButton(  // Botón de tienda para gastar monedas
                                    "TIENDA",  // Etiqueta del botón
                                    Icons.storefront,  // Ícono de tienda
                                    () => context.push('/tienda'),  // Navega a la pantalla de tienda
                                  ),
                                  _buildNavButton(  // Botón de información/tutorial
                                    "INFO",  // Etiqueta del botón
                                    Icons.info_outline,  // Ícono de información
                                    () => context.go('/onboarding'),  // Navega al onboarding (reemplaza historial)
                                  ),
                                  _buildNavButton(  // Botón de contacto/soporte
                                    "CONTACTO",  // Etiqueta del botón
                                    Icons.mail_outline,  // Ícono de correo/sobre
                                    () => context.push('/contacto'),  // Navega a la pantalla de contacto
                                  ),
                                ],
                              )
                            : Row(  // En escritorio: fila horizontal con todos los botones
                                children: [  // Hijos de la fila de navegación
                                  _buildNavButtonExpanded(  // Botón de logros expandido
                                    "LOGROS",  // Etiqueta del botón
                                    Icons.emoji_events_outlined,  // Ícono de trofeos
                                    () => context.push('/logros'),  // Navega a logros
                                  ),
                                  const SizedBox(width: 14),  // Espaciador horizontal de 14px
                                  _buildNavButtonExpanded(  // Botón de tienda expandido
                                    "TIENDA",  // Etiqueta del botón
                                    Icons.storefront,  // Ícono de tienda
                                    () => context.push('/tienda'),  // Navega a tienda
                                  ),
                                  const SizedBox(width: 14),  // Espaciador horizontal de 14px
                                  _buildNavButtonExpanded(  // Botón de información expandido
                                    "INFO",  // Etiqueta del botón
                                    Icons.info_outline,  // Ícono de información
                                    () => context.go('/onboarding'),  // Navega a onboarding
                                  ),
                                  const SizedBox(width: 14),  // Espaciador horizontal de 14px
                                  _buildNavButtonExpanded(  // Botón de contacto expandido
                                    "CONTACTO",  // Etiqueta del botón
                                    Icons.mail_outline,  // Ícono de correo
                                    () => context.push('/contacto'),  // Navega a contacto
                                  ),
                                ],
                              ),

                        const SizedBox(height: 40),  // Espaciador vertical de 40px antes de la lista de niveles

                        // --- LISTA DE NIVELES ---  // Sección principal con las tarjetas de cada nivel
                        // Usamos StreamBuilder para escuchar cambios de progreso en tiempo real  // Escucha activa a Firestore
                        StreamBuilder<DocumentSnapshot>(  // Widget que escucha un stream de Firestore
                          stream: FirebaseFirestore.instance  // Instancia de Firestore
                              .collection('users')  // Colección de usuarios
                              .doc(user.uid)  // Documento del usuario autenticado por su ID
                              .snapshots(),  // Stream en tiempo real del documento
                          builder: (context, snapshot) {  // Función constructora que se ejecuta con cada evento del stream
                            if (!snapshot.hasData) {  // Si aún no hay datos del stream
                              return const CircularProgressIndicator();  // Muestra spinner de carga
                            }
                            final userData = snapshot.data?.data() as Map<String, dynamic>?;  // Extrae los datos del documento como mapa nullable

                            return Column(  // Columna vertical para todas las tarjetas de nivel
                              children: [  // Hijos de la columna de niveles
                                ...nivelesData.map(  // Spread operator: mapea cada entrada de nivelesData a un widget
                                  (data) => _buildLevelCard(  // Llama al método constructor de tarjeta de nivel
                                    data,  // Datos del nivel (nombre, dificultad, etc.)
                                    neonCian,  // Color cian neón para decoración
                                    isMobile,  // Flag de dispositivo móvil para layout responsivo
                                    userData,  // Datos del usuario desde Firestore para calcular progreso
                                  ),
                                ),
                              ],
                            );
                          },
                        ),

                        const SizedBox(height: 30),  // Espaciador vertical de 30px antes del log del sistema

                        // --- LOG DEL SISTEMA (ESTILO TERMINAL) ---  // Sección decorativa con info del usuario tipo consola
                        Container(  // Contenedor con estilo de terminal negra
                          width: double.infinity,  // Ancho completo disponible
                          padding: const EdgeInsets.all(12),  // Padding interno de 12px
                          decoration: BoxDecoration(  // Decoración tipo terminal
                            color: Colors.black,  // Fondo negro puro
                            border: Border.all(  // Borde semitransparente
                              color: mainBorderColor.withValues(alpha: 0.4),  // Azul con 40% de opacidad
                            ),
                          ),
                          child: Column(  // Columna vertical para las líneas del log
                            crossAxisAlignment: CrossAxisAlignment.start,  // Texto alineado a la izquierda
                            children: [  // Hijos de la columna del log
                              _buildLogText("> USER: $actualUsername"),  // Línea con el nombre del usuario
                              _buildLogText("> STATUS: READY_FOR_LEARNING"),  // Línea con el estado listo para aprender
                              _buildLogText(  // Línea con la marca de tiempo actual
                                "> TIMESTAMP: ${_getFormattedTimestamp()}",  // Timestamp formateado
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 120),  // Espaciador vertical de 120px para dejar espacio al footer fijo
                      ],
                    ),
                  ),

                  // Pie de página fijo  // Footer posicionado absolutamente en la parte inferior
                  Positioned(  // Widget de posicionamiento absoluto dentro del Stack
                    bottom: 0,  // Pegado al borde inferior
                    left: 0,  // Pegado al borde izquierdo
                    right: 0,  // Pegado al borde derecho
                    child: AppFooter(borderColor: mainBorderColor),  // Componente de footer con color de borde del tema
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// ═══ MÉTODO: _buildNavButton ═══
  /// Construye un botón de navegación con estilo retro oficial para la versión móvil (grid).
  /// Recibe la etiqueta, el ícono y la acción de tap, y retorna un RetroButton configurado
  /// con orientación vertical (ícono encima del texto).
  Widget _buildNavButton(String label, IconData icon, VoidCallback onTap) {  // Método privado que construye un botón de navegación
    return RetroButton(  // Retorna un botón retro personalizado
      text: label.toUpperCase(),  // Texto del botón en mayúsculas
      icon: icon,  // Ícono de Material Design
      style: RetroButtonStyle.secondary,  // Estilo secundario del sistema retro
      fontSize: 10,  // Tamaño de fuente de 10px
      isVertical: true, // Icono encima del texto  // Layout vertical para el grid móvil
      onPressed: onTap,  // Callback que se ejecuta al pulsar el botón
    );
  }

  /// ═══ MÉTODO: _buildNavButtonExpanded ═══
  /// Versión expandida del botón para filas en escritorio. Envuelve el botón de navegación
  /// en un widget Expanded para que ocupe todo el ancho disponible en la fila horizontal.
  Widget _buildNavButtonExpanded(  // Método privado que construye un botón expandido
    String label,  // Etiqueta de texto del botón
    IconData icon,  // Ícono de Material Design
    VoidCallback onTap,  // Callback de acción al pulsar
  ) {
    return Expanded(child: _buildNavButton(label, icon, onTap));  // Envuelve el botón normal en un Expanded
  }

  /// ═══ MÉTODO: _buildLevelCard ═══
  /// Construye la tarjeta representativa de cada nivel usando RetroContainer. Determina si el
  /// nivel está desbloqueado según el progreso del nivel anterior, muestra la barra de progreso,
  /// el contador de ejercicios y el botón de acción (INICIAR/REANUDAR/COMPLETADO/BLOQUEADO).
  Widget _buildLevelCard(  // Método privado que construye una tarjeta de nivel
    Map<String, dynamic> data,  // Mapa con datos del nivel (nombre, dificultad, subtítulo)
    Color neonCian,  // Color cian neón para elementos visuales activos
    bool isMobile,  // Flag para determinar layout responsivo
    Map<String, dynamic>? userData,  // Datos del usuario desde Firestore (nullable)
  ) {
    final String diff = data['difficulty'];  // Extrae el identificador de dificultad del nivel
    // Si userData es null, el progreso es 0  // Protección contra datos inexistentes
    final int progress = userData != null ? (userData['progress_$diff'] ?? 0) : 0;  // Obtiene el progreso del campo dinámico o 0
    const int totalEx = 20; // Estándar de 20 ejercicios por nivel  // Cantidad fija de ejercicios por nivel

    // Escuchamos el provider de progreso de niveles para saber si está desbloqueado  // Lee el estado de desbloqueo
    final levelProgressAsync = ref.watch(levelProgressProvider);  // AsyncValue con el progreso general de niveles

    return levelProgressAsync.when(  // Maneja los 3 estados del AsyncValue de Riverpod
      loading: () => const Center(child: CircularProgressIndicator()),  // Mientras carga: spinner centrado
      error: (_, _) => const SizedBox.shrink(),  // Si hay error: widget invisible de tamaño cero
      data: (levelProgress) {  // Cuando los datos están disponibles
        // Determinamos si el nivel está desbloqueado según la dificultad  // Lógica de desbloqueo progresivo
        bool isUnlocked = false;  // Flag de nivel disponible, por defecto bloqueado
        bool isChallengeCompleted = false;  // Flag de nivel completado, por defecto no completado

        switch (diff) {  // Switch según la dificultad del nivel actual
          case 'basic':  // Caso del nivel básico
            isUnlocked = true; // El nivel básico siempre está disponible  // Sin requisitos previos
            isChallengeCompleted = levelProgress.challengeBasicCompleted;  // Se completó si el flag del provider es true
            break;  // Sale del switch
          case 'intermediate':  // Caso del nivel intermedio
            isUnlocked = levelProgress.challengeBasicCompleted;  // Requiere haber completado el básico
            isChallengeCompleted = levelProgress.challengeIntermediateCompleted;  // Se completó si el flag del provider es true
            break;  // Sale del switch
          case 'advanced':  // Caso del nivel avanzado
            isUnlocked = levelProgress.challengeIntermediateCompleted;  // Requiere haber completado el intermedio
            isChallengeCompleted = levelProgress.advancedCompleted;  // Se completó si el flag del provider es true
            break;  // Sale del switch
          case 'expert':  // Caso del nivel experto (reto final GG)
            // El nivel expert (GG) se desbloquea al completar advanced  // Requiere el nivel más alto previo
            isUnlocked = levelProgress.advancedCompleted;  // Requiere haber completado el avanzado
            isChallengeCompleted =  // No tiene siguiente nivel, este flag no se usa
                false; // El reto final GG no tiene challenge siguiente  // Siempre false porque es el último nivel
            break;  // Sale del switch
        }

        // hasStarted: hay progreso (>= 1) Y el nivel NO está completado  // Determina si el usuario ya empezó pero no terminó
        final bool hasStarted = progress >= 1 && !isChallengeCompleted;  // True si avanzó al menos 1 ejercicio y no está completo

        // Si el challenge está completado, mostramos texto de "COMPLETADO"  // Flag de nivel al máximo
        final bool isMaxLevel = isChallengeCompleted;  // Alias para legibilidad: nivel al máximo = completado

        return Padding(  // Espaciado inferior entre tarjetas de nivel
          padding: const EdgeInsets.only(bottom: 20),  // Margen inferior de 20px
          child: RetroContainer(  // Contenedor retro que envuelve toda la tarjeta del nivel
            isWin95: false,  // No usa estilo Windows 95
            borderColor: isUnlocked ? neonCian : Colors.grey,  // Borde cian si desbloqueado, gris si bloqueado
            backgroundColor: isUnlocked  // Color de fondo según estado de desbloqueo
                ? const Color(0xFF14243D)  // Azul oscuro si está desbloqueado (activo)
                : const Color(0xFF0A0F1A),  // Casi negro si está bloqueado (inactivo)
            child: Column(  // Columna vertical para contenido de la tarjeta
              crossAxisAlignment: CrossAxisAlignment.start,  // Texto alineado a la izquierda
              children: [  // Hijos de la columna de la tarjeta
                Row(  // Fila horizontal para título y botón de acción
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,  // Extremos opuestos: título a la izquierda, botón a la derecha
                  children: [  // Hijos de la fila
                    Expanded(  // El título ocupa todo el espacio disponible
                      child: Column(  // Columna vertical para título y subtítulo del nivel
                        crossAxisAlignment: CrossAxisAlignment.start,  // Texto alineado a la izquierda
                        children: [  // Hijos de la columna de texto
                          Row(  // Fila horizontal para título + íconos de estado
                            children: [  // Hijos de la fila del título
                              Text(  // Texto del nombre del nivel
                                data['nombre'],  // Nombre extraído del mapa de datos
                                style: GoogleFonts.pressStart2p(  // Fuente pixel art retro
                                  color: isUnlocked ? neonCian : Colors.grey,  // Cian si desbloqueado, gris si bloqueado
                                  fontSize: 11,  // Tamaño de 11px
                                ),
                              ),
                              if (!isUnlocked) ...[  // Si está bloqueado: muestra ícono de candado
                                const SizedBox(width: 8),  // Espaciador horizontal de 8px
                                Icon(Icons.lock, color: Colors.grey, size: 14),  // Ícono de candado gris pequeño
                              ],
                              if (isMaxLevel) ...[  // Si está completado: muestra ícono de estrella
                                const SizedBox(width: 8),  // Espaciador horizontal de 8px
                                Icon(  // Ícono de estrella dorada
                                  Icons.star,  // Estrella de Material Design
                                  color: const Color(0xFFFFB800),  // Color dorado ámbar
                                  size: 14,  // Tamaño de 14px
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 6),  // Espaciador vertical de 6px
                          Text(  // Subtítulo descriptivo del nivel
                            data['sub'],  // Subtítulo extraído del mapa de datos
                            style: GoogleFonts.shareTechMono(  // Fuente monoespaciada tipo terminal
                              color: isUnlocked ? Colors.grey : Colors.white24,  // Gris si activo, blanco muy tenue si bloqueado
                              fontSize: 12,  // Tamaño de 12px
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!isMobile)  // En escritorio: botón alineado a la derecha del título
                      isUnlocked  // Si el nivel está desbloqueado
                          ? RetroButton(  // Botón de acción para nivel disponible
                              text: isMaxLevel  // Texto condicional según estado
                                  ? "COMPLETADO"  // Si está completado: texto de completado
                                  : (hasStarted ? "REANUDAR" : "INICIAR"),  // Si empezó: reanudar, si no: iniciar
                              width: 150,  // Ancho fijo de 150px
                              style: isMaxLevel  // Estilo condicional según estado
                                  ? RetroButtonStyle.primary  // Estilo primario si completado
                                  : (hasStarted  // Si no completado, verifica si empezó
                                        ? RetroButtonStyle.primary  // Estilo primario si ya empezó (reanudar)
                                        : RetroButtonStyle.secondary),  // Estilo secundario si es nuevo
                              backgroundColor: isMaxLevel  // Color de fondo especial si completado
                                  ? const Color(0xFF39FF14)  // Verde neón brillante para completado
                                  : null,  // Color por defecto del estilo si no completado
                              onPressed: isMaxLevel  // Acción condicional según estado
                                  ? null  // Si completado: botón deshabilitado (null)
                                  : () => context.go('/quiz?difficulty=$diff'),  // Si no: navega al quiz con la dificultad
                            )
                          : RetroButton(  // Botón para nivel bloqueado
                              text: "BLOQUEADO",  // Texto indicando que no está disponible
                              width: 150,  // Ancho fijo de 150px
                              style: RetroButtonStyle.secondary,  // Estilo secundario
                              backgroundColor: Colors.grey.withValues(  // Fondo gris semitransparente
                                alpha: 0.3,  // 30% de opacidad
                              ),
                              onPressed: null, // Botón deshabilitado  // Null desactiva el botón en Flutter
                            ),
                  ],  // Cierre de la lista de hijos del Row
                ),  // Cierre del Row título-botón
                const SizedBox(height: 20),  // Espaciador vertical de 20px antes de la barra de progreso
                // Barra de progreso visual (solo si está desbloqueado)  // Muestra avance gráfico
                if (isUnlocked)  // Condicional: solo muestra barra si el nivel está desbloqueado
                  // Si el nivel está completado, mostramos la barra al máximo (totalEx)  // Barra llena para completados
                  RetroProgressBar(  // Widget personalizado de barra de progreso
                    current: isMaxLevel ? totalEx : progress,  // Si completado: muestra total, si no: progreso actual
                    total: totalEx,  // Total de ejercicios (20) como referencia
                  )
                else  // Si está bloqueado: muestra mensaje de requisito
                  Container(  // Contenedor con mensaje de bloqueo
                    width: double.infinity,  // Ancho completo
                    height: 20,  // Alto fijo de 20px
                    decoration: BoxDecoration(  // Decoración del contenedor
                      color: Colors.black.withValues(alpha: 0.5),  // Fondo negro semitransparente
                      border: Border.all(  // Borde semitransparente
                        color: Colors.grey.withValues(alpha: 0.3),  // Gris muy tenue
                      ),
                    ),
                    child: Center(  // Centra el texto dentro del contenedor
                      child: Text(  // Texto de requisito para desbloquear
                        "COMPLETA EL NIVEL ANTERIOR PARA DESBLOQUEAR",  // Mensaje instructivo
                        style: GoogleFonts.shareTechMono(  // Fuente monoespaciada
                          color: Colors.white24,  // Blanco muy tenue (24% opacidad)
                          fontSize: 9,  // Tamaño pequeño de 9px
                        ),
                      ),
                    ),
                  ),
                // Botón de acción para móvil (debajo de la barra)  // Versión móvil del botón de acción
                if (isMobile) ...[  // Solo en layout móvil: botón debajo de la barra
                  const SizedBox(height: 15),  // Espaciador vertical de 15px
                  Row(  // Fila horizontal para el botón
                    mainAxisAlignment: MainAxisAlignment.end,  // Alineado a la derecha
                    children: [  // Hijos de la fila
                      isUnlocked  // Si el nivel está desbloqueado
                          ? RetroButton(  // Botón de acción para nivel disponible
                              text: isMaxLevel  // Texto condicional según estado
                                  ? "COMPLETADO"  // Si completado: texto de completado
                                  : (hasStarted ? "REANUDAR" : "INICIAR"),  // Si empezó: reanudar, si no: iniciar
                              width: 150,  // Ancho fijo de 150px
                              style: isMaxLevel  // Estilo condicional
                                  ? RetroButtonStyle.primary  // Primario si completado
                                  : (hasStarted
                                        ? RetroButtonStyle.primary  // Primario si ya empezó
                                        : RetroButtonStyle.secondary),  // Secundario si es nuevo
                              backgroundColor: isMaxLevel  // Color especial si completado
                                  ? const Color(0xFF39FF14)  // Verde neón brillante
                                  : null,  // Color por defecto
                              onPressed: isMaxLevel  // Acción condicional
                                  ? null  // Deshabilitado si completado
                                  : () => context.go('/quiz?difficulty=$diff'),  // Navega al quiz
                            )
                          : RetroButton(  // Botón para nivel bloqueado
                              text: "BLOQUEADO",  // Texto de bloqueado
                              width: 150,  // Ancho fijo de 150px
                              style: RetroButtonStyle.secondary,  // Estilo secundario
                              backgroundColor: Colors.grey.withValues(  // Fondo gris semitransparente
                                alpha: 0.3,  // 30% de opacidad
                              ),
                              onPressed: null, // Botón deshabilitado  // Null desactiva el botón
                            ),
                    ],  // Cierre de hijos del Row
                  ),  // Cierre del Row del botón móvil
                ],  // Cierre del spread condicional móvil
                const SizedBox(height: 10),  // Espaciador vertical de 10px antes del contador
                // Contador numérico de progreso (solo si está desbloqueado)  // Texto con X/Y ejercicios
                if (isUnlocked)  // Solo muestra contador si desbloqueado
                  Text(  // Widget de texto con el conteo de progreso
                    // Si el nivel está completado, mostramos el total completo  // Muestra máximo si completado
                    "${isMaxLevel ? totalEx : progress}/$totalEx EJERCICIOS COMPLETADOS",  // String interpolado con el conteo
                    style: GoogleFonts.shareTechMono(  // Fuente monoespaciada
                      color: Colors.grey,  // Color gris
                      fontSize: 10,  // Tamaño de 10px
                    ),
                  )
                else  // Si bloqueado: muestra texto de requisito
                  Text(  // Texto informativo del requisito
                    "REQUISITO: Superar el reto del nivel anterior",  // Mensaje de requisito
                    style: GoogleFonts.shareTechMono(  // Fuente monoespaciada
                      color: Colors.white24,  // Blanco muy tenue
                      fontSize: 9,  // Tamaño pequeño de 9px
                    ),
                  ),
              ],  // Cierre de hijos de la Column de la tarjeta
            ),  // Cierre de la Column
          ),  // Cierre del RetroContainer
        );  // Cierre del Padding
      },  // Cierre del callback data de when
    );  // Cierre del when de levelProgressAsync
  }  // Cierre del método _buildLevelCard

  /// ═══ MÉTODO: _buildLogText ═══
  /// Construye un widget de texto con estilo de terminal para las líneas del log del sistema.
  /// Usa fuente monoespaciada verde brillante sobre fondo negro simulando una consola.
  Widget _buildLogText(String text) {  // Método privado que construye una línea de log
    return Text(  // Widget de texto estilizado
      text,  // Texto recibido como parámetro
      style: GoogleFonts.shareTechMono(color: Colors.greenAccent, fontSize: 11),  // Fuente verde estilo terminal
    );
  }  // Cierre del método _buildLogText
}  // Cierre de la clase _MainMenuScreenState
