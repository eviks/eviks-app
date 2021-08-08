import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../providers/auth.dart';
import '../../widgets/styled_input.dart';
import '../verification_screen.dart';

class RegisterForm extends StatefulWidget {
  final Function switchAuthMode;

  const RegisterForm(this.switchAuthMode);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  var _isLoading = false;
  final Map<String, String> _authData = {
    'username': '',
    'displayName': '',
    'email': '',
    'password': '',
  };

  void _register() async {
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

    try {
      await Provider.of<Auth>(context, listen: false).register(
        _authData['username']!,
        _authData['displayName']!,
        _authData['email']!,
        _authData['password']!,
      );
    } catch (error) {
      rethrow;
    }

    setState(() {
      _isLoading = false;
    });

    Navigator.of(context).pushNamed(VerificationScreen.routeName);
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
            icon: Icons.account_circle,
            title: AppLocalizations.of(context)!.authUsername,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!.errorRequiredField;
              }
            },
            onSaved: (value) {
              _authData['username'] = value ?? '';
            },
          ),
          StyledInput(
            icon: Icons.account_circle,
            title: AppLocalizations.of(context)!.authDisplayName,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!.errorRequiredField;
              }
            },
            onSaved: (value) {
              _authData['displayName'] = value ?? '';
            },
          ),
          StyledInput(
            icon: Icons.email,
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
            icon: Icons.lock,
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
              onPressed: _register,
              child: _isLoading
                  ? SizedBox(
                      width: 24.0,
                      height: 24.0,
                      child: CircularProgressIndicator(
                        color: Theme.of(context).backgroundColor,
                      ),
                    )
                  : Text(
                      AppLocalizations.of(context)!.registerButton,
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          TextButton(
            onPressed: () {
              widget.switchAuthMode(AuthMode.login);
            },
            child: Text(AppLocalizations.of(context)!.login),
          )
        ],
      ),
    );
  }
}
