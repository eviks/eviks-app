import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import './menu/locale_settings.dart';
import './menu/profile_settings.dart';
import './menu/theme_mode_settings.dart';
import './menu/user_posts.dart';
import './user_info.dart';
import './user_profile_menu.dart';
import '../../constants.dart';
import '../../models/failure.dart';
import '../../providers/auth.dart';
import '../../screens/tabs_screen.dart';
import '../../widgets/sized_config.dart';
import '../auth_screen/auth_screen.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    final _isAuth = Provider.of<Auth>(context, listen: false).isAuth;

    Future<void> _logout() async {
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
        showSnackBar(context, _errorMessage);
        return;
      }
      Navigator.of(context)
          .pushNamedAndRemoveUntil(TabsScreen.routeName, (route) => false);
    }

    void _login() {
      Navigator.of(context).pushNamed(AuthScreen.routeName);
    }

    void _goToUserPosts() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserPosts(),
        ),
      );
    }

    void _goToProfileSettings() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ProfileSettings(),
        ),
      );
    }

    void _changeThemeMode() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ThemeModeSettings(),
        ),
      );
    }

    void _changeLanguage() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LocaleSettings(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.profile,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            constraints: BoxConstraints(
              minHeight: SizeConfig.safeBlockVertical * 70.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const UserInfo(),
                const SizedBox(
                  height: 8.0,
                ),
                if (_isAuth)
                  Column(
                    children: [
                      UserProfileMenu(
                        title: AppLocalizations.of(context)!.myPosts,
                        icon: CustomIcons.bookmark,
                        onPressed: _goToUserPosts,
                      ),
                      UserProfileMenu(
                        title: AppLocalizations.of(context)!.profileSettings,
                        icon: CustomIcons.user,
                        onPressed: _goToProfileSettings,
                      ),
                    ],
                  ),
                if (!_isAuth)
                  UserProfileMenu(
                    title: AppLocalizations.of(context)!.login,
                    icon: CustomIcons.login,
                    onPressed: _login,
                  ),
                UserProfileMenu(
                  title: AppLocalizations.of(context)!.theme,
                  icon: CustomIcons.thememode,
                  onPressed: _changeThemeMode,
                ),
                UserProfileMenu(
                  title: AppLocalizations.of(context)!.language,
                  icon: CustomIcons.globe,
                  onPressed: _changeLanguage,
                ),
                if (_isAuth)
                  UserProfileMenu(
                    title: AppLocalizations.of(context)!.logout,
                    icon: CustomIcons.logout,
                    onPressed: _logout,
                  ),
                const Text('0.0.1'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
