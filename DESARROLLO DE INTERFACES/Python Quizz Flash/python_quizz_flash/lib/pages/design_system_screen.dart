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
import 'package:flutter/material.dart';  // importa el framework base de Flutter para construir la UI
import '../theme/app_theme.dart';  // importa las definiciones de colores y estilos globales de la app
import '../widgets/retro_button.dart';  // importa el widget de botón con estilo retro pixelado
import '../widgets/retro_container.dart';  // importa el contenedor con bordes estilo retro
import '../widgets/retro_input.dart';  // importa el campo de texto con estilo retro
import '../widgets/pixel_clip.dart';  // importa el widget del clip pixelado decorativo

/// ═══════════════════════════════════════════════════════
/// CLASE: DesignSystemScreen
/// Pantalla de demostración del sistema de diseño retro.
/// Muestra tipografías, botones, contenedores e inputs
/// con los estilos cyberpunk/retro de la aplicación.
/// Es StatelessWidget porque no mantiene estado interno.
/// ═══════════════════════════════════════════════════════
class DesignSystemScreen extends StatelessWidget {  // define una pantalla que no cambia de estado
  const DesignSystemScreen({super.key});  // constructor constante que pasa la key al padre

  @override  // sobrescribe el método build de StatelessWidget
  Widget build(BuildContext context) {  // construye la interfaz visual de la pantalla
    return Scaffold(  // widget raíz que proporciona la estructura básica de la pantalla
      appBar: AppBar(title: const Text('SISTEMA_DE_DISEÑO')),  // barra superior con título estilo terminal
      body: SingleChildScrollView(  // contenedor que permite scroll vertical cuando el contenido excede la pantalla
        padding: const EdgeInsets.all(20),  // aplica un margen interno de 20 píxeles en todos los lados
        child: Column(  // dispone los widgets hijos en una columna vertical
          crossAxisAlignment: CrossAxisAlignment.start,  // alinea todos los hijos al inicio horizontal (izquierda)
          children: [  // lista de widgets que se muestran en orden vertical
            Text(  // widget de texto para la sección de tipografía
              'TIPOGRAFÍA',  // etiqueta de la sección
              style: Theme.of(  // accede al tema global de la aplicación
                context,  // contexto de construcción actual
              ).textTheme.displayLarge?.copyWith(fontSize: 16),  // usa el estilo displayLarge reduciendo el tamaño a 16
            ),
            const Divider(color: AppTheme.borderBlue),  // línea divisoria horizontal con color azul del tema
            Text(  // muestra un ejemplo de texto con estilo de título grande
              'Título: Press Start 2P',  // texto descriptivo de la fuente de títulos
              style: Theme.of(context).textTheme.titleLarge,  // aplica el estilo titleLarge del tema
            ),
            const SizedBox(height: 10),  // espacio vertical de 10 píxeles entre widgets
            Text(  // muestra un ejemplo de texto con estilo de cuerpo
              'Cuerpo: Roboto Mono / IBM Plex Mono',  // texto descriptivo de las fuentes de cuerpo
              style: Theme.of(context).textTheme.bodyLarge,  // aplica el estilo bodyLarge del tema
            ),
            const SizedBox(height: 10),  // espacio vertical de 10 píxeles entre widgets
            Text(  // muestra un ejemplo de texto con estilo de etiqueta
              'print("Código: Fira Code")',  // texto de ejemplo que simula código Python
              style: Theme.of(context).textTheme.labelLarge,  // aplica el estilo labelLarge del tema
            ),

            const SizedBox(height: 40),  // espacio vertical grande de 40 píxeles para separar secciones
            Text(  // widget de texto para la sección de botones
              'BOTONES',  // etiqueta de la sección
              style: Theme.of(  // accede al tema global de la aplicación
                context,  // contexto de construcción actual
              ).textTheme.displayLarge?.copyWith(fontSize: 16),  // usa el estilo displayLarge con tamaño 16
            ),
            const Divider(color: AppTheme.borderBlue),  // línea divisoria horizontal azul para separar la sección
            Wrap(  // layout que envuelve los hijos automáticamente cuando no caben en una línea
              spacing: 10,  // separación horizontal de 10 píxeles entre widgets
              runSpacing: 10,  // separación vertical de 10 píxeles entre filas envueltas
              children: [  // lista de botones a mostrar
                RetroButton(text: 'PRIMARY', onPressed: () {}),  // botón primario con acción vacía de demostración
                RetroButton(  // botón secundario con estilo diferente
                  text: 'SECONDARY',  // texto que muestra el botón
                  style: RetroButtonStyle.secondary,  // aplica el estilo secundario del enum
                  onPressed: () {},  // callback vacío para demostración
                ),
                RetroButton(  // botón de peligro con estilo rojo
                  text: 'DANGER',  // texto que muestra el botón
                  style: RetroButtonStyle.danger,  // aplica el estilo danger del enum
                  onPressed: () {},  // callback vacío para demostración
                ),
                RetroButton(text: 'WIN 95', isWin95: true, onPressed: () {}),  // botón con estilo Windows 95 retro
              ],
            ),

            const SizedBox(height: 40),  // espacio vertical grande de 40 píxeles para separar secciones
            Text(  // widget de texto para la sección de contenedores
              'CONTENEDORES',  // etiqueta de la sección
              style: Theme.of(  // accede al tema global de la aplicación
                context,  // contexto de construcción actual
              ).textTheme.displayLarge?.copyWith(fontSize: 16),  // usa el estilo displayLarge con tamaño 16
            ),
            const Divider(color: AppTheme.borderBlue),  // línea divisoria horizontal azul para separar la sección
            Row(  // dispone los widgets hijos en una fila horizontal
              children: [  // lista de contenedores a mostrar lado a lado
                const Expanded(  // widget que expande para ocupar todo el espacio disponible en la fila
                  child: RetroContainer(  // contenedor con estilo retro y bordes especiales
                    isWin95: true,  // activa el estilo Windows 95 para los bordes
                    child: Text(  // texto dentro del contenedor
                      'Windows 95 Style Border',  // texto descriptivo del estilo
                      style: TextStyle(color: Colors.black),  // texto en color negro para contraste
                    ),
                  ),
                ),
                const SizedBox(width: 10),  // espacio horizontal de 10 píxeles entre contenedores
                Expanded(  // widget que expande para ocupar el espacio restante de la fila
                  child: RetroContainer(  // contenedor con estilo cyberpunk
                    isWin95: false,  // desactiva el estilo Windows 95 para usar cyberpunk
                    child: Text(  // texto dentro del contenedor
                      'Cyberpunk Style Border',  // texto descriptivo del estilo
                      style: TextStyle(color: AppTheme.primaryCyan),  // texto en color cyan del tema
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),  // espacio vertical grande de 40 píxeles para separar secciones
            Text(  // widget de texto para la sección de inputs
              'INPUTS & ASISTENTE',  // etiqueta de la sección
              style: Theme.of(  // accede al tema global de la aplicación
                context,  // contexto de construcción actual
              ).textTheme.displayLarge?.copyWith(fontSize: 16),  // usa el estilo displayLarge con tamaño 16
            ),
            const Divider(color: AppTheme.borderBlue),  // línea divisoria horizontal azul para separar la sección
            Row(  // dispone los widgets hijos en una fila horizontal
              children: [  // lista de widgets de input y decorador
                const Expanded(  // widget que expande para ocupar el espacio disponible
                  child: RetroInput(label: 'USUARIO:', hint: 'Ingresa tu nick'),  // campo de texto retro con etiqueta y placeholder
                ),
                const SizedBox(width: 20),  // espacio horizontal de 20 píxeles entre input y decorador
                const PixelClip(),  // widget decorativo del clip pixelado sin interacción
              ],
            ),
          ],
        ),
      ),
    );
  }
}
