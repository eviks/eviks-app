import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants.dart';
import '../../models/failure.dart';
import '../../providers/posts.dart';
import '../../widgets/styled_elevated_button.dart';

class PostDetailButtons extends StatefulWidget {
  const PostDetailButtons({Key? key}) : super(key: key);

  @override
  State<PostDetailButtons> createState() => _PostDetailButtonsState();
}

class _PostDetailButtonsState extends State<PostDetailButtons> {
  Future<void> _callPhoneNumber() async {
    final postId = ModalRoute.of(context)!.settings.arguments! as int;
    String phoneNumber = '';
    String errorMessage = '';
    try {
      phoneNumber = await Provider.of<Posts>(context, listen: false)
          .fetchPostPhoneNumber(postId);
    } on Failure catch (error) {
      if (error.statusCode >= 500) {
        errorMessage = AppLocalizations.of(context)!.serverError;
      } else {
        errorMessage = error.toString();
      }
    } catch (error) {
      errorMessage = AppLocalizations.of(context)!.unknownError;
    }

    if (errorMessage.isNotEmpty) {
      if (!mounted) return;
      showSnackBar(context, errorMessage);
      return;
    }

    if (await Permission.phone.request().isGranted) {
      final uri = Uri.parse('tel://$phoneNumber');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return StyledElevatedButton(
      text: AppLocalizations.of(context)!.call,
      onPressed: _callPhoneNumber,
    );
  }
}
