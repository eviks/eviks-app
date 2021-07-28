import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/sized_config.dart';
import '../widgets/styled_input.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: SizeConfig.blockSizeVertical * 100.0,
        child: Stack(
          children: [
            Image.asset(
              "assets/img/illustrations/auth.png",
              width: double.infinity,
              height: SizeConfig.blockSizeVertical * 40.0,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(.5),
                        blurRadius: 20.0,
                        offset: const Offset(
                          5.0,
                          5.0,
                        ),
                      ),
                    ],
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(50.0),
                        topRight: Radius.circular(50.0)),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Text(
                                AppLocalizations.of(context)!.signInTitle,
                                style: const TextStyle(
                                    fontSize: 32.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 32.0,
                              ),
                              StyledInput(
                                icon: Icons.email,
                                title: AppLocalizations.of(context)!.authEmail,
                              ),
                              StyledInput(
                                icon: Icons.lock,
                                title:
                                    AppLocalizations.of(context)!.authPassword,
                              ),
                              Container(
                                padding: const EdgeInsets.only(top: 8.0),
                                width: double.infinity,
                                height: 60.0,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  child: Text(
                                    AppLocalizations.of(context)!.loginButton,
                                    style: const TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
