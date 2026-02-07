---
description: Steps to build the Aurawear application for Windows (EXE) and Android (APK)
---

# Build Workflow

This workflow provides the commands necessary to build Aurawear for different platforms.

## Prerequisites

- **Flutter SDK**: Ensure Flutter is installed and added to your PATH.
- **Android SDK**: Required for building the APK.
- **Visual Studio 2022**: Required for building the Windows EXE (with "Desktop development with C++" workload).

## Build Commands

### 1. Clear Build Cache
It is recommended to clear the build cache before a release build.
```powershell
flutter clean
```

### 2. Get Dependencies
// turbo
```powershell
flutter pub get
```

### 3. Build Android APK
// turbo
```powershell
flutter build apk --release
```
The output file will be located at: `build/app/outputs/flutter-apk/app-release.apk`

### 4. Build Windows EXE
// turbo
```powershell
flutter build windows --release
```
The output files will be located in: `build/windows/runner/Release/`

## Troubleshooting

- If the Windows build fails, ensure you have the correct Visual Studio components installed.
- For Android, ensure `local.properties` points to your correct Android SDK path.
