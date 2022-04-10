import 'package:flutter/material.dart';

class Settlement {
  final String id;
  final String name;
  final String nameRu;
  final String nameEn;
  final String routeName;
  final double? x;
  final double? y;
  List<Settlement>? children;
  Settlement({
    required this.id,
    required this.name,
    required this.nameRu,
    required this.nameEn,
    required this.routeName,
    this.x,
    this.y,
    this.children,
  });

  String getLocaliedName(BuildContext context) {
    final Locale _locale = Localizations.localeOf(context);
    if (_locale == const Locale('az')) return name;
    if (_locale == const Locale('ru')) return nameRu;
    if (_locale == const Locale('en')) return nameEn;
    return name;
  }

  factory Settlement.fromJson(dynamic json) {
    return Settlement(
      id: json['id'] as String,
      name: json['name'] as String,
      nameRu: json['nameRu'] != null
          ? json['nameRu'] as String
          : json['name'] as String,
      nameEn: json['nameEn'] != null
          ? json['nameEn'] as String
          : json['name'] as String,
      routeName: json['routeName'] != null ? json['routeName'] as String : '',
      x: json['x'] != null ? json['x'] as double : null,
      y: json['y'] != null ? json['y'] as double : null,
      children: json['children'] != null
          ? List<Settlement>.from(
              (json['children'] as List).map(
                (model) => Settlement.fromJson(model),
              ),
            )
          : [],
    );
  }
}
