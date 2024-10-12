// Public package imports.
import 'package:provider/provider.dart';
import 'package:flutter/material.dart' hide NavigationMode;

// Own package imports.
import 'package:engaige_meal_tracker_demo/constants/colors.dart';
import 'package:engaige_meal_tracker_demo/models/user.dart';
import 'package:engaige_meal_tracker_demo/models/meal.dart';
import 'package:engaige_meal_tracker_demo/providers/ui_readiness_provider.dart';
import 'package:engaige_meal_tracker_demo/providers/data_provider.dart';
import 'package:engaige_meal_tracker_demo/utils/custom_app_bar.dart';
import 'package:engaige_meal_tracker_demo/widgets/meal_type_item.dart';
import 'package:engaige_meal_tracker_demo/widgets/scroll_to_top_fab.dart';

/// A screen that displays the daily overview of meals.
///
/// This screen provides a scrollable interface for viewing daily meal details.
/// It includes a floating action button (FAB) that allows users to quickly scroll
/// to the top of the screen. Additionally, it shows localized content and
/// provides a language switcher in the app bar.
class MealsDailyOverviewScreen extends StatefulWidget {
  /// Screen identifier for navigation.
  static const String id = 'meals_overview_daily_screen';

  const MealsDailyOverviewScreen({super.key});

  @override
  State<MealsDailyOverviewScreen> createState() =>
      _MealsDailyOverviewScreenState();
}

class _MealsDailyOverviewScreenState extends State<MealsDailyOverviewScreen> {
  /// Future to track the readiness of the `MealsDailyOverviewScreen`.
  /// The readiness flag is awaited before building the screen content.
  late Future<void> _screenReadyFuture;

  /// The user object holding logged-in user details.
  late final User user;

  /// A list of meal types for each day to build the UI.
  late final List<String>? mealTypes;

  /// The list of meals the user tracked.
  late List<Meal>? mealsOfDay;

  /// Scroll controller to manage scrolling within the screen.
  final ScrollController scrollController = ScrollController();

  /// Flag to control the visibility of the scroll-to-top button.
  bool showScrollToTopBtn = false;

  @override
  void initState() {
    super.initState();

    // Listen to scroll events to show or hide the scroll-to-top button.
    scrollController.addListener(_scrollListener);

    // Fetch required data for displaying the meal overview.
    _getData();

    // Await readiness of the screen.
    _screenReadyFuture =
        Provider.of<UIReadinessProvider>(context, listen: false)
            .awaitMealsOverviewDailyReadiness();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _screenReadyFuture,
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
          // Build the main screen content after readiness is confirmed.
          return _buildScreenContent(context);
        }
      },
    );
  }

  /// Builds the screen content once the necessary data is loaded.
  Scaffold _buildScreenContent(BuildContext context) {
    return Scaffold(
      backgroundColor: kColors_backgroundColor_default,
      appBar: CustomAppBar(context: context),
      floatingActionButton: ScrollToTopFloatingActionButton(
        scrollController: scrollController,
        showScrollToTopBtn: showScrollToTopBtn,
      ),
      body: _buildAppBody(),
    );
  }

  /// Builds the main body of the screen.
  Widget _buildAppBody() {
    // Get current screen width for responsive UI.
    double screenWidth = MediaQuery.of(context).size.width;

    // Display a message if no meal types are available.
    if (mealTypes == null || mealTypes!.isEmpty) {
      return const Center(
        child: Text('No meal types available'),
      );
    }

    // Return a scrollable list of meal types.
    return Column(
      children: [
        const SizedBox(height: 35), // Add spacer at the top.
        Expanded(
          child: ListView.builder(
            itemCount: mealTypes!.length,
            itemBuilder: (context, index) {
              String mealType = mealTypes![index];
              return MealTypeItem(
                mealType: mealType,
                meal: getCorrespondingMeal(
                    mealsOfDay: mealsOfDay, mealType: mealType),
                currentScreenWidth: screenWidth,
                onEditMeal: () {
                  print("Edit Meal Button clicked");
                },
                onAddMeal: () {
                  print("Add Meal Button clicked");
                },
              );
            },
          ),
        ),
      ],
    );
  }

  /// Fetches the necessary data to populate the screen.
  ///
  /// Retrieves the logged-in user data and updates the UI readiness flag
  /// to indicate when the `MealsDailyOverviewScreen` is ready.
  Future<void> _getData() async {
    if (!mounted) return;

    // Access necessary providers.
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    final uiReadinessProvider =
        Provider.of<UIReadinessProvider>(context, listen: false);

    // Indicate that the screen values are being fetched.
    uiReadinessProvider.isMealsOverViewDailyScreenReady = false;

    // Fetch and set the logged-in user data.
    user = await dataProvider.getLoggedInUser_async();

    // Fetch the meal types from the database.
    mealTypes = await dataProvider.dataHandler.getMealRepo().getMealTypes(user);

    // Fetch the meals tracked for the current day.
    mealsOfDay =
        await dataProvider.dataHandler.getMealRepo().getMeals(user: user);

    // Indicate that the screen values are fully loaded.
    uiReadinessProvider.isMealsOverViewDailyScreenReady = true;
  }

  /// Listens to scroll events and shows or hides the scroll-to-top button.
  void _scrollListener() {
    const double showOffset =
        10.0; // Show button when scrolled past 10.0 offset.

    setState(() {
      showScrollToTopBtn = scrollController.offset > showOffset;
    });
  }

  Meal? getCorrespondingMeal(
      {required String mealType, required List<Meal>? mealsOfDay}) {
    // Check if mealsOfDay is null or empty
    if (mealsOfDay == null || mealsOfDay.isEmpty) {
      return null;
    }

    // Loop through the list of meals
    for (Meal meal in mealsOfDay) {
      // Check if the mealType matches
      if (meal.mealType == mealType) {
        return meal; // Return the matching meal
      }
    }

    // If no matching meal is found, return null
    return null;
  }

  @override
  void dispose() {
    // Remove scroll listener and dispose of the scroll controller.
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.dispose();
  }
}
