import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class ThemePreferences with ChangeNotifier {
  ThemeMode _themeMode;

  ThemePreferences(this._themeMode);

  ThemeMode get themeMode => _themeMode;

  Future<void> setThemePreferences(ThemeMode selectedThemeMode) async {
    _themeMode = selectedThemeMode;

    final mySystemTheme = themeMode == ThemeMode.dark
        ? SystemUiOverlayStyle.dark
        : SystemUiOverlayStyle.light;
    SystemChrome.setSystemUIOverlayStyle(mySystemTheme);

    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(
        'themeMode',
        selectedThemeMode.toString().replaceAll('ThemeMode.', ''),
      );
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}

ThemeData lightThemeData(BuildContext context) {
  return ThemeData.light().copyWith(
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
    primaryColor: primaryColor,
    androidOverscrollIndicator: AndroidOverscrollIndicator.glow,
    disabledColor: greyColor,
    backgroundColor: lightColor,
    scaffoldBackgroundColor: lightColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: lightColor,
      shadowColor: Colors.transparent,
      centerTitle: true,
      elevation: 0,
      iconTheme: IconThemeData(
        color: primaryColor,
      ),
      titleTextStyle: TextStyle(
        color: primaryColor,
        fontSize: 24.0,
      ),
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
      secondary: primaryColor,
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
      unselectedItemColor: darkGreyColor,
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
      selectedColor: lightColor,
      fillColor: primaryColor,
    ),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateColor.resolveWith(
        (states) {
          if (states.contains(MaterialState.selected)) {
            return primaryColor;
          }
          return greyColor;
        },
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateColor.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return primaryColor;
        }
        return greyColor;
      }),
    ),
    switchTheme: SwitchThemeData(
      trackColor: MaterialStateColor.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return primaryColor;
        }
        return greyColor;
      }),
      thumbColor: MaterialStateColor.resolveWith(
        (states) {
          return lightColor;
        },
      ),
    ),
    chipTheme: ThemeData.light().chipTheme.copyWith(
          backgroundColor: lightColor,
          secondarySelectedColor: primaryColor,
          secondaryLabelStyle: const TextStyle(color: lightColor),
          labelStyle: const TextStyle(color: darkColor),
        ),
    tabBarTheme: const TabBarTheme(
      indicator: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: primaryColor,
            width: 2.0,
          ),
        ),
      ),
    ),
  );
}

ThemeData darkThemeData(BuildContext context) {
  return ThemeData.dark().copyWith(
    brightness: Brightness.dark,
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        side: MaterialStateProperty.all(
          const BorderSide(color: softDarkColor),
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(darkColor),
      ),
    ),
    cardColor: darkColor,
    primaryColor: lightPrimaryColor,
    disabledColor: greyColor,
    backgroundColor: darkColor,
    scaffoldBackgroundColor: darkColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: darkColor,
      shadowColor: Colors.transparent,
      centerTitle: true,
      elevation: 0,
      iconTheme: IconThemeData(
        color: lightPrimaryColor,
      ),
      titleTextStyle: TextStyle(
        color: lightPrimaryColor,
        fontSize: 24.0,
      ),
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
      secondary: lightPrimaryColor,
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
      fillColor: softDarkColor,
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: primaryColor, width: 2.0),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: primaryColor, width: 2.0),
      ),
      iconColor: lightGreyColor,
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
      selectedColor: darkColor,
      color: lightGreyColor,
      fillColor: lightPrimaryColor,
      borderColor: darkGreyColor,
    ),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateColor.resolveWith(
        (states) {
          if (states.contains(MaterialState.selected)) {
            return lightPrimaryColor;
          }
          return greyColor;
        },
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateColor.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return lightPrimaryColor;
        }
        return greyColor;
      }),
      checkColor: MaterialStateProperty.all(darkColor),
    ),
    switchTheme: SwitchThemeData(
      trackColor: MaterialStateColor.resolveWith(
        (states) {
          if (states.contains(MaterialState.selected)) {
            return lightPrimaryColor;
          }
          return greyColor;
        },
      ),
      thumbColor: MaterialStateColor.resolveWith(
        (states) {
          return darkGreyColor;
        },
      ),
    ),
    chipTheme: ThemeData.light().chipTheme.copyWith(
          backgroundColor: darkColor,
          secondarySelectedColor: lightPrimaryColor,
          secondaryLabelStyle: const TextStyle(color: darkColor),
          labelStyle: const TextStyle(color: lightGreyColor),
        ),
    tabBarTheme: const TabBarTheme(
      indicator: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: lightPrimaryColor,
            width: 2.0,
          ),
        ),
      ),
    ),
  );
}
