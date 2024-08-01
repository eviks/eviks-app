import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import './step_title.dart';
import '../../constants.dart';
import '../../models/failure.dart';
import '../../models/post.dart';
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
  bool _isInit = true;

  final _formKey = GlobalKey<FormState>();
  var _isLoading = false;

  String? _phoneNumber;
  String? _username;

  @override
  void didChangeDependencies() {
    postData = Provider.of<Posts>(context).postData;
    if (_isInit) {
      if ((postData?.lastStep ?? -1) >= 9) {
        _phoneNumber = postData?.phoneNumber;
        _username = postData?.username;
      }

      _isInit = false;
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
        phoneNumber: _phoneNumber,
        username: _username,
        lastStep: 9,
        step: !_confirmPost ? 8 : 9,
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

    String errorMessage = '';
    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    try {
      if ((postData?.id ?? 0) == 0 ||
          postData?.postType != PostType.confirmed) {
        await Provider.of<Posts>(context, listen: false).createPost(
          postData!.copyWith(
            phoneNumber: _phoneNumber,
            username: _username,
            lastStep: 7,
          ),
        );
      } else {
        await Provider.of<Posts>(context, listen: false).updatePost(
          postData!.copyWith(
            phoneNumber: _phoneNumber,
            username: _username,
            lastStep: 7,
          ),
        );
      }
    } on Failure catch (error) {
      if (error.statusCode >= 500) {
        errorMessage = AppLocalizations.of(context)!.serverError;
      } else {
        errorMessage = error.toString();
      }
    } catch (error) {
      errorMessage = AppLocalizations.of(context)!.unknownError;
    }

    setState(() {
      _isLoading = false;
    });

    if (!mounted) return;

    if (errorMessage.isNotEmpty) {
      showSnackBar(context, errorMessage);
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
    final bool showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;
    SizeConfig().init(context);
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
            padding: EdgeInsets.fromLTRB(
              SizeConfig.safeBlockHorizontal * 15.0,
              8.0,
              SizeConfig.safeBlockHorizontal * 15.0,
              32.0,
            ),
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
                      icon: CustomIcons.user,
                      title: AppLocalizations.of(context)!.username,
                      initialValue: _username,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!
                              .errorRequiredField;
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _username = value ?? '';
                      },
                    ),
                    StyledInput(
                      icon: CustomIcons.phonecall,
                      title: AppLocalizations.of(context)!.phoneNumber,
                      initialValue: _phoneNumber,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!
                              .errorRequiredField;
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _phoneNumber = value ?? '';
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Visibility(
        visible: showFab,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: StyledElevatedButton(
            text: AppLocalizations.of(context)!.submitPost,
            onPressed: _onPostConfirm,
            loading: _isLoading,
            width: SizeConfig.safeBlockHorizontal * 100.0,
            suffixIcon: CustomIcons.checked,
          ),
        ),
      ),
    );
  }
}
