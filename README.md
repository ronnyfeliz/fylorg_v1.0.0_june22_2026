# 📂 FYLORG

<p align="center">
  <img src="assets/logo/fylorg_logo.png" width="180" alt="Fylorg Logo">
</p>

<h1 align="center">FYLORG</h1>

<p align="center">
  <strong>Organizador Inteligente de Archivos para Windows, Android y Linux</strong>
</p>

<p align="center">
  Automatiza la organización de archivos mediante reglas inteligentes, historial reversible y una interfaz moderna desarrollada en Flutter.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.44.0-02569B?logo=flutter&logoColor=white">
  <img src="https://img.shields.io/badge/Dart-3.12-0175C2?logo=dart&logoColor=white">
  <img src="https://img.shields.io/badge/Riverpod-3.3.2-6E56CF">
  <img src="https://img.shields.io/badge/Hive_CE-2.19.3-F9A825">
  <img src="https://img.shields.io/badge/Platforms-Windows%20|%20Android%20|%20Linux-success">
  <img src="https://img.shields.io/badge/Version-v1.0.0-blue">
</p>

---

# 🚀 ¿Qué es FYLORG?

**FYLORG** es una aplicación multiplataforma desarrollada con Flutter que permite organizar automáticamente archivos y carpetas mediante reglas configurables.

La aplicación analiza directorios completos, identifica tipos de archivos, crea estructuras organizadas y registra todas las operaciones realizadas para permitir una restauración completa en cualquier momento.

### ✨ Características principales

- 📂 Organización automática de archivos
- ⚙️ Reglas totalmente editables
- 🔄 Historial con sistema Undo
- 🌍 Soporte para 9 idiomas
- 🎨 Modo claro y oscuro
- 📊 Estadísticas en tiempo real
- 📁 Subcarpetas automáticas por extensión
- 🖥️ Compatible con Windows
- 🤖 Compatible con Android
- 🐧 Compatible con Linux
- 🚀 Interfaz moderna inspirada en Windows 11

---

# 📸 Capturas de Pantalla

## 🪟 Windows

<p align="center">
  <img src="https://github.com/user-attachments/assets/a5980b42-6dcc-4f8d-b75e-aeb7e5965557" width="48%">
  <img src="https://github.com/user-attachments/assets/e68c64e6-466b-462f-a1b6-8f46baa2dc99" width="48%">
</p>

<p align="center">
  <img src="https://github.com/user-attachments/assets/34d98361-8040-4a12-aa55-c24302df3a5f" width="48%">
  <img src="https://github.com/user-attachments/assets/16aebbe8-0510-4bd0-9f33-40eb7d50b2f5" width="48%">
</p>

<p align="center">
  <img src="https://github.com/user-attachments/assets/0d9ad31e-c864-4001-ab0f-3a9a4939623e" width="80%">
</p>

---

## 🤖 Android

<p align="center">
  <img src="https://github.com/user-attachments/assets/99fb31c2-01db-46bf-9573-e4c52a2baecb" width="19%">
  <img src="https://github.com/user-attachments/assets/b425faa5-8e0a-4364-b72a-a9d6370d50e7" width="19%">
  <img src="https://github.com/user-attachments/assets/7a0e353e-9482-4148-b17c-31e7de634404" width="19%">
  <img src="https://github.com/user-attachments/assets/8b9a4c68-a687-457f-91af-8e803c902396" width="19%">
  <img src="https://github.com/user-attachments/assets/7b713494-9e68-43f9-ac43-e0e310cb9e5c" width="19%">
</p>

---

## 🐧 Linux

<p align="center">
  <img src="https://github.com/user-attachments/assets/823a73e0-0fa4-4275-b405-fc0c70e308f7" width="48%">
  <img src="https://github.com/user-attachments/assets/c0bcc5a4-9ab9-4eca-9358-3488ee65f7ea" width="48%">
</p>

<p align="center">
  <img src="https://github.com/user-attachments/assets/16b4f849-acc9-4bdb-bf9c-dab808caa293" width="48%">
  <img src="https://github.com/user-attachments/assets/64d71c8c-a032-4912-a1d7-1a5c9f097980" width="48%">
</p>

<p align="center">
  <img src="https://github.com/user-attachments/assets/d9f2ec35-5847-4a63-9e6c-40082c8b6af1" width="80%">
</p>

---

# 🌟 Funcionalidades

| Funcionalidad | Estado |
|--------------|---------|
| Organización recursiva de archivos | ✅ |
| Reglas personalizadas | ✅ |
| Activar / Desactivar reglas | ✅ |
| Subcarpetas por extensión | ✅ |
| Historial agrupado por sesión | ✅ |
| Revertir organización | ✅ |
| Eliminación automática de carpetas vacías | ✅ |
| Soporte multilenguaje | ✅ |
| Tema claro y oscuro | ✅ |
| Interfaz Premium | ✅ |
| Windows | ✅ |
| Android | ✅ |
| Linux | ✅ |

---

# 🌍 Idiomas Soportados

| Idioma | Estado |
|---------|---------|
| Español | ✅ |
| English | ✅ |
| Italiano | ✅ |
| Русский | ✅ |
| 日本語 | ✅ |
| 中文 | ✅ |
| Português | ✅ |
| Français | ✅ |
| 한국어 | ✅ |

---

# 🏗️ Arquitectura

```text
lib/
│
├── core/
│   ├── constants/
│   ├── l10n/
│   ├── theme/
│   └── utils/
│
├── data/
│   ├── models/
│   ├── providers/
│   ├── repositories/
│   └── services/
│
└── presentation/
    ├── screens/
    └── widgets/
```

---

# 🛠️ Stack Tecnológico

| Tecnología | Versión |
|------------|----------|
| Flutter | 3.44.0 |
| Dart | 3.12 |
| Riverpod | 3.3.2 |
| Hive CE | 2.19.3 |
| Hive CE Flutter | 2.3.4 |
| File Picker | 11.0.2 |
| Permission Handler | 12.0.3 |

---

# 📊 Estadísticas del Proyecto

| Métrica | Valor |
|----------|--------|
| Idiomas soportados | 9 |
| Categorías predeterminadas | 7 |
| Plataformas verificadas | 3 |
| Funciones implementadas | 13+ |
| Errores críticos corregidos | 9 |
| Versión actual | v1.0.0 |

---

# 📦 Builds Verificados

| Plataforma | Estado |
|------------|--------|
| Windows Release | ✅ |
| Android Debug | ✅ |
| Android Release | ✅ |
| Linux Bundle | ✅ |

---

# ⚡ Instalación

## Clonar el repositorio

```bash
git clone https://github.com/ronnyfeliz/fylorg.git
cd fylorg
```

## Instalar dependencias

```bash
flutter pub get
```

## Generar adaptadores Hive

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Ejecutar aplicación

```bash
flutter run
```

---

# 🔮 Roadmap

## v1.1

- [ ] Instalador para Windows
- [ ] Corrección del tema oscuro en Android
- [ ] Optimización de rendimiento
- [ ] Nuevas categorías

## v1.2

- [ ] Sincronización en la nube
- [ ] Perfiles personalizados
- [ ] Exportación de reportes

## v2.0

- [ ] Clasificación mediante IA
- [ ] Organización basada en contenido
- [ ] Sincronización multi-dispositivo
- [ ] Dashboard avanzado

---

# 👨‍💻 Desarrollador

## Ronny Feliz

**Founder & Lead Developer @ Innovatech**

Especializado en:

- Flutter
- Dart
- Android
- Linux
- Windows Desktop
- Automatización de Procesos

---

# ⭐ Apoya el Proyecto

Si FYLORG te resulta útil:

- ⭐ Dale una estrella al repositorio
- 🍴 Haz un Fork
- 📢 Compártelo con otros desarrolladores
- 💡 Envía sugerencias o reporta errores

---

<p align="center">
  <strong>FYLORG v1.0.0</strong><br>
  Organiza • Automatiza • Simplifica
</p>

<p align="center">
  Innovatech © 2026
</p>
