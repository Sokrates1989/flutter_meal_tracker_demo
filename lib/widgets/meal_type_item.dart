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
  final Function onAddMeal; // Function to handle meal addition
  final Function onDeleteMeal; // Function to handle meal addition

  const MealTypeItem({
    super.key,
    required this.mealType,
    this.meal,
    required this.currentScreenWidth,
    required this.onEditMeal,
    required this.onAddMeal,
    required this.onDeleteMeal,
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
        padding: EdgeInsets.symmetric(
          vertical: meal == null ? 15.0 : 10.0,
          horizontal: 15.0,
        ),
        decoration: BoxDecoration(
          color: kColors_listTile_backgroundColor,
          borderRadius: BorderRadius.circular(38.0),
          boxShadow: const [
            BoxShadow(
              color: kColors_boxShadow,
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Column for meal title and details
            Padding(
              padding: const EdgeInsets.only(right: 50.0), // Reserve space for the icon
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMealTitle(context),
                  if (meal != null) _buildMealDetails(context),
                  if (meal != null) const SizedBox(height: 8.0),
                ],
              ),
            ),
            // Positioned trailing action button
            Positioned(
              right: 15.0,  // Adjust based on your desired spacing
              top: meal == null ? -2.0 : 15.0,     // Adjust to align properly
              child: _buildActionButton(),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the meal title row.
  Widget _buildMealTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 22.0,
      ),
      child: Text(
        tr("mealType_$mealType"),
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: kColors_defaultTextColor,
        ),
      ),
    );
  }

  /// Builds the action button (Add or Edit) depending on whether a meal exists.
  Widget _buildActionButton() {
    if (meal != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,  // Ensures the row only takes up the space it needs
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            iconSize: 30.0,
            color: kColors_mealTypeItem_iconColors,
            onPressed: () {
              onEditMeal(); // Trigger edit action
            },
          ),
          const SizedBox(width: 8.0),  // Space between edit and delete icons
          IconButton(
            icon: const Icon(Icons.delete),
            iconSize: 30.0,
            color: kColors_mealTypeItem_iconColors,  // You can change this color to fit your theme
            onPressed: () {
              onDeleteMeal(); // Trigger delete action
            },
          ),
        ],
      );
    } else {
      return IconButton(
        icon: const Icon(Icons.add_box),
        iconSize: 30.0,
        color: kColors_mealTypeItem_iconColors,
        onPressed: () {
          onAddMeal(); // Trigger add action
        },
      );
    }
  }

  /// Builds the meal details (fat level and sugar level) if a meal exists.
  Widget _buildMealDetails(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22.0),
      child: Row(
        children: [
          _buildTag(context, tr("fatLevel_heading"), meal!.getFatLevelString()),
          const SizedBox(width: 8.0),
          _buildTag(context, tr("sugarLevel_heading"), meal!.getSugarLevelString()),
        ],
      ),
    );
  }

  /// Builds a tag for displaying fat/sugar levels with distinct label and level styles.
  Widget _buildTag(BuildContext context, String label, String level) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: kColors_tagBackgroundColor,  // Background color for the outer tag
        borderRadius: BorderRadius.circular(20.0),  // Circular edges
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,  // Wraps content snugly
        children: [
          // Label section (e.g., "Fett")
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
            decoration: BoxDecoration(
              color: Colors.transparent,  // Transparent for the label
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15.0),
                bottomLeft: Radius.circular(15.0),
              ),
            ),
            child: Text(
              label,
              style: const TextStyle(
                color: kColors_tagLabelColor,  // Text color for the label
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // Level section (e.g., "Mittel")
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
            decoration: const BoxDecoration(
              color: kColors_tagLevelColor,  // Solid color for the level
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
              ),
            ),
            child: Text(
              level,
              style: const TextStyle(
                color: kColors_tagLevelTextColor,  // White text on colored background
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
