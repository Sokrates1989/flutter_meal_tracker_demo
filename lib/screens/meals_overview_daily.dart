// Public package imports.
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart' hide NavigationMode;

// Own package imports.
import 'package:engaige_meal_tracker_demo/constants/colors.dart';
import 'package:engaige_meal_tracker_demo/models/user.dart';
import 'package:engaige_meal_tracker_demo/models/meal.dart';
import 'package:engaige_meal_tracker_demo/providers/ui_readiness_provider.dart';
import 'package:engaige_meal_tracker_demo/providers/data_provider.dart';
import 'package:engaige_meal_tracker_demo/utils/custom_app_bar.dart';
import 'package:engaige_meal_tracker_demo/widgets/dialogs/loading_dialog.dart';
import 'package:engaige_meal_tracker_demo/widgets/meal_progress_bar.dart';
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
  late List<Meal>? initialMealsOfDay; // To store the initial state

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
    double screenWidth = MediaQuery.of(context).size.width;

    if (mealTypes == null || mealTypes!.isEmpty) {
      return const Center(
        child: Text('No meal types available'),
      );
    }


    // Calculate the number of added meals
    int addedMeals = mealsOfDay?.length ?? 0;
    int totalMeals = mealTypes!.length;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MealProgressBar(
            totalMeals: totalMeals,
            addedMeals: addedMeals,
          ),
          const SizedBox(height: 35),
          ListView.builder(
            shrinkWrap: true,
            // Ensures ListView takes up only the necessary space
            physics: NeverScrollableScrollPhysics(),
            // Disables internal scrolling
            itemCount: mealTypes!.length,
            itemBuilder: (context, index) {
              String mealType = mealTypes![index];
              return MealTypeItem(
                mealType: mealType,
                meal: getCorrespondingMeal(
                    mealsOfDay: mealsOfDay, mealType: mealType),
                currentScreenWidth: screenWidth,
                onAddMeal: () {
                  _showAddEditMealDialog(
                    context: context,
                    mealType: mealType,
                    isEdit: false,
                    meal: null,
                  );
                },
                onEditMeal: () {
                  _showAddEditMealDialog(
                    context: context,
                    mealType: mealType,
                    isEdit: true,
                    meal: getCorrespondingMeal(
                        mealsOfDay: mealsOfDay, mealType: mealType),
                  );
                },
                onDeleteMeal: () {
                  setState(() {
                    // Find and remove the meal from mealsOfDay
                    mealsOfDay!.removeWhere((meal) => meal.mealType == mealType);
                  });
                },
              );
            },
          ),
          const SizedBox(height: 20),
          // Add spacing between the list and the buttons
          if (haveMealsChanged()) _buildSaveCancelButtons(),
          // Conditionally show buttons
        ],
      ),
    );
  }

  Widget _buildSaveCancelButtons() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Save Button (ElevatedButton with rounded corners and specific color)
          ElevatedButton(
            onPressed: _saveChanges, // Define your save logic here
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red, // Button background color
              minimumSize: const Size(200, 45), // Set a specific size
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0), // Rounded corners
              ),
            ),
            child: Text(
              tr('Save'),
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white, // White text color
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Cancel Button (OutlinedButton with rounded corners)
          OutlinedButton(
            onPressed: _cancelChanges, // Define your cancel logic here
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red, // Text and border color
              side: const BorderSide(color: Colors.red), // Red border
              minimumSize: const Size(200, 45), // Set a specific size
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0), // Rounded corners
              ),
            ),
            child: Text(
              tr('Cancel'),
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black, // Black text color
              ),
            ),
          ),
        ],
      ),
    );
  }


  void _saveChanges() async {
    // Instantiate the LoadingDialog
    LoadingDialog loadingDialog = LoadingDialog(buildContext: context);

    // Show the loading dialog before starting the API operations
    loadingDialog.showLoadingDialog();

    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    final dataHandlerMealRepo = dataProvider.dataHandler.getMealRepo();

    // Lists to store meals that need to be added, edited, or deleted
    List<Meal> mealsToAdd = [];
    List<Meal> mealsToEdit = [];
    List<Meal> mealsToDelete = [];

    // Compare mealsOfDay with initialMealsOfDay for additions and edits
    for (Meal meal in mealsOfDay!) {
      final correspondingInitialMeal = initialMealsOfDay!.firstWhere(
            (initialMeal) => initialMeal.mealType == meal.mealType,
        orElse: () => Meal(
          year: meal.year,
          month: meal.month,
          day: meal.day,
          mealType: "",
          fatLevel: -1,
          sugarLevel: -1,
        ),
      );

      // If the meal is not found in initialMealsOfDay, it needs to be added
      if (correspondingInitialMeal.mealType == "") {
        mealsToAdd.add(meal);
      } else if (meal.toJson() != correspondingInitialMeal.toJson()) {
        // If the meal exists but its data has changed, it needs to be edited
        mealsToEdit.add(meal);
      }
    }

    // Identify meals to delete (present in initialMealsOfDay but not in mealsOfDay)
    for (Meal initialMeal in initialMealsOfDay!) {
      final correspondingCurrentMeal = mealsOfDay!.firstWhere(
            (currentMeal) => currentMeal.mealType == initialMeal.mealType,
        orElse: () => Meal(
          year: initialMeal.year,
          month: initialMeal.month,
          day: initialMeal.day,
          mealType: "",
          fatLevel: -1,
          sugarLevel: -1,
        ),
      );

      // If the meal is not found in mealsOfDay, it needs to be deleted
      if (correspondingCurrentMeal.mealType == "") {
        mealsToDelete.add(initialMeal);
      }
    }

    // Handle adding new meals
    for (Meal newMeal in mealsToAdd) {
      bool success = await dataHandlerMealRepo.addMeal(meal: newMeal, user: user);
      if (!success) {
        // Handle failure to add meal (e.g., show an error message)
        print("Failed to add meal: ${newMeal.mealType}");
      }
    }

    // Handle editing existing meals
    for (Meal updatedMeal in mealsToEdit) {
      bool success = await dataHandlerMealRepo.editMeal(meal: updatedMeal, user: user);
      if (!success) {
        // Handle failure to edit meal (e.g., show an error message)
        print("Failed to edit meal: ${updatedMeal.mealType}");
      }
    }

    // Handle deleting meals
    for (Meal mealToDelete in mealsToDelete) {
      bool success = await dataHandlerMealRepo.deleteMeal(meal: mealToDelete, user: user);
      if (!success) {
        // Handle failure to delete meal (e.g., show an error message)
        print("Failed to delete meal: ${mealToDelete.mealType}");
      }
    }

    // Update the initialMealsOfDay to reflect the current state
    setState(() {
      initialMealsOfDay =
          List.from(mealsOfDay!.map((meal) => Meal.fromMap(meal.toMap())));
    });

    // Close the loading dialog once all operations are complete
    loadingDialog.closeLoadingDialog();
  }



  void _cancelChanges() {
    setState(() {
      // Cancel changes logic - revert mealsOfDay to the initial state
      mealsOfDay = List.from(
          initialMealsOfDay!.map((meal) => Meal.fromMap(meal.toMap())));
    });
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

    // Store a deep copy of mealsOfDay in initialMealsOfDay
    initialMealsOfDay =
        List.from(mealsOfDay!.map((meal) => Meal.fromMap(meal.toMap())));

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

  bool haveMealsChanged() {
    if (mealsOfDay == null || initialMealsOfDay == null) return false;

    if (mealsOfDay!.length != initialMealsOfDay!.length) return true;

    for (int i = 0; i < mealsOfDay!.length; i++) {
      if (mealsOfDay![i].toJson() != initialMealsOfDay![i].toJson()) {
        return true;
      }
    }

    return false;
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

  void _showAddEditMealDialog({
    required BuildContext context,
    required String mealType,
    required bool isEdit,
    Meal? meal,
  }) {
    // Pre-select values if in edit mode
    int selectedFatLevel = meal?.fatLevel ?? 1; // Default to 1
    int selectedSugarLevel = meal?.sugarLevel ?? 1; // Default to 1

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              contentPadding: EdgeInsets.zero,
              content: Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tr("mealType_$mealType"),
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Text(tr("fatLevel_dialogHeading")),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSelectionButton(
                          context: context,
                          label: tr('fatLevel_0'),
                          isSelected: selectedFatLevel == 0,
                          onTap: () {
                            setDialogState(() {
                              selectedFatLevel = 0;
                            });
                          },
                        ),
                        _buildSelectionButton(
                          context: context,
                          label: tr('fatLevel_1'),
                          isSelected: selectedFatLevel == 1,
                          onTap: () {
                            setDialogState(() {
                              selectedFatLevel = 1;
                            });
                          },
                        ),
                        _buildSelectionButton(
                          context: context,
                          label: tr('fatLevel_2'),
                          isSelected: selectedFatLevel == 2,
                          onTap: () {
                            setDialogState(() {
                              selectedFatLevel = 2;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Text(tr("sugarLevel_dialogHeading")),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSelectionButton(
                          context: context,
                          label: tr('sugarLevel_0'),
                          isSelected: selectedSugarLevel == 0,
                          onTap: () {
                            setDialogState(() {
                              selectedSugarLevel = 0;
                            });
                          },
                        ),
                        _buildSelectionButton(
                          context: context,
                          label: tr('sugarLevel_1'),
                          isSelected: selectedSugarLevel == 1,
                          onTap: () {
                            setDialogState(() {
                              selectedSugarLevel = 1;
                            });
                          },
                        ),
                        _buildSelectionButton(
                          context: context,
                          label: tr('sugarLevel_2'),
                          isSelected: selectedSugarLevel == 2,
                          onTap: () {
                            setDialogState(() {
                              selectedSugarLevel = 2;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 30.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.cancel, color: Colors.red),
                          onPressed: () {
                            Navigator.pop(context); // Close the dialog
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.check, color: Colors.green),
                          onPressed: () {
                            // Create a new Meal object with the selected values
                            Meal newMeal = Meal(
                              year: DateTime.now().year,
                              month: DateTime.now().month,
                              day: DateTime.now().day,
                              mealType: mealType,
                              fatLevel: selectedFatLevel,
                              sugarLevel: selectedSugarLevel,
                            );

                            setState(() {
                              if (isEdit) {
                                // Find and replace the existing meal in mealsOfDay
                                int index = mealsOfDay!.indexWhere(
                                    (meal) => meal.mealType == mealType);
                                if (index != -1) {
                                  mealsOfDay![index] = newMeal;
                                }
                              } else {
                                // Add the new meal to mealsOfDay
                                mealsOfDay!.add(newMeal);
                              }
                            });

                            // Close the dialog.
                            Navigator.pop(context); // Close the dialog
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSelectionButton({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.red : Colors.transparent,
          border: Border.all(
            color: isSelected ? Colors.red : Colors.black,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Remove scroll listener and dispose of the scroll controller.
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.dispose();
  }
}
