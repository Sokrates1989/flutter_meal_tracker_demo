import 'dart:convert';

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

  /// Constructs a [Meal] instance from a [Map].
  ///
  /// Expects the map to contain keys for 'year', 'month', 'day', 'mealType', 'fatLevel', and 'sugarLevel'.
  static Meal fromMap(Map<String, dynamic> map) {
    return Meal(
      year: map['year'],
      month: map['month'],
      day: map['day'],
      mealType: map['mealType'],
      fatLevel: map['fatLevel'],
      sugarLevel: map['sugarLevel'],
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
      'fatLevel': fatLevel,
      'sugarLevel': sugarLevel,
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
}
