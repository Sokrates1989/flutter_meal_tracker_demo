// Copyright (C) 2024 Patrick Michiels
// All rights reserved.
// This source code is licensed under the Evaluation License Agreement and
// may not be used, modified, or distributed without explicit permission from the author.
// This code is provided for evaluation purposes only.

// Public package imports
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

// Own package imports
import 'package:engaige_meal_tracker_demo/utils/language_utils.dart';

/// A widget that allows the user to switch the app's translation language.
///
/// The widget displays a dropdown menu with selectable languages.
/// Each language can be represented by a flag image and optionally
/// its written name. The flag style and size can be customized.
class LanguageSwitcher extends StatefulWidget {
  const LanguageSwitcher({
    super.key,
    required this.locale,
    this.showWrittenLanguageInSelectedItem = false,
    this.showFlag = true,
    this.flagStyle = FlagStyle.rounded,
    this.flagWidth = 40,
    this.flagHeight = 0,
    this.dropdownIconSize = 36,
    this.dropDownIconColor,
  });

  /// The initial locale for the app.
  final Locale locale;

  /// Whether to show the written language in the selected item.
  final bool showWrittenLanguageInSelectedItem;

  /// Whether to show the flag for the language.
  final bool showFlag;

  /// Width of the flag image.
  final double flagWidth;

  /// Height of the flag image.
  final double flagHeight;

  /// The style of the flag (rounded, waving, or original).
  final FlagStyle flagStyle;

  /// The size of the dropdown icon.
  final double dropdownIconSize;

  /// The color of the dropdown icon.
  final Color? dropDownIconColor;

  @override
  State<LanguageSwitcher> createState() => _LanguageSwitcherState();
}

class _LanguageSwitcherState extends State<LanguageSwitcher> {
  late LangCode _chosenLangCode;
  late bool showWrittenLanguage;
  late bool showFlag;
  late FlagStyle flagStyle;
  late double flagWidth;
  late double flagHeight;
  late double dropdownIconSize;
  late Color? dropDownIconColor;

  @override
  void initState() {
    _chosenLangCode = LanguageUtils.getLangCodeFromLocale(widget.locale);
    showWrittenLanguage = widget.showWrittenLanguageInSelectedItem;
    showFlag = widget.showFlag;
    flagStyle = widget.flagStyle;
    flagWidth = widget.flagWidth;
    flagHeight = widget.flagHeight;
    dropdownIconSize = widget.dropdownIconSize;
    dropDownIconColor = widget.dropDownIconColor;
    super.initState();
  }

  /// Returns a flag image for the given language code.
  ///
  /// - [langCode]: The language code to get the flag for. If not provided,
  ///   the currently selected language code (`_chosenLangCode`) will be used.
  /// - [flagAlignment]: The alignment of the flag image. Default is `center`.
  ///
  /// The flag style (rounded, waving, original) and size (width, height) are
  /// determined by the properties passed to the widget.
  Align getFlagImageOfLangCode({
    LangCode? langCode,
    Alignment? flagAlignment = Alignment.center,
  }) {
    langCode = langCode ?? _chosenLangCode;

    // Get image representation of language
    String assetName = "assets/images/flags/";
    switch (langCode) {
      case LangCode.de:
        assetName += "de";
        break;
      case LangCode.en:
      default:
        assetName += "gb";
        break;
    }

    // Add flag style to the image name
    switch (flagStyle) {
      case FlagStyle.rounded:
        assetName += "_rounded.png";
        break;
      case FlagStyle.waving:
        assetName += "_waving.png";
        break;
      case FlagStyle.original:
        assetName += "_original.png";
        break;
    }

    // Return the image widget with proper alignment and size
    return Align(
      alignment: flagAlignment!,
      child: Image.asset(
        assetName,
        width: flagWidth < 3 ? null : flagWidth,
        height: flagHeight < 3 ? null : flagHeight,
        fit: BoxFit.fill,
      ),
    );
  }

  /// Changes the app's language.
  ///
  /// - [langCode]: The language code to switch to. If not provided, the
  ///   currently selected language code (`_chosenLangCode`) will be used.
  ///
  /// This method changes the app's locale to the selected language and
  /// updates the UI.
  void changeLanguage(LangCode? langCode) {
    langCode = langCode ?? _chosenLangCode;

    switch (langCode) {
      case LangCode.en:
        setState(() {
          context.setLocale(Locale('en'));
          _chosenLangCode = LangCode.en;
        });
        break;
      case LangCode.de:
        setState(() {
          context.setLocale(Locale('de'));
          _chosenLangCode = LangCode.de;
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: buildWidgetFromSettings(),
    );
  }

  /// Builds the dropdown widget according to the provided settings.
  ///
  /// This method constructs a `DropdownButton` that lists supported
  /// languages. The currently selected language is shown with its flag
  /// and optionally its written name.
  Widget buildWidgetFromSettings() {
    return DropdownButtonHideUnderline(
      child: DropdownButton(
        iconSize: dropdownIconSize,
        iconEnabledColor: dropDownIconColor,
        selectedItemBuilder: (BuildContext context) {
          return LanguageUtils.getSupportedLanguagesAsStringList()
              .map<Widget>((String langCodeString) {
            return buildLanguageRowForDropDownButton(
              isSelectedItem: true,
              langCode: LanguageUtils.getLangCodeFromItsStringRep(langCodeString),
            );
          }).toList();
        },
        items: LanguageUtils.getSupportedLanguagesAsStringList()
            .map<DropdownMenuItem<String>>((String langCodeString) {
          return DropdownMenuItem<String>(
            value: langCodeString,
            child: buildLanguageRowForDropDownButton(
              isSelectedItem: false,
              langCode: LanguageUtils.getLangCodeFromItsStringRep(langCodeString),
            ),
          );
        }).toList(),
        value: LanguageUtils.getStringRepForLangCode(_chosenLangCode),
        onChanged: (String? chosenLangCodeAsString) {
          changeLanguage(LanguageUtils.getLangCodeFromItsStringRep(chosenLangCodeAsString!));
        },
      ),
    );
  }

  /// Builds a row that represents the language for the dropdown menu.
  ///
  /// - [isSelectedItem]: Whether the row is for the currently selected language.
  /// - [langCode]: The language code to display in the row. If not provided,
  ///   the currently selected language code (`_chosenLangCode`) will be used.
  ///
  /// The row can display both the flag and the written name of the language,
  /// based on the settings provided to the widget.
  Widget buildLanguageRowForDropDownButton({
    required bool isSelectedItem,
    LangCode? langCode,
  }) {
    langCode = langCode ?? _chosenLangCode;

    List<Widget> rowElements = [];
    if (showFlag) {
      rowElements.add(getFlagImageOfLangCode(
        langCode: langCode,
        flagAlignment: Alignment.centerLeft,
      ));
    }
    if (!isSelectedItem || showWrittenLanguage) {
      rowElements.add(Text(
        LanguageUtils.getFullNameForLangCode(langCode),
        textAlign: TextAlign.center,
      ));
    }

    if (isSelectedItem) {
      if (showWrittenLanguage) {
        return SizedBox(
          width: 130,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: rowElements,
          ),
        );
      } else {
        return SizedBox(
          width: 70,
          child: getFlagImageOfLangCode(
            langCode: langCode,
            flagAlignment: Alignment.centerRight,
          ),
        );
      }
    } else {
      return SizedBox(
        width: 130,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: rowElements,
        ),
      );
    }
  }
}

/// Style options for the flag image used in the `LanguageSwitcher` widget.
enum FlagStyle {
  /// Rounded style flag image.
  rounded,

  /// Waving style flag image.
  waving,

  /// Original style flag image.
  original,
}
