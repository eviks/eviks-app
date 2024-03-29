import 'package:eviks_mobile/models/post.dart';
import 'package:flutter/material.dart';

class PostReviewStatus extends StatelessWidget {
  final ReviewStatus reviewStatus;

  const PostReviewStatus({Key? key, required this.reviewStatus})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        reviewStatusTitle(reviewStatus, context),
        style: TextStyle(
          fontSize: 22.0,
          color: reviewStatus == ReviewStatus.rejected
              ? Theme.of(context).colorScheme.error
              : null,
        ),
      ),
    );
  }
}
