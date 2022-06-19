import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../providers/theme_preferences.dart';

class UserProfileMenu extends StatelessWidget {
  final String title;
  final IconData icon;
  final void Function()? onPressed;

  const UserProfileMenu(
      {required this.title, required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode =
        Provider.of<ThemePreferences>(context, listen: true).themeMode ==
            ThemeMode.dark;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
                side: BorderSide(
                  width: isDarkMode ? 0 : 1,
                  color: isDarkMode ? Colors.transparent : lightGreyColor,
                )),
          ),
          backgroundColor: MaterialStateProperty.all(
            isDarkMode ? softDarkColor : lightColor,
          ),
          padding: MaterialStateProperty.all(
              const EdgeInsets.symmetric(vertical: 2.0, horizontal: 18.0)),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 16.0),
                  child: Icon(icon),
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: isDarkMode ? lightGreyColor : darkColor,
                  ),
                ),
              ],
            ),
            const Icon(CustomIcons.next),
          ],
        ),
      ),
    );
  }
}
