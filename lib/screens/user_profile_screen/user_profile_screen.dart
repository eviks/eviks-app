import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../providers/auth.dart';
import '../../screens/tabs_screen.dart';
import '../../widgets/sized_config.dart';
import './user_info.dart';
import './user_profile_menu.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _logout() async {
      try {
        await Provider.of<Auth>(context, listen: false).logout();
      } catch (error) {
        rethrow;
      }

      Navigator.of(context)
          .pushNamedAndRemoveUntil(TabsScreen.routeName, (route) => false);
    }

    return Scaffold(
      body: Center(
        child: Container(
          height: SizeConfig.safeBlockVertical * 100.0,
          margin: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const UserInfo(),
              UserProfileMenu(
                title: AppLocalizations.of(context)!.logout,
                onPressed: _logout,
              )
            ],
          ),
        ),
      ),
    );
  }
}
