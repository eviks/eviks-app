import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import './user_info.dart';
import './user_profile_menu.dart';
import '../../constants.dart';
import '../../models/failure.dart';
import '../../providers/auth.dart';
import '../../screens/tabs_screen.dart';
import '../../widgets/sized_config.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _logout() async {
      String _errorMessage = '';
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      try {
        await Provider.of<Auth>(context, listen: false).logout();
      } on Failure catch (error) {
        if (error.statusCode >= 500) {
          _errorMessage = AppLocalizations.of(context)!.serverError;
        } else {
          _errorMessage = error.toString();
        }
      } catch (error) {
        _errorMessage = AppLocalizations.of(context)!.unknownError;
      }

      if (_errorMessage.isNotEmpty) {
        displayErrorMessage(context, _errorMessage);
        return;
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
