import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../models/post.dart';
import '../../providers/auth.dart';
import '../../providers/posts.dart';
import '../../widgets/sized_config.dart';
import '../../widgets/styled_elevated_button.dart';
import '../../widgets/styled_input.dart';
import './step_title.dart';

class EditPostContacts extends StatefulWidget {
  const EditPostContacts({
    Key? key,
  }) : super(key: key);

  @override
  _EditPostContactsState createState() => _EditPostContactsState();
}

class _EditPostContactsState extends State<EditPostContacts> {
  late Post? postData;

  final _formKey = GlobalKey<FormState>();

  String? _contact;

  @override
  void initState() {
    postData = Provider.of<Posts>(context, listen: false).postData;

    if ((postData?.lastStep ?? -1) >= 7) {
      _contact = postData?.contact;
    }

    super.initState();
  }

  void _continuePressed() {
    if (_formKey.currentState == null) {
      return;
    }

    _formKey.currentState!.save();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    Provider.of<Posts>(context, listen: false).updatePost(postData?.copyWith(
      contact: _contact,
      username:
          Provider.of<Auth>(context, listen: false).user?.displayName ?? '',
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(SizeConfig.safeBlockHorizontal * 15.0,
                8.0, SizeConfig.safeBlockHorizontal * 15.0, 32.0),
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StepTitle(
                      title: AppLocalizations.of(context)!.contactTitle,
                      icon: CustomIcons.phonering,
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    StyledInput(
                      icon: CustomIcons.phone,
                      title: AppLocalizations.of(context)!.phoneNumber,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!
                              .errorRequiredField;
                        }
                      },
                      onSaved: (value) {
                        _contact = value ?? '';
                      },
                    ),
                    const SizedBox(
                      height: 32.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withOpacity(0.1),
                  blurRadius: 8.0,
                  offset: const Offset(10.0, 10.0),
                )
              ],
            ),
            child: StyledElevatedButton(
              secondary: true,
              text: AppLocalizations.of(context)!.submitPost,
              onPressed: _continuePressed,
              width: SizeConfig.safeBlockHorizontal * 100.0,
              suffixIcon: CustomIcons.checked,
            ),
          ),
        ),
      ],
    );
  }
}
