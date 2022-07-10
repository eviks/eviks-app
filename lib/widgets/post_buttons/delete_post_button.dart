import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../models/failure.dart';
import '../../providers/posts.dart';

class DeletePostButton extends StatefulWidget {
  final int postId;

  const DeletePostButton(
    this.postId,
  );

  @override
  State<DeletePostButton> createState() => _DeletePostButtonState();
}

class _DeletePostButtonState extends State<DeletePostButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => showDialog(
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
                String _errorMessage = '';
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                try {
                  await Provider.of<Posts>(context, listen: false)
                      .deletePost(widget.postId);
                } on Failure catch (error) {
                  if (error.statusCode >= 500) {
                    _errorMessage = AppLocalizations.of(context)!.serverError;
                  } else {
                    _errorMessage = error.toString();
                  }
                } catch (error) {
                  _errorMessage = AppLocalizations.of(context)!.unknownError;
                }

                if (!mounted) return;

                if (_errorMessage.isNotEmpty) {
                  showSnackBar(context, _errorMessage);
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
        padding: const EdgeInsets.all(4.0),
        minimumSize: const Size(50, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        fixedSize: const Size(50.0, 50.0),
        primary: Theme.of(context).backgroundColor,
        onPrimary: Theme.of(context).dividerColor,
      ),
      child: const Icon(CustomIcons.garbage),
    );
  }
}
