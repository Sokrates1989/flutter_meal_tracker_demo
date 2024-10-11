// Public package imports.
import 'dart:convert';
import 'package:http/http.dart' as http;

// Custom package imports.
import 'package:engaige_meal_tracker_demo/constants/config.dart';
import 'package:engaige_meal_tracker_demo/models/user.dart';
import 'package:engaige_meal_tracker_demo/storage/api_connector.dart';

/// The `ApiUserRepo` class handles API operations related to user registration and login.
///
/// It interacts with the `ApiConnector` to perform HTTP requests for user-related operations
/// like registering a new user or logging in an existing user.
class ApiUserRepo {
  /// Reference to the `ApiConnector` for managing API calls.
  final ApiConnector _apiConnector;

  /// The base URL for the API.
  final String _baseUrl = kConfig_apiBaseUrl;

  /// Constructor for `ApiUserRepo`.
  ///
  /// - [_apiConnector]: The API connector instance for API communication.
  ApiUserRepo(this._apiConnector);

  /// Registers a new user via the API.
  ///
  /// This method sends a request to the API to register a user using the login identifier
  /// and hashed password. If registration is successful, a `User` object is returned.
  ///
  /// - [userName]: The user's login identifier (e.g., username or email).
  /// - [hashedPassword]: The user's hashed password.
  /// - [isTelegramLogin]: A flag to indicate if the user is registering via Telegram.
  ///
  /// Returns an `ApiReturn` object with the result of the registration request.
  Future<ApiReturn> registerUser({
    required String userName,
    required String hashedPassword,
    required bool isTelegramLogin,
  }) async {
    String apiEndpointUrl = '$_baseUrl/v1/register';
    Map credentialsItemMap = _apiConnector.getCredentialsItemMap(
      userName: userName,
      hashedPassword: hashedPassword,
    );
    var body = json.encode(credentialsItemMap);

    http.Response response;
    try {
      response = await http.post(
        Uri.parse(apiEndpointUrl),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );
    } catch (e) {
      return ApiReturn(
        success: false,
        returnCode: 599,
        explanation: e.toString(),
      );
    }

    if (response.statusCode == 200) {
      User user = getUserFromHttpResponse(response);
      return ApiReturn(
        success: true,
        returnCode: 200,
        explanation: 'Successfully registered new user',
        data: user,
      );
    } else {
      _apiConnector.printHttpResponse(response);
      return ApiReturn(
        success: false,
        returnCode: response.statusCode,
        explanation: '${response.reasonPhrase} ${response.body}',
      );
    }
  }

  /// Logs in a user via the API.
  ///
  /// This method sends a login request to the API using the login identifier and hashed password.
  /// If login is successful, a `User` object is returned.
  ///
  /// - [userName]: The user's login identifier (e.g., username or email).
  /// - [hashedPassword]: The user's hashed password.
  ///
  /// Returns an `ApiReturn` object with the result of the login request.
  Future<ApiReturn> login({
    required String userName,
    required String hashedPassword,
  }) async {
    String apiEndpointUrl = '$_baseUrl/v1/login';
    Map credentialsItemMap = _apiConnector.getCredentialsItemMap(
      userName: userName,
      hashedPassword: hashedPassword,
    );
    var body = json.encode(credentialsItemMap);

    http.Response response;
    try {
      response = await http.post(
        Uri.parse(apiEndpointUrl),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );
    } catch (e) {
      return ApiReturn(
        success: false,
        returnCode: 599,
        explanation: e.toString(),
      );
    }

    if (response.statusCode == 200) {
      User user = getUserFromHttpResponse(response);
      return ApiReturn(
        success: true,
        returnCode: 200,
        explanation: 'Successfully logged in user',
        data: user,
      );
    } else {
      _apiConnector.printHttpResponse(response);
      return ApiReturn(
        success: false,
        returnCode: response.statusCode,
        explanation: '${response.reasonPhrase} ${response.body}',
      );
    }
  }

  /// Logs in a user using a `User` object via the API.
  ///
  /// This method logs in the user using their existing `User` object details.
  ///
  /// - [user]: The `User` object containing the login credentials.
  ///
  /// Returns an `ApiReturn` object with the result of the login request.
  Future<ApiReturn> loginUsingUser({
    required User user,
  }) async {
    String userName = user.userName;
    String hashedPassword = user.hashedPassword ?? "";
    return login(userName: userName, hashedPassword: hashedPassword);
  }

  /// Extracts the `User` object from the HTTP response.
  ///
  /// This method parses the HTTP response body and converts it into a `User` object.
  ///
  /// - [response]: The HTTP response containing the user data.
  ///
  /// Returns a `User` object.
  User getUserFromHttpResponse(http.Response response) {
    var userJsonDecoded = jsonDecode(utf8.decode(response.bodyBytes));
    return User.fromMap(userJsonDecoded);
  }
}
