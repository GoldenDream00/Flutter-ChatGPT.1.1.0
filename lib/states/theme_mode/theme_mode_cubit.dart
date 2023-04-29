// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// 🌎 Project imports:
import 'package:chat_gpt_app/core/app_instances.dart';
import 'package:chat_gpt_app/manager/theme/theme_manager.dart';

class ThemeModeCubit extends Cubit<ThemeMode> {
  late final _themeManager = AppInstances.get<ThemeManagerProtocol>();
  ThemeModeCubit(ThemeMode currentState) : super(currentState);

  Future<void> setMode(ThemeMode mode) {
    emit(mode);
    return _themeManager.persist(mode);
  }
}
