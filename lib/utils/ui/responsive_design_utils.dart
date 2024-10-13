// Copyright (C) 2024 Patrick Michiels
// All rights reserved.
// This source code is licensed under the Evaluation License Agreement and
// may not be used, modified, or distributed without explicit permission from the author.
// This code is provided for evaluation purposes only.

// Public package imports.
import 'package:flutter/material.dart' hide NavigationMode;

// Custom package imports.
import 'package:engaige_meal_tracker_demo/constants/sizes.dart';
import 'package:engaige_meal_tracker_demo/models/sizes/widget_size_values.dart';

/// A utility class that provides responsive design functions.
///
/// This class adjusts the sizes of various UI components such as text, padding,
/// and flags, depending on the current screen width.
class ResponsiveDesignUtils {
  ResponsiveDesignUtils();

  /// Returns the font size for the screen title, adjusted according to the screen width.
  ///
  /// The size is interpolated between 21 and 31, depending on the screen width.
  ///
  /// - [currentScreenWidth]: The current width of the screen.
  ///
  /// Returns the adjusted screen title size.
  static double getScreenTitleSize(double currentScreenWidth) {
    return interpolateBestDouble(
        InterpolationDoubleValues(min: 21, max: 31), currentScreenWidth);
  }

  /// Returns the width of the screen title, adjusted based on the screen width.
  ///
  /// If the screen width exceeds 1100, the value is capped to 1100.
  ///
  /// - [currentScreenWidth]: The current width of the screen.
  ///
  /// Returns the adjusted screen title width.
  static double getScreenTitleWidth(double currentScreenWidth) {
    if (currentScreenWidth > 1100) {
      currentScreenWidth = 1100;
    }
    return currentScreenWidth * 0.80;
  }

  /// Returns the font size for list item titles, adjusted according to the screen width.
  ///
  /// The size is interpolated between 17 and 23, depending on the screen width.
  ///
  /// - [currentScreenWidth]: The current width of the screen.
  ///
  /// Returns the adjusted list item title font size.
  static double getListItemTitleFontSize(double currentScreenWidth) {
    return interpolateBestDouble(
        InterpolationDoubleValues(min: 17, max: 23), currentScreenWidth);
  }

  /// Returns the padding for panels, adjusted according to the screen width.
  ///
  /// The padding is interpolated between 5 and 20, depending on the screen width.
  ///
  /// - [currentScreenWidth]: The current width of the screen.
  ///
  /// Returns the adjusted panel padding.
  static double getPanelPadding(double currentScreenWidth) {
    return interpolateBestDouble(
        InterpolationDoubleValues(min: 5, max: 20), currentScreenWidth);
  }

  /// Returns the width for the user setting flag, adjusted according to the screen width.
  ///
  /// The width is interpolated between 30 and 42, depending on the screen width.
  ///
  /// - [currentScreenWidth]: The current width of the screen.
  ///
  /// Returns the adjusted width for the user setting flag.
  static double getUserSettingFlagWidth(double currentScreenWidth) {
    return interpolateBestDouble(
        InterpolationDoubleValues(min: 30, max: 42), currentScreenWidth);
  }

  /// Returns the height for the user setting flag, adjusted according to the screen width.
  ///
  /// The height is interpolated between 15 and 23, depending on the screen width.
  ///
  /// - [currentScreenWidth]: The current width of the screen.
  ///
  /// Returns the adjusted height for the user setting flag.
  static double getUserSettingFlagHeight(double currentScreenWidth) {
    return interpolateBestDouble(
        InterpolationDoubleValues(min: 15, max: 23), currentScreenWidth);
  }

  /// Returns the maximum width for the settings tile text, adjusted according to the screen width.
  ///
  /// The width is interpolated between 100 and 700, with a maximum of 1000.
  ///
  /// - [currentScreenWidth]: The current width of the screen.
  ///
  /// Returns the adjusted maximum width for the settings tile text.
  static double getSettingsTileTextMaxWidth(double currentScreenWidth) {
    return interpolateBestDouble(
        InterpolationDoubleValues(min: 100, max: 700, maxWidth: 1000),
        currentScreenWidth);
  }

  /// Calculates the optimal horizontal padding to ensure the content width does not exceed 800px.
  ///
  /// This method adjusts the padding based on the current screen width. If the screen width exceeds
  /// the maximum allowed width for the widget, the padding is adjusted to center the content.
  ///
  /// - [minPadding]: The minimum padding to apply if no adjustments are needed.
  /// - [currentScreenWidth]: The current width of the screen.
  ///
  /// Returns the optimal padding value to be used with `EdgeInsets`.
  static double getOptimalHorizontalPadding({
    required double minPadding,
    required double currentScreenWidth,
    double? maxWidgetWidthOverwrite,
  }) {
    double optimalPadding = minPadding;
    double maxWidgetWidthWithoutPadding = maxWidgetWidthOverwrite ?? kSizes_maxWidgetWidth;
    double maxAllowedWidth = maxWidgetWidthWithoutPadding + (minPadding * 2);

    // Adjust the padding to center the content if the screen exceeds the maximum allowed width.
    if (currentScreenWidth > maxAllowedWidth) {
      optimalPadding = (currentScreenWidth - maxWidgetWidthWithoutPadding) / 2;
    }

    return optimalPadding;
  }

  /// Returns the size and padding for the back navigation icon, adjusted according to the screen width.
  ///
  /// - [currentScreenWidth]: The current width of the screen.
  ///
  /// Returns the adjusted sizes and padding for the back navigation icon.
  static WidgetSizeValues getBackNavigationSizes({
    required double currentScreenWidth,
  }) {
    WidgetSizeValues widgetSizeValues = WidgetSizeValues();
    widgetSizeValues.size = interpolateBestDouble(
        InterpolationDoubleValues(min: 35, max: 45), currentScreenWidth);
    widgetSizeValues.padding = EdgeInsets.only(
      left: interpolateBestDouble(
          InterpolationDoubleValues(min: 5, max: 10), currentScreenWidth),
    );

    return widgetSizeValues;
  }
  /// Interpolates a value between a minimum and maximum range based on the screen width.
  /// Optionally inverts the logic, returning higher values for smaller widths and
  /// lower values for larger widths if [invertedLogic] is set to true.
  ///
  /// - [values]: An `InterpolationDoubleValues` object containing the min, max, minWidth, and maxWidth values.
  /// - [currentScreenWidth]: The current width of the screen.
  /// - [invertedLogic]: A boolean flag that reverses the interpolation logic if set to true.
  ///
  /// Returns the interpolated value.
  static double interpolateBestDouble(
      InterpolationDoubleValues values, double currentScreenWidth, {bool invertedLogic = false}) {
    double interpolatedValue;

    if (invertedLogic) {
      // Invert the logic: smaller screen width returns higher values and vice versa
      interpolatedValue = values.max -
          (values.max - values.min) *
              (currentScreenWidth - values.minWidth) /
              (values.maxWidth - values.minWidth);
    } else {
      // Normal interpolation: smaller screen width returns lower values
      interpolatedValue = values.min +
          (values.max - values.min) *
              (currentScreenWidth - values.minWidth) /
              (values.maxWidth - values.minWidth);
    }

    // Ensure the interpolated value stays within the range of [min, max]
    return interpolatedValue.clamp(values.min, values.max);
  }

}

/// A data class that holds the minimum and maximum values for interpolation.
///
/// It is used to store the min/max values for dynamic sizing based on screen width.
class InterpolationDoubleValues {
  InterpolationDoubleValues({
    this.minWidth = kSizes_minScreenWidth,
    this.maxWidth = kSizes_maxWidgetWidth,
    required this.min,
    required this.max,
  });

  /// The minimum screen width to start interpolation.
  double minWidth;

  /// The maximum screen width to stop interpolation.
  double maxWidth;

  /// The minimum value to interpolate from.
  double min;

  /// The maximum value to interpolate to.
  double max;
}
