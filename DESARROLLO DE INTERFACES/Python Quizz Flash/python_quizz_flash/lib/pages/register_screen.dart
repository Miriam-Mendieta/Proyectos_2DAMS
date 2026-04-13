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
import '../providers/auth_provider.dart';  // importa el provider de autenticación para registro

/// ═══════════════════════════════════════════════════════
/// CLASE: RegisterScreen
/// Pantalla de registro de nuevo usuario.
/// Muestra un formulario con validaciones estrictas para
/// usuario, email, contraseña y confirmación.
/// Usa ConsumerStatefulWidget para reaccionar al estado
/// de autenticación gestionado por Riverpod.
/// ═══════════════════════════════════════════════════════
class RegisterScreen extends ConsumerStatefulWidget {  // widget con estado que puede leer providers de Riverpod
  const RegisterScreen({super.key});  // constructor constante que pasa la key al padre

  @override  // sobrescribe el método createState del StatefulWidget
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();  // crea el estado asociado a esta pantalla
}

/// ═══════════════════════════════════════════════════════
/// CLASE: _RegisterScreenState
/// Estado privado de RegisterScreen.
/// Maneja los controladores de texto, la animación de
/// parpadeo del cursor, las validaciones de formulario
/// y la lógica de registro.
/// Usa SingleTickerProviderStateMixin para la animación
/// del cursor parpadeante.
/// ═══════════════════════════════════════════════════════
class _RegisterScreenState extends ConsumerState<RegisterScreen>  // estado que tiene acceso al ref de Riverpod
    with SingleTickerProviderStateMixin {  // mixin que proporciona un TickerProvider para una animación
  final _formKey = GlobalKey<FormState>();  // clave global para acceder al estado del formulario y validarlo
  final TextEditingController _userController = TextEditingController();  // controlador del campo de usuario/nick
  final TextEditingController _emailController = TextEditingController();  // controlador del campo de email
  final TextEditingController _passwordController = TextEditingController();  // controlador del campo de contraseña
  final TextEditingController _confirmPasswordController = TextEditingController();  // controlador del campo de confirmación
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
    _userController.dispose();  // libera los recursos del controlador de usuario
    _emailController.dispose();  // libera los recursos del controlador de email
    _passwordController.dispose();  // libera los recursos del controlador de contraseña
    _confirmPasswordController.dispose();  // libera los recursos del controlador de confirmación
    _blinkController.dispose();  // libera los recursos del controlador de animación
    super.dispose();  // llama al dispose del padre para mantener el ciclo de vida
  }

  /// ═══════════════════════════════════════════════════════
  /// MÉTODO: _validateUsername
  /// Valida que el nombre de usuario no esté vacío y tenga
  /// al menos 4 caracteres.
  /// Retorna un mensaje de error o null si es válido.
  /// ═══════════════════════════════════════════════════════
  String? _validateUsername(String? value) {  // validador del campo de nombre de usuario
    if (value == null || value.isEmpty) return 'OBLIGATORIO';  // retorna error si el campo está vacío
    if (value.length < 4) return 'MIN 4 CAR.';  // retorna error si tiene menos de 4 caracteres
    return null;  // retorna null indicando que la validación pasó
  }

  /// ═══════════════════════════════════════════════════════
  /// MÉTODO: _validateEmail
  /// Valida que el email tenga un formato correcto usando
  /// una expresión regular.
  /// Retorna un mensaje de error o null si es válido.
  /// ═══════════════════════════════════════════════════════
  String? _validateEmail(String? value) {  // validador del campo de email
    if (value == null || value.isEmpty) return 'OBLIGATORIO';  // retorna error si el campo está vacío
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');  // crea la expresión regular para validar formato email
    if (!emailRegExp.hasMatch(value)) return 'CORREO INVÁLIDO';  // retorna error si no coincide con el patrón
    return null;  // retorna null indicando que la validación pasó
  }

  /// ═══════════════════════════════════════════════════════
  /// MÉTODO: _validatePassword
  /// Valida que la contraseña tenga al menos 12 caracteres,
  /// incluya mayúsculas, minúsculas, números, símbolos,
  /// no sea una contraseña común ni tenga secuencias simples.
  /// Retorna un mensaje de error o null si es válida.
  /// ═══════════════════════════════════════════════════════
  String? _validatePassword(String? value) {  // validador del campo de contraseña
    if (value == null || value.isEmpty) return 'OBLIGATORIO';  // retorna error si el campo está vacío
    if (value.length < 12) return 'MIN 12 CAR.';  // retorna error si tiene menos de 12 caracteres

    final hasUpper = RegExp(r'[A-Z]').hasMatch(value);  // verifica si tiene al menos una letra mayúscula
    final hasLower = RegExp(r'[a-z]').hasMatch(value);  // verifica si tiene al menos una letra minúscula
    final hasNumber = RegExp(r'[0-9]').hasMatch(value);  // verifica si tiene al menos un número
    final hasSpecial = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value);  // verifica si tiene al menos un símbolo especial

    if (!hasUpper) return 'DEBE_TENER_MAYUSCULAS';  // retorna error si falta una mayúscula
    if (!hasLower) return 'DEBE_TENER_MINUSCULAS';  // retorna error si falta una minúscula
    if (!hasNumber) return 'DEBE_TENER_NUMEROS';  // retorna error si falta un número
    if (!hasSpecial) return 'DEBE_TENER_SIMBOLOS';  // retorna error si falta un símbolo especial

    final commonPasswords = [  // lista de contraseñas comunes que deben rechazarse
      'password1234',  // contraseña común número 1
      'qwerty123456',  // contraseña común número 2
      '123456789012',  // contraseña común número 3
      'contraseña123',  // contraseña común número 4
      'admin123456789',  // contraseña común número 5
      'welcome123456',  // contraseña común número 6
    ];

    if (commonPasswords.contains(value.toLowerCase())) {  // verifica si la contraseña (en minúsculas) está en la lista
      return 'CONTRASEÑA_MUY_COMUN_USA_OTRA';  // retorna error si es una contraseña demasiado común
    }

    final sequentialPatterns = [  // lista de patrones secuenciales que deben rechazarse
      RegExp(r'(012|123|234|345|456|567|678|789|890)'),  // patrones de secuencias numéricas
      RegExp(  // patrones de secuencias alfabéticas
        r'(abc|bcd|cde|def|efg|fgh|ghi|hij|ijk|jkl|klm|lmn|mno|nop|opq|pqr|qrs|rst|stu|tuv|uvw|vwx|wxy|xyz)',  // secuencias de 3 letras consecutivas
      ),
    ];

    for (final pattern in sequentialPatterns) {  // itera sobre cada patrón secuencial
      if (pattern.hasMatch(value.toLowerCase())) {  // verifica si la contraseña (en minúsculas) contiene la secuencia
        return 'NO_USAR_SECUENCIAS_SIMPLES';  // retorna error si coincide con un patrón secuencial
      }
    }

    return null;  // retorna null indicando que todas las validaciones de contraseña pasaron
  }

  /// ═══════════════════════════════════════════════════════
  /// MÉTODO: _validateConfirmPassword
  /// Valida que la confirmación de contraseña coincida
  /// exactamente con la contraseña ingresada.
  /// Retorna un mensaje de error o null si coincide.
  /// ═══════════════════════════════════════════════════════
  String? _validateConfirmPassword(String? value) {  // validador del campo de confirmación de contraseña
    if (value == null || value.isEmpty) return 'OBLIGATORIO';  // retorna error si el campo está vacío
    if (value != _passwordController.text.trim()) return 'NO_COINCIDE_CON_PASSWORD';  // retorna error si no coincide con la contraseña
    return null;  // retorna null indicando que la validación pasó
  }

  /// ═══════════════════════════════════════════════════════
  /// MÉTODO: _handleRegister
  /// Valida el formulario e intenta registrar al usuario
  /// con los datos ingresados usando el auth provider.
  /// ═══════════════════════════════════════════════════════
  void _handleRegister() async {  // maneja el evento de presionar el botón de registro (asíncrono)
    if (_formKey.currentState!.validate()) {  // valida todos los campos del formulario
      await ref  // usa await para esperar la operación asíncrona del provider
          .read(authProvider.notifier)  // obtiene el notifier del provider de autenticación
          .register(  // llama al método de registro con los datos del formulario
            username: _userController.text.trim(),  // pasa el nombre de usuario recortando espacios
            email: _emailController.text.trim(),  // pasa el email recortando espacios
            password: _passwordController.text.trim(),  // pasa la contraseña recortando espacios
          );
    }
  }

  @override  // sobrescribe el método build para construir la interfaz visual
  Widget build(BuildContext context) {  // construye la pantalla de registro
    final authState = ref.watch(authProvider);  // observa el estado actual de autenticación de forma reactiva
    const Color cian = Color(0xFF00FFFF);  // define el color cian neón constante para bordes y textos
    const Color cardBg = Color(0xFF152A3E);  // define el color de fondo de la tarjeta de registro

    ref.listen(authProvider, (previous, next) {  // escucha cambios en el estado de autenticación
      if (next.status == AuthStatus.success) {  // si el registro fue exitoso
        Future.delayed(const Duration(seconds: 3), () {  // espera 3 segundos antes de navegar
          if (context.mounted) context.go('/login');  // navega al login si el contexto aún está montado
        });
      }
    });

    return Scaffold(  // widget raíz que proporciona la estructura básica de la pantalla
      backgroundColor: AppTheme.darkBg,  // establece el color de fondo oscuro definido en el tema
      body: Center(  // centra el contenido horizontal y verticalmente en la pantalla
        child: Padding(  // aplica márgenes externos simétricos
          padding: const EdgeInsets.symmetric(horizontal: 16.0),  // margen horizontal de 16 píxeles a cada lado
          child: Container(  // contenedor principal con restricciones y decoración
            constraints: const BoxConstraints(  // limita las dimensiones del contenedor
              maxWidth: 380,  // ancho máximo de 380 píxeles
              maxHeight: 680,  // alto máximo de 680 píxeles
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),  // margen interno de 20 píxeles horizontal y vertical
            decoration: BoxDecoration(  // decoración visual del contenedor
              color: cardBg,  // usa el color de fondo definido anteriormente
              border: Border.all(color: cian, width: 2.0),  // borde cian de 2 píxeles alrededor del contenedor
            ),
            child: Form(  // formulario que agrupa los campos de entrada con validación
              key: _formKey,  // asigna la clave global para poder validar el formulario
              child: Column(  // dispone los elementos del formulario en columna vertical
                mainAxisSize: MainAxisSize.min,  // la columna ocupa el mínimo espacio necesario
                children: [  // lista de widgets del formulario en orden
                  Text(  // texto del título de la pantalla
                    'CREAR CUENTA',  // texto que se muestra
                    style: GoogleFonts.pressStart2p(color: cian, fontSize: 16),  // fuente pixelada cian de 16 píxeles
                  ),

                  const SizedBox(height: 15),  // espacio vertical de 15 píxeles debajo del título

                  Container(  // contenedor decorativo estilo terminal con fondo negro
                    padding: const EdgeInsets.all(8),  // margen interno de 8 píxeles
                    decoration: BoxDecoration(  // decoración del contenedor tipo terminal
                      color: Colors.black,  // fondo negro como una terminal real
                      border: Border.all(color: cian, width: 1),  // borde cian de 1 píxel
                    ),
                    child: Column(  // dispone los elementos de la terminal en columna
                      crossAxisAlignment: CrossAxisAlignment.start,  // alinea los textos a la izquierda
                      children: [  // lista de elementos dentro de la terminal
                        Row(  // fila que contiene el prompt y el cursor parpadeante
                          children: [  // widgets de la fila
                            Text(  // texto del prompt de la terminal
                              '> REGISTRO_NUEVO_USUARIO',  // texto estilo comando de terminal
                              style: GoogleFonts.sourceCodePro(  // aplica la fuente monoespaciada Source Code Pro
                                color: cian,  // color cian para el texto
                                fontSize: 9,  // tamaño de fuente pequeño
                                fontWeight: FontWeight.bold,  // peso de fuente en negrita
                              ),
                            ),
                            const SizedBox(width: 4),  // espacio horizontal de 4 píxeles entre texto y cursor
                            FadeTransition(  // transición de opacidad para el efecto de parpadeo
                              opacity: _blinkController,  // vincula la opacidad al controlador de animación
                              child: Container(  // rectángulo que simula el cursor de la terminal
                                width: 6,  // ancho de 6 píxeles
                                height: 10,  // alto de 10 píxeles
                                color: cian,  // color cian del cursor
                              ),
                            ),
                          ],
                        ),
                        Text(  // texto con la versión del sistema
                          'Sistema: Python_Quizz_Flash v1.0',  // muestra el nombre y versión de la app
                          style: GoogleFonts.sourceCodePro(  // aplica la fuente monoespaciada
                            color: cian,  // color cian para el texto
                            fontSize: 7,  // tamaño de fuente muy pequeño
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),  // espacio vertical de 20 píxeles debajo de la terminal

                  NeonTextField(  // campo de texto con efecto neón para el usuario
                    label: 'Usuario:',  // etiqueta descriptiva del campo
                    hintText: 'Tu nick (4+ car.)',  // texto placeholder indicando el requisito mínimo
                    controller: _userController,  // conecta el controlador del campo de usuario
                    validator: _validateUsername,  // asigna la función validadora de nombre de usuario
                  ),
                  const SizedBox(height: 10),  // espacio vertical de 10 píxeles entre campos
                  NeonTextField(  // campo de texto con efecto neón para el email
                    label: 'Email:',  // etiqueta descriptiva del campo
                    hintText: 'tu@email.com',  // texto placeholder indicando el formato esperado
                    controller: _emailController,  // conecta el controlador del campo de email
                    validator: _validateEmail,  // asigna la función validadora de email
                  ),
                  const SizedBox(height: 10),  // espacio vertical de 10 píxeles entre campos
                  NeonTextField(  // campo de texto con efecto neón para la contraseña
                    label: 'Password:',  // etiqueta descriptiva del campo
                    hintText: '12+ car. (Mayús, Núm, Sím)',  // placeholder indicando los requisitos
                    controller: _passwordController,  // conecta el controlador del campo de contraseña
                    isPassword: true,  // activa el modo contraseña para ocultar los caracteres
                    validator: _validatePassword,  // asigna la función validadora de contraseña
                  ),
                  const SizedBox(height: 10),  // espacio vertical de 10 píxeles entre campos
                  NeonTextField(  // campo de texto con efecto neón para confirmar contraseña
                    label: 'Confirmar Password:',  // etiqueta descriptiva del campo
                    hintText: 'Repite tu contraseña',  // texto placeholder indicando la acción requerida
                    controller: _confirmPasswordController,  // conecta el controlador del campo de confirmación
                    isPassword: true,  // activa el modo contraseña para ocultar los caracteres
                    validator: _validateConfirmPassword,  // asigna la función validadora de confirmación
                  ),

                  const SizedBox(height: 25),  // espacio vertical de 25 píxeles debajo de los campos

                  if (authState.status == AuthStatus.loading)  // condicional que verifica si está en estado de carga
                    const SizedBox(  // widget de tamaño fijo que contiene el indicador de carga
                      height: 40,  // altura de 40 píxeles para el spinner
                      child: Center(  // centra el indicador horizontalmente
                        child: CircularProgressIndicator(  // spinner circular de carga
                          color: cian,  // color cian del spinner
                          strokeWidth: 2,  // grosor del trazo de 2 píxeles
                        ),
                      ),
                    )
                  else  // si no está cargando, muestra el botón de registro
                    CyberButton(  // botón estilizado cyberpunk para ejecutar el registro
                      text: authState.status == AuthStatus.success  // texto condicional según el estado
                          ? 'SISTEMA LISTO'  // muestra "SISTEMA LISTO" cuando el registro fue exitoso
                          : 'REGISTRAR',  // muestra "REGISTRAR" en estado normal
                      onPressed: authState.status == AuthStatus.success  // deshabilita el botón si fue exitoso
                          ? null  // null deshabilita el botón cuando el registro fue exitoso
                          : _handleRegister,  // ejecuta el handler de registro en estado normal
                    ),

                  const SizedBox(height: 12),  // espacio vertical de 12 píxeles debajo del botón

                  GestureDetector(  // widget detecta toques para navegar al login
                    onTap: () => context.go('/login'),  // navega a la pantalla de login al tocar
                    child: Text(  // texto del enlace para ir al login
                      '< Ya tengo cuenta',  // texto con flecha estilo retro
                      style: GoogleFonts.sourceCodePro(  // aplica la fuente monoespaciada
                        color: cian,  // color cian para el texto
                        fontSize: 11,  // tamaño de fuente de 11 píxeles
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),  // espacio vertical de 15 píxeles

                  Container(  // contenedor que actúa como línea separadora
                    width: double.infinity,  // ocupa todo el ancho disponible
                    height: 1,  // altura de 1 píxel
                    color: Colors.grey.withValues(alpha: 0.2),  // color gris semitransparente al 20%
                  ),

                  const SizedBox(height: 10),  // espacio vertical de 10 píxeles debajo de la línea

                  Center(  // centra el texto de estado horizontalmente
                    child: Text(  // muestra el mensaje de estado del registro
                      authState.message.toUpperCase(),  // convierte el mensaje a mayúsculas
                      textAlign: TextAlign.center,  // centra el texto horizontalmente
                      style: GoogleFonts.sourceCodePro(  // aplica la fuente monoespaciada
                        color: authState.status == AuthStatus.success  // selecciona color según el estado
                            ? AppTheme.neonGreen  // verde neón si el registro fue exitoso
                            : (authState.status == AuthStatus.error  // verifica si hay error
                                  ? Colors.red  // rojo si hay error
                                  : Colors.grey),  // gris para otros estados
                        fontSize: 9,  // tamaño de fuente de 9 píxeles
                        fontWeight: FontWeight.bold,  // peso de fuente en negrita
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
