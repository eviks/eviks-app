import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../widgets/styled_elevated_button.dart';

class PostDetailModerationButtons extends StatelessWidget {
  final int postId;

  const PostDetailModerationButtons({required this.postId, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: StyledElevatedButton(
            text: AppLocalizations.of(context)!.confirm,
            color: Colors.green,
            onPressed: () {},
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
