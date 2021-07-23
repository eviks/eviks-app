import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../providers/posts.dart';
import '../../widgets/sized_config.dart';
import './post_detail_content.dart';
import './post_detail_header.dart';

class PostDetailScreen extends StatelessWidget {
  const PostDetailScreen({Key? key}) : super(key: key);

  static const routeName = '/post-detail';

  @override
  Widget build(BuildContext context) {
    final postId = ModalRoute.of(context)!.settings.arguments! as int;
    final loadedPost =
        Provider.of<Posts>(context, listen: false).findById(postId);
    final headerHeight =
        MediaQuery.of(context).orientation == Orientation.portrait
            ? 50.0
            : 70.0;
    SizeConfig().init(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
              delegate: PostDetailHeader(
                  images: loadedPost.images,
                  height: SizeConfig.safeBlockVertical * headerHeight)),
          SliverAppBar(
            title: Text(
              currencyFormat.format(loadedPost.price),
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
            ),
            pinned: true,
          ),
          PostDetailContent(
            loadedPost,
          ),
        ],
      ),
    );
  }
}
