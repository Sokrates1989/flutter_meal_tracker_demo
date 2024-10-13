// Copyright (C) 2024 Patrick Michiels
// All rights reserved.
// This source code is licensed under the Evaluation License Agreement and
// may not be used, modified, or distributed without explicit permission from the author.
// This code is provided for evaluation purposes only.

// Public package imports.
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Custom package imports.
import 'package:engaige_meal_tracker_demo/constants/colors.dart';
import 'package:engaige_meal_tracker_demo/providers/navigation_provider.dart';
import 'package:engaige_meal_tracker_demo/widgets/language_switcher.dart';
import 'package:engaige_meal_tracker_demo/constants/sizes.dart';
import 'package:engaige_meal_tracker_demo/utils/ui/responsive_design_utils.dart';

/// A custom AppBar widget with a leading back button, title, and a language switcher.
///
/// The `CustomAppBar` displays a back navigation icon, a title centered with a logo,
/// and a language switcher on the right. It also includes a bottom divider for styling.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// The [BuildContext] for the custom AppBar.
  final BuildContext context;

  /// Constructs a `CustomAppBar` widget.
  ///
  /// - [context]: The context in which the widget is built.
  const CustomAppBar({super.key, required this.context});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: kColors_backgroundColor_default,
      elevation: 0.2,
      leading: _buildAppBarLeadingWidget(context),
      title: _buildAppBarTitleWidget(),
      bottom: _buildAppBarBottomWidget(),
    );
  }

  /// Builds the leading widget of the AppBar, containing a back button and label.
  Row _buildAppBarLeadingWidget(BuildContext context) {
    // Get currentScreenWidth for responsive layout building.
    double currentScreenWidth = MediaQuery.of(context).size.width;

    return Row(
      children: [
        IconButton(
          iconSize: ResponsiveDesignUtils.interpolateBestDouble(
              InterpolationDoubleValues(
                  min: kSizes_appBar_backNavigation_iconSize_min,
                  max: kSizes_appBar_backNavigation_iconSize_max),
              currentScreenWidth),
          icon: const Icon(Icons.arrow_back),
          color: kColors_backNavigationIconColor,
          onPressed: () {
            Provider.of<NavigationProvider>(context, listen: false)
                .navigateToBackNavigationDestination(context);
          },
        ),
        Text(
          tr("mealsOverviewDaily_appBarBackNavigationText"),
          style: TextStyle(
            color: kColors_backNavigationTextColor,
            fontSize: ResponsiveDesignUtils.interpolateBestDouble(
                InterpolationDoubleValues(
                    min: kSizes_appBar_backNavigation_textSize_min,
                    max: kSizes_appBar_backNavigation_textSize_max),
                currentScreenWidth),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  /// Builds the title widget for the AppBar, displaying the logo and the title text.
  Center _buildAppBarTitleWidget() {
    // Get currentScreenWidth for responsive layout building.
    double currentScreenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              width: ResponsiveDesignUtils.interpolateBestDouble(
                  InterpolationDoubleValues(
                      min: kSizes_appBar_title_startSpacerWidth_min,
                      max: kSizes_appBar_title_startSpacerWidth_max),
                  currentScreenWidth,
                  invertedLogic: true)),
          // Spacer to center the title
          Material(
            type: MaterialType.transparency,
            child: Hero(
              tag: 'logo',
              child: CircleAvatar(
                radius: ResponsiveDesignUtils.interpolateBestDouble(
                    InterpolationDoubleValues(
                        min: kSizes_appBar_title_iconSize_min,
                        max: kSizes_appBar_title_iconSize_max),
                    currentScreenWidth),
                backgroundImage: AssetImage(
                    'assets/images/meal_tracker_demo_icon_circle_400px.png'),
                backgroundColor: kColors_backgroundColor_default,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            tr("mealsOverviewDaily_appBarTitle"),
            style: TextStyle(
              color: kColors_defaultTextColor,
              fontSize: ResponsiveDesignUtils.interpolateBestDouble(
                  InterpolationDoubleValues(
                      min: kSizes_appBar_title_textFont_min,
                      max: kSizes_appBar_title_textFont_max),
                  currentScreenWidth),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
              width: ResponsiveDesignUtils.interpolateBestDouble(
                  InterpolationDoubleValues(
                      min: kSizes_appBar_title_endSpacerWidth_min,
                      max: kSizes_appBar_title_endSpacerWidth_max),
                  currentScreenWidth,
                  invertedLogic: false)),
          // Spacer to center the title
        ],
      ),
    );
  }

  /// Builds the language switcher widget that appears on the right side of the AppBar.
  Widget _buildLanguageSwitcher(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: LanguageSwitcher(
        locale: context.locale,
        dropDownIconColor: kColors_languageSwitcher_dropDownIconColor,
        flagWidth: 34,
      ),
    );
  }

  /// Builds the bottom divider for the AppBar with additional padding above.
  PreferredSize _buildAppBarBottomWidget() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(4.0),
      child: Column(
        children: [
          const SizedBox(height: 4), // Adds space above the divider
          Container(
            color: kColors_appBar_bottomDividerColor,
            height: 2.0,
          ),
        ],
      ),
    );
  }
}
