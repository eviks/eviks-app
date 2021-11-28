import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../providers/auth.dart';
import '../../widgets/sized_config.dart';
import './background.dart';
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

  void switchAuthMode(AuthMode mode) {
    setState(() {
      _authMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Theme.of(context).primaryColor,
          width: double.infinity,
          child: SafeArea(
            child: Column(
              children: [
                CustomPaint(
                  painter: Background(Theme.of(context).primaryColor),
                  child: SizedBox(
                    width: double.infinity,
                    height: SizeConfig.safeBlockVertical * 30.0,
                    child: Stack(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(
                                CustomIcons.close,
                                color: Theme.of(context).backgroundColor,
                              ),
                              onPressed: () {
                                print('123');
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _authMode == AuthMode.login
                                    ? AppLocalizations.of(context)!.signInTitle
                                    : AppLocalizations.of(context)!.signUpTitle,
                                style: TextStyle(
                                  color: Theme.of(context).backgroundColor,
                                  fontSize: 32.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                _authMode == AuthMode.login
                                    ? AppLocalizations.of(context)!
                                        .signInSubtitle
                                    : AppLocalizations.of(context)!
                                        .signUpSubtitle,
                                style: TextStyle(
                                  color: Theme.of(context).backgroundColor,
                                  fontSize: 18.0,
                                ),
                              ),
                            ],
                          ),
                        ),
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
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    constraints: BoxConstraints(
                        minHeight: SizeConfig.safeBlockVertical * 70.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).backgroundColor,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(
                            50.0,
                          ),
                          topRight: Radius.circular(
                            50.0,
                          )),
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
