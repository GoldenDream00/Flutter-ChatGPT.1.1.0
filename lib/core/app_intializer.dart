// 📦 Package imports:
import 'package:awesome_extensions/awesome_extensions.dart';

class AppInitializer {
  AppInitializer._();

  static Future<void> initialize() async {
    await Future.delayed(1.seconds);
  }
}
