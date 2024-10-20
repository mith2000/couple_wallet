import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class Logs {
  const Logs._();

  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  static void d(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) _logger.d(message);
  }

  static void e(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) _logger.e(message);
  }

  static void i(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) _logger.i(message);
  }

  static void v(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) _logger.i(message);
  }

  static void w(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) _logger.w(message);
  }

  static void fatal(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) _logger.f(message);
  }

  static void close() {
    if (kDebugMode) _logger.close();
  }
}
