import 'package:flutter/material.dart';

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
        ? double.parse(_mediaQueryData.size.width.toString())
        : double.parse(_mediaQueryData.size.height.toString());
    screenHeight = _mediaQueryData.orientation == Orientation.portrait
        ? double.parse(_mediaQueryData.size.height.toString())
        : double.parse(_mediaQueryData.size.width.toString());
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
    _safeAreaHorizontal =
        double.parse(_mediaQueryData.padding.left.toString()) +
            double.parse(_mediaQueryData.padding.right.toString());
    _safeAreaVertical = double.parse(_mediaQueryData.padding.top.toString()) +
        double.parse(_mediaQueryData.padding.bottom.toString());
    safeBlockHorizontal = (screenWidth - _safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight - _safeAreaVertical) / 100;
  }
}
