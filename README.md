# Palmistry App

Interactive palmistry (کف‌بینی) Flutter application — Persian UI and resources.

This repository contains the Flutter application source for the Palmistry App.

## What you'll find
- Flutter app sources under `lib/` and Android config under `android/`.
- Basic tests under `test/`.

## Quick setup

Prerequisites:
- Flutter SDK (stable)
- Android SDK (for Android builds)

Steps to run locally:

1. Install Flutter: https://docs.flutter.dev/get-started/install
2. From the project root run:

```bash
flutter pub get
flutter run
```

To run tests and static analysis:

```bash
flutter analyze
flutter test
```

## Build for Android

Generate a release APK or app bundle:

```bash
flutter build appbundle --release
flutter build apk --release
```

If you use signing, keep `android/key.properties` and any keystore files out of version control (see `.gitignore`).

## Contributing / Preparing to push
- Follow conventional commits and include clear commit messages.
- Ensure sensitive files (keystores, API keys) are not committed.
- Update `pubspec.yaml` dependencies as needed and run `flutter pub get`.

To push local changes to the remote GitHub repository:

```bash
git add .
git commit -m "chore: prepare repo for publishing (README, gitignore, CI)"
git push origin HEAD
```

If the repository does not have a remote yet, add it:

```bash
git remote add origin <git-ssh-or-https-url>
git push -u origin HEAD
```

## CI
A basic GitHub Actions workflow is included to run `flutter analyze` and `flutter test` on push and PRs.

## License
This repository is licensed under the MIT License — see `LICENSE`.

## Contact
If you want help packaging releases or setting up Play Store signing, open an issue or contact the maintainer.
