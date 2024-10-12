import 'package:flutter/material.dart';

/// Global used colors.
const kColors_primary = Color(0xFFDD1C1C);
const kColors_secondary = Colors.grey;
const kColors_backgroundColor_default = Color(0xFFF0F0F0);
const kColors_listTile_backgroundColor = Colors.white;
const kColors_backNavigationIconColor = Colors.black;
const kColors_backNavigationTextColor = Colors.black;
const kColors_defaultTextColor = Colors.black;

/// Login screen colors.
const kColors_flutterLogin_inputDecorationTheme_color = Color(0xFF757575); // Colors.grey.shade600
const kColors_welcomeScreen_inputBackgroundColor = Color(0x172196f3);
const kColors_flutterLoginTheme_pageColorLight = Color(0xFF757575);
const kColors_flutterLoginTheme_primaryColor = kColors_primary;
const kColors_flutterLoginTheme_titleTextColor = Color(0xFFDEE3D9);

/// AppBar colors.
const kColors_appBar_bottomDividerColor = Color(0xFFDDDDDD);

/// Meal Type item colors.
const kColors_mealTypeItem_addIconColor = kColors_primary;

/// LanguageSwitcher colors.
const kColors_languageSwitcher_dropDownIconColor = kColors_primary;

/// Floating action button.
const kColors_scrollToTopFloatingActionButton_backgroundColor = kColors_primary;

/// Box shadow color for widgets.
const kColors_boxShadow = Color(0x1A000000); // Slight black shadow (translucent black)

/// Tag colors for displaying fat/sugar levels.
const kColors_tagBackgroundColor = Color(0xFFFFCDD2); // Light red background for the tag
const kColors_tagLabelColor = Color(0xFFD32F2F); // Red for the label text
const kColors_tagLevelColor = Color(0xFFD32F2F); // Red for the level background
const kColors_tagLevelTextColor = Colors.white; // White text for the level

/// Get Color from Hex String (#FF001122 or #001122).
///
/// Can be used to change colors based on selected language if used like this:
/// Widget(
///    backgroundColor: HexColor(tr('languageTestColor')),
///    color: HexColor(tr('languageTestColor')),
class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
