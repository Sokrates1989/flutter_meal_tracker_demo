// Copyright (C) 2024 Patrick Michiels
// All rights reserved.
// This source code is licensed under the Evaluation License Agreement and
// may not be used, modified, or distributed without explicit permission from the author.
// This code is provided for evaluation purposes only.

import 'package:engaige_meal_tracker_demo/storage/api_connector.dart';
import 'package:engaige_meal_tracker_demo/storage/database_wrapper.dart';
import 'package:engaige_meal_tracker_demo/storage/data_handler_repo/data_handler_user_repo.dart';
import 'package:engaige_meal_tracker_demo/storage/data_handler_repo/data_handler_meal_repo.dart';


/// The `DataHandler` class serves as the main entry point for managing
/// user data interactions with both the API and local database.
///
/// It holds instances of `ApiConnector` and `DatabaseWrapper` to provide
/// a bridge for accessing and manipulating data from both sources.
class DataHandler {
  /// Instance of `ApiConnector` for handling API-related operations.
  late ApiConnector _apiConnector;

  /// Instance of `DatabaseWrapper` for handling local database operations.
  late DatabaseWrapper _databaseWrapper;

  /// Constructor for `DataHandler`.
  ///
  /// Initializes the `ApiConnector` and `DatabaseWrapper` for data interaction.
  DataHandler() {
    _apiConnector = ApiConnector();
    _databaseWrapper = DatabaseWrapper();
  }

  /// Returns an instance of `DataHandlerUserRepo` for managing user-related
  /// data operations using both API and database.
  ///
  /// This method provides access to user-specific repository operations,
  /// which interact with both the API and the local database.
  ///
  /// Returns an instance of `DataHandlerUserRepo`.
  DataHandlerUserRepo getUserRepo() {
    return DataHandlerUserRepo(_apiConnector, _databaseWrapper);
  }


  /// Provides an instance of [DataHandlerMealRepo] for managing meal-related
  /// data operations through the API.
  ///
  /// Returns an instance of [DataHandlerMealRepo] that allows access to
  /// meal-specific repository operations.
  DataHandlerMealRepo getMealRepo() {
    return DataHandlerMealRepo(_apiConnector, _databaseWrapper);
  }
}
