import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const primaryColor = Color(0xFFFF337A);
const lightPrimaryColor = Color(0xFFFF4788);
const lightColor = Color(0xFFFFFFFF);
const lightGreyColor = Color(0xFFD8D8D8);
const greyColor = Color(0xFFB4B4B4);
const darkGreyColor = Color(0xFF7A7A7A);
const darkColor = Color(0xFF342E37);
const softDarkColor = Color(0xFF49414E);
const dangerColor = Color(0xFFFF337A);
const lightDangerColor = Color(0xFFFF4788);

final currencyFormat =
    NumberFormat.currency(locale: 'az_AZ', symbol: '₼', decimalDigits: 0);

Color darken(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

  return hslDark.toColor();
}

Color lighten(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

  return hslLight.toColor();
}

void displayErrorMessage(BuildContext context, String mesaage) {
  final snackbar = SnackBar(
    content: Text(mesaage),
    duration: const Duration(seconds: 5),
    action: SnackBarAction(
      label: AppLocalizations.of(context)!.close,
      onPressed: () {},
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackbar);
}

String removeAzerbaijaniChars(String value) {
  String newValue = value;
  newValue = newValue.replaceAll(RegExp('ç', caseSensitive: false), 'c');
  newValue = newValue.replaceAll(RegExp('ə', caseSensitive: false), 'e');
  newValue = newValue.replaceAll(RegExp('ğ', caseSensitive: false), 'g');
  newValue = newValue.replaceAll(RegExp('ı', caseSensitive: false), 'i');
  newValue = newValue.replaceAll(RegExp('ö', caseSensitive: false), 'o');
  newValue = newValue.replaceAll(RegExp('ş', caseSensitive: false), 's');
  newValue = newValue.replaceAll(RegExp('ü', caseSensitive: false), 'u');
  return newValue;
}
