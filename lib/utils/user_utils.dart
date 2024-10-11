import 'package:engaige_meal_tracker_demo/utils/shared_pref_utils.dart';
import 'package:engaige_meal_tracker_demo/storage/data_handler.dart';
import 'package:engaige_meal_tracker_demo/models/user.dart';
import 'package:engaige_meal_tracker_demo/utils/encryption_utils.dart';

class UserUtils {
  final SharedPrefUtils sharedPref = SharedPrefUtils();
  final EncryptionUtils encryptionUtils = EncryptionUtils();
  final DataHandler dataHandler = DataHandler();

  /// Fetches the logged-in user information from shared preferences.
  ///
  /// This method retrieves the last logged-in username and password from
  /// shared preferences and attempts to authenticate the user using these credentials.
  /// It returns the [User] object if found, or `null` if no user is logged in.
  ///
  /// Returns a [Future] that completes with the logged-in [User] or `null`.ds, or null otherwise.
  Future<User?> getLoggedInUser() async {
    String savedUserName = await sharedPref.get("lastLoggedInUserName");
    String savedPassword = await sharedPref.get("lastLoggedInUserPassword");

    if (savedUserName.isEmpty || savedPassword.isEmpty) return null;

    String savedPasswordHash = encryptionUtils.hashUserPassword(
        passwordToHash: savedPassword, userName: savedUserName);

    return await dataHandler.getUserRepo().getUser(
        userName: savedUserName, hashedPassword: savedPasswordHash);
  }
}
