import 'package:engaige_meal_tracker_demo/models/user.dart';
import 'package:engaige_meal_tracker_demo/storage/api_connector.dart';
import 'package:engaige_meal_tracker_demo/storage/database_wrapper.dart';

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

  /// Constructor for `DataHandlerUserRepo`.
  ///
  /// - [_apiConnector]: The `ApiConnector` to handle API calls.
  /// - [_databaseWrapper]: The `DatabaseWrapper` to interact with the local database.
  DataHandlerUserRepo(this._apiConnector, this._databaseWrapper);

  /// Registers a new user using the API.
  ///
  /// This method sends a registration request to the API with the user's login
  /// identifier and hashed password.
  ///
  /// - [userName]: The user's login identifier (e.g., username or email).
  /// - [hashedPassword]: The user's hashed password.
  /// - [isTelegramLogin]: A flag to indicate if the user is registering via Telegram.
  ///
  /// Returns an `ApiReturn` object containing the response from the API.
  Future<ApiReturn> registerUser({
    required String userName,
    required String hashedPassword,
    required bool isTelegramLogin,
  }) async {
    ApiReturn apiResponse = await _apiConnector.getUserRepo().registerUser(
      userName: userName,
      hashedPassword: hashedPassword,
      isTelegramLogin: isTelegramLogin,
    );
    return apiResponse;
  }

  /// Logs in a user using the API.
  ///
  /// This method sends a login request to the API with the user's login identifier
  /// and hashed password.
  ///
  /// - [userName]: The user's login identifier (e.g., username or email).
  /// - [hashedPassword]: The user's hashed password.
  ///
  /// Returns an `ApiReturn` object containing the response from the API.
  Future<ApiReturn> login({
    required String userName,
    required String hashedPassword,
  }) async {
    ApiReturn apiResponse = await _apiConnector.getUserRepo().login(
      userName: userName,
      hashedPassword: hashedPassword,
    );
    return apiResponse;
  }

  /// Logs in a user and retrieves the user data if successful.
  ///
  /// This method sends a login request to the API and returns the `User` object
  /// if the login is successful. If not, it returns `null`.
  ///
  /// - [userName]: The user's login identifier (e.g., username or email).
  /// - [hashedPassword]: The user's hashed password.
  ///
  /// Returns a `User` object if the login is successful, or `null` otherwise.
  Future<User?> getUser({
    required String userName,
    required String hashedPassword,
  }) async {
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

  /// Retrieves a `User` object, including the user's ID, based on the provided `User` object.
  ///
  /// This method logs in the user using their existing information (e.g., username and password)
  /// and retrieves the full `User` object, including the user's ID.
  ///
  /// - [user]: The `User` object to retrieve the ID for.
  ///
  /// Returns the updated `User` object with the ID.
  ///
  /// Throws an exception if the login fails or the user data cannot be retrieved.
  Future<User> getUserWithID({required User user}) async {
    ApiReturn loginReturn =
    await _apiConnector.getUserRepo().loginUsingUser(user: user);
    if (loginReturn.success) {
      return loginReturn.data as User;
    } else {
      throw Exception(
        "Could not get ID of User ${loginReturn.returnCode}: ${loginReturn.explanation}",
      );
    }
  }
}
