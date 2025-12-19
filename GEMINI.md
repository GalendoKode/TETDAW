# DAWALA Project

## Overview
DAWALA is a PWA offline-first application for data and service management.
Built with Flutter for Web and Android.

## Tech Stack
- **Framework**: Flutter (Web, Android)
- **State Management**: Riverpod (riverpod_generator)
- **Navigation**: GoRouter
- **API**: HTTP (Google Apps Script Backend)
- **Local Storage**: SharedPreferences

## Features
- **Authentication**:
  - Login with Email.
  - Animated Gradient Background.
  - Session Management (Local Storage + 6-hour expiry).
  - Error Handling.
- **Home**:
  - Protected Route (requires valid session).

## Architecture
Clean Architecture with Feature-based folder structure:
- `lib/src/core`: Shared services and routing.
- `lib/src/features`: Feature modules (auth, home).
  - `data`: Repositories and Sources.
  - `presentation`: UI and ViewModels.

## Setup
1. `flutter pub get`
2. `flutter pub run build_runner build`
3. `flutter run`
