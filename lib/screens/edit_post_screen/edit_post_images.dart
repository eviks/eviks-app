import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/post.dart';
import '../../widgets/sized_config.dart';
import '../../widgets/styled_elevated_button.dart';
import './step_title.dart';

class EditPostImages extends StatefulWidget {
  final Post post;
  final Function(Post) updatePost;

  const EditPostImages({
    required this.post,
    required this.updatePost,
    Key? key,
  }) : super(key: key);

  @override
  _EditPostImagesState createState() => _EditPostImagesState();
}

class _EditPostImagesState extends State<EditPostImages> {
  final _formKey = GlobalKey<FormState>();

  void _continuePressed() {
    if (_formKey.currentState == null) {
      return;
    }

    _formKey.currentState!.save();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    widget.updatePost(widget.post.copyWith(
      step: 6,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.safeBlockHorizontal * 15.0, vertical: 32.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StepTitle(
                  title: AppLocalizations.of(context)!.buildingInfo,
                  icon: CustomIcons.apartment,
                ),
                const SizedBox(
                  height: 16.0,
                ),
                const SizedBox(
                  height: 16.0,
                ),
                StyledElevatedButton(
                  text: AppLocalizations.of(context)!.next,
                  onPressed: _continuePressed,
                  width: double.infinity,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
