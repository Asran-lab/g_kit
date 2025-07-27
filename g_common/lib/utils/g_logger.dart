import 'dart:developer' show log;
import 'package:flutter/foundation.dart';

enum LogLevel { debug, info, warning, error }

class Logger {
  Logger._();
  static void d(Object? message, {String tag = "✅ Debug"}) {
    if (kDebugMode) _log(LogLevel.debug, tag, message);
  }

  static void i(Object? message, {String tag = "🖍️ Info"}) {
    if (kDebugMode) _log(LogLevel.info, tag, message);
  }

  static void w(Object? message, {String tag = "⚠️ Warning"}) {
    if (kDebugMode) _log(LogLevel.warning, tag, message);
  }

  static void e(
    Object? message, {
    String tag = "❌ Error",
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(LogLevel.error, tag, message, error: error, stackTrace: stackTrace);
  }

  static void _log(
    LogLevel level,
    String tag,
    Object? message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    final logLevel = switch (level) {
      LogLevel.debug => 500, // Fine-grained
      LogLevel.info => 800,
      LogLevel.warning => 900,
      LogLevel.error => 1000,
    };
    log(
      '[$tag] ${message.toString()}',
      level: logLevel,
      name: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
