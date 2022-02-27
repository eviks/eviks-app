import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import './models/filters.dart';
import './models/pagination.dart';
import './models/post.dart';
import './models/settlement.dart';

// Production
const baseUrl = 'https://eviks.xyz';
const baseScheme = 'https';
const baseHost = 'eviks.xyz';
const basePort = 443;

// Development
// const baseUrl = 'http://192.168.1.9:5000';
// const baseScheme = 'http';
// const baseHost = '192.168.1.9';
// const basePort = 5000;

const primaryColor = Color(0xFFFF337A);
const lightPrimaryColor = Color(0xFFFF4788);
const lightColor = Color(0xFFFFFFFF);
const lightGreyColor = Color(0xFFD8D8D8);
const greyColor = Color(0xFFB4B4B4);
const darkGreyColor = Color(0xFF7A7A7A);
const darkColor = Color(0xFF151316);
const softDarkColor = Color(0xFF342E37);
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

void showSnackBar(BuildContext context, String mesaage) {
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

Settlement getCapitalCity() {
  return Settlement(
    id: '10',
    name: 'Bakı',
    children: [
      Settlement(id: '117', name: 'Binəqədi'),
      Settlement(id: '112', name: 'Nərimanov'),
      Settlement(id: '111', name: 'Nəsimi'),
      Settlement(id: '113', name: 'Nizami'),
      Settlement(id: '122', name: 'Pirallahı'),
      Settlement(id: '121', name: 'Qaradağ'),
      Settlement(id: '118', name: 'Sabunçu'),
      Settlement(id: '115', name: 'Səbail'),
      Settlement(id: '119', name: 'Suraxanı'),
      Settlement(id: '114', name: 'Xətai'),
      Settlement(id: '120', name: 'Xəzər'),
      Settlement(id: '116', name: 'Yasamal'),
    ],
  );
}

Filters initFilters() {
  return Filters(
    city: getCapitalCity(),
    dealType: DealType.sale,
    estateType: EstateType.apartment,
  );
}

Pagination initPagination() {
  return Pagination(
    current: 0,
  );
}
