// Copyright (C) 2024 Patrick Michiels
// All rights reserved.
// This source code is licensed under the Evaluation License Agreement and
// may not be used, modified, or distributed without explicit permission from the author.
// This code is provided for evaluation purposes only.

import 'dart:ui';

/// Utility class for handling app translation language functionalities.
///
/// This class provides functions to convert between language codes,
/// retrieve language names, and map between locale and supported languages.
class LanguageUtils {
  LanguageUtils();

  /// Returns the full name of the language based on the [LangCode] provided.
  ///
  /// This can be used for displaying a user-friendly language name.
  ///
  /// - [langCodeToGetStringFor]: The `LangCode` to retrieve the full name for.
  ///
  /// Returns the name of the language as a string.
  static String getFullNameForLangCode(LangCode langCodeToGetStringFor) {
    switch (langCodeToGetStringFor) {
      case LangCode.en:
        return "English";
      case LangCode.de:
        return "Deutsch";
    }
  }

  /// Returns the short string representation of the [LangCode] for programmatic use.
  ///
  /// This can be used when exporting or saving state to a persistent storage.
  ///
  /// - [langCodeToGetStringFor]: The `LangCode` to retrieve the short representation for.
  ///
  /// Returns the short string representation of the language code.
  static String getStringRepForLangCode(LangCode langCodeToGetStringFor) {
    switch (langCodeToGetStringFor) {
      case LangCode.en:
        return "en";
      case LangCode.de:
        return "de";
    }
  }

  /// Retrieves a list of supported languages as a list of string representations.
  ///
  /// This can be used to populate a dropdown menu or for other UI components
  /// that require a list of supported languages.
  ///
  /// Returns a list of string representations of the supported languages.
  static List<String> getSupportedLanguagesAsStringList() {
    return LangCode.values.map((e) => e.name).toList();
  }

  /// Converts a string representation of a language code back to its corresponding [LangCode].
  ///
  /// If the provided string is not a valid language code, the function will return [LangCode.en]
  /// as a failsafe to ensure the app always has a valid language code.
  ///
  /// - [langCodeAsString]: The string representation of the language code.
  ///
  /// Returns the corresponding `LangCode`.
  static LangCode getLangCodeFromItsStringRep(String langCodeAsString) {
    switch (langCodeAsString) {
      case "de":
        return LangCode.de;
      case "en":
      default:
        return LangCode.en;
    }
  }

  /// Retrieves the supported [LangCode] from a user's locale.
  ///
  /// This function maps the system locale to one of the supported languages.
  /// If the locale is not supported, it defaults to [LangCode.en].
  ///
  /// - [locale]: The `Locale` object to retrieve the language from.
  ///
  /// Returns the corresponding `LangCode` for the provided locale.
  static LangCode getLangCodeFromLocale(Locale locale) {
    switch (locale.languageCode) {
      case "de":
        return LangCode.de;
      case "en":
      default:
        return LangCode.en;
    }
  }
}

/// Enum representing the supported languages.
///
/// This enum holds all the languages that the application supports.
enum LangCode { en, de }
