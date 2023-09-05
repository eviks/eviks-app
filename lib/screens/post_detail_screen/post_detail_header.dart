import 'package:eviks_mobile/icons.dart';
import 'package:eviks_mobile/models/post.dart';
import 'package:eviks_mobile/models/user.dart';
import 'package:eviks_mobile/providers/posts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth.dart';
import '../../widgets/carousel.dart';
import '../../widgets/post_buttons/delete_post_button.dart';
import '../../widgets/post_buttons/edit_post_button.dart';
import '../../widgets/post_buttons/favorite_button.dart';
import '../../widgets/post_buttons/share_button.dart';

class PostDetailHeader extends SliverPersistentHeaderDelegate {
  final String user;
  final int postId;
  final List<String> images;
  final double height;
  final bool buttonsVisibility;
  final ReviewStatus? reviewStatus;
  final PostType postType;
  final bool isExternal;
  final String districtName;
  final int price;
  final int rooms;

  PostDetailHeader({
    required this.user,
    required this.postId,
    required this.images,
    required this.height,
    required this.buttonsVisibility,
    required this.reviewStatus,
    required this.postType,
    required this.isExternal,
    required this.districtName,
    required this.price,
    required this.rooms,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Carousel(
          images: images,
          height: height,
          temp: postType == PostType.unreviewed,
          external: isExternal,
          displayIndicator: buttonsVisibility,
          fullScreenView: true,
        ),
        Consumer<Auth>(
          builder: (context, auth, child) => Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: AnimatedOpacity(
              opacity: buttonsVisibility ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: Visibility(
                visible: buttonsVisibility,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: Navigator.canPop(context)
                            ? () {
                                final userRole =
                                    Provider.of<Auth>(context, listen: false)
                                        .userRole;

                                if (userRole == UserRole.moderator) {
                                  final postId = ModalRoute.of(context)!
                                      .settings
                                      .arguments! as int;

                                  Provider.of<Posts>(context, listen: false)
                                      .unblockPostFromModeration(postId);
                                }

                                Navigator.pop(context);
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(45, 45),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          fixedSize: const Size(45.0, 45.0),
                          backgroundColor:
                              Theme.of(context).colorScheme.background,
                          foregroundColor: Theme.of(context).dividerColor,
                        ),
                        child: const Icon(
                          CustomIcons.back,
                          size: 18.0,
                        ),
                      ),
                    ),
                    if ((auth.user?.id ?? '') == user)
                      Container(
                        margin: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            ShareButton(
                              postId: postId,
                              districtName: districtName,
                              price: price,
                              rooms: rooms,
                            ),
                            const SizedBox(width: 4.0),
                            EditPostButton(
                              postId: postId,
                              reviewStatus: reviewStatus,
                              postType: postType,
                            ),
                            const SizedBox(width: 4.0),
                            DeletePostButton(
                              postId: postId,
                              reviewStatus: reviewStatus,
                              postType: postType,
                            ),
                          ],
                        ),
                      )
                    else
                      Container(
                        margin: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            FavoriteButton(
                              postId: postId,
                            ),
                            const SizedBox(width: 4.0),
                            ShareButton(
                              postId: postId,
                              districtName: districtName,
                              price: price,
                              rooms: rooms,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
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
