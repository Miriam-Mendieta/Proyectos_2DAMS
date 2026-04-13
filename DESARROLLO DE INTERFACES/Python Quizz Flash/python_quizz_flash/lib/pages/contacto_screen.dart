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
import 'package:flutter/services.dart';  // importa servicios del sistema como portapapeles y orientación
import 'package:url_launcher/url_launcher.dart';  // permite abrir URLs externas (navegador, email, etc.)
import 'package:font_awesome_flutter/font_awesome_flutter.dart';  // provee iconos de FontAwesome para la UI
import 'package:google_fonts/google_fonts.dart';  // permite usar fuentes personalizadas de Google Fonts
import '../theme/app_theme.dart';  // importa la configuración de temas y colores de la app
import '../widgets/retro_container.dart';  // importa el contenedor con estilo retro personalizado
import '../widgets/app_header_buttons.dart';  // importa los botones del encabezado de la app
import '../widgets/app_notifications.dart';  // importa el sistema de notificaciones de la app

/// ═══════════════════════════════════════════════════════
/// CLASE: _SocialLink
/// Modelo de datos interno para organizar la información de cada red social.
/// Contiene el nombre, icono, subtítulo, URL y si es un enlace de email.
/// ═══════════════════════════════════════════════════════
class _SocialLink {
  final String label;  // nombre visible de la red social (ej: "GitHub")
  final IconData icon;  // icono de FontAwesome asociado a la red social
  final String subtitle;  // descripción corta que aparece debajo del label
  final String url;  // enlace directo al perfil o página web
  final bool isEmail;  // bandera que indica si el enlace es un correo electrónico

  /// Constructor constante que requiere label, icon, subtitle y url; isEmail es opcional (default: false)
  const _SocialLink({
    required this.label,  // parámetro obligatorio: nombre de la red social
    required this.icon,  // parámetro obligatorio: icono a mostrar
    required this.subtitle,  // parámetro obligatorio: subtítulo descriptivo
    required this.url,  // parámetro obligatorio: URL del enlace
    this.isEmail = false,  // parámetro opcional: indica si es un email (por defecto false)
  });

  bool get isEnabled => url.isNotEmpty;  // getter que devuelve true si la URL no está vacía (enlace activo)
}

/// ═══════════════════════════════════════════════════════
/// CLASE: ContactoScreen
/// Pantalla de Contacto - Configurada con diseño responsivo para móvil, tablet y PC.
/// Es un StatefulWidget porque necesita manejar estado interno como el logo pre-cacheado.
/// ═══════════════════════════════════════════════════════
class ContactoScreen extends StatefulWidget {
  const ContactoScreen({super.key});  // constructor que pasa la clave al padre (StatefulWidget)

  @override
  State<ContactoScreen> createState() => _ContactoScreenState();  // crea el estado asociado a esta pantalla
}

/// ═══════════════════════════════════════════════════════
/// CLASE: _ContactoScreenState
/// Estado interno de ContactoScreen que maneja la inicialización del logo y las acciones de contacto.
/// ═══════════════════════════════════════════════════════
class _ContactoScreenState extends State<ContactoScreen> {
  late Image _contactLogo;  // variable que almacena la imagen del logo de contacto (se inicializa en initState)

  /// ═══════════════════════════════════════════════════════
  /// MÉTODO: initState
  /// Se ejecuta una vez al crear el widget. Inicializa la imagen del logo con sus propiedades.
  /// ═══════════════════════════════════════════════════════
  @override
  void initState() {
    super.initState();  // llama al initState del padre (obligatorio en Flutter)
    _contactLogo = Image.asset(  // carga la imagen desde los assets del proyecto
      'assets/images/logoContacto.png',  // ruta del archivo de imagen en assets
      height: 280,  // altura fija de la imagen en píxeles
      width: 280,  // anchura fija de la imagen en píxeles
      fit: BoxFit.contain,  // ajusta la imagen manteniendo proporción sin recortar
    );
  }

  /// ═══════════════════════════════════════════════════════
  /// MÉTODO: didChangeDependencies
  /// Se ejecuta cuando cambian las dependencias del widget. Precachea la imagen para mejor rendimiento.
  /// ═══════════════════════════════════════════════════════
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();  // llama al método del padre (obligatorio)
    precacheImage(_contactLogo.image, context);  // precarga la imagen en caché para evitar parpadeos al mostrarla
  }

  /// ═══════════════════════════════════════════════════════
  /// MÉTODO: _handleAction
  /// Maneja la acción al tocar un enlace social: copia email o abre URL externa.
  /// ═══════════════════════════════════════════════════════
  Future<void> _handleAction(_SocialLink link) async {  // método asíncrono que recibe un enlace social
    if (link.isEmail) {  // si el enlace es un correo electrónico
      await Clipboard.setData(ClipboardData(text: link.url));  // copia el email al portapapeles del dispositivo
      if (mounted) {  // verifica que el widget siga montado en el árbol (evita errores de estado)
        AppNotifications.show(context, 'CORREO COPIADO EN PORTAPAPELES');  // muestra notificación de confirmación
      }
    } else {  // si no es email, es una URL normal
      final Uri uri = Uri.parse(link.url);  // convierte la string de URL en un objeto Uri
      if (!await launchUrl(uri)) {  // intenta abrir la URL en el navegador; si falla
        debugPrint('No se pudo abrir el enlace: ${link.url}');  // imprime mensaje de error en consola de debug
      }
    }
  }

  /// Lista constante de enlaces sociales predefinidos con sus datos
  final List<_SocialLink> _socialLinks = const [
    _SocialLink(  // entrada para GitHub
      label: 'GitHub',  // nombre visible
      icon: FontAwesomeIcons.github,  // icono de GitHub de FontAwesome
      subtitle: 'Repositorios y proyectos',  // descripción corta
      url: 'https://github.com/Miriam-Mendieta',  // enlace al perfil de GitHub
    ),
    _SocialLink(  // entrada para LinkedIn
      label: 'LinkedIn',  // nombre visible
      icon: FontAwesomeIcons.linkedin,  // icono de LinkedIn de FontAwesome
      subtitle: 'Perfil profesional',  // descripción corta
      url: 'https://www.linkedin.com/in/miriam-mendieta',  // enlace al perfil de LinkedIn
    ),
    _SocialLink(  // entrada para Twitter (deshabilitada - URL vacía)
      label: 'Twitter',  // nombre visible
      icon: FontAwesomeIcons.xTwitter,  // icono de X/Twitter de FontAwesome
      subtitle: 'Actualizaciones y tweets',  // descripción corta
      url: '',  // URL vacía indica que el enlace está deshabilitado
    ),
    _SocialLink(  // entrada para Instagram (deshabilitada - URL vacía)
      label: 'Instagram',  // nombre visible
      icon: FontAwesomeIcons.instagram,  // icono de Instagram de FontAwesome
      subtitle: 'Contenido visual',  // descripción corta
      url: '',  // URL vacía indica que el enlace está deshabilitado
    ),
    _SocialLink(  // entrada para Email (copia al portapapeles)
      label: 'Email',  // nombre visible
      icon: FontAwesomeIcons.envelope,  // icono de sobre/email de FontAwesome
      subtitle: 'Contacto directo',  // descripción corta
      url: 'ejemploMiEmpresa@empresa.com',  // dirección de correo electrónico a copiar
      isEmail: true,  // marca este enlace como email (activa lógica de copiado)
    ),
    _SocialLink(  // entrada para Portfolio (deshabilitada - URL vacía)
      label: 'Portfolio',  // nombre visible
      icon: FontAwesomeIcons.globe,  // icono de globo/web de FontAwesome
      subtitle: 'Sitio web personal',  // descripción corta
      url: '',  // URL vacía indica que el enlace está deshabilitado
    ),
  ];

  /// ═══════════════════════════════════════════════════════
  /// MÉTODO: build
  /// Construye la UI completa de la pantalla de contacto con diseño responsivo.
  /// ═══════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {  // método obligatorio de StatelessWidget/State que retorna el widget visual
    const Color cardBg = AppTheme.surfaceBlue;  // color de fondo de las tarjetas desde el tema
    const Color neonCian = AppTheme.primaryCyan;  // color cian neón principal desde el tema

    return Scaffold(  // widget estructural base de Flutter que proporciona la pantalla
      backgroundColor: AppTheme.darkBg,  // establece el color de fondo oscuro del tema
      body: LayoutBuilder(  // widget que permite construir UI basada en las restricciones de tamaño
        builder: (context, constraints) {  // función builder que recibe contexto y restricciones de layout
          final double width = constraints.maxWidth;  // obtiene el ancho máximo disponible
          final bool isMobile = width < 700;  // determina si es móvil (ancho menor a 700px)
          final bool isTablet = width >= 700 && width < 1100;  // determina si es tablet (entre 700 y 1100px)

          final double sidePadding = isMobile  // calcula el padding lateral según dispositivo
              ? 20.0  // 20px para móvil
              : (isTablet ? 60.0 : 120.0);  // 60px para tablet, 120px para PC
          final int crossAxisCount = isMobile ? 1 : (isTablet ? 2 : 3);  // columnas del grid: 1 móvil, 2 tablet, 3 PC
          final double logoSize = isMobile ? 220 : 280;  // tamaño del logo: 220px móvil, 280px otros
          final double gridSpacing = isMobile ? 20 : 30;  // espaciado del grid: 20px móvil, 30px otros

          return SafeArea(  // widget que respeta las áreas seguras del dispositivo (notch, barras)
            child: Padding(  // agrega padding alrededor del contenido
              padding: EdgeInsets.symmetric(  // padding simétrico horizontal y vertical
                horizontal: sidePadding,  // padding lateral calculado según dispositivo
                vertical: 20,  // padding vertical fijo de 20px
              ),
              child: Column(  // layout en columna que apila los widgets verticalmente
                children: [  // lista de widgets hijos de la columna
                  const AppHeaderButtons(),  // componente de botones del encabezado
                  const SizedBox(height: 25),  // espacio vertical de 25px entre header y título
                  Align(  // widget para alinear su hijo dentro del espacio disponible
                    alignment: Alignment.centerLeft,  // alinea el texto a la izquierda
                    child: Text(  // widget de texto para el título "Contacto"
                      'Contacto',  // texto del título
                      style: GoogleFonts.pressStart2p(  // aplica la fuente retro Press Start 2P
                        fontSize: isMobile ? 14 : 16,  // tamaño: 14px móvil, 16px otros
                        color: neonCian,  // color cian neón para el texto
                        letterSpacing: 1.2,  // espaciado entre letras de 1.2px
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),  // espacio vertical de 30px tras el título
                  Expanded(  // widget que ocupa todo el espacio restante disponible
                    child: RetroContainer(  // contenedor con estilo retro personalizado
                      isWin95: false,  // desactiva el estilo Windows 95
                      showGlow: false,  // desactiva el efecto de resplandor
                      borderColor: Colors.transparent,  // borde transparente
                      backgroundColor: cardBg.withValues(alpha: 0.3),  // fondo azul semitransparente (30% opacidad)
                      padding: EdgeInsets.zero,  // sin padding interno en el contenedor
                      child: SingleChildScrollView(  // permite scroll vertical cuando el contenido excede la pantalla
                        padding: EdgeInsets.symmetric(  // padding interno del scroll
                          horizontal: isMobile ? 20 : 30,  // 20px móvil, 30px otros dispositivos
                          vertical: 25,  // padding vertical de 25px
                        ),
                        child: Column(  // columna interna que organiza el contenido scrolleable
                          children: [  // widgets hijos de la columna interna
                            Center(  // centra su hijo horizontalmente
                              child: Container(  // contenedor para el logo con efectos de sombra
                                width: logoSize,  // anchura del contenedor según dispositivo
                                height: logoSize,  // altura del contenedor según dispositivo
                                decoration: BoxDecoration(  // decoración del contenedor
                                  shape: BoxShape.circle,  // forma circular para el contenedor
                                  boxShadow: [  // lista de sombras (box shadows)
                                    BoxShadow(  // definición de una sombra
                                      color: neonCian.withValues(alpha: 0.1),  // color cian con 10% opacidad
                                      blurRadius: isMobile ? 40 : 60,  // radio de desenfoque: 40px móvil, 60px otros
                                      spreadRadius: isMobile ? 10 : 20,  // radio de expansión: 10px móvil, 20px otros
                                    ),
                                  ],
                                ),
                                child: _contactLogo,  // la imagen del logo precargada
                              ),
                            ),
                            const SizedBox(height: 35),  // espacio de 35px tras el logo
                            Text(  // texto con el nombre "Miriam Mendieta"
                              'Miriam Mendieta',  // nombre a mostrar
                              textAlign: TextAlign.center,  // centra el texto horizontalmente
                              style: GoogleFonts.pressStart2p(  // fuente retro Press Start 2P
                                fontSize: isMobile ? 16 : (isTablet ? 20 : 24),  // tamaño responsivo: 16/20/24px
                                color: neonCian,  // color cian neón
                                height: 1.5,  // altura de línea de 1.5 (interlineado)
                              ),
                            ),
                            const SizedBox(height: 15),  // espacio de 15px tras el nombre
                            Text(  // texto descriptivo sobre la desarrolladora
                              'Desarrolladora y creadora de Python_Quizz_Flash.\nConéctate conmigo en las siguientes plataformas:',  // contenido del texto con salto de línea
                              textAlign: TextAlign.center,  // centra el texto
                              style: GoogleFonts.shareTechMono(  // fuente monoespaciada Share Tech Mono
                                fontSize: isMobile ? 14 : 16,  // tamaño: 14px móvil, 16px otros
                                color: Colors.grey.shade400,  // color gris claro (tono 400)
                                height: 1.4,  // altura de línea de 1.4
                              ),
                            ),
                            const SizedBox(height: 40),  // espacio de 40px antes del grid
                            GridView.builder(  // constructor de grid dinámico para las tarjetas sociales
                              shrinkWrap: true,  // ajusta el tamaño del grid a su contenido (necesario dentro de scroll)
                              physics: const NeverScrollableScrollPhysics(),  // deshabilita scroll propio del grid (el padre maneja scroll)
                              clipBehavior: Clip.none,  // no recorta hijos que excedan los límites
                              gridDelegate:  // delegado que define la estructura del grid
                                  SliverGridDelegateWithFixedCrossAxisCount(  // grid con número fijo de columnas
                                    crossAxisCount: crossAxisCount,  // número de columnas según dispositivo
                                    mainAxisSpacing: gridSpacing,  // espaciado vertical entre items
                                    crossAxisSpacing: gridSpacing,  // espaciado horizontal entre items
                                    childAspectRatio: isMobile  // proporción ancho/alto de cada tarjeta
                                        ? 3.2  // 3.2 para móvil (más alargada)
                                        : (isTablet ? 2.2 : 2.0),  // 2.2 tablet, 2.0 PC
                                  ),
                              itemCount: _socialLinks.length,  // número total de items = longitud de la lista
                              itemBuilder: (context, index) {  // función constructora para cada item del grid
                                return _SocialCard(  // retorna una tarjeta social personalizada
                                  link: _socialLinks[index],  // pasa el enlace correspondiente al índice
                                  onAction: _handleAction,  // pasa la función para manejar acciones
                                  isMobile: isMobile,  // pasa bandera de si es móvil para ajustes de tamaño
                                );
                              },
                            ),
                            const SizedBox(height: 50),  // espacio de 50px tras el grid
                            Container(  // contenedor para el footer con copyright
                              width: double.infinity,  // ocupa todo el ancho disponible
                              padding: const EdgeInsets.all(20),  // padding interno de 20px en todos los lados
                              decoration: BoxDecoration(  // decoración del contenedor
                                color: Colors.black.withValues(alpha: 0.3),  // fondo negro semitransparente (30%)
                                border: Border.all(  // borde del contenedor
                                  color: neonCian.withValues(alpha: 0.1),  // color cian con 10% opacidad
                                ),
                                borderRadius: BorderRadius.circular(4),  // esquinas redondeadas de 4px
                              ),
                              child: Column(  // columna interna para los textos de copyright
                                children: [  // widgets hijos
                                  Text(  // texto de copyright y año
                                    '© 2026 Miriam Mendieta • Python_Quizz_Flash',  // contenido del texto
                                    style: GoogleFonts.shareTechMono(  // fuente monoespaciada
                                      fontSize: isMobile ? 11 : 12,  // tamaño: 11px móvil, 12px otros
                                      color: Colors.grey.shade400,  // color gris claro
                                    ),
                                  ),
                                  const SizedBox(height: 8),  // espacio de 8px entre líneas
                                  Text(  // texto descriptivo del estilo
                                    'Hecho con 💜 y estética retro-tech',  // contenido del texto
                                    style: GoogleFonts.shareTechMono(  // fuente monoespaciada
                                      fontSize: isMobile ? 10 : 11,  // tamaño: 10px móvil, 11px otros
                                      color: AppTheme.mutedTeal,  // color verde azulado apagado del tema
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// ═══════════════════════════════════════════════════════
/// CLASE: _SocialCard
/// Widget interno para representar cada tarjeta de red social.
/// Maneja estado de hover y muestra visualmente si el enlace está activo o deshabilitado.
/// ═══════════════════════════════════════════════════════
class _SocialCard extends StatefulWidget {
  final _SocialLink link;  // enlace social con toda su información
  final Function(_SocialLink) onAction;  // función callback que se ejecuta al tocar la tarjeta
  final bool isMobile;  // bandera que indica si se renderiza en dispositivo móvil

  const _SocialCard({  // constructor constante que requiere todos los parámetros
    required this.link,  // parámetro obligatorio: datos del enlace social
    required this.onAction,  // parámetro obligatorio: función de acción
    required this.isMobile,  // parámetro obligatorio: indicador de dispositivo móvil
  });

  @override
  State<_SocialCard> createState() => _SocialCardState();  // crea el estado asociado a esta tarjeta
}

/// ═══════════════════════════════════════════════════════
/// CLASE: _SocialCardState
/// Estado interno de _SocialCard que maneja el efecto de hover y la apariencia visual.
/// ═══════════════════════════════════════════════════════
class _SocialCardState extends State<_SocialCard> {
  bool _isHovered = false;  // variable de estado que indica si el cursor está sobre la tarjeta

  /// ═══════════════════════════════════════════════════════
  /// MÉTODO: build
  /// Construye la tarjeta visual con efectos de hover, animaciones y estilos condicionales.
  /// ═══════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {  // método que retorna el widget visual de la tarjeta
    const Color neonCian = AppTheme.primaryCyan;  // color cian neón desde el tema
    final bool isEnabled = widget.link.isEnabled;  // verifica si el enlace está activo (URL no vacía)

    return MouseRegion(  // widget que detecta eventos del mouse (hover)
      onEnter: (_) => isEnabled ? setState(() => _isHovered = true) : null,  // al entrar cursor: activa hover si está habilitado
      onExit: (_) => isEnabled ? setState(() => _isHovered = false) : null,  // al salir cursor: desactiva hover si está habilitado
      cursor: isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,  // cursor: mano si activo, normal si no
      child: GestureDetector(  // widget que detecta gestos táctiles (tap, etc.)
        onTap: () => isEnabled ? widget.onAction(widget.link) : null,  // al tocar: ejecuta acción si está habilitado
        child: AnimatedContainer(  // contenedor que anima cambios de propiedades visualmente
          duration: const Duration(milliseconds: 250),  // duración de la animación: 250 milisegundos
          curve: Curves.easeOutCubic,  // curva de animación: desaceleración suave al final
          transform: (isEnabled && _isHovered)  // transformación condicional: solo si activo y con hover
              ? (Matrix4.identity()  // crea matriz de identidad (sin transformación base)
                  ..translate(0, -10)  // mueve 10px hacia arriba en eje Y
                  ..scale(1.05))  // escala al 105% del tamaño original
              : Matrix4.identity(),  // sin transformación si no hay hover
          decoration: BoxDecoration(  // decoración visual del contenedor
            color: (isEnabled && _isHovered)  // color condicional según estado
                ? const Color(0xFF1D3557)  // azul más claro si activo y con hover
                : const Color(0xFF14243D),  // azul oscuro por defecto
            border: Border.all(  // definición del borde
              color: (isEnabled && _isHovered)  // color del borde condicional
                  ? neonCian  // cian brillante si activo y con hover
                  : neonCian.withValues(alpha: 0.2),  // cian tenue (20%) por defecto
              width: 1.5,  // grosor del borde de 1.5px
            ),
            boxShadow: (isEnabled && _isHovered)  // sombras condicionales
                ? [  // lista de sombras si activo y con hover
                    BoxShadow(  // definición de sombra
                      color: neonCian.withValues(alpha: 0.2),  // color cian con 20% opacidad
                      blurRadius: 15,  // radio de desenfoque de 15px
                      offset: const Offset(0, 10),  // desplazamiento: 0 horizontal, 10 vertical (sombra inferior)
                    ),
                  ]
                : null,  // sin sombra si no hay hover
          ),
          child: Column(  // columna que organiza el contenido de la tarjeta verticalmente
            mainAxisAlignment: MainAxisAlignment.center,  // centra los hijos verticalmente
            children: [  // widgets hijos de la columna
              FaIcon(  // icono de FontAwesome
                widget.link.icon,  // icono definido en el enlace social
                color: isEnabled ? neonCian : neonCian.withValues(alpha: 0.2),  // color: brillante si activo, tenue si no
                size: widget.isMobile ? 24 : 28,  // tamaño: 24px móvil, 28px otros
              ),
              const SizedBox(height: 10),  // espacio de 10px tras el icono
              Text(  // texto con el label de la red social
                widget.link.label.toUpperCase(),  // convierte el label a mayúsculas
                textAlign: TextAlign.center,  // centra el texto
                style: GoogleFonts.pressStart2p(  // fuente retro Press Start 2P
                  fontSize: widget.isMobile ? 7.5 : 8.5,  // tamaño: 7.5px móvil, 8.5px otros
                  color: isEnabled ? neonCian : neonCian.withValues(alpha: 0.2),  // color condicional: brillante o tenue
                ),
              ),
              const SizedBox(height: 8),  // espacio de 8px tras el label
              Text(  // texto con subtítulo o mensaje "Próximamente"
                isEnabled ? widget.link.subtitle : 'Próximamente',  // muestra subtítulo si activo, "Próximamente" si no
                textAlign: TextAlign.center,  // centra el texto
                maxLines: 1,  // limita a una sola línea
                overflow: TextOverflow.ellipsis,  // agrega "..." si el texto excede el espacio
                style: GoogleFonts.shareTechMono(  // fuente monoespaciada Share Tech Mono
                  fontSize: widget.isMobile ? 11 : 12,  // tamaño: 11px móvil, 12px otros
                  color: isEnabled  // color condicional
                      ? Colors.grey.shade400  // gris claro si activo
                      : Colors.grey.shade700,  // gris oscuro si deshabilitado
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
