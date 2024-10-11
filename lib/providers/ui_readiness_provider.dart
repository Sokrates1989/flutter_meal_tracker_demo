import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// A provider that manages the UI readiness state for the application.
///
/// This class is responsible for ensuring that the user interface is fully ready
/// before displaying certain screens, such as the Meals Overview Daily Screen.
/// It extends `ChangeNotifier` to allow for notifying listeners when the UI state changes.
///
/// Another asynchronous method, `__getData()`, which resides outside this class,
/// performs tasks required for the Meals Overview Daily Screen to function properly.
/// Once `__getData()` completes its task, it sets the readiness flag in this class to
/// indicate that the data is ready.
class UIReadinessProvider extends ChangeNotifier {

  /// Flags Indicating the readiness of their screens.
  ///
  /// If `false`, the screen is still loading or preparing the necessary data.
  /// Once it is ready, these flags will be set to `true`.
  bool isMealsOverViewDailyScreenReady = false;

  /// Waits until the Meals Overview Daily Screen is ready before proceeding.
  ///
  /// This method continuously checks the `isMealsOverViewDailyScreenReady` flag.
  /// If the screen is not yet ready, it waits for 50 milliseconds before checking again.
  /// The method uses recursion to keep checking until the screen becomes ready.
  ///
  /// Returns a [Future] that completes when the screen is ready.
  Future<void> awaitMealsOverviewDailyReadiness() async {
    if (!isMealsOverViewDailyScreenReady) {
      // Wait for 50 milliseconds and then recursively check again.
      await Future.delayed(const Duration(milliseconds: 50));
      return await awaitMealsOverviewDailyReadiness();
    }
  }
}
