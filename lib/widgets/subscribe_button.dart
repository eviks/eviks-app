import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SubscribeButton extends StatefulWidget {
  const SubscribeButton();

  @override
  State<SubscribeButton> createState() => _SubscribeButtonState();
}

class _SubscribeButtonState extends State<SubscribeButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: const Icon(CustomIcons.bell),
      label: Text(AppLocalizations.of(context)!.subscribeButton),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(8.0),
        minimumSize: const Size(50, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        primary: Theme.of(context).backgroundColor.withOpacity(0.9),
        onPrimary: Theme.of(context).textTheme.bodyText1?.color,
      ),
    );
  }
}
