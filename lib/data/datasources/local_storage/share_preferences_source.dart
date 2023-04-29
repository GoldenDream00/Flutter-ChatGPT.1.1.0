// 📦 Package imports:
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SharedPreferencesSourceProtocol {
  Future<void> setup();

  bool? getBool(String key, {bool? defaultValue});

  /// Reads a value from persistent storage, throwing an exception if it's not
  /// an int.
  int? getInt(String key, {int? defaultValue});

  /// Reads a value from persistent storage, throwing an exception if it's not a
  /// double.
  double? getDouble(String key, {double? defaultValue});

  /// Reads a value from persistent storage, throwing an exception if it's not a
  /// String.
  String? getString(String key, {String? defaultValue});

  /// Reads a set of string values from persistent storage, throwing an
  /// exception if it's not a string set.
  List<String>? getStringList(String key);

  /// Saves a boolean [value] to persistent storage in the background.
  Future<bool> setBool(String key, bool value);

  /// Saves an integer [value] to persistent storage in the background.
  Future<bool> setInt(String key, int value);

  /// Saves a double [value] to persistent storage in the background.
  ///
  /// Android doesn't support storing doubles, so it will be stored as a float.
  Future<bool> setDouble(String key, double value);

  /// Saves a string [value] to persistent storage in the background.
  ///
  /// Note: Due to limitations in Android's SharedPreferences,
  /// values cannot start with any one of the following:
  ///
  /// - 'VGhpcyBpcyB0aGUgcHJlZml4IGZvciBhIGxpc3Qu'
  /// - 'VGhpcyBpcyB0aGUgcHJlZml4IGZvciBCaWdJbnRlZ2Vy'
  /// - 'VGhpcyBpcyB0aGUgcHJlZml4IGZvciBEb3VibGUu'
  Future<bool> setString(String key, String value);

  /// Saves a list of strings [value] to persistent storage in the background.
  Future<bool> setStringList(String key, List<String> value);

  /// Removes an entry from persistent storage.
  Future<bool> remove(String key);

  /// Completes with true once the user preferences for the app has been cleared.
  Future<bool> clear();

  /// Fetches the latest values from the host platform.
  ///
  /// Use this method to observe modifications that were made in native code
  /// (without using the plugin) while the app is running.
  Future<void> reload();

  bool containsKey(String key);
}

@LazySingleton(as: SharedPreferencesSourceProtocol, order: -2)
class SharedPreferencesSource extends SharedPreferencesSourceProtocol {
  late SharedPreferences _sharedPreferences;

  @PostConstruct(preResolve: true)
  @override
  Future<void> setup() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  Future<bool> clear() {
    return _sharedPreferences.clear();
  }

  @override
  bool? getBool(String key, {bool? defaultValue}) {
    final value = _sharedPreferences.getBool(key) ?? defaultValue;
    return value;
  }

  @override
  double? getDouble(String key, {double? defaultValue}) {
    final value = _sharedPreferences.getDouble(key) ?? defaultValue;
    return value;
  }

  @override
  int? getInt(String key, {int? defaultValue}) {
    final value = _sharedPreferences.getInt(key) ?? defaultValue;
    return value;
  }

  @override
  String? getString(String key, {String? defaultValue}) {
    final value = _sharedPreferences.getString(key) ?? defaultValue;
    return value;
  }

  @override
  List<String>? getStringList(String key) {
    final value = _sharedPreferences.getStringList(key);
    return value;
  }

  @override
  Future<void> reload() {
    return _sharedPreferences.reload();
  }

  @override
  Future<bool> remove(String key) {
    return _sharedPreferences.remove(key);
  }

  @override
  Future<bool> setBool(String key, bool value) {
    return _sharedPreferences.setBool(key, value);
  }

  @override
  Future<bool> setDouble(String key, double value) {
    return _sharedPreferences.setDouble(key, value);
  }

  @override
  Future<bool> setInt(String key, int value) {
    return _sharedPreferences.setInt(key, value);
  }

  @override
  Future<bool> setString(String key, String value) {
    return _sharedPreferences.setString(key, value);
  }

  @override
  Future<bool> setStringList(String key, List<String> value) {
    return _sharedPreferences.setStringList(key, value);
  }

  @override
  bool containsKey(String key) {
    return _sharedPreferences.containsKey(key);
  }
}
