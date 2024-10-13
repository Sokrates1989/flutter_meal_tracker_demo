
# Flutter Meal Tracker App

A Flutter app that allows users to track meal parameters (Fat and Sugar levels) for Breakfast, Lunch, Dinner, and Snacks. The app uses Easy Localization for language support and integrates a login screen for user authentication.

## Table of Contents
1. [Features](#features)
2. [Plugins Used](#plugins-used)
   - [Flutter Login Plugin](#flutter-login-plugin)
   - [Easy Localization](#easy-localization)
3. [Setup Guide](#setup-guide)
   - [Installation](#installation)
      - [Build Web App](#building-the-web-app)
      - [Android Setup](#android-setup)
      - [iOS Setup](#ios-setup)
   - [Configuration](#configuration)
4. [Running the App](#running-the-app)

## Features

- Track meal data for Breakfast, Lunch, Dinner, and Snacks.
- Store fat and sugar levels for each meal.
- User authentication with login screen.
- Multi-language support using Easy Localization.

## Plugins Used

### Flutter Login Plugin
The app uses the [Flutter Login Plugin](https://pub.dev/packages/flutter_login) to handle user authentication. This plugin simplifies the process of adding a login screen with built-in form validation and animations.

### Easy Localization
[Easy Localization](https://pub.dev/packages/easy_localization) is used to manage localization and language support in the app. All user-facing texts are stored in JSON files and can be easily extended for multiple languages.

## Setup Guide

### Installation

#### Building the Web App

To build the web version of the app, use the following command:

```bash
flutter build web --release --web-renderer html --target lib/main.dart
```

#### Android Setup

1. Open the project in Android Studio.
2. Navigate to `android/app/build.gradle` and ensure the `minSdkVersion` is set to at least **21**:

```gradle
   defaultConfig {
       minSdkVersion 21
   }
```
3. Add the following lines to `android/app/src/main/AndroidManifest.xml` under the `<application>` tag for localization support:

```xml
<application
    android:name="io.flutter.app.FlutterApplication"
    android:label="Meal Tracker"
    android:usesCleartextTraffic="true"
    android:icon="@mipmap/ic_launcher">
    <!-- Localization configuration -->
    <meta-data
        android:name="flutterEmbedding"
        android:value="2" />
</application>
```

4. Run the project in Android Studio or using the command line:

```bash
flutter run
```

#### iOS Setup

1. Open the project in Xcode by navigating to `ios/Runner.xcworkspace`.
2. Ensure that the iOS deployment target is set to at least **12.0** in the Xcode settings.
3. Add the following code in `ios/Runner/Info.plist` to enable localization:

```xml
<key>CFBundleLocalizations</key>
<array>
    <string>en</string>
    <string>de</string>
</array>
```

4. Install CocoaPods dependencies by running:

```bash
cd ios
pod install
cd ..
```

5. Run the project in Xcode or using the command line:

```bash
flutter run
```

### Configuration

To set up the localization files, create your language JSON files in the following directory:

```
assets/
└── lang/
    ├── en.json
    └── de.json
```

Example `en.json`:

```json
{
  "Meal Tracker": "Meal Tracker",
  "Login": "Login",
  "Fat Level": "Fat Level",
  "Sugar Level": "Sugar Level"
}
```

Update your `pubspec.yaml` to include the localization files:

```yaml
flutter:
  assets:
    - assets/lang/
```

## Running the App

Once you've completed the setup, you can run the app using the following command:

```bash
flutter run
```

For additional build commands, such as building APKs for Android or iOS builds, refer to the Flutter documentation.
