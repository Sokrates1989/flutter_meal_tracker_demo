// Copyright (C) 2024 Patrick Michiels
// All rights reserved.
// This source code is licensed under the Evaluation License Agreement and
// may not be used, modified, or distributed without explicit permission from the author.
// This code is provided for evaluation purposes only.

import 'package:shared_preferences/shared_preferences.dart';

/// A utility class that wraps saving and retrieving simple data
/// (integers, booleans, doubles, strings, and string lists) from
/// `SharedPreferences`. This provides a persistent local storage solution
/// for storing key-value pairs across app sessions.
class SharedPrefUtils {
  SharedPrefUtils() {
    init();
  }

  /// A flag to track whether shared preferences have been initialized.
  bool sharedPrefIsReady = false;

  /// An instance of `SharedPreferences` for storing and retrieving data.
  late SharedPreferences prefs;

  /// Default values for various types of keys.
  final Map<String, int> intKeys = {};
  final Map<String, bool> boolKeys = {
    "isRememberUserAndPasswordEnabled": true,
  };
  final Map<String, double> doubleKeys = {};
  final Map<String, String> stringKeys = {
    "lastLoggedInUserName": "",
    "lastLoggedInUserPassword": "",
  };
  final Map<String, List<String>> stringListKeys = {};

  /// Initializes the `SharedPreferences` instance asynchronously.
  ///
  /// This method must be called before accessing any shared preferences.
  /// It is called automatically in the constructor.
  ///
  /// `await` cannot be used in the constructor, so this method allows
  /// initialization after object creation.
  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    sharedPrefIsReady = true;
  }

  /// Ensures that the `SharedPreferences` instance has been initialized.
  ///
  /// This prevents reinitialization if the shared preferences are already
  /// initialized.
  Future<void> ensureSharedPrefIsInitialized() async {
    if (!sharedPrefIsReady) {
      await init();
    }
  }

  /// Retrieves the value for a given key from `SharedPreferences`.
  ///
  /// This method will automatically return the correct type (int, bool,
  /// double, string, or string list) based on the provided key. If the key
  /// does not exist, the method throws an exception.
  ///
  /// - [key]: The key for the value to be retrieved.
  Future<dynamic> get(String key) async {
    await ensureSharedPrefIsInitialized();
    if (intKeys.containsKey(key)) {
      return getInt(key);
    } else if (boolKeys.containsKey(key)) {
      return getBool(key);
    } else if (doubleKeys.containsKey(key)) {
      return getDouble(key);
    } else if (stringKeys.containsKey(key)) {
      return getString(key);
    } else if (stringListKeys.containsKey(key)) {
      return getStringList(key);
    } else {
      throw Exception("Key '$key' is not implemented.");
    }
  }

  /// Sets the value for a given key in `SharedPreferences`.
  ///
  /// This method automatically determines the correct storage type based
  /// on the key. If the key does not exist, an exception is thrown.
  ///
  /// - [key]: The key for the value to be set.
  /// - [value]: The value to store.
  Future<void> set(String key, dynamic value) async {
    await ensureSharedPrefIsInitialized();
    if (intKeys.containsKey(key)) {
      setInt(key, value);
    } else if (boolKeys.containsKey(key)) {
      setBool(key, value);
    } else if (doubleKeys.containsKey(key)) {
      setDouble(key, value);
    } else if (stringKeys.containsKey(key)) {
      setString(key, value);
    } else if (stringListKeys.containsKey(key)) {
      setStringList(key, value);
    } else {
      throw Exception("Key '$key' is not implemented.");
    }
  }

  /// Retrieves an integer value from `SharedPreferences`.
  ///
  /// Returns the default value if the key does not exist.
  ///
  /// - [key]: The key for the integer value to be retrieved.
  Future<int> getInt(String key) async {
    await ensureSharedPrefIsInitialized();
    if (intKeys.containsKey(key)) {
      return prefs.getInt(key) ?? intKeys[key]!;
    } else {
      throw Exception("Key '$key' is not implemented as int.");
    }
  }

  /// Stores an integer value in `SharedPreferences`.
  ///
  /// - [key]: The key for the integer value to be stored.
  /// - [value]: The integer value to store.
  Future<void> setInt(String key, int value) async {
    await ensureSharedPrefIsInitialized();
    if (intKeys.containsKey(key)) {
      await prefs.setInt(key, value);
    } else {
      throw Exception("Key '$key' is not implemented as int.");
    }
  }

  /// Retrieves a boolean value from `SharedPreferences`.
  ///
  /// Returns the default value if the key does not exist.
  ///
  /// - [key]: The key for the boolean value to be retrieved.
  Future<bool> getBool(String key) async {
    await ensureSharedPrefIsInitialized();
    if (boolKeys.containsKey(key)) {
      return prefs.getBool(key) ?? boolKeys[key]!;
    } else {
      throw Exception("Key '$key' is not implemented as bool.");
    }
  }

  /// Stores a boolean value in `SharedPreferences`.
  ///
  /// - [key]: The key for the boolean value to be stored.
  /// - [value]: The boolean value to store.
  Future<void> setBool(String key, bool value) async {
    await ensureSharedPrefIsInitialized();
    if (boolKeys.containsKey(key)) {
      await prefs.setBool(key, value);
    } else {
      throw Exception("Key '$key' is not implemented as bool.");
    }
  }

  /// Retrieves a double value from `SharedPreferences`.
  ///
  /// Returns the default value if the key does not exist.
  ///
  /// - [key]: The key for the double value to be retrieved.
  Future<double> getDouble(String key) async {
    await ensureSharedPrefIsInitialized();
    if (doubleKeys.containsKey(key)) {
      return prefs.getDouble(key) ?? doubleKeys[key]!;
    } else {
      throw Exception("Key '$key' is not implemented as double.");
    }
  }

  /// Stores a double value in `SharedPreferences`.
  ///
  /// - [key]: The key for the double value to be stored.
  /// - [value]: The double value to store.
  Future<void> setDouble(String key, double value) async {
    await ensureSharedPrefIsInitialized();
    if (doubleKeys.containsKey(key)) {
      await prefs.setDouble(key, value);
    } else {
      throw Exception("Key '$key' is not implemented as double.");
    }
  }

  /// Retrieves a string value from `SharedPreferences`.
  ///
  /// Returns the default value if the key does not exist.
  ///
  /// - [key]: The key for the string value to be retrieved.
  Future<String> getString(String key) async {
    await ensureSharedPrefIsInitialized();
    if (stringKeys.containsKey(key)) {
      return prefs.getString(key) ?? stringKeys[key]!;
    } else {
      throw Exception("Key '$key' is not implemented as string.");
    }
  }

  /// Stores a string value in `SharedPreferences`.
  ///
  /// - [key]: The key for the string value to be stored.
  /// - [value]: The string value to store.
  Future<void> setString(String key, String value) async {
    await ensureSharedPrefIsInitialized();
    if (stringKeys.containsKey(key)) {
      await prefs.setString(key, value);
    } else {
      throw Exception("Key '$key' is not implemented as string.");
    }
  }

  /// Retrieves a list of strings from `SharedPreferences`.
  ///
  /// Returns the default value if the key does not exist.
  ///
  /// - [key]: The key for the list of strings to be retrieved.
  Future<List<String>> getStringList(String key) async {
    await ensureSharedPrefIsInitialized();
    if (stringListKeys.containsKey(key)) {
      return prefs.getStringList(key) ?? stringListKeys[key]!;
    } else {
      throw Exception("Key '$key' is not implemented as string list.");
    }
  }

  /// Stores a list of strings in `SharedPreferences`.
  ///
  /// - [key]: The key for the list of strings to be stored.
  /// - [value]: The list of strings to store.
  Future<void> setStringList(String key, List<String> value) async {
    await ensureSharedPrefIsInitialized();
    if (stringListKeys.containsKey(key)) {
      await prefs.setStringList(key, value);
    } else {
      throw Exception("Key '$key' is not implemented as string list.");
    }
  }
}
