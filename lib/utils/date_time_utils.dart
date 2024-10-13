// Copyright (C) 2024 Patrick Michiels
// All rights reserved.
// This source code is licensed under the Evaluation License Agreement and
// may not be used, modified, or distributed without explicit permission from the author.
// This code is provided for evaluation purposes only.

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

/// A utility class that provides functions related to date and time manipulation.
///
/// This class contains methods to get the current Unix timestamp and to
/// convert an hour into a human-readable string based on the current locale.
class DateTimeUtils {
  DateTimeUtils();

  /// Retrieves the current Unix timestamp in milliseconds.
  ///
  /// The Unix timestamp is the number of milliseconds that have passed since
  /// January 1, 1970 (UTC). This is commonly used in applications to represent
  /// the current time in a machine-readable format.
  ///
  /// Returns the current Unix timestamp as an integer.
  static int getCurrentUnixTimestamp() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  /// Converts an hour (in 24-hour format) into a human-readable string based on the locale.
  ///
  /// This function formats the given hour using the locale's hour-minute format.
  /// If the locale is German (`de`), the string " Uhr" is appended to the result.
  ///
  /// - [context]: The `BuildContext` used to retrieve the current locale.
  /// - [numberToConvert]: The hour (in 24-hour format) to convert into a human-readable string.
  ///
  /// Returns the hour as a human-readable string.
  static String hourAsHumanReadableString(BuildContext context, int numberToConvert) {
    // Create a DateFormat object based on the locale's language code.
    var formatter = DateFormat.Hm(Localizations.localeOf(context).languageCode);

    // Format the hour into a human-readable string.
    String hourAsHumanReadableString = formatter.format(DateTime(2023, 5, 9, numberToConvert, 0));

    // Add "Uhr" to the string for the German locale.
    switch (EasyLocalization.of(context)!.locale.languageCode) {
      case 'de':
        hourAsHumanReadableString += " Uhr";
        break;
      case 'en':
      default:
      // No changes needed for the English locale.
        break;
    }
    return hourAsHumanReadableString;
  }
}
