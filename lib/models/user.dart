// Copyright (C) 2024 Patrick Michiels
// All rights reserved.
// This source code is licensed under the Evaluation License Agreement and
// may not be used, modified, or distributed without explicit permission from the author.
// This code is provided for evaluation purposes only.

// Public package imports.
import 'dart:convert';

// Custom package imports.
import 'package:engaige_meal_tracker_demo/utils/encryption_utils.dart';

/// Represents a User in the meal tracker application.
///
/// Contains information such as the user's ID, username, and optionally
/// the hashed password.
class User {
  /// The unique IDentifier for the user.
  ///
  /// A value of `0` indicates the user is not yet created or will be created.
  late int ID;

  /// The username of the user.
  final String userName;

  /// The hashed password of the user, optional.
  String? hashedPassword;

  /// Constructs a [User] instance.
  ///
  /// The [userName] is required, while the [ID] and [hashedPassword] are optional.
  /// If the [ID] is not provided, it defaults to `0`.
  User({
    int? ID,
    required this.userName,
    this.hashedPassword,
  }) {
    this.ID = ID ?? 0;
  }

  /// Returns a demo user with preset credentials for demo login.
  ///
  /// The demo user's username is `DemoUser123` and their password is hashed.
  static User getDemoUser() {
    const String demoUserName = 'DemoUser123';
    const String demoPassword = '123';

    EncryptionUtils encryptionUtils = EncryptionUtils();
    String hashedPassword = encryptionUtils.hashUserPassword(
      userName: demoUserName,
      passwordToHash: demoPassword,
    );

    return User(
      userName: demoUserName,
      hashedPassword: hashedPassword,
    );
  }

  /// Constructs a [User] instance from a [Map].
  ///
  /// Expects the map to contain keys for 'ID', 'name', and 'hashedPassword'.
  static User fromMap(Map map) {
    return User(
      ID: map['ID'],
      userName: map['name'],
      hashedPassword: map['hashedPassword'],
    );
  }

  /// Utility function to interpret various representations of boolean values.
  ///
  /// Returns `true` if the value is `1`, `"True"`, `"true"`, or `true`, otherwise returns `false`.
  static bool getBooleanFromMapValue(dynamic value) {
    return value == 1 || value == "True" || value == "true" || value == true;
  }

  /// Converts the [User] instance into a [Map].
  ///
  /// This is useful for serialization purposes.
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'ID': ID,
      'userName': userName,
    };

    if (hashedPassword != null) {
      map['hashedPassword'] = hashedPassword;
    }

    return map;
  }

  /// Converts the [User] instance into a JSON string.
  ///
  /// This method uses [toMap] internally for the conversion.
  String toJson() {
    return jsonEncode(toMap());
  }

  /// Constructs a [User] instance from a JSON string.
  ///
  /// This method decodes the JSON and passes it to [fromMap].
  static User fromJson(String jsonString) {
    return fromMap(jsonDecode(jsonString));
  }
}
