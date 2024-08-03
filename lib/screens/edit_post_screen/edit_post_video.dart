import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../models/post.dart';
import '../../providers/posts.dart';
import '../../widgets/sized_config.dart';
import '../../widgets/styled_elevated_button.dart';
import '../../widgets/styled_input.dart';
import './edit_post_images/edit_post_images.dart';
import './step_title.dart';

class EditPostVideo extends StatefulWidget {
  const EditPostVideo({
    Key? key,
  }) : super(key: key);

  @override
  _EditPostVideoState createState() => _EditPostVideoState();
}

class _EditPostVideoState extends State<EditPostVideo> {
  late Post? postData;
  bool _goToNextStep = false;
  bool _isInit = true;

  RegExp validateYoutubeUrl =
      RegExp(r'^(https?\:\/\/)?((www\.)?youtube\.com|youtu\.be)\/.+$');

  final _formKey = GlobalKey<FormState>();

  String? _videoLink;

  @override
  void didChangeDependencies() {
    postData = Provider.of<Posts>(context).postData;
    if (_isInit) {
      if ((postData?.lastStep ?? -1) >= 6) {
        _videoLink = postData?.videoLink;
      }

      _isInit = false;
    }

    super.didChangeDependencies();
  }

  void _continuePressed() {
    if (_formKey.currentState == null) {
      return;
    }

    _formKey.currentState!.save();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    _goToNextStep = true;
    _updatePost();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EditPostImages()),
    );
  }

  void _updatePost() {
    Provider.of<Posts>(context, listen: false).setPostData(
      postData?.copyWith(
        videoLink: _videoLink,
        lastStep: 6,
        step: _goToNextStep ? 7 : 5,
      ),
    );
  }

  void _prevStep() {
    _formKey.currentState!.save();
    _updatePost();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: StepTitle(
          title: AppLocalizations.of(context)!.videoLinkTitle,
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
              SizeConfig.safeBlockHorizontal * 7.0,
              8.0,
              SizeConfig.safeBlockHorizontal * 7.0,
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
                        "assets/img/illustrations/video.png",
                      ),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      AppLocalizations.of(context)!.addPostVideo,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    Text(
                      AppLocalizations.of(context)!.addPostVideoHint,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                    const SizedBox(
                      height: 32.0,
                    ),
                    StyledInput(
                      icon: CustomIcons.play,
                      title: AppLocalizations.of(context)!.youtubeLink,
                      initialValue: _videoLink,
                      hintText: "https://youtu.be/",
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          if (!validateYoutubeUrl.hasMatch(value)) {
                            return AppLocalizations.of(context)!
                                .invalidYoutubeLink;
                          }
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _videoLink = value;
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
        secondary: true,
        text: AppLocalizations.of(context)!.next,
        onPressed: _continuePressed,
        width: SizeConfig.safeBlockHorizontal * 100.0,
        suffixIcon: CustomIcons.next,
      ),
    );
  }
}
