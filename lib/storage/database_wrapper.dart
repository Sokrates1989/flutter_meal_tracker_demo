// Public package imports
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

// Custom package imports.
import 'package:engaige_meal_tracker_demo/utils/os_utils.dart';
import 'package:engaige_meal_tracker_demo/storage/database_repo/user_database_repo.dart';

/// Enum that defines tables with auto-incrementing IDs.
///
/// In this case, we only have the `users` table defined,
/// but this can be extended for other tables with similar needs.
enum TablesWithAutoIncrement {
  users,
}

/// The `DatabaseWrapper` class is responsible for managing the connection
/// to the SQLite database. It handles database initialization, ensuring the
/// database is ready for use, and provides helper functions for interacting
/// with specific tables.
class DatabaseWrapper {
  /// Holds a reference to the opened database.
  late Database database;

  /// Tracks whether the database is ready for use.
  bool dbIsReady = false;

  /// Constructor for `DatabaseWrapper`.
  ///
  /// If the local database is supported by the host OS, the [init] method
  /// is called to initialize the database.
  DatabaseWrapper() {
    if (OSUtils.isLocalDatabaseSupportedOnHostOS()) {
      init();
    }
  }

  /// Provides an instance of `UserDatabaseRepo`.
  ///
  /// This method allows access to the `UserDatabaseRepo` and returns
  /// an instance of it, allowing user-related operations to be performed
  /// using the database wrapper.
  UserDatabaseRepo getUserRepo() {
    return UserDatabaseRepo(this);
  }

  /// Initializes the SQLite database asynchronously.
  ///
  /// This method is called when the instance of `DatabaseWrapper` is created.
  /// Since constructors cannot have `await` expressions, the initialization
  /// is done here. It sets the database path, ensures Flutter binding is
  /// initialized, and creates the necessary tables (if they don't already exist).
  ///
  /// In case of future database schema upgrades, this method also handles
  /// migration between versions.
  Future<void> init() async {
    // Ensure Flutter bindings are initialized.
    WidgetsFlutterBinding.ensureInitialized();

    // Open the database and store the reference.
    database = await openDatabase(
      path.join(await getDatabasesPath(), 'engaige_meal_tracker_demo.db'),
      onCreate: (db, version) async {
        // Create the users table
        await db.execute('''
          CREATE TABLE users (
            ID INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            hashedPassword TEXT NULL
          )
        ''');

        // Insert the demo user directly into the database
        await db.insert('users', {
          'name': 'DemoUser123',
          'hashedPassword': '3c110c5edaf304f6ac0a678bd9766709e8654f1713bd2f6fac94f95873bd77f9a591cb9349c4f9e944a44e1ab30812e66c3f6bf6e3c566fcd4055c65de9a1245'
        });

        // Create the days table
        await db.execute('''
          CREATE TABLE days (
            ID INTEGER PRIMARY KEY AUTOINCREMENT,
            year INT NOT NULL,
            month INT NOT NULL,
            day INT NOT NULL
          )
        ''');

        // Create the meal_types table
        await db.execute('''
          CREATE TABLE meal_types (
            ID INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL
          )
        ''');

        // Insert predefined meal types (breakfast, lunch, dinner, snacks)
        await db.insert('meal_types', {'name': 'breakfast'});
        await db.insert('meal_types', {'name': 'lunch'});
        await db.insert('meal_types', {'name': 'dinner'});
        await db.insert('meal_types', {'name': 'snacks'});

        // Create the meals table
        await db.execute('''
          CREATE TABLE meals (
            ID INTEGER PRIMARY KEY AUTOINCREMENT,
            fat_level INT NOT NULL,
            sugar_level INT NOT NULL
          )
        ''');

        // Create the day_meals table with composite primary key
        await db.execute('''
          CREATE TABLE day_meals (
            fk_user_id INTEGER NOT NULL,
            fk_day_id INTEGER NOT NULL,
            fk_meal_type_id INTEGER NOT NULL,
            fk_meal_id INTEGER NOT NULL,
            PRIMARY KEY (fk_user_id, fk_day_id, fk_meal_type_id),
            FOREIGN KEY (fk_user_id) REFERENCES users(ID) ON DELETE CASCADE,
            FOREIGN KEY (fk_day_id) REFERENCES days(ID) ON DELETE CASCADE,
            FOREIGN KEY (fk_meal_type_id) REFERENCES meal_types(ID) ON DELETE CASCADE,
            FOREIGN KEY (fk_meal_id) REFERENCES meals(ID) ON DELETE CASCADE
          )
        ''');
      },
      version: 1,
    );

    // Mark the database as ready.
    dbIsReady = true;
  }

  /// Ensures the database is initialized and ready for use.
  ///
  /// This method checks if the database has been initialized. If not, it
  /// calls the [init] method to initialize the database.
  Future<void> ensureDBIsInitialized() async {
    if (!dbIsReady) {
      await init();
    }
  }

  /// Retrieves the next available ID for auto-incrementing tables.
  ///
  /// This method is responsible for generating a new ID for tables that
  /// require auto-increment functionality. It ensures that new IDs are unique
  /// and, in case of locally created items, it uses negative IDs.
  ///
  /// When pushing updates to an online database, the new ID will be returned
  /// and replaced accordingly.
  ///
  /// - [table]: The table for which the next ID is required.
  /// - [userID]: Optional userID for future customization.
  ///
  /// Returns the next available ID.
  Future<int> getNextID({required TablesWithAutoIncrement table, int? userID}) async {
    // Ensure the database is ready before any interaction.
    await ensureDBIsInitialized();

    List<Map>? result;

    // Handle ID fetching based on the table provided.
    switch (table) {
      case TablesWithAutoIncrement.users:
        result = await database.rawQuery('SELECT MIN(ID) as currentID FROM users');
        break;
    }

    int nextID = 1; // Default starting ID if no records exist.

    // Increment logic based on the current ID from the table.
    if (result.isNotEmpty) {
      nextID = result.first['currentID'] ?? 0;
    }

    return nextID + 1; // Increment and return next available ID.
  }
}
