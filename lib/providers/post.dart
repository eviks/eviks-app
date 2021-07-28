import 'package:flutter/foundation.dart';

import '../models/settlement.dart';

enum EstateType {
  apartment,
  house,
}

class Post with ChangeNotifier {
  final int id;
  final EstateType estateType;
  final int price;
  final int rooms;
  final int sqm;
  final Settlement city;
  final Settlement district;
  final List<String> images;
  final String description;
  final List<double> location;
  final int floor;
  final int totalFloors;
  final int lotSqm;

  Post({
    required this.id,
    required this.estateType,
    required this.price,
    required this.rooms,
    required this.sqm,
    required this.city,
    required this.district,
    required this.images,
    required this.description,
    required this.location,
    this.floor = 0,
    this.totalFloors = 0,
    this.lotSqm = 0,
  });

  factory Post.fromJson(dynamic json) {
    return Post(
      id: json['_id'] as int,
      estateType: EstateType.values.firstWhere((element) =>
          element.toString() == 'EstateType.${json['estateType'] as String}'),
      price: json['price'] as int,
      rooms: json['rooms'] as int,
      sqm: json['sqm'] as int,
      city: Settlement.fromJson(json['city']),
      district: Settlement.fromJson(
        json['district'],
      ),
      images: (json['images'] as List<dynamic>).cast<String>(),
      description: json['description'] as String,
      location: (json['location'] as List<dynamic>).cast<double>(),
      floor: json['floor'] as int,
      totalFloors: json['totalFloors'] as int,
      lotSqm: json['lotSqm'] as int,
    );
  }
}
