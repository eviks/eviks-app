import 'package:flutter/material.dart';

class UserProfileMenu extends StatelessWidget {
  final String title;
  final void Function()? onPressed;

  const UserProfileMenu({required this.title, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextButton(
        onPressed: onPressed,
        child: Text(title,
            style: TextStyle(
                fontSize: 16.0,
                color: Theme.of(context).textTheme.bodyText1?.color)),
      ),
    );
  }
}
