// Public package imports.
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Custom package imports.
import 'package:engaige_meal_tracker_demo/constants/colors.dart';
import 'package:engaige_meal_tracker_demo/constants/themes.dart';
import 'package:engaige_meal_tracker_demo/models/user.dart';
import 'package:engaige_meal_tracker_demo/providers/data_provider.dart';
import 'package:engaige_meal_tracker_demo/providers/navigation_provider.dart';
import 'package:engaige_meal_tracker_demo/providers/ui_readiness_provider.dart';
import 'package:engaige_meal_tracker_demo/screens/meals_overview_daily.dart';
import 'package:engaige_meal_tracker_demo/screens/welcome_screen.dart';
import 'package:engaige_meal_tracker_demo/utils/UI/ui_utils.dart';
import 'package:engaige_meal_tracker_demo/utils/user_utils.dart';

/// Entry point for the application.
///
/// This method initializes the app, sets up localization, retrieves the
/// user's login state, and configures system UI settings.
void main() async {
  // Ensures that Flutter framework bindings are initialized before performing any actions.
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // Fetch the currently logged-in user, if any, from local storage (shared preferences).
  User? user = await UserUtils().getLoggedInUser();

  // Set system bar styles for enhanced UI appearance on Android.
  UIUtils.makeSystemBarTransparent();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'), // English language support.
        Locale('de'), // German language support.
      ],
      path: 'assets/lang', // Path to localization asset files.
      child: MyApp(user: user), // Passes the logged-in user to the app.
    ),
  );
}

/// Root widget for the application.
///
/// This widget configures the core features of the app, including state management,
/// themes, localization, and routing. It decides whether to show the [WelcomeScreen]
/// or the [MealsDailyOverviewScreen] based on the user's login status.
class MyApp extends StatefulWidget {
  /// The currently logged-in user, if any. Passed to this widget at initialization.
  final User? user;

  const MyApp({super.key, this.user});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      /// A wrapper to provide multiple `ChangeNotifierProvider` instances in the app.
      ///
      /// This structure allows different parts of the app to access shared state objects
      /// (such as [DataProvider], [NavigationProvider], and [UIReadinessProvider])
      /// from a single point of initialization.
      providers: [
        // Manages all data-related operations for the app.
        ChangeNotifierProvider(create: (context) => DataProvider()),

        // Handles navigation and routing within the app.
        ChangeNotifierProvider(create: (context) => NavigationProvider(context)),

        // Tracks and monitors the readiness of UI components (e.g., ensures data is fully loaded).
        ChangeNotifierProvider(create: (context) => UIReadinessProvider()),
      ],

      child: MaterialApp(
        /// The main configuration for the app, defining its themes, localization,
        /// and routing structure using the `MaterialApp` widget, the core Flutter app widget.
        theme: ThemeData(
          primaryColor: kColors_primary, // Primary color for app elements such as buttons.
          scaffoldBackgroundColor: Colors.white, // Default background color for the app screens.

          /// Defines the color scheme used throughout the app.
          /// - [primary]: The main theme color for major UI elements like buttons and app bars.
          /// - [secondary]: The accent color used for highlights or smaller UI elements.
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: kColors_primary,
            secondary: kColors_secondary,
          ),

          // Configures the default styling for input fields (e.g., text boxes) across the app.
          inputDecorationTheme: kThemes_mainTheme_inputDecorationTheme,
        ),

        /// Delegates responsible for handling localization, such as loading the correct
        /// language files and applying translations based on the user's locale.
        localizationsDelegates: context.localizationDelegates,

        /// Supported locales for the app. Each locale corresponds to a set of
        /// localized strings stored in the `assets/lang` directory.
        supportedLocales: context.supportedLocales,

        /// The current locale of the app, derived from either the user's device settings
        /// or their language preference in the app.
        locale: context.locale,

        /// Determines the initial screen to display based on the user's login state.
        ///
        /// - If the user is logged in, the [MealsDailyOverviewScreen] is shown.
        /// - If no user is logged in, the [WelcomeScreen] is displayed.
        home: widget.user == null
            ? const WelcomeScreen() // Show welcome screen if no user is logged in.
            : const MealsDailyOverviewScreen(), // Show meal overview if the user is logged in.

        /// Defines the named routes for navigation within the app.
        ///
        /// This allows the app to navigate between screens by using route names.
        routes: {
          MealsDailyOverviewScreen.id: (context) => const MealsDailyOverviewScreen(),
        },
      ),
    );
  }
}
