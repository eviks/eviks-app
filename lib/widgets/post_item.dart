import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../constants.dart';
import '../models/post.dart';
import '../screens/post_detail_screen/post_detail_screen.dart';
import '../widgets/sized_config.dart';
import './carousel.dart';
import './favorite_button.dart';

class PostItem extends StatelessWidget {
  final Post post;

  const PostItem({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final headerHeight =
        MediaQuery.of(context).orientation == Orientation.portrait
            ? 30.0
            : 50.0;

    SizeConfig().init(context);
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(PostDetailScreen.routeName, arguments: post.id);
      },
      child: Container(
        margin: const EdgeInsets.only(
          top: 20.0,
        ),
        child: Column(
          children: <Widget>[
            Stack(
              alignment: Alignment.bottomRight,
              children: <Widget>[
                Carousel(
                  images: post.images,
                  height: SizeConfig.safeBlockVertical * headerHeight,
                ),
                Container(
                  margin: const EdgeInsets.all(4.0),
                  child: FavoriteButton(post.id),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        currencyFormat.format(post.price),
                        style: const TextStyle(
                            fontSize: 24.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        post.district?.name ?? '',
                        style: const TextStyle(fontSize: 24.0),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: <Widget>[
                        const Icon(
                          CustomIcons.sqm,
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        Text('${post.sqm} m²'),
                        const SizedBox(
                          width: 8,
                        ),
                        const Icon(CustomIcons.door),
                        const SizedBox(
                          width: 8.0,
                        ),
                        Text(
                            '${post.rooms} ${AppLocalizations.of(context)!.postRooms}'),
                        const SizedBox(
                          width: 8.0,
                        ),
                        Icon(post.estateType == EstateType.apartment
                            ? CustomIcons.stairs
                            : CustomIcons.garden),
                        const SizedBox(
                          width: 8.0,
                        ),
                        Text(post.estateType == EstateType.apartment
                            ? '${post.floor}/${post.totalFloors}'
                            : '${post.lotSqm} ${AppLocalizations.of(context)!.postLot}'),
                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        '20.06.2021',
                        style:
                            TextStyle(color: Theme.of(context).disabledColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
