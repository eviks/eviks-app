import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';

class UserProfileMenu extends StatelessWidget {
  final String title;
  final IconData icon;
  final void Function()? onPressed;

  const UserProfileMenu(
      {required this.title, required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: OutlinedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
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
                      color: Theme.of(context).textTheme.bodyText1?.color),
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
