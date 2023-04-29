// 📦 Package imports:
import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:chat_gpt_app/core/app_instances.dart';
import 'package:chat_gpt_app/core/logger.dart';
import 'package:chat_gpt_app/manager/chat_gpt/chat_gpt_manager.dart';

class AppInitializer {
  AppInitializer._();

  static Future<void> initialize() async {
    AppLogger.debug(() => "[AppInitializer] initialize the app");
    await AppInstances.get<ChatGPTManagerProtocol>().setup();
    await Future.delayed(1.seconds);
    AppLogger.debug(() => "[AppInitializer] initialize done");
  }
}
