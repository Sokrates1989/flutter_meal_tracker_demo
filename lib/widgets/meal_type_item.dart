import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:engaige_meal_tracker_demo/constants/colors.dart';
import 'package:engaige_meal_tracker_demo/models/meal.dart';
import 'package:engaige_meal_tracker_demo/utils/ui/responsive_design_utils.dart';

/// A widget representing a meal type item in a list.
/// This widget displays the meal type, allows editing meals, and shows current
/// meal parameters (fat and sugar levels).
class MealTypeItem extends StatelessWidget {
  final String mealType;
  final Meal? meal; // This represents the meal for this type, if available.
  final double currentScreenWidth;
  final Function onEditMeal; // Function to handle meal edit

  const MealTypeItem({
    super.key,
    required this.mealType,
    this.meal,
    required this.currentScreenWidth,
    required this.onEditMeal,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 22.0,
              ),
              title: Text(
                tr("mealType_$mealType"),
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: kColors_defaultTextColor,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    iconSize: 30.0,
                    color: kColors_mealTypeItem_addIconColor,
                    onPressed: () {
                      onEditMeal(); // Trigger edit action
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22.0),
              child: meal != null
                  ? Row(
                children: [
                  _buildTag(context, tr("fatLevel_heading"), meal!.getFatLevelString()),
                  const SizedBox(width: 8.0),
                  _buildTag(context, tr("sugarLevel_heading"), meal!.getSugarLevelString()),
                ],
              )
                  : Container(), // Show nothing if no meal data
            ),
            const SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }

  // Builds a tag for fat/sugar level (e.g., "Fett: Mittel").
  Widget _buildTag(BuildContext context, String label, String level) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.red.shade100, // Example tag color
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Text(
        "$label: $level",
        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      ),
    );
  }
}
