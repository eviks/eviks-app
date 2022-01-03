import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth.dart';
import '../../widgets/carousel.dart';
import '../../widgets/post_buttons/delete_post_button.dart';
import '../../widgets/post_buttons/edit_post_button.dart';
import '../../widgets/post_buttons/favorite_button.dart';

class PostDetailHeader extends SliverPersistentHeaderDelegate {
  final String user;
  final int postId;
  final List<String> images;
  final double height;
  final bool buttonsVisibility;

  PostDetailHeader({
    required this.user,
    required this.postId,
    required this.images,
    required this.height,
    required this.buttonsVisibility,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Carousel(
          images: images,
          height: height,
          imageSize: '640',
        ),
        Consumer<Auth>(
          builder: (context, auth, child) => Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Visibility(
              visible: buttonsVisibility,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: Navigator.canPop(context)
                        ? () {
                            Navigator.pop(context);
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      fixedSize: const Size.fromRadius(25.0),
                      primary: Theme.of(context).backgroundColor,
                      onPrimary: Theme.of(context).dividerColor,
                    ),
                    child: const Icon(CustomIcons.back),
                  ),
                  if ((auth.user?.id ?? '') == user)
                    Container(
                      margin: const EdgeInsets.all(4.0),
                      child: Row(
                        children: [
                          EditPostButton(postId),
                          DeletePostButton(postId),
                        ],
                      ),
                    )
                  else
                    Container(
                      margin: const EdgeInsets.all(4.0),
                      child: FavoriteButton(
                        postId: postId,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => 0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
