// Public packages imports.
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' hide NavigationMode;

// Own package imports.
import 'package:engaige_meal_tracker_demo/constants/colors.dart';
import 'package:engaige_meal_tracker_demo/providers/ui_readiness_provider.dart';
import 'package:engaige_meal_tracker_demo/widgets/scroll_to_top_fab.dart';
import 'package:engaige_meal_tracker_demo/models/user.dart';
import 'package:engaige_meal_tracker_demo/providers/data_provider.dart';

/// A screen that displays the daily overview of meals.
///
/// This screen shows meal details for the day and provides a scrollable interface.
/// It includes a floating action button that scrolls the view to the top when pressed.
class MealsDailyOverviewScreen extends StatefulWidget {
  static const String id = 'meals_overview_daily_screen';

  const MealsDailyOverviewScreen({super.key});

  @override
  State<MealsDailyOverviewScreen> createState() => _MealsDailyOverviewScreenState();
}

class _MealsDailyOverviewScreenState extends State<MealsDailyOverviewScreen> {
  /// Future to track the readiness of the notification settings screen.
  /// The readiness flag is awaited before building the screen content.
  late Future<void> _notificationSettingsScreenValuesAreReady;

  /// The user object holding logged-in user details.
  late final User user;

  /// Scroll controller to manage scrolling within the screen.
  ScrollController scrollController = ScrollController();

  /// Flag to control the visibility of the scroll-to-top button.
  bool showScrollToTopBtn = false;

  @override
  void initState() {
    super.initState();

    // Listen to scrolling events to show or hide the scroll-to-top button.
    scrollController.addListener(() {
      const double showOffset = 10.0; // Show button when scrolled past 10.0 offset.

      if (scrollController.offset > showOffset) {
        setState(() {
          showScrollToTopBtn = true;
        });
      } else {
        setState(() {
          showScrollToTopBtn = false;
        });
      }
    });

    // Fetch required values for displaying meal overview.
    _getData();

    // Await the readiness of the Meals Overview Daily Screen before displaying content.
    _notificationSettingsScreenValuesAreReady =
        Provider.of<UIReadinessProvider>(context, listen: false)
            .awaitMealsOverviewDailyReadiness();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _notificationSettingsScreenValuesAreReady,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while waiting for the screen to be ready.
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          // Display an error message if something went wrong.
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          // Build the main screen content after the readiness is confirmed.
          return buildScreenAfterFutureResolved(context);
        }
      },
    );
  }

  /// Builds the screen content once the necessary data is loaded.
  Scaffold buildScreenAfterFutureResolved(BuildContext context) {
    return Scaffold(
      backgroundColor: kColors_backgroundColorGrey,
      floatingActionButton: ScrollToTopFloatingActionButton(
        scrollController: scrollController,
        showScrollToTopBtn: showScrollToTopBtn,
      ),
      body: Column(
        children: [
          Text(tr("Test")),
        ],
      ),
    );
  }

  /// Fetches the necessary data to populate the screen.
  ///
  /// This method retrieves the logged-in user data and updates the UI readiness flag
  /// to indicate when the Meals Overview Daily Screen is ready.
  /// The UI readiness state is managed by [UIReadinessProvider].
  ///
  /// It ensures that providers are properly initialized before accessing them.
  Future<void> _getData() async {
    // Ensure the widget is mounted before accessing context.
    if (!mounted) {
      return;
    }

    // Accessing necessary providers.
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    final uiReadinessProvider = Provider.of<UIReadinessProvider>(context, listen: false);

    // Indicate that the screen values are being built.
    uiReadinessProvider.isMealsOverViewDailyScreenReady = false;

    // Fetch and set the logged-in user data.
    user = await dataProvider.getLoggedInUser_async();

    // Indicate that the screen values are fully loaded.
    uiReadinessProvider.isMealsOverViewDailyScreenReady = true;
  }
}
