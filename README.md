
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
      - [Build Web App](#build-the-web-app)
      - [Build Android Release](#build-android-release)
      - [Android Setup](docs/guides/README_Debug_Android_Flutter.md)
      - [iOS Setup](docs/guides/README_Debug_iOS_Flutter.md)
5. [Running the App](#running-the-app)
6. [Download APK](#download-apk)
7. [Next Steps](#next-steps)
8. [Webapp](#deployed-webapp)
9. [Documentation](#documentation)
10. [License](#license)

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

#### Build the Web App

To build the web version of the app, use the following command:

```bash
flutter build web --release --web-renderer html --target lib/main.dart
```


#### Build Android Release

To build the android release version of the app, use the following command:

```bash
flutter build apk --release
```


#### Android Setup

For Android setup instructions, refer to the [Android Setup Guide](docs/guides/README_Debug_Android_Flutter.md).

#### iOS Setup

For iOS setup instructions, refer to the [iOS Setup Guide](docs/guides/README_Debug_iOS_Flutter.md).

## Running the App

Once you've completed the setup, you can run the app using the following command:

```bash
flutter run
```

For additional build commands, such as building APKs for Android or iOS builds, refer to the Flutter documentation.

## Download APK

You can download the latest release of the Flutter Meal Tracker App from the link below:

- [Download the Release APK](releases/android)
- [View Releases](https://github.com/Sokrates1989/flutter_engaige_meal_tracker_demo/releases)

## Next Steps

There are several potential enhancements for the Flutter Meal Tracker App:

- **Sync Mechanism for Local and Online Databases**: Currently, the app stores data in separate local and online databases. A sync mechanism could be implemented to allow offline usage while still benefiting from the advantages of an online database. This would enable users to seamlessly transition between offline and online usage.
- **Opt-Out of Online Usage**: For users who prioritize security and privacy, an option to fully opt out of online usage could be provided. This would ensure that no user data is transmitted or stored online, promoting security and data protection.

## Deployed WebApp

The App has been built as web-app and can be found here: https://engaige.fe-wi.com/

## Documentation

- The zipped documentation for the project can be found at [docs/doku.zip](docs/doku.zip).
- An online version of this documentation can be found at https://doku.engaige.fe-wi.com/

## License

This software is provided under an **Evaluation License Agreement**. It may only be used for evaluation purposes and cannot be modified, copied, or distributed without the express permission of the author.

For full details, please refer to the [LICENSE](./LICENSE) file.
