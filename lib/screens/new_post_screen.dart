import 'package:eviks_mobile/icons.dart';
import 'package:eviks_mobile/screens/edit_post_screen/edit_post_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/sized_config.dart';
import '../widgets/styled_elevated_button.dart';

class NewPostScreen extends StatelessWidget {
  const NewPostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Navigator.canPop(context)
            ? IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(CustomIcons.back),
              )
            : null,
        title: Text(
          AppLocalizations.of(context)!.newPost,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                SizedBox(
                  height: SizeConfig.safeBlockVertical * 40.0,
                  child: Image.asset(
                    "assets/img/illustrations/deal.png",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.newPostTitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                          top: 8.0,
                        ),
                        height: 60.0,
                        child: StyledElevatedButton(
                          onPressed: () => Navigator.of(context)
                              .pushNamed(EditPostScreen.routeName),
                          text: AppLocalizations.of(context)!.createPost,
                        ),
                      ),
                    ],
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
