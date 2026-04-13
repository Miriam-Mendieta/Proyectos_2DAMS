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
import 'package:google_fonts/google_fonts.dart';  // Importa Google Fonts para usar fuentes personalizadas (ShareTechMono)

/// ═══ CLASE: CyberButton ═══
/// Boton estilo cyber con efecto de presionado 3D y soporte de estado de carga.
/// Usa bordes asimetricos para crear un efecto de relieve que cambia al presionar.
class CyberButton extends StatefulWidget {  // Extiende StatefulWidget para manejar el estado de presionado
  final String text;  // Texto que se muestra en el boton
  final VoidCallback? onPressed;  // Funcion que se ejecuta al presionar el boton (null = deshabilitado)
  final bool isLoading;  // Si es true, muestra un indicador de carga en lugar del texto

  /// ═══ MÉTODO: Constructor de CyberButton ═══
  /// Inicializa el boton cyber con texto, callback y estado de carga
  const CyberButton({
    super.key,  // Clave del widget para identificacion en el arbol
    required this.text,  // Parametro obligatorio: texto del boton
    this.onPressed,  // Callback opcional de presionado
    this.isLoading = false,  // Por defecto no esta en estado de carga
  });

  @override
  State<CyberButton> createState() => _CyberButtonState();  // Crea el estado asociado al widget
}

/// ═══ CLASE: _CyberButtonState ═══
/// Estado interno del CyberButton que maneja el efecto visual de presionado
class _CyberButtonState extends State<CyberButton> {  // Extiende State para manejar estado local
  bool _isPressed = false;  // Indica si el boton esta siendo presionado actualmente

  @override
  Widget build(BuildContext context) {  // Construye la interfaz visual del boton
    const Color buttonColor = Color(0xFF7B89A8);  // Color principal del boton (gris azulado claro)
    const Color reliefColor = Color(0xFF4A556E);  // Color de sombra/relieve del boton (gris azulado oscuro)
    const Color textColor = Color(0xFF152A3E);  // Color del texto (azul oscuro casi negro)

    return GestureDetector(  // Widget que detecta gestos de toque
      onTapDown: (_) => setState(() => _isPressed = true),  // Al presionar, activa estado _isPressed
      onTapUp: (_) => setState(() => _isPressed = false),  // Al soltar, desactiva estado _isPressed
      onTapCancel: () => setState(() => _isPressed = false),  // Al cancelar toque, desactiva estado _isPressed
      onTap: widget.isLoading ? null : widget.onPressed,  // Ejecuta callback solo si no esta cargando
      child: AnimatedContainer(  // Contenedor con animacion de transicion para el efecto 3D
        duration: const Duration(milliseconds: 50),  // Duracion de la animacion: 50ms (rapida)
        width: double.infinity,  // Ancho: ocupa todo el espacio disponible (flexible)
        padding: const EdgeInsets.symmetric(vertical: 12),  // Relleno vertical: 12px arriba y abajo
        decoration: BoxDecoration(  // Decoracion del contenedor
          color: buttonColor,  // Color de fondo principal del boton
          border: Border(  // Borde con lados independientes para efecto 3D
            top: BorderSide(  // Borde superior
              color: _isPressed ? reliefColor : Colors.white,  // Si presionado: oscuro, si no: blanco
              width: 2,  // Grosor del borde superior: 2px
            ),
            left: BorderSide(  // Borde izquierdo
              color: _isPressed ? reliefColor : Colors.white,  // Si presionado: oscuro, si no: blanco
              width: 2,  // Grosor del borde izquierdo: 2px
            ),
            right: BorderSide(  // Borde derecho
              color: _isPressed ? Colors.white : reliefColor,  // Si presionado: blanco, si no: oscuro (invertido)
              width: 4,  // Grosor del borde derecho: 4px (mas grueso para efecto 3D)
            ),
            bottom: BorderSide(  // Borde inferior
              color: _isPressed ? Colors.white : reliefColor,  // Si presionado: blanco, si no: oscuro (invertido)
              width: 4,  // Grosor del borde inferior: 4px (mas grueso para efecto 3D)
            ),
          ),
        ),
        child: Center(  // Centra el contenido horizontal y verticalmente
          child: widget.isLoading  // Condicional: si esta en estado de carga
              ? const SizedBox(  // Muestra un contenedor de tamano fijo
                  height: 20,  // Alto del spinner: 20px
                  width: 20,  // Ancho del spinner: 20px
                  child: CircularProgressIndicator(  // Indicador de carga circular
                    strokeWidth: 2,  // Grosor de la linea del spinner: 2px
                    color: textColor,  // Color del spinner: azul oscuro
                  ),
                )
              : Text(  // Si no esta cargando, muestra el texto del boton
                  widget.text.toUpperCase(),  // Texto convertido a mayusculas
                  style: GoogleFonts.shareTechMono(  // Estilo de fuente: Share Tech Mono (monoespaciada)
                    color: textColor,  // Color del texto: azul oscuro
                    fontSize: 16,  // Tamano de fuente: 16
                    fontWeight: FontWeight.bold,  // Peso de fuente: negrita
                    letterSpacing: 1.5,  // Espaciado entre letras: 1.5px
                  ),
                ),
        ),
      ),
    );
  }
}
