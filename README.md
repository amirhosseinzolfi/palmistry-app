# Palmistry App (کف‌بینی تعاملی کیهانی)

A premium interactive Palmistry Cheat Sheet and Reader application built with Flutter. This app features a modern "Cosmic" UI, Persian (Farsi) localization, and an interactive hand mapping system.

## ✨ Key Features

- **Interactive Hand Map**: Tap on specific lines (Heart, Head, Life, Fate), mounts (Jupiter, Saturn, Apollo, Mercury, Venus, Moon, Mars), fingers, and symbols to get instant interpretations.
- **Palmistry Encyclopedia**: A comprehensive, searchable database of palmistry knowledge categorized by basics, lines, mounts/fingers, and special signs.
- **Interactive Reading Wizard**: An 11-step guided process that walks users through a personalized palm reading experience.
- **Cosmic UI/UX**: High-fidelity dark theme with neon accents, optimized for readability and a mystical atmosphere.
- **Persian Localization**: Fully localized in Persian with RTL support and custom typography (Vazirmatn).

## 🛠 Tech Stack

- **Framework**: [Flutter](https://flutter.dev)
- **Language**: Dart
- **State Management**: StatefulWidget (Simple & effective for this scale)
- **UI Components**: Custom Painters for the interactive hand map, Material Design 3.
- **Typography**: Vazirmatn font for optimal Persian reading.

## 📂 Project Structure

```text
lib/
├── models/         # Data models and palmistry database content
├── screens/        # Main UI screens (Home, Wizard, Report)
├── widgets/        # Reusable UI components (Hand Map, Custom Painters)
└── main.dart       # Entry point and theme configuration
```

## 🚀 Quick Setup

Prerequisites:
- Flutter SDK (stable)
- Android SDK (for Android builds)

### Using the Smart Build Script (Windows)

This project includes a `run_app.ps1` PowerShell script designed to optimize builds, save disk space on `C:\`, and bypass network issues:

```powershell
.\run_app.ps1 run          # Run on x64 emulator
.\run_app.ps1 run-arm      # Run on physical Android phone
.\run_app.ps1 build        # Build debug APK (x64 only)
.\run_app.ps1 clean        # Clean build artifacts
.\run_app.ps1 free-space   # Manage and clean disk cache
```

### Standard Flutter Commands

Steps to run locally without the script:

1. Install Flutter: https://docs.flutter.dev/get-started/install
2. Clone the repository and navigate to the root folder.
3. Run the following commands:

```bash
flutter pub get
flutter run
```

## 🧪 Quality Assurance

To run static analysis and tests:

```bash
flutter analyze
flutter test
```

## 📦 Build for Android

Generate a release APK or app bundle:

```bash
flutter build appbundle --release
flutter build apk --release
```

If you use signing, keep `android/key.properties` and any keystore files out of version control (see `.gitignore`).

## 🤝 Contributing

- Follow [Conventional Commits](https://www.conventionalcommits.org/) for clear commit history.
- Ensure sensitive files (keystores, API keys) are never committed.
- Run `flutter analyze` before pushing any changes.

## 📄 License
This repository is licensed under the MIT License — see `LICENSE`.

## 📬 Contact
If you want help packaging releases or setting up Play Store signing, open an issue or contact the maintainer.
