import 'package:eviks_mobile/models/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../models/failure.dart';
import '../../providers/posts.dart';

class DeletePostButton extends StatefulWidget {
  final int postId;
  final ReviewStatus? reviewStatus;
  final PostType postType;

  const DeletePostButton({
    required this.postId,
    required this.reviewStatus,
    required this.postType,
  });

  @override
  State<DeletePostButton> createState() => _DeletePostButtonState();
}

class _DeletePostButtonState extends State<DeletePostButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.reviewStatus == ReviewStatus.onreview
          ? null
          : () => showDialog(
                context: context,
                builder: (BuildContext ctx) => AlertDialog(
                  title: Text(
                    AppLocalizations.of(context)!.deletePostTitle,
                  ),
                  content: Text(
                    AppLocalizations.of(context)!.deletePostContent,
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        AppLocalizations.of(context)!.deletePostCancel,
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        String errorMessage = '';
                        ScaffoldMessenger.of(context).removeCurrentSnackBar();
                        try {
                          await Provider.of<Posts>(context, listen: false)
                              .deletePost(
                            postId: widget.postId,
                            postType: widget.postType,
                          );
                        } on Failure catch (error) {
                          if (error.statusCode >= 500) {
                            if (!context.mounted) return;
                            errorMessage =
                                AppLocalizations.of(context)!.serverError;
                          } else {
                            errorMessage = error.toString();
                          }
                        } catch (error) {
                          if (!context.mounted) return;
                          errorMessage =
                              AppLocalizations.of(context)!.unknownError;
                        }

                        if (!context.mounted) return;

                        if (errorMessage.isNotEmpty) {
                          showSnackBar(context, errorMessage);
                        }

                        Navigator.pop(context);
                      },
                      child: Text(
                        AppLocalizations.of(context)!.deletePost,
                        style: TextStyle(
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: const Size(45, 45),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        fixedSize: const Size(45.0, 45.0),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).dividerColor,
      ),
      child: const Icon(
        LucideIcons.trash,
        size: 18.0,
      ),
    );
  }
}
