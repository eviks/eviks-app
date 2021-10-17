import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/post.dart';

import '../../widgets/sized_config.dart';
import './edit_post_estate_info.dart';
import './edit_post_general_info.dart';
import './edit_post_map.dart';

class EditPostScreen extends StatefulWidget {
  static const routeName = '/edit_post';

  const EditPostScreen({Key? key}) : super(key: key);

  @override
  _EditPostScreenState createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  Post post = Post(
    id: 0,
    userType: UserType.owner,
    estateType: EstateType.house,
    dealType: DealType.sale,
    price: 0,
    rooms: 0,
    sqm: 0,
    city: null,
    district: null,
    address: '',
    images: [],
    description: '',
    location: [],
  );

  void updatePost(Post value) {
    setState(() {
      post = value;
    });
  }

  Widget getStepWidget() {
    switch (post.step) {
      case 0:
        return EditPostGeneralInfo(
          post: post,
          updatePost: updatePost,
        );

      case 1:
        return EditPostMap(
          post: post,
          updatePost: updatePost,
        );
      case 2:
        return EditPostEstateInfo(
          post: post,
          updatePost: updatePost,
        );
      default:
        return EditPostGeneralInfo(
          post: post,
          updatePost: updatePost,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      resizeToAvoidBottomInset: post.step != 1,
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              AppLocalizations.of(context)!.editPostScreenTitle,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: getStepWidget(),
      ),
    );
  }
}
