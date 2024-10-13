// Public package imports.
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

// Custom package imports.
import 'package:engaige_meal_tracker_demo/constants/colors.dart';

class MealProgressBar extends StatelessWidget {
  final int totalMeals;
  final int addedMeals;

  const MealProgressBar({
    Key? key,
    required this.totalMeals,
    required this.addedMeals,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate the progress as a fraction between 0 and 1
    double progress = addedMeals / totalMeals;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(tr('meals_added')),
              Text('$addedMeals / $totalMeals'),
            ],
          ),
          const SizedBox(height: 8.0),
          // Wrap the progress bar with ClipRRect to make rounded corners
          ClipRRect(
            borderRadius: BorderRadius.circular(30.0), // Apply rounded corners
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: kColors_mealProgressBar_backgroundColor,
              color: kColors_mealProgressBar_fillColor,
              minHeight: 8.0,
            ),
          ),
        ],
      ),
    );
  }
}

