import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/post.dart';

import '../../providers/posts.dart';
import '../../widgets/sized_config.dart';
import './edit_post_additional_info.dart';
import './edit_post_building_info.dart';
import './edit_post_contacts.dart';
import './edit_post_estate_info.dart';
import './edit_post_general_info.dart';
import './edit_post_images/edit_post_images.dart';
import './edit_post_map.dart';
import './edit_post_price.dart';

class EditPostScreen extends StatefulWidget {
  static const routeName = '/edit_post';

  const EditPostScreen({Key? key}) : super(key: key);

  @override
  _EditPostScreenState createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  Widget getStepWidget(Post? postData) {
    switch (postData?.step ?? 0) {
      case 0:
        return const EditPostGeneralInfo();
      case 1:
        return const EditPostMap();
      case 2:
        return const EditPostEstateInfo();
      case 3:
        return const EditPostBuildingInfo();
      case 4:
        return const EditPostAdditionalInfo();
      case 5:
        return const EditPostImages();
      case 6:
        return const EditPostPrice();
      case 7:
        return const EditPostContacts();
      default:
        return const EditPostGeneralInfo();
    }
  }

  @override
  void initState() {
    Provider.of<Posts>(context, listen: false).initNewPost();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final postData = Provider.of<Posts>(context, listen: true).postData;
    SizeConfig().init(context);
    return getStepWidget(postData);
  }
}
