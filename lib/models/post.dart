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
enum ApartmentType {
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

String estateTypeDescription(EstateType estateType, BuildContext ctx) {
  switch (estateType) {
    case EstateType.apartment:
      return AppLocalizations.of(ctx)!.apartment;
    case EstateType.house:
      return AppLocalizations.of(ctx)!.house;
    default:
      return '';
  }
}

String apartmentTypeDescription(ApartmentType apartmentType, BuildContext ctx) {
  switch (apartmentType) {
    case ApartmentType.newBuilding:
      return AppLocalizations.of(ctx)!.newBuilding;
    case ApartmentType.secondaryBuilding:
      return AppLocalizations.of(ctx)!.resale;
    default:
      return '';
  }
}

String dealTypeDescription(DealType dealType, BuildContext ctx) {
  switch (dealType) {
    case DealType.sale:
      return AppLocalizations.of(ctx)!.sale;
    case DealType.rent:
      return AppLocalizations.of(ctx)!.rent;
    case DealType.rentPerDay:
      return AppLocalizations.of(ctx)!.rentPerDay;
    default:
      return '';
  }
}

class Post {
  final int id;
  final UserType userType;
  final EstateType estateType;
  final ApartmentType? apartmentType;
  final DealType dealType;
  final int price;
  final int rooms;
  final int sqm;
  final Settlement? city;
  final Settlement? district;
  final String address;
  final List<String> images;
  final String description;
  final List<double> location;
  final Settlement? subdistrict;
  final int floor;
  final int totalFloors;
  final int lotSqm;
  final int step;

  Post({
    required this.id,
    required this.userType,
    required this.estateType,
    this.apartmentType,
    required this.dealType,
    required this.price,
    required this.rooms,
    required this.sqm,
    required this.city,
    required this.district,
    required this.address,
    required this.images,
    required this.description,
    required this.location,
    this.subdistrict,
    this.floor = 0,
    this.totalFloors = 0,
    this.lotSqm = 0,
    this.step = 0,
  });

  factory Post.fromJson(dynamic json) {
    return Post(
      id: json['_id'] as int,
      userType: UserType.values.firstWhere((element) =>
          element.toString() == 'UserType.${json['userType'] as String}'),
      estateType: EstateType.values.firstWhere((element) =>
          element.toString() == 'EstateType.${json['estateType'] as String}'),
      apartmentType: json['apartmentType'] == null
          ? null
          : ApartmentType.values.firstWhere((element) =>
              element.toString() ==
              'ApartmentType.${json['apartmentType'] as String}'),
      dealType: DealType.values.firstWhere((element) =>
          element.toString() == 'DealType.${json['dealType'] as String}'),
      price: json['price'] as int,
      rooms: json['rooms'] as int,
      sqm: json['sqm'] as int,
      city: Settlement.fromJson(json['city']),
      district: Settlement.fromJson(
        json['district'],
      ),
      subdistrict: json['subdistrict'] == null
          ? null
          : Settlement.fromJson(
              json['subdistrict'],
            ),
      address: json['address'] as String,
      images: (json['images'] as List<dynamic>).cast<String>(),
      description: json['description'] as String,
      location: (json['location'] as List<dynamic>).cast<double>(),
      floor: json['floor'] as int,
      totalFloors: json['totalFloors'] as int,
      lotSqm: json['lotSqm'] as int,
    );
  }

  Post copyWith({
    UserType? userType,
    EstateType? estateType,
    ApartmentType? apartmentType,
    DealType? dealType,
    int? price,
    int? rooms,
    int? sqm,
    Settlement? city,
    Settlement? district,
    Settlement? subdistrict,
    String? address,
    List<String>? images,
    String? description,
    List<double>? location,
    int? step,
  }) {
    return Post(
      id: id,
      userType: userType ?? this.userType,
      estateType: estateType ?? this.estateType,
      apartmentType: (estateType ?? this.estateType) == EstateType.house
          ? null
          : apartmentType ?? this.apartmentType,
      dealType: dealType ?? this.dealType,
      price: price ?? this.price,
      rooms: rooms ?? this.rooms,
      sqm: sqm ?? this.sqm,
      city: city ?? this.city,
      district: district ?? this.district,
      address: address ?? this.address,
      images: images ?? this.images,
      description: description ?? this.description,
      location: location ?? this.location,
      subdistrict: subdistrict ?? this.subdistrict,
      step: step ?? this.step,
    );
  }
}
