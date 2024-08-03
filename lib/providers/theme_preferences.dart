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
  return ThemeData(
    useMaterial3: true,
    colorSchemeSeed: primaryColor,
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        side: WidgetStateProperty.all(
          const BorderSide(
            color: lightGreyColor,
          ),
        ),
        shape: WidgetStateProperty.all(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
        ),
      ),
    ),
    appBarTheme: const AppBarTheme(
      shadowColor: lightGreyColor,
      centerTitle: true,
      scrolledUnderElevation: 2,
      surfaceTintColor: Colors.transparent,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(
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
    chipTheme: ChipThemeData(
      showCheckmark: false,
      selectedColor: primaryColor,
      elevation: 0,
      side: const BorderSide(
        width: 0,
        color: lightGreyColor,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      backgroundColor: lightColor,
    ),
  );
}

ThemeData darkThemeData(BuildContext context) {
  return ThemeData.dark().copyWith(
    useMaterial3: true,
    primaryColor: lightPrimaryColor,
    colorScheme: const ColorScheme.dark(
      primary: lightPrimaryColor,
      error: lightDangerColor,
      secondary: lightPrimaryColor,
      surface: darkColor,
    ),
    brightness: Brightness.dark,
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        side: WidgetStateProperty.all(
          const BorderSide(
            color: darkGreyColor,
          ),
        ),
        shape: WidgetStateProperty.all(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
        ),
      ),
    ),
    appBarTheme: const AppBarTheme(
      color: darkColor,
      shadowColor: darkColor,
      centerTitle: true,
      scrolledUnderElevation: 2,
      surfaceTintColor: Colors.transparent,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(
          color: lightPrimaryColor,
          width: 2.0,
        ),
      ),
      fillColor: softDarkColor,
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: lightPrimaryColor, width: 2.0),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: lightPrimaryColor, width: 2.0),
      ),
      iconColor: lightGreyColor,
    ),
    chipTheme: ChipThemeData(
      showCheckmark: false,
      selectedColor: lightPrimaryColor,
      elevation: 0,
      side: const BorderSide(
        width: 0,
        color: darkColor,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      backgroundColor: softDarkColor,
    ),
    scaffoldBackgroundColor: darkColor,
    dividerColor: greyColor,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: softDarkColor,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: darkColor,
    ),
  );
}
