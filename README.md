# JournalApp

A Flutter journal application for writing daily thoughts, tracking memories, and managing personal entries with Firebase-powered authentication and cloud storage.

## Features

- User registration and login with Firebase Authentication
- Create, read, update, and delete journal entries
- Save personal notes with timestamps and custom content
- Clean, responsive UI built with Flutter
- Riverpod-based state management for a scalable app structure
- Cross-platform Flutter project setup for Android, iOS, web, Linux, macOS, and Windows

## Tech Stack

- Flutter
- Dart
- Firebase Core
- Firebase Authentication
- Cloud Firestore
- Riverpod

## Project Structure

- `journalapp/lib/` — app source code
- `journalapp/lib/screens/` — screens and UI views
- `journalapp/lib/providers/` — state management logic
- `journalapp/lib/service/` — Firebase and business logic services
- `journalapp/android/` — Android project files
- `journalapp/ios/` — iOS project files
- `journalapp/web/` and desktop folders — platform-specific setup

## Getting Started

1. Install Flutter SDK and set up your preferred editor (VS Code or Android Studio).
2. Clone the repository.
3. Navigate to the app folder:

   ```bash
   cd journalapp
   ```

4. Install dependencies:

   ```bash
   flutter pub get
   ```

5. Configure Firebase for your project and ensure the generated Firebase config is available.
6. Run the app:

   ```bash
   flutter run
   ```

## Notes

This project is designed as a personal journaling app with Firebase integration for authentication and persistence. You can extend it with features such as mood tagging, search, image attachment support, and reminders.
