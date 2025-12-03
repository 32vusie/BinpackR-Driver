import 'package:logger/logger.dart';

class AppLogger {
  static final Logger logger = Logger(
    printer: PrettyPrinter(),
  );

  static void logInfo(String message) => logger.i(message);

  static void logDebug(String message) => logger.d(message);

  static void logError(String message, {dynamic error, StackTrace? stackTrace}) {
    logger.e(message, error: error, stackTrace: stackTrace);
  }
}
