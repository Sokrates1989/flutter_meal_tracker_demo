// Public package imports.
import 'package:http/http.dart' as http;

// Custom package imports.
import 'package:engaige_meal_tracker_demo/constants/authentication.dart';
import 'package:engaige_meal_tracker_demo/models/user.dart';
import 'package:engaige_meal_tracker_demo/storage/api_repo/api_user_repo.dart';

/// The `ApiConnector` class is responsible for managing interactions
/// with external APIs, such as user authentication, credentials management,
/// and handling API responses.
class ApiConnector {
  /// Constructor for `ApiConnector`.
  ///
  /// Initializes the API connector instance.
  ApiConnector();

  /// Provides an instance of `ApiUserRepo` for user-related API operations.
  ///
  /// This method returns a repository that contains user-specific API
  /// functions, like login and registration.
  ///
  /// Returns an instance of `ApiUserRepo`.
  ApiUserRepo getUserRepo() {
    return ApiUserRepo(this);
  }

  /// Returns a map containing the authentication token required for API calls.
  ///
  /// The token is retrieved from the authentication constants defined in the app.
  ///
  /// Returns a `Map<String, dynamic>` containing the API token.
  Map<String, dynamic> getAuthenticationItemMap() {
    return {
      'token': kAuthentication_apiToken,
    };
  }

  /// Returns a map containing credentials for API calls.
  ///
  /// This method is used to generate a map that contains the login identifier
  /// and hashed password, along with the authentication token.
  ///
  /// - [userName]: The user's login identifier (e.g., username or email).
  /// - [hashedPassword]: The user's hashed password.
  ///
  /// Returns a `Map<String, dynamic>` with credentials for API calls.
  Map<String, dynamic> getCredentialsItemMap({
    required String userName,
    required String hashedPassword,
  }) {
    return {
      'token': kAuthentication_apiToken,
      'userName': userName,
      'hashedPassword': hashedPassword,
    };
  }

  /// Returns a map containing credentials for API calls from a `User` object.
  ///
  /// This method is similar to [getCredentialsItemMap], but it extracts
  /// the login identifier and hashed password from a `User` object.
  ///
  /// - [user]: The `User` object containing the login identifier and hashed password.
  ///
  /// Returns a `Map<String, dynamic>` with credentials for API calls.
  Map<String, dynamic> getCredentialsItemMapFromUser({required User user}) {
    return getCredentialsItemMap(
      userName: user.userName,
      hashedPassword: user.hashedPassword!,
    );
  }

  /// Prints the HTTP response to the console.
  ///
  /// This method is useful for debugging purposes. It prints the status code,
  /// reason phrase, and body of the HTTP response.
  ///
  /// - [response]: The HTTP response to be printed.
  void printHttpResponse(http.Response response) {
    print(
        "response.statusCode: ${response.statusCode}, \nresponse.reasonPhrase: ${response.reasonPhrase}, \nresponse.body: ${response.body}");
  }
}

/// A class that represents the result of an API call.
///
/// This class encapsulates the success status, return code, explanation,
/// and optional data returned from the API.
class ApiReturn {
  ApiReturn({
    required this.success,
    required this.returnCode,
    required this.explanation,
    this.data,
  });

  /// Indicates whether the API call was successful.
  bool success;

  /// The return code from the API call (e.g., HTTP status code).
  int returnCode;

  /// A description or explanation of the result from the API.
  String explanation;

  /// Optional data returned by the API, if any.
  var data;

  /// Converts the `ApiReturn` object into its string representation.
  ///
  /// This is useful for logging or debugging the result of an API call.
  @override
  String toString() {
    return 'ApiReturn{success: $success, returnCode: $returnCode, explanation: $explanation, data: ${data ?? 'null'}}';
  }
}
