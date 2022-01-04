import 'package:eviks_mobile/models/settlement.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './edit_post_additional_info.dart';
import './edit_post_building_info.dart';
import './edit_post_contacts.dart';
import './edit_post_estate_info.dart';
import './edit_post_general_info.dart';
import './edit_post_images/edit_post_images.dart';
import './edit_post_map.dart';
import './edit_post_price.dart';
import '../../models/post.dart';
import '../../providers/localities.dart';
import '../../providers/posts.dart';

class EditPostScreen extends StatefulWidget {
  static const routeName = '/edit_post';

  const EditPostScreen({Key? key}) : super(key: key);

  @override
  _EditPostScreenState createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  var _isInit = true;

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
  Future<void> didChangeDependencies() async {
    if (_isInit) {
      Post? loadedPost;
      Settlement? city;
      Settlement? district;

      final arguments = ModalRoute.of(context)!.settings.arguments;
      if (arguments != null) {
        final postId = arguments as int;
        loadedPost =
            Provider.of<Posts>(context, listen: false).findById(postId);

        try {
          // Get city
          final cityResult =
              await Provider.of<Localities>(context, listen: false)
                  .getLocalities({'id': loadedPost.city.id});
          city = cityResult[0];

          // Get district
          final districtResult =
              await Provider.of<Localities>(context, listen: false)
                  .getLocalities({'id': loadedPost.district.id});
          district = districtResult[0];

          loadedPost = loadedPost.copyWith(city: city, district: district);
        } catch (e) {
          // No error handler
        }
      }

      Provider.of<Posts>(context, listen: false).initNewPost(loadedPost);

      setState(() {
        _isInit = false;
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (_isInit) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      final postData = Provider.of<Posts>(context, listen: true).postData;
      return getStepWidget(postData);
    }
  }
}
