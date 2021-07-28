import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../constants.dart';
import '../models/settlement.dart';
import '../providers/post.dart';
import '../screens/post_detail_screen/post_detail_screen.dart';
import '../widgets/sized_config.dart';
import './carousel.dart';

class PostItem extends StatelessWidget {
  final int id;
  final EstateType estateType;
  final int price;
  final int rooms;
  final int sqm;
  final Settlement city;
  final Settlement district;
  final List<String> images;
  final int floor;
  final int totalFloors;
  final int lotSqm;

  const PostItem({
    Key? key,
    required this.id,
    required this.estateType,
    required this.price,
    required this.rooms,
    required this.sqm,
    required this.city,
    required this.district,
    required this.images,
    this.floor = 0,
    this.totalFloors = 0,
    this.lotSqm = 0,
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
            .pushNamed(PostDetailScreen.routeName, arguments: id);
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
                  images: images,
                  height: SizeConfig.safeBlockVertical * headerHeight,
                ),
                Container(
                  margin: const EdgeInsets.all(4.0),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      fixedSize: const Size.fromRadius(25.0),
                    ),
                    child: const Icon(CustomIcons.heart),
                  ),
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
                        currencyFormat.format(price),
                        style: const TextStyle(
                            fontSize: 24.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        district.name,
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
                        Text('$sqm m²'),
                        const SizedBox(
                          width: 8,
                        ),
                        const Icon(CustomIcons.door),
                        const SizedBox(
                          width: 8.0,
                        ),
                        Text(
                            '$rooms ${AppLocalizations.of(context)!.postRooms}'),
                        const SizedBox(
                          width: 8.0,
                        ),
                        Icon(estateType == EstateType.apartment
                            ? CustomIcons.stairs
                            : CustomIcons.garden),
                        const SizedBox(
                          width: 8.0,
                        ),
                        Text(estateType == EstateType.apartment
                            ? '$floor/$totalFloors'
                            : '$lotSqm ${AppLocalizations.of(context)!.postLot}'),
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
