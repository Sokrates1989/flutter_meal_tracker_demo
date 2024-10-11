import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:engaige_meal_tracker_demo/storage/data_handler.dart';
import 'package:engaige_meal_tracker_demo/models/user.dart';

/// The `DataProvider` class manages the state of user data and handles interactions
/// with the data layer, such as user login, logout, and data fetching.
///
/// It extends `ChangeNotifier` to notify listeners when state changes, allowing UI elements
/// to react to changes in user authentication and data.
class DataProvider extends ChangeNotifier {
  /// Instance of `DataHandler` for managing data operations.
  final DataHandler dataHandler = DataHandler();

  // User-related state.
  User? _loggedInUser;
  bool _userIsLoggedIn = false;

  /// Retrieves the currently logged-in user asynchronously.
  ///
  /// If no user is logged in, it defaults to returning the demo user.
  /// If `ensureUserIDIsSet` is true, it will ensure the user has an ID by fetching
  /// the user's ID if it's not set.
  ///
  /// - [ensureUserIDIsSet]: Whether to ensure the user has an ID. Defaults to `false`.
  ///
  /// Returns a `User` object representing the logged-in user.
  Future<User> getLoggedInUser_async({bool? ensureUserIDIsSet}) async {
    if (_userIsLoggedIn) {
      // Get the current user or return the demo user.
      User user = _loggedInUser ?? User.getDemoUser();

      // Ensure the user ID is set if required.
      if (user.ID == 0 && (ensureUserIDIsSet ?? false)) {
        user = await dataHandler.getUserRepo().getUserWithID(user: user);
        _loggedInUser = user;
      }
      return user;
    } else {
      // If the user is not logged in, delay the function call until user login is complete.
      await Future.delayed(const Duration(milliseconds: 100));
      return await getLoggedInUser_async(
          ensureUserIDIsSet: ensureUserIDIsSet ?? false);
    }
  }

  /// Retrieves the currently logged-in user.
  ///
  /// This method should only be called when you're sure the user has been set up correctly.
  /// If no user is logged in, it defaults to returning the demo user.
  ///
  /// Returns a `User` object representing the logged-in user.
  User getLoggedInUser() {
    return _loggedInUser ?? User.getDemoUser();
  }

  /// Marks the user as logged in and stores the `loggedInUser` data.
  ///
  /// - [loggedInUser]: The `User` object representing the logged-in user.
  Future<void> userHasLoggedIn(User loggedInUser) async {
    _loggedInUser = loggedInUser;
    _userIsLoggedIn = true;
    notifyListeners(); // Notifies listeners that the user login state has changed.
  }

  /// Logs out the current user and resets the user state.
  ///
  /// This method sets the `_loggedInUser` to `null` and notifies listeners of the state change.
  void userHasLoggedOut() {
    _loggedInUser = null;
    _userIsLoggedIn = false;
    notifyListeners(); // Notifies listeners that the user has logged out.
  }
}
