import 'package:eviks_mobile/models/post.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../screens/edit_post_screen/edit_post_screen.dart';

class EditPostButton extends StatelessWidget {
  final int postId;
  final ReviewStatus? reviewStatus;
  final PostType postType;
  final double? elevation;

  const EditPostButton({
    required this.postId,
    required this.reviewStatus,
    required this.postType,
    this.elevation,
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
        minimumSize: const Size(45, 45),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        fixedSize: const Size(45.0, 45.0),
        elevation: elevation,
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).dividerColor,
      ),
      child: const Icon(
        LucideIcons.pencil,
        size: 18.0,
      ),
    );
  }
}
