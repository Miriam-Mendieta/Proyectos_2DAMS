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
import 'package:flutter/material.dart'; // Framework base de Flutter.
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Gestión de estado reactiva.
import 'package:google_fonts/google_fonts.dart'; // Fuentes retro.
import 'package:go_router/go_router.dart'; // Navegación.
import 'package:firebase_auth/firebase_auth.dart'; // Para acceder al usuario actual.
import 'package:cloud_firestore/cloud_firestore.dart'; // Para sincronizar con Firestore.
import '../theme/app_theme.dart'; // Sistema de diseño.
import '../widgets/app_header_buttons.dart'; // Cabecera.
import '../widgets/crt_overlay.dart'; // Efecto CRT.
import '../widgets/app_footer.dart'; // Pie de página.
import '../widgets/retro_button.dart'; // Botones retro.
import '../widgets/retro_container.dart'; // Contenedores retro.
import '../widgets/app_notifications.dart'; // Notificaciones estandarizadas.
import '../providers/auth_provider.dart'; // Auth.
import '../providers/settings_provider.dart'; // Configuraciones globales.
import '../providers/level_progress_provider.dart'; // Para resetear todo el progreso.
import '../providers/economia_provider.dart'; // Para resetear monedas

/// Pantalla de Configuración con rediseño avanzado y lógica de reinicio.
class ConfigScreen extends ConsumerWidget {
  const ConfigScreen({super.key});

  /// Diálogo de confirmación para reiniciar el juego a cero.
  void _showResetGameDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      barrierDismissible: false, // No se puede cerrar tocando fuera
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppTheme.darkBg,
        shape: const RoundedRectangleBorder(
          side: BorderSide(color: AppTheme.neonRed, width: 2),
        ),
        title: Text(
          "RESETEO DE DATOS",
          textAlign: TextAlign.center,
          style: GoogleFonts.pressStart2p(
            color: AppTheme.neonRed,
            fontSize: 14,
          ),
        ),
        content: Text(
          "¿DESEAS BORRAR TODO TU PROGRESO?\nESTO PONDRÁ TUS PUNTUACIONES Y LOGROS A CERO.",
          textAlign: TextAlign.center,
          style: GoogleFonts.shareTechMono(color: Colors.white, fontSize: 12),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: RetroButton(
                    text: "CANCELAR",
                    style: RetroButtonStyle.secondary,
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: RetroButton(
                    text: "CONFIRMAR",
                    style: RetroButtonStyle.danger,
                    onPressed: () {
                      // Primero cerramos el diálogo
                      Navigator.of(dialogContext).pop();
                      // Luego ejecutamos el reseteo y navegación
                      _performResetAndNavigate(context, ref);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Realiza el reseteo de datos y navega al menú principal
  /// ESTRATEGIA: Reset local + sync COMPLETO antes de navegar (con timeout)
  Future<void> _performResetAndNavigate(
    BuildContext context,
    WidgetRef ref,
  ) async {
    // Verificar que el usuario esté autenticado
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (context.mounted) {
        context.go('/login');
      }
      return;
    }

    try {
      // 1. RESET LOCAL INMEDIATO - El usuario ve el cambio al instante
      // Actualizar el provider de progreso localmente
      await ref.read(levelProgressProvider.notifier).resetAllProgressLocal();

      // Resetear el provider de economía (monedas) localmente
      final economia = ref.read(economiaProvider);
      await economia.reiniciar(monedasCheckpoint: 0);

      // 2. Sync CON BLOQUEO - Esperamos máximo 2 segundos para que Firestore se actualice
      await _syncResetToFirestoreWithTimeout(user.uid);

      // Pequeña pausa para asegurar que Firestore propagó los cambios
      await Future.delayed(const Duration(milliseconds: 500));

      // 3. Navegación - El usuario ya ve el reseteo en la UI
      if (context.mounted) {
        // Mostrar mensaje de éxito con notificación estandarizada
        AppNotifications.show(context, "PROGRESO RESETEADO CORRECTAMENTE");
        context.go('/main_menu');
      }
    } catch (e) {
      // Si hay error en el reset local, mostramos error
      if (context.mounted) {
        // Mostrar mensaje de error con notificación estandarizada
        AppNotifications.show(context, "ERROR AL RESETEAR", isError: true);
        context.go('/main_menu');
      }
    }
  }

  /// Sincroniza el reseteo con Firestore con timeout de 2 segundos
  /// Retorna cuando termina o cuando se agota el timeout
  Future<void> _syncResetToFirestoreWithTimeout(String uid) async {
    try {
      await _syncResetToFirestore(uid).timeout(
        const Duration(seconds: 2),
        onTimeout: () {},
      );
    } catch (e) {
      // Error silencioso - continuamos
    }
  }

  /// Sincroniza el reseteo con Firestore en segundo plano
  /// No bloquea la UI del usuario
  Future<void> _syncResetToFirestore(String uid) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (!userDoc.exists) {
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'username': 'Usuario',
          'username_search': 'usuario',
          'email': FirebaseAuth.instance.currentUser?.email ?? '',
          'createdAt': FieldValue.serverTimestamp(),
          'coins': 0,
          'pyCoins': 0,
          'totalEarned': 0,
          'totalSpent': 0,
          'level': 1,
          'basic_completed': false,
          'challenge_basic_completed': false,
          'intermediate_unlocked': false,
          'intermediate_completed': false,
          'challenge_intermediate_completed': false,
          'advanced_unlocked': false,
          'advanced_completed': false,
          'progress_basic': 0,
          'progress_intermediate': 0,
          'progress_advanced': 0,
          'total_errors': 0,
        });
      } else {
        // Usamos set() con merge para actualizar TODO de una vez
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'coins': 0,
          'pyCoins': 0,
          'totalEarned': 0,
          'totalSpent': 0,
          'basic_completed': false,
          'challenge_basic_completed': false,
          'intermediate_unlocked': false,
          'intermediate_completed': false,
          'challenge_intermediate_completed': false,
          'advanced_unlocked': false,
          'advanced_completed': false,
          'progress_basic': 0,
          'progress_intermediate': 0,
          'progress_advanced': 0,
          'total_errors': 0,
          // Mantenemos campos que no deben resetearse
          'username': userDoc.data()?['username'] ?? 'Usuario',
          'username_search': userDoc.data()?['username_search'] ?? 'usuario',
          'email': userDoc.data()?['email'] ?? '',
          'createdAt':
              userDoc.data()?['createdAt'] ?? FieldValue.serverTimestamp(),
          'level': userDoc.data()?['level'] ?? 1,
        }, SetOptions(merge: true));
      }
    } catch (e) {
      rethrow; // Relanzamos el error para que lo maneje _performResetAndNavigate
    }
  }

  /// Diálogo de confirmación para eliminar la cuenta.
  void _showDeleteAccountDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      barrierDismissible: false,  // No se puede cerrar tocando fuera
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppTheme.darkBg,
        shape: const RoundedRectangleBorder(
          side: BorderSide(color: AppTheme.neonRed, width: 2),
        ),
        title: Text(
          "¡¡ ALERTA CRÍTICA !!",
          textAlign: TextAlign.center,
          style: GoogleFonts.pressStart2p(
            color: AppTheme.neonRed,
            fontSize: 14,
          ),
        ),
        content: Text(
          "ESTA ACCIÓN ELIMINARÁ TU CUENTA DE FORMA PERMANENTE.\n\n"
          "• Se borrarán todos tus datos\n"
          "• Se perderán tus monedas y progreso\n"
          "• No se puede deshacer esta acción",
          textAlign: TextAlign.center,
          style: GoogleFonts.shareTechMono(color: Colors.white, fontSize: 12),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: RetroButton(
                    text: "CANCELAR",
                    style: RetroButtonStyle.secondary,
                    onPressed: () => Navigator.pop(dialogContext),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: RetroButton(
                    text: "ELIMINAR",
                    style: RetroButtonStyle.danger,
                    onPressed: () async {
                      // Ejecutamos la eliminación
                      await ref.read(authProvider.notifier).deleteAccount();
                      
                      // Verificamos el resultado
                      final authState = ref.read(authProvider);
                      
                      if (authState.status == AuthStatus.success) {
                        // Eliminación exitosa - mostramos mensaje y navegamos a login
                        if (dialogContext.mounted) {
                          Navigator.pop(dialogContext);  // Cerramos diálogo
                          
                          // Mostramos mensaje de éxito
                          AppNotifications.show(
                            context,
                            "CUENTA ELIMINADA CORRECTAMENTE",
                          );
                          
                          // Esperamos un momento para que se procese la eliminación
                          await Future.delayed(const Duration(milliseconds: 500));
                          
                          // Navegamos a login
                          if (context.mounted) {
                            context.go('/login');
                          }
                        }
                      } else {
                        // Hubo un error - mostramos mensaje
                        if (dialogContext.mounted) {
                          Navigator.pop(dialogContext);  // Cerramos diálogo
                          
                          String errorMsg = "ERROR AL ELIMINAR CUENTA";
                          if (authState.message.contains('REINICIA_SESION')) {
                            errorMsg = "DEBES INICIAR SESIÓN NUEVAMENTE PARA PODER ELIMINAR TU CUENTA.\n\n"
                                "Por seguridad, Firebase requiere que te autentiques recientemente antes de eliminar una cuenta.\n\n"
                                "Inicia sesión nuevamente y vuelve a intentar.";
                          }
                          
                          AppNotifications.show(
                            context,
                            errorMsg,
                            isError: true,
                          );
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    const Color neonCian = AppTheme.primaryCyan;
    const Color mainBorderColor = AppTheme.borderBlue;

    return CRTOverlay(
      child: Scaffold(
        backgroundColor: AppTheme.darkBg,
        body: LayoutBuilder(
          builder: (context, constraints) {
            final bool isMobile = constraints.maxWidth < 700;
            final double sidePadding = isMobile
                ? 20.0
                : constraints.maxWidth * 0.1;

            return SafeArea(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    padding: EdgeInsets.only(
                      left: sidePadding,
                      right: sidePadding,
                      top: 20,
                      bottom: 150,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AppHeaderButtons(),
                        const SizedBox(height: 30),

                        Text(
                          "CONFIGURACIÓN DEL JUEGO",
                          style: GoogleFonts.pressStart2p(
                            color: neonCian,
                            fontSize: isMobile ? 14 : 20,
                          ),
                        ),
                        const SizedBox(height: 30),

                        // --- MÓDULOS DE INTERFAZ ---
                        _buildSectionTitle("MÓDULOS DE INTERFAZ:"),
                        _buildConfigItem(
                          title: "MÚSICA DE FONDO",
                          subtitle: "Audio ambiental del sistema",
                          icon: Icons.music_note,
                          trailing: Switch(
                            value: settings.musicEnabled,
                            activeThumbColor: neonCian,
                            onChanged: (value) => ref
                                .read(appSettingsProvider.notifier)
                                .setMusicEnabled(value),
                          ),
                        ),

                        const SizedBox(height: 15),
                        _buildConfigItem(
                          title: "REINICIAR JUEGO",
                          subtitle: "Poner todo el progreso a cero",
                          icon: Icons.refresh,
                          trailing: RetroButton(
                            text: "RESET",
                            width: 80,
                            height: 35,
                            fontSize: 8,
                            style: RetroButtonStyle.danger,
                            onPressed: () => _showResetGameDialog(context, ref),
                          ),
                        ),

                        const SizedBox(height: 20),
                        _buildConfigItem(
                          title: "EFECTOS DE SONIDO",
                          subtitle: "Feedback sonoro de acciones",
                          icon: Icons.volume_up,
                          trailing: Switch(
                            value: settings.sfxEnabled,
                            activeThumbColor: neonCian,
                            onChanged: (value) => ref
                                .read(appSettingsProvider.notifier)
                                .setSfxEnabled(value),
                          ),
                        ),

                        const SizedBox(height: 30),

                        // --- CUENTA Y LEGAL REDISEÑADA ---
                        _buildSectionTitle("CUENTA Y LEGAL:"),
                        RetroContainer(
                          isWin95: false,
                          padding: const EdgeInsets.all(15),
                          borderColor: AppTheme.borderBlue.withAlpha(150),
                          backgroundColor: AppTheme.surfaceBlue.withAlpha(200),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildAccountAction(
                                "Valorar aplicación",
                                Icons.star,
                                AppTheme.primaryCyan,
                                () => context.push('/valorar'),
                              ),
                              _buildAccountAction(
                                "Términos y condiciones",
                                Icons.description,
                                Colors.white,
                                () => context.push('/terminos'),
                              ),
                              _buildAccountAction(
                                "Política de privacidad",
                                Icons.shield_outlined,
                                Colors.white,
                                () => context.push('/privacidad'),
                              ),
                              _buildAccountAction(
                                "Cerrar sesión",
                                Icons.logout,
                                AppTheme.primaryCyan,
                                () {
                                  ref.read(authProvider.notifier).logout();
                                  context.go('/login');
                                },
                              ),
                              _buildAccountAction(
                                "Eliminar cuenta",
                                Icons.delete_forever,
                                AppTheme.neonRed,
                                () => _showDeleteAccountDialog(context, ref),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 40),

                        // --- PANEL DE LOG ---
                        Container(
                          width: double.infinity,
                          child: RetroContainer(
                            isWin95: false,
                            borderColor: mainBorderColor.withAlpha(150),
                            backgroundColor: Colors.black,
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLogText(
                                    "> SISTEMA: Python_Quizz_Flash v1.0.0",
                                  ),
                                  _buildLogText(
                                    "> ESTADO: CONFIGURANDO PARÁMETROS ...",
                                  ),
                                  _buildLogText(
                                    "> FECHA: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                                  ),
                                  _buildLogText(
                                    "> USUARIO: ${FirebaseAuth.instance.currentUser?.email ?? 'INVITADO'}",
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),

                        // --- BOTONES DE ACCIÓN FINAL (LARGOS) ---
                        Center(
                          child: Wrap(
                            spacing: 20,
                            runSpacing: 20,
                            alignment: WrapAlignment.center,
                            children: [
                              SizedBox(
                                width:
                                    300, // Aumentado para que entre en una línea
                                child: RetroButton(
                                  text: "GUARDAR CONFIGURACIÓN",
                                  height: 55,
                                  fontSize: 10,
                                  textColor: Colors.black,
                                  style: RetroButtonStyle.primary,
                                  onPressed: () => context.pop(),
                                ),
                              ),
                              SizedBox(
                                width:
                                    300, // Aumentado para que entre en una línea
                                child: RetroButton(
                                  text: "VOLVER AL MENÚ PRINCIPAL",
                                  height: 55,
                                  fontSize: 10,
                                  style: RetroButtonStyle.secondary,
                                  onPressed: () => context.go('/main_menu'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: AppFooter(borderColor: mainBorderColor),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// Título de sección.
  Widget _buildSectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Text(
        text,
        style: GoogleFonts.pressStart2p(color: Colors.white, fontSize: 10),
      ),
    );
  }

  /// Item de configuración individual.
  Widget _buildConfigItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required Widget trailing,
  }) {
    return RetroContainer(
      isWin95: false,
      backgroundColor: AppTheme.surfaceBlue.withAlpha(200),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryCyan, size: 22),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white38, fontSize: 9),
                ),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }

  /// Acción de cuenta con botones oscuros, alineados a la izquierda y con luz perimetral.
  Widget _buildAccountAction(
    String text,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return StatefulBuilder(
      builder: (context, setState) {
        bool isHovered = false;
        return MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: RetroButton(
              text: text,
              icon: icon,
              width: double.infinity,
              height: 52,
              fontSize: 14,
              alignment: MainAxisAlignment.start, // Alineación a la izquierda
              fontFamily: 'IBMPlexMono', // Otro tipo de letra solicitado
              backgroundColor: isHovered
                  ? AppTheme.primaryCyan
                  : AppTheme.darkBg,
              textColor: isHovered ? Colors.black : color,
              // Brillo intenso arriba, abajo y a los costados solicitado.
              shadows: isHovered
                  ? [
                      BoxShadow(
                        color: color.withAlpha(150),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                      BoxShadow(
                        color: color.withAlpha(100),
                        blurRadius: 10,
                        spreadRadius: -2,
                      ),
                    ]
                  : null,
              onPressed: onTap,
            ),
          ),
        );
      },
    );
  }

  /// Texto de consola.
  Widget _buildLogText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: GoogleFonts.shareTechMono(
          color: const Color(0xFF4BA3C3),
          fontSize: 11,
          letterSpacing: 1.1,
        ),
      ),
    );
  }
}
