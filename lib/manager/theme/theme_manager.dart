// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:injectable/injectable.dart';

// 🌎 Project imports:
import 'package:chat_gpt_app/configs/local_storage_keys.dart';
import 'package:chat_gpt_app/core/app_instances.dart';
import 'package:chat_gpt_app/data/datasources/local_storage/share_preferences_source.dart';

abstract class ThemeManagerProtocol {
  ThemeMode get currentTheme;
  Future<void> persist(ThemeMode mode);
}

@LazySingleton(as: ThemeManagerProtocol)
class ThemeManager implements ThemeManagerProtocol {
  late final _sharedPreferencesSource = AppInstances.get<SharedPreferencesSourceProtocol>();

  @override
  ThemeMode get currentTheme {
    final currentThemeString = _sharedPreferencesSource.getString(LocalStorgeKeys.themeMode, defaultValue: "system")!;
    switch (currentThemeString) {
      case "light":
        return ThemeMode.light;
      case "dark":
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  @override
  Future<void> persist(ThemeMode mode) async {
    await _sharedPreferencesSource.setString(LocalStorgeKeys.themeMode, mode.name);
  }
}
