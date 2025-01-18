import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../providers/auth.dart';
import '../../screens/auth_screen/auth_screen.dart';
import '../../widgets/subscription_modal.dart';

class SubscribeButton extends StatefulWidget {
  final String url;

  const SubscribeButton(
    this.url,
  );

  @override
  State<SubscribeButton> createState() => _SubscribeButtonState();
}

class _SubscribeButtonState extends State<SubscribeButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        final user = Provider.of<Auth>(context, listen: false).user;
        if (user == null) {
          Navigator.of(context).pushNamed(AuthScreen.routeName);
          return;
        }
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
            return SubscriptionModal(
              url: widget.url,
              name: '',
              id: '',
              notify: false,
            );
          },
        );
      },
      icon: const Icon(LucideIcons.bell),
      label: Text(AppLocalizations.of(context)!.subscribeButton),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(8.0),
        minimumSize: const Size(50, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.9),
        foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
      ),
    );
  }
}
