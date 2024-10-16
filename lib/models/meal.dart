// Copyright (C) 2024 Patrick Michiels
// All rights reserved.
// This source code is licensed under the Evaluation License Agreement and
// may not be used, modified, or distributed without explicit permission from the author.
// This code is provided for evaluation purposes only.

// Public package imports.
import 'dart:convert';

// Custom package imports.
import 'package:easy_localization/easy_localization.dart';

/// Represents a Meal tracked in the meal tracker application.
///
/// Each meal is associated with a date and contains information about
/// its type, fat level, and sugar level.
class Meal {
  /// The year the meal was recorded.
  final int year;

  /// The month the meal was recorded.
  final int month;

  /// The day the meal was recorded.
  final int day;

  /// The type of meal (e.g., Breakfast, Lunch, Dinner, Snack).
  final String mealType;

  /// The fat level recorded for the meal.
  final int fatLevel;

  /// The sugar level recorded for the meal.
  final int sugarLevel;

  /// Constructs a [Meal] instance.
  ///
  /// All parameters are required.
  Meal({
    required this.year,
    required this.month,
    required this.day,
    required this.mealType,
    required this.fatLevel,
    required this.sugarLevel,
  });

  /// Constructs a [Meal] instance from a [Map] for API use.
  static Meal fromMap(Map<String, dynamic> map) {
    return Meal(
      year: map['year'],
      month: map['month'],
      day: map['day'],
      mealType: map['mealType'],
      fatLevel: map['fat_level'],
      sugarLevel: map['sugar_level'],
    );
  }

  /// Constructs a [Meal] instance from a [Map] for local DB use.
  ///
  /// This version expects the map to contain keys 'fat_level', 'sugar_level', and 'name' (for mealType).
  /// The year, month, and day are handled separately via arguments (since they're likely coming from a joined query).
  static Meal fromLocalDBMap(Map<String, dynamic> map, int year, int month, int day) {
    return Meal(
      year: year,
      month: month,
      day: day,
      mealType: map['name'], // meal type name from local DB
      fatLevel: map['fat_level'],
      sugarLevel: map['sugar_level'],
    );
  }

  /// Converts the [Meal] instance into a [Map].
  ///
  /// This is useful for serialization purposes.
  Map<String, dynamic> toMap() {
    return {
      'year': year,
      'month': month,
      'day': day,
      'mealType': mealType,
      'fat_level': fatLevel,
      'sugar_level': sugarLevel,
    };
  }

  /// Converts the [Meal] instance into a JSON string.
  ///
  /// This method uses [toMap] internally for the conversion.
  String toJson() {
    return jsonEncode(toMap());
  }

  /// Constructs a [Meal] instance from a JSON string.
  ///
  /// This method decodes the JSON and passes it to [fromMap].
  static Meal fromJson(String jsonString) {
    return fromMap(jsonDecode(jsonString));
  }


  /// Converts the fat level to a string representation.
  String getFatLevelString() {
    switch (fatLevel) {
      case 0:
        return tr('fatLevel_0'); // Low
      case 1:
        return tr('fatLevel_1'); // Medium
      case 2:
        return tr('fatLevel_2'); // High
      default:
        return tr('fatLevel_unknown'); // Unknown
    }
  }

  /// Converts the sugar level to a string representation.
  String getSugarLevelString() {
    switch (sugarLevel) {
      case 0:
        return tr('sugarLevel_0'); // Low
      case 1:
        return tr('sugarLevel_1'); // Medium
      case 2:
        return tr('sugarLevel_2'); // High
      default:
        return tr('sugarLevel_unknown'); // Unknown
    }
  }
}
