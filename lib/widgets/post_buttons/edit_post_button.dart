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
        shape: const CircleBorder(),
        fixedSize: const Size.fromRadius(25.0),
        primary: Theme.of(context).backgroundColor,
        onPrimary: Theme.of(context).dividerColor,
      ),
      child: const Icon(CustomIcons.pencil),
    );
  }
}
