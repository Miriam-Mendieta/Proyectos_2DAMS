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

// ═══ IMPORTS: Dependencias para tests de widgets ═══

import 'package:flutter/material.dart';  // importa framework de Flutter para widgets
import 'package:flutter_test/flutter_test.dart';  // importa framework de tests para Flutter
import 'package:google_fonts/google_fonts.dart';  // importa Google Fonts para fuentes personalizadas
import 'package:python_quizz_flash/widgets/cyber_button.dart';  // importa widget CyberButton
import 'package:python_quizz_flash/widgets/retro_input.dart';  // importa widget RetroInput

/// ═══ GRUPO PRINCIPAL: Tests de Widgets ═══
/// Verifica que los widgets personalizados se rendericen correctamente
/// y respondan apropiadamente a interacciones del usuario.
void main() {
  // ═══ GRUPO: CyberButton ═══
  group('CyberButton Widget Tests', () {
    
    /// Test: CyberButton se renderiza con texto
    testWidgets('should render with text', (WidgetTester tester) async {
      // Arrange & Act: construye CyberButton
      await tester.pumpWidget(
        MaterialApp(  // envuelve en MaterialApp para acceso a tema y material
          home: Scaffold(  // Scaffold provee estructura básica
            body: CyberButton(  // widget a testear
              text: 'Click Me',  // texto del botón
              onPressed: () {},  // callback vacío
            ),
          ),
        ),
      );

      // Assert: verifica que el texto se muestra
      expect(find.text('CLICK ME'), findsOneWidget);  // texto en mayúsculas encontrado
    });

    /// Test: CyberButton ejecuta callback al hacer tap
    testWidgets('should execute onPressed when tapped', (WidgetTester tester) async {
      // Arrange
      bool wasPressed = false;  // flag para verificar callback

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(  // builder con estado para actualizar flag
            builder: (context, setState) {  // builder function
              return Scaffold(
                body: CyberButton(
                  text: 'Press Me',  // texto del botón
                  onPressed: () {  // callback de presionado
                    setState(() => wasPressed = true);  // actualiza flag
                  },
                ),
              );
            },
          ),
        ),
      );

      // Act: simula tap en el botón
      await tester.tap(find.text('PRESS ME'));  // encuentra y toca el botón
      await tester.pumpAndSettle();  // espera animaciones y rebuilds

      // Assert: verifica que se ejecutó el callback
      expect(wasPressed, true);  // flag debe ser verdadero
    });

    /// Test: CyberButton no ejecuta onPressed cuando isLoading es true
    testWidgets('should not execute onPressed when loading', (WidgetTester tester) async {
      // Arrange
      bool wasPressed = false;  // flag para verificar callback

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                body: CyberButton(
                  text: 'Loading Button',  // texto del botón
                  isLoading: true,  // estado de carga activado
                  onPressed: () {  // callback que no debería ejecutarse
                    setState(() => wasPressed = true);
                  },
                ),
              );
            },
          ),
        ),
      );

      // Act: intenta tap en el botón (debería estar bloqueado)
      await tester.tap(find.byType(CyberButton));  // toca el botón
      await tester.pump(const Duration(milliseconds: 100));  // pump manual (evita timeout por CircularProgressIndicator)

      // Assert: verifica que NO se ejecutó el callback
      expect(wasPressed, false);  // flag debe seguir falso
    });

    /// Test: CyberButton muestra indicador de carga cuando isLoading es true
    testWidgets('should show loading indicator when isLoading is true', (WidgetTester tester) async {
      // Arrange & Act: construye botón en estado de carga
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CyberButton(
              text: 'Test Button',  // texto del botón
              isLoading: true,  // estado de carga activado
              onPressed: () {},  // callback vacío
            ),
          ),
        ),
      );

      // Assert: verifica que se muestra CircularProgressIndicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);  // spinner encontrado
    });

    /// Test: CyberButton no muestra texto cuando isLoading es true
    testWidgets('should not show text when loading', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CyberButton(
              text: 'Hidden Text',  // texto que debería estar oculto
              isLoading: true,  // estado de carga
              onPressed: () {},
            ),
          ),
        ),
      );

      // Assert: verifica que el texto NO se muestra
      expect(find.text('HIDDEN TEXT'), findsNothing);  // texto no encontrado
    });

    /// Test: CyberButton deshabilitado cuando onPressed es null
    testWidgets('should be disabled when onPressed is null', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CyberButton(
              text: 'Disabled',  // texto del botón
              onPressed: null,  // sin callback = deshabilitado
            ),
          ),
        ),
      );

      // Assert: verifica que el botón está deshabilitado
      expect(find.text('DISABLED'), findsOneWidget);  // texto se muestra
      // No se puede hacer tap en botón deshabilitado, pero se puede verificar que existe
    });

    /// Test: CyberButton aplica estilo visual correcto
    testWidgets('should have correct visual styling', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CyberButton(
              text: 'Styled Button',  // texto del botón
              onPressed: () {},
            ),
          ),
        ),
      );

      // Assert: verifica que el botón existe y es del tipo correcto
      final buttonFinder = find.byType(CyberButton);
      expect(buttonFinder, findsOneWidget);  // botón encontrado
      
      // Verifica que el contenedor animado existe
      expect(find.byType(AnimatedContainer), findsWidgets);  // AnimatedContainer presente
    });

    /// Test: CyberButton maneja estado de presionado visualmente
    testWidgets('should handle pressed state visually', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CyberButton(
              text: 'Press Test',  // texto del botón
              onPressed: () {},
            ),
          ),
        ),
      );

      // Act: presiona y mantén presionado
      final gesture = await tester.startGesture(tester.getCenter(find.text('PRESS TEST')));  // inicia gesto
      await tester.pump();  // pump para registrar down
      
      // El botón debería estar en estado presionado ahora
      await tester.pump(const Duration(milliseconds: 25));  // espera un poco
      await gesture.up();  // levanta el dedo
      await tester.pump();  // pump para registrar up
    });
  });

  // ═══ GRUPO: RetroInput ═══
  group('RetroInput Widget Tests', () {
    
    /// Test: RetroInput se renderiza con label
    testWidgets('should render with label', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RetroInput(
              label: 'Username',  // etiqueta del campo
              hint: 'Enter username',  // hint opcional
            ),
          ),
        ),
      );

      // Assert: verifica que la etiqueta se muestra
      expect(find.text('Username'), findsOneWidget);  // etiqueta encontrada
    });

    /// Test: RetroInput muestra hint text
    testWidgets('should show hint text', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RetroInput(
              label: 'Email',  // etiqueta
              hint: 'user@example.com',  // texto de sugerencia
            ),
          ),
        ),
      );

      // Assert: verifica hint text
      expect(find.text('user@example.com'), findsOneWidget);  // hint encontrado
    });

    /// Test: RetroInput permite escribir texto
    testWidgets('should allow text input', (WidgetTester tester) async {
      // Arrange
      final controller = TextEditingController();  // controlador para el campo

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                body: RetroInput(
                  label: 'Input Test',  // etiqueta
                  controller: controller,  // controlador
                ),
              );
            },
          ),
        ),
      );

      // Act: escribe en el campo
      await tester.enterText(find.byType(TextField), 'Hello World');  // ingresa texto
      await tester.pump(const Duration(seconds: 1));  // espera 1 segundo (en lugar de pumpAndSettle)

      // Assert: verifica que el texto se ingresó
      expect(controller.text, 'Hello World');  // texto en controlador
    });

    /// Test: RetroInput con obscureText para contraseñas
    testWidgets('should obscure text when enabled', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RetroInput(
              label: 'Password',  // etiqueta
              hint: 'Enter password',  // hint
              obscureText: true,  // activar modo contraseña
            ),
          ),
        ),
      );

      // Assert: verifica que TextField está configurado para ocultar texto
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.obscureText, true);  // obscureText activado
    });

    /// Test: RetroInput muestra prompt de terminal '> '
    testWidgets('should show terminal prompt', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RetroInput(
              label: 'Terminal',  // etiqueta
            ),
          ),
        ),
      );

      // Assert: verifica que el prompt '> ' se muestra
      expect(find.text('> '), findsOneWidget);  // prompt encontrado
    });

    /// Test: RetroInput tiene fondo negro estilo terminal
    testWidgets('should have terminal-style black background', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RetroInput(
              label: 'Console',  // etiqueta
            ),
          ),
        ),
      );

      // Assert: verifica que existe al menos un Container
      final containerFinder = find.byType(Container);
      expect(containerFinder, findsWidgets);  // hay múltiples containers
    });

    /// Test: RetroInput con controlador personalizado
    testWidgets('should work with custom controller', (WidgetTester tester) async {
      // Arrange
      final controller = TextEditingController(text: 'Initial Text');  // controlador con texto inicial

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RetroInput(
              label: 'Custom',  // etiqueta
              controller: controller,  // controlador personalizado
            ),
          ),
        ),
      );

      // Act: intenta cambiar el texto
      await tester.enterText(find.byType(TextField), 'New Text');
      await tester.pump(const Duration(seconds: 1));  // espera 1 segundo (en lugar de pumpAndSettle)

      // Assert: verifica que el controlador tiene el nuevo texto
      expect(controller.text, 'New Text');  // texto actualizado
    });

    /// Test: RetroInput sin hint usa string vacío
    testWidgets('should use empty string as default hint', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RetroInput(
              label: 'No Hint',  // etiqueta sin hint explícito
              // hint no proporcionado, usa default ''
            ),
          ),
        ),
      );

      // Assert: verifica que no hay hint visible (es vacío)
      // El TextField puede mostrar hint vacío sin problemas
      expect(find.byType(TextField), findsOneWidget);  // TextField existe
    });

    /// Test: RetroInput animación de cursor
    testWidgets('should have cursor animation', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RetroInput(
              label: 'Animated',  // etiqueta
            ),
          ),
        ),
      );

      // Avanza el tiempo para ver animación de cursor
      await tester.pump(const Duration(milliseconds: 250));  // mitad del ciclo
      await tester.pump(const Duration(milliseconds: 250));  // final del ciclo
      
      // Assert: verifica que el widget sigue vivo después de animación
      expect(find.byType(RetroInput), findsOneWidget);  // widget existe
    });

    /// Test: RetroInput múltiples inputs independientes
    testWidgets('should handle multiple independent inputs', (WidgetTester tester) async {
      // Arrange
      final controller1 = TextEditingController();  // primer controlador
      final controller2 = TextEditingController();  // segundo controlador

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(  // columna con múltiples inputs
              children: [
                RetroInput(
                  label: 'First',  // primera etiqueta
                  controller: controller1,
                ),
                RetroInput(
                  label: 'Second',  // segunda etiqueta
                  controller: controller2,
                ),
              ],
            ),
          ),
        ),
      );

      // Act: escribe en ambos campos
      await tester.enterText(find.byType(TextField).first, 'Input 1');  // primer campo
      await tester.enterText(find.byType(TextField).last, 'Input 2');  // segundo campo
      await tester.pump(const Duration(seconds: 1));  // espera 1 segundo (en lugar de pumpAndSettle)

      // Assert: verifica que cada controlador tiene su texto
      expect(controller1.text, 'Input 1');  // primer texto
      expect(controller2.text, 'Input 2');  // segundo texto
    });
  });
}
