// Public package imports.
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

// Custom package imports.
import 'colors.dart';


/// The login theme configuration for the `FlutterLogin` widget.
///
/// This theme customizes the appearance of the login page, including colors,
/// input fields, and title styles.
final kThemes_loginTheme = LoginTheme(
  pageColorLight: kColors_flutterLoginTheme_pageColorLight,
  primaryColor: kColors_flutterLoginTheme_primaryColor,
  inputTheme: kThemes_flutterLogin_inputDecorationTheme,
  titleStyle: const TextStyle(
    color: kColors_flutterLoginTheme_titleTextColor, // Makes the login title text white.
    fontSize: 48,
    fontWeight: FontWeight.bold,
  ),
);

/// The input decoration theme for the `FlutterLogin` widget.
///
/// This theme applies to input fields within the login screen, such as the
/// email and password input boxes.
final kThemes_flutterLogin_inputDecorationTheme = InputDecorationTheme(
  filled: true,
  fillColor: kColors_welcomeScreen_inputBackgroundColor, // Custom input background color.
  contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0), // Padding inside input fields.

  // Label style for input fields.
  labelStyle: TextStyle(
    fontSize: 14,
    color: Colors.grey.shade600,  // Sets the label text color to a light grey.
  ),

  // Colors for icons inside input fields.
  prefixIconColor: kColors_flutterLogin_inputDecorationTheme_color,
  suffixIconColor: kColors_flutterLogin_inputDecorationTheme_color,
);

/// The main input decoration theme used across the app.
///
/// This theme applies to input fields outside of the login screen, customizing
/// their appearance with borders, colors, and padding.
final kThemes_mainTheme_inputDecorationTheme = InputDecorationTheme(
  filled: true,
  fillColor: kColors_welcomeScreen_inputBackgroundColor, // Custom input background color.
  contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0), // Padding inside input fields.

  // Label style for input fields.
  labelStyle: TextStyle(
    fontSize: 14,
    color: Colors.grey.shade600,  // Sets the label text color to a light grey.
  ),

  // Enabled border style for input fields when not focused.
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
    borderRadius: BorderRadius.circular(30.0), // Rounded border for the input fields.
  ),

  // Focused border style for input fields when selected.
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blue.shade700, width: 2.5),
    borderRadius: BorderRadius.circular(30.0), // Rounded border for the input fields when focused.
  ),

  // Colors for icons inside input fields.
  prefixIconColor: kColors_flutterLogin_inputDecorationTheme_color,
  suffixIconColor: kColors_flutterLogin_inputDecorationTheme_color,
);
