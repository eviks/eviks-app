import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import './settlement.dart';

enum UserType {
  owner,
  agent,
}

enum EstateType {
  apartment,
  house,
}
enum AppartmentType {
  newBuilding,
  secondaryBuilding,
}

enum DealType {
  sale,
  rent,
  rentPerDay,
}

String userTypeDescription(UserType userType, BuildContext ctx) {
  switch (userType) {
    case UserType.owner:
      return AppLocalizations.of(ctx)!.owner;
    case UserType.agent:
      return AppLocalizations.of(ctx)!.agent;
    default:
      return '';
  }
}

class Post {
  final int id;
  final UserType? userType;
  final EstateType? estateType;
  final AppartmentType? appartmentType;
  final DealType? dealType;
  final int price;
  final int rooms;
  final int sqm;
  final Settlement? city;
  final Settlement? district;
  final List<String> images;
  final String description;
  final List<double> location;
  final int floor;
  final int totalFloors;
  final int lotSqm;

  Post({
    required this.id,
    required this.userType,
    required this.estateType,
    required this.dealType,
    required this.price,
    required this.rooms,
    required this.sqm,
    required this.city,
    required this.district,
    required this.images,
    required this.description,
    required this.location,
    this.appartmentType,
    this.floor = 0,
    this.totalFloors = 0,
    this.lotSqm = 0,
  });

  factory Post.fromJson(dynamic json) {
    return Post(
      id: json['_id'] as int,
      userType: UserType.values.firstWhere((element) =>
          element.toString() == 'UserType.${json['userType'] as String}'),
      estateType: EstateType.values.firstWhere((element) =>
          element.toString() == 'EstateType.${json['estateType'] as String}'),
      dealType: DealType.values.firstWhere((element) =>
          element.toString() == 'DealType.${json['dealType'] as String}'),
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
      appartmentType: json['appartmentType'] == null
          ? null
          : AppartmentType.values.firstWhere((element) =>
              element.toString() ==
              'AppartmentType.${json['appartmentType'] as String}'),
      floor: json['floor'] as int,
      totalFloors: json['totalFloors'] as int,
      lotSqm: json['lotSqm'] as int,
    );
  }
}
