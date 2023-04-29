import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';

import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stack_trace/stack_trace.dart';

final _logger = Logger(
  output: AppLogOutput(),
  printer: CustomPrinter(),
  filter: ProductionFilter(),
  level: Level.debug,
);

Future<List<String>> getLogPaths() async {
  AppLogger.debug(() => "Export logs");
  await Future.delayed(const Duration(seconds: 1));
  final logPath = "${await AppLogOutput._localPath}/flutter_app_log.log";
  if (!(await File(logPath).exists())) {
    await File(logPath).create();
  }
  if (await File(logPath).exists()) {
    return [logPath];
  }
  return [];
}

class CustomPrinter extends LogPrinter {
  @override
  List<String> log(LogEvent event) {
    final now = DateTime.now();
    return [
      "${now.toString()} [${event.level}]${event.message} [${now.millisecondsSinceEpoch}]",
      if (event.level == Level.error && event.error != null) "|---${event.error ?? ""}",
      if (event.level == Level.error && event.stackTrace != null) "|---${event.stackTrace ?? ""}",
      if (event.level == Level.error && event.stackTrace != null)
        "------------------------------------------------------",
    ];
  }
}

class AppLogger {
  AppLogger._();

  static const _encoder = JsonEncoder.withIndent('  ');

  static String? _getMethodName() {
    var frames = Trace.current().frames; //.member?.split(".");
    if (frames.length >= 3) {
      var members = frames[2].member!.split(".");

      if (members.length == 2) {
        return members.join(".");
      } else if (members.length > 2) {
        return members[2];
      } else {
        return members.last;
      }
    } else {
      return frames.first.member;
    }
  }

  static void debug(dynamic Function() fn) {
    var className = "";
    try {
      className = Trace.current().frames[2].member!.split(".")[0];
    } catch (_) {}
    var methodName = _getMethodName();
    var message = fn();
    if (message is Map) {
      try {
        message = _encoder.convert(fn());
      } catch (_) {}
    }

    _logger.d("_[$className]_[$methodName] $message");
  }

  static void error(String Function() fn, [Object? error, StackTrace? trace]) {
    var className = "";
    try {
      className = Trace.current().frames[2].member!.split(".")[0];
    } catch (_) {}
    var methodName = _getMethodName();
    _logger.e("_[$className]_[$methodName] ${fn()}", error, trace);
  }
}

class AppLogOutput extends LogOutput {
  String? _latestFilePath;
  File? _logFile;

  @override
  void output(OutputEvent event) async {
    for (var d in event.lines) {
      dev.log(d);
      print(d);
    }
    _logRecord(event);
  }

  Future<String> _getLatestFile() async {
    if (_latestFilePath != null) {
      return _latestFilePath!;
    }
    final localPath = await _localPath;

    return _latestFilePath = '$localPath/flutter_app_log.log';
  }

  static Future<String> get _localPath async {
    try {
      Directory? directory;
      if (Platform.isIOS || Platform.isMacOS) {
        directory = await getApplicationDocumentsDirectory();
      } else if (Platform.isAndroid) {
        directory = await getExternalStorageDirectory();
      }
      return directory!.absolute.path;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _logRecord(OutputEvent event) async {
    _logFile ??= await _getLocalFile();
    for (final line in event.lines) {
      await _logFile?.writeAsString("$line\n", mode: FileMode.append, flush: true);
    }
  }

  Future<File> _getLocalFile() async {
    final file = File(await _getLatestFile());
    _logFile = file;
    if (!(await file.exists())) {
      await file.create();
    }
    return file;
  }
}
