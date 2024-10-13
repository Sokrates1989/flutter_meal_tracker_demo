// Copyright (C) 2024 Patrick Michiels
// All rights reserved.
// This source code is licensed under the Evaluation License Agreement and
// may not be used, modified, or distributed without explicit permission from the author.
// This code is provided for evaluation purposes only.

// Public package imports.
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

// Custom package imports.
import 'package:engaige_meal_tracker_demo/constants/colors.dart';
import 'package:engaige_meal_tracker_demo/constants/sizes.dart';
import 'package:engaige_meal_tracker_demo/utils/ui/responsive_design_utils.dart';

class MealProgressBar extends StatelessWidget {
  final int totalMeals;
  final int addedMeals;
  final double currentScreenWidth;

  const MealProgressBar({
    Key? key,
    required this.totalMeals,
    required this.addedMeals,
    required this.currentScreenWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate the progress as a fraction between 0 and 1
    double progress = addedMeals / totalMeals;

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: ResponsiveDesignUtils.getOptimalHorizontalPadding(
          minPadding: 8.0,
          currentScreenWidth: currentScreenWidth,
          maxWidgetWidthOverwrite: kSizes_progressBar_maxWidth,
        ),
      ),
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

