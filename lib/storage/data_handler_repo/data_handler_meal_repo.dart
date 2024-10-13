// Copyright (C) 2024 Patrick Michiels
// All rights reserved.
// This source code is licensed under the Evaluation License Agreement and
// may not be used, modified, or distributed without explicit permission from the author.
// This code is provided for evaluation purposes only.

import 'package:engaige_meal_tracker_demo/storage/api_connector.dart';
import 'package:engaige_meal_tracker_demo/models/meal.dart';
import 'package:engaige_meal_tracker_demo/models/user.dart';
import 'package:engaige_meal_tracker_demo/storage/database_repo/meal_database_repo.dart';
import 'package:engaige_meal_tracker_demo/storage/database_wrapper.dart';
import 'package:engaige_meal_tracker_demo/utils/os_utils.dart';

/// The `DataHandlerMealRepo` class is responsible for handling meal-related operations,
/// either through the local database or the API, depending on the availability of local database support.
///
/// It contains methods for fetching meal types, retrieving meals for specific days, adding new meals,
/// editing existing meals, and deleting meals.
class DataHandlerMealRepo {
  final ApiConnector _apiConnector;
  final MealDatabaseRepo _mealDatabaseRepo;
  final bool useLocalDb;

  /// Constructs an instance of `DataHandlerMealRepo`.
  ///
  /// - `_apiConnector`: The API connector used to communicate with the backend.
  /// - `_databaseWrapper`: The database wrapper used to interact with the local database.
  DataHandlerMealRepo(this._apiConnector, DatabaseWrapper databaseWrapper)
      : _mealDatabaseRepo = MealDatabaseRepo(databaseWrapper),
        useLocalDb = OSUtils.isLocalDatabaseSupportedOnHostOS();

  /// Fetches all meal types either from the local database or the API, depending on the availability of local database support.
  ///
  /// - [user]: The `User` object representing the current user.
  ///
  /// Returns a `Future<List<String>?>` containing meal types, or `null` if the request fails.
  Future<List<String>?> getMealTypes(User user) async {
    if (useLocalDb) {
      // Fetch meal types from the local database
      return await _mealDatabaseRepo.getMealTypes();
    } else {
      // Fetch meal types from the API
      final ApiReturn apiResponse = await _apiConnector.getMealRepo().getMealTypes(user);
      if (!apiResponse.success) {
        return null;
      }
      return List<String>.from(apiResponse.data.map((meal) => meal['name']));
    }
  }

  /// Fetches meals for a specific day from either the local database or the API.
  ///
  /// - [user]: The `User` object representing the current user.
  /// - [day]: The date for which to fetch the meals. If not provided, defaults to today.
  ///
  /// Returns a `Future<List<Meal>?>` containing the meals for the specified day, or `null` if the request fails.
  Future<List<Meal>?> getMeals({required User user, DateTime? day}) async {
    day ??= DateTime.now();

    if (useLocalDb) {
      // Fetch meals from the local database
      return await _mealDatabaseRepo.getMealsForDay(user.ID, day.year, day.month, day.day);
    } else {
      // Fetch meals from the API
      final ApiReturn apiResponse = await _apiConnector.getMealRepo().getMeals(day: day, user: user);
      if (!apiResponse.success) {
        return null;
      }
      return List<Meal>.from(apiResponse.data.map((meal) => Meal.fromMap(meal)));
    }
  }

  /// Adds a new meal to either the local database or the API.
  ///
  /// - [meal]: The `Meal` object containing the meal details to be added.
  /// - [user]: The `User` object representing the current user.
  ///
  /// Returns a `Future<bool>` indicating whether the meal was successfully added.
  Future<bool> addMeal({required Meal meal, required User user}) async {
    if (useLocalDb) {
      // Add meal to the local database
      await _mealDatabaseRepo.addMeal(meal: meal, userID: user.ID);
      return true;
    } else {
      // Add meal via the API
      final ApiReturn apiResponse = await _apiConnector.getMealRepo().addMeal(meal: meal, user: user);
      return apiResponse.success;
    }
  }

  /// Edits an existing meal in either the local database or the API.
  ///
  /// - [meal]: The `Meal` object containing the updated meal details.
  /// - [user]: The `User` object representing the current user.
  ///
  /// Returns a `Future<bool>` indicating whether the meal was successfully edited.
  Future<bool> editMeal({required Meal meal, required User user}) async {
    if (useLocalDb) {
      // Edit meal in the local database
      return await _mealDatabaseRepo.updateMeal(meal: meal, userID: user.ID);
    } else {
      final ApiReturn apiResponse = await _apiConnector.getMealRepo().editMeal(meal: meal, user: user);
      return apiResponse.success;
    }
  }

  /// Deletes an existing meal from either the local database or the API.
  ///
  /// - [meal]: The `Meal` object representing the meal to be deleted.
  /// - [user]: The `User` object representing the current user.
  ///
  /// Returns a `Future<bool>` indicating whether the meal was successfully deleted.
  Future<bool> deleteMeal({required Meal meal, required User user}) async {
    if (useLocalDb) {
      // Delete meal from the local database
      return await _mealDatabaseRepo.deleteMeal(meal: meal, userID: user.ID);
    } else {
      final ApiReturn apiResponse = await _apiConnector.getMealRepo().deleteMeal(meal: meal, user: user);
      return apiResponse.success;
    }
  }
}
