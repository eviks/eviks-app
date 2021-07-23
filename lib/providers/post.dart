import 'package:flutter/foundation.dart';

import '../models/settlement.dart';

class Post with ChangeNotifier {
  final int id;
  final int price;
  final int rooms;
  final int sqm;
  final Settlement city;
  final Settlement district;
  final List<String> images;
  final String description;
  final List<double> location;

  Post(
      {required this.id,
      required this.price,
      required this.rooms,
      required this.sqm,
      required this.city,
      required this.district,
      required this.images,
      required this.description,
      required this.location});

  factory Post.fromJson(dynamic json) {
    return Post(
        id: json['_id'] as int,
        price: json['price'] as int,
        rooms: json['rooms'] as int,
        sqm: json['sqm'] as int,
        city: Settlement.fromJson(json['city']),
        district: Settlement.fromJson(
          json['district'],
        ),
        images: (json['images'] as List<dynamic>).cast<String>(),
        description: json['description'] as String,
        location: (json['location'] as List<dynamic>).cast<double>());
  }
}
