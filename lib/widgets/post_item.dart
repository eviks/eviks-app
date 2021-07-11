import 'package:flutter/material.dart';

import './sized_config.dart';
import '../models/settlement.dart';
import './carousel.dart';

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

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      margin: EdgeInsets.only(
        top: 20.0,
      ),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.bottomRight,
            children: <Widget>[
              Carousel(images: images),
              Container(
                margin: EdgeInsets.all(4.0),
                child: ElevatedButton(
                  onPressed: () {},
                  child: Icon(Icons.favorite),
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    fixedSize:
                        Size.fromRadius(SizeConfig.safeBlockHorizontal * 5.0),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      price.toString(),
                      style: TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text(
                      district.name,
                      style: TextStyle(fontSize: 24.0),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.square_foot),
                      Text('$sqm m²'),
                      SizedBox(
                        width: 8,
                      ),
                      Icon(Icons.door_front_outlined),
                      Text('$rooms комната'),
                      SizedBox(
                        width: 8.0,
                      ),
                      Icon(Icons.elevator_outlined),
                      Text('1/5'),
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
