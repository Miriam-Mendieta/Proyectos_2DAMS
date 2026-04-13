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
import 'package:flutter/material.dart';  // Importa el framework principal de Flutter para widgets Material Design
import 'package:flutter/services.dart';  // Importa servicios del sistema como el portapapeles
import 'package:google_fonts/google_fonts.dart';  // Importa la librería para usar fuentes personalizadas de Google Fonts
import 'package:go_router/go_router.dart';  // Importa el sistema de enrutamiento go_router para navegación
import '../models/ai_content.dart';  // Importa el modelo de datos AiContent
import '../theme/app_theme.dart';  // Importa las definiciones de tema y colores de la aplicación
import '../widgets/retro_button.dart';  // Importa el widget personalizado de botón retro
import '../widgets/retro_container.dart';  // Importa el widget personalizado de contenedor retro
import '../widgets/pixel_clip_logo.dart';  // Importa el widget del logo PixelClip
import '../widgets/crt_overlay.dart';  // Importa el widget de superposición CRT
import '../widgets/app_footer.dart';  // Importa el widget del pie de página de la aplicación
import '../widgets/app_notifications.dart';  // Importa el sistema de notificaciones de la aplicación

/// ═══ CLASE: AiContentViewerScreen ═══
/// ═══ Widget StatefulWidget que muestra contenido generado por IA con estilo retro ═══
class AiContentViewerScreen extends StatefulWidget {  // Clase principal de la pantalla visora de contenido IA
  final AiContent content;  // Almacena el objeto de contenido IA a mostrar
  const AiContentViewerScreen({super.key, required this.content});  // Constructor que requiere el contenido IA como parámetro obligatorio

  @override  // Sobrescribe el método para crear el estado asociado
  State<AiContentViewerScreen> createState() => _AiContentViewerScreenState();  // Crea y retorna la instancia del estado privado
}

/// ═══ CLASE: _AiContentViewerScreenState ═══
/// ═══ Estado privado que maneja la lógica y apariencia de la pantalla ═══
class _AiContentViewerScreenState extends State<AiContentViewerScreen> {  // Extiende State para manejar el estado mutable
  bool _isLoading = true;  // Bandera que indica si el contenido está cargando inicialmente
  String _formattedContent = '';  // Almacena el contenido formateado para mostrar

  @override  // Sobrescribe el método de inicialización del ciclo de vida
  void initState() {  // Se ejecuta cuando se inicializa el widget por primera vez
    super.initState();  // Llama al initState de la clase padre
    _formatContent();  // Ejecuta la función para formatear el contenido
  }

  void _formatContent() {  // Método privado que formatea el contenido IA para su visualización
    setState(() {  // Notifica al framework que el estado ha cambiado y necesita reconstruirse
      _formattedContent = widget.content.content;  // Asigna el contenido raw al campo formateado
      _isLoading = false;  // Marca la carga como completada
    });  // Cierra la función setState
  }  // Fin del método _formatContent

  void _copyToClipboard() {  // Método privado que copia el contenido al portapapeles del dispositivo
    Clipboard.setData(ClipboardData(text: widget.content.content));  // Escribe el texto en el portapapeles del sistema
    AppNotifications.show(context, '¡CONTENIDO COPIADO AL PORTAPELES!');  // Muestra notificación de confirmación al usuario
  }  // Fin del método _copyToClipboard

  List<String> _extractCodeBlocks() {  // Método privado que extrae bloques de código del contenido usando regex
    final codeBlocks = <String>[];  // Lista vacía para almacenar los bloques de código encontrados
    final regex = RegExp(r'```[\s\S]*?```');  // Expresión regular que encuentra texto entre triples backticks
    final matches = regex.allMatches(widget.content.content);  // Encuentra todas las coincidencias en el contenido
    for (final match in matches) {  // Itera sobre cada coincidencia de bloque de código encontrada
      String code = match.group(0) ?? '';  // Obtiene el texto completo de la coincidencia actual
      code = code.replaceAll(RegExp(r'^```\w*\n?'), '');  // Elimina la línea de apertura con lenguaje opcional
      code = code.replaceAll(RegExp(r'\n?```$'), '');  // Elimina la línea de cierre con triples backticks
      codeBlocks.add(code.trim());  // Agrega el código limpio y sin espacios a la lista
    }  // Fin del bucle for
    return codeBlocks;  // Retorna la lista de bloques de código extraídos
  }  // Fin del método _extractCodeBlocks

  @override  // Sobrescribe el método build que construye la interfaz visual
  Widget build(BuildContext context) {  // Método que retorna el árbol de widgets de la pantalla
    final screenWidth = MediaQuery.of(context).size.width;  // Obtiene el ancho actual de la pantalla del dispositivo
    final bool isMobile = screenWidth < 700;  // Determina si es dispositivo móvil según el ancho
    final sidePadding = isMobile ? 15.0 : 100.0;  // Define el padding lateral según el tipo de dispositivo

    Color accentColor;  // Variable para almacenar el color de acento según el tipo de contenido
    IconData titleIconData;  // Variable para almacenar el ícono del título según el tipo
    switch (widget.content.itemType) {  // Evalúa el tipo de item del contenido IA
      case 'explicacion':  // Caso cuando es una explicación
        accentColor = AppTheme.primaryCyan;  // Usa el color cyan principal del tema
        titleIconData = Icons.menu_book;  // Usa el ícono de libro
        break;  // Rompe el switch
      case 'ejercicio':  // Caso cuando es un ejercicio
        accentColor = AppTheme.neonGreen;  // Usa el color verde neón del tema
        titleIconData = Icons.code;  // Usa el ícono de código
        break;  // Rompe el switch
      case 'mini_curso':  // Caso cuando es un mini curso
        accentColor = const Color(0xFFFFD700);  // Usa el color dorado (gold)
        titleIconData = Icons.school;  // Usa el ícono de escuela
        break;  // Rompe el switch
      default:  // Caso por defecto para tipos no reconocidos
        accentColor = AppTheme.primaryCyan;  // Usa el color cyan como fallback
        titleIconData = Icons.smart_toy;  // Usa el ícono de robot como fallback
    }  // Fin del switch

    return CRTOverlay(  // Envuelve todo en un efecto de superposición CRT retro
      child: Scaffold(  // Crea la estructura base Material de la pantalla
        backgroundColor: AppTheme.darkBg,  // Establece el color de fondo oscuro del tema
        body: LayoutBuilder(  // Widget que permite construir basado en las restricciones de layout
          builder: (context, constraints) {  // Función builder que recibe contexto y restricciones
            return SafeArea(  // Asegura que el contenido no se solape con barras del sistema
              child: Stack(  // Permite superponer widgets en capas
                children: [  // Lista de widgets hijos del Stack
                  Positioned.fill(  // Widget que ocupa todo el espacio disponible
                    child: SingleChildScrollView(  // Permite scroll vertical para contenido largo
                      padding: EdgeInsets.only(  // Define padding desigual por cada lado
                        left: sidePadding,  // Padding izquierdo dinámico
                        right: sidePadding,  // Padding derecho dinámico
                        top: 80,  // Padding superior fijo de 80 píxeles
                        bottom: 100,  // Padding inferior fijo de 100 píxeles para el footer
                      ),  // Fin del padding
                      child: Column(  // Organiza widgets en columna vertical
                        crossAxisAlignment: CrossAxisAlignment.start,  // Alinea hijos al inicio horizontal
                        children: [  // Lista de widgets en la columna
                          _buildHeader(accentColor, titleIconData, isMobile),  // Construye el encabezado
                          const SizedBox(height: 25),  // Espacio vertical de 25 píxeles
                          _buildBadges(accentColor),  // Construye las insignias de tipo y dificultad
                          const SizedBox(height: 25),  // Espacio vertical de 25 píxeles
                          _buildContentCard(accentColor, isMobile),  // Construye la tarjeta de contenido
                          const SizedBox(height: 25),  // Espacio vertical de 25 píxeles
                          if (_extractCodeBlocks().isNotEmpty) ...[  // Si hay bloques de código, mostrar sección
                            _buildCodeBlocksSection(accentColor, isMobile),  // Construye sección de bloques de código
                            const SizedBox(height: 25),  // Espacio vertical de 25 píxeles
                          ],  // Fin del condicional de bloques de código
                          _buildActionButtons(accentColor),  // Construye los botones de acción
                          const SizedBox(height: 40),  // Espacio vertical de 40 píxeles
                          _buildPixelClipComment(accentColor),  // Construye el comentario de PixelClip
                        ],  // Fin de la lista de children
                      ),  // Fin del Column
                    ),  // Fin del SingleChildScrollView
                  ),  // Fin del Positioned.fill
                  const Positioned(  // Widget posicionado en coordenadas específicas
                    bottom: 0,  // Posicionado en la parte inferior
                    left: 0,  // Alineado a la izquierda
                    right: 0,  // Alineado a la derecha
                    child: AppFooter(borderColor: AppTheme.borderBlue),  // Muestra el footer con borde azul
                  ),  // Fin del Positioned del footer
                ],  // Fin de la lista de children del Stack
              ),  // Fin del Stack
            );  // Fin del SafeArea
          },  // Fin de la función builder
        ),  // Fin del LayoutBuilder
      ),  // Fin del Scaffold
    );  // Fin del CRTOverlay
  }  // Fin del método build

  /// ═══ MÉTODO: _buildHeader ═══
  /// ═══ Construye el encabezado con título, ícono y botón de volver ═══
  Widget _buildHeader(Color accentColor, IconData icon, bool isMobile) {  // Método privado que construye el header
    return Row(  // Organiza los elementos del header en fila horizontal
      children: [  // Lista de widgets hijos
        Expanded(  // Ocupa todo el espacio disponible en la fila
          child: Column(  // Organiza título y tema en columna
            crossAxisAlignment: CrossAxisAlignment.start,  // Alinea al inicio horizontal
            children: [  // Lista de widgets
              Row(  // Fila para ícono y título
                children: [  // Lista de widgets
                  Icon(icon, color: accentColor, size: isMobile ? 16 : 20),  // Ícono dinámico con color y tamaño adaptable
                  const SizedBox(width: 8),  // Espacio horizontal de 8 píxeles
                  Expanded(  // Ocupa el espacio restante
                    child: Text(  // Muestra el texto del título
                      '${_getTypeTitle()}',  // Obtiene el título formateado según el tipo
                      style: GoogleFonts.pressStart2p(  // Aplica la fuente pixelada Press Start 2P
                        color: accentColor,  // Color de acento dinámico
                        fontSize: isMobile ? 10 : 14,  // Tamaño de fuente adaptable según dispositivo
                      ),  // Fin del estilo
                    ),  // Fin del Text
                  ),  // Fin del Expanded
                ],  // Fin de la lista de children del Row interno
              ),  // Fin del Row del título
              const SizedBox(height: 8),  // Espacio vertical de 8 píxeles
              Text(  // Muestra el tema del contenido
                'Tema: ${widget.content.topic}',  // Concatena el label con el tema del contenido
                style: GoogleFonts.shareTechMono(  // Aplica la fuente monoespaciada Share Tech Mono
                  color: Colors.white70,  // Color blanco con 70% de opacidad
                  fontSize: 12,  // Tamaño de fuente fijo de 12 píxeles
                ),  // Fin del estilo
              ),  // Fin del Text del tema
            ],  // Fin de la lista de children del Column
          ),  // Fin del Column
        ),  // Fin del Expanded
        RetroButton(  // Botón personalizado de estilo retro
          text: 'VOLVER',  // Texto del botón
          icon: Icons.arrow_back,  // Ícono de flecha hacia atrás
          width: 120,  // Ancho fijo de 120 píxeles
          height: 40,  // Alto fijo de 40 píxeles
          style: RetroButtonStyle.secondary,  // Estilo secundario del botón
          fontSize: 8,  // Tamaño de fuente de 8 píxeles
          onPressed: () {  // Callback cuando se presiona el botón
            if (Navigator.of(context).canPop()) {  // Verifica si se puede navegar hacia atrás en el stack
              context.pop();  // Navega hacia atrás en la pila de navegación
            } else {  // Si no se puede hacer pop
              context.go('/tienda');  // Navega directamente a la ruta de la tienda
            }  // Fin del else
          },  // Fin del onPressed
        ),  // Fin del RetroButton
      ],  // Fin de la lista de children del Row principal
    );  // Fin del Row
  }  // Fin del método _buildHeader

  /// ═══ MÉTODO: _buildBadges ═══
  /// ═══ Construye las insignias de tipo, dificultad y fecha ═══
  Widget _buildBadges(Color accentColor) {  // Método privado que construye las badges informativas
    return Row(  // Organiza las badges en fila horizontal
      children: [  // Lista de widgets hijos
        Container(  // Contenedor para la badge de tipo de item
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),  // Padding simétrico horizontal y vertical
          decoration: BoxDecoration(  // Define la decoración visual del contenedor
            color: accentColor.withValues(alpha: 0.2),  // Color de acento con 20% de opacidad
            border: Border.all(color: accentColor, width: 1),  // Borde con color de acento y grosor 1
          ),  // Fin del BoxDecoration
          child: Text(  // Muestra el tipo de item en mayúsculas
            widget.content.itemType.toUpperCase(),  // Convierte el tipo de item a mayúsculas
            style: GoogleFonts.shareTechMono(  // Aplica la fuente Share Tech Mono
              color: accentColor,  // Color de acento dinámico
              fontSize: 10,  // Tamaño de fuente de 10 píxeles
              fontWeight: FontWeight.bold,  // Peso de fuente negrita
            ),  // Fin del estilo
          ),  // Fin del Text
        ),  // Fin del Container del tipo
        const SizedBox(width: 10),  // Espacio horizontal de 10 píxeles
        Container(  // Contenedor para la badge de dificultad
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),  // Padding simétrico horizontal y vertical
          decoration: BoxDecoration(  // Define la decoración visual del contenedor
            color: AppTheme.borderBlue.withValues(alpha: 0.2),  // Color azul de borde con 20% opacidad
            border: Border.all(color: AppTheme.borderBlue, width: 1),  // Borde con color azul del tema
          ),  // Fin del BoxDecoration
          child: Text(  // Muestra la dificultad en mayúsculas
            widget.content.difficulty.toUpperCase(),  // Convierte la dificultad a mayúsculas
            style: GoogleFonts.shareTechMono(  // Aplica la fuente Share Tech Mono
              color: AppTheme.borderBlue,  // Color azul del tema
              fontSize: 10,  // Tamaño de fuente de 10 píxeles
            ),  // Fin del estilo
          ),  // Fin del Text
        ),  // Fin del Container de dificultad
        const SizedBox(width: 10),  // Espacio horizontal de 10 píxeles
        Text(  // Muestra la fecha formateada de creación
          _formatDate(widget.content.createdAt),  // Formatea la fecha de creación del contenido
          style: GoogleFonts.shareTechMono(color: Colors.grey, fontSize: 10),  // Fuente gris de 10 píxeles
        ),  // Fin del Text de fecha
      ],  // Fin de la lista de children
    );  // Fin del Row
  }  // Fin del método _buildBadges

  /// ═══ MÉTODO: _buildContentCard ═══
  /// ═══ Construye la tarjeta principal que muestra el contenido IA ═══
  Widget _buildContentCard(Color accentColor, bool isMobile) {  // Método privado que construye la tarjeta de contenido
    return RetroContainer(  // Contenedor de estilo retro personalizado
      isWin95: false,  // Desactiva el estilo Windows 95
      borderColor: accentColor.withValues(alpha: 0.6),  // Borde con color de acento al 60% de opacidad
      backgroundColor: const Color(0xFF14243D).withValues(alpha: 0.5),  // Fondo azul oscuro al 50% de opacidad
      child: Column(  // Organiza el contenido en columna
        crossAxisAlignment: CrossAxisAlignment.start,  // Alinea hijos al inicio horizontal
        children: [  // Lista de widgets hijos
          Container(  // Contenedor para el encabezado de la tarjeta
            padding: const EdgeInsets.all(12),  // Padding uniforme de 12 píxeles
            decoration: BoxDecoration(  // Define la decoración visual
              color: accentColor.withValues(alpha: 0.1),  // Color de acento al 10% de opacidad
              border: const Border(  // Define bordes específicos
                bottom: BorderSide(color: AppTheme.borderBlue, width: 1),  // Solo borde inferior azul
              ),  // Fin del Border
            ),  // Fin del BoxDecoration
            child: Row(  // Organiza ícono y texto en fila
              children: [  // Lista de widgets
                Icon(Icons.article, color: accentColor, size: 18),  // Ícono de artículo con color de acento
                const SizedBox(width: 10),  // Espacio horizontal de 10 píxeles
                Text(  // Muestra el label de contenido IA
                  'CONTENIDO GENERADO POR IA',  // Texto estático descriptivo
                  style: GoogleFonts.pressStart2p(  // Aplica fuente pixelada Press Start 2P
                    color: accentColor,  // Color de acento dinámico
                    fontSize: 8,  // Tamaño de fuente pequeño de 8 píxeles
                  ),  // Fin del estilo
                ),  // Fin del Text
              ],  // Fin de la lista de children
            ),  // Fin del Row
          ),  // Fin del Container del encabezado
          Padding(  // Widget de padding para el contenido principal
            padding: EdgeInsets.all(isMobile ? 15 : 25),  // Padding dinámico según tipo de dispositivo
            child: Column(  // Organiza el contenido en columna
              crossAxisAlignment: CrossAxisAlignment.start,  // Alinea al inicio horizontal
              children: [  // Lista de widgets hijos
                if (_isLoading)  // Condición: si está cargando
                  const Center(  // Centra el indicador de carga
                    child: CircularProgressIndicator(  // Indicador circular de progreso
                      color: AppTheme.primaryCyan,  // Color cyan principal del tema
                    ),  // Fin del CircularProgressIndicator
                  )  // Fin del Center
                else  // Si no está cargando
                  Text(  // Muestra el contenido formateado
                    _formattedContent,  // Variable con el contenido ya formateado
                    style: GoogleFonts.firaCode(  // Aplica la fuente monoespaciada Fira Code
                      color: Colors.white,  // Color blanco puro
                      fontSize: isMobile ? 18 : 16,  // Tamaño de fuente adaptable
                      height: 1.8,  // Interlineado de 1.8 veces el tamaño de fuente
                    ),  // Fin del estilo
                  ),  // Fin del Text
              ],  // Fin de la lista de children
            ),  // Fin del Column
          ),  // Fin del Padding
        ],  // Fin de la lista de children
      ),  // Fin del Column
    );  // Fin del RetroContainer
  }  // Fin del método _buildContentCard

  /// ═══ MÉTODO: _buildCodeBlocksSection ═══
  /// ═══ Construye la sección completa de bloques de código extraídos ═══
  Widget _buildCodeBlocksSection(Color accentColor, bool isMobile) {  // Método que construye la sección de código
    final codeBlocks = _extractCodeBlocks();  // Extrae los bloques de código del contenido
    return Column(  // Organiza título y bloques en columna
      crossAxisAlignment: CrossAxisAlignment.start,  // Alinea hijos al inicio horizontal
      children: [  // Lista de widgets hijos
        Text(  // Muestra el título de la sección
          'BLOQUES DE CODIGO',  // Texto estático del encabezado
          style: GoogleFonts.pressStart2p(color: accentColor, fontSize: 10),  // Fuente pixelada con color de acento
        ),  // Fin del Text
        const SizedBox(height: 15),  // Espacio vertical de 15 píxeles
        ...codeBlocks.asMap().entries.map((entry) {  // Spread operator para mapear cada bloque de código
          final index = entry.key;  // Obtiene el índice actual del bloque
          final code = entry.value;  // Obtiene el código del bloque actual
          return Padding(  // Envuelve cada bloque con padding inferior
            padding: const EdgeInsets.only(bottom: 15),  // Padding solo inferior de 15 píxeles
            child: _buildCodeBlock(code, index + 1, accentColor, isMobile),  // Construye bloque individual con número 1-based
          );  // Fin del Padding
        }),  // Fin del map
      ],  // Fin de la lista de children
    );  // Fin del Column
  }  // Fin del método _buildCodeBlocksSection

  /// ═══ MÉTODO: _buildCodeBlock ═══
  /// ═══ Construye un bloque individual de código con opción de copiar ═══
  Widget _buildCodeBlock(String code, int number, Color accentColor, bool isMobile) {  // Método que construye un bloque de código
    return Container(  // Contenedor principal del bloque de código
      decoration: BoxDecoration(  // Define la decoración visual
        color: Colors.black,  // Fondo negro puro para el código
        border: Border.all(color: accentColor.withValues(alpha: 0.4), width: 1),  // Borde con acento al 40% opacidad
      ),  // Fin del BoxDecoration
      child: Column(  // Organiza encabezado y código en columna
        crossAxisAlignment: CrossAxisAlignment.start,  // Alinea hijos al inicio horizontal
        children: [  // Lista de widgets hijos
          Container(  // Contenedor para el encabezado del bloque
            padding: EdgeInsets.symmetric(  // Padding simétrico adaptable
              horizontal: isMobile ? 10 : 12,  // Padding horizontal dinámico
              vertical: isMobile ? 6 : 8,  // Padding vertical dinámico
            ),  // Fin del padding
            decoration: BoxDecoration(  // Define la decoración del encabezado
              color: accentColor.withValues(alpha: 0.1),  // Color de acento al 10% opacidad
              border: const Border(  // Define bordes específicos
                bottom: BorderSide(color: AppTheme.borderBlue, width: 1),  // Solo borde inferior azul
              ),  // Fin del Border
            ),  // Fin del BoxDecoration
            child: Row(  // Organiza etiqueta y botón en fila
              mainAxisAlignment: MainAxisAlignment.spaceBetween,  // Distribuye espacio entre hijos
              children: [  // Lista de widgets
                Flexible(  // Permite que el texto se adapte al espacio disponible
                  child: Text(  // Muestra la etiqueta del bloque
                    'BLOQUE #$number',  // Texto con número de bloque
                    style: GoogleFonts.shareTechMono(  // Aplica fuente Share Tech Mono
                      color: accentColor,  // Color de acento dinámico
                      fontSize: isMobile ? 11 : 10,  // Tamaño de fuente adaptable
                    ),  // Fin del estilo
                    overflow: TextOverflow.ellipsis,  // Trunca con puntos suspensivos si excede
                  ),  // Fin del Text
                ),  // Fin del Flexible
                GestureDetector(  // Widget detectable a toques/gestos
                  onTap: () {  // Callback cuando se toca el widget
                    Clipboard.setData(ClipboardData(text: code));  // Copia el código al portapapeles
                    AppNotifications.show(context, '¡CÓDIGO #$number COPIADO!');  // Muestra notificación de éxito
                  },  // Fin del onTap
                  child: Row(  // Organiza ícono y texto en fila
                    children: [  // Lista de widgets
                      Icon(Icons.copy, size: isMobile ? 14 : 16, color: Colors.white70),  // Ícono de copiar con tamaño adaptable
                      SizedBox(width: isMobile ? 4 : 5),  // Espacio horizontal adaptable
                      Text('COPIAR', style: GoogleFonts.shareTechMono(color: Colors.white70, fontSize: isMobile ? 10 : 9)),  // Texto copiar
                    ],  // Fin de la lista de children
                  ),  // Fin del Row
                ),  // Fin del GestureDetector
              ],  // Fin de la lista de children
            ),  // Fin del Row
          ),  // Fin del Container del encabezado
          Padding(  // Widget de padding para el código
            padding: EdgeInsets.all(isMobile ? 12 : 18),  // Padding dinámico según dispositivo
            child: SingleChildScrollView(  // Permite scroll horizontal para líneas largas
              scrollDirection: Axis.horizontal,  // Dirección de scroll horizontal
              child: Text(  // Muestra el código
                code,  // Variable con el código del bloque
                style: GoogleFonts.firaCode(  // Aplica fuente Fira Code
                  color: AppTheme.neonGreen,  // Color verde neón para el código
                  fontSize: isMobile ? 16 : 14,  // Tamaño de fuente adaptable
                  height: 1.7,  // Interlineado de 1.7 veces
                ),  // Fin del estilo
              ),  // Fin del Text
            ),  // Fin del SingleChildScrollView
          ),  // Fin del Padding
        ],  // Fin de la lista de children
      ),  // Fin del Column
    );  // Fin del Container
  }  // Fin del método _buildCodeBlock

  /// ═══ MÉTODO: _buildActionButtons ═══
  /// ═══ Construye los botones de acción principales (copiar y compartir) ═══
  Widget _buildActionButtons(Color accentColor) {  // Método que construye la fila de botones de acción
    return Row(  // Organiza botones en fila horizontal
      mainAxisAlignment: MainAxisAlignment.center,  // Centra los botones horizontalmente
      children: [  // Lista de widgets hijos
        RetroButton(  // Primer botón de copiar todo
          text: 'COPIAR TODO',  // Texto del botón
          icon: Icons.copy,  // Ícono de copiar
          width: 160,  // Ancho fijo de 160 píxeles
          height: 45,  // Alto fijo de 45 píxeles
          style: RetroButtonStyle.primary,  // Estilo primario del botón
          fontSize: 9,  // Tamaño de fuente de 9 píxeles
          onPressed: _copyToClipboard,  // Ejecuta el método para copiar al portapapeles
        ),  // Fin del primer RetroButton
        const SizedBox(width: 15),  // Espacio horizontal de 15 píxeles
        RetroButton(  // Segundo botón de compartir
          text: 'COMPARTIR',  // Texto del botón
          icon: Icons.share,  // Ícono de compartir
          width: 160,  // Ancho fijo de 160 píxeles
          height: 45,  // Alto fijo de 45 píxeles
          style: RetroButtonStyle.secondary,  // Estilo secundario del botón
          fontSize: 9,  // Tamaño de fuente de 9 píxeles
          onPressed: () {  // Callback cuando se presiona
            AppNotifications.show(context, 'FUNCIÓN DE COMPARTIR EN DESARROLLO...');  // Muestra mensaje de función en desarrollo
          },  // Fin del onPressed
        ),  // Fin del segundo RetroButton
      ],  // Fin de la lista de children
    );  // Fin del Row
  }  // Fin del método _buildActionButtons

  /// ═══ MÉTODO: _buildPixelClipComment ═══
  /// ═══ Construye el comentario motivacional de PixelClip al final ═══
  Widget _buildPixelClipComment(Color accentColor) {  // Método que construye la sección de PixelClip
    return Row(  // Organiza logo y comentario en fila
      crossAxisAlignment: CrossAxisAlignment.end,  // Alinea hijos al final verticalmente
      children: [  // Lista de widgets hijos
        const PixelClipLogo(size: 70),  // Logo de PixelClip con tamaño fijo de 70 píxeles
        const SizedBox(width: 15),  // Espacio horizontal de 15 píxeles
        Expanded(  // Ocupa el espacio restante
          child: Container(  // Contenedor del comentario estilo burbuja
            padding: const EdgeInsets.all(15),  // Padding uniforme de 15 píxeles
            decoration: BoxDecoration(  // Define la decoración visual
              color: Colors.white,  // Fondo blanco puro
              border: Border.all(color: Colors.black, width: 2),  // Borde negro de 2 píxeles
              boxShadow: [  // Lista de sombras
                BoxShadow(  // Define una sombra
                  color: Colors.black.withValues(alpha: 0.3),  // Color negro al 30% de opacidad
                  offset: const Offset(3, 3),  // Desplazamiento de 3 píxeles en X e Y
                ),  // Fin del BoxShadow
              ],  // Fin de la lista de sombras
            ),  // Fin del BoxDecoration
            child: Text(  // Muestra el mensaje de PixelClip
              _getPixelClipMessage(),  // Obtiene el mensaje según tipo de contenido
              style: GoogleFonts.shareTechMono(  // Aplica fuente Share Tech Mono
                color: Colors.black,  // Color negro puro
                fontSize: 11,  // Tamaño de fuente de 11 píxeles
                fontWeight: FontWeight.bold,  // Peso de fuente negrita
              ),  // Fin del estilo
            ),  // Fin del Text
          ),  // Fin del Container
        ),  // Fin del Expanded
      ],  // Fin de la lista de children
    );  // Fin del Row
  }  // Fin del método _buildPixelClipComment

  /// ═══ MÉTODO: _getTypeTitle ═══
  /// ═══ Retorna el título formateado según el tipo de contenido IA ═══
  String _getTypeTitle() {  // Método privado que mapea el tipo de item a su título
    switch (widget.content.itemType) {  // Evalúa el tipo de item del contenido
      case 'explicacion': return 'EXPLICACIÓN';  // Retorna título en español para explicación
      case 'ejercicio': return 'EJERCICIO';  // Retorna título en español para ejercicio
      case 'mini_curso': return 'MINI-CURSO';  // Retorna título en español para mini curso
      default: return 'CONTENIDO IA';  // Retorna título genérico como fallback
    }  // Fin del switch
  }  // Fin del método _getTypeTitle

  /// ═══ MÉTODO: _formatDate ═══
  /// ═══ Formatea la fecha en formato DD/MM/AAAA HH:MM ═══
  String _formatDate(DateTime date) {  // Método privado que formatea un objeto DateTime a string
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';  // Retorna fecha formateada
  }  // Fin del método _formatDate

  /// ═══ MÉTODO: _getPixelClipMessage ═══
  /// ═══ Retorna el mensaje motivacional de PixelClip según el tipo ═══
  String _getPixelClipMessage() {  // Método privado que selecciona mensaje según tipo
    switch (widget.content.itemType) {  // Evalúa el tipo de item del contenido
      case 'explicacion': return '¡Espero que esta explicacion te sea util! Recuerda: la practica hace al maestro. ¡Sigue asi!';  // Mensaje para explicación
      case 'ejercicio': return '¡A codificar! Recuerda: cada error es una oportunidad de aprendizaje. ¡Tu puedes!';  // Mensaje para ejercicio
      case 'mini_curso': return '¡Excelente eleccion de aprendizaje! Dedica 15-20 minutos a este curso y veras grandes resultados.';  // Mensaje para mini curso
      default: return '¡Sigue aprendiendo! Cada paso cuenta en tu camino para dominar Python.';  // Mensaje genérico fallback
    }  // Fin del switch
  }  // Fin del método _getPixelClipMessage
}  // Fin de la clase _AiContentViewerScreenState
