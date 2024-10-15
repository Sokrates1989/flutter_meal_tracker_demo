// Copyright (C) 2024 Patrick Michiels
// All rights reserved.
// This source code is licensed under the Evaluation License Agreement and
// may not be used, modified, or distributed without explicit permission from the author.
// This code is provided for evaluation purposes only.

import 'package:engaige_meal_tracker_demo/models/user.dart';
import 'package:engaige_meal_tracker_demo/storage/api_connector.dart';
import 'package:engaige_meal_tracker_demo/storage/database_repo/user_database_repo.dart';
import 'package:engaige_meal_tracker_demo/storage/database_wrapper.dart';
import 'package:engaige_meal_tracker_demo/storage/data_handler_repo/data_handler_user_repo.dart';
import 'package:engaige_meal_tracker_demo/storage/models/users_db_model.dart';
import 'package:engaige_meal_tracker_demo/utils/os_utils.dart';

/// A repository class that handles user-related data operations across both
/// the API and local database.
///
/// The `DataHandlerUserRepo` provides methods for user registration, login,
/// and fetching user data, utilizing both the API and local storage.
class DataHandlerUserRepo {
  /// API connector for handling API-based user operations.
  final ApiConnector _apiConnector;

  /// Database wrapper for handling local database operations.
  final DatabaseWrapper _databaseWrapper;

  final UserDatabaseRepo _userDatabaseRepo;
  final bool useLocalDb;

  /// Constructs an instance of `DataHandlerUserRepo`.
  ///
  /// Accepts an [ApiConnector] for handling API interactions and a [DatabaseWrapper]
  /// for managing local database operations.
  DataHandlerUserRepo(this._apiConnector, this._databaseWrapper)
      : _userDatabaseRepo = UserDatabaseRepo(_databaseWrapper),
        useLocalDb = OSUtils.isLocalDatabaseSupportedOnHostOS();

  /// Registers a new user using the API.
  ///
  /// This method sends a registration request to the API with the user's login
  /// identifier (e.g., username or email) and hashed password.
  ///
  /// - [userName]: The user's login identifier.
  /// - [hashedPassword]: The user's hashed password.
  ///
  /// Returns an [ApiReturn] object containing the response from the API.
  Future<ApiReturn> registerUser({
    required String userName,
    required String hashedPassword,
  }) async {
    if (useLocalDb) {
      // Register user in local database.
      final newUser = UsersDBModel(name: userName, hashedPassword: hashedPassword);
      int userID = await _userDatabaseRepo.createUser(newUser);
      return ApiReturn(
        success: true,
        returnCode: 200,
        explanation: 'User registered locally.',
        data: await _userDatabaseRepo.getUserByID(userID),
      );
    } else {
      // Register user via API.
      ApiReturn apiResponse = await _apiConnector.getUserRepo().registerUser(
        userName: userName,
        hashedPassword: hashedPassword,
      );
      return apiResponse;
    }
  }

  /// Logs in a user using the API.
  ///
  /// This method sends a login request to the API using the user's login identifier
  /// (e.g., username or email) and hashed password.
  ///
  /// - [userName]: The user's login identifier.
  /// - [hashedPassword]: The user's hashed password.
  ///
  /// Returns an [ApiReturn] object containing the response from the API.
  Future<ApiReturn> login({
    required String userName,
    required String hashedPassword,
  }) async {
    if (useLocalDb) {
      User? user = await _userDatabaseRepo.login(
        userName: userName,
        hashedPassword: hashedPassword,
      );
      if (user != null) {
        return ApiReturn(
          success: true,
          returnCode: 200,
          explanation: 'User logged in locally.',
          data: user,
        );
      } else {
        return ApiReturn(
          success: false,
          returnCode: 401,
          explanation: 'Invalid credentials for local database.',
        );
      }
    } else {
      ApiReturn apiResponse = await _apiConnector.getUserRepo().login(
        userName: userName,
        hashedPassword: hashedPassword,
      );
      return apiResponse;
    }
  }

  /// Logs in a user and retrieves their user data if the login is successful.
  ///
  /// This method sends a login request to the API and returns a `User` object
  /// if the login is successful. If the login fails, it returns `null`.
  ///
  /// - [userName]: The user's login identifier.
  /// - [hashedPassword]: The user's hashed password.
  ///
  /// Returns a `User` object if the login is successful, or `null` if it fails.
  Future<User?> getUser({
    required String userName,
    required String hashedPassword,
  }) async {
    if (useLocalDb) {
      return await _userDatabaseRepo.getUserByName(userName);
    } else {
      ApiReturn apiResponse = await _apiConnector.getUserRepo().login(
        userName: userName,
        hashedPassword: hashedPassword,
      );
      if (!apiResponse.success) {
        return null;
      } else {
        return apiResponse.data as User;
      }
    }
  }

  /// Retrieves a `User` object, including the user's ID, based on the provided `User` object.
  ///
  /// This method logs in the user using their existing information (e.g., username and password)
  /// and retrieves the full `User` object, including their ID.
  ///
  /// - [user]: The `User` object for which to retrieve the ID.
  ///
  /// Returns the updated `User` object with the ID if successful.
  ///
  /// Throws an exception if the login fails or the user data cannot be retrieved.
  Future<User> getUserWithID({required User user}) async {
    if (useLocalDb) {
      return await _userDatabaseRepo.ensureUserID(user);
    } else {
      ApiReturn loginReturn = await _apiConnector.getUserRepo().loginUsingUser(user: user);
      if (loginReturn.success) {
        return loginReturn.data as User;
      } else {
        throw Exception(
          "Could not get ID of User ${loginReturn.returnCode}: ${loginReturn.explanation}",
        );
      }
    }
  }
}