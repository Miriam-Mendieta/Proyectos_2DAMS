# ==========================================
# PROGUARD RULES - Python Quizz Flash
# ==========================================
# Mantener clases necesarias para Flutter y Firebase
# Ofuscar el resto del código de la aplicación

# ------------------------------------------
# Flutter - Mantener clases del framework
# ------------------------------------------
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Mantener clases de embedding de Flutter
-keep class io.flutter.embedding.** { *; }

# ------------------------------------------
# Firebase - Mantener clases necesarias
# ------------------------------------------
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# Firestore
-keep class com.google.firebase.firestore.** { *; }

# Firebase Auth
-keep class com.google.firebase.auth.** { *; }

# ------------------------------------------
# Riverpod - Mantener generación de código
# ------------------------------------------
-keep class * extends * { *; }

# ------------------------------------------
# Freezed - Mantener código generado
# ------------------------------------------
-keep class * implements java.io.Serializable { *; }

# ------------------------------------------
# Kotlin - Mantener clases estándar
# ------------------------------------------
-keep class kotlin.** { *; }
-keep class kotlin.Metadata { *; }
-dontwarn kotlin.**
-keepclassmembers class **$WhenMappings {
    <fields>;
}
-keepclassmembers class kotlin.Metadata {
    public <methods>;
}

# ------------------------------------------
# SharedPreferences (flutter_secure_storage)
# ------------------------------------------
-keep class androidx.security.crypto.** { *; }

# ------------------------------------------
# HTTP y networking
# ------------------------------------------
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }
-dontwarn okhttp3.**
-dontwarn okio.**

# ------------------------------------------
# Google APIs
# ------------------------------------------
-keep class com.google.api.** { *; }
-keep class com.google.gson.** { *; }

# ------------------------------------------
# Mantener clases de la aplicación
# ------------------------------------------
# Mantener modelos y providers generados
-keep class com.example.python_quizz_flash.** { *; }

# ------------------------------------------
# Ofuscación - Diccionario personalizado
# ------------------------------------------
# Usar diccionario personalizado para mayor ofuscación
# -obfuscationdictionary words.txt
# -classobfuscationdictionary words.txt

# ------------------------------------------
# Optimizaciones
# ------------------------------------------
# Optimizar para tamaño de APK
-optimizations !code/simplification/arithmetic,!code/simplification/cast,!field/*,!class/merging/*
-optimizationpasses 5

# Permitir sobreescribir clases
-allowaccessmodification

# No advertir sobre clases faltantes
-dontnote
-dontwarn

# Mantener atributos SourceFile y LineNumber
-keepattributes SourceFile,LineNumberTable

# Mantener nombres de métodos nativos
-keepclasseswithmembernames class * {
    native <methods>;
}

# Mantener constructores de excepciones
-keepclassmembers,allowshrinking,allowobfuscation class * extends java.lang.Exception {
    *;
}
