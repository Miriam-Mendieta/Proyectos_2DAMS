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

// ═══ IMPORTS: Dependencias de configuración y almacenamiento seguro ═══

import 'package:freezed_annotation/freezed_annotation.dart';  // importa freezed para generar clases inmutables
import 'package:riverpod_annotation/riverpod_annotation.dart';  // importa riverpod_annotation para generar providers
import 'package:shared_preferences/shared_preferences.dart';  // importa SharedPreferences para persistencia simple
import 'package:flutter_secure_storage/flutter_secure_storage.dart';  // importa almacenamiento cifrado para configuraciones sensibles
import '../services/music_service.dart';  // importa el servicio de música para toggle desde configuración

part 'settings_provider.freezed.dart';  // archivo generado por freezed con implementación inmutable
part 'settings_provider.g.dart';  // archivo generado por json_serializable

/// ═══ CLASE: AppSettings ═══
/// Modelo inmutable de datos para las configuraciones de la aplicación.
/// Generado con @freezed. Almacena preferencias de audio, vibración,
/// notificaciones e idioma.
@freezed  // anotación que indica a freezed que genere la clase inmutable
sealed class AppSettings with _$AppSettings {  // clase sealed que mezcla el mixin generado
  const factory AppSettings({  // factory constructor que define la estructura de configuraciones
    @Default(true) bool musicEnabled,  // música de fondo activa, true por defecto
    @Default(true) bool sfxEnabled,  // efectos de sonido activos, true por defecto
    @Default(true) bool vibrationEnabled,  // vibración activa, true por defecto
    @Default(true) bool notificationsEnabled,  // alertas/notificaciones activas, true por defecto
    @Default('es') String language,  // idioma de la app, español por defecto
  }) = _AppSettings;  // nombre de la clase concreta generada por freezed
}

/// ═══ CLASE: SecureStorageService ═══
/// Servicio de almacenamiento seguro para configuraciones sensibles.
/// Usa flutter_secure_storage con cifrado en Android (SharedPreferences cifrados)
/// y Keychain en iOS. Incluye fallback a SharedPreferences si falla.
class SecureStorageService {
  /// Instancia singleton interna de FlutterSecureStorage con opciones de plataforma.
  static final _storage = FlutterSecureStorage(  // crea instancia de almacenamiento seguro
    aOptions: AndroidOptions(  // opciones específicas para Android
      encryptedSharedPreferences: true,  // usa SharedPreferences cifrados en Android
      preferencesKeyPrefix: 'enc_',  // prefijo para las claves cifradas
    ),
    iOptions: IOSOptions(  // opciones específicas para iOS
      accessibility: KeychainAccessibility.first_unlock_this_device,  // accesible tras primer desbloqueo del dispositivo
    ),
  );

  /// ═══ MÉTODO: writeBool ═══
  /// Guarda un valor booleano de forma cifrada.
  /// Si falla el almacenamiento seguro, hace fallback a SharedPreferences normal.
  Future<void> writeBool(String key, bool value) async {  // recibe clave y valor booleano
    try {  // intenta escribir en almacenamiento seguro
      await _storage.write(key: key, value: value.toString());  // escribe el booleano como string
    } catch (e) {  // si falla el almacenamiento seguro
      final prefs = await SharedPreferences.getInstance();  // obtiene SharedPreferences normal
      await prefs.setBool(key, value);  // guarda como fallback sin cifrar
    }
  }

  /// ═══ MÉTODO: readBool ═══
  /// Lee un valor booleano de forma cifrada.
  /// Si falla el almacenamiento seguro, hace fallback a SharedPreferences normal.
  Future<bool> readBool(String key, {bool defaultValue = false}) async {  // recibe clave y valor por defecto opcional
    try {  // intenta leer desde almacenamiento seguro
      final value = await _storage.read(key: key);  // lee el valor cifrado
      if (value == null) return defaultValue;  // si no existe, retorna valor por defecto
      return value.toLowerCase() == 'true';  // convierte string a booleano (case insensitive)
    } catch (e) {  // si falla el almacenamiento seguro
      final prefs = await SharedPreferences.getInstance();  // obtiene SharedPreferences normal
      return prefs.getBool(key) ?? defaultValue;  // lee como fallback o retorna default
    }
  }

  /// ═══ MÉTODO: writeString ═══
  /// Guarda un string de forma cifrada. Error silencioso si falla.
  Future<void> writeString(String key, String value) async {  // recibe clave y valor string
    try {  // intenta escribir en almacenamiento seguro
      await _storage.write(key: key, value: value);  // escribe el string cifrado
    } catch (e) {  // si falla, ignora el error silenciosamente
    }
  }

  /// ═══ MÉTODO: readString ═══
  /// Lee un string de forma cifrada. Retorna null si falla o no existe.
  Future<String?> readString(String key) async {  // recibe clave a leer
    try {  // intenta leer desde almacenamiento seguro
      return await _storage.read(key: key);  // retorna el string cifrado o null
    } catch (e) {  // si falla, retorna null silenciosamente
      return null;
    }
  }

  /// ═══ MÉTODO: delete ═══
  /// Elimina un valor almacenado. Error silencioso si falla.
  Future<void> delete(String key) async {  // recibe clave a eliminar
    try {  // intenta eliminar del almacenamiento seguro
      await _storage.delete(key: key);  // elimina el valor asociado a la clave
    } catch (e) {  // si falla, ignora el error silenciosamente
    }
  }

  /// ═══ MÉTODO: deleteAll ═══
  /// Elimina todos los valores almacenados. Error silencioso si falla.
  Future<void> deleteAll() async {  // sin parámetros, elimina todo
    try {  // intenta eliminar todo del almacenamiento seguro
      await _storage.deleteAll();  // borra todas las claves almacenadas
    } catch (e) {  // si falla, ignora el error silenciosamente
    }
  }
}

/// Instancia global singleton del servicio de almacenamiento seguro.
final _secureStorage = SecureStorageService();  // única instancia accesible internamente

/// ═══ CLASE: AppSettingsNotifier ═══
/// Notifier de Riverpod que gestiona el estado y la lógica de la configuración.
/// Carga configuraciones desde almacenamiento seguro al inicializarse
/// y proporciona setters para cada preferencia.
@riverpod  // anotación que genera el provider automáticamente
class AppSettingsNotifier extends _$AppSettingsNotifier {  // extiende el generado _$AppSettingsNotifier
  @override  // sobrescribe el método build del notifier
  AppSettings build() {  // retorna la configuración inicial
    Future.microtask(_loadFromPrefs);  // programa carga asíncrona tras la inicialización
    return const AppSettings();  // retorna configuración por defecto inmediatamente
  }

  /// ═══ MÉTODO: _loadFromPrefs ═══
  /// Carga todas las configuraciones desde el almacenamiento seguro.
  /// Se ejecuta asíncronamente tras la inicialización del provider.
  Future<void> _loadFromPrefs() async {
    /// Lee cada configuración con su valor por defecto.
    final musicEnabled = await _secureStorage.readBool('music_enabled', defaultValue: true);  // lee música (default: true)
    final sfxEnabled = await _secureStorage.readBool('sfx_enabled', defaultValue: true);  // lee SFX (default: true)
    final vibrationEnabled = await _secureStorage.readBool('vibration_enabled', defaultValue: true);  // lee vibración (default: true)
    final notificationsEnabled = await _secureStorage.readBool('notifications_enabled', defaultValue: true);  // lee notificaciones (default: true)
    final language = await _secureStorage.readString('language') ?? 'es';  // lee idioma (default: español)

    state = AppSettings(  // actualiza el estado con las configuraciones cargadas
      musicEnabled: musicEnabled,  // establece música desde almacenamiento
      sfxEnabled: sfxEnabled,  // establece SFX desde almacenamiento
      vibrationEnabled: vibrationEnabled,  // establece vibración desde almacenamiento
      notificationsEnabled: notificationsEnabled,  // establece notificaciones desde almacenamiento
      language: language,  // establece idioma desde almacenamiento
    );
  }

  /// ═══ MÉTODO: setMusicEnabled ═══
  /// Activa o desactiva la música de fondo y persiste el cambio.
  Future<void> setMusicEnabled(bool enabled) async {
    state = state.copyWith(musicEnabled: enabled);  // actualiza estado inmediatamente
    await _secureStorage.writeBool('music_enabled', enabled);  // persiste en almacenamiento seguro
    ref.read(musicControllerProvider.notifier).toggleMusic(enabled);  // activa/desactiva música en el servicio
  }

  /// ═══ MÉTODO: setSfxEnabled ═══
  /// Activa o desactiva los efectos de sonido y persiste el cambio.
  Future<void> setSfxEnabled(bool enabled) async {
    state = state.copyWith(sfxEnabled: enabled);  // actualiza estado inmediatamente
    await _secureStorage.writeBool('sfx_enabled', enabled);  // persiste en almacenamiento seguro
  }

  /// ═══ MÉTODO: setVibrationEnabled ═══
  /// Activa o desactiva la vibración y persiste el cambio.
  Future<void> setVibrationEnabled(bool enabled) async {
    state = state.copyWith(vibrationEnabled: enabled);  // actualiza estado inmediatamente
    await _secureStorage.writeBool('vibration_enabled', enabled);  // persiste en almacenamiento seguro
  }

  /// ═══ MÉTODO: setNotificationsEnabled ═══
  /// Activa o desactiva las notificaciones y persiste el cambio.
  Future<void> setNotificationsEnabled(bool enabled) async {
    state = state.copyWith(notificationsEnabled: enabled);  // actualiza estado inmediatamente
    await _secureStorage.writeBool('notifications_enabled', enabled);  // persiste en almacenamiento seguro
  }

  /// ═══ MÉTODO: setLanguage ═══
  /// Cambia el idioma de la aplicación y persiste el cambio.
  Future<void> setLanguage(String languageCode) async {
    state = state.copyWith(language: languageCode);  // actualiza estado inmediatamente
    await _secureStorage.writeString('language', languageCode);  // persiste en almacenamiento seguro
  }

  /// ═══ MÉTODO: resetAllSettings ═══
  /// Resetea todas las configuraciones a valores por defecto.
  /// Elimina todos los datos almacenados y restaura el estado inicial.
  Future<void> resetAllSettings() async {
    await _secureStorage.deleteAll();  // elimina todas las configuraciones almacenadas
    state = const AppSettings();  // restaura estado a valores por defecto
  }
}
