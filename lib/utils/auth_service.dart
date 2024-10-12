// Public packages imports.
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:provider/provider.dart';

// Own package imports.
import 'package:engaige_meal_tracker_demo/utils/encryption_utils.dart';
import 'package:engaige_meal_tracker_demo/storage/api_connector.dart';
import 'package:engaige_meal_tracker_demo/utils/shared_pref_utils.dart';
import 'package:engaige_meal_tracker_demo/widgets/dialogs/loading_dialog.dart';
import 'package:engaige_meal_tracker_demo/providers/data_provider.dart';
import 'package:engaige_meal_tracker_demo/storage/data_handler.dart';
import 'package:engaige_meal_tracker_demo/models/user.dart';

/// A service class that handles user authentication including login, signup,
/// and demo user authentication. It interacts with various providers, utilities,
/// and external services like encryption and shared preferences to manage the
/// authentication process.
class AuthService {
  /// The [BuildContext] used for accessing providers, dialogs, and localizations.
  final BuildContext context;

  /// Constructor for [AuthService].
  ///
  /// - [context]: The `BuildContext` used for accessing dependencies like
  /// providers and dialogs.
  AuthService(this.context);

  /// Logs in the user by verifying the provided credentials.
  ///
  /// This function checks the user's credentials by hashing the password,
  /// sending the login request, and saving the credentials locally if
  /// `rememberMe` is true.
  ///
  /// - [data]: A `LoginData` object containing the username and password.
  /// - [rememberMe]: A flag indicating if the user's credentials should be
  ///   saved for future logins.
  ///
  /// Returns `null` on successful login, or an error message otherwise.
  Future<String?> loginUser(LoginData data, bool rememberMe) async {
    LoadingDialog loadingDialog = LoadingDialog(buildContext: context);
    loadingDialog.showLoadingDialog();

    try {
      // Hash the password before sending to API
      EncryptionUtils encryptionUtils = EncryptionUtils();
      String hashedPassword = encryptionUtils.hashUserPassword(
          passwordToHash: data.password,
          userName: data.name
      );

      // Call the login API
      ApiReturn loginReturn = await Provider.of<DataProvider>(context, listen: false)
          .dataHandler
          .getUserRepo()
          .login(
        hashedPassword: hashedPassword,
        userName: data.name,
      );

      // If login is successful
      if (loginReturn.success) {
        await Provider.of<DataProvider>(context, listen: false)
            .userHasLoggedIn(loginReturn.data);

        // Save user credentials if `rememberMe` is enabled
        if (rememberMe) {
          await SharedPrefUtils().set("lastLoggedInUserName", data.name);
          await SharedPrefUtils().set("lastLoggedInUserPassword", data.password);
        }

        loadingDialog.closeLoadingDialog();
        return null;
      } else {
        loadingDialog.closeLoadingDialog();
        return '${loginReturn.returnCode}\n${loginReturn.explanation}';
      }
    } catch (e) {
      loadingDialog.closeLoadingDialog();
      return e.toString();
    }
  }

  /// Logs in the demo user automatically for testing or demonstration purposes.
  ///
  /// This function retrieves a demo user and logs them in without requiring
  /// any credentials.
  Future<void> logInDemoUserFlutterLogin() async {
    await Provider.of<DataProvider>(context, listen: false)
        .userHasLoggedIn(User.getDemoUser());
  }

  /// Registers a new user using the provided signup information.
  ///
  /// This function hashes the password, sends the registration request to the
  /// server, and saves the user's credentials locally if `rememberMe` is true.
  ///
  /// - [signupData]: A `SignupData` object containing the username and password.
  /// - [rememberMe]: A flag indicating if the user's credentials should be saved
  ///   for future logins.
  ///
  /// Returns `null` on successful registration, or an error message otherwise.
  Future<String?> signupUser(SignupData signupData, bool rememberMe) async {
    LoadingDialog loadingDialog = LoadingDialog(buildContext: context);
    loadingDialog.showLoadingDialog();

    try {
      // Hash the password before sending to API
      EncryptionUtils encryptionUtils = EncryptionUtils();
      String hashedPassword = encryptionUtils.hashUserPassword(
          userName: signupData.name!,
          passwordToHash: signupData.password!
      );

      // Call the register API
      DataHandler dataHandler = DataHandler();
      ApiReturn registrationReturn = await dataHandler
          .getUserRepo()
          .registerUser(
        hashedPassword: hashedPassword,
        userName: signupData.name!,
      );

      // If registration is successful
      if (registrationReturn.success) {
        await Provider.of<DataProvider>(context, listen: false)
            .userHasLoggedIn(registrationReturn.data);

        // Save user credentials if `rememberMe` is enabled
        if (rememberMe) {
          await SharedPrefUtils().set("lastLoggedInUserName", signupData.name!);
          await SharedPrefUtils().set("lastLoggedInUserPassword", signupData.password!);
        }

        loadingDialog.closeLoadingDialog();
        return null;
      } else {
        loadingDialog.closeLoadingDialog();
        return '${registrationReturn.returnCode}\n${registrationReturn.explanation}';
      }
    } catch (e) {
      loadingDialog.closeLoadingDialog();
      return e.toString();
    }
  }
}
