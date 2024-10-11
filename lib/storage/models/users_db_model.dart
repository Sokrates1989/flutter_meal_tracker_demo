/// A model class representing a user in the database.
///
/// This class stores the user's information such as their ID, name, and hashed password.
/// It provides methods to convert the object into a map for database operations and
/// overrides the `toString` method to give a string representation of the object.
class UsersDBModel {
  /// The user's unique identifier in the database. This field is nullable.
  ///
  /// If no ID is provided during object instantiation, it defaults to `0`.
  late int? ID;

  /// The user's name.
  ///
  /// This is a required field when creating an instance of [UsersDBModel].
  final String name;

  /// The user's hashed password.
  ///
  /// This is also a required field, representing the securely hashed version of the user's password.
  final String hashedPassword;

  /// Constructor for [UsersDBModel].
  ///
  /// - [ID] is an optional parameter representing the user's unique ID. If not provided, it defaults to `0`.
  /// - [name] is the user's name and must be provided.
  /// - [hashedPassword] is the user's hashed password and must also be provided.
  UsersDBModel({
    ID,
    required this.name,
    required this.hashedPassword,
  }) {
    // Set ID to `0` if not provided.
    this.ID = ID ?? 0;
  }

  /// Converts the object into a map that can be used in database operations.
  ///
  /// The map will contain the user's name and hashed password. If the [ID] is not `null` and not `0`,
  /// it will also be included in the map. This allows for the auto-increment functionality in databases
  /// that do not require the ID to be manually set.
  ///
  /// Returns a `Map<String, dynamic>` representing the user.
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'name': name,
      'hashedPassword': hashedPassword,
    };
    // Include ID only if it is set (non-null and non-zero).
    if (ID != null && ID != 0) {
      map['ID'] = ID;
    }
    return map;
  }

  /// Returns a string representation of the object.
  ///
  /// This method returns a formatted string containing the user's ID, name, and hashed password.
  @override
  String toString() {
    return 'UsersDBModel{'
        'ID: $ID, '
        'name: $name, '
        'hashedPassword: $hashedPassword'
        '}';
  }
}
