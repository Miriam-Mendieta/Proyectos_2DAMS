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
import 'package:flutter/material.dart';  // Librería base de Flutter para widgets Material Design

// ═══ CLASE: PixelClipLogo ═══
/// Widget del logo con resplandor sutil y movimiento de levitación
class PixelClipLogo extends StatefulWidget {  // Widget con estado para animación de levitación y glow
  final double size;  // Tamaño del logo en píxeles
  final bool hasGlow;  // Indica si se muestra el efecto de resplandor
  final bool animated;  // Indica si se activa la animación de levitación

  const PixelClipLogo({  // Constructor con valores por defecto
    super.key,  // Clave del widget
    this.size = 160,  // Tamaño por defecto: 160 píxeles
    this.hasGlow = true,  // Glow activado por defecto
    this.animated = true,  // Animación activada por defecto
  });

  @override
  State<PixelClipLogo> createState() => _PixelClipLogoState();  // Crea el estado del widget
}

// ═══ CLASE: _PixelClipLogoState ═══
/// Estado del widget PixelClipLogo que maneja la animación de levitación
class _PixelClipLogoState extends State<PixelClipLogo>
    with SingleTickerProviderStateMixin {  // Mixin para proporcionar un solo Ticker
  late AnimationController _controller;  // Controlador de la animación de levitación
  late Animation<Offset> _animation;  // Animación de desplazamiento para el efecto de flotación

  @override
  void initState() {  // Inicialización del estado y configuración de animaciones
    super.initState();  // Llama al initState de la clase padre
    _controller = AnimationController(  // Crea el controlador de animación
      vsync: this,  // Sincroniza con el refresh rate de la pantalla
      duration: const Duration(seconds: 2),  // Duración de un ciclo completo: 2 segundos
    );

    _animation = Tween<Offset>(  // Interpolación de desplazamiento para levitación
      begin: Offset.zero,  // Posición inicial: sin desplazamiento
      end: const Offset(0, 0.05),  // Posición final: desplazamiento vertical de 5%
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));  // Aplica curva de animación suave

    if (widget.animated) {  // Verifica si la animación está habilitada
      _controller.repeat(reverse: true);  // Repite la animación en bucle con reversa
    }
  }

  @override
  void dispose() {  // Limpieza de recursos al destruir el widget
    _controller.dispose();  // Libera el controlador de animación
    super.dispose();  // Llama al dispose de la clase padre
  }

  @override
  Widget build(BuildContext context) {  // Construye la interfaz del widget
    const Color neonCian = Color(0xFF00F2FF);  // Color cian neón para el resplandor

    return SlideTransition(  // Widget que aplica la animación de desplazamiento
      position: _animation,  // Asigna la animación de offset
      child: Stack(  // Apila elementos centrados uno sobre otro
        alignment: Alignment.center,  // Alineación central de los elementos
        children: [  // Lista de elementos apilados
          if (widget.hasGlow)  // Condición: muestra glow solo si está activado
            Container(  // Contenedor para el efecto de resplandor
              // Resplandor reducido (menos ancho)
              width: widget.size * 0.7,  // Ancho del glow: 70% del tamaño del logo
              height: widget.size * 0.7,  // Alto del glow: 70% del tamaño del logo
              decoration: BoxDecoration(  // Decoración del contenedor
                shape: BoxShape.circle,  // Forma circular para el glow
                boxShadow: [  // Lista de sombras para el efecto de resplandor
                  BoxShadow(  // Definición de la sombra/resplandor
                    color: neonCian.withValues(alpha: 0.5),  // Color cian con 50% de opacidad
                    blurRadius: widget.size * 0.35,  // Radio de desenfoque: 35% del tamaño
                    spreadRadius: widget.size * 0.05,  // Radio de expansión: 5% del tamaño
                  ),
                ],
              ),
            ),
          Image.asset(  // Carga la imagen del logo desde los assets
            'assets/images/logo.png',  // Ruta de la imagen del logo
            height: widget.size,  // Altura según el parámetro size
            fit: BoxFit.contain,  // Ajusta la imagen manteniendo proporción
          ),
        ],
      ),
    );
  }
}
