// Public package imports.
import 'dart:convert';
import 'package:http/http.dart' as http;

// Own package imports.
import 'package:engaige_meal_tracker_demo/constants/config.dart';
import 'package:engaige_meal_tracker_demo/storage/api_connector.dart';
import 'package:engaige_meal_tracker_demo/models/meal.dart';
import 'package:engaige_meal_tracker_demo/models/user.dart';

/// The `ApiMealRepo` class handles meal-related API operations.
///
/// It uses the [ApiConnector] to make requests and interact with the backend
/// for fetching and adding meals, among other meal-related operations.
class ApiMealRepo {
  /// Instance of [ApiConnector] to manage interactions with the API.
  final ApiConnector _apiConnector;

  /// Base URL for the API, fetched from the application configuration.
  final String _baseUrl = kConfig_apiBaseUrl;

  /// Constructs an instance of [ApiMealRepo] with a provided [ApiConnector].
  ApiMealRepo(this._apiConnector);

  /// Fetches all available meal types from the API.
  ///
  /// This method sends a GET request to the API endpoint to retrieve the list of
  /// meal types. It returns an [ApiReturn] object with the success status,
  /// explanation, and the meal types (if successful).
  ///
  /// Returns an [ApiReturn] containing the result of the operation.
  Future<ApiReturn> getMealTypes(User user) async {
    final String apiEndpointUrl = '$_baseUrl/v1/getMealTypes';

    // Construct the request body with credentials.
    final body = json.encode(
      _apiConnector.getCredentialsItemMap(
        userName: user.userName,
        hashedPassword: user.hashedPassword!,
      ),
    );

    try {
      // Sending the POST request to fetch meal types.
      final response = await http.post(
        Uri.parse(apiEndpointUrl),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      // Handling successful response with status code 200.
      if (response.statusCode == 200) {
        final mealTypes = jsonDecode(response.body)['mealTypes'];
        return ApiReturn(
          success: true,
          returnCode: 200,
          explanation: 'Successfully fetched meal types',
          data: mealTypes,
        );
      } else {
        // Print and return the response in case of a non-200 status.
        _apiConnector.printHttpResponse(response);
        return ApiReturn(
          success: false,
          returnCode: response.statusCode,
          explanation: '${response.reasonPhrase} ${response.body}',
        );
      }
    } catch (e) {
      // Handling any errors that occur during the request.
      return ApiReturn(
        success: false,
        returnCode: 599,
        explanation: e.toString(),
      );
    }
  }


  /// Fetches meals for a specific day (defaults to the current day).
  ///
  /// This method sends a request to retrieve meals for the provided day. If no
  /// day is provided, it defaults to the current date.
  ///
  /// Returns an [ApiReturn] containing the result of the operation.
  Future<ApiReturn> getMeals({required User user, DateTime? day}) async {
    // If no day is provided, use today's date
    day ??= DateTime.now();

    // Format the day into a string (yyyy-MM-dd) to send to the API
    final String apiEndpointUrl = '$_baseUrl/v1/getMeals';

    // Construct the request body with credentials and date.
    final getDayMealsItemMap = {
      'credentials': _apiConnector.getCredentialsItemMap(userName: user.userName, hashedPassword: user.hashedPassword!),
      'year': day.year,
      'month': day.month,
      'day': day.day,
    };
    final body = json.encode(getDayMealsItemMap);

    try {
      // Sending the POST request to fetch meals for the specific day
      final response = await http.post(
        Uri.parse(apiEndpointUrl),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      // Handling successful response with status code 200
      if (response.statusCode == 200) {
        final meals = jsonDecode(response.body)['meals'];
        return ApiReturn(
          success: true,
          returnCode: 200,
          explanation: 'Successfully fetched meals',
          data: meals,
        );
      } else {
        _apiConnector.printHttpResponse(response);
        return ApiReturn(
          success: false,
          returnCode: response.statusCode,
          explanation: '${response.reasonPhrase} ${response.body}',
        );
      }
    } catch (e) {
      // Handling any errors that occur during the request
      return ApiReturn(
        success: false,
        returnCode: 599,
        explanation: e.toString(),
      );
    }
  }


  /// Adds a new meal entry to the backend via the API.
  ///
  /// This method sends a POST request to add a meal to the database. It
  /// constructs a request body containing the meal details and credentials
  /// required for the operation.
  ///
  /// Returns an [ApiReturn] containing the result of the operation.
  Future<ApiReturn> addMeal(Meal meal) async {
    final String apiEndpointUrl = '$_baseUrl/v1/addMeal';

    // Constructing the request body with meal details and credentials.
    final mealItemMap = {
      'credentials': _apiConnector.getAuthenticationItemMap(),
      'year': meal.year,
      'month': meal.month,
      'day': meal.day,
      'mealType': meal.mealType,
      'fat_level': meal.fatLevel,
      'sugar_level': meal.sugarLevel,
    };

    final body = json.encode(mealItemMap);

    try {
      // Sending the POST request to add a meal.
      final response = await http.post(
        Uri.parse(apiEndpointUrl),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      // Handling successful response with status code 200.
      if (response.statusCode == 200) {
        return ApiReturn(
          success: true,
          returnCode: 200,
          explanation: 'Successfully added meal',
        );
      } else {
        // Print and return the response in case of a non-200 status.
        _apiConnector.printHttpResponse(response);
        return ApiReturn(
          success: false,
          returnCode: response.statusCode,
          explanation: '${response.reasonPhrase} ${response.body}',
        );
      }
    } catch (e) {
      // Handling any errors that occur during the request.
      return ApiReturn(
        success: false,
        returnCode: 599,
        explanation: e.toString(),
      );
    }
  }
}
