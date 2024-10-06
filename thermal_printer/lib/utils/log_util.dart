import 'package:flutter/foundation.dart';

abstract class LogUtil {
  static void log(String message) {
    if (kDebugMode) {
      print(message);
    }
  }
}
