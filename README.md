
# Flutter Meal Tracker App

A Flutter app that allows users to track meal parameters (Fat and Sugar levels) for Breakfast, Lunch, Dinner, and Snacks. Users can select Low, Medium, or High for each parameter and store the entries in a local SQLite database. The app uses Easy Localization for language support and Provider for state management. Additionally, it includes a login screen for user authentication.

## Table of Contents
1. [Features](#features)
2. [Database Schema](#database-schema)
3. [Plugins Used](#plugins-used)
    - [SQLite](#sqlite)
    - [Flutter Login Plugin](#flutter-login-plugin)
    - [Easy Localization](#easy-localization)
    - [Provider](#provider)
4. [Setup Guide](#setup-guide)
    - [Installation](#installation)
        - [Build Web App](#building-the-web-app)
        - [Android Setup](#android-setup)
        - [iOS Setup](#ios-setup)
5. [Running the App](#running-the-app)
6.[Licence](#license)

## Features

- Track meal parameters for Breakfast, Lunch, Dinner, and Snacks.
- Each meal type has selectable Fat and Sugar levels (Low, Medium, High).
- Save and retrieve meal data using a local SQLite database.
- User authentication with a login screen.
- Multi-language support using Easy Localization.
- State management using Provider.
- Simple, user-friendly UI.

## Database Schema
![Database Schema](docs/images/database_scheme.png)

### SQL Representation of the Database

```sql
-- SQL commands for creating tables
CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL
);

CREATE TABLE meal_types (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL
);

CREATE TABLE meals (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    fat_level TEXT NOT NULL,
    sugar_level TEXT NOT NULL
);

CREATE TABLE day_meals (
    day DATE NOT NULL,
    meal_type_id INTEGER,
    meal_id INTEGER,
    PRIMARY KEY (day, meal_type_id),
    FOREIGN KEY (meal_type_id) REFERENCES meal_types(id),
    FOREIGN KEY (meal_id) REFERENCES meals(id)
);
```

### Tables

- `users`: Stores user information (no encryption used for names).
- `meal_types`: Contains meal types (Breakfast, Lunch, Dinner, Snacks).
- `meals`: Stores the fat and sugar level for each meal.
- `day_meals`: Connects a day to its respective meals.

The app uses a composite primary key in `day_meals` to uniquely identify meals for each day and meal type.

## Plugins Used

### SQLite
The app uses [SQLite](https://pub.dev/packages/sqflite) to locally store meal data. All meal entries (Fat and Sugar levels) are saved and retrieved from this local database, ensuring offline functionality.

### Flutter Login Plugin
The app uses the [Flutter Login Plugin](https://pub.dev/packages/flutter_login) to handle user authentication. This plugin simplifies the process of adding a login screen with built-in form validation and animations.

### Easy Localization
[Easy Localization](https://pub.dev/packages/easy_localization) is used for multi-language support. All user-facing texts are stored in JSON files and can be easily extended for multiple languages.

### Provider
[Provider](https://pub.dev/packages/provider) is used for state management, allowing efficient handling of state across the app, especially for user interactions with meal data.

## Setup Guide

### Installation

#### Building the Web App

To build the web version of the app, use the following command:

```bash
flutter build web --release --web-renderer html --target lib/main.dart
```

#### Android Setup

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

## Running the App

Once you've completed the setup, you can run the app using the following command:

```bash
flutter run
```

For additional build commands, such as building APKs for Android or iOS builds, refer to the Flutter documentation.

---

By integrating the local database and state management as described, the app offers seamless meal tracking functionality. This README should help guide developers through setting up and running the Flutter Meal Tracker App.


## License

This software is provided under an **Evaluation License Agreement**. It may only be used for evaluation purposes and cannot be modified, copied, or distributed without the express permission of the author.

For full details, please refer to the [LICENSE](./LICENSE) file.
