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

/// ═══ IMPORTS ═══
/// Importaciones necesarias para la pantalla de la tienda.
import 'package:flutter/material.dart';  // Framework principal de Flutter para widgets y UI
import 'package:flutter_riverpod/flutter_riverpod.dart';  // Gestión de estado reactivo con Riverpod
import 'package:google_fonts/google_fonts.dart';  // Carga de fuentes tipográficas de Google
import 'package:go_router/go_router.dart';  // Enrutamiento declarativo para navegación
import 'package:firebase_auth/firebase_auth.dart';  // Autenticación de usuarios con Firebase
import 'package:cloud_firestore/cloud_firestore.dart';  // Base de datos en tiempo real Firestore
import '../theme/app_theme.dart';  // Tema visual y colores de la aplicación
import '../widgets/app_header_buttons.dart';  // Botones de cabecera reutilizables
import '../widgets/retro_button.dart';  // Botón con estilo retro personalizado
import '../widgets/retro_container.dart';  // Contenedor con estilo retro personalizado
import '../widgets/pixel_clip_dialog.dart';  // Diálogo con estilo de recorte pixelado
import '../widgets/app_footer.dart';  // Pie de página reutilizable de la app
import '../widgets/app_notifications.dart';  // Sistema de notificaciones de la app
import '../widgets/ai_purchase_dialog.dart';  // Diálogo de compra con IA personalizado
import '../providers/firebase_providers.dart';  // Providers de Firebase para Riverpod
import '../providers/economia_provider.dart';  // Provider de economía y monedas
import '../services/ai_gemini_service.dart';  // Servicio de generación de contenido con IA Gemini
import '../models/ai_content.dart';  // Modelos de contenido generado por IA

/// ═══ CLASE: _ShopItem ═══
/// Modelo de datos interno que representa cada artículo disponible en la tienda.
/// Define las propiedades esenciales de un producto: identificador, título, descripción,
/// precio, icono visual, color temático y tipo de contenido que generará la IA.
class _ShopItem {
  final String id;  // Identificador único del artículo en la tienda
  final String title;  // Título visible del artículo para el usuario
  final String description;  // Descripción detallada del contenido del artículo
  final int price;  // Precio en PY-Coins que cuesta adquirir este artículo
  final IconData icon;  // Icono Material Design que representa visualmente el artículo
  final Color color;  // Color temático asociado al artículo para UI
  final String itemType;  // Tipo de contenido IA: 'explicacion', 'ejercicio', 'mini_curso'

  const _ShopItem({  // Constructor constante para instancias compile-time
    required this.id,  // Parámetro obligatorio: identificador único
    required this.title,  // Parámetro obligatorio: título del artículo
    required this.description,  // Parámetro obligatorio: descripción del artículo
    required this.price,  // Parámetro obligatorio: precio en PY-Coins
    required this.icon,  // Parámetro obligatorio: icono representativo
    required this.itemType,  // Parámetro obligatorio: tipo de item de IA
    Color? color,  // Parámetro opcional: color temático (tiene valor por defecto)
  }) : color = color ?? AppTheme.primaryCyan;  // Si no se pasa color, usa cyan primario del tema
}

// Constante para color de items comprados: dorado (#FFD700) que indica adquisición exitosa
const _purchasedColor = Color(0xFFFFD700);

/// ═══ CLASE: TiendaScreen ═══
/// Pantalla principal de la Tienda que gestiona las adquisiciones de contenido generado por IA.
/// Permite al usuario comprar explicaciones detalladas, ejercicios extra y mini-cursos usando
/// su saldo de PY-Coins. Integra verificación de autenticación, límites diarios de uso y
/// navegación automática al contenido generado tras la compra exitosa.
class TiendaScreen extends ConsumerStatefulWidget {
  const TiendaScreen({super.key});  // Constructor con clave opcional del widget padre

  @override
  ConsumerState<TiendaScreen> createState() => _TiendaScreenState();  // Crea el estado consumible con Riverpod
}

/// ═══ CLASE: _TiendaScreenState ═══
/// Estado de la pantalla de tienda que maneja toda la lógica de negocio: servicio de IA,
/// rastreo de compras, estados de carga, selección de temas, lista de productos y
/// procesamiento de transacciones con Firestore.
class _TiendaScreenState extends ConsumerState<TiendaScreen> {
  // Servicio de IA
  final AiGeminiService _aiService = AiGeminiService();  // Instancia del servicio Gemini para generar contenido con IA

  // Rastreo local de items comprados en esta sesión.
  final Set<String> _purchasedItems = {};  // Conjunto de IDs de artículos ya comprados durante esta sesión

  // Estado de carga para cada item
  final Map<String, bool> _loadingItems = {};  // Mapa de IDs a booleano que indica si el artículo se está generando

  // Tema seleccionado para la compra
  String? _selectedTopic;  // Tema que el usuario seleccionó para generar contenido (null si no hay selección)

  // Lista de productos disponibles en la tienda
  final List<_ShopItem> _items = const [  // Lista constante de los 3 artículos disponibles en la tienda
    _ShopItem(
      id: 'desc_det',  // Identificador único para explicación detallada
      title: 'Explicación Detallada',  // Título visible del producto
      description:  // Descripción del contenido que recibirá el usuario
          'Accede a una explicación profunda del concepto con ejemplos adicionales',
      price: 20,  // Costo de 20 PY-Coins
      icon: Icons.menu_book,  // Icono de libro abierto
      itemType: 'explicacion',  // Tipo de contenido IA: explicación
    ),
    _ShopItem(
      id: 'extra_ex',  // Identificador único para ejercicio extra
      title: 'Ejercicio Extra',  // Título visible del producto
      description: 'Desbloquea un ejercicio especial de práctica avanzada',  // Descripción del contenido
      price: 50,  // Costo de 50 PY-Coins
      icon: Icons.star_border,  // Icono de estrella
      itemType: 'ejercicio',  // Tipo de contenido IA: ejercicio
    ),
    _ShopItem(
      id: 'mini_ia',  // Identificador único para mini-curso
      title: 'Mini-Curso IA',  // Título visible del producto
      description:  // Descripción del contenido personalizado
          'Acceso a un mini-curso personalizado generado por IA sobre un tema específico',
      price: 100,  // Costo de 100 PY-Coins
      icon: Icons.auto_awesome,  // Icono de estrella mágica/IA
      itemType: 'mini_curso',  // Tipo de contenido IA: mini-curso
    ),
  ];

  /// ═══ MÉTODO: _showTopicSelection ═══
  /// Muestra un diálogo modal que permite al usuario escribir el tema sobre el cual
  /// quiere que la IA genere contenido. El diálogo contiene un campo de texto para
  /// ingresar el tema y botones de cancelar/continuar. Solo permite continuar si
  /// se ha escrito un tema válido.
  void _showTopicSelection(_ShopItem item) {  // Recibe el artículo de tienda seleccionado
    // Variable local para el tema siendo editado
    String? localTopic = _selectedTopic;  // Copia local del tema seleccionado para manipular dentro del diálogo

    showDialog(  // Abre un diálogo modal sobre la pantalla actual
      context: context,  // Contexto de build actual para ubicar el diálogo
      barrierDismissible: false,  // Impide cerrar el diálogo tocando fuera de él
      builder: (context) => StatefulBuilder(  // Builder con estado interno para actualizar el diálogo dinámicamente
        builder: (context, setDialogState) => Dialog(  // Widget de diálogo base
          backgroundColor: Colors.transparent,  // Fondo transparente para usar decoración personalizada
          child: Container(  // Contenedor principal del diálogo
            constraints: const BoxConstraints(maxWidth: 500),  // Ancho máximo de 500 píxeles
            decoration: BoxDecoration(  // Decoración visual del contenedor
              color: AppTheme.darkBg,  // Color de fondo oscuro del tema
              border: Border.all(color: item.color, width: 2),  // Borde del color del artículo con grosor 2
            ),
            child: Column(  // Columna vertical para organizar elementos del diálogo
              mainAxisSize: MainAxisSize.min,  // Tamaño mínimo necesario para el contenido
              children: [  // Lista de widgets hijos
                // Header
                Container(  // Contenedor de la cabecera del diálogo
                  width: double.infinity,  // Ancho completo disponible
                  padding: const EdgeInsets.all(15),  // Padding de 15 píxeles en todos los lados
                  decoration: BoxDecoration(  // Decoración de la cabecera
                    color: item.color.withValues(alpha: 0.1),  // Fondo con color del artículo al 10% de opacidad
                    border: const Border(  // Solo borde inferior visible
                      bottom: BorderSide(color: AppTheme.borderBlue, width: 1),  // Línea separadora azul
                    ),
                  ),
                  child: Row(  // Fila horizontal para icono y título
                    children: [  // Widgets hijos de la fila
                      Icon(item.icon, color: item.color, size: 24),  // Icono del artículo con su color y tamaño 24
                      const SizedBox(width: 10),  // Espaciador horizontal de 10 píxeles
                      Expanded(  // Expande el texto para ocupar espacio restante
                        child: Text(  // Texto del título de la cabecera
                          'Selecciona el tema',  // Texto visible
                          style: GoogleFonts.pressStart2p(  // Fuente pixel-art estilo retro
                            color: item.color,  // Color del texto igual al del artículo
                            fontSize: 10,  // Tamaño de fuente pequeño (estilo retro)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Contenido
                Padding(  // Espaciado interno del contenido del diálogo
                  padding: const EdgeInsets.all(20),  // Padding de 20 píxeles en todos los lados
                  child: Column(  // Columna vertical para el contenido
                    mainAxisSize: MainAxisSize.min,  // Tamaño mínimo necesario
                    children: [  // Widgets hijos
                      Text(  // Texto de pregunta sobre el tema
                        '¿Sobre qué tema quieres tu ${item.title.toLowerCase()}?',  // Pregunta dinámica con título del item
                        style: GoogleFonts.shareTechMono(  // Fuente monoespaciada tecnológica
                          color: Colors.white,  // Color blanco para el texto
                          fontSize: 13,  // Tamaño de fuente 13
                          height: 1.5,  // Interlineado de 1.5 veces el tamaño
                        ),
                        textAlign: TextAlign.center,  // Texto centrado horizontalmente
                      ),
                      const SizedBox(height: 20),  // Espaciador vertical de 20 píxeles

                      // Campo de texto para el tema
                      TextField(  // Campo de entrada de texto editable
                        autofocus: true,  // Enfoca automáticamente al abrir el diálogo
                        decoration: InputDecoration(  // Decoración visual del campo de texto
                          hintText:  // Texto de sugerencia cuando está vacío
                              'Ej: listas, funciones, clases, decoradores...',
                          hintStyle: GoogleFonts.firaCode(color: Colors.white38),  // Estilo del hint con fuente Fira Code
                          filled: true,  // Activa el color de fondo
                          fillColor: const Color(0xFF14243D),  // Color de fondo azul oscuro
                          border: OutlineInputBorder(  // Borde con esquinas redondeadas
                            borderRadius: BorderRadius.circular(4),  // Radio de esquina de 4 píxeles
                            borderSide: BorderSide(color: item.color),  // Borde lateral con color del artículo
                          ),
                          prefixIcon: Icon(Icons.search, color: item.color),  // Icono de búsqueda con color del artículo
                        ),
                        style: GoogleFonts.firaCode(color: Colors.white),  // Estilo del texto escrito por el usuario
                        onChanged: (value) {  // Callback cuando el texto cambia
                          setDialogState(() {  // Actualiza el estado interno del diálogo
                            localTopic = value;  // Guarda el valor escrito en la variable local
                          });
                        },
                      ),
                      const SizedBox(height: 25),  // Espaciador vertical de 25 píxeles

                      // Botones
                      Row(  // Fila horizontal para los botones de acción
                        mainAxisAlignment: MainAxisAlignment.center,  // Botones centrados horizontalmente
                        children: [  // Widgets hijos de la fila
                          RetroButton(  // Botón de cancelar
                            text: 'CANCELAR',  // Texto del botón
                            style: RetroButtonStyle.secondary,  // Estilo visual secundario
                            width: 140,  // Ancho de 140 píxeles
                            height: 45,  // Alto de 45 píxeles
                            fontSize: 9,  // Tamaño de fuente 9 (estilo retro)
                            onPressed: () {  // Acción al presionar
                              Navigator.of(context).pop();  // Cierra el diálogo
                              _selectedTopic = null;  // Limpia el tema seleccionado
                            },
                          ),
                          const SizedBox(width: 15),  // Espaciador horizontal de 15 píxeles
                          RetroButton(  // Botón de continuar
                            text: 'CONTINUAR',  // Texto del botón
                            style: RetroButtonStyle.primary,  // Estilo visual primario
                            backgroundColor: item.color,  // Color de fondo igual al del artículo
                            width: 160,  // Ancho de 160 píxeles
                            height: 45,  // Alto de 45 píxeles
                            fontSize: 9,  // Tamaño de fuente 9 (estilo retro)
                            onPressed: (localTopic != null &&  // Solo habilitado si hay tema escrito
                                    localTopic!.trim().isNotEmpty)  // Y el tema no está vacío tras quitar espacios
                                ? () {  // Si está habilitado:
                                    // Verifica si tiene monedas suficientes usando el provider local (igual que la UI)
                                    final economia = ref.read(economiaProvider);  // lee el provider de economía local
                                    final balance = economia.coins;  // obtiene el saldo local actualizado al instante

                                    if (balance < item.price) {  // si no tiene monedas suficientes
                                      Navigator.of(context).pop();  // cierra el diálogo de selección de tema
                                      AppNotifications.show(  // muestra notificación de error
                                        context,  // contexto actual
                                        'NO HAY SUFICIENTES PY_COINS PARA ESTA COMPRA\nNecesitas: ${item.price} PY-Coins\nTienes: $balance PY-Coins',  // mensaje de error con montos
                                      );
                                      return;  // sale sin abrir el diálogo de compra
                                    }

                                    _selectedTopic = localTopic;  // Guarda el tema en la variable de estado
                                    Navigator.of(context).pop();  // Cierra el diálogo de selección
                                    _showPurchaseDialog(item);  // Abre el diálogo de confirmación de compra
                                  }
                                : null,  // Si no está habilitado: botón desactivado
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ═══ MÉTODO: _showPurchaseDialog ═══
  /// Muestra el diálogo de confirmación de compra que presenta al usuario el resumen
  /// del artículo a comprar, su precio, el saldo actual y botones para confirmar o cancelar.
  /// Lee el saldo del perfil del usuario desde Firestore mediante Riverpod.
  void _showPurchaseDialog(_ShopItem item) {  // Recibe el artículo de tienda a comprar
    // Obtenemos las monedas actuales del perfil del usuario
    final userProfile = ref.read(userProfileProvider);  // Lee el provider del perfil de usuario de Firebase
    final balance = userProfile.value?['coins'] ?? 0;  // Extrae el saldo de monedas o 0 si no existe

    showDialog(  // Abre un diálogo modal de confirmación
      context: context,  // Contexto de build actual
      barrierDismissible: false,  // No permite cerrar tocando fuera del diálogo
      builder: (context) => AiPurchaseDialog(  // Widget personalizado de diálogo de compra con IA
        title: item.title,  // Título del artículo a mostrar
        description: item.description,  // Descripción del artículo a mostrar
        price: item.price,  // Precio del artículo en PY-Coins
        currentBalance: balance,  // Saldo actual del usuario para verificación visual
        icon: item.icon,  // Icono del artículo para identificación visual
        onConfirm: () {  // Callback cuando el usuario confirma la compra
          // El diálogo ya se cerró en _handleConfirm del diálogo
          // Solo procesamos la compra
          _processPurchase(item);  // Inicia el proceso de compra y generación de contenido
        },
      ),
    );
  }

  /// ═══ MÉTODO: _processPurchase ═══
  /// Procesa la compra del artículo verificando autenticación, límite diario, saldo disponible
  /// y tema seleccionado. Si todo es válido, genera contenido con IA según el tipo de artículo,
  /// descuenta las monedas del usuario, registra la transacción en Firestore y navega a la
  /// pantalla de visualización del contenido generado.
  Future<void> _processPurchase(_ShopItem item) async {  // Método asíncrono que procesa la compra del item
    // Verificar que el usuario esté autenticado
    final user = FirebaseAuth.instance.currentUser;  // Obtiene el usuario actualmente logueado en Firebase
    if (user == null) {  // Si no hay usuario autenticado
      if (mounted) {  // Verifica que el widget siga montado en el árbol
        AppNotifications.show(  // Muestra notificación de error
          context,  // Contexto actual
          'ERROR: Debes iniciar sesión para usar la tienda',  // Mensaje de error
        );
      }
      return;  // Sale del método sin procesar la compra
    }

    // Verificar límite diario
    final canUse = await _aiService.canUseService(item.itemType);  // Consulta si puede usar el servicio hoy (límite 1/día)
    if (!canUse) {  // Si ya alcanzó el límite diario para este tipo de servicio
      if (mounted) {  // Verifica que el widget siga montado
        AppNotifications.show(  // Muestra notificación de límite alcanzado
          context,  // Contexto actual
          'LÍMITE ALCANZADO: Ya usaste este servicio hoy. Vuelve mañana.',  // Mensaje informativo
        );
      }
      return;  // Sale del método sin procesar la compra
    }

    // Obtenemos el saldo actual de Firestore
    final userProfile = ref.read(userProfileProvider);  // Lee el provider del perfil del usuario
    final int currentBalance = userProfile.value?['coins'] ?? 0;  // Extrae el saldo actual o 0 por defecto

    // Verificar saldo
    if (currentBalance < item.price) {  // Si el saldo es menor al precio del artículo
      if (mounted) {  // Verifica que el widget siga montado
        AppNotifications.show(
          context, 
          'NO HAY SUFICIENTES PY_COINS PARA ESTA COMPRA\nNecesitas: ${item.price} PY-Coins\nTienes: $currentBalance PY-Coins',
        );  // Muestra notificación de saldo insuficiente con detalles
      }
      return;  // Sale del método sin procesar la compra
    }

    // Validar que se haya seleccionado un tema
    if (_selectedTopic == null || _selectedTopic!.trim().isEmpty) {  // Si no hay tema seleccionado o está vacío
      if (mounted) {  // Verifica que el widget siga montado
        AppNotifications.show(context, 'ERROR: Debes seleccionar un tema');  // Muestra error de tema faltante
      }
      return;  // Sale del método sin procesar la compra
    }

    if (!mounted) return;  // Verificación final de que el widget está montado antes de continuar

    setState(() {  // Actualiza el estado del widget
      _loadingItems[item.id] = true;  // Marca el artículo como "cargando" para mostrar spinner
    });

    try {  // Bloque de intento para captura de errores
      // Generar contenido según el tipo de item
      AiContent content;  // Variable para almacenar el contenido generado por IA

      switch (item.itemType) {  // Selección según el tipo de artículo
        case 'explicacion':  // Si es tipo explicación
          content = await _aiService.generateExplanation(  // Genera explicación con IA
            topic: _selectedTopic!.trim(),  // Tema seleccionado sin espacios extra
            difficulty: 'basic',  // Dificultad básica por defecto
          );
          break;  // Sale del switch
        case 'ejercicio':  // Si es tipo ejercicio
          content = await _aiService.generateExercise(  // Genera ejercicio con IA
            topic: _selectedTopic!.trim(),  // Tema seleccionado sin espacios extra
            difficulty: 'basic',  // Dificultad básica por defecto
          );
          break;  // Sale del switch
        case 'mini_curso':  // Si es tipo mini-curso
          content = await _aiService.generateMiniCourse(  // Genera mini-curso con IA
            topic: _selectedTopic!.trim(),  // Tema seleccionado sin espacios extra
            difficulty: 'basic',  // Dificultad básica por defecto
          );
          break;  // Sale del switch
        default:  // Caso por defecto si el tipo no es reconocido
          throw Exception('Tipo de item no válido');  // Lanza excepción de tipo inválido
      }

      // Calculamos el nuevo saldo
      final int newBalance = currentBalance - item.price;  // Resta el precio del artículo al saldo actual

      // Marcamos el item como comprado localmente
      if (mounted) {  // Verifica que el widget siga montado
        setState(() {  // Actualiza el estado del widget
          _purchasedItems.add(item.id);  // Agrega el ID al conjunto de items comprados
          _loadingItems[item.id] = false;  // Quita el estado de carga del item
        });
      }

      // Actualizar saldo en Firestore
      await FirebaseFirestore.instance  // Acceso a la base de datos Firestore
          .collection('users')  // Colección de usuarios
          .doc(user.uid)  // Documento del usuario actual por su UID
          .update({  // Actualiza los campos del documento
            'coins': newBalance,  // Nuevo saldo de monedas después de la compra
            'totalSpent': FieldValue.increment(item.price),  // Incrementa el total gastado acumulativamente
            'shop_spent': FieldValue.increment(item.price),  // Incrementa el gasto específico en tienda
          });

      // Registrar el gasto en EconomiaProvider para sincronizar todas las pantallas
      final economia = ref.read(economiaProviderNotifier);  // Obtiene el notifier de economía de Riverpod
      await economia.gastarMonedas(item.price, 'tienda');  // Registra el gasto para sincronización global

      // Registrar transacción en el historial
      await FirebaseFirestore.instance.collection('transactions').add({  // Agrega documento a colección de transacciones
        'user_id': user.uid,  // ID del usuario que realizó la compra
        'type': 'tienda_compra',  // Tipo de transacción: compra en tienda
        'item_id': item.id,  // ID del artículo comprado
        'item_name': item.title,  // Nombre legible del artículo
        'amount': -item.price,  // Monto negativo porque es un gasto
        'balance_after': newBalance,  // Saldo restante después de la compra
        'timestamp': FieldValue.serverTimestamp(),  // Marca de tiempo del servidor para consistencia
        'topic': _selectedTopic,  // Tema sobre el cual se generó el contenido
      });

      // Limpiar el tema seleccionado después de la compra exitosa
      _selectedTopic = null;  // Resetea el tema para la próxima compra

      // Notificar éxito y navegar inmediatamente
      if (mounted) {  // Verifica que el widget siga montado
        AppNotifications.show(context, '¡CONTENIDO GENERADO CON ÉXITO!');  // Muestra notificación de éxito

        // Navegar inmediatamente a la pantalla de visualización
        // Usamos push para que el botón "volver" regrese a la tienda
        context.push('/ai-content', extra: content);  // Navega a la ruta de contenido IA pasando el contenido generado
      }
    } catch (e) {  // Captura cualquier excepción lanzada en el bloque try
      // Verificar mounted antes de llamar setState
      if (mounted) {  // Verifica que el widget siga montado
        setState(() {  // Actualiza el estado del widget
          _loadingItems[item.id] = false;  // Quita el estado de carga del item fallido
        });
      }

      if (mounted) {  // Verifica nuevamente que el widget esté montado para mostrar notificación
        // Mostrar error detallado para debugging
        String errorMessage = 'ERROR AL GENERAR CONTENIDO';  // Mensaje de error genérico por defecto
        String errorDetails = e.toString();  // Convierte la excepción a string para análisis

        // Verificar tipos específicos de error
        if (errorDetails.contains('API Key') ||  // Si el error menciona clave de API
            errorDetails.contains('apiKey') ||  // O variante en camelCase
            errorDetails.contains('inválida')) {  // O indica que es inválida
          errorMessage = 'ERROR: API Key inválida o no configurada';  // Mensaje específico de problema con API Key
        } else if (errorDetails.contains('429') ||  // Si es error HTTP 429 (Too Many Requests)
            errorDetails.contains('Límite') ||  // O menciona límite
            errorDetails.contains('quota') ||  // O cuota
            errorDetails.contains('límite de peticiones')) {  // O límite de peticiones
          errorMessage = 'LÍMITE DE PETICIONES ALCANZADO. Intenta mañana';  // Mensaje de límite de tasa
        } else if (errorDetails.contains('auth') ||  // Si el error es de autenticación
            errorDetails.contains('user') ||  // O menciona usuario
            errorDetails.contains('sesión')) {  // O sesión
          errorMessage = 'ERROR: Debes iniciar sesión';  // Mensaje de requerimiento de login
        } else if (errorDetails.contains('network') ||  // Si es error de red
            errorDetails.contains('connection') ||  // O conexión
            errorDetails.contains('conexión') ||  // Variante en español
            errorDetails.contains('internet')) {  // O internet
          errorMessage = 'ERROR: Sin conexión a internet';  // Mensaje de problema de conectividad
        } else if (errorDetails.contains('403') ||  // Si es error HTTP 403 (Forbidden)
            errorDetails.contains('permisos')) {  // O menciona permisos
          errorMessage = 'ERROR: Sin permisos. Verifica la API Key';  // Mensaje de falta de permisos
        } else {  // Si no coincide con ningún patrón conocido
          // Error genérico - mostrar más información
          errorMessage = 'ERROR: $errorDetails';  // Muestra el detalle completo del error
        }

        // Mostrar mensaje de error
        AppNotifications.show(context, errorMessage);  // Muestra la notificación con el mensaje de error determinado
      }
    }
  }

  /// ═══ MÉTODO: build ═══
  /// Construye la interfaz visual completa de la pantalla de la tienda.
  /// Organiza tres capas: contenido deslizable con tarjetas de productos,
  /// cabecera fija con título y saldo, y pie de página fijo.
  /// Es reactivo al saldo del usuario mediante Riverpod.
  @override
  Widget build(BuildContext context) {  // Método de construcción del widget principal
    // Usamos el EconomiaProvider para obtener las monedas locales actualizadas al instante
    // (igual que lo hace logros_screen.dart para mostrar datos en tiempo real)
    final economia = ref.watch(economiaProvider);  // Observa el provider de economía para obtener datos reactivos
    final int currentCoins = economia.coins;  // Extrae las PyCoins actuales del usuario (actualización instantánea)

    // También escuchamos userProfileProvider para mantener sincronización con Firestore en segundo plano
    final userProfileAsync = ref.watch(userProfileProvider);  // Observa cambios en tiempo real del perfil del usuario

    const Color neonCian = AppTheme.primaryCyan;  // Color cian neón del tema para elementos visuales destacados

    return Scaffold(  // Widget estructural principal de Material Design
      backgroundColor: AppTheme.darkBg,  // Fondo oscuro según el tema de la app
      body: LayoutBuilder(  // Builder que responde a cambios de tamaño de pantalla
        builder: (context, constraints) {  // Callback con restricciones de layout
          final double width = constraints.maxWidth;  // Ancho máximo disponible del layout
          final bool isMobile = width < 700;  // Determina si es vista móvil (menos de 700px)
          final double sidePadding = isMobile ? 15.0 : 100.0;  // Padding lateral: 15px en móvil, 100px en escritorio

          return SafeArea(  // Garantiza que el contenido no quede detrás de barras del sistema
            child: Stack(  // Pila para superponer capas de contenido
              children: [  // Lista de capas apiladas
                // --- CAPA 1: CONTENIDO DESLIZABLE ---
                Positioned.fill(  // Posiciona el widget llenando todo el espacio disponible
                  child: SingleChildScrollView(  // Contenedor con scroll vertical
                    padding: EdgeInsets.only(  // Padding personalizado por lado
                      left: sidePadding,  // Padding izquierdo según tamaño de pantalla
                      right: sidePadding,  // Padding derecho según tamaño de pantalla
                      top: isMobile ? 150 : 180,  // Padding superior: 150px móvil, 180px escritorio
                      bottom: 100,  // Padding inferior fijo de 100px
                    ),
                    clipBehavior: Clip.none,  // Permite que el contenido溢出 sin recortarse
                    child: Column(  // Columna vertical para el contenido scrolleable
                      children: [  // Widgets hijos de la columna
                        const SizedBox(height: 10),  // Espaciador superior de 10 píxeles
                        ..._items.map(  // Expande la lista de items mapeados a tarjetas
                          (item) =>  // Para cada artículo de la tienda
                              _buildShopCard(item, isMobile, _purchasedColor),  // Construye la tarjeta del producto
                        ),
                        const SizedBox(height: 40),  // Espaciador vertical de 40 píxeles tras las tarjetas
                        PixelClipDialog(  // Widget de diálogo con estilo pixelado y mensaje informativo
                          message:  // Mensaje de bienvenida y consejos de uso
                              '¡Bienvenido a mi tienda! Estas herramientas te ayudarán a superar los ejercicios más difíciles. Recuerda: el mejor uso de tus monedas es invertir en aprendizaje. ¡Cada item tiene un límite de 1 uso por día! 🚀',
                          isMobile: isMobile,  // Indica si es layout móvil al widget
                        ),
                        const SizedBox(height: 25),  // Espaciador vertical de 25 píxeles
                        _buildTerminalLog(currentCoins.toString()),  // Construye el registro estilo terminal con saldo
                      ],
                    ),
                  ),
                ),

                // --- CAPA 2: CABECERA FIJA ---
                Positioned(  // Widget posicionado absolutamente dentro del Stack
                  top: 0,  // Posición superior pegada al borde
                  left: 0,  // Posición izquierda pegada al borde
                  right: 0,  // Posición derecha pegada al borde
                  child: Container(  // Contenedor de la cabecera
                    color: AppTheme.darkBg,  // Color de fondo oscuro para opacidad
                    padding: EdgeInsets.symmetric(  // Padding simétrico horizontal y vertical
                      horizontal: sidePadding,  // Padding horizontal según tamaño de pantalla
                      vertical: 20,  // Padding vertical fijo de 20 píxeles
                    ),
                    child: Column(  // Columna vertical para elementos de cabecera
                      crossAxisAlignment: CrossAxisAlignment.start,  // Alineación horizontal al inicio (izquierda)
                      children: [  // Widgets hijos
                        const AppHeaderButtons(),  // Botones de navegación de cabecera (constante)
                        const SizedBox(height: 25),  // Espaciador vertical de 25 píxeles
                        Row(  // Fila horizontal para título e indicador de saldo
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,  // Espacio entre título y saldo
                          children: [  // Widgets hijos de la fila
                            Expanded(  // Expande el título para ocupar espacio disponible
                              child: Text(  // Texto del título de la pantalla
                                'TIENDA',  // Título en mayúsculas
                                style: GoogleFonts.pressStart2p(  // Fuente pixel-art retro
                                  fontSize: isMobile ? 11 : 18,  // Tamaño: 11px móvil, 18px escritorio
                                  color: neonCian,  // Color cian neón
                                  letterSpacing: 1.2,  // Espaciado entre letras de 1.2px
                                ),
                                maxLines: 1,  // Máximo una línea de texto
                                overflow: TextOverflow.ellipsis,  // Trunca con puntos suspensivos si no cabe
                              ),
                            ),
                            // Indicador visual de saldo (compacto en móvil)
                            Container(  // Contenedor del indicador de monedas
                              padding: EdgeInsets.symmetric(  // Padding simétrico adaptable
                                horizontal: isMobile ? 8 : 12,  // Padding horizontal: 8px móvil, 12px escritorio
                                vertical: isMobile ? 4 : 8,  // Padding vertical: 4px móvil, 8px escritorio
                              ),
                              decoration: BoxDecoration(  // Decoración visual del contenedor
                                color: _purchasedColor.withValues(alpha: 0.1),  // Fondo dorado al 10% de opacidad
                                border: Border.all(  // Borde completo
                                  color: _purchasedColor,  // Color dorado del borde
                                  width: 1,  // Grosor de 1 píxel
                                ),
                                borderRadius: BorderRadius.circular(4),  // Esquinas redondeadas de 4px
                              ),
                              child: Row(  // Fila horizontal para icono y cantidad de monedas
                                mainAxisSize: MainAxisSize.min,  // Tamaño mínimo necesario
                                children: [  // Widgets hijos
                                  Icon(  // Icono de moneda
                                    Icons.monetization_on,  // Icono de monetización de Material
                                    color: _purchasedColor,  // Color dorado
                                    size: isMobile ? 14 : 20,  // Tamaño: 14px móvil, 20px escritorio
                                  ),
                                  SizedBox(width: isMobile ? 4 : 8),  // Espaciador: 4px móvil, 8px escritorio
                                  Text(  // Texto con la cantidad de monedas
                                    '$currentCoins',  // Interpolación del saldo actual
                                    style: GoogleFonts.pressStart2p(  // Fuente pixel-art retro
                                      color: _purchasedColor,  // Color dorado
                                      fontSize: isMobile ? 9 : 14,  // Tamaño: 9px móvil, 14px escritorio
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // --- CAPA 3: PIE DE PÁGINA FIJO ---
                const Positioned(  // Widget posicionado para el footer (constante porque no cambia)
                  bottom: 0,  // Posición inferior pegada al borde
                  left: 0,  // Posición izquierda pegada al borde
                  right: 0,  // Posición derecha pegada al borde
                  child: AppFooter(borderColor: AppTheme.borderBlue),  // Pie de página con borde azul
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// ═══ MÉTODO: _buildShopCard ═══
  /// Construye las tarjetas visuales de cada producto de la tienda.
  /// Determina si el artículo está comprado o cargando para ajustar colores y estados,
  /// y delega en _buildMobileCard o _buildDesktopCard según el tamaño de pantalla.
  Widget _buildShopCard(_ShopItem item, bool isMobile, Color purchasedColor) {  // Construye tarjeta de producto
    final bool isPurchased = _purchasedItems.contains(item.id);  // Verifica si el item fue comprado en esta sesión
    final bool isLoading = _loadingItems[item.id] ?? false;  // Verifica si el item se está generando (false por defecto)
    final Color borderColor = isPurchased  // Color del borde:
        ? _purchasedColor  // Dorado si está comprado
        : item.color.withValues(alpha: 0.4);  // Color del item al 40% si no está comprado
    final Color iconColor = isPurchased ? const Color(0xFF0D1B2A) : item.color;  // Color del icono: oscuro si comprado, color del item si no

    return Padding(  // Contenedor con padding
      padding: EdgeInsets.only(bottom: isMobile ? 12 : 20),  // Padding inferior: 12px móvil, 20px escritorio
      child: SizedBox(  // Contenedor de tamaño definido
        width: double.infinity,  // Ancho completo disponible
        child: RetroContainer(  // Contenedor con estilo retro personalizado
          isWin95: false,  // No usa estilo Windows 95
          borderColor: borderColor,  // Color del borde determinado arriba
          backgroundColor: const Color(0xFF14243D).withValues(alpha: 0.5),  // Fondo azul oscuro al 50% de opacidad
          child: isMobile  // Si es layout móvil
              ? _buildMobileCard(  // Construye tarjeta vertical para móvil
                  item,  // Artículo de tienda
                  isPurchased,  // Estado de compra
                  isLoading,  // Estado de carga
                  iconColor,  // Color del icono
                  purchasedColor,  // Color de item comprado
                )
              : _buildDesktopCard(  // Construye tarjeta horizontal para escritorio
                  item,  // Artículo de tienda
                  isPurchased,  // Estado de compra
                  isLoading,  // Estado de carga
                  iconColor,  // Color del icono
                  purchasedColor,  // Color de item comprado
                ),
        ),
      ),
    );
  }

  /// ═══ MÉTODO: _buildMobileCard ═══
  /// Construye la tarjeta de producto en layout vertical optimizado para pantallas móviles.
  /// Organiza icono, título, descripción, precio y botón de compra en columna vertical.
  Widget _buildMobileCard(  // Método para layout vertical de móvil
    _ShopItem item,  // Artículo de tienda a renderizar
    bool isPurchased,  // Indica si el artículo ya fue comprado
    bool isLoading,  // Indica si el artículo se está generando
    Color iconColor,  // Color a usar para el icono
    Color purchasedColor,  // Color dorado para items comprados
  ) {
    return Padding(  // Contenedor con padding interno
      padding: const EdgeInsets.all(12),  // Padding uniforme de 12 píxeles
      child: Column(  // Columna vertical para layout móvil
        children: [  // Widgets hijos de la columna
          // Header con icono y título
          Row(  // Fila horizontal para icono y texto
            children: [  // Widgets hijos
              // Icono
              Container(  // Contenedor del icono del producto
                width: 60,  // Ancho de 60 píxeles
                height: 60,  // Alto de 60 píxeles
                decoration: BoxDecoration(  // Decoración visual
                  color: isPurchased  // Color de fondo:
                      ? purchasedColor  // Dorado si está comprado
                      : item.color.withValues(alpha: 0.1),  // Color del item al 10% si no
                  border: Border.all(  // Borde completo
                    color: isPurchased  // Color del borde:
                        ? purchasedColor  // Dorado si está comprado
                        : item.color.withValues(alpha: 0.6),  // Color del item al 60% si no
                    width: 2,  // Grosor de 2 píxeles
                  ),
                  borderRadius: BorderRadius.circular(4),  // Esquinas redondeadas de 4px
                ),
                child: Center(  // Centra el contenido interno
                  child: isLoading  // Si está cargando
                      ? SizedBox(  // Muestra indicador de carga
                          width: 20,  // Ancho del spinner de 20px
                          height: 20,  // Alto del spinner de 20px
                          child: CircularProgressIndicator(  // Spinner circular de progreso
                            strokeWidth: 2,  // Grosor del trazo de 2px
                            color: item.color,  // Color del spinner igual al del item
                          ),
                        )
                      : Icon(item.icon, color: iconColor, size: 28),  // Si no carga: muestra icono del item
                ),
              ),
              const SizedBox(width: 12),  // Espaciador horizontal de 12 píxeles
              // Título y descripción
              Expanded(  // Expande para ocupar espacio restante de la fila
                child: Column(  // Columna vertical para título y descripción
                  crossAxisAlignment: CrossAxisAlignment.start,  // Alineación al inicio (izquierda)
                  children: [  // Widgets hijos
                    Text(  // Texto del título del artículo
                      item.title,  // Título del item
                      style: GoogleFonts.pressStart2p(  // Fuente pixel-art retro
                        color: item.color,  // Color del texto igual al del item
                        fontSize: 9,  // Tamaño de fuente pequeño
                      ),
                      maxLines: 2,  // Máximo 2 líneas de texto
                      overflow: TextOverflow.ellipsis,  // Trunca con puntos suspensivos si no cabe
                    ),
                    const SizedBox(height: 6),  // Espaciador vertical de 6 píxeles
                    Text(  // Texto de descripción del artículo
                      item.description,  // Descripción del item
                      style: GoogleFonts.shareTechMono(  // Fuente monoespaciada tecnológica
                        color: Colors.grey.shade400,  // Color gris claro
                        fontSize: 10,  // Tamaño de fuente 10
                        height: 1.3,  // Interlineado de 1.3x
                      ),
                      maxLines: 2,  // Máximo 2 líneas de texto
                      overflow: TextOverflow.ellipsis,  // Trunca con puntos suspensivos si no cabe
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),  // Espaciador vertical de 12 píxeles
          // Precio y botón
          Row(  // Fila horizontal para precio y botón de acción
            children: [  // Widgets hijos
              // Precio
              Expanded(  // Expande para ocupar espacio disponible
                child: Row(  // Fila interna para icono de moneda y texto de precio
                  children: [  // Widgets hijos
                    Icon(  // Icono de moneda
                      Icons.monetization_on,  // Icono de monetización
                      color: isPurchased  // Color:
                          ? purchasedColor  // Dorado si está comprado
                          : item.color.withValues(alpha: 0.7),  // Color del item al 70% si no
                      size: 14,  // Tamaño de 14 píxeles
                    ),
                    const SizedBox(width: 4),  // Espaciador horizontal de 4 píxeles
                    Text(  // Texto de precio o estado de compra
                      isPurchased ? 'ADQUIRIDO' : '${item.price} PY_Coins',  // "ADQUIRIDO" si comprado, precio si no
                      style: GoogleFonts.shareTechMono(  // Fuente monoespaciada tecnológica
                        color: isPurchased  // Color del texto:
                            ? purchasedColor  // Dorado si está comprado
                            : item.color.withValues(alpha: 0.7),  // Color del item al 70% si no
                        fontSize: 10,  // Tamaño de fuente 10
                        fontWeight: FontWeight.bold,  // Peso de fuente negrita
                      ),
                    ),
                  ],
                ),
              ),
              // Botón
              SizedBox(  // Contenedor de tamaño fijo para el botón
                width: 100,  // Ancho de 100 píxeles
                child: RetroButton(  // Botón con estilo retro personalizado
                  text: isPurchased ? 'HECHO' : 'COMPRAR',  // Texto: "HECHO" si comprado, "COMPRAR" si no
                  icon: isPurchased ? Icons.check : null,  // Icono de check si comprado, ninguno si no
                  width: 100,  // Ancho de 100 píxeles
                  height: 36,  // Alto de 36 píxeles
                  fontSize: 7,  // Tamaño de fuente 7 (estilo retro)
                  style: isPurchased  // Estilo visual:
                      ? RetroButtonStyle.secondary  // Secundario si está comprado
                      : RetroButtonStyle.primary,  // Primario si no está comprado
                  onPressed: (isPurchased || isLoading)  // Deshabilitado si comprado o cargando
                      ? null  // null deshabilita el botón
                      : () => _showTopicSelection(item),  // Si no: abre diálogo de selección de tema
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ═══ MÉTODO: _buildDesktopCard ═══
  /// Construye la tarjeta de producto en layout horizontal optimizado para pantallas de escritorio.
  /// Organiza icono a la izquierda, información textual al centro y botón de compra a la derecha.
  Widget _buildDesktopCard(  // Método para layout horizontal de escritorio
    _ShopItem item,  // Artículo de tienda a renderizar
    bool isPurchased,  // Indica si el artículo ya fue comprado
    bool isLoading,  // Indica si el artículo se está generando
    Color iconColor,  // Color a usar para el icono
    Color purchasedColor,  // Color dorado para items comprados
  ) {
    return IntrinsicHeight(  // Widget que fuerza a que todos los hijos tengan la misma altura
      child: Row(  // Fila horizontal para layout de escritorio
        children: [  // Widgets hijos de la fila
          // Icono del producto
          Container(  // Contenedor externo del icono
            width: 110,  // Ancho fijo de 110 píxeles
            padding: const EdgeInsets.all(12),  // Padding interno de 12 píxeles
            child: Container(  // Contenedor interno decorado del icono
              decoration: BoxDecoration(  // Decoración visual
                color: isPurchased  // Color de fondo:
                    ? purchasedColor  // Dorado si está comprado
                    : item.color.withValues(alpha: 0.1),  // Color del item al 10% si no
                border: Border.all(  // Borde completo
                  color: isPurchased  // Color del borde:
                      ? purchasedColor  // Dorado si está comprado
                      : item.color.withValues(alpha: 0.6),  // Color del item al 60% si no
                  width: 2.5,  // Grosor de 2.5 píxeles
                ),
                borderRadius: BorderRadius.circular(2),  // Esquinas redondeadas de 2px
              ),
              child: Center(  // Centra el contenido interno
                child: isLoading  // Si está cargando
                    ? SizedBox(  // Muestra spinner de carga
                        width: 24,  // Ancho del spinner de 24px
                        height: 24,  // Alto del spinner de 24px
                        child: CircularProgressIndicator(  // Indicador circular de progreso
                          strokeWidth: 2,  // Grosor del trazo de 2px
                          color: item.color,  // Color del spinner igual al del item
                        ),
                      )
                    : Icon(item.icon, color: iconColor, size: 36),  // Si no carga: muestra icono del item tamaño 36
              ),
            ),
          ),

          // Información textual
          Expanded(  // Expande para ocupar espacio horizontal disponible
            child: Padding(  // Padding interno del área de texto
              padding: const EdgeInsets.symmetric(  // Padding simétrico
                vertical: 12.0,  // Padding vertical de 12px
                horizontal: 8.0,  // Padding horizontal de 8px
              ),
              child: Column(  // Columna vertical para los textos informativos
                crossAxisAlignment: CrossAxisAlignment.start,  // Alineación al inicio (izquierda)
                mainAxisAlignment: MainAxisAlignment.center,  // Centrado verticalmente
                children: [  // Widgets hijos
                  Text(  // Texto del título del artículo
                    item.title,  // Título del item
                    style: GoogleFonts.pressStart2p(  // Fuente pixel-art retro
                      color: purchasedColor,  // Color dorado siempre
                      fontSize: 11,  // Tamaño de fuente 11
                    ),
                  ),
                  const SizedBox(height: 6),  // Espaciador vertical de 6 píxeles
                  Text(  // Texto de descripción del artículo
                    item.description,  // Descripción del item
                    style: GoogleFonts.shareTechMono(  // Fuente monoespaciada tecnológica
                      color: Colors.grey.shade400,  // Color gris claro
                      fontSize: 13,  // Tamaño de fuente 13
                    ),
                  ),
                  const SizedBox(height: 10),  // Espaciador vertical de 10 píxeles
                  Row(  // Fila horizontal para icono de moneda y precio
                    children: [  // Widgets hijos
                      Icon(  // Icono de moneda
                        Icons.monetization_on,  // Icono de monetización
                        color: isPurchased  // Color:
                            ? purchasedColor  // Dorado si está comprado
                            : item.color.withValues(alpha: 0.7),  // Color del item al 70% si no
                        size: 12,  // Tamaño de 12 píxeles
                      ),
                      const SizedBox(width: 4),  // Espaciador horizontal de 4 píxeles
                      Text(  // Texto de precio o estado de compra
                        isPurchased  // Texto condicional:
                            ? 'ITEM ADQUIRIDO'  // "ITEM ADQUIRIDO" si comprado
                            : 'Cuesta ${item.price} PY_Coins',  // "Cuesta X PY_Coins" si no
                        style: GoogleFonts.shareTechMono(  // Fuente monoespaciada tecnológica
                          color: isPurchased  // Color del texto:
                              ? purchasedColor  // Dorado si está comprado
                              : item.color.withValues(alpha: 0.7),  // Color del item al 70% si no
                          fontSize: 11,  // Tamaño de fuente 11
                          fontWeight: FontWeight.bold,  // Peso de fuente negrita
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Botón de compra
          Padding(  // Padding alrededor del botón
            padding: const EdgeInsets.symmetric(horizontal: 12),  // Padding horizontal de 12px
            child: RetroButton(  // Botón con estilo retro personalizado
              text: isLoading  // Texto del botón:
                  ? 'GENERANDO...'  // "GENERANDO..." si está cargando
                  : (isPurchased ? 'HECHO' : 'COMPRAR'),  // "HECHO" si comprado, "COMPRAR" si no
              icon: isPurchased ? Icons.check : null,  // Icono de check si comprado, ninguno si no
              width: 160,  // Ancho de 160 píxeles
              height: 40,  // Alto de 40 píxeles
              fontSize: 8,  // Tamaño de fuente 8 (estilo retro)
              style: isPurchased  // Estilo visual:
                  ? RetroButtonStyle.secondary  // Secundario si está comprado
                  : RetroButtonStyle.primary,  // Primario si no está comprado
              onPressed: (isPurchased || isLoading)  // Deshabilitado si comprado o cargando
                  ? null  // null deshabilita el botón
                  : () => _showTopicSelection(item),  // Si no: abre diálogo de selección de tema
            ),
          ),
        ],
      ),
    );
  }

  /// ═══ MÉTODO: _buildTerminalLog ═══
  /// Construye un registro de actividad con estilo de terminal de consola que muestra
  /// información resumen de la tienda: versión, saldo actual, items disponibles,
  /// compras realizadas y límite de uso. Usa datos en tiempo real desde Firestore.
  Widget _buildTerminalLog(String balance) {  // Construye widget de registro estilo terminal
    // Escuchar el saldo en tiempo real desde el provider
    final userProfileAsync = ref.watch(userProfileProvider);  // Observa cambios en tiempo real del perfil
    final String realTimeBalance = userProfileAsync.when(  // Obtiene el saldo en tiempo real según el estado
      loading: () => 'CARGANDO...',  // Mientras carga: texto "CARGANDO..."
      error: (_, __) => 'ERROR',  // Si hay error: texto "ERROR"
      data: (data) => '${data?['coins'] ?? 0}',  // Si hay datos: formatea el saldo como string
    );

    return SizedBox(  // Contenedor de tamaño definido
      width: double.infinity,  // Ancho completo disponible
      child: RetroContainer(  // Contenedor con estilo retro
        isWin95: false,  // No usa estilo Windows 95
        borderColor: AppTheme.greyBlue.withValues(alpha: 0.2),  // Borde gris-azulado al 20% de opacidad
        backgroundColor: Colors.black.withValues(alpha: 0.6),  // Fondo negro al 60% de opacidad (estilo terminal)
        child: Column(  // Columna vertical para las líneas de texto
          crossAxisAlignment: CrossAxisAlignment.start,  // Alineación al inicio (izquierda)
          children: [  // Widgets hijos
            _terminalLine('> TIENDA_PIXEL_CLIP v2.0.0 - CON IA'),  // Línea de versión de la tienda
            _terminalLine('> SALDO_ACTUAL: $realTimeBalance PY_COINS'),  // Línea con saldo en tiempo real
            _terminalLine('> ITEMS_DISPONIBLES: 3'),  // Línea con cantidad de items disponibles
            _terminalLine('> COMPRAS_REALIZADAS: ${_purchasedItems.length}'),  // Línea con contador de compras en sesión
            _terminalLine('> LÍMITE: 1 USO POR DÍA POR ITEM'),  // Línea con información del límite diario
          ],
        ),
      ),
    );
  }

  /// ═══ MÉTODO: _terminalLine ═══
  /// Construye una línea individual de texto con estilo de terminal de consola,
  /// usando fuente monoespaciada y color gris-azulado del tema.
  Widget _terminalLine(String text) {  // Construye una línea de texto estilo terminal
    return Padding(  // Contenedor con padding
      padding: const EdgeInsets.only(bottom: 4),  // Padding inferior de 4 píxeles entre líneas
      child: Text(  // Widget de texto
        text,  // Texto de la línea de terminal
        style: GoogleFonts.shareTechMono(  // Fuente monoespaciada tecnológica
          color: AppTheme.greyBlue,  // Color gris-azulado del tema
          fontSize: 12,  // Tamaño de fuente 12
        ),
      ),
    );
  }
}
