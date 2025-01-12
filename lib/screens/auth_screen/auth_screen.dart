import 'package:eviks_mobile/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../providers/auth.dart';
import '../../widgets/sized_config.dart';
import './login_form.dart';
import './register_form.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth';

  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  AuthMode _authMode = AuthMode.login;
  Widget _title = const LoginTitle();

  void switchAuthMode(AuthMode mode) {
    setState(() {
      _authMode = mode;
      _title =
          mode == AuthMode.login ? const LoginTitle() : const RegisterTitle();
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [lightPrimaryColor, darkPrimaryColor],
            ),
          ),
          width: double.infinity,
          child: SafeArea(
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: SizeConfig.safeBlockVertical * 27.0,
                  child: Stack(
                    children: [
                      Visibility(
                        visible: MediaQuery.of(context).orientation ==
                            Orientation.portrait,
                        child: IgnorePointer(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Image.asset(
                                "assets/img/illustrations/auth.png",
                              ),
                              const SizedBox(
                                width: 16.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(
                              LucideIcons.x,
                              color: Theme.of(context).colorScheme.surface,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                          child: _title,
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(
                          50.0,
                        ),
                        topRight: Radius.circular(
                          50.0,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(
                            32.0,
                          ),
                          child: _authMode == AuthMode.login
                              ? LoginForm(switchAuthMode)
                              : RegisterForm(switchAuthMode),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoginTitle extends StatelessWidget {
  const LoginTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.signInTitle,
          style: TextStyle(
            color: Theme.of(context).colorScheme.surface,
            fontSize: 32.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          AppLocalizations.of(context)!.signInSubtitle,
          style: TextStyle(
            color: Theme.of(context).colorScheme.surface,
            fontSize: 18.0,
          ),
        ),
      ],
    );
  }
}

class RegisterTitle extends StatelessWidget {
  const RegisterTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.signUpTitle,
          style: TextStyle(
            color: Theme.of(context).colorScheme.surface,
            fontSize: 32.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          AppLocalizations.of(context)!.signUpSubtitle,
          style: TextStyle(
            color: Theme.of(context).colorScheme.surface,
            fontSize: 18.0,
          ),
        ),
      ],
    );
  }
}
