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

// ═══ IMPORTS: Dependencias de autenticación con Firebase y Riverpod ═══

import 'package:firebase_auth/firebase_auth.dart';  // importa Firebase Auth para gestión de usuarios
import 'package:cloud_firestore/cloud_firestore.dart';  // importa Firestore para base de datos en la nube
import 'package:riverpod_annotation/riverpod_annotation.dart';  // importa riverpod_annotation para generar providers automáticamente
import 'package:freezed_annotation/freezed_annotation.dart';  // importa freezed para generar clases inmutables
import 'economia_provider.dart';  // importa EconomiaProvider para resetear datos al eliminar cuenta

part 'auth_provider.freezed.dart';  // archivo generado por freezed con la implementación inmutable
part 'auth_provider.g.dart';  // archivo generado por json_serializable

/// ═══ CONSTANTES: Límites de seguridad para login ═══

/// Límite de intentos fallidos antes de bloquear temporalmente la cuenta.
const int _maxFailedAttempts = 5;  // número máximo de intentos fallidos permitidos (5)

/// Duración del bloqueo tras múltiples intentos fallidos (en minutos).
const int _lockoutDurationMinutes = 15;  // minutos que dura el bloqueo (15 min)

/// Mapa para tracking de intentos fallidos por identificador (email/username).
/// En producción, esto debería estar en el servidor (Firebase Cloud Functions).
final Map<String, _FailedAttemptInfo> _failedAttempts = {};  // almacena info de intentos fallidos por cada usuario

/// ═══ CLASE: _FailedAttemptInfo ═══
/// Información interna sobre intentos fallidos de login de un usuario.
/// Almacena el conteo de intentos y hasta cuándo está bloqueado.
class _FailedAttemptInfo {
  final int count;  // cantidad de intentos fallidos acumulados
  final DateTime? lockoutUntil;  // fecha/hora hasta la que el usuario está bloqueado (null si no hay bloqueo)

  /// Constructor que crea la info con conteo y límite opcional.
  _FailedAttemptInfo({required this.count, this.lockoutUntil});  // requiere el conteo, lockoutUntil es opcional

  /// Incrementa el contador de intentos fallidos.
  _FailedAttemptInfo increment() {  // retorna una nueva instancia con count + 1
    return _FailedAttemptInfo(count: count + 1, lockoutUntil: lockoutUntil);  // mantiene el mismo lockoutUntil
  }

  /// Establece un nuevo límite de bloqueo temporal.
  _FailedAttemptInfo withLockout(DateTime until) {  // retorna una nueva instancia con bloqueo hasta la fecha dada
    return _FailedAttemptInfo(count: count, lockoutUntil: until);  // mantiene el conteo actual
  }

  /// Resetea el contador y elimina el bloqueo.
  _FailedAttemptInfo reset() {  // retorna una nueva instancia limpia (0 intentos, sin bloqueo)
    return _FailedAttemptInfo(count: 0, lockoutUntil: null);  // reinicia todo a valores iniciales
  }
}

/// ═══ ENUM: AuthStatus ═══
/// Estados posibles del proceso de autenticación.
/// - initial: estado inicial sin acción
/// - loading: proceso de login/registro en curso
/// - authenticated: usuario logueado exitosamente
/// - error: ocurrió un error en la operación
/// - success: operación completada sin autenticar (registro exitoso)
enum AuthStatus { initial, loading, authenticated, error, success }

/// ═══ CLASE: AuthState ═══
/// Estado inmutable del proceso de autenticación.
/// Generado con @freezed para inmutabilidad automática.
/// Contiene el estado actual y un mensaje descriptivo.
@freezed  // anotación que indica a freezed que genere la clase inmutable
abstract class AuthState with _$AuthState {  // clase abstracta que mezcla el mixin generado
  const factory AuthState({  // factory constructor que define la estructura del estado
    @Default(AuthStatus.initial) AuthStatus status,  // estado actual, initial por defecto
    @Default('SISTEMA_EN_ESPERA...') String message,  // mensaje descriptivo, texto por defecto
  }) = _AuthState;  // nombre de la clase concreta generada por freezed
}

/// ═══ CLASE: Auth ═══
/// Notifier de Riverpod que gestiona toda la lógica de autenticación.
/// Soporta login con email o nombre de usuario, registro, logout y eliminación de cuenta.
/// Incluye rate limiting local para prevenir ataques de fuerza bruta.
@riverpod  // anotación que genera el provider automáticamente
class Auth extends _$Auth {  // extiende el generado _$Auth para gestión de estado
  @override  // sobrescribe el método build del notifier
  AuthState build() => const AuthState();  // retorna el estado inicial por defecto

  /// ═══ MÉTODO: resetState ═══
  /// Reinicia el estado de autenticación a valores iniciales.
  /// Se usa al hacer logout o limpiar errores.
  void resetState() {
    state = const AuthState();  // restaura el estado inicial (status: initial, mensaje por defecto)
  }

  /// ═══ MÉTODO: login ═══
  /// Inicia sesión con identificador (email o nombre de usuario) y contraseña.
  /// Soporta rate limiting: bloquea la cuenta tras 5 intentos fallidos por 15 min.
  /// Si el identificador no es un email, busca el nick en Firestore para obtener el email real.
  Future<void> login({
    required String identifier,  // email o nombre de usuario del usuario
    required String password,  // contraseña del usuario
  }) async {
    final input = identifier.trim();  // elimina espacios al inicio y final del identificador
    final pass = password.trim();  // elimina espacios al inicio y final de la contraseña

    if (input.isEmpty || pass.isEmpty) {  // verifica que ambos campos tengan contenido
      state = state.copyWith(  // actualiza el estado con error de campos vacíos
        status: AuthStatus.error,  // establece estado como error
        message: 'RELLENA_TODOS_LOS_CAMPOS',  // mensaje indicando que faltan datos
      );
      return;  // sale sin intentar login
    }

    /// Verificar si el identificador está bloqueado por rate limiting.
    final lockoutInfo = _failedAttempts[input.toLowerCase()];  // busca info de intentos fallidos (case insensitive)
    if (lockoutInfo != null && lockoutInfo.lockoutUntil != null) {  // si existe info y hay bloqueo activo
      if (lockoutInfo.lockoutUntil!.isAfter(DateTime.now())) {  // si el bloqueo aún no ha expirado
        final minutesRemaining = lockoutInfo.lockoutUntil!.difference(DateTime.now()).inMinutes + 1;  // calcula minutos restantes
        state = state.copyWith(  // actualiza estado con error de cuenta bloqueada
          status: AuthStatus.error,  // establece estado como error
          message: 'CUENTA_BLOQUEADA_INTENTA_EN_$minutesRemaining${minutesRemaining == 1 ? 'MIN' : 'MINS'}',  // mensaje con tiempo restante
        );
        return;  // sale sin intentar login
      } else {  // el bloqueo ya expiró
        _failedAttempts[input.toLowerCase()] = lockoutInfo.reset();  // resetea los intentos fallidos
      }
    }

    state = state.copyWith(  // actualiza estado a cargando
      status: AuthStatus.loading,  // establece estado como loading
      message: 'VERIFICANDO_IDENTIDAD...',  // mensaje de verificación en curso
    );

    try {  // bloque try-catch para manejar errores de autenticación
      final auth = FirebaseAuth.instance;  // obtiene la instancia de Firebase Auth
      final db = FirebaseFirestore.instance;  // obtiene la instancia de Firestore
      String emailToUse = input;  // email a usar para login (puede ser el input directo o el encontrado por nick)

      /// Si no es un email, buscamos el nick en la base de datos.
      if (!input.contains('@')) {  // verifica si el input NO contiene @ (no es email)
        state = state.copyWith(  // actualiza mensaje de búsqueda de nick
          message: 'BUSCANDO_NICK: ${input.toLowerCase()}',  // muestra el nick que se está buscando
        );

        try {  // try-catch interno para errores de consulta a Firestore
          final userQuery = await db  // realiza consulta a Firestore
              .collection('users')  // en la colección 'users'
              .where('username_search', isEqualTo: input.toLowerCase())  // busca por username_search (minúsculas)
              .limit(1)  // limita a 1 resultado
              .get();  // ejecuta la consulta

          if (userQuery.docs.isEmpty) {  // si no se encontró ningún usuario con ese nick
            _incrementFailedAttempt(input);  // incrementa contador de intentos fallidos
            state = state.copyWith(  // actualiza estado con error de nick no encontrado
              status: AuthStatus.error,  // establece estado como error
              message: 'EL_NICK_NO_EXISTE',  // mensaje de nick inexistente
            );
            return;  // sale sin intentar login
          }

          emailToUse = userQuery.docs.first.get('email');  // extrae el email real asociado a ese nick
        } catch (dbError) {  // captura errores de consulta a Firestore (generalmente reglas de seguridad)
          state = state.copyWith(  // actualiza estado con error de permisos
            status: AuthStatus.error,  // establece estado como error
            message: 'ERROR_PERMISOS: ACTIVA_REGLAS_EN_CONSOLA',  // mensaje de reglas de seguridad
          );
          return;  // sale sin intentar login
        }
      }

      /// Intentamos el login oficial con el email (sea directo o encontrado por nick).
      state = state.copyWith(message: 'CONECTANDO_CON_NUBE...');  // actualiza mensaje de conexión
      await auth.signInWithEmailAndPassword(email: emailToUse, password: pass);  // intenta login con Firebase Auth

      /// Login exitoso - resetear contador de intentos fallidos.
      _failedAttempts.remove(input.toLowerCase());  // elimina registro de intentos fallidos para este usuario

      state = state.copyWith(  // actualiza estado a autenticado exitosamente
        status: AuthStatus.authenticated,  // establece estado como authenticated
        message: 'ACCESO_TOTAL_CONCEDIDO',  // mensaje de acceso concedido
      );
    } on FirebaseAuthException catch (e) {  // captura errores específicos de Firebase Auth
      _incrementFailedAttempt(input);  // incrementa contador de intentos fallidos

      String errorMsg = 'ERROR: ';  // inicia string de mensaje de error
      if (e.code == 'wrong-password') {  // si el error es contraseña incorrecta
        errorMsg += 'CONTRASEÑA_ERRÓNEA';  // mensaje de contraseña errónea
      } else if (e.code == 'user-not-found') {  // si el error es usuario no encontrado
        errorMsg += 'CUENTA_NO_ENCONTRADA';  // mensaje de cuenta no encontrada
      } else if (e.code == 'too-many-requests') {  // si el error es demasiados intentos
        errorMsg += 'DEMASIADOS_INTENTOS_INTENTA_MAS_TARDE';  // mensaje de rate limit
      } else {  // cualquier otro error de Firebase Auth
        errorMsg += e.code.replaceAll('-', '_').toUpperCase();  // convierte el código a MAYÚSCULAS_CON_GUION_BAJO
      }

      state = state.copyWith(status: AuthStatus.error, message: errorMsg);  // actualiza estado con error
    } catch (e) {  // captura cualquier otro error no esperado
      _incrementFailedAttempt(input);  // incrementa contador de intentos fallidos
      state = state.copyWith(  // actualiza estado con error crítico
        status: AuthStatus.error,  // establece estado como error
        message: 'FALLO_CRÍTICO',  // mensaje genérico de fallo
      );
    }
  }

  /// ═══ MÉTODO: _incrementFailedAttempt ═══
  /// Incrementa el contador de intentos fallidos y aplica bloqueo si se alcanza el límite.
  void _incrementFailedAttempt(String identifier) {  // recibe el identificador del intento fallido
    final key = identifier.toLowerCase();  // normaliza a minúsculas para consistencia
    final currentInfo = _failedAttempts[key] ?? _FailedAttemptInfo(count: 0);  // obtiene info actual o crea nueva con count 0
    final newCount = currentInfo.count + 1;  // calcula el nuevo conteo incrementado

    if (newCount >= _maxFailedAttempts) {  // si se alcanzó o superó el límite de intentos
      final lockoutUntil = DateTime.now().add(Duration(minutes: _lockoutDurationMinutes));  // calcula fecha de fin de bloqueo
      _failedAttempts[key] = currentInfo.increment().withLockout(lockoutUntil);  // aplica bloqueo temporal
    } else {  // aún no se alcanzó el límite
      _failedAttempts[key] = currentInfo.increment();  // solo incrementa el contador
    }
  }

  /// ═══ MÉTODO: register ═══
  /// Registra un nuevo usuario con nombre de usuario, email y contraseña.
  /// Verifica disponibilidad del nick antes de crear la cuenta.
  /// Crea el usuario en Firebase Auth y guarda datos adicionales en Firestore.
  Future<void> register({
    required String username,  // nombre de usuario/nick elegido
    required String email,  // email del usuario
    required String password,  // contraseña (mínimo 6 caracteres por Firebase)
  }) async {
    final nick = username.trim();  // elimina espacios del nombre de usuario
    final mail = email.trim();  // elimina espacios del email
    final pass = password.trim();  // elimina espacios de la contraseña

    state = state.copyWith(  // actualiza estado a cargando
      status: AuthStatus.loading,  // establece estado como loading
      message: 'COMPROBANDO_NICK...',  // mensaje de verificación de disponibilidad
    );

    try {  // bloque try-catch para manejar errores de registro
      final auth = FirebaseAuth.instance;  // obtiene instancia de Firebase Auth
      final db = FirebaseFirestore.instance;  // obtiene instancia de Firestore

      /// 1. Verificamos disponibilidad del nick en Firestore.
      final existingUser = await db  // consulta Firestore para verificar si el nick ya existe
          .collection('users')  // en la colección 'users'
          .where('username_search', isEqualTo: nick.toLowerCase())  // busca por username_search en minúsculas
          .limit(1)  // limita a 1 resultado
          .get();  // ejecuta la consulta

      if (existingUser.docs.isNotEmpty) {  // si ya existe un usuario con ese nick
        state = state.copyWith(  // actualiza estado con error de nick en uso
          status: AuthStatus.error,  // establece estado como error
          message: 'ESTE_NICK_YA_ESTA_EN_USO',  // mensaje de nick no disponible
        );
        return;  // sale sin registrar
      }

      /// 2. Registro en Firebase Auth.
      state = state.copyWith(message: 'CREANDO_CREDENCIALES...');  // actualiza mensaje de creación
      UserCredential credential = await auth.createUserWithEmailAndPassword(  // crea usuario en Firebase Auth
        email: mail,  // email proporcionado
        password: pass,  // contraseña proporcionada
      );

      /// 3. Guardado en base de datos Firestore.
      await db.collection('users').doc(credential.user!.uid).set({  // crea documento en Firestore con el UID del usuario
        'username': nick,  // nombre de usuario original (preserva mayúsculas)
        'username_search': nick.toLowerCase(),  // versión en minúsculas para búsquedas eficientes
        'email': mail,  // email del usuario
        'createdAt': FieldValue.serverTimestamp(),  // marca de tiempo del servidor
        'coins': 0,  // monedas iniciales: 0
        'level': 1,  // nivel inicial: 1
      });

      await auth.signOut();  // cierra sesión tras registro exitoso (obliga a hacer login)
      state = state.copyWith(  // actualiza estado a éxito
        status: AuthStatus.success,  // establece estado como success
        message: 'CUENTA_CREADA_SISTEMA_LISTO',  // mensaje de cuenta creada
      );
    } on FirebaseAuthException catch (e) {  // captura errores específicos de Firebase Auth
      String errorMsg = 'FALLO: ';  // inicia string de mensaje de error
      if (e.code == 'email-already-in-use') {  // si el email ya está registrado
        errorMsg += 'EMAIL_YA_REGISTRADO';  // mensaje de email duplicado
      } else {  // cualquier otro error
        errorMsg += e.code.replaceAll('-', '_').toUpperCase();  // convierte el código a MAYÚSCULAS
      }
      state = state.copyWith(status: AuthStatus.error, message: errorMsg);  // actualiza estado con error
    } catch (e) {  // captura cualquier otro error no esperado
      state = state.copyWith(  // actualiza estado con error de base de datos
        status: AuthStatus.error,  // establece estado como error
        message: 'FALLO_DE_BASE_DE_DATOS: $e',  // mensaje con detalle del error
      );
    }
  }

  /// ═══ MÉTODO: logout ═══
  /// Cierra la sesión del usuario actual y resetea el estado.
  /// También resetea el EconomiaProvider para permitir re-inicialización con el nuevo usuario.
  Future<void> logout() async {
    try {  // try-catch para evitar que errores de signOut detengan la app
      // Resetea el EconomiaProvider para permitir re-inicialización con nuevo usuario
      final economia = EconomiaProvider();  // obtiene instancia del provider
      await economia.reset();  // resetea datos y limpia _initialized para permitir nueva inicialización
      
      await FirebaseAuth.instance.signOut();  // cierra sesión en Firebase Auth
    } catch (_) {}  // ignora errores silenciosamente
    resetState();  // resetea el estado del provider a valores iniciales
  }

  /// ═══ MÉTODO: deleteAccount ═══
  /// Elimina permanentemente la cuenta del usuario (Firestore + Firebase Auth).
  /// Requiere re-autenticación reciente por seguridad.
  Future<void> deleteAccount() async {
    state = state.copyWith(  // actualiza estado a cargando
      status: AuthStatus.loading,  // establece estado como loading
      message: 'ELIMINANDO_DATOS_DEL_SISTEMA...',  // mensaje de eliminación en curso
    );
    try {  // bloque try-catch para manejar errores de eliminación
      final user = FirebaseAuth.instance.currentUser;  // obtiene el usuario actualmente logueado
      if (user == null) {  // si no hay usuario
        state = state.copyWith(
          status: AuthStatus.error,
          message: 'ERROR: NO_HAY_USUARIO_ACTIVO',
        );
        return;
      }

      final uid = user.uid;  // obtiene el UID del usuario

      // Resetea el EconomiaProvider para permitir reinicialización con nuevo usuario
      final economia = EconomiaProvider();  // obtiene instancia del provider
      await economia.reset();  // resetea todos los datos y limpia SharedPreferences

      // 1. PRIMERO eliminamos el documento de Firestore (mientras aún estamos autenticados)
      // Si eliminamos Auth primero, Firestore denegará el acceso por falta de autenticación
      try {
        await FirebaseFirestore.instance.collection('users').doc(uid).delete();  // elimina documento de Firestore
      } catch (firestoreError) {
        // Si Firestore falla por permisos, continuamos igual (Auth se eliminará de todos modos)
      }

      // 2. LUEGO eliminamos el usuario de Firebase Auth
      try {
        await user.delete();  // elimina usuario de Firebase Auth
      } on FirebaseAuthException catch (e) {
        if (e.code == 'requires-recent-login') {
          state = state.copyWith(
            status: AuthStatus.error,
            message: 'ERROR: REINICIA_SESION_PARA_BORRAR',
          );
        } else {
          state = state.copyWith(
            status: AuthStatus.error,
            message: 'ERROR_AL_BORRAR_AUTH',
          );
        }
        return;  // Sale temprano si Auth falla
      }

      // 3. Cerramos sesión explícitamente para limpiar el estado de auth
      await FirebaseAuth.instance.signOut();  // cierra sesión para limpiar estado

      // 4. Actualizamos estado (con try-catch por si el ref ya fue disposed tras signOut)
      try {
        state = state.copyWith(  // actualiza estado a éxito
          status: AuthStatus.success,  // establece estado como success
          message: 'CUENTA_ELIMINADA_CON_EXITO',  // mensaje de eliminación exitosa
        );
      } catch (e) {
        // Si el ref ya fue disposed, el usuario ya no verá este estado de todos modos
      }
    } catch (e) {  // captura cualquier otro error no esperado
      try {
        state = state.copyWith(  // actualiza estado con error crítico
          status: AuthStatus.error,  // establece estado como error
          message: 'FALLO_CRITICO_AL_BORRAR',  // mensaje con detalle del error
        );
      } catch (_) {
        // Si el ref ya fue disposed, ignoramos el error
      }
    }
  }
}
