// Copyright (C) 2024 Patrick Michiels
// All rights reserved.
// This source code is licensed under the Evaluation License Agreement and
// may not be used, modified, or distributed without explicit permission from the author.
// This code is provided for evaluation purposes only.

// Public packages imports.
import 'package:crypto/crypto.dart';
import 'dart:convert';

// Own package imports.
import 'package:engaige_meal_tracker_demo/constants/authentication.dart';

/// A utility class responsible for handling encryption and hashing operations.
///
/// This class provides methods for securely hashing user passwords, combining
/// the username, password, and an additional pepper (constant) to generate a secure hash.
class EncryptionUtils {

  /// Default constructor for [EncryptionUtils].
  EncryptionUtils();

  /// Generates a SHA-512 hash of the user's password combined with the username and a pepper.
  ///
  /// This method takes in the user's email (or username) and password, concatenates
  /// them with a secret pepper (`kAuthentication_pepper`), and then hashes the resulting
  /// string using the SHA-512 algorithm.
  ///
  /// This hashed result can be stored securely in a database and compared against
  /// the hashed values during authentication.
  ///
  /// - [userName] The user's email or username.
  /// - [passwordToHash] The user's password in plaintext.
  ///
  /// Returns a SHA-512 hashed string representing the concatenated and hashed input values.
  String hashUserPassword({required String userName, required String passwordToHash}) {
    // Combine the username, password, and a secret pepper for additional security.
    String fullStringToHash = userName + passwordToHash + kAuthentication_pepper;

    // Convert the combined string into bytes, which can be hashed.
    var bytes = utf8.encode(fullStringToHash);

    // Perform the SHA-512 hash operation on the byte data.
    var digest = sha512.convert(bytes);

    // Return the hashed result as a hexadecimal string.
    return digest.toString();
  }
}
