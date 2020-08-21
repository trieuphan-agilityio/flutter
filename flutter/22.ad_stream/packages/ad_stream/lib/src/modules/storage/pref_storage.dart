import 'package:shared_preferences/shared_preferences.dart';

abstract class PrefStoreReading {
  /// Reads a value, return null if it's not a bool.
  bool getBool(String key);

  /// Reads a value, return null if it's not an int.
  int getInt(String key);

  /// Reads a value, return null if it's not a double.
  double getDouble(String key);

  /// Reads a value, return null if it's not a String.
  String getString(String key);

  /// Reads a set of string values, return null if it's not a string set.
  List<String> getStringList(String key);

  /// Returns true if persistent storage the contains the given [key].
  bool containsKey(String key);
}

abstract class PrefStoreWriting implements PrefStoreReading {
  /// Saves a boolean [value] in the background.
  ///
  /// If [value] is null, this is equivalent to calling [remove()] on the [key].
  Future<bool> setBool(String key, bool value);

  /// Saves an integer [value] in the background.
  ///
  /// If [value] is null, this is equivalent to calling [remove()] on the [key].
  Future<bool> setInt(String key, int value);

  /// Saves a double [value] in the background.
  ///
  /// Android doesn't support storing doubles, so it will be stored as a float.
  ///
  /// If [value] is null, this is equivalent to calling [remove()] on the [key].
  Future<bool> setDouble(String key, double value);

  /// Saves a string [value] in the background.
  ///
  /// If [value] is null, this is equivalent to calling [remove()] on the [key].
  Future<bool> setString(String key, String value);

  /// Saves a list of strings [value] in the background.
  ///
  /// If [value] is null, this is equivalent to calling [remove()] on the [key].
  Future<bool> setStringList(String key, List<String> value);

  /// Removes an entry.
  Future<bool> remove(String key);
}

class PrefStoreImpl implements PrefStoreWriting {
  final SharedPreferences pref;

  PrefStoreImpl(this.pref);

  /// PrefStoreReading

  bool containsKey(String key) => pref.containsKey(key);

  bool getBool(String key) {
    try {
      return pref.getBool(key);
    } catch (_) {
      return null;
    }
  }

  double getDouble(String key) {
    try {
      return pref.getDouble(key);
    } catch (_) {
      return null;
    }
  }

  int getInt(String key) {
    try {
      return pref.getInt(key);
    } catch (_) {
      return null;
    }
  }

  String getString(String key) {
    try {
      return pref.getString(key);
    } catch (_) {
      return null;
    }
  }

  List<String> getStringList(String key) {
    try {
      return pref.getStringList(key);
    } catch (_) {
      return null;
    }
  }

  /// PrefStoreWriting

  Future<bool> remove(String key) => pref.remove(key);

  Future<bool> setBool(String key, bool value) => pref.setBool(key, value);

  Future<bool> setDouble(String key, double value) =>
      pref.setDouble(key, value);

  Future<bool> setInt(String key, int value) => pref.setInt(key, value);

  Future<bool> setString(String key, String value) =>
      pref.setString(key, value);

  Future<bool> setStringList(String key, List<String> value) =>
      pref.setStringList(key, value);
}
