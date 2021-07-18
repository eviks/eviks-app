import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/settlement.dart';
import './carousel.dart';
import './sized_config.dart';

class PostItem extends StatelessWidget {
  final int id;
  final int price;
  final int rooms;
  final int sqm;
  final Settlement city;
  final Settlement district;
  final List<String> images;

  PostItem({
    required this.id,
    required this.price,
    required this.rooms,
    required this.sqm,
    required this.city,
    required this.district,
    required this.images,
  });

  final currencyFormat =
      NumberFormat.currency(locale: 'az_AZ', symbol: '₼', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      margin: const EdgeInsets.only(
        top: 20.0,
      ),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.bottomRight,
            children: <Widget>[
              Carousel(images: images),
              Container(
                margin: const EdgeInsets.all(4.0),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    fixedSize:
                        Size.fromRadius(SizeConfig.safeBlockHorizontal * 5.0),
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
                      Text('$rooms комната'),
                      const SizedBox(
                        width: 8.0,
                      ),
                      const Icon(CustomIcons.stairs),
                      const SizedBox(
                        width: 8.0,
                      ),
                      const Text('1/5'),
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    Text(
                      '20.06.2021',
                      style: TextStyle(color: Theme.of(context).disabledColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
