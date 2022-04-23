import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';

import '../../screens/edit_post_screen/edit_post_screen.dart';

class EditPostButton extends StatelessWidget {
  final int postId;

  const EditPostButton(
    this.postId,
  );

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => Navigator.of(context)
          .pushNamed(EditPostScreen.routeName, arguments: postId),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(0.0),
        minimumSize: const Size(50, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        fixedSize: const Size(50.0, 50.0),
        primary: Theme.of(context).backgroundColor,
        onPrimary: Theme.of(context).dividerColor,
      ),
      child: const Icon(CustomIcons.pencil),
    );
  }
}
