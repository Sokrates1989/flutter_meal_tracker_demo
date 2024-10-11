// Public packages imports.
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

// Own package imports.
import 'package:engaige_meal_tracker_demo/screens/meals_overview_daily.dart';
import 'package:engaige_meal_tracker_demo/widgets/language_switcher.dart';
import 'package:engaige_meal_tracker_demo/utils/auth_service.dart';
import 'package:engaige_meal_tracker_demo/widgets/remember_me_checkbox.dart';
import 'package:engaige_meal_tracker_demo/constants/themes.dart';
import 'package:engaige_meal_tracker_demo/models/user.dart';
import 'package:engaige_meal_tracker_demo/providers/data_provider.dart';
import 'package:engaige_meal_tracker_demo/utils/shared_pref_utils.dart';

/// The `WelcomeScreen` class is the first screen users see when they open the app.
///
/// It includes a login and sign-up form, along with options for switching
/// languages and saving login credentials.
class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;

  final SharedPrefUtils sharedPref = SharedPrefUtils();
  bool isRememberUserAndPasswordEnabled = true;
  String? savedUserName;
  String? savedPassword;

  @override
  void initState() {
    super.initState();

    // Initialize animation for the background color transition.
    controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
        .animate(controller);
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });

    // Load saved login preferences.
    _getSharedPref();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  /// Loads the user's saved preferences for login credentials and "Remember Me" option.
  Future<void> _getSharedPref() async {
    isRememberUserAndPasswordEnabled =
    await sharedPref.get("isRememberUserAndPasswordEnabled");
    savedUserName = await sharedPref.get("lastLoggedInUserName");
    savedPassword = await sharedPref.get("lastLoggedInUserPassword");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: savedUserName == null
          ? const CircularProgressIndicator()
          : FlutterLogin(
        theme: kThemes_loginTheme,
        title: tr('title'),
        logo: const AssetImage('assets/images/meal_tracker_demo_icon_circle_400px.png'),
        headerWidget: _buildHeaderWidget(context),
        onLogin: (loginData) => AuthService(context).loginUser(
            loginData, isRememberUserAndPasswordEnabled),
        onSignup: (signupData) => AuthService(context).signupUser(
            signupData, isRememberUserAndPasswordEnabled),
        hideForgotPasswordButton: true,
        savedEmail: savedUserName!,
        savedPassword: savedPassword!,
        passwordValidator: _passwordValidator,
        userValidator: _userNameValidator,
        userType: LoginUserType.name,
        onSubmitAnimationCompleted: _onSubmitCompleted,
        loginProviders: [
          LoginProvider(
            icon: Icons.list,
            label: tr('Demonstration'),
            callback: () async {
              await AuthService(context).logInDemoUserFlutterLogin();
              return null;
            },
          ),
        ],
        onRecoverPassword: _recoverPassword,
      ),
    );
  }

  /// Builds the header widget for the login form.
  ///
  /// The header contains the "Remember Me" checkbox and the language switcher.
  Widget _buildHeaderWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RememberMeCheckbox(
          isChecked: isRememberUserAndPasswordEnabled,
          onChanged: _setRememberMeState,
        ),
        LanguageSwitcher(
          locale: context.locale,
          dropDownIconColor: Colors.blue[700]?.withOpacity(0.8),
          flagWidth: 34,
        ),
      ],
    );
  }

  /// Toggles the "Remember Me" state and updates shared preferences accordingly.
  ///
  /// - [newState]: The new state of the "Remember Me" checkbox.
  void _setRememberMeState(bool newState) {
    setState(() {
      isRememberUserAndPasswordEnabled = newState;
      sharedPref.set("isRememberUserAndPasswordEnabled", newState);

      if (!newState) {
        sharedPref.set("lastLoggedInUserName", "");
        sharedPref.set("lastLoggedInUserPassword", "");
      }
    });
  }

  /// Called when the login/signup animation completes, navigates to the main app screen.
  Future<void> _onSubmitCompleted() async {
    User user = await Provider.of<DataProvider>(context, listen: false)
        .getLoggedInUser_async();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const MealsDailyOverviewScreen()),
    );
  }

  /// A placeholder function for password recovery, currently disabled.
  Future<String?> _recoverPassword(String name) {
    return Future.delayed(const Duration(milliseconds: 2250), () => null);
  }

  /// Validates the password entered by the user.
  ///
  /// The password must be at least 3 characters long.
  ///
  /// - [value]: The password entered by the user.
  ///
  /// Returns an error message if the password is too short, otherwise `null`.
  String? _passwordValidator(String? value) {
    return value!.length < 3 ? tr('Password is too short') : null;
  }

  /// Validates the username entered by the user.
  ///
  /// The username must be at least 3 characters long.
  ///
  /// - [value]: The username entered by the user.
  ///
  /// Returns an error message if the username is too short, otherwise returns `null`.
  static String? _userNameValidator(String? value) {
    return value!.length < 3 ? tr('Username is too short') : null;
  }
}
