import 'package:eviks_mobile/icons.dart';
import 'package:eviks_mobile/models/subscription.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../providers/subscriptions.dart';
import '../../widgets/styled_elevated_button.dart';
import '../../widgets/styled_input.dart';
import '../models/failure.dart';

class SubscribeButton extends StatefulWidget {
  final String url;

  const SubscribeButton(
    this.url,
  );

  @override
  State<SubscribeButton> createState() => _SubscribeButtonState();
}

class _SubscribeButtonState extends State<SubscribeButton> {
  String _name = '';
  final _formKey = GlobalKey<FormState>();
  String _errorText = '';

  @override
  Widget build(BuildContext context) {
    Future<void> subscribe() async {
      if (_formKey.currentState == null) {
        return;
      }

      _formKey.currentState!.save();

      if (!_formKey.currentState!.validate()) {
        return;
      }

      final deviceToken = await FirebaseMessaging.instance.getToken() ?? '';

      final Subscription subscription = Subscription(
        id: "0",
        name: _name,
        url: widget.url,
        deviceToken: deviceToken,
      );

      String errorMessage = '';
      if (!mounted) return;
      try {
        await Provider.of<Subscriptions>(context, listen: false)
            .subscribe(subscription);
      } on Failure catch (error) {
        if (error.statusCode >= 500) {
          errorMessage = AppLocalizations.of(context)!.serverError;
        } else {
          errorMessage = error.toString();
        }
      } catch (error) {
        errorMessage = AppLocalizations.of(context)!.unknownError;
      }

      if (errorMessage.isNotEmpty) {
        if (!mounted) return;
        setState(() {
          _errorText = errorMessage;
        });
        _formKey.currentState!.validate();
      } else {
        if (!mounted) return;
        Navigator.pop(context);
      }
    }

    return ElevatedButton.icon(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0),
            ),
          ),
          builder: (BuildContext context) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Form(
                key: _formKey,
                child: Container(
                  margin: const EdgeInsets.all(
                    32.0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.createSubscriptionTitle,
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
                        AppLocalizations.of(context)!.createSubscriptionHint,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      StyledInput(
                        icon: CustomIcons.search,
                        title: AppLocalizations.of(context)!.subscriptionName,
                        initialValue: _name,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!
                                .errorRequiredField;
                          }
                          if (_errorText.isNotEmpty) return _errorText;
                          return null;
                        },
                        onSaved: (value) {
                          _errorText = '';
                          _name = value ?? '';
                        },
                      ),
                      StyledElevatedButton(
                        text: AppLocalizations.of(context)!.subscribeButton,
                        height: 50.0,
                        onPressed: subscribe,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
      icon: const Icon(CustomIcons.bell),
      label: Text(AppLocalizations.of(context)!.subscribeButton),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(8.0),
        minimumSize: const Size(50, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        backgroundColor:
            Theme.of(context).colorScheme.background.withOpacity(0.9),
        foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
      ),
    );
  }
}
