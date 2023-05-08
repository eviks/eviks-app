import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../models/failure.dart';
import '../../providers/posts.dart';
import '../../widgets/styled_elevated_button.dart';
import '../../widgets/styled_input.dart';

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
  late TextEditingController _controller;
  bool _loading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _confirmPost() async {
    setState(() {
      _loading = true;
    });

    String errorMessage = '';

    try {
      await Provider.of<Posts>(context, listen: false)
          .confirmPost(widget.postId);
    } on Failure catch (error) {
      if (error.statusCode >= 500) {
        errorMessage = AppLocalizations.of(context)!.serverError;
      } else {
        errorMessage = AppLocalizations.of(context)!.networkError;
      }
    } catch (error) {
      errorMessage = AppLocalizations.of(context)!.unknownError;
      errorMessage = error.toString();
    }

    setState(() {
      _loading = false;
    });

    if (!mounted) return;

    if (errorMessage.isNotEmpty) {
      showSnackBar(context, errorMessage);
    } else {
      Navigator.of(context).pop();
    }
  }

  Future<bool?> _rejectPost() {
    return showDialog<bool>(
      context: _scaffoldKey.currentContext!,
      builder: (BuildContext ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                AppLocalizations.of(context)!.rejectionTitle,
              ),
              content: StyledInput(
                controller: _controller,
                autofocus: true,
                hintText: AppLocalizations.of(context)!.rejectionReason,
                keyboardType: TextInputType.multiline,
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    if (_controller.text.isEmpty) {
                      return;
                    }

                    setState(() {
                      _loading = true;
                    });

                    String errorMessage = '';

                    try {
                      await Provider.of<Posts>(context, listen: false)
                          .rejectPost(widget.postId, _controller.text);
                    } on Failure catch (error) {
                      if (error.statusCode >= 500) {
                        errorMessage =
                            AppLocalizations.of(context)!.serverError;
                      } else {
                        errorMessage =
                            AppLocalizations.of(context)!.networkError;
                      }
                    } catch (error) {
                      errorMessage = AppLocalizations.of(context)!.unknownError;
                      errorMessage = error.toString();
                    }

                    setState(() {
                      _loading = false;
                    });

                    if (!mounted) return;

                    if (errorMessage.isNotEmpty) {
                      showSnackBar(context, errorMessage);
                    } else {
                      Navigator.of(context).pop(true);
                    }
                  },
                  child: _loading
                      ? const SizedBox(
                          height: 24.0,
                          width: 24.0,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                          ),
                        )
                      : Text(
                          AppLocalizations.of(context)!.reject,
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      key: _scaffoldKey,
      children: [
        Expanded(
          child: StyledElevatedButton(
            text: AppLocalizations.of(context)!.confirm,
            color: Colors.green,
            loading: _loading,
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
            onPressed: () async {
              final result = await _rejectPost();
              if (result ?? false) {
                if (!mounted) return;
                Navigator.of(context).pop();
              }
            },
          ),
        )
      ],
    );
  }
}
