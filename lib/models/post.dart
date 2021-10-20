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

enum Renovation {
  cosmetic,
  designer,
  noRenovation,
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

String renovationDescription(Renovation renovation, BuildContext ctx) {
  switch (renovation) {
    case Renovation.cosmetic:
      return AppLocalizations.of(ctx)!.cosmetic;
    case Renovation.designer:
      return AppLocalizations.of(ctx)!.designer;
    case Renovation.noRenovation:
      return AppLocalizations.of(ctx)!.noRenovation;
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
  final List<double> location;
  final Settlement? city;
  final Settlement? district;
  final Settlement? subdistrict;
  final String address;
  final int rooms;
  final int sqm;
  final int? livingRoomsSqm;
  final int? kitchenSqm;
  final int? lotSqm;
  final int? floor;
  final int? totalFloors;
  final Renovation renovation;
  final bool redevelopment;
  final bool documented;
  final int price;
  final List<String> images;
  final String description;
  final int step;

  Post({
    required this.id,
    required this.userType,
    required this.estateType,
    this.apartmentType,
    required this.dealType,
    required this.location,
    required this.city,
    required this.district,
    this.subdistrict,
    required this.address,
    required this.rooms,
    required this.sqm,
    this.livingRoomsSqm,
    this.kitchenSqm,
    this.lotSqm,
    this.floor,
    this.totalFloors,
    this.redevelopment = false,
    this.documented = false,
    required this.renovation,
    required this.price,
    required this.images,
    required this.description,
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
      location: (json['location'] as List<dynamic>).cast<double>(),
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
      rooms: json['rooms'] as int,
      sqm: json['sqm'] as int,
      livingRoomsSqm:
          json['livingRoomsSqm'] == null ? null : json['livingRoomsSqm'] as int,
      kitchenSqm: json['kitchenSqm'] == null ? null : json['kitchenSqm'] as int,
      lotSqm: json['lotSqm'] == null ? null : json['lotSqm'] as int,
      floor: json['floor'] as int,
      totalFloors: json['totalFloors'] as int,
      redevelopment: json['redevelopment'] as bool,
      documented: json['documented'] as bool,
      renovation: Renovation.values.firstWhere((element) =>
          element.toString() == 'Renovation.${json['renovation'] as String}'),
      price: json['price'] as int,
      images: (json['images'] as List<dynamic>).cast<String>(),
      description: json['description'] as String,
    );
  }

  Post copyWith({
    UserType? userType,
    EstateType? estateType,
    ApartmentType? apartmentType,
    DealType? dealType,
    List<double>? location,
    Settlement? city,
    Settlement? district,
    Settlement? subdistrict,
    String? address,
    int? rooms,
    int? sqm,
    int? livingRoomsSqm,
    int? kitchenSqm,
    int? lotSqm,
    int? floor,
    int? totalFloors,
    bool? redevelopment,
    bool? documented,
    Renovation? renovation,
    int? price,
    List<String>? images,
    String? description,
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
      location: location ?? this.location,
      city: city ?? this.city,
      district: district ?? this.district,
      subdistrict: subdistrict ?? this.subdistrict,
      address: address ?? this.address,
      rooms: rooms ?? this.rooms,
      sqm: sqm ?? this.sqm,
      livingRoomsSqm: livingRoomsSqm ?? this.livingRoomsSqm,
      kitchenSqm: kitchenSqm ?? this.kitchenSqm,
      lotSqm: lotSqm ?? this.lotSqm,
      floor: floor ?? this.floor,
      totalFloors: totalFloors ?? this.totalFloors,
      redevelopment: redevelopment ?? this.redevelopment,
      documented: documented ?? this.documented,
      renovation: renovation ?? this.renovation,
      price: price ?? this.price,
      images: images ?? this.images,
      description: description ?? this.description,
      step: step ?? this.step,
    );
  }
}
