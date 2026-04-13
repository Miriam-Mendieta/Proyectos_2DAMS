# 📚 Glosario de Términos - Python Quizz Flash

**Propósito:** Definir términos técnicos y de dominio utilizados en el proyecto para facilitar la comprensión del código y la documentación.

---

## 🔤 Glosario Completo

### A

**Achievement (Logro)**
Reconocimiento visual y numérico otorgado al usuario tras cumplir hitos específicos (ej. completar su primer quiz, superar un desafío).

**AI Content (Contenido IA)**
Información dinámica generada por modelos de lenguaje (LLM) que incluye explicaciones, ejercicios adicionales y mini-cursos personalizados según el tema y nivel del usuario.

**AiGeminiService**
Clase de infraestructura encargada de gestionar la comunicación asíncrona entre la aplicación Flutter y las APIs de IA (Gemini y Groq como fallback). Implementa estrategia de failover automático.

**App Check**
Servicio de seguridad de Firebase que garantiza que solo las instancias autorizadas de la aplicación puedan acceder a los recursos del backend, protegiendo contra uso abusivo.

**AppSettings**
Modelo de datos que almacena las preferencias locales del usuario, como el volumen de la música, efectos de sonido y configuración del tema visual.

**Assets JSON**
Archivos de datos estáticos almacenados localmente en la aplicación (`assets/data/exercises_pool.json`) que contienen el pool principal de ejercicios para permitir el funcionamiento offline.

**AsyncNotifier**
Tipo de provider en Riverpod que gestiona estado asíncrono con carga inicial. Permite operaciones como cargar datos desde Firestore antes de que la UI los requiera.

**AOT (Ahead-of-Time)**
Compilación previa antes de la ejecución. Flutter usa AOT para generar código nativo rápido en producción.

### B

**BLoC (Business Logic Component)**
Patrón de gestión de estado que separa la lógica de negocio de la UI. Alternativa a Riverpod, no utilizada en este proyecto pero mencionada en la documentación.

**Build Flavor**
Configuraciones específicas de compilación que permiten generar diferentes versiones de la app (ej. desarrollo vs. producción) con distintos backends y configuraciones.

**build_runner**
Herramienta de Dart que ejecuta generadores de código como Freezed y json_serializable. Se ejecuta con `dart run build_runner build --delete-conflicting-outputs`.

### C

**ChangeNotifier**
Clase de Flutter que permite notificar a listeners cuando el estado cambia. Usado en `EconomiaProvider` para gestionar la economía del juego de forma reactiva.

**Checkpoint**
Punto de guardado del progreso del usuario que permite restaurar monedas y ejercicios al fallar un nivel. Se guarda en Firestore con campos como `coins_after_basic_level`, `exercises_completed_after_basic`, etc.

**Challenge (Desafío)**
Ejercicio especial de alta dificultad situado al final de cada nivel. Es un reto de programación contra reloj (10 minutos) que debe superarse para progresar al siguiente rango.

**Clean Architecture**
Patrón arquitectónico que separa el sistema en capas: presentación (UI), dominio (casos de uso) y datos (repositorios). Facilita el mantenimiento y testing.

**Cloud Functions**
Funciones serverless de Firebase para ejecutar código backend de forma segura sin necesidad de servidores propios.

**Code Generation**
Proceso de generar código automáticamente. Freezed y json_serializable usan este enfoque para crear clases inmutables y métodos de serialización.

**copyWith()**
Método generado por Freezed que crea una copia inmutable de un objeto con algunos campos modificados. Ejemplo: `state.copyWith(coins: newCoins)`.

**CRT Overlay**
Efecto visual de post-procesamiento que imita el parpadeo y las líneas de escaneo de los monitores de tubo antiguos, reforzando la estética Cyberpunk/Retrowave del proyecto.

### D

**Dart**
Lenguaje de programación de tipado fuerte desarrollado por Google, optimizado para la creación de interfaces de usuario rápidas en múltiples plataformas. Es el lenguaje base de Flutter.

**Deep Linking**
Tecnología de enrutamiento (vía GoRouter) que permite a la aplicación abrirse en una pantalla específica a través de una URL o notificación push.

**Dependencias**
Paquetes externos que el proyecto necesita. Definidos en `pubspec.yaml`. Incluyen flutter_riverpod, google_fonts, go_router, cloud_firestore, etc.

**Design System**
Conjunto estandarizado de componentes visuales (CyberButton, NeonTextField, RetroContainer) que mantienen la coherencia estética Cyberpunk en toda la interfaz.

### E

**EconomiaProvider**
Controlador de lógica de negocio (Singleton + ChangeNotifier) que gestiona el saldo de PY-Coins, estadísticas de ejercicios completados/fallados, y sincronización con Firebase Firestore.

**enum (Enumeración)**
Tipo especial de clase que representa un conjunto finito de valores constantes. Ejemplos en el proyecto: `ExerciseType` (multipleChoice, fillInTheBlank, etc.), `Difficulty` (basic, intermediate, advanced, expert).

**Exercise (Ejercicio)**
Unidad mínima de evaluación del conocimiento del usuario. Puede ser de tipo: selección múltiple, completar espacios, corrección de errores (bug-fix) o escritura de código desde cero.

### F

**Failover**
Mecanismo de redundancia que activa un sistema de respaldo (Groq/Llama 3) de forma automática cuando el sistema principal (Gemini 1.5 Pro) falla. Luego intenta con Gemini 2.0 Flash como segundo fallback.

**FamilyNotifier**
Tipo de provider de Riverpod que acepta parámetros. Usado en `QuizProvider` para recibir la dificultad del nivel como parámetro: `quizProvider(difficulty)`.

**Firebase**
Plataforma integral de Google (Backend as a Service) que proporciona autenticación, base de datos en tiempo real, almacenamiento, hosting y más servicios.

**Firestore**
Base de datos NoSQL escalable en la nube que almacena documentos en colecciones. Utilizada para la persistencia del progreso del usuario, economía y contenido IA generado.

**Firestore Rules**
Reglas de seguridad en Firebase Firestore que controlan quién puede leer/escribir cada documento. Protegen los datos del usuario contra accesos no autorizados.

**Flutter**
Framework de UI de Google para construir aplicaciones nativas multiplataforma (Android, iOS, Web, Linux, macOS, Windows) desde un único código base en Dart.

**Freezed**
Paquete de Dart para code generation que proporciona inmutabilidad automática, métodos `copyWith()`, union types, pattern matching y serialización JSON.

### G

**GameLevel**
Entidad que agrupa un conjunto de ejercicios y un desafío final bajo una dificultad específica (Básico, Intermedio, Avanzado, Experto). Cada nivel tiene 20 ejercicios + 1 reto final.

**Gemini**
Modelo de Inteligencia Artificial Generativa de Google (gemini-1.5-pro, gemini-2.0-flash) integrado en la aplicación para actuar como tutor educativo y generar contenido personalizado.

**GoRouter**
Paquete de enrutamiento declarativo para Flutter que facilita la navegación basada en rutas, gestión de parámetros URL y redirección automática según estado de autenticación.

**Groq**
Infraestructura de inferencia de alto rendimiento utilizada como respaldo (fallback) para procesar el modelo Llama 3.3 70B en caso de caída o límite de cuota de los servicios de Google.

### I

**Inmutabilidad**
Principio de programación donde los datos no cambian tras su creación. Freezed garantiza esto en los modelos del proyecto, mejorando la predictibilidad y reduciendo errores de estado.

**Input Sanitizer (InputSanitizer)**
Componente de seguridad que limpia y valida las entradas de texto del usuario mediante más de 40 patrones de expresiones regulares para prevenir ataques de Prompt Injection y manipulación de la IA.

**Integration Tests**
Pruebas automatizadas que verifican el funcionamiento de múltiples componentes trabajando juntos (ej. flujo completo de login + quiz + tienda).

### J

**JIT (Just-in-Time)**
Compilación durante la ejecución. Flutter usa JIT para Hot Reload durante el desarrollo, permitiendo ver cambios en la UI instantáneamente sin reiniciar la app.

**json_serializable**
Paquete que genera automáticamente código para convertir entre JSON y objetos Dart. Usado junto con Freezed para serialización de modelos como `Exercise` y `UserProfile`.

### L

**Level (Nivel)**
Indicador del progreso del usuario en el sistema de gamificación. Los niveles son: Básico → Intermedio → Avanzado → Experto (RETO FINAL GG).

**Listener**
Función que se ejecuta automáticamente cuando cambia el estado de un provider Riverpod. Los widgets se suscriben como listeners para actualizar la UI reactivamente.

### M

**Main Menu**
Pantalla principal de navegación después del login. Muestra los 4 niveles de dificultad, botones de acceso a logros, tienda, configuración y contacto.

**Mini-Curso**
Contenido IA extenso que cubre un tema completo de Python en módulos estructurados (3-5 módulos), incluyendo proyecto final y recursos para profundizar.

**MPL-2.0 (Mozilla Public License 2.0)**
Licencia de código abierto del proyecto que permite uso comercial pero requiere compartir cambios en archivos originales bajo la misma licencia.

**MusicService**
Servicio centralizado basado en el patrón Singleton encargado de la reproducción de audio de fondo y la gestión del ciclo de vida del sonido ambiente de la app.

### N

**NoSQL**
Paradigma de base de datos que no utiliza estructuras relacionales de tablas. Firestore es NoSQL, permitiendo un esquema flexible basado en documentos JSON.

**Notifier**
Clase base en Riverpod que mantiene estado y notifica a los listeners cuando cambia. Subclases incluyen `AsyncNotifier`, `FamilyNotifier` y `ChangeNotifierProvider`.

### P

**Power-Up**
Ayudas consumibles comprables con PY-Coins en el quiz: revelar pista (5 monedas), eliminar 2 opciones incorrectas (20 monedas).

**Prompt Injection**
Ataque donde un usuario intenta manipular el comportamiento de una IA mediante instrucciones ocultas en el input para saltarse las restricciones de seguridad.

**Provider (Riverpod)**
Objeto que encapsula una pieza de estado y permite que los widgets de la interfaz reaccionen a sus cambios de forma eficiente y type-safe.

**PY-Coins**
Moneda virtual del juego, obtenida mediante el acierto en ejercicios (+10 normales, +200 retos) y utilizada para transacciones en la tienda interna (pistas, explicaciones IA, ejercicios extra, mini-cursos).

### Q

**Quiz**
Evaluación interactiva de conocimientos de Python compuesta por 20 ejercicios aleatorios + 1 reto final por nivel. Incluye 4 tipos de ejercicios: selección múltiple, completar código, detectar bugs y escribir código.

**QuizProvider**
Orquestador de la lógica del juego que maneja el flujo de preguntas, validación de respuestas, gestión de pistas, cálculo de puntuación y sincronización de progreso con Firestore.

### R

**Rate Limiting**
Técnica de control de tráfico que limita el número de acciones que un usuario puede realizar en un tiempo dado. En auth: 5 intentos fallidos = bloqueo de 15 minutos. En IA: 1 uso por día por tipo de contenido.

**Riverpod**
Framework de gestión de estado reactivo para Flutter que mejora Provider con seguridad de tipos en tiempo de compilación, testing más fácil y generación automática de boilerplate.

**Riverpod Generator**
Paquete que genera código boilerplate de providers a partir de anotaciones `@riverpod`. Permite definir providers con sintaxis limpia: `final myProvider = Provider((ref) => ...)`.

### S

**SecureStorage**
Capa de persistencia que cifra los datos en el hardware del dispositivo (KeyStore en Android, Keychain en iOS) para guardar información sensible como tokens de sesión y API keys.

**SharedPreferences**
Sistema de almacenamiento local de clave-valor para guardar preferencias pequeñas y configuraciones de usuario que no requieren cifrado (ej. volumen de música, tema visual).

**Singleton**
Patrón de diseño que restringe la instanciación de una clase a un solo objeto, asegurando un punto de acceso global. Usado en `EconomiaProvider`, `AiGeminiService` y `MusicService`.

**SplashScreen**
Pantalla de carga inicial donde se realizan las comprobaciones de autenticación y carga de recursos antes de entrar al menú principal. Redirige automáticamente a login o main_menu según el estado del usuario.

**State Management**
Proceso de control y distribución de los datos que determinan lo que el usuario ve en pantalla en un momento dado. Riverpod es la solución usada en este proyecto.

**SubDifficulty**
Sub-nivel dentro de una dificultad que indica la complejidad interna del ejercicio: easy (fácil), medium (medio), hard (difícil).

### T

**Topic (Tema)**
Concepto de Python sobre el que se genera contenido IA (ej: "listas", "funciones", "clases", "decoradores"). El usuario lo selecciona al comprar contenido en la tienda.

### U

**Union Types**
Capacidad de Freezed para definir un tipo de dato que puede tener múltiples formas distintas. Usado en `AuthState` que puede ser: Initial, Loading, Authenticated, Error o Success.

**User Profile (Perfil de Usuario)**
Modelo que representa toda la información del usuario: identidad (uid, username, email), estadísticas de juego (coins, level, exercises_completed), progreso por nivel y logros desbloqueados.

### W

**Widget**
Bloque de construcción fundamental de la interfaz en Flutter. Cada elemento de la pantalla es un widget que se compone con otros. Ejemplos: `RetroButton`, `CRTOverlay`, `AiPurchaseDialog`.

**Widget Factory**
Patrón que crea widgets diferentes según el tipo de dato. Usado en el proyecto para renderizar ejercicios de forma distinta según `ExerciseType` (múltiple opción, completar código, etc.).

---



**Última actualización:** 12 de abril de 2026  

*Este archivo es parte de Python Quizz Flash y está licenciado bajo MPL-2.0*
