import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../models/failure.dart';
import '../../providers/auth.dart';
import '../../widgets/styled_input.dart';
import '../tabs_screen.dart';

class LoginForm extends StatefulWidget {
  final Function switchAuthMode;

  const LoginForm(this.switchAuthMode);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  var _isLoading = false;
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  void _login() async {
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

    String _errorMessage = '';
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    try {
      await Provider.of<Auth>(context, listen: false)
          .login(_authData['email']!, _authData['password']!);
    } on Failure catch (error) {
      if (error.statusCode >= 500) {
        _errorMessage = AppLocalizations.of(context)!.serverError;
      } else {
        _errorMessage = error.toString();
      }
    } catch (error) {
      _errorMessage = AppLocalizations.of(context)!.unknownError;
    }

    setState(() {
      _isLoading = false;
    });

    if (_errorMessage.isNotEmpty) {
      displayErrorMessage(context, _errorMessage);
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
        children: [
          const SizedBox(
            height: 32.0,
          ),
          StyledInput(
            icon: CustomIcons.email,
            title: AppLocalizations.of(context)!.authEmail,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!.errorEmail;
              }
            },
            onSaved: (value) {
              _authData['email'] = value ?? '';
            },
          ),
          StyledInput(
            icon: CustomIcons.password,
            title: AppLocalizations.of(context)!.authPassword,
            obscureText: true,
            controller: _passwordController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!.errorPassword;
              }
            },
            onSaved: (value) {
              _authData['password'] = value ?? '';
            },
          ),
          Container(
            padding: const EdgeInsets.only(
              top: 8.0,
            ),
            width: double.infinity,
            height: 60.0,
            child: ElevatedButton(
              onPressed: _login,
              child: _isLoading
                  ? SizedBox(
                      width: 24.0,
                      height: 24.0,
                      child: CircularProgressIndicator(
                        color: Theme.of(context).backgroundColor,
                      ),
                    )
                  : Text(
                      AppLocalizations.of(context)!.loginButton,
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          TextButton(
            onPressed: () {
              widget.switchAuthMode(AuthMode.register);
            },
            child: Text(AppLocalizations.of(context)!.createAccount),
          )
        ],
      ),
    );
  }
}
