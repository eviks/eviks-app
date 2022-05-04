import 'package:flutter/material.dart';

class MetroStation {
  final String id;
  final String cityId;
  final String name;
  final String nameRu;
  final String nameEn;
  final double x;
  final double y;
  MetroStation({
    required this.id,
    required this.cityId,
    required this.name,
    required this.nameRu,
    required this.nameEn,
    required this.x,
    required this.y,
  });

  String getLocaliedName(BuildContext context) {
    final Locale _locale = Localizations.localeOf(context);
    if (_locale == const Locale('az')) return name;
    if (_locale == const Locale('ru')) return nameRu;
    if (_locale == const Locale('en')) return nameEn;
    return name;
  }
}
