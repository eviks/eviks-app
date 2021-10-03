import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/post.dart';
import '../../widgets/sized_config.dart';
import '../../widgets/styled_input.dart';
import './step_title.dart';

class EditPostEstateInfo extends StatefulWidget {
  final Post post;
  final Function(Post) updatePost;

  const EditPostEstateInfo({
    required this.post,
    required this.updatePost,
    Key? key,
  }) : super(key: key);

  @override
  _EditPostEstateInfoState createState() => _EditPostEstateInfoState();
}

class _EditPostEstateInfoState extends State<EditPostEstateInfo> {
  final _formKey = GlobalKey<FormState>();

  int? _sqm;

  void _continuePressed() {
    if (_formKey.currentState == null) {
      return;
    }

    _formKey.currentState!.save();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    widget.updatePost(widget.post.copyWith(
      sqm: _sqm,
      step: 3,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 32.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StepTitle(
                  title: AppLocalizations.of(context)!.generalInfo,
                  icon: CustomIcons.information,
                ),
                StyledInput(
                  icon: CustomIcons.marker,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.errorAddress;
                    }
                  },
                  onSaved: (value) {
                    _sqm = int.parse(value ?? '');
                  },
                ),
                const SizedBox(
                  height: 16.0,
                ),
                Container(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                  ),
                  width: SizeConfig.safeBlockHorizontal * 50,
                  height: 60.0,
                  child: ElevatedButton(
                    onPressed: _continuePressed,
                    child: Text(
                      AppLocalizations.of(context)!.next,
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
