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
import 'package:flutter_riverpod/flutter_riverpod.dart';  // importa Riverpod para gestión de estado reactivo
import 'package:go_router/go_router.dart';  // importa el sistema de enrutamiento declarativo go_router
import 'package:google_fonts/google_fonts.dart';  // importa Google Fonts para usar tipografías personalizadas
import '../theme/app_theme.dart';  // importa las definiciones de colores y estilos globales de la app
import '../widgets/neon_text_field.dart';  // importa el campo de texto con efecto neón brillante
import '../widgets/cyber_button.dart';  // importa el botón con estilo cyberpunk
import '../providers/auth_provider.dart';  // importa el provider de autenticación para login

/// ═══════════════════════════════════════════════════════
/// CLASE: LoginScreen
/// Pantalla de inicio de sesión del usuario.
/// Muestra un formulario con email/usuario y contraseña,
/// con estética de terminal retro y borde cian neón.
/// Usa ConsumerStatefulWidget para reaccionar al estado
/// de autenticación gestionado por Riverpod.
/// ═══════════════════════════════════════════════════════
class LoginScreen extends ConsumerStatefulWidget {  // widget con estado que puede leer providers de Riverpod
  const LoginScreen({super.key});  // constructor constante que pasa la key al padre

  @override  // sobrescribe el método createState del StatefulWidget
  ConsumerState<LoginScreen> createState() => _LoginScreenState();  // crea el estado asociado a esta pantalla
}

/// ═══════════════════════════════════════════════════════
/// CLASE: _LoginScreenState
/// Estado privado de LoginScreen.
/// Maneja los controladores de texto, la animación de
/// parpadeo del cursor y la lógica de login.
/// Usa SingleTickerProviderStateMixin para permitir
/// una animación de un solo ticker (el cursor).
/// ═══════════════════════════════════════════════════════
class _LoginScreenState extends ConsumerState<LoginScreen>  // estado que tiene acceso al ref de Riverpod
    with SingleTickerProviderStateMixin {  // mixin que proporciona un TickerProvider para una animación
  final _formKey = GlobalKey<FormState>();  // clave global para acceder al estado del formulario y validarlo
  final TextEditingController _emailController = TextEditingController();  // controlador del campo de email/usuario
  final TextEditingController _passwordController = TextEditingController();  // controlador del campo de contraseña
  late AnimationController _blinkController;  // controlador de animación para el parpadeo del cursor (se inicializa en initState)

  @override  // sobrescribe el método de inicialización del estado
  void initState() {  // se ejecuta una vez cuando el estado se crea
    super.initState();  // llama al initState del padre para mantener el ciclo de vida
    WidgetsBinding.instance.addPostFrameCallback((_) {  // ejecuta código después del primer frame renderizado
      ref.read(authProvider.notifier).resetState();  // reinicia el estado de autenticación al entrar en la pantalla
    });

    _blinkController = AnimationController(  // crea el controlador de animación para el parpadeo
      vsync: this,  // usa este estado como vsync para sincronizar con la tasa de refresco de la pantalla
      duration: const Duration(milliseconds: 500),  // duración de medio segundo por ciclo de animación
    )..repeat(reverse: true);  // repite la animación infinitamente invirtiendo la dirección en cada ciclo
  }

  @override  // sobrescribe el método de limpieza del estado
  void dispose() {  // se ejecuta cuando el estado se destruye
    _emailController.dispose();  // libera los recursos del controlador de email
    _passwordController.dispose();  // libera los recursos del controlador de contraseña
    _blinkController.dispose();  // libera los recursos del controlador de animación
    super.dispose();  // llama al dispose del padre para mantener el ciclo de vida
  }

  /// ═══════════════════════════════════════════════════════
  /// MÉTODO: _handleLogin
  /// Valida el formulario e intenta iniciar sesión con las
  /// credenciales ingresadas usando el auth provider.
  /// ═══════════════════════════════════════════════════════
  void _handleLogin() async {  // maneja el evento de presionar el botón de login (asíncrono)
    if (_formKey.currentState!.validate()) {  // valida todos los campos del formulario
      await ref  // usa await para esperar la operación asíncrona del provider
          .read(authProvider.notifier)  // obtiene el notifier del provider de autenticación
          .login(  // llama al método de login con las credenciales
            identifier: _emailController.text.trim(),  // pasa el email/usuario recortando espacios
            password: _passwordController.text.trim(),  // pasa la contraseña recortando espacios
          );
    }
  }

  @override  // sobrescribe el método build para construir la interfaz visual
  Widget build(BuildContext context) {  // construye la pantalla de login
    final authState = ref.watch(authProvider);  // observa el estado actual de autenticación de forma reactiva
    const Color cian = Color(0xFF00FFFF);  // define el color cian neón constante para bordes y textos
    const Color cardBg = Color(0xFF152A3E);  // define el color de fondo de la tarjeta de login

    ref.listen(authProvider, (previous, next) {  // escucha cambios en el estado de autenticación
      if (next.status == AuthStatus.authenticated) {  // si el usuario se autenticó exitosamente
        context.go('/onboarding');  // navega a la pantalla de onboarding reemplazando la ruta actual
      }
    });

    return Scaffold(  // widget raíz que proporciona la estructura básica de la pantalla
      backgroundColor: AppTheme.darkBg,  // establece el color de fondo oscuro definido en el tema
      body: Center(  // centra el contenido horizontal y verticalmente en la pantalla
        child: SingleChildScrollView(  // contenedor con scroll vertical para contenido que excede la pantalla
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),  // márgenes internos de 20 horizontal y 40 vertical
          child: Container(  // contenedor principal con restricciones y decoración
            constraints: const BoxConstraints(maxWidth: 400),  // limita el ancho máximo a 400 píxeles
            padding: const EdgeInsets.all(24),  // aplica un margen interno de 24 píxeles en todos los lados
            decoration: BoxDecoration(  // decoración visual del contenedor
              color: cardBg,  // usa el color de fondo definido anteriormente
              border: Border.all(color: cian, width: 2.0),  // borde cian de 2 píxeles alrededor del contenedor
            ),
            child: Form(  // formulario que agrupa los campos de entrada con validación
              key: _formKey,  // asigna la clave global para poder validar el formulario
              child: Column(  // dispone los elementos del formulario en columna vertical
                mainAxisSize: MainAxisSize.min,  // la columna ocupa el mínimo espacio necesario
                crossAxisAlignment: CrossAxisAlignment.stretch,  // estira los hijos al ancho completo
                children: [  // lista de widgets del formulario en orden
                  Center(  // centra el título horizontalmente
                    child: Text(  // texto del título de la pantalla
                      'INICIAR SESIÓN',  // texto que se muestra
                      style: GoogleFonts.pressStart2p(  // aplica la fuente pixelada Press Start 2P
                        color: cian,  // color cian para el texto del título
                        fontSize: 18,  // tamaño de fuente de 18 píxeles
                        fontWeight: FontWeight.bold,  // peso de fuente en negrita
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),  // espacio vertical de 24 píxeles debajo del título
                  Container(  // contenedor decorativo estilo terminal con fondo negro
                    padding: const EdgeInsets.all(12),  // margen interno de 12 píxeles
                    decoration: BoxDecoration(  // decoración del contenedor tipo terminal
                      color: Colors.black,  // fondo negro como una terminal real
                      border: Border.all(color: cian, width: 1.5),  // borde cian de 1.5 píxeles
                    ),
                    child: Column(  // dispone los elementos de la terminal en columna
                      crossAxisAlignment: CrossAxisAlignment.start,  // alinea los textos a la izquierda
                      children: [  // lista de elementos dentro de la terminal
                        Row(  // fila que contiene el prompt y el cursor parpadeante
                          children: [  // widgets de la fila
                            Text(  // texto del prompt de la terminal
                              '> ACCESO AL SISTEMA',  // texto estilo comando de terminal
                              style: GoogleFonts.sourceCodePro(  // aplica la fuente monoespaciada Source Code Pro
                                color: cian,  // color cian para el texto
                                fontSize: 10,  // tamaño de fuente pequeño
                                fontWeight: FontWeight.bold,  // peso de fuente en negrita
                              ),
                            ),
                            const SizedBox(width: 4),  // espacio horizontal de 4 píxeles entre texto y cursor
                            FadeTransition(  // transición de opacidad para el efecto de parpadeo
                              opacity: _blinkController,  // vincula la opacidad al controlador de animación
                              child: Container(  // rectángulo que simula el cursor de la terminal
                                width: 8,  // ancho de 8 píxeles
                                height: 12,  // alto de 12 píxeles
                                color: cian,  // color cian del cursor
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),  // espacio vertical de 4 píxeles entre filas de la terminal
                        Text(  // texto con la versión del sistema
                          'SISTEMA: Python_Quizz_Flash v1.0.0',  // muestra el nombre y versión de la app
                          style: GoogleFonts.sourceCodePro(  // aplica la fuente monoespaciada
                            color: cian,  // color cian para el texto
                            fontSize: 8,  // tamaño de fuente aún más pequeño
                            fontWeight: FontWeight.bold,  // peso de fuente en negrita
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),  // espacio vertical de 20 píxeles debajo de la terminal
                  NeonTextField(  // campo de texto con efecto neón para el email/usuario
                    label: 'Email o Nombre de Usuario:',  // etiqueta descriptiva del campo
                    hintText: 'tu@email.com o tu_nick',  // texto placeholder que indica el formato esperado
                    controller: _emailController,  // conecta el controlador del campo de email
                  ),
                  const SizedBox(height: 8),  // espacio vertical de 8 píxeles debajo del campo
                  Text(  // texto aclaratorio sobre las opciones de login
                    'Puedes usar tu email O tu nombre de usuario',  // mensaje informativo al usuario
                    style: GoogleFonts.sourceCodePro(  // aplica la fuente monoespaciada
                      color: Colors.white54,  // color blanco semitransparente (54% opacidad)
                      fontSize: 8,  // tamaño de fuente pequeño
                    ),
                    textAlign: TextAlign.center,  // centra el texto horizontalmente
                  ),
                  const SizedBox(height: 4),  // espacio vertical de 4 píxeles
                  NeonTextField(  // campo de texto con efecto neón para la contraseña
                    label: 'Contraseña:',  // etiqueta descriptiva del campo
                    hintText: '********',  // placeholder con asteriscos indicando campo seguro
                    controller: _passwordController,  // conecta el controlador del campo de contraseña
                    isPassword: true,  // activa el modo contraseña para ocultar los caracteres
                  ),
                  const SizedBox(height: 24),  // espacio vertical de 24 píxeles debajo de los campos
                  CyberButton(  // botón estilizado cyberpunk para ejecutar el login
                    text: 'INICIAR SESIÓN',  // texto que muestra el botón
                    isLoading: authState.status == AuthStatus.loading,  // muestra estado de carga si está logueando
                    onPressed: authState.status == AuthStatus.loading  // deshabilita el botón mientras carga
                        ? null  // null deshabilita el botón durante la carga
                        : _handleLogin,  // ejecuta el handler de login cuando no está cargando
                  ),
                  const SizedBox(height: 12),  // espacio vertical de 12 píxeles debajo del botón
                  Center(  // centra el enlace de registro horizontalmente
                    child: GestureDetector(  // widget detecta toques para navegar al registro
                      onTap: () => context.go('/register'),  // navega a la pantalla de registro al tocar
                      child: Text(  // texto del enlace de registro
                        '> ¿No tienes cuenta? Regístrate aquí',  // texto estilo prompt de terminal
                        style: GoogleFonts.sourceCodePro(  // aplica la fuente monoespaciada
                          color: AppTheme.primaryCyan,  // color cyan del tema
                          fontSize: 10,  // tamaño de fuente de 10 píxeles
                          fontWeight: FontWeight.bold,  // peso de fuente en negrita
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),  // espacio vertical de 20 píxeles
                  Container(height: 1.5, color: const Color(0xFF7B89A8)),  // línea separadora horizontal gris-azulada
                  const SizedBox(height: 8),  // espacio vertical de 8 píxeles debajo de la línea
                  Center(  // centra el texto de estado horizontalmente
                    child: Text(  // muestra el mensaje de estado de la autenticación
                      'ESTADO : ${authState.message}'.toUpperCase(),  // convierte el mensaje a mayúsculas
                      style: GoogleFonts.sourceCodePro(  // aplica la fuente monoespaciada
                        color: authState.status == AuthStatus.error  // selecciona color según el estado
                            ? Colors.redAccent  // rojo si hay error
                            : Colors.grey.shade400,  // gris si es otro estado
                        fontSize: 9,  // tamaño de fuente de 9 píxeles
                        fontWeight: FontWeight.bold,  // peso de fuente en negrita
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),  // espacio vertical de 16 píxeles
                  Center(  // centra el enlace de volver horizontalmente
                    child: GestureDetector(  // widget detecta toques para navegar al inicio
                      onTap: () => context.go('/inicio'),  // navega a la pantalla de inicio al tocar
                      child: Text(  // texto del enlace de volver
                        '<< VOLVER AL INICIO',  // texto con flechas estilo retro
                        style: GoogleFonts.sourceCodePro(  // aplica la fuente monoespaciada
                          color: cian.withValues(alpha: 0.7),  // cian semitransparente al 70% de opacidad
                          fontSize: 10,  // tamaño de fuente de 10 píxeles
                          fontWeight: FontWeight.bold,  // peso de fuente en negrita
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
