import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UIUtils {

  /// Configures the system UI overlay to be transparent.
  ///
  /// This method modifies the status bar and navigation bar to have a transparent
  /// background, allowing for a more immersive UI experience, especially on Android devices.
  static void makeSystemBarTransparent() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
      systemNavigationBarDividerColor: null,
    ));
  }
}
