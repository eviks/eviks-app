import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

import './verification.dart';
import '../../constants.dart';
import '../../models/failure.dart';
import '../../providers/auth.dart';
import '../../widgets/styled_elevated_button.dart';
import '../../widgets/styled_input.dart';

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
  var _showPassword = false;
  final Map<String, String> _authData = {
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

    String errorMessage = '';
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    try {
      await Provider.of<Auth>(context, listen: false).register(
        _authData['displayName']!,
        _authData['email']!,
        _authData['password']!,
      );
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

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Verification(
          email: _authData['email']!,
        ),
      ),
    );
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
              height: 16.0,
            ),
            StyledInput(
              icon: CustomIcons.user,
              title: AppLocalizations.of(context)!.displayName,
              keyboardType: TextInputType.name,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.errorRequiredField;
                }
                return null;
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
              controller: _passwordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.errorPassword;
                } else if (value.length < 6) {
                  return AppLocalizations.of(context)!.invalidPassword;
                }
                return null;
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
            StyledElevatedButton(
              onPressed: () {
                widget.switchAuthMode(AuthMode.login);
              },
              text: AppLocalizations.of(context)!.login,
              secondary: true,
            )
          ],
        ),
      ),
    );
  }
}
