// Copyright (C) 2024 Patrick Michiels
// All rights reserved.
// This source code is licensed under the Evaluation License Agreement and
// may not be used, modified, or distributed without explicit permission from the author.
// This code is provided for evaluation purposes only.

// Public package imports.
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

// Own package imports.
import 'package:engaige_meal_tracker_demo/screens/meals_overview_daily.dart';
import 'package:engaige_meal_tracker_demo/widgets/language_switcher.dart';
import 'package:engaige_meal_tracker_demo/constants/colors.dart';
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
  /// Identifier used for routing to this screen.
  static const String id = 'welcome_screen';

  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Color?> _animation;

  final SharedPrefUtils _sharedPref = SharedPrefUtils();
  bool _isRememberUserAndPasswordEnabled = true;
  String? _savedUserName;
  String? _savedPassword;

  @override
  void initState() {
    super.initState();

    // Initialize animation for background color transition.
    _controller = AnimationController(duration: const Duration(seconds: 1), vsync: this);
    _animation = ColorTween(begin: Colors.blueGrey, end: Colors.white).animate(_controller);
    _controller.forward();
    _controller.addListener(() {
      setState(() {});
    });

    // Load saved login preferences.
    _getSharedPref();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Loads the user's saved preferences for login credentials and "Remember Me" option.
  Future<void> _getSharedPref() async {
    _isRememberUserAndPasswordEnabled = await _sharedPref.get("isRememberUserAndPasswordEnabled");
    _savedUserName = await _sharedPref.get("lastLoggedInUserName");
    _savedPassword = await _sharedPref.get("lastLoggedInUserPassword");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _animation.value,
      body: _savedUserName == null
          ? const CircularProgressIndicator()
          : FlutterLogin(
        theme: getLoginTheme(context),
        title: tr('title'),
        logo: const AssetImage('assets/images/meal_tracker_demo_icon_circle_400px.png'),
        headerWidget: _buildHeaderWidget(context),
        onLogin: (loginData) => AuthService(context).loginUser(
            loginData, _isRememberUserAndPasswordEnabled),
        onSignup: (signupData) => AuthService(context).signupUser(
            signupData, _isRememberUserAndPasswordEnabled),
        hideForgotPasswordButton: true,
        messages: LoginMessages(
          userHint: tr('Username'),
          passwordHint: tr('Password'),
          confirmPasswordHint: tr('Confirm Password'),
          loginButton: tr('LOGIN'),
          signupButton: tr('SIGNUP'),
          // providersTitleFirst: tr('or login with'),
          providersTitleFirst: tr('or view Demo'),
          // providersTitleSecond: tr('or view Demo'),
        ),
        savedEmail: _savedUserName!,
        savedPassword: _savedPassword!,
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
          isChecked: _isRememberUserAndPasswordEnabled,
          onChanged: _setRememberMeState,
        ),
        LanguageSwitcher(
          locale: context.locale,
          dropDownIconColor: kColors_languageSwitcher_dropDownIconColor,
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
      _isRememberUserAndPasswordEnabled = newState;
      _sharedPref.set("isRememberUserAndPasswordEnabled", newState);

      if (!newState) {
        _sharedPref.set("lastLoggedInUserName", "");
        _sharedPref.set("lastLoggedInUserPassword", "");
      }
    });
  }

  /// Called when the login/signup animation completes, navigates to the main app screen.
  Future<void> _onSubmitCompleted() async {
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
