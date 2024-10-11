import 'dart:convert';

import 'package:engaige_meal_tracker_demo/utils/encryption_utils.dart';

class User {
  // Class vars.
  late int ID;
  final String userName;
  String? hashedPassword;

  // ID = 0 not yet created/ to be created.
  User({
    ID,
    required this.userName,
    this.hashedPassword,
  }) {
    this.ID = ID ?? 0;
  }

  static User getDemoUser() {
    String userName = 'DemoUser123';
    String password = '123';
    EncryptionUtils encryptionUtils = EncryptionUtils();
    String hashedPassword = encryptionUtils.hashUserPassword(
        userName: userName, passwordToHash: password);
    return User(
        userName: userName, hashedPassword: hashedPassword);
  }

  static User fromMap(Map map) {
    return User(
      ID: map['ID'],
      userName: map['name'],
      hashedPassword: map['hashedPassword'],
    );
  }

  static bool getBooleanFromMapValue(value) {
    return value == 1 || value == "True" || value == "true" || value == true;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'ID': ID,
      'userName': userName,
    };

    // Optional parameters.
    if (hashedPassword != null) {
      map['hashedPassword'] = hashedPassword;
    }

    return map;
  }

  /// Convert object to json (using its map conversion).
  String toJson() {
    return json.encode(toMap());
  }

  /// Convert json to object.
  static User fromJson(String json) {
    return fromMap(jsonDecode(json));
  }

}
