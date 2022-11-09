import 'package:eviks_mobile/models/post.dart';
import 'package:eviks_mobile/models/review_history.dart';
import 'package:flutter/material.dart';

class PostDetailReviewStatus extends StatelessWidget {
  final ReviewStatus reviewStatus;
  final List<ReviewHistory> reviewHistory;

  const PostDetailReviewStatus({
    required this.reviewStatus,
    required this.reviewHistory,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(top: 8.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).dividerColor,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          Text(
            reviewStatusTitle(reviewStatus, context),
            style: TextStyle(
              fontSize: 22,
              color: reviewStatus == ReviewStatus.rejected
                  ? Theme.of(context).errorColor
                  : null,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            reviewStatusHint(reviewStatus, context),
            textAlign: TextAlign.center,
          ),
          if (reviewStatus == ReviewStatus.rejected && reviewHistory.isNotEmpty)
            Column(
              children: [
                const SizedBox(height: 8.0),
                Text(
                  reviewHistory[0].comment,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                Text(
                  reviewStatusHintEnding(reviewStatus, context),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
        ],
      ),
    );
  }
}
