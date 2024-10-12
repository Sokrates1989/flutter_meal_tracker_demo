// Public package imports.
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' hide NavigationMode;

// Own package imports.
import 'package:engaige_meal_tracker_demo/constants/colors.dart';
import 'package:engaige_meal_tracker_demo/models/user.dart';
import 'package:engaige_meal_tracker_demo/providers/ui_readiness_provider.dart';
import 'package:engaige_meal_tracker_demo/providers/navigation_provider.dart';
import 'package:engaige_meal_tracker_demo/providers/data_provider.dart';
import 'package:engaige_meal_tracker_demo/widgets/scroll_to_top_fab.dart';
import 'package:engaige_meal_tracker_demo/widgets/language_switcher.dart';

/// A screen that displays the daily overview of meals.
///
/// This screen provides a scrollable interface for viewing the details of daily meals.
/// It includes a floating action button (FAB) that allows users to quickly scroll
/// to the top of the screen. Additionally, the screen shows localized content and
/// provides a language switcher in the app bar.
class MealsDailyOverviewScreen extends StatefulWidget {
  static const String id = 'meals_overview_daily_screen';

  const MealsDailyOverviewScreen({super.key});

  @override
  State<MealsDailyOverviewScreen> createState() => _MealsDailyOverviewScreenState();
}

class _MealsDailyOverviewScreenState extends State<MealsDailyOverviewScreen> {
  /// Future to track the readiness of the `MealsDailyOverviewScreen`.
  /// The readiness flag is awaited before building the screen content.
  late Future<void> _mealsDailyOverviewScreenValuesAreReady;

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

    // Fetch required values for displaying the meal overview.
    _getData();

    // Await the readiness of the Meals Overview Daily Screen before displaying content.
    _mealsDailyOverviewScreenValuesAreReady =
        Provider.of<UIReadinessProvider>(context, listen: false)
            .awaitMealsOverviewDailyReadiness();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _mealsDailyOverviewScreenValuesAreReady,
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
      appBar: _buildCustomAppBar(context),
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

  /// Builds a custom `AppBar` for the `MealsDailyOverviewScreen`.
  PreferredSizeWidget _buildCustomAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: kColors_backgroundColorGrey,
      elevation: 0.2,
      leading: _buildAppBarLeadingWidget(context),
      title: _buildAppBarTitleWidget(),
      actions: [_buildLanguageSwitcher(context)],
      bottom: _buildAppBarBottomWidget(),
    );
  }

  /// Builds the leading widget for the `AppBar`, which includes a back button
  /// and a label for back navigation.
  Row _buildAppBarLeadingWidget(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          color: kColors_backNavigationIconColor,
          onPressed: () {
            Provider.of<NavigationProvider>(context, listen: false)
                .navigateToBackNavigationDestination(context);
          },
        ),
        Text(
          tr("mealsOverviewDaily_appBarBackNavigationText"),
          style: TextStyle(
            color: kColors_backNavigationTextColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  /// Builds the title widget for the `AppBar`, which includes a logo and the screen title.
  Center _buildAppBarTitleWidget() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Material(
            type: MaterialType.transparency,
            child: Hero(
              tag: 'logo',
              child: CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage('assets/images/meal_tracker_demo_icon_circle_400px.png'),
                backgroundColor: kColors_backgroundColorGrey,
              ),
            ),
          ),
          const SizedBox(width: 10), // Spacing between the Hero image and title
          Text(
            tr("mealsOverviewDaily_appBarTitle"),
            style: const TextStyle(
              color: kColors_defaultTextColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the language switcher widget for the `AppBar`.
  Widget _buildLanguageSwitcher(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0), // Optional padding for spacing
      child: LanguageSwitcher(
        locale: context.locale,
        dropDownIconColor: Colors.blue[700]?.withOpacity(0.8),
        flagWidth: 34,
      ),
    );
  }

  /// Builds the bottom widget for the `AppBar`, which displays a progress bar.
  PreferredSize _buildAppBarBottomWidget() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(4.0),
      child: Container(
        color: kColors_mealsOverViewScreenDaily_appBar_progressBar_color, // Progress bar color
        height: 4.0,
      ),
    );
  }

  /// Fetches the necessary data to populate the screen.
  ///
  /// This method retrieves the logged-in user data and updates the UI readiness flag
  /// to indicate when the `MealsDailyOverviewScreen` is ready.
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
