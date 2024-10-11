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
      // Set the path to the database.
      path.join(await getDatabasesPath(), 'engaige_meal_tracker_demo_debug_1.db'),
      // Define the database creation logic.
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE users (ID BIGINT PRIMARY KEY, userName TEXT NOT NULL, hashedPassword TEXT NOT NULL)',
        );
      },
      // Handle database upgrades.
      onUpgrade: (db, oldVersion, newVersion) async {
        var batch = db.batch();
        if (oldVersion == 1 && newVersion == 2) {
          // Example: future schema changes for version 2.
        }
        await batch.commit();
      },
      // Set the database version.
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
