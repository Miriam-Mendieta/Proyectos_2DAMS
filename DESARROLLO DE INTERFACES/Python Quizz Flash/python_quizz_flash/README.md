# Python Quizz Flash

> Aplicación educativa gamificada para repasar Python con un estética cyberpunk/retro.

[![Dart SDK](https://img.shields.io/badge/Dart-^3.10.0-0175C2?logo=dart)](https://dart.dev/)
[![Flutter](https://img.shields.io/badge/Flutter-Compatible-02569B?logo=flutter)](https://flutter.dev/)
[![License](https://img.shields.io/badge/License-MPL--2.0-green)](LICENSE)
[![Riverpod](https://img.shields.io/badge/State%20Management-Riverpod%20v3-42A5F5)](https://riverpod.dev/)

---

## Descripción

**Python Quizz Flash** es una aplicación  multiplataforma (Android, iOS, Web, Windows, Linux, macOS) diseñada para repasar Python de forma gamificada. Los usuarios pueden:

- Resolver ejercicios interactivos organizados por niveles de dificultad (básico, intermedio, avanzado, experto)
- Desafiar sus conocimientos con retos tipo "boss fight"
- Generar contenido personalizado con IA (Google Gemini / Groq)
- Ganar PY-Coins (moneda virtual) y canjearlas por pistas y ayudas
- Competir por logros y estadísticas
- Disfrutar de una estética retro cyberpunk con música de fondo

## Tecnologías Principales

| Categoría | Tecnología |
|-----------|-----------|
| **Framework** | Flutter (Dart ^3.10.0) |
| **Estado** | Riverpod v3 (annotation-based) |
| **Rutas** | GoRouter ^17.1.0 |
| **Backend** | Firebase (Auth, Firestore, App Check, Storage) |
| **IA** | Google Gemini 1.5 Pro → Gemini 2.0 Flash → Groq Llama 3 |
| **Audio** | audioplayers ^6.6.0 |
| **Generación de código** | freezed, json_serializable, build_runner |

## Estructura del Proyecto

```
python_quizz_flash/
├── lib/
│   ├── config/            # Configuración de API keys
│   ├── routes/            # Enrutamiento con GoRouter
│   ├── theme/             # Sistema de diseño (colores, tipografía, efectos)
│   ├── utils/             # Logger, sanitización de inputs
│   ├── models/            # Modelos de datos (freezed + json_serializable)
│   ├── providers/         # Providers de Riverpod (estado de la app)
│   ├── services/          # Servicios externos (IA, música)
│   ├── pages/             # Pantallas (16 screens)
│   ├── widgets/           # Widgets reutilizables (22 widgets)
│   └── main.dart          # Punto de entrada
├── assets/
│   ├── data/              # Pools de ejercicios en JSON
│   ├── images/            # Logo y recursos visuales
│   ├── fonts/             # Fuentes personalizadas (4 familias)
│   └── audio/music/       # Música de fondo
├── test/                  # Pruebas unitarias y de widgets
├── docs/                  # Documentación técnica (este directorio)
└── android/ios/web/linux/macos/windows/  # Plataformas nativas
```

## Inicio Rápido

### Requisitos

- Dart SDK ^3.10.0
- Flutter SDK (versión compatible con Dart ^3.10.0)
- Cuenta de Firebase configurada
- API keys de Google Gemini (obligatorio) y Groq (opcional)

### Configuración

```bash
# 1. Clonar el repositorio
git clone <repo-url>
cd python_quizz_flash

# 2. Copiar y configurar variables de entorno
cp .env.example .env
# Editar .env con tus API keys reales

# 3. Instalar dependencias
flutter pub get

# 4. Generar código (freezed, json_serializable, riverpod)
dart run build_runner build --delete-conflicting-outputs

# 5. Ejecutar en tu plataforma preferida
flutter run        # Dispositivo conectado
flutter run -d chrome   # Web
flutter run -d windows  # Windows
```

## Documentación Técnica

Toda la documentación técnica detallada se encuentra en el directorio [`docs/`](docs/):

### Documentación General

| Documento | Descripción |
|-----------|-------------|
| [Guía de Configuración](docs/setup-guide.md) | Configuración completa del entorno |
| [Arquitectura](docs/architecture.md) | Arquitectura y patrones de diseño |
| [Gestión de Estado](docs/state-management.md) | Riverpod y flujo de datos |
| [Rutas](docs/routing.md) | Sistema de navegación |
| [Sistema de Diseño](docs/theme-design-system.md) | Tema visual y componentes |
| [Firebase](docs/firebase-integrations.md) | Integración con Firebase |
| [Servicio de IA](docs/ai-service.md) | APIs de IA y estrategia de fallback |
| [Modelos de Datos](docs/models.md) | Estructura de datos |
| [Seguridad](docs/security.md) | Prácticas de seguridad |
| [Pruebas](docs/testing.md) | Estrategia de testing |
| [Referencia API](docs/api-reference.md) | Referencia de providers y servicios |

### Diagramas UML

| Diagrama | Descripción |
|----------|-------------|
| [Diagrama de Clases](docs/uml-class-diagram.md) | Clases, modelos, providers y sus relaciones |
| [Casos de Uso](docs/uml-use-case-diagram.md) | Actores y casos de uso del sistema |
| [Diagramas de Secuencia](docs/uml-sequence-diagrams.md) | Interacciones temporales entre objetos |
| [Diagramas de Actividad](docs/uml-activity-diagrams.md) | Flujos de trabajo de procesos clave |
| [Diagrama de Componentes](docs/uml-component-diagram.md) | Organización estructural del sistema |
| [Diagramas de Estado](docs/uml-state-diagrams.md) | Ciclos de vida de objetos principales |

## Plataformas Soportadas

- **Android** (móvil/tablet)
- **iOS** (móvil/tablet)
- **Web** (navegadores modernos)
- **Windows** (desktop)
- **Linux** (desktop)
- **macOS** (desktop)

## Licencia

Este proyecto está licenciado bajo la **Mozilla Public License 2.0 (MPL-2.0)**.  
Consulta [LICENSE](LICENSE) (inglés) o [LICENSE.es](LICENSE.es) (español) para más detalles.

**Autor:** Miriam Mendieta Racedo.-  
**Copyright:** 2026

## Créditos

- **Música de fondo:** "Game On" por akashworldwide
- **Fuentes:** Press Start 2P, Fira Code, IBM Plex Mono, Pixelify Sans
- **Iconos:** Font Awesome Flutter, Lucide Icons

---

> *"Aprende Python jugando, línea de código a la vez."*
