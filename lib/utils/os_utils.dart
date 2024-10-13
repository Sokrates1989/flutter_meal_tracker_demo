// Copyright (C) 2024 Patrick Michiels
// All rights reserved.
// This source code is licensed under the Evaluation License Agreement and
// may not be used, modified, or distributed without explicit permission from the author.
// This code is provided for evaluation purposes only.

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
