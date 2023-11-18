import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../models/failure.dart';
import '../../providers/auth.dart';
import '../../widgets/styled_elevated_button.dart';
import '../../widgets/styled_input.dart';
import '../reset_password_screen/reset_password_screen.dart';
import '../tabs_screen.dart';

class LoginForm extends StatefulWidget {
  final Function switchAuthMode;

  const LoginForm(this.switchAuthMode);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLoading = false;
  var _showPassword = false;
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  Future<void> _login() async {
    if (_formKey.currentState == null) {
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    _formKey.currentState!.save();

    String errorMessage = '';
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    try {
      await Provider.of<Auth>(context, listen: false)
          .login(_authData['email']!, _authData['password']!);
    } on Failure catch (error) {
      if (error.statusCode >= 500) {
        errorMessage = AppLocalizations.of(context)!.serverError;
      } else {
        errorMessage = error.toString();
      }
    } catch (error) {
      errorMessage = AppLocalizations.of(context)!.unknownError;
    }

    setState(() {
      _isLoading = false;
    });

    if (!mounted) return;

    if (errorMessage.isNotEmpty) {
      showSnackBar(context, errorMessage);
      return;
    }

    Navigator.of(context)
        .pushNamedAndRemoveUntil(TabsScreen.routeName, (route) => false);
  }

  Future<void> _loginWithGoogle() async {
    String errorMessage = '';
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    try {
      await Provider.of<Auth>(context, listen: false).loginWithGoogle();
    } on Failure catch (error) {
      if (error.statusCode >= 500) {
        errorMessage = AppLocalizations.of(context)!.serverError;
      } else {
        errorMessage = error.toString();
      }
    } catch (error) {
      errorMessage = AppLocalizations.of(context)!.unknownError;
    }

    if (!mounted) return;

    if (errorMessage.isNotEmpty) {
      showSnackBar(context, errorMessage);
      return;
    }

    Navigator.of(context)
        .pushNamedAndRemoveUntil(TabsScreen.routeName, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: AnimationConfiguration.toStaggeredList(
          childAnimationBuilder: (widget) => SlideAnimation(
            duration: const Duration(milliseconds: 375),
            verticalOffset: 50.0,
            child: FadeInAnimation(
              duration: const Duration(milliseconds: 375),
              child: widget,
            ),
          ),
          children: [
            const SizedBox(
              height: 8.0,
            ),
            StyledInput(
              icon: CustomIcons.email,
              title: AppLocalizations.of(context)!.authEmail,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.errorEmail;
                }
                return null;
              },
              onSaved: (value) {
                _authData['email'] = value ?? '';
              },
            ),
            StyledInput(
              icon: CustomIcons.password,
              title: AppLocalizations.of(context)!.password,
              suffixIcon: IconButton(
                icon: Icon(
                  _showPassword
                      ? CustomIcons.hidepassword
                      : CustomIcons.showpassword,
                ),
                onPressed: () {
                  setState(() {
                    _showPassword = !_showPassword;
                  });
                },
              ),
              obscureText: !_showPassword,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.errorPassword;
                }
                return null;
              },
              onSaved: (value) {
                _authData['password'] = value ?? '';
              },
            ),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, ResetPasswordScreen.routeName);
              },
              child: Text(
                AppLocalizations.of(context)!.oopsforgotPassword,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            const SizedBox(
              height: 4.0,
            ),
            StyledElevatedButton(
              text: AppLocalizations.of(context)!.loginButton,
              onPressed: _login,
              loading: _isLoading,
            ),
            StyledElevatedButton(
              onPressed: () {
                widget.switchAuthMode(AuthMode.register);
              },
              secondary: true,
              text: AppLocalizations.of(context)!.createAccount,
            ),
            Row(
              children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32.0,
                    vertical: 16.0,
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.loginOr,
                  ),
                ),
                const Expanded(child: Divider()),
              ],
            ),
            Container(
              padding: const EdgeInsets.only(
                top: 8.0,
              ),
              height: 60.0,
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: Image.asset(
                  "assets/img/svg/google.png",
                  height: 24.0,
                ),
                label: Text(
                  AppLocalizations.of(context)!.loginWithGoogle,
                ),
                onPressed: _loginWithGoogle,
                style: OutlinedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.background,
                  foregroundColor: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
