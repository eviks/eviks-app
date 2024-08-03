import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants.dart';
import '../../models/failure.dart';
import '../../providers/auth.dart';
import '../../screens/tabs_screen.dart';
import '../../widgets/sized_config.dart';
import '../auth_screen/auth_screen.dart';
import './menu/locale_settings.dart';
import './menu/profile_settings.dart';
import './menu/theme_mode_settings.dart';
import './menu/user_posts.dart';
import './user_info.dart';
import './user_profile_menu.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    final isAuth = Provider.of<Auth>(context, listen: false).isAuth;

    Future<void> logout() async {
      String errorMessage = '';
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      try {
        await Provider.of<Auth>(context, listen: false).logout();
      } on Failure catch (error) {
        if (error.statusCode >= 500) {
          errorMessage = AppLocalizations.of(context)!.serverError;
        } else {
          errorMessage = error.toString();
        }
      } catch (error) {
        errorMessage = AppLocalizations.of(context)!.unknownError;
      }

      if (!mounted) return;

      if (errorMessage.isNotEmpty) {
        showSnackBar(context, errorMessage);
        return;
      }
      Navigator.of(context)
          .pushNamedAndRemoveUntil(TabsScreen.routeName, (route) => false);
    }

    void login() {
      Navigator.of(context).pushNamed(AuthScreen.routeName);
    }

    void goToUserPosts() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserPosts(),
        ),
      );
    }

    void goToProfileSettings() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ProfileSettings(),
        ),
      );
    }

    void changeThemeMode() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ThemeModeSettings(),
        ),
      );
    }

    void changeLanguage() {
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
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
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
                if (isAuth)
                  Column(
                    children: [
                      UserProfileMenu(
                        title: AppLocalizations.of(context)!.myPosts,
                        icon: CustomIcons.bookmark,
                        onPressed: goToUserPosts,
                      ),
                      UserProfileMenu(
                        title: AppLocalizations.of(context)!.profileSettings,
                        icon: CustomIcons.user,
                        onPressed: goToProfileSettings,
                      ),
                    ],
                  ),
                if (!isAuth)
                  UserProfileMenu(
                    title: AppLocalizations.of(context)!.login,
                    icon: CustomIcons.login,
                    onPressed: login,
                  ),
                UserProfileMenu(
                  title: AppLocalizations.of(context)!.theme,
                  icon: CustomIcons.thememode,
                  onPressed: changeThemeMode,
                ),
                UserProfileMenu(
                  title: AppLocalizations.of(context)!.language,
                  icon: CustomIcons.globe,
                  onPressed: changeLanguage,
                ),
                if (isAuth)
                  UserProfileMenu(
                    title: AppLocalizations.of(context)!.logout,
                    icon: CustomIcons.logout,
                    onPressed: logout,
                  ),
                const Text(appVersion),
                const SizedBox(
                  height: 5.0,
                ),
                InkWell(
                  child: const Text(
                    'Illustrations by Icons 8 from Ouch!',
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                  onTap: () async {
                    final uri = Uri.parse('https://icons8.com/illustrations/');
                    await launchUrl(uri);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
