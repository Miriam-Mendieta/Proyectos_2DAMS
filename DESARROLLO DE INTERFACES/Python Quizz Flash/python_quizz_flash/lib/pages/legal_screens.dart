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
import 'package:flutter/material.dart';  // importa el framework principal de Flutter para widgets y UI
import 'package:google_fonts/google_fonts.dart';  // permite usar fuentes personalizadas de Google Fonts
import 'package:go_router/go_router.dart';  // importa el sistema de enrutamiento go_router para navegación
import '../widgets/retro_button.dart';  // importa el botón con estilo retro personalizado
import '../widgets/retro_container.dart';  // importa el contenedor con estilo retro personalizado
import '../widgets/crt_overlay.dart';  // importa el efecto de overlay tipo pantalla CRT
import '../widgets/app_footer.dart';  // importa el componente de pie de página de la app
import '../widgets/app_header_buttons.dart';  // importa los botones del encabezado de la app
import '../theme/app_theme.dart';  // importa la configuración de temas y colores de la app

/// ═══════════════════════════════════════════════════════
/// CLASE: LegalScreen
/// Clase base para pantallas legales (Términos, Privacidad, etc.) que unifica el estilo.
/// Es un StatelessWidget porque recibe título y contenido como parámetros y no maneja estado.
/// ═══════════════════════════════════════════════════════
class LegalScreen extends StatelessWidget {
  final String title;  // título de la pantalla legal (ej: "Términos de Servicio")
  final String content;  // contenido textual de la pantalla legal

  const LegalScreen({super.key, required this.title, required this.content});  // constructor que requiere title y content

  /// ═══════════════════════════════════════════════════════
  /// MÉTODO: build
  /// Construye la UI de una pantalla legal genérica con estilo retro consistente.
  /// ═══════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {  // método obligatorio que retorna el widget visual
    const Color neonCian = AppTheme.primaryCyan;  // color cian neón desde el tema
    const Color mainBorderColor = AppTheme.borderBlue;  // color de borde azul desde el tema

    return CRTOverlay(  // aplica el efecto de overlay tipo pantalla CRT sobre toda la pantalla
      child: Scaffold(  // widget estructural base de Flutter
        backgroundColor: AppTheme.darkBg,  // establece el color de fondo oscuro del tema
        body: LayoutBuilder(  // widget que permite construir UI basada en restricciones de tamaño
          builder: (context, constraints) {  // función builder que recibe contexto y restricciones
            final bool isMobile = constraints.maxWidth < 700;  // determina si es móvil (ancho menor a 700px)
            final double sidePadding = isMobile ? 20.0 : 100.0;  // padding lateral: 20px móvil, 100px otros

            return SafeArea(  // widget que respeta las áreas seguras del dispositivo (notch, barras)
              child: Padding(  // agrega padding alrededor del contenido
                padding: EdgeInsets.symmetric(horizontal: sidePadding),  // padding lateral calculado según dispositivo
                child: Stack(  // widget que permite superponer widgets (scroll + footer fijo)
                  children: [  // lista de widgets hijos del Stack
                    SingleChildScrollView(  // permite scroll vertical cuando el contenido excede la pantalla
                      padding: const EdgeInsets.only(top: 20, bottom: 120),  // padding: 20px arriba, 120px abajo (para footer)
                      child: Column(  // columna que organiza el contenido verticalmente
                        crossAxisAlignment: CrossAxisAlignment.start,  // alinea los hijos al inicio horizontalmente
                        children: [  // widgets hijos de la columna
                          const AppHeaderButtons(),  // componente de botones del encabezado
                          const SizedBox(height: 30),  // espacio de 30px entre header y título
                          Text(  // widget de texto para el título
                            title.toUpperCase(),  // convierte el título a mayúsculas
                            style: GoogleFonts.pressStart2p(  // aplica la fuente retro Press Start 2P
                              color: neonCian,  // color cian neón para el texto
                              fontSize: 16,  // tamaño de fuente de 16px
                            ),
                          ),
                          const SizedBox(height: 30),  // espacio de 30px tras el título
                          RetroContainer(  // contenedor con estilo retro para el contenido legal
                            isWin95: false,  // desactiva el estilo Windows 95
                            borderColor: mainBorderColor.withValues(alpha: 0.3),  // borde azul con 30% opacidad
                            backgroundColor: Colors.black.withValues(alpha: 0.4),  // fondo negro con 40% opacidad
                            padding: const EdgeInsets.all(20),  // padding interno de 20px en todos los lados
                            child: Text(  // texto con el contenido legal
                              content,  // contenido pasado como parámetro al LegalScreen
                              style: GoogleFonts.shareTechMono(  // aplica la fuente monoespaciada Share Tech Mono
                                color: Colors.white70,  // color blanco con 70% opacidad
                                fontSize: 14,  // tamaño de fuente de 14px
                                height: 1.6,  // altura de línea de 1.6 (interlineado amplio para legibilidad)
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),  // espacio de 40px tras el contenedor de contenido
                          Center(  // centra su hijo horizontalmente
                            child: RetroButton(  // botón retro para volver
                              text: "ACEPTAR Y VOLVER",  // texto del botón
                              width: 220,  // anchura fija de 220px
                              height: 55,  // altura fija de 55px
                              textColor: Colors.black,  // color del texto: negro
                              style: RetroButtonStyle.primary,  // estilo primario del botón retro
                              onPressed: () => Navigator.pop(context),  // acción: cerrar la pantalla actual y volver
                            ),
                          ),
                          const SizedBox(height: 20),  // espacio de 20px tras el botón
                        ],
                      ),
                    ),
                    Positioned(  // widget para posicionar un hijo de forma absoluta dentro del Stack
                      bottom: 0,  // posiciona en la parte inferior
                      left: 0,  // alineado al borde izquierdo
                      right: 0,  // alineado al borde derecho
                      child: AppFooter(borderColor: mainBorderColor),  // componente de footer con color de borde
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// ═══════════════════════════════════════════════════════
/// CLASE: TerminosScreen
/// Pantalla de Términos de Servicio.
/// Usa LegalScreen como base pasando el título y contenido específicos.
/// ═══════════════════════════════════════════════════════
class TerminosScreen extends StatelessWidget {
  const TerminosScreen({super.key});  // constructor que pasa la clave al padre (StatelessWidget)

  @override
  Widget build(BuildContext context) {  // método obligatorio que retorna el widget visual
    return const LegalScreen(  // reutiliza LegalScreen con parámetros fijos
      title: "Términos de Servicio",  // título de la pantalla
      content: """  // contenido textual de los términos de servicio
ÚLTIMA ACTUALIZACIÓN: 20/03/2026

1. ACEPTACIÓN DE TÉRMINOS
Al acceder a la terminal de PYTHON QUIZZ FLASH, el usuario acepta quedar vinculado por estos términos de servicio, todas las leyes y regulaciones aplicables.

2. LICENCIA DE USO
Se concede permiso para descargar temporalmente una copia de los materiales (información o software) en la aplicación para uso personal, no comercial y transitorio únicamente.

3. PROPIEDAD INTELECTUAL
El código fuente, los retos algorítmicos, la interfaz gráfica y los activos de audio son propiedad exclusiva de PYTHON QUIZZ FLASH CORP. Queda prohibida su ingeniería inversa.

4. LIMITACIÓN DE RESPONSABILIDAD
En ningún caso PYTHON QUIZZ FLASH o sus proveedores serán responsables de cualquier daño (incluyendo, sin limitación, daños por pérdida de datos o beneficios, o debido a la interrupción del negocio) que surja del uso o la imposibilidad de usar el software.

5. PRECISIÓN DE LOS MATERIALES
Los materiales que aparecen en la aplicación podrían incluir errores técnicos, tipográficos o fotográficos. No garantizamos que ninguno de los materiales en su software sea preciso, completo o actual.
      """,  // fin del contenido de términos
    );
  }
}

/// ═══════════════════════════════════════════════════════
/// CLASE: PrivacidadScreen
/// Pantalla de Política de Privacidad (RGPD).
/// Usa LegalScreen como base pasando el título y contenido específicos sobre protección de datos.
/// ═══════════════════════════════════════════════════════
class PrivacidadScreen extends StatelessWidget {
  const PrivacidadScreen({super.key});  // constructor que pasa la clave al padre (StatelessWidget)

  @override
  Widget build(BuildContext context) {  // método obligatorio que retorna el widget visual
    return const LegalScreen(  // reutiliza LegalScreen con parámetros fijos
      title: "Política de Privacidad (RGPD)",  // título de la pantalla
      content: """  // contenido textual de la política de privacidad conforme a RGPD
CONFORME AL REGLAMENTO (UE) 2016/679 (RGPD)

1. RESPONSABLE DEL TRATAMIENTO
PYTHON QUIZZ FLASH CORP. garantiza la protección de los datos personales facilitados por los usuarios a través de la terminal.

2. FINALIDAD DEL TRATAMIENTO
Los datos (Email, Nombre de Usuario) se recogen exclusivamente para:
- Gestión de la cuenta de usuario y autenticación (vía Firebase Auth).
- Almacenamiento del progreso educativo y puntuaciones (vía Cloud Firestore).
- Personalización de la experiencia de aprendizaje.

3. BASE JURÍDICA
El tratamiento de sus datos se realiza con su consentimiento explícito al registrarse en la plataforma.

4. CONSERVACIÓN DE DATOS
Los datos se conservarán mientras se mantenga la relación con el usuario o hasta que este solicite su supresión mediante la función 'Eliminar Cuenta'.

5. DERECHOS DEL USUARIO (ARCO)
Usted tiene derecho a:
- Acceder a sus datos personales.
- Rectificar datos inexactos.
- Solicitar la supresión (Derecho al olvido) de sus datos.
- Oponerse o limitar el tratamiento.

6. SEGURIDAD DE LOS DATOS
Implementamos medidas técnicas de nivel Cyber-Security para evitar la pérdida, mal uso o acceso no autorizado a sus datos, utilizando la infraestructura segura de Google Cloud.
      """,  // fin del contenido de privacidad
    );
  }
}

/// ═══════════════════════════════════════════════════════
/// CLASE: ValoracionScreen
/// Pantalla de Valoración y Feedback.
/// Usa LegalScreen como base pasando el título y contenido específicos sobre soporte y feedback.
/// ═══════════════════════════════════════════════════════
class ValoracionScreen extends StatelessWidget {
  const ValoracionScreen({super.key});  // constructor que pasa la clave al padre (StatelessWidget)

  @override
  Widget build(BuildContext context) {  // método obligatorio que retorna el widget visual
    return const LegalScreen(  // reutiliza LegalScreen con parámetros fijos
      title: "Soporte y Feedback",  // título de la pantalla
      content: """  // contenido textual sobre soporte y feedback
SISTEMA DE MEJORA CONTINUA

¡Tu opinión es vital para el sistema!

Estamos trabajando para que Python Quizz Flash sea la mejor herramienta de aprendizaje. Próximamente podrás dejarnos tus 5 estrellas en la Store oficial.

Al enviarnos sus comentarios, usted acepta que utilicemos dicha información para realizar mejoras técnicas en la terminal.

Si desea reportar un fallo crítico (bug) o sugerir un nuevo reto de código, puede hacerlo a través de nuestros canales oficiales de comunicación.
      """,  // fin del contenido de valoración/feedback
    );
  }
}
