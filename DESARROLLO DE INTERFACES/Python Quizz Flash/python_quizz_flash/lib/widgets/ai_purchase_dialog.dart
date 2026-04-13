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
import 'package:flutter/material.dart';  // Librería base de Flutter para construir la UI
import 'package:google_fonts/google_fonts.dart';  // Paquete para fuentes retro y monoespaciadas
import '../theme/app_theme.dart';  // Colores y tema global de la aplicación
import '../widgets/retro_button.dart';  // Widget de botón personalizado con estilo retro
import '../widgets/retro_container.dart';  // Widget de contenedor personalizado con estilo retro
import '../widgets/pixel_clip_logo.dart';  // Widget del logo Pixel Clip de la tienda

/// ═══ CLASE: AiPurchaseDialog ═══
/// Diálogo de confirmación de compra para items de la tienda.
///
/// Muestra información del item, costo y permite confirmar o cancelar la compra.
class AiPurchaseDialog extends StatefulWidget {  // StatefulWidget porque maneja estado de carga
  /// Título del item a comprar
  final String title;  // nombre del producto que se muestra en el header

  /// Descripción del item
  final String description;  // texto descriptivo del producto

  /// Precio en PY-Coins
  final int price;  // costo del item en la moneda virtual

  /// Saldo actual del usuario
  final int currentBalance;  // saldo disponible del usuario

  /// Icono del item
  final IconData icon;  // ícono que representa al producto

  /// Callback cuando se confirma la compra
  final VoidCallback? onConfirm;  // función opcional ejecutada al confirmar

  const AiPurchaseDialog({  // constructor con todos los parámetros requeridos excepto onConfirm
    super.key,  // clave del widget
    required this.title,  // título obligatorio
    required this.description,  // descripción obligatoria
    required this.price,  // precio obligatorio
    required this.currentBalance,  // saldo obligatorio
    required this.icon,  // ícono obligatorio
    this.onConfirm,  // callback opcional de confirmación
  });

  @override
  State<AiPurchaseDialog> createState() => _AiPurchaseDialogState(); 
   // ═══ MÉTODO: createState ═══
  // Crea el estado mutable asociado a este StatefulWidget
}

/// ═══ CLASE: _AiPurchaseDialogState ═══
/// Estado del diálogo de compra que gestiona la UI y el proceso de confirmación
class _AiPurchaseDialogState extends State<AiPurchaseDialog> {
  bool _isLoading = false;  // flag que indica si se está procesando la compra

  @override
  Widget build(BuildContext context) {  // ═══ MÉTODO: build ═══
    // Construye el diálogo de compra con info del item, precio y botones de acción
    final bool canAfford = widget.currentBalance >= widget.price;  // determina si el usuario tiene saldo suficiente
    final double screenHeight = MediaQuery.of(context).size.height;  // altura actual de la pantalla
    final bool isMobile = screenHeight < 700;  // determina si es dispositivo móvil (< 700px)

    return Dialog(  // widget de diálogo modal
      backgroundColor: Colors.transparent,  // fondo transparente para decoración personalizada
      child: Container(  // contenedor principal del diálogo
        constraints: BoxConstraints(  // restricciones de tamaño
          maxWidth: isMobile ? 350 : 500,  // ancho máximo: 350px móvil, 500px desktop
          maxHeight: isMobile ? screenHeight * 0.85 : 600,  // alto máximo: 85% pantalla móvil o 600px
        ),
        decoration: BoxDecoration(  // decoración del contenedor
          color: AppTheme.darkBg,  // fondo oscuro del tema
          border: Border.all(color: AppTheme.primaryCyan, width: 2),  // borde cian de 2 píxeles
        ),
        child: Column(  // ═══ SECCIÓN: layout vertical del diálogo ═══
          mainAxisSize: MainAxisSize.min,  // ocupa solo el espacio mínimo necesario
          children: [  // ═══ SECCIÓN: header con título ═══
            // Header con título
            Container(  // contenedor del header
              width: double.infinity,  // ocupa todo el ancho
              padding: EdgeInsets.all(isMobile ? 10 : 15),  // padding adaptativo: 10px móvil, 15px desktop
              decoration: BoxDecoration(  // decoración del header
                color: AppTheme.primaryCyan.withValues(alpha: 0.1),  // fondo cian semitransparente
                border: const Border(  // borde solo inferior
                  bottom: BorderSide(color: AppTheme.primaryCyan, width: 1),  // línea inferior cian de 1 píxel
                ),
              ),
              child: Row(  // fila horizontal para ícono y título
                children: [
                  Icon(  // ícono del producto
                    widget.icon,  // ícono recibido como parámetro
                    color: AppTheme.primaryCyan,  // color cian del tema
                    size: isMobile ? 18 : 24,  // tamaño adaptativo: 18px móvil, 24px desktop
                  ),
                  const SizedBox(width: 8),  // espacio de 8 píxeles
                  Expanded(  // ocupa el espacio restante
                    child: Text(  // texto del título
                      widget.title,  // título del producto
                      style: GoogleFonts.pressStart2p(  // fuente pixelada retro
                        color: AppTheme.primaryCyan,  // color cian
                        fontSize: isMobile ? 8 : 10,  // tamaño adaptativo: 8px móvil, 10px desktop
                      ),
                      maxLines: 2,  // máximo 2 líneas
                      overflow: TextOverflow.ellipsis,  // muestra "..." si excede el espacio
                    ),
                  ),
                ],
              ),
            ),

            // ═══ SECCIÓN: contenido del diálogo (scrollable) ═══
            // Contenido del diálogo (scrollable para móvil)
            Flexible(  // permite que el contenido sea flexible dentro de las restricciones
              child: SingleChildScrollView(  // permite scroll si el contenido excede
                padding: EdgeInsets.all(isMobile ? 12 : 20),  // padding adaptativo: 12px móvil, 20px desktop
                child: Column(  // columna vertical del contenido
                  children: [  // ═══ SECCIÓN: logo Pixel Clip ═══
                    // Logo de Pixel Clip
                    const PixelClipLogo(size: 60),  // logo con tamaño fijo de 60 píxeles
                    SizedBox(height: isMobile ? 10 : 20),  // espacio adaptativo

                    // ═══ SECCIÓN: descripción del item ═══
                    // Descripción del item
                    RetroContainer(  // contenedor con estilo retro
                      isWin95: false,  // estilo cyberpunk (no Windows 95)
                      borderColor: AppTheme.borderBlue,  // borde azul del tema
                      backgroundColor: const Color(0xFF14243D),  // fondo azul oscuro
                      padding: EdgeInsets.all(isMobile ? 10 : 15),  // padding adaptativo
                      child: Text(  // texto descriptivo
                        widget.description,  // descripción del producto
                        style: GoogleFonts.shareTechMono(  // fuente monoespaciada tecnológica
                          color: Colors.white,  // color blanco
                          fontSize: isMobile ? 11 : 13,  // tamaño adaptativo
                          height: 1.5,  // altura de línea de 1.5
                        ),
                      ),
                    ),

                    SizedBox(height: isMobile ? 12 : 20),  // espacio adaptativo

                    // ═══ SECCIÓN: información de precio y saldo ═══
                    // Información de precio y saldo
                    Container(  // contenedor de la sección financiera
                      padding: EdgeInsets.all(isMobile ? 10 : 15),  // padding adaptativo
                      decoration: BoxDecoration(  // decoración condicional según saldo
                        color: canAfford  // si puede pagarlo
                            ? const Color(0xFF14243D)  // fondo azul oscuro
                            : const Color(0xFF3D1414),  // fondo rojo oscuro si no puede
                        border: Border.all(  // borde condicional
                          color: canAfford  // si puede pagarlo
                              ? AppTheme.borderBlue  // borde azul
                              : AppTheme.neonRed,  // borde rojo si no puede
                          width: 2,  // grosor de 2 píxeles
                        ),
                      ),
                      child: Column(  // columna con las filas de precios
                        children: [  // ═══ SECCIÓN: fila del precio ═══
                          _buildPriceRow(  // widget helper para filas de precio
                            'Precio:',  // etiqueta
                            widget.price,  // precio del producto
                            AppTheme.primaryCyan,  // color cian
                            isMobile: isMobile,  // flag responsive
                          ),
                          SizedBox(height: isMobile ? 6 : 10),  // espacio adaptativo
                          // ═══ SECCIÓN: fila del saldo actual ═══
                          _buildPriceRow(  // widget helper para filas de precio
                            'Tu saldo:',  // etiqueta
                            widget.currentBalance,  // saldo del usuario
                            Colors.amber,  // color ámbar
                            isMobile: isMobile,  // flag responsive
                          ),
                          SizedBox(height: isMobile ? 10 : 15),  // espacio adaptativo
                          const Divider(color: Colors.white24),  // línea divisoria semitransparente
                          SizedBox(height: isMobile ? 6 : 10),  // espacio adaptativo
                          // ═══ SECCIÓN: fila del saldo restante ═══
                          _buildPriceRow(  // widget helper para filas de precio
                            'Restante:',  // etiqueta
                            widget.currentBalance - widget.price,  // cálculo del saldo después de la compra
                            canAfford ? AppTheme.neonGreen : AppTheme.neonRed,  // verde si puede, rojo si no
                            isNegative:  // flag si el resultado es negativo
                                widget.currentBalance - widget.price < 0,  // comprueba si queda saldo negativo
                            isMobile: isMobile,  // flag responsive
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: isMobile ? 12 : 20),  // espacio adaptativo

                    // ═══ SECCIÓN: advertencia de límite diario ═══
                    // Advertencia de límite diario
                    Container(  // contenedor de advertencia
                      padding: EdgeInsets.all(isMobile ? 8 : 12),  // padding adaptativo
                      decoration: BoxDecoration(  // decoración dorada de advertencia
                        color: const Color(0xFFFFD700).withValues(alpha: 0.1),  // fondo dorado semitransparente
                        border: Border.all(  // borde dorado
                          color: const Color(0xFFFFD700),  // color dorado
                          width: 1,  // grosor de 1 píxel
                        ),
                      ),
                      child: Row(  // fila horizontal para ícono y texto
                        children: [
                          Icon(  // ícono de información
                            Icons.info_outline,  // ícono de info con contorno
                            color: const Color(0xFFFFD700),  // color dorado
                            size: isMobile ? 16 : 20,  // tamaño adaptativo
                          ),
                          SizedBox(width: isMobile ? 6 : 10),  // espacio adaptativo
                          Expanded(  // ocupa el espacio restante
                            child: Text(  // texto de advertencia
                              'Limite: 1 uso por dia. ¡Usalo sabiamente!',  // mensaje de límite diario
                              style: GoogleFonts.shareTechMono(  // fuente monoespaciada
                                color: const Color(0xFFFFD700),  // color dorado
                                fontSize: isMobile ? 9 : 11,  // tamaño adaptativo
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ═══ SECCIÓN: botones de acción ═══
            // Botones de acción
            Padding(  // padding alrededor de los botones
              padding: EdgeInsets.all(isMobile ? 12 : 20),  // padding adaptativo
              child: isMobile  // ═══ SECCIÓN: layout condicional de botones ═══
                  ? Column(  // en móvil: botones en columna vertical
                      mainAxisSize: MainAxisSize.min,  // ocupa espacio mínimo
                      children: [  // ═══ SECCIÓN: botón CANCELAR ═══
                        SizedBox(  // contenedor de ancho completo
                          width: double.infinity,  // ancho completo
                          child: RetroButton(  // botón de cancelar
                            text: _isLoading ? 'PROCESANDO...' : 'CANCELAR',  // texto condicional según carga
                            style: RetroButtonStyle.secondary,  // estilo secundario
                            height: 45,  // alto de 45 píxeles
                            fontSize: 8,  // tamaño de fuente de 8 píxeles
                            onPressed: _isLoading  // si está cargando
                                ? null  // deshabilitado
                                : () => Navigator.of(context).pop(),  // cierra el diálogo
                          ),
                        ),
                        const SizedBox(height: 10),  // espacio de 10 píxeles
                        // ═══ SECCIÓN: botón CONFIRMAR COMPRA ═══
                        SizedBox(  // contenedor de ancho completo
                          width: double.infinity,  // ancho completo
                          child: RetroButton(  // botón de confirmación
                            text: _isLoading ? 'ESPERA...' : 'CONFIRMAR COMPRA',  // texto condicional
                            style: canAfford  // estilo según saldo
                                ? RetroButtonStyle.primary  // si puede pagar: primario
                                : RetroButtonStyle.danger,  // si no puede: danger
                            backgroundColor: canAfford  // color de fondo según saldo
                                ? AppTheme.neonGreen  // verde si puede pagar
                                : AppTheme.neonRed,  // rojo si no puede
                            height: 45,  // alto de 45 píxeles
                            fontSize: 8,  // tamaño de fuente de 8 píxeles
                            onPressed: canAfford && !_isLoading  // habilitado solo si puede y no está cargando
                                ? _handleConfirm  // ejecuta la confirmación
                                : null,  // deshabilitado si no cumple condiciones
                          ),
                        ),
                      ],
                    )
                  : Row(  // ═══ SECCIÓN: layout desktop (botones en fila) ═══
                      mainAxisAlignment: MainAxisAlignment.center,  // centrados horizontalmente
                      children: [  // ═══ SECCIÓN: botón CANCELAR desktop ═══
                        Expanded(  // ocupa espacio proporcional
                          child: RetroButton(  // botón de cancelar
                            text: _isLoading ? 'PROCESANDO...' : 'CANCELAR',  // texto condicional
                            style: RetroButtonStyle.secondary,  // estilo secundario
                            height: 45,  // alto de 45 píxeles
                            fontSize: 9,  // tamaño de fuente de 9 píxeles
                            onPressed: _isLoading  // si está cargando
                                ? null  // deshabilitado
                                : () => Navigator.of(context).pop(),  // cierra el diálogo
                          ),
                        ),
                        const SizedBox(width: 15),  // espacio de 15 píxeles
                        // ═══ SECCIÓN: botón CONFIRMAR COMPRA desktop ═══
                        Expanded(  // ocupa espacio proporcional
                          child: RetroButton(  // botón de confirmación
                            text: _isLoading ? 'ESPERA...' : 'CONFIRMAR COMPRA',  // texto condicional
                            style: canAfford  // estilo según saldo
                                ? RetroButtonStyle.primary  // si puede pagar: primario
                                : RetroButtonStyle.danger,  // si no puede: danger
                            backgroundColor: canAfford  // color de fondo según saldo
                                ? AppTheme.neonGreen  // verde si puede pagar
                                : AppTheme.neonRed,  // rojo si no puede
                            height: 45,  // alto de 45 píxeles
                            fontSize: 9,  // tamaño de fuente de 9 píxeles
                            onPressed: canAfford && !_isLoading  // habilitado solo si puede y no está cargando
                                ? _handleConfirm  // ejecuta la confirmación
                                : null,  // deshabilitado si no cumple condiciones
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  /// ═══ MÉTODO: _buildPriceRow ═══
  /// Construye una fila con etiqueta de precio y valor con ícono de moneda
  Widget _buildPriceRow(  // retorna un widget Row
    String label,  // etiqueta descriptiva (ej: "Precio:", "Tu saldo:")
    int value,  // valor numérico a mostrar
    Color color, {  // color del texto y del ícono
    bool isNegative = false,  // flag opcional: true si el valor es negativo
    bool isMobile = false,  // flag opcional: true si es layout móvil
  }) {
    return Row(  // fila horizontal con etiqueta y valor
      mainAxisAlignment: MainAxisAlignment.spaceBetween,  // separados a los extremos
      children: [  // ═══ SECCIÓN: etiqueta ═══
        Text(  // texto de la etiqueta
          label,  // etiqueta recibida como parámetro
          style: GoogleFonts.shareTechMono(  // fuente monoespaciada
            color: Colors.white70,  // blanco semitransparente
            fontSize: isMobile ? 10 : 12,  // tamaño adaptativo
          ),
        ),
        // ═══ SECCIÓN: valor con ícono ═══
        Row(  // fila horizontal para ícono y valor numérico
          children: [
            Icon(  // ícono de moneda
              Icons.monetization_on,  // ícono de moneda
              color: isNegative ? AppTheme.neonRed : color,  // rojo si es negativo, sino el color proporcionado
              size: isMobile ? 12 : 16,  // tamaño adaptativo
            ),
            SizedBox(width: isMobile ? 3 : 5),  // espacio adaptativo
            Text(  // texto del valor numérico
              value.toString(),  // convierte el entero a string
              style: GoogleFonts.pressStart2p(  // fuente pixelada retro
                color: isNegative ? AppTheme.neonRed : color,  // rojo si es negativo, sino el color proporcionado
                fontSize: isMobile ? 9 : 11,  // tamaño adaptativo
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// ═══ MÉTODO: _handleConfirm ═══
  /// Maneja la confirmación de compra con un delay simulado para mejor UX
  void _handleConfirm() {
    setState(() {  // actualiza el estado del widget
      _isLoading = true;  // activa el estado de carga
    });

    // Simular pequeño delay para mejor UX
    Future.delayed(const Duration(milliseconds: 500), () {  // espera 500ms antes de ejecutar
      widget.onConfirm?.call();  // ejecuta el callback de confirmación si existe
      Navigator.of(context).pop();  // cierra el diálogo
    });
  }
}
