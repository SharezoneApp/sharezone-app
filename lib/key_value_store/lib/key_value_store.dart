abstract class KeyValueStore {
  /// Returns all keys in the persistent storage.
  Set<String> getKeys();

  /// Reads a value from persistent storage, throwing an exception if it's not a bool.
  bool getBool(String key);
  // Reads a value from persistent storage, throwing an exception if it's not an int.
  int getInt(String key);
  // Reads a value from persistent storage, throwing an exception if it's not a double.
  double getDouble(String key);
  // Reads a value from persistent storage, throwing an exception if it's not an String.
  String getString(String key);

  /// Reads a set of string values from persistent storage, throwing an exception if it's not a string set.
  List<String> getStringList(String key);

  /// Saves a boolean [value] to persistent storage in the background.
  ///
  /// If [value] is null, this is equivalent to calling [remove()] on the [key].
  Future<bool> setBool(String key, bool value);

  /// Reads a value from persistent storage, throwing an exception if it's not
  /// an int.
  Future<bool> setInt(String key, int value);

  /// Saves a double [value] to persistent storage in the background.
  ///
  /// Android doesn't support storing doubles, so it will be stored as a float.
  ///
  /// If [value] is null, this is equivalent to calling [remove()] on the [key].
  Future<bool> setDouble(String key, double value);

  /// Saves a string [value] to persistent storage in the background.
  ///
  /// If [value] is null, this is equivalent to calling [remove()] on the [key].
  Future<bool> setString(String key, String value);

  /// Saves a list of strings [value] to persistent storage in the background.
  ///
  /// If [value] is null, this is equivalent to calling [remove()] on the [key].
  Future<bool> setStringList(String key, List<String> values);

  /// Removes an entry from persistent storage.
  Future<bool> remove(String key);

  /// If the cache contains a value with the [key], it will returns true
  bool containsKey(String key);

  /// Completes with true once the user preferences for the app has been cleared
  Future<bool> clear();
}