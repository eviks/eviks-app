import 'package:flutter/material.dart';

import './constants.dart';

ThemeData lightThemeData(BuildContext context) {
  return ThemeData.light().copyWith(
    primaryColor: primaryColor,
    disabledColor: greyColor,
    scaffoldBackgroundColor: lightColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: lightColor,
      centerTitle: false,
      elevation: 1,
    ),
    iconTheme: const IconThemeData(color: darkColor),
    textTheme: ThemeData.light().textTheme.apply(
          fontFamily: 'Roboto',
          bodyColor: darkColor,
        ),
    primaryIconTheme: const IconThemeData(
      color: primaryColor,
    ),
    primaryTextTheme: ThemeData.light().textTheme.apply(
          fontFamily: 'Roboto',
          bodyColor: primaryColor,
        ),
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      error: dangerColor,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: lightColor,
      selectedItemColor: darkGreyColor,
      selectedIconTheme: IconThemeData(color: primaryColor),
      unselectedItemColor: greyColor,
    ),
  );
}

ThemeData darkThemeData(BuildContext context) {
  return ThemeData.dark().copyWith(
    primaryColor: lightPrimaryColor,
    disabledColor: greyColor,
    scaffoldBackgroundColor: darkColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: softDarkColor,
      centerTitle: true,
      elevation: 1,
    ),
    iconTheme: const IconThemeData(color: lightGreyColor),
    textTheme: ThemeData.dark().textTheme.apply(
          fontFamily: 'Roboto',
          bodyColor: lightGreyColor,
        ),
    primaryIconTheme: const IconThemeData(
      color: lightPrimaryColor,
    ),
    primaryTextTheme: ThemeData.light().textTheme.apply(
          fontFamily: 'Roboto',
          bodyColor: lightPrimaryColor,
        ),
    colorScheme: const ColorScheme.light(
      primary: lightPrimaryColor,
      error: lightDangerColor,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: softDarkColor,
      selectedItemColor: lightGreyColor,
      selectedIconTheme: IconThemeData(color: lightPrimaryColor),
      unselectedItemColor: greyColor,
    ),
  );
}
