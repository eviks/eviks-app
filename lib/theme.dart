import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import './constants.dart';

ThemeData lightThemeData(BuildContext context) {
  return ThemeData.light().copyWith(
    primaryColor: primaryColor,
    disabledColor: greyColor,
    backgroundColor: lightColor,
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
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide.none,
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: primaryColor,
          width: 2.0,
        ),
      ),
      fillColor: lightGreyColor,
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: primaryColor, width: 2.0),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: primaryColor, width: 2.0),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: lightColor,
      selectedItemColor: primaryColor,
      selectedIconTheme: IconThemeData(color: primaryColor),
      unselectedItemColor: greyColor,
    ),
    dividerColor: greyColor,
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: primaryColor,
      contentTextStyle: TextStyle(
        color: lightColor,
      ),
      actionTextColor: lightColor,
      behavior: SnackBarBehavior.floating,
    ),
    toggleButtonsTheme: const ToggleButtonsThemeData(
      selectedColor: primaryColor,
    ),
  );
}

ThemeData darkThemeData(BuildContext context) {
  return ThemeData.dark().copyWith(
    primaryColor: lightPrimaryColor,
    disabledColor: greyColor,
    backgroundColor: darkColor,
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
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide.none,
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: lightPrimaryColor,
          width: 2.0,
        ),
      ),
      fillColor: lightGreyColor,
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: primaryColor, width: 2.0),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: primaryColor, width: 2.0),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: softDarkColor,
      selectedItemColor: lightPrimaryColor,
      selectedIconTheme: IconThemeData(color: lightPrimaryColor),
      unselectedItemColor: greyColor,
    ),
    dividerColor: greyColor,
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: lightPrimaryColor,
      contentTextStyle: TextStyle(
        color: darkColor,
      ),
      actionTextColor: darkColor,
      behavior: SnackBarBehavior.floating,
    ),
    toggleButtonsTheme: const ToggleButtonsThemeData(
      selectedColor: lightPrimaryColor,
    ),
  );
}
