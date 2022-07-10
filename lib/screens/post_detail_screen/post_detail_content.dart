import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import './post_detail_additional.dart';
import './post_detail_building.dart';
import './post_detail_general.dart';
import './post_detail_main_info.dart';
import './post_detail_map.dart';
import './post_detail_user.dart';
import '../../models/post.dart';

class PostDetailContent extends StatelessWidget {
  final Post post;

  const PostDetailContent(this.post);

  bool _postHasAdditionalItems() {
    return (post.kidsAllowed ?? false) ||
        (post.petsAllowed ?? false) ||
        (post.garage ?? false) ||
        (post.pool ?? false) ||
        (post.bathhouse ?? false) ||
        (post.balcony ?? false) ||
        (post.furniture ?? false) ||
        (post.kitchenFurniture ?? false) ||
        (post.cableTv ?? false) ||
        (post.phone ?? false) ||
        (post.internet ?? false) ||
        (post.electricity ?? false) ||
        (post.gas ?? false) ||
        (post.water ?? false) ||
        (post.heating ?? false) ||
        (post.tv ?? false) ||
        (post.conditioner ?? false) ||
        (post.washingMachine ?? false) ||
        (post.dishwasher ?? false) ||
        (post.refrigerator ?? false);
  }

  bool _postHasBuildingInfo() {
    return (post.yearBuild != null && post.yearBuild != 0) ||
        (post.ceilingHeight != null && post.ceilingHeight != 0) ||
        (post.elevator ?? false) ||
        (post.parkingLot ?? false);
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 15.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 375),
              childAnimationBuilder: (widget) => SlideAnimation(
                horizontalOffset: 50.0,
                child: FadeInAnimation(
                  child: widget,
                ),
              ),
              children: [
                PostDetailMainInfo(
                  post: post,
                ),
                PostDetailUser(
                  post: post,
                ),
                if (post.description?.isNotEmpty ?? false)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ContentTitle(
                        AppLocalizations.of(context)!.postDetailDescription,
                      ),
                      Text(
                        post.description ?? '',
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                _ContentTitle(
                  AppLocalizations.of(context)!.postDetailGeneral,
                ),
                PostDetailGeneral(
                  post: post,
                ),
                if (_postHasAdditionalItems())
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ContentTitle(
                        AppLocalizations.of(context)!.postDetailAdditional,
                      ),
                      PostDetailAdditional(
                        post: post,
                      ),
                    ],
                  ),
                if (_postHasBuildingInfo())
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ContentTitle(
                        AppLocalizations.of(context)!.postDetailBuilding,
                      ),
                      PostDetailBuilding(
                        post: post,
                      ),
                    ],
                  ),
                _ContentTitle(
                  AppLocalizations.of(context)!.postDetailLocation,
                ),
                SizedBox(
                  height: 300.0,
                  child: PostDetailMap(
                    post,
                  ),
                ),
                const SizedBox(
                  height: 80,
                )
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

class _ContentTitle extends StatelessWidget {
  final String title;

  const _ContentTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15.0),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
