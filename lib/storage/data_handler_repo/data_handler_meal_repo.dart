import 'package:engaige_meal_tracker_demo/storage/api_connector.dart';
import 'package:engaige_meal_tracker_demo/models/meal.dart';
import 'package:engaige_meal_tracker_demo/models/user.dart';

/// The `DataHandlerMealRepo` class is responsible for handling meal-related operations
/// through the API, including fetching meal types and adding new meals.
class DataHandlerMealRepo {
  /// Reference to the `ApiConnector` for API communication.
  final ApiConnector _apiConnector;

  /// Constructs an instance of `DataHandlerMealRepo`.
  ///
  /// - [_apiConnector]: The API connector used to interact with the backend.
  DataHandlerMealRepo(this._apiConnector);

  /// Fetches all meal types from the API.
  ///
  /// This method interacts with the API to retrieve a list of meal types and returns it
  /// as a list of strings. If the API call fails, it returns `null`.
  ///
  /// Returns a `Future<List<String>?>` containing meal types or `null` if the request fails.
  Future<List<String>?> getMealTypes(User user) async {
    final ApiReturn apiResponse = await _apiConnector.getMealRepo().getMealTypes(user);

    // If the API request was not successful, return null.
    if (!apiResponse.success) {
      return null;
    }

    // Map the API response data to a list of meal type names (strings).
    final List<String> mealTypes = List<String>.from(
      apiResponse.data.map((meal) => meal['name']),
    );

    return mealTypes;
  }


  /// Fetches meals for a specific day (defaults to the current day).
  ///
  /// This method interacts with the API to fetch meals for the provided day.
  /// If no day is provided, it defaults to the current date.
  ///
  /// - [user]: The `User` object representing the current user.
  /// - [day]: (Optional) The date for which to fetch the meals. If not provided, defaults to today.
  ///
  /// Returns a `Future<List<Meal>?>` containing the meals for the specified day, or `null` if the request fails.
  Future<List<Meal>?> getMeals({required User user, DateTime? day}) async {
    // Use today's date if no day is provided
    day ??= DateTime.now();

    // Fetch meals from the API
    final ApiReturn apiResponse = await _apiConnector.getMealRepo().getMeals(day: day, user: user);

    // If the API request was not successful, return null.
    if (!apiResponse.success) {
      return null;
    }

    // Map the API response data to a list of Meal objects using fromMap
    final List<Meal> meals = List<Meal>.from(
      apiResponse.data.map((meal) => Meal.fromMap(meal)),
    );

    return meals;
  }

  /// Adds a new meal to the database via the API.
  ///
  /// This method sends a new `Meal` object to the API to be stored in the database.
  /// It returns `true` if the operation was successful, otherwise `false`.
  ///
  /// - [meal]: The `Meal` object containing the meal details to be added.
  ///
  /// Returns a `Future<bool>` indicating whether the meal was successfully added.
  Future<bool> addMeal(Meal meal) async {
    final ApiReturn apiResponse = await _apiConnector.getMealRepo().addMeal(meal);

    // Return the success status of the API call.
    return apiResponse.success;
  }
}
