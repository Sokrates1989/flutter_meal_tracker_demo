// Copyright (C) 2024 Patrick Michiels
// All rights reserved.
// This source code is licensed under the Evaluation License Agreement and
// may not be used, modified, or distributed without explicit permission from the author.
// This code is provided for evaluation purposes only.

import 'package:engaige_meal_tracker_demo/screens/welcome_screen.dart';
import 'package:engaige_meal_tracker_demo/utils/ui/responsive_design_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../models/sizes/widget_size_values.dart';

/// The `NavigationProvider` class is responsible for managing navigation-related
/// state across the app. This includes handling top menu navigation, back
/// navigation, and providing the appropriate AppBar title and navigation
/// destination based on the user's interaction.
///
/// The provider listens for changes and updates the UI accordingly when the
/// user navigates between screens or selects different menu items.
class NavigationProvider extends ChangeNotifier {

  /// Initializes the provider and sets the starting navigation state.
  ///
  /// [context] is required to obtain the necessary dependencies.
  NavigationProvider(this.context) {
    setStartingNavigation(context);
  }

  final BuildContext context;

  // AppBar related properties
  String _appBarTitle = tr('title');
  String get appBarTitle => _appBarTitle;
  String getAppBarTitle() {
    return _appBarTitle;
  }

  // Navigation properties
  NavigationDestination _navigationDestination = NavigationDestination.mealsOverviewDaily;
  BackNavigationDestination _backNavigationDestination = BackNavigationDestination.none;

  /// Updates the AppBar title based on the current navigation destination.
  void setAppBarTitleFromNavigationSelection() {
    switch (_navigationDestination) {
      case NavigationDestination.mealsOverviewDaily:
        _appBarTitle = tr('Notifications_appBarTitle');
        break;
      default:
        _appBarTitle = tr('title');
    }
  }


  /// Sets the initial navigation destination based on the user's subscriptions.
  ///
  /// [context] is required to access the user's data.
  Future<void> setStartingNavigation(BuildContext context) async {

    _navigationDestination = NavigationDestination.mealsOverviewDaily;

    setBackNavigationFromCurrentNavigationDestination();
    setAppBarTitleFromNavigationSelection();

    notifyListeners();
  }

  // Getters for various navigation properties.
  NavigationDestination get navigationDestination => _navigationDestination;
  BackNavigationDestination get backNavigationDestination => _backNavigationDestination;
  /// Returns the index corresponding to the current navigation menu selection.
  int getIndexForMenuSelection() {
    return 0;
  }
  /// Returns the current navigation destination.
  NavigationDestination getNavigationDestination() {
    return _navigationDestination;
  }


  /// Updates the back navigation destination based on the current screen.
  void setBackNavigationFromCurrentNavigationDestination() {
    _backNavigationDestination = BackNavigationDestination.none;
  }

  /// Navigates to a simple screen based on the [destination] provided.
  ///
  /// [destination] is the simple screen to navigate to.
  void navigateToSimpleScreen(SimpleNavigationDestination destination) {
    _navigationDestination = _getDestinationFromSimple(destination);
    setBackNavigationFromCurrentNavigationDestination();
    setAppBarTitleFromNavigationSelection();
    notifyListeners();
  }


  /// Maps the simple navigation destination to the actual navigation destination.
  ///
  /// [destination] refers to the simple screen destination to be mapped.
  NavigationDestination _getDestinationFromSimple(SimpleNavigationDestination destination) {
    return NavigationDestination.mealsOverviewDaily;
  }


  /// Navigates to the previously determined back navigation destination.
  ///
  /// [context] is required to control the navigation.
  void navigateToBackNavigationDestination(BuildContext context) {
    switch (_backNavigationDestination) {
      case BackNavigationDestination.none:
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => WelcomeScreen()));
        break;
    }
  }

  /// Returns the widget for the back navigation button.
  ///
  /// [context] is required to determine the screen size and handle the button press.
  Widget? getBackNavigation(BuildContext context) {
    final WidgetSizeValues sizes = ResponsiveDesignUtils.getBackNavigationSizes(currentScreenWidth: MediaQuery.of(context).size.width);
    Widget icon = Icon(Icons.arrow_back, size: sizes.size!, color: Colors.white);

    Function? onNavigationItemClicked;

    switch (_backNavigationDestination) {
      case BackNavigationDestination.none:
        icon = Icon(Icons.logout, size: sizes.size!, color: Colors.white);
        onNavigationItemClicked = () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => WelcomeScreen()));
        };
        break;
    }

    return Padding(
      padding: sizes.padding!,
      child: IconButton(icon: icon, onPressed: onNavigationItemClicked == null ? null : () => onNavigationItemClicked!()),
    );
  }



  // Navigation method section.

  /// Returns the current back navigation destination.
  BackNavigationDestination getBackNavigationDestination() {
    return _backNavigationDestination;
  }


}






// Enums.

/// Represents the various simple destinations within the app.
///
/// - [mealsOverviewDaily]: Day view of meals eaten on a day.
enum SimpleNavigationDestination {
  mealsOverviewDaily,
}

/// Represents the possible detailed navigation destinations within the app.
///
/// - [mealsOverviewDaily]: Day view of meals eaten on a day.
enum NavigationDestination {
  mealsOverviewDaily,
}

/// Represents the possible back navigation destinations for the app.
///
/// - [none]: No specific back destination (returns to the login screen).
enum BackNavigationDestination {
  none,
}

