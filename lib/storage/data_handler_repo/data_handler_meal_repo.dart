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
