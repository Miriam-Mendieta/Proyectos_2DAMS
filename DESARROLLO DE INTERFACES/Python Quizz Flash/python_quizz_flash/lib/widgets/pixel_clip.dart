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
import '../theme/app_theme.dart';  // Tema de la aplicación con colores y estilos definidos

// ═══ CLASE: PixelClip ═══
/// Personaje asistente IA en pixel art con animación de flotación.
class PixelClip extends StatefulWidget {  // Widget con estado para el personaje animado
  final double size;  // Tamaño del personaje en píxeles
  const PixelClip({super.key, this.size = 80});  // Constructor con tamaño por defecto de 80

  @override
  State<PixelClip> createState() => _PixelClipState();  // Crea el estado del widget
}

// ═══ CLASE: _PixelClipState ═══
/// Estado del widget PixelClip que maneja la animación de flotación vertical
class _PixelClipState extends State<PixelClip>
    with SingleTickerProviderStateMixin {  // Mixin para proporcionar un solo Ticker
  late AnimationController _controller;  // Controlador de la animación de flotación
  late Animation<double> _animation;  // Animación de valor doble para el desplazamiento vertical

  @override
  void initState() {  // Inicialización del estado y configuración de animaciones
    super.initState();  // Llama al initState de la clase padre
    _controller = AnimationController(  // Crea el controlador de animación
      vsync: this,  // Sincroniza con el refresh rate de la pantalla
      duration: const Duration(seconds: 2),  // Duración de un ciclo completo: 2 segundos
    )..repeat(reverse: true);  // Repite la animación en bucle con reversa inmediatamente

    _animation = Tween<double>(  // Interpolación de valor double para desplazamiento
      begin: 0,  // Valor inicial: 0 píxeles de desplazamiento
      end: 15,  // Valor final: 15 píxeles de desplazamiento vertical
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));  // Aplica curva suave
  }

  @override
  void dispose() {  // Limpieza de recursos al destruir el widget
    _controller.dispose();  // Libera el controlador de animación
    super.dispose();  // Llama al dispose de la clase padre
  }

  @override
  Widget build(BuildContext context) {  // Construye la interfaz del widget
    return AnimatedBuilder(  // Widget que reconstruye al cambiar la animación
      animation: _animation,  // Escucha los cambios de la animación
      builder: (context, child) {  // Función constructora llamada en cada frame
        return Transform.translate(  // Aplica desplazamiento al widget hijo
          offset: Offset(0, -_animation.value),  // Desplazamiento vertical negativo (hacia arriba)
          child: Container(  // Contenedor principal del personaje
            width: widget.size,  // Ancho según el parámetro size
            height: widget.size,  // Alto según el parámetro size
            decoration: BoxDecoration(  // Decoración del contenedor
              color: AppTheme.surfaceBlue,  // Color de fondo desde el tema de la app
              border: Border.all(color: AppTheme.primaryCyan, width: 3),  // Borde cian de 3px
              boxShadow: [AppTheme.glow()],  // Efecto de resplandor desde el tema
            ),
            child: const Center(  // Centra el contenido interno
              child: Icon(  // Ícono temporal como representación del PixelClip
                Icons
                    .face_retouching_natural,  // Representación temporal del PixelClip
                color: AppTheme.primaryCyan,  // Color cian del ícono desde el tema
                size: 40,  // Tamaño fijo del ícono: 40 píxeles
              ),
            ),
          ),
        );
      },
    );
  }
}
