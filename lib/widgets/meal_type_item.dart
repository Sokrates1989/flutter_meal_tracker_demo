// Public package imports.
import 'package:easy_localization/easy_localization.dart';
import 'package:engaige_meal_tracker_demo/utils/ui/responsive_design_utils.dart';
import 'package:flutter/material.dart';

// Custom package imports.
import 'package:engaige_meal_tracker_demo/constants/colors.dart';

/// A widget representing a meal type item in a list.
///
/// The `MealTypeItem` displays a meal type with an "add" button, allowing the user
/// to add meals. The widget adjusts its padding based on the current screen width
/// for responsive design.
class MealTypeItem extends StatelessWidget {
  /// The meal type string to be displayed.
  final String mealType;

  /// The current screen width used for responsive padding adjustments.
  final double currentScreenWidth;

  const MealTypeItem({
    super.key,
    required this.mealType,
    required this.currentScreenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: ResponsiveDesignUtils.getOptimalHorizontalPadding(
          minPadding: 16.0,
          currentScreenWidth: currentScreenWidth,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 22.0),
          title: Text(
            tr("mealType_$mealType"),
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: kColors_defaultTextColor,
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.add_box),
            iconSize: 30.0,
            color: kColors_mealTypeItem_addIconColor, // Customize your icon color here
            onPressed: () {
              // Handle the logic to add a meal here
            },
          ),
        ),
      ),
    );
  }
}
