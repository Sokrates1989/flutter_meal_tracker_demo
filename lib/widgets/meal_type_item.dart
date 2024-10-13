// Copyright (C) 2024 Patrick Michiels
// All rights reserved.
// This source code is licensed under the Evaluation License Agreement and
// may not be used, modified, or distributed without explicit permission from the author.
// This code is provided for evaluation purposes only.

// Public package imports.
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

// Custom package imports.
import 'package:engaige_meal_tracker_demo/constants/colors.dart';
import 'package:engaige_meal_tracker_demo/models/meal.dart';
import 'package:engaige_meal_tracker_demo/utils/ui/responsive_design_utils.dart';
import 'package:engaige_meal_tracker_demo/constants/sizes.dart';

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
          vertical: getInnerVerticalPadding(),
          horizontal: getInnerHorizontalPadding(),
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
              right: getActionButtonRightPosition(),  // Adjust based on your desired spacing
              top: getActionButtonTopPosition(),     // Adjust to align properly
              child: _buildActionButton(),
            ),
          ],
        ),
      ),
    );
  }


  /// Gets action button right position responsively.
  double getActionButtonRightPosition() {
    return ResponsiveDesignUtils.interpolateBestDouble(
        InterpolationDoubleValues(
            min: kSizes_mealTypeItem_actionButtons_rightPosition_min,
            max: kSizes_mealTypeItem_actionButtons_rightPosition_max),
        currentScreenWidth);
  }



  /// Gets action button top position responsively.
  double getActionButtonTopPosition() {
    double topPosition = 10.0;
    if (meal == null) {
      topPosition = ResponsiveDesignUtils.interpolateBestDouble(
          InterpolationDoubleValues(
              min: kSizes_mealTypeItem_actionButtons_topPosition_noMealYet_min,
              max: kSizes_mealTypeItem_actionButtons_topPosition_noMealYet_max),
          currentScreenWidth,
          invertedLogic: true);
    }
    else {
      topPosition = ResponsiveDesignUtils.interpolateBestDouble(
          InterpolationDoubleValues(
              min: kSizes_mealTypeItem_actionButtons_topPosition_mealAlreadySet_min,
              max: kSizes_mealTypeItem_actionButtons_topPosition_mealAlreadySet_max),
          currentScreenWidth);
    }
    return topPosition;
  }

  /// Gets inner vertical padding responsively.
  double getInnerVerticalPadding() {
    double verticalPadding = 10.0;
    if (meal == null) {
      verticalPadding = ResponsiveDesignUtils.interpolateBestDouble(
          InterpolationDoubleValues(
              min: kSizes_mealTypeItem_innerPadding_noMealYet_vertical_min,
              max: kSizes_mealTypeItem_innerPadding_noMealYet_vertical_max),
          currentScreenWidth);
    }
    else {
      verticalPadding = ResponsiveDesignUtils.interpolateBestDouble(
          InterpolationDoubleValues(
              min: kSizes_mealTypeItem_innerPadding_mealAlreadySet_vertical_min,
              max: kSizes_mealTypeItem_innerPadding_mealAlreadySet_vertical_max),
          currentScreenWidth);
    }
    return verticalPadding;
  }

  /// Gets inner horizontal padding responsively.
  double getInnerHorizontalPadding() {
    return ResponsiveDesignUtils.interpolateBestDouble(
        InterpolationDoubleValues(
            min: kSizes_mealTypeItem_innerPadding_horizontal_min,
            max: kSizes_mealTypeItem_innerPadding_horizontal_max),
        currentScreenWidth);
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
        style: TextStyle(
          fontSize: ResponsiveDesignUtils.interpolateBestDouble(
              InterpolationDoubleValues(
                  min: kSizes_mealTypeItem_title_font_min,
                  max: kSizes_mealTypeItem_title_font_max),
              currentScreenWidth),
          fontWeight: FontWeight.bold,
          color: kColors_defaultTextColor,
        ),
      ),
    );
  }

  /// Builds the action button (Add or Edit) depending on whether a meal exists.
  /// Builds the action button (Add, Edit, Delete) depending on whether a meal exists.
  Widget _buildActionButton() {
    if (meal != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,  // Ensures the row only takes up the space it needs
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            iconSize: ResponsiveDesignUtils.interpolateBestDouble(
              InterpolationDoubleValues(
                min: kSizes_mealTypeItem_actionButtons_iconSize_min,
                max: kSizes_mealTypeItem_actionButtons_iconSize_max,
              ),
              currentScreenWidth,
            ),
            color: kColors_mealTypeItem_iconColors,
            onPressed: () {
              onEditMeal(); // Trigger edit action
            },
          ),
          SizedBox(
            width: ResponsiveDesignUtils.interpolateBestDouble(
              InterpolationDoubleValues(
                min: kSizes_mealTypeItem_actionButtons_spacing_min,
                max: kSizes_mealTypeItem_actionButtons_spacing_max,
              ),
              currentScreenWidth,
            ),
          ),  // Dynamic space between edit and delete icons
          IconButton(
            icon: const Icon(Icons.delete),
            iconSize: ResponsiveDesignUtils.interpolateBestDouble(
              InterpolationDoubleValues(
                min: kSizes_mealTypeItem_actionButtons_iconSize_min,
                max: kSizes_mealTypeItem_actionButtons_iconSize_max,
              ),
              currentScreenWidth,
            ),
            color: kColors_mealTypeItem_iconColors,
            onPressed: () {
              onDeleteMeal(); // Trigger delete action
            },
          ),
        ],
      );
    } else {
      return IconButton(
        icon: const Icon(Icons.add_box),
        iconSize: ResponsiveDesignUtils.interpolateBestDouble(
          InterpolationDoubleValues(
            min: kSizes_mealTypeItem_actionButtons_iconSize_min,
            max: kSizes_mealTypeItem_actionButtons_iconSize_max,
          ),
          currentScreenWidth,
        ),
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
      padding: EdgeInsets.all(
        ResponsiveDesignUtils.interpolateBestDouble(
          InterpolationDoubleValues(
            min: kSizes_mealTypeItem_mealDetailsTag_padding_min,
            max: kSizes_mealTypeItem_mealDetailsTag_padding_max,
          ),
          currentScreenWidth,
        ),
      ),
      decoration: BoxDecoration(
        color: kColors_tagBackgroundColor,  // Background color for the outer tag
        borderRadius: BorderRadius.circular(
          ResponsiveDesignUtils.interpolateBestDouble(
            InterpolationDoubleValues(
              min: kSizes_mealTypeItem_mealDetailsTag_borderRadius_min,
              max: kSizes_mealTypeItem_mealDetailsTag_borderRadius_max,
            ),
            currentScreenWidth,
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,  // Wraps content snugly
        children: [
          // Label section (e.g., "Fett")
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveDesignUtils.interpolateBestDouble(
                InterpolationDoubleValues(
                  min: kSizes_mealTypeItem_mealDetailsTag_paddingHorizontal_min,
                  max: kSizes_mealTypeItem_mealDetailsTag_paddingHorizontal_max,
                ),
                currentScreenWidth,
              ),
              vertical: ResponsiveDesignUtils.interpolateBestDouble(
                InterpolationDoubleValues(
                  min: kSizes_mealTypeItem_mealDetailsTag_paddingVertical_min,
                  max: kSizes_mealTypeItem_mealDetailsTag_paddingVertical_max,
                ),
                currentScreenWidth,
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.transparent,  // Transparent for the label
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(
                  ResponsiveDesignUtils.interpolateBestDouble(
                    InterpolationDoubleValues(
                      min: kSizes_mealTypeItem_mealDetailsTag_cornerRadius_min,
                      max: kSizes_mealTypeItem_mealDetailsTag_cornerRadius_max,
                    ),
                    currentScreenWidth,
                  ),
                ),
                bottomLeft: Radius.circular(
                  ResponsiveDesignUtils.interpolateBestDouble(
                    InterpolationDoubleValues(
                      min: kSizes_mealTypeItem_mealDetailsTag_cornerRadius_min,
                      max: kSizes_mealTypeItem_mealDetailsTag_cornerRadius_max,
                    ),
                    currentScreenWidth,
                  ),
                ),
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: kColors_tagLabelColor,  // Text color for the label
                fontSize: ResponsiveDesignUtils.interpolateBestDouble(
                  InterpolationDoubleValues(
                    min: kSizes_mealTypeItem_mealDetailsTag_fontSizeLabel_min,
                    max: kSizes_mealTypeItem_mealDetailsTag_fontSizeLabel_max,
                  ),
                  currentScreenWidth,
                ),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // Level section (e.g., "Mittel")
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveDesignUtils.interpolateBestDouble(
                InterpolationDoubleValues(
                  min: kSizes_mealTypeItem_mealDetailsTag_paddingHorizontal_min,
                  max: kSizes_mealTypeItem_mealDetailsTag_paddingHorizontal_max,
                ),
                currentScreenWidth,
              ),
              vertical: ResponsiveDesignUtils.interpolateBestDouble(
                InterpolationDoubleValues(
                  min: kSizes_mealTypeItem_mealDetailsTag_paddingVertical_min,
                  max: kSizes_mealTypeItem_mealDetailsTag_paddingVertical_max,
                ),
                currentScreenWidth,
              ),
            ),
            decoration: BoxDecoration(
              color: kColors_tagLevelColor,  // Solid color for the level
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(
                  ResponsiveDesignUtils.interpolateBestDouble(
                    InterpolationDoubleValues(
                      min: kSizes_mealTypeItem_mealDetailsTag_cornerRadius_min,
                      max: kSizes_mealTypeItem_mealDetailsTag_cornerRadius_max,
                    ),
                    currentScreenWidth,
                  ),
                ),
                bottomRight: Radius.circular(
                  ResponsiveDesignUtils.interpolateBestDouble(
                    InterpolationDoubleValues(
                      min: kSizes_mealTypeItem_mealDetailsTag_cornerRadius_min,
                      max: kSizes_mealTypeItem_mealDetailsTag_cornerRadius_max,
                    ),
                    currentScreenWidth,
                  ),
                ),
              ),
            ),
            child: Text(
              level,
              style: TextStyle(
                color: kColors_tagLevelTextColor,  // White text on colored background
                fontSize: ResponsiveDesignUtils.interpolateBestDouble(
                  InterpolationDoubleValues(
                    min: kSizes_mealTypeItem_mealDetailsTag_fontSizeLevel_min,
                    max: kSizes_mealTypeItem_mealDetailsTag_fontSizeLevel_max,
                  ),
                  currentScreenWidth,
                ),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }


}
