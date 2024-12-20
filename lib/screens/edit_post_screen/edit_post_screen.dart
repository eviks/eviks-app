import 'package:eviks_mobile/models/settlement.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/post.dart';
import '../../providers/localities.dart';
import '../../providers/posts.dart';
import './edit_post_general_info.dart';

class EditPostScreen extends StatefulWidget {
  static const routeName = '/edit_post';

  const EditPostScreen({Key? key}) : super(key: key);

  @override
  _EditPostScreenState createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  var _isInit = true;

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
          if (!mounted) return;
          final districtResult =
              await Provider.of<Localities>(context, listen: false)
                  .getLocalities({'id': loadedPost.district.id});
          district = districtResult[0];

          loadedPost = loadedPost.copyWith(city: city, district: district);
        } catch (e) {
          // No error handler
        }
      }

      if (!mounted) return;
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
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return const EditPostGeneralInfo();
    }
  }
}
