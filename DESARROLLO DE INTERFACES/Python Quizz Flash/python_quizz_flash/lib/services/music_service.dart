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

// ═══ IMPORTS: Dependencias de audio y Riverpod ═══

import 'package:audioplayers/audioplayers.dart';  // importa AudioPlayers para reproducir música de fondo
import 'package:riverpod_annotation/riverpod_annotation.dart';  // importa riverpod_annotation para generar providers
import 'package:shared_preferences/shared_preferences.dart';  // importa SharedPreferences para persistir preferencia de música

part 'music_service.g.dart';  // archivo generado por riverpod_annotation con el código del provider

/// ═══ CLASE: MusicController ═══
/// Notifier de Riverpod que maneja el estado de la música de fondo.
/// Persiste la preferencia del usuario (encendida/apagada) en SharedPreferences.
/// Usa una única instancia de AudioPlayer durante toda la vida de la app.
@Riverpod(keepAlive: true)  // anotación que genera el provider con keepAlive (no se destruye al dejar de escucharse)
class MusicController extends _$MusicController {  // extiende el generado _$MusicController
  static final AudioPlayer _player = AudioPlayer();  // instancia singleton del reproductor de audio (única para toda la app)
  bool _isPlaying = false;  // indica si la música se está reproduciendo actualmente

  @override  // sobrescribe el método build del notifier
  bool build() {  // retorna el estado inicial del controller
    _loadSettings();  // carga la configuración guardada del usuario de forma asíncrona
    return true;  // por defecto asume encendida hasta que SharedPreferences cargue
  }

  /// ═══ MÉTODO: _loadSettings ═══
  /// Carga la configuración guardada del usuario desde SharedPreferences.
  /// Si music_enabled=true reproduce la música, si no la detiene.
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();  // obtiene instancia de SharedPreferences
    final enabled = prefs.getBool('music_enabled') ?? true;  // lee preferencia de música o true por defecto
    state = enabled;  // actualiza el estado del provider con la preferencia cargada
    if (enabled) {  // si la música está habilitada
      playBackgroundMusic();  // inicia la reproducción de la música de fondo
    } else {  // si la música está deshabilitada
      stopMusic();  // detiene cualquier reproducción activa
    }
  }

  /// ═══ MÉTODO: toggleMusic ═══
  /// Cambia el estado de la música entre encendido y apagado.
  /// Persiste la preferencia del usuario en SharedPreferences.
  Future<void> toggleMusic(bool enabled) async {
    if (state == enabled) return;  // si ya está en el estado deseado, evita llamada redundante

    state = enabled;  // actualiza el estado del provider
    final prefs = await SharedPreferences.getInstance();  // obtiene instancia de SharedPreferences
    await prefs.setBool('music_enabled', enabled);  // guarda la preferencia del usuario

    if (enabled) {  // si el usuario activó la música
      await playBackgroundMusic();  // reproduce la música de fondo
    } else {  // si el usuario desactivó la música
      await stopMusic();  // detiene la reproducción
    }
  }

  /// ═══ MÉTODO: playBackgroundMusic ═══
  /// Reproduce la música de fondo en bucle con volumen al 40%.
  /// Error silencioso si falla (puede ocurrir en algunos navegadores web).
  Future<void> playBackgroundMusic() async {
    try {  // try-catch para manejar errores de reproducción
      if (!state || _isPlaying) return;  // si el estado es apagado o ya está reproduciendo, sale

      await _player.setReleaseMode(ReleaseMode.loop);  // configura el audio para que se repita en bucle infinito
      await _player.setVolume(0.4);  // establece el volumen al 40%
      await _player.play(  // reproduce el archivo de audio
        AssetSource('audio/music/akashworldwide-game-on-231800.mp3'),  // carga el archivo desde assets/audio/music/
      );
      _isPlaying = true;  // marca que la música se está reproduciendo
    } catch (e) {  // captura errores de reproducción silenciosamente
      // Error silencioso - la música puede fallar en algunos navegadores web
    }
  }

  /// ═══ MÉTODO: resumeIfBlocked ═══
  /// Intenta reanudar la música si está habilitada pero no se está reproduciendo.
  /// Soluciona el bloqueo de Autoplay en navegadores Web (Chrome requiere interacción del usuario).
  Future<void> resumeIfBlocked() async {
    if (state && !_isPlaying) {  // si la música está habilitada pero no se está reproduciendo
      await playBackgroundMusic();  // intenta iniciar la reproducción
    } else if (state) {  // si la música está habilitada y podría estar pausada
      await _player.resume();  // reanuda la reproducción (más seguro que play() en Web)
      _isPlaying = true;  // marca que la música se está reproduciendo
    }
  }

  /// ═══ MÉTODO: stopMusic ═══
  /// Detiene la reproducción de la música de fondo.
  /// Usa pause() en lugar de stop() para Web (más fiable para evitar leaks de audio).
  Future<void> stopMusic() async {
    await _player.pause();  // pausa el reproductor de audio
    _isPlaying = false;  // marca que la música ya no se está reproduciendo
  }
}
