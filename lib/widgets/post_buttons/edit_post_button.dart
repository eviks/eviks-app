import 'package:eviks_mobile/icons.dart';
import 'package:eviks_mobile/models/post.dart';
import 'package:flutter/material.dart';

import '../../screens/edit_post_screen/edit_post_screen.dart';

class EditPostButton extends StatelessWidget {
  final int postId;
  final ReviewStatus? reviewStatus;
  final PostType postType;

  const EditPostButton({
    required this.postId,
    required this.reviewStatus,
    required this.postType,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: reviewStatus == ReviewStatus.onreview
          ? null
          : () => Navigator.of(context)
              .pushNamed(EditPostScreen.routeName, arguments: postId),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
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
