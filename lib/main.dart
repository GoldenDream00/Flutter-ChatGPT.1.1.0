// 🎯 Dart imports:
import 'dart:async';

// 🐦 Flutter imports:
import 'package:chat_gpt_app/core/logger.dart';
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:chat_gpt_app/injectable_config.dart';
import 'package:chat_gpt_app/my_app.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.dumpErrorToConsole(details);
      AppLogger.error(() => "[main] unhandle error $details");
    };

    await configureDependencies();
    runApp(const MyApp());
  }, (error, stack) {
    AppLogger.error(() => "[runZonedGuarded] unhandle error $error $stack");
  });
}
