// 📦 Package imports:
import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:chat_gpt_app/core/logger.dart';

class AppInitializer {
  AppInitializer._();

  static Future<void> initialize() async {
    AppLogger.debug(() => "[AppInitializer] initialize the app");
    await Future.delayed(1.seconds);
    AppLogger.debug(() => "[AppInitializer] initialize done");
  }
}
