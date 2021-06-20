import 'package:flutter/material.dart';

class PostItem extends StatelessWidget {
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
              Image.network(
                'https://ichef.bbci.co.uk/news/976/cpsprodpb/492B/production/_107913781_house1_getty.jpg',
                height: SizeConfig.safeBlockHorizontal * 50.0,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Container(
                margin: EdgeInsets.all(4.0),
                child: ElevatedButton(
                  onPressed: () {},
                  child: Icon(Icons.favorite),
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    fixedSize:
                        Size.fromRadius(SizeConfig.safeBlockHorizontal * 6.0),
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
                      '65,000 ₼',
                      style: TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text(
                      'Nəsimi',
                      style: TextStyle(fontSize: 24.0),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.square_foot),
                      Text('1 m²'),
                      SizedBox(
                        width: 8,
                      ),
                      Icon(Icons.door_front_outlined),
                      Text('1 комната'),
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

class SizeConfig {
  static dynamic _mediaQueryData;
  static double screenWidth = 0;
  static double screenHeight = 0;
  static double blockSizeHorizontal = 0;
  static double blockSizeVertical = 0;
  static double _safeAreaHorizontal = 0;
  static double _safeAreaVertical = 0;
  static double safeBlockHorizontal = 0;
  static double safeBlockVertical = 0;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.orientation == Orientation.portrait
        ? _mediaQueryData.size.width
        : _mediaQueryData.size.height;
    screenHeight = _mediaQueryData.orientation == Orientation.portrait
        ? _mediaQueryData.size.height
        : _mediaQueryData.size.width;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
    _safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (screenWidth - _safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight - _safeAreaVertical) / 100;
  }
}
