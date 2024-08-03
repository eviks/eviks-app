import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../models/failure.dart';
import '../../providers/auth.dart';
import '../../widgets/sized_config.dart';
import '../../widgets/styled_elevated_button.dart';
import '../../widgets/styled_input.dart';
import './reset_password_verification.dart';

class ResetPasswordScreen extends StatefulWidget {
  static const routeName = '/reset_password';

  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  var _isLoading = false;
  String _email = '';

  Future<void> _generateResetPasswordToken() async {
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
          .createResetPasswordToken(_email);
    } on Failure catch (error) {
      if (error.statusCode >= 500) {
        if (!mounted) return;
        errorMessage = AppLocalizations.of(context)!.serverError;
      } else {
        errorMessage = error.toString();
      }
    } catch (error) {
      if (!mounted) return;
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
        builder: (context) => ResetPasswordVerification(
          email: _email,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        leading: Navigator.canPop(context)
            ? IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(CustomIcons.back),
              )
            : null,
        title: Text(
          AppLocalizations.of(context)!.resetPassword,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  SizedBox(
                    height: SizeConfig.safeBlockVertical * 40.0,
                    child: Image.asset(
                      "assets/img/illustrations/reset_password.png",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.resetPasswordTitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        Text(
                          AppLocalizations.of(context)!.resetPasswordHint,
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(color: Theme.of(context).dividerColor),
                        ),
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
                            _email = value ?? '';
                          },
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                            top: 8.0,
                          ),
                          height: 60.0,
                          child: StyledElevatedButton(
                            onPressed: _generateResetPasswordToken,
                            text: AppLocalizations.of(context)!
                                .resetPasswordButton,
                            loading: _isLoading,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
