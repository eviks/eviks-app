import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../models/failure.dart';
import '../../providers/posts.dart';
import '../../widgets/styled_elevated_button.dart';

class PostDetailModerationButtons extends StatefulWidget {
  final int postId;

  const PostDetailModerationButtons({required this.postId, Key? key})
      : super(key: key);

  @override
  State<PostDetailModerationButtons> createState() =>
      _PostDetailModerationButtonsState();
}

class _PostDetailModerationButtonsState
    extends State<PostDetailModerationButtons> {
  Future<void> _confirmPost() async {
    String _errorMessage = '';

    try {
      await Provider.of<Posts>(context, listen: false)
          .confirmPost(widget.postId);
    } on Failure catch (error) {
      if (error.statusCode >= 500) {
        _errorMessage = AppLocalizations.of(context)!.serverError;
      } else {
        _errorMessage = AppLocalizations.of(context)!.networkError;
      }
    } catch (error) {
      _errorMessage = AppLocalizations.of(context)!.unknownError;
      _errorMessage = error.toString();
    }

    if (!mounted) return;

    if (_errorMessage.isNotEmpty) {
      showSnackBar(context, _errorMessage);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: StyledElevatedButton(
            text: AppLocalizations.of(context)!.confirm,
            color: Colors.green,
            onPressed: _confirmPost,
          ),
        ),
        const SizedBox(
          width: 10.0,
        ),
        Expanded(
          child: StyledElevatedButton(
            text: AppLocalizations.of(context)!.reject,
            color: Colors.red,
            onPressed: () {},
          ),
        )
      ],
    );
  }
}
