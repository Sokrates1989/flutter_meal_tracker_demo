import 'dart:io';  // For Platform.isIOS, Platform.isMacOS, etc.
import 'package:flutter/foundation.dart';  // For kIsWeb

class OSUtils {
  /// Checks if the host OS supports the local database with the used plugin.
  static bool isLocalDatabaseSupportedOnHostOS() {
    bool isIOS = !kIsWeb && Platform.isIOS;
    bool isMacOS = !kIsWeb && Platform.isMacOS;
    bool isAndroid = !kIsWeb && Platform.isAndroid;

    return isIOS || isMacOS || isAndroid;
  }
}
