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

  String getLocalizedName(BuildContext context) {
    final Locale _locale = Localizations.localeOf(context);
    if (_locale == const Locale('az')) return name;
    if (_locale == const Locale('ru')) return nameRu;
    if (_locale == const Locale('en')) return nameEn;
    return name;
  }

  factory MetroStation.fromJson(dynamic json) {
    return MetroStation(
      id: json['_id'] as String,
      cityId: json['cityId'] as String,
      name: json['name'] as String,
      nameRu: json['nameRu'] != null
          ? json['nameRu'] as String
          : json['name'] as String,
      nameEn: json['nameEn'] != null
          ? json['nameEn'] as String
          : json['name'] as String,
      x: json['x'] != null ? json['x'] as double : 0,
      y: json['y'] != null ? json['y'] as double : 0,
    );
  }
}
