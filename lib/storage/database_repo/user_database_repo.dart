// Public package imports.
import 'package:sqflite/sqflite.dart';

// Custom package imports.
import 'package:engaige_meal_tracker_demo/models/user.dart';
import 'package:engaige_meal_tracker_demo/storage/database_wrapper.dart';
import 'package:engaige_meal_tracker_demo/storage/models/users_db_model.dart';

/// The `UserDatabaseRepo` class provides repository methods for user-related
/// database operations. It interacts with the `DatabaseWrapper` to perform
/// CRUD operations and ensure that user data is managed efficiently in the database.
class UserDatabaseRepo {
  /// Reference to the `DatabaseWrapper` for database interaction.
  final DatabaseWrapper _databaseWrapper;

  /// Constructor for `UserDatabaseRepo`.
  ///
  /// - [_databaseWrapper]: The database wrapper instance that handles
  ///   initialization and database connection.
  UserDatabaseRepo(this._databaseWrapper);

  /// Retrieves a `User` by their ID.
  ///
  /// - [userID]: The ID of the user to be fetched.
  ///
  /// Returns the `User` if found, otherwise returns `null`.
  Future<User?> getUserByID(int userID) async {
    await _databaseWrapper.ensureDBIsInitialized();

    final List<Map> maps = await _databaseWrapper.database.query(
      'users',
      columns: ['ID', 'name', 'hashedPassword'],
      where: 'ID = ?',
      whereArgs: [userID],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    } else {
      return null;
    }
  }

  /// Logs in the user by checking their credentials (username and hashed password).
  ///
  /// - [userName]: The username of the user attempting to log in.
  /// - [hashedPassword]: The hashed password for the user.
  ///
  /// Returns the `User` if credentials are correct, otherwise returns `null`.
  Future<User?> login({required String userName, required String hashedPassword}) async {
    if (await isUserPasswordCorrect(userName: userName, hashedPassword: hashedPassword)) {
      return await getUserByName(userName);
    } else {
      return null;
    }
  }

  /// Verifies if the provided username and hashed password match a user in the database.
  ///
  /// - [userName]: The username of the user.
  /// - [hashedPassword]: The hashed password to verify.
  ///
  /// Returns `true` if the credentials match, otherwise returns `false`.
  Future<bool> isUserPasswordCorrect({required String userName, required String hashedPassword}) async {
    User? user = await getUserByName(userName);
    return user != null && user.hashedPassword == hashedPassword;
  }

  /// Retrieves a `User` by their username.
  ///
  /// - [userName]: The username of the user to be fetched.
  ///
  /// Returns the `User` if found, otherwise returns `null`.
  Future<User?> getUserByName(String userName) async {
    await _databaseWrapper.ensureDBIsInitialized();

    final List<Map> maps = await _databaseWrapper.database.query(
      'users',
      columns: ['ID'],
      where: 'name = ?',
      whereArgs: [userName],
    );

    if (maps.isNotEmpty) {
      return await getUserByID(maps.first['ID']);
    } else {
      return null;
    }
  }

  /// Creates a new user in the database.
  ///
  /// - [userDBModel]: The user data model containing information for the new user.
  ///
  /// Returns the ID of the newly created user.
  Future<int> createUser(UsersDBModel userDBModel) async {
    return await _insertUsersDBModel(userDBModel);
  }

  /// Retrieves all users from the database.
  ///
  /// Returns a list of `UsersDBModel` objects representing all users in the database.
  Future<List<UsersDBModel>> getUsersDBModels() async {
    await _databaseWrapper.ensureDBIsInitialized();
    final List<Map<String, dynamic>> maps = await _databaseWrapper.database.query('users');
    return List.generate(maps.length, (i) {
      return UsersDBModel(
        ID: maps[i]['ID'],
        name: maps[i]['name'],
        hashedPassword: maps[i]['hashedPassword'],
      );
    });
  }

  /// Inserts a new user into the database.
  ///
  /// - [userDBModel]: The user data model to insert.
  ///
  /// Returns the ID of the newly inserted user.
  Future<int> _insertUsersDBModel(UsersDBModel userDBModel) async {
    await _databaseWrapper.ensureDBIsInitialized();

    // Auto Increment does not work -> set next ID manually.
    if (userDBModel.ID == null || userDBModel.ID == 0) {
      userDBModel.ID = await _databaseWrapper.getNextID(table: TablesWithAutoIncrement.users);
    }

    await _databaseWrapper.database.insert(
      'users',
      userDBModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return userDBModel.ID!;
  }

  /// Prints all users stored in the database.
  ///
  /// This method fetches all users and prints their data to the console.
  Future<void> printAllUsers() async {
    List<UsersDBModel> allUsers = await getUsersDBModels();
    for (var user in allUsers) {
      print(user.toString());
    }
  }

  /// Ensures that a `User` object has a valid ID.
  ///
  /// If the `User` object has no ID set, this method attempts to find the user by their username
  /// and assigns the ID.
  ///
  /// - [user]: The `User` object that needs an ID.
  ///
  /// Returns the updated `User` object with a valid ID.
  Future<User> ensureUserID(User user) async {
    if (user.ID == 0) {
      User? userByName = await getUserByName(user.userName);
      return userByName!;
    } else {
      return user;
    }
  }

  /// Prints all user models stored in the database.
  ///
  /// If the number of users is greater than six, it prints each user's details.
  /// Otherwise, it prints the entire list of users.
  Future<void> testPrintAllUserDBModels() async {
    print('');
    print('getUsersDBModels()');
    List<UsersDBModel> allUserDBModels = await getUsersDBModels();
    if (allUserDBModels.length > 6) {
      for (UsersDBModel userDBModel in allUserDBModels) {
        print(userDBModel.toString());
      }
    } else {
      print(allUserDBModels);
    }
  }
}
