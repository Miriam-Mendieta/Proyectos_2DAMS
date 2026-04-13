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
import 'package:flutter/material.dart';  // Importa el framework Material de Flutter para widgets y componentes UI
import '../theme/app_theme.dart';  // Importa el tema de la aplicacion para acceder a colores y estilos globales

// ═══ SECCION: Enumeracion de estilos de boton ═══
// Define los estilos disponibles para el boton retro
enum RetroButtonStyle { primary, secondary, danger, purple }

/// ═══ CLASE: RetroButton ═══
/// Widget de boton PÍXEL ART: cuadrado, con bisel solido y estados dinamicos.
/// Maneja automaticamente los estados de Hover (Gris) y Bloqueado (Opacidad).
class RetroButton extends StatefulWidget {  // Extiende StatefulWidget para manejar estado interno (hover, pressed)
  final String text;  // Texto que se muestra en el boton
  final VoidCallback? onPressed;  // Funcion que se ejecuta al presionar el boton (null = deshabilitado)
  final RetroButtonStyle style;  // Estilo predefinido del boton (primary, secondary, danger, purple)
  final bool isWin95;  // Si es true, usa el estilo visual de Windows 95
  final Color? backgroundColor;  // Color de fondo personalizado (sobreescribe el estilo)
  final Color? textColor;  // Color del texto personalizado
  final IconData? icon;  // Icono opcional a mostrar junto al texto
  final Color? iconColor;  // Color personalizado para el icono
  final double? width;  // Ancho fijo opcional del boton
  final double? height;  // Alto fijo opcional del boton
  final double fontSize;  // Tamano de la fuente del texto (default: 10)
  final bool isVertical;  // Si es true, icono y texto se disponen verticalmente
  final List<BoxShadow>? shadows;  // Sombras personalizadas opcionales
  final MainAxisAlignment alignment;  // Alineacion del contenido dentro del boton
  final String fontFamily;  // Familia de fuente a usar (default: 'PressStart2P')
  final bool forceUppercase;  // Si es true, convierte el texto a mayusculas

  /// ═══ MÉTODO: Constructor de RetroButton ═══
  /// Inicializa el widget con todos sus parametros opcionales y obligatorios
  const RetroButton({
    super.key,  // Clave del widget para identificacion en el arbol
    required this.text,  // Parametro obligatorio: texto del boton
    this.onPressed,  // Callback opcional de presionado
    this.style = RetroButtonStyle.primary,  // Estilo por defecto: primary
    this.isWin95 = false,  // Por defecto no es estilo Win95
    this.backgroundColor,  // Color de fondo opcional
    this.textColor,  // Color de texto opcional
    this.icon,  // Icono opcional
    this.iconColor,  // Color de icono opcional
    this.width,  // Ancho opcional
    this.height,  // Alto opcional
    this.fontSize = 10,  // Tamano de fuente por defecto: 10
    this.isVertical = false,  // Por defecto disposicion horizontal
    this.shadows,  // Sombras opcionales
    this.alignment = MainAxisAlignment.center,  // Alineacion por defecto: centrada
    this.fontFamily = 'PressStart2P',  // Fuente por defecto: PressStart2P
    this.forceUppercase = true,  // Por defecto fuerza mayusculas
  });

  @override
  State<RetroButton> createState() => _RetroButtonState();  // Crea el estado asociado al widget
}

/// ═══ CLASE: _RetroButtonState ═══
/// Estado interno del RetroButton que maneja las animaciones de hover y pressed
class _RetroButtonState extends State<RetroButton> {  // Extiende State para manejar estado local
  // Estados locales para animar la interaccion
  bool _isHovered = false;  // Indica si el cursor esta sobre el boton
  bool _isPressed = false;  // Indica si el boton esta siendo presionado

  /// ═══ MÉTODO: _getBackgroundColor ═══
  /// Determina el color de fondo basado en el estado actual (disabled, pressed, hovered, default)
  Color _getBackgroundColor() {  // Retorna el color de fondo segun el estado
    if (widget.onPressed == null) {  // Si el boton esta deshabilitado
      return (widget.backgroundColor ?? _getDefaultStyleColor()).withOpacity(0.5);  // Retorna color con 50% opacidad
    }
    if (_isPressed) return Colors.grey.shade700;  // Si esta presionado, gris oscuro
    if (_isHovered) return Colors.grey.shade800;  // Si esta en hover, gris medio (Hover Gris pedido)

    return widget.backgroundColor ?? _getDefaultStyleColor();  // Retorna color personalizado o el del estilo por defecto
  }

  /// ═══ MÉTODO: _getDefaultStyleColor ═══
  /// Obtiene el color por defecto segun el estilo seleccionado (primary, secondary, danger, purple)
  Color _getDefaultStyleColor() {  // Retorna el color asociado al estilo del boton
    switch (widget.style) {  // Evalua el estilo actual del widget
      case RetroButtonStyle.secondary:  // Caso estilo secundario
        return AppTheme.mutedTeal;  // Retorna color teal apagado del tema
      case RetroButtonStyle.danger:  // Caso estilo peligro
        return AppTheme.neonRed;  // Retorna rojo neon del tema
      case RetroButtonStyle.purple:  // Caso estilo purpura
        return AppTheme.greyBlue;  // Retorna gris azulado del tema
      default:  // Caso por defecto (primary)
        return AppTheme.primaryCyan;  // Retorna cyan primario del tema
    }
  }

  @override
  Widget build(BuildContext context) {  // Construye la interfaz visual del boton
    final bool isDisabled = widget.onPressed == null;  // Determina si el boton esta deshabilitado
    final Color currentBgColor = _getBackgroundColor();  // Obtiene el color de fondo actual segun estado

    // Estilo especial para Windows 95
    if (widget.isWin95) return _buildWin95(isDisabled);  // Si es estilo Win95, delega al metodo especifico

    final Color topBorderColor = _isPressed ? Colors.black45 : Colors.white54;  // Color borde superior: oscuro si presionado, blanco si no
    final Color bottomBorderColor = _isPressed ? Colors.white54 : Colors.black45;  // Color borde inferior: blanco si presionado, oscuro si no

    return MouseRegion(  // Widget que detecta la entrada/salida del mouse
      cursor: isDisabled  // Define el cursor segun estado
          ? SystemMouseCursors.forbidden  // Si deshabilitado, cursor de prohibido
          : SystemMouseCursors.click,  // Si habilitado, cursor de clic
      onEnter: (_) => !isDisabled ? setState(() => _isHovered = true) : null,  // Al entrar, activa hover si no esta deshabilitado
      onExit: (_) => !isDisabled ? setState(() => _isHovered = false) : null,  // Al salir, desactiva hover si no esta deshabilitado
      child: GestureDetector(  // Widget que detecta gestos de toque
        onTap: widget.onPressed,  // Ejecuta el callback al tocar
        onTapDown: (_) => !isDisabled ? setState(() => _isPressed = true) : null,  // Al presionar, activa estado presionado
        onTapUp: (_) => !isDisabled ? setState(() => _isPressed = false) : null,  // Al soltar, desactiva estado presionado
        onTapCancel: () => !isDisabled ? setState(() => _isPressed = false) : null,  // Al cancelar toque, desactiva estado presionado
        child: AnimatedContainer(  // Contenedor con animacion de transicion
          duration: const Duration(milliseconds: 100),  // Duracion de la animacion: 100ms
          width: widget.width,  // Ancho del contenedor
          height: widget.height,  // Alto del contenedor
          decoration: BoxDecoration(  // Decoracion del contenedor
            color: currentBgColor,  // Color de fondo actual
            border: Border(  // Borde con lados independientes para efecto bisel
              top: BorderSide(color: topBorderColor, width: 3),  // Borde superior con color dinamico, grosor 3
              left: BorderSide(color: topBorderColor, width: 3),  // Borde izquierdo con color dinamico, grosor 3
              right: BorderSide(color: bottomBorderColor, width: 3),  // Borde derecho con color dinamico, grosor 3
              bottom: BorderSide(color: bottomBorderColor, width: 3),  // Borde inferior con color dinamico, grosor 3
            ),
            boxShadow: widget.shadows,  // Sombras personalizadas si se proporcionan
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),  // Relleno interno: 8px horizontal, 8px vertical
          child: _buildButtonContent(isDisabled),  // Construye el contenido interno del boton
        ),
      ),
    );
  }

  /// ═══ MÉTODO: _buildButtonContent ═══
  /// Construye el contenido interno del boton (icono opcional + texto)
  Widget _buildButtonContent(bool isDisabled) {  // Retorna el widget del contenido del boton
    final Color contentColor = isDisabled  // Color del contenido segun estado
        ? Colors.white30  // Si deshabilitado, blanco con 30% opacidad
        : (widget.textColor ?? Colors.white);  // Si habilitado, color personalizado o blanco
    final Color iconColor = widget.iconColor ?? contentColor;  // Color del icono: personalizado o el mismo del texto

    return Flex(  // Widget flexible para disposicion de hijos
      direction: widget.isVertical ? Axis.vertical : Axis.horizontal,  // Direccion: vertical u horizontal segun propiedad
      mainAxisSize: MainAxisSize.min,  // Tamano minimo segun contenido
      mainAxisAlignment: widget.alignment,  // Alineacion principal segun propiedad
      children: [  // Lista de widgets hijos
        if (widget.icon != null) ...[  // Si hay icono definido
          Icon(widget.icon, color: iconColor, size: widget.fontSize + 6),  // Muestra el icono con color y tamano ajustado
          widget.isVertical  // Si es disposicion vertical
              ? const SizedBox(height: 8)  // Espacio vertical de 8px
              : const SizedBox(width: 8),  // Espacio horizontal de 8px
        ],
        if (widget.text.isNotEmpty)  // Si el texto no esta vacio
          Flexible(  // Widget que permite al texto ajustarse al espacio disponible
            child: Text(  // Widget de texto
              widget.forceUppercase ? widget.text.toUpperCase() : widget.text,  // Texto en mayusculas si forceUppercase es true
              style: TextStyle(  // Estilo del texto
                color: contentColor,  // Color del texto
                fontFamily: widget.fontFamily,  // Familia de fuente
                fontSize: widget.fontSize,  // Tamano de fuente
                fontWeight: FontWeight.bold,  // Peso de fuente: negrita
              ),
              textAlign: TextAlign.center,  // Alineacion del texto: centrada
            ),
          ),
      ],
    );
  }

  /// ═══ MÉTODO: _buildWin95 ═══
  /// Construye el boton con estilo visual de Windows 95 (bises blancos arriba/izquierda, negros abajo/derecha)
  Widget _buildWin95(bool isDisabled) {  // Retorna el widget del boton estilo Win95
    return GestureDetector(  // Widget que detecta gestos de toque
      onTap: widget.onPressed,  // Ejecuta el callback al tocar
      child: Container(  // Contenedor principal del boton
        width: widget.width,  // Ancho del contenedor
        height: widget.height,  // Alto del contenedor
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),  // Relleno interno: 12px horizontal, 8px vertical
        decoration: BoxDecoration(  // Decoracion del contenedor
          color: isDisabled  // Color de fondo segun estado
              ? AppTheme.win95Grey.withOpacity(0.5)  // Si deshabilitado, gris con 50% opacidad
              : AppTheme.win95Grey,  // Si habilitado, gris Win95 solido
          border: const Border(  // Borde estilo Win95 con efecto bisel
            top: BorderSide(color: Colors.white, width: 2),  // Borde superior blanco, grosor 2
            left: BorderSide(color: Colors.white, width: 2),  // Borde izquierdo blanco, grosor 2
            right: BorderSide(color: Colors.black, width: 2),  // Borde derecho negro, grosor 2
            bottom: BorderSide(color: Colors.black, width: 2),  // Borde inferior negro, grosor 2
          ),
        ),
        child: Center(  // Centra el contenido horizontal y verticalmente
          child: Text(  // Widget de texto
            widget.forceUppercase ? widget.text.toUpperCase() : widget.text,  // Texto en mayusculas si forceUppercase es true
            style: TextStyle(  // Estilo del texto
              color: isDisabled ? Colors.grey : Colors.black,  // Color: gris si deshabilitado, negro si habilitado
              fontFamily: 'monospace',  // Familia de fuente: monoespaciada
              fontSize: widget.fontSize,  // Tamano de fuente
              fontWeight: FontWeight.bold,  // Peso de fuente: negrita
            ),
          ),
        ),
      ),
    );
  }
}
