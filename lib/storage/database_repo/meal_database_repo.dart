// Public package imports.
import 'package:sqflite/sqflite.dart';

// Custom package imports.
import 'package:engaige_meal_tracker_demo/models/meal.dart';
import 'package:engaige_meal_tracker_demo/storage/database_wrapper.dart';

/// The `MealDatabaseRepo` class provides repository methods for meal-related
/// database operations. It interacts with the `DatabaseWrapper` to perform
/// CRUD operations and manage meal data in the local database.
class MealDatabaseRepo {
  /// Reference to the `DatabaseWrapper` for database interaction.
  final DatabaseWrapper _databaseWrapper;

  /// Constructor for `MealDatabaseRepo`.
  ///
  /// - [_databaseWrapper]: The database wrapper instance that handles
  ///   initialization and database connection.
  MealDatabaseRepo(this._databaseWrapper);


  /// Retrieves the meal ID based on user ID, day, and meal type.
  ///
  /// - [userID]: The ID of the user.
  /// - [year]: The year for the specified day.
  /// - [month]: The month for the specified day.
  /// - [day]: The day for the specified day.
  /// - [mealType]: The meal type (e.g., "breakfast", "lunch").
  ///
  /// Returns the meal ID if found, otherwise `null`.
  Future<int?> getMealID(int userID, int year, int month, int day, String mealType) async {
    await _databaseWrapper.ensureDBIsInitialized();

    // Get the day ID
    final List<Map<String, dynamic>> dayRecords = await _databaseWrapper.database.query(
      'days',
      where: 'year = ? AND month = ? AND day = ?',
      whereArgs: [year, month, day],
    );
    if (dayRecords.isEmpty) return null;
    final int dayID = dayRecords.first['ID'];

    // Get the meal type ID
    final List<Map<String, dynamic>> mealTypeRecords = await _databaseWrapper.database.query(
      'meal_types',
      where: 'LOWER(name) = ?',
      whereArgs: [mealType.toLowerCase()],
    );
    if (mealTypeRecords.isEmpty) return null;
    final int mealTypeID = mealTypeRecords.first['ID'];

    // Get the existing meal from day_meals
    final List<Map<String, dynamic>> dayMealRecords = await _databaseWrapper.database.query(
      'day_meals',
      where: 'fk_user_id = ? AND fk_day_id = ? AND fk_meal_type_id = ?',
      whereArgs: [userID, dayID, mealTypeID],
    );
    if (dayMealRecords.isEmpty) return null;

    // Return the meal ID
    return dayMealRecords.first['fk_meal_id'];
  }

  /// Deletes a meal and its corresponding day_meals entry.
  ///
  /// - [userID]: The ID of the user.
  /// - [year]: The year for the specified day.
  /// - [month]: The month for the specified day.
  /// - [day]: The day for the specified day.
  /// - [mealType]: The meal type (e.g., "breakfast", "lunch").
  ///
  /// Returns `true` if the meal and its corresponding day_meal entry were successfully deleted, otherwise `false`.
  Future<bool> deleteMeal({required Meal meal, required int userID}) async {
    final int? mealID = await getMealID(userID, meal.year, meal.month, meal.day, meal.mealType);
    if (mealID == null) {
      return false; // Meal or day not found
    }

    await _databaseWrapper.ensureDBIsInitialized();

    final batch = _databaseWrapper.database.batch();

    // Delete from day_meals
    batch.delete(
      'day_meals',
      where: 'fk_user_id = ? AND fk_day_id = (SELECT ID FROM days WHERE year = ? AND month = ? AND day = ?) AND fk_meal_type_id = (SELECT ID FROM meal_types WHERE LOWER(name) = ?)',
      whereArgs: [userID, meal.year, meal.month, meal.day, meal.mealType.toLowerCase()],
    );

    // Delete the meal from the meals table
    batch.delete(
      'meals',
      where: 'ID = ?',
      whereArgs: [mealID],
    );

    final List<dynamic> results = await batch.commit();
    return results.every((result) => result > 0);
  }

  /// Retrieves all meal types stored in the database.
  ///
  /// Returns a list of meal type names as `List<String>`.
  Future<List<String>> getMealTypes() async {
    await _databaseWrapper.ensureDBIsInitialized();

    final List<Map<String, dynamic>> maps = await _databaseWrapper.database.query('meal_types');
    return List<String>.from(maps.map((map) => map['name']));
  }

  /// Retrieves all meals for a specific day, based on the user ID and day ID.
  ///
  /// - [userID]: The ID of the user.
  /// - [year]: The year of the specific day.
  /// - [month]: The month of the specific day.
  /// - [day]: The day of the month.
  ///
  /// Returns a list of meals for the specific day.
  Future<List<Meal>> getMealsForDay(int userID, int year, int month, int day) async {
    await _databaseWrapper.ensureDBIsInitialized();

    final List<Map<String, dynamic>> meals = await _databaseWrapper.database.rawQuery(
      '''
    SELECT meals.fat_level, meals.sugar_level, meal_types.name
    FROM day_meals
    INNER JOIN meals ON day_meals.fk_meal_id = meals.ID
    INNER JOIN meal_types ON day_meals.fk_meal_type_id = meal_types.ID
    WHERE day_meals.fk_user_id = ? AND day_meals.fk_day_id = 
    (SELECT ID FROM days WHERE year = ? AND month = ? AND day = ?)
    ''',
      [userID, year, month, day],
    );

    // Use fromLocalDBMap to handle local DB-specific data mapping
    return List<Meal>.from(meals.map((meal) => Meal.fromLocalDBMap(meal, year, month, day)));
  }

  /// Adds a new meal to the database.
  ///
  /// - [meal]: The meal object to be added.
  ///
  /// Returns the ID of the newly created meal.
  Future<int?> addMeal({required Meal meal, required int userID}) async {
    await _databaseWrapper.ensureDBIsInitialized();

    // Step 1: Check if the day already exists, if not create a new one
    List<Map<String, dynamic>> dayRecords = await _databaseWrapper.database.query(
      'days',
      where: 'year = ? AND month = ? AND day = ?',
      whereArgs: [meal.year, meal.month, meal.day],
    );
    int dayID;
    if (dayRecords.isEmpty) {
      dayID = await _databaseWrapper.database.insert(
        'days',
        {'year': meal.year, 'month': meal.month, 'day': meal.day},
      );
    } else {
      dayID = dayRecords.first['ID'];
    }

    // Step 2: Get the meal type ID
    List<Map<String, dynamic>> mealTypeRecords = await _databaseWrapper.database.query(
      'meal_types',
      where: 'LOWER(name) = ?',
      whereArgs: [meal.mealType.toLowerCase()],
    );
    if (mealTypeRecords.isEmpty) {
      throw Exception('Invalid meal type: ${meal.mealType}');
    }
    int mealTypeID = mealTypeRecords.first['ID'];

    // Step 3: Insert the new meal
    int mealID = await _databaseWrapper.database.insert(
      'meals',
      {'fat_level': meal.fatLevel, 'sugar_level': meal.sugarLevel},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Step 4: Link the meal to the day and meal type in day_meals
    List<Map<String, dynamic>> dayMealRecords = await _databaseWrapper.database.query(
      'day_meals',
      where: 'fk_user_id = ? AND fk_day_id = ? AND fk_meal_type_id = ?',
      whereArgs: [userID, dayID, mealTypeID],
    );
    if (dayMealRecords.isNotEmpty) {
      return null; // Meal already exists for this day and meal type
    }

    await _databaseWrapper.database.insert(
      'day_meals',
      {
        'fk_user_id': userID,
        'fk_day_id': dayID,
        'fk_meal_type_id': mealTypeID,
        'fk_meal_id': mealID,
      },
    );

    return mealID;
  }



  /// Updates an existing meal in the database based on user, day, and meal type.
  ///
  /// - [meal]: The meal object containing updated data.
  /// - [userID]: The ID of the user who owns the meal.
  /// - [year]: The year of the meal.
  /// - [month]: The month of the meal.
  /// - [day]: The day of the meal.
  /// - [mealType]: The meal type (e.g., "breakfast", "lunch").
  ///
  /// Returns a `Future<bool>` indicating if the operation was successful.
  Future<bool> updateMeal({required Meal meal, required int userID}) async {
    final int? mealID = await getMealID(userID, meal.year, meal.month, meal.day, meal.mealType);
    if (mealID == null) {
      return false; // Meal or day not found
    }

    await _databaseWrapper.ensureDBIsInitialized();

    final int count = await _databaseWrapper.database.update(
      'meals',
      meal.toMap(),
      where: 'ID = ?',
      whereArgs: [mealID],
    );

    return count > 0;
  }

}
