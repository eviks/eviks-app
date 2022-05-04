import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import './step_title.dart';
import '../../constants.dart';
import '../../models/failure.dart';
import '../../models/post.dart';
import '../../providers/auth.dart';
import '../../providers/posts.dart';
import '../../widgets/sized_config.dart';
import '../../widgets/styled_elevated_button.dart';
import '../../widgets/styled_input.dart';
import '../tabs_screen.dart';

class EditPostContacts extends StatefulWidget {
  const EditPostContacts({
    Key? key,
  }) : super(key: key);

  @override
  _EditPostContactsState createState() => _EditPostContactsState();
}

class _EditPostContactsState extends State<EditPostContacts> {
  late Post? postData;
  bool _confirmPost = false;

  final _formKey = GlobalKey<FormState>();
  var _isLoading = false;

  String? _contact;

  @override
  void didChangeDependencies() {
    postData = Provider.of<Posts>(context, listen: true).postData;

    if ((postData?.lastStep ?? -1) >= 7) {
      _contact = postData?.contact;
    }

    super.didChangeDependencies();
  }

  void _onPostConfirm() {
    if (_formKey.currentState == null) {
      return;
    }

    _formKey.currentState!.save();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    _confirmPost = true;
    _updatePost();
    _createPost();
  }

  void _updatePost() {
    Provider.of<Posts>(context, listen: false).setPostData(
      postData?.copyWith(
        contact: _contact,
        username:
            Provider.of<Auth>(context, listen: false).user?.displayName ?? '',
        lastStep: 7,
        step: !_confirmPost ? 6 : 7,
      ),
    );
  }

  Future<void> _createPost() async {
    if (postData == null) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    String _errorMessage = '';
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    try {
      if ((postData?.id ?? 0) == 0) {
        await Provider.of<Posts>(context, listen: false).createPost(
          postData!.copyWith(
            contact: _contact,
            username:
                Provider.of<Auth>(context, listen: false).user?.displayName ??
                    '',
            lastStep: 7,
          ),
        );
      } else {
        await Provider.of<Posts>(context, listen: false).updatePost(
          postData!.copyWith(
            contact: _contact,
            username:
                Provider.of<Auth>(context, listen: false).user?.displayName ??
                    '',
            lastStep: 7,
          ),
        );
      }
    } on Failure catch (error) {
      if (error.statusCode >= 500) {
        _errorMessage = AppLocalizations.of(context)!.serverError;
      } else {
        _errorMessage = error.toString();
      }
    } catch (error) {
      _errorMessage = AppLocalizations.of(context)!.unknownError;
    }

    setState(() {
      _isLoading = false;
    });

    if (_errorMessage.isNotEmpty) {
      showSnackBar(context, _errorMessage);
      return;
    }

    Navigator.of(context)
        .pushNamedAndRemoveUntil(TabsScreen.routeName, (route) => false);
  }

  void _prevStep() {
    _formKey.currentState!.save();
    _updatePost();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StepTitle(
          title: AppLocalizations.of(context)!.contactTitle,
        ),
        leading: IconButton(
          onPressed: () {
            _prevStep();
          },
          icon: const Icon(CustomIcons.back),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(SizeConfig.safeBlockHorizontal * 15.0,
                8.0, SizeConfig.safeBlockHorizontal * 15.0, 32.0),
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: SizeConfig.safeBlockVertical * 30.0,
                      child: Image.asset(
                        "assets/img/illustrations/post_confirm.png",
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.postAlmostCreated,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      AppLocalizations.of(context)!.postAlmostCreatedHint,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    StyledInput(
                      icon: CustomIcons.phone,
                      title: AppLocalizations.of(context)!.phoneNumber,
                      initialValue: _contact,
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
      ),
      bottomNavigationBar: StyledElevatedButton(
        text: AppLocalizations.of(context)!.submitPost,
        onPressed: _onPostConfirm,
        loading: _isLoading,
        width: SizeConfig.safeBlockHorizontal * 100.0,
        suffixIcon: CustomIcons.checked,
      ),
    );
  }
}
