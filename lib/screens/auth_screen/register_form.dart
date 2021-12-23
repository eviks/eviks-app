import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../models/failure.dart';
import '../../providers/auth.dart';
import '../../widgets/styled_elevated_button.dart';
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

  Future<void> _register() async {
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
      await Provider.of<Auth>(context, listen: false).register(
        _authData['username']!,
        _authData['displayName']!,
        _authData['email']!,
        _authData['password']!,
      );
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
            icon: CustomIcons.user,
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
            icon: CustomIcons.user,
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
          StyledElevatedButton(
            text: AppLocalizations.of(context)!.registerButton,
            onPressed: _register,
            loading: _isLoading,
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
