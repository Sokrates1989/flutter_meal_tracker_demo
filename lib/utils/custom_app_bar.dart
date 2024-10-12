// Public package imports.
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Custom package imports.
import 'package:engaige_meal_tracker_demo/constants/colors.dart';
import 'package:engaige_meal_tracker_demo/providers/navigation_provider.dart';
import 'package:engaige_meal_tracker_demo/widgets/language_switcher.dart';

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
      actions: [_buildLanguageSwitcher(context)],
      bottom: _buildAppBarBottomWidget(),
    );
  }

  /// Builds the leading widget of the AppBar, containing a back button and label.
  Row _buildAppBarLeadingWidget(BuildContext context) {
    return Row(
      children: [
        IconButton(
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
            color:kColors_backNavigationTextColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  /// Builds the title widget for the AppBar, displaying the logo and the title text.
  Center _buildAppBarTitleWidget() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: 70), // Spacer to center the title
          const Material(
            type: MaterialType.transparency,
            child: Hero(
              tag: 'logo',
              child: CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage('assets/images/meal_tracker_demo_icon_circle_400px.png'),
                backgroundColor: kColors_backgroundColor_default,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            tr("mealsOverviewDaily_appBarTitle"),
            style: const TextStyle(
              color: kColors_defaultTextColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
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
            color: kColors_mealsOverViewScreenDaily_appBar_bottomDividerColor,
            height: 2.0,
          ),
        ],
      ),
    );
  }
}
