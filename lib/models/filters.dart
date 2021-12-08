import 'package:eviks_mobile/models/post.dart';

import './settlement.dart';

class Filters {
  Settlement city;
  List<Settlement>? districts;
  List<Settlement>? subdistricts;
  DealType dealType;
  EstateType? estateType;
  ApartmentType? apartmentType;
  int? priceMin;
  int? priceMax;
  int? roomsMin;
  int? roomsMax;
  int? sqmMin;
  int? sqmMax;
  int? livingRoomsSqmMin;
  int? livingRoomsSqmMax;
  int? kitchenSqmMin;
  int? kitchenSqmMax;
  int? lotSqmMin;
  int? lotSqmMax;

  Filters({
    required this.city,
    required this.dealType,
    this.districts,
    this.subdistricts,
    this.estateType,
    this.apartmentType,
    this.priceMin,
    this.priceMax,
    this.roomsMin,
    this.roomsMax,
    this.sqmMin,
    this.sqmMax,
    this.livingRoomsSqmMin,
    this.livingRoomsSqmMax,
    this.kitchenSqmMin,
    this.kitchenSqmMax,
    this.lotSqmMin,
    this.lotSqmMax,
  });

  Map<String, dynamic> toQueryParameters() => {
        'cityId': city.id,
        'dealType': dealType.toString().replaceAll('DealType.', ''),
        'districtId': districts?.map((e) => e.id).toList().join(','),
        'subdistrictId': subdistricts?.map((e) => e.id).toList().join(','),
        'estateType': estateType?.toString().replaceAll('EstateType.', ''),
        'apartmentType':
            apartmentType?.toString().replaceAll('ApartmentType.', ''),
        'priceMin': priceMin == 0 ? null : priceMin?.toString(),
        'priceMax': priceMax == 0 ? null : priceMax?.toString(),
        'roomsMin': roomsMin == 0 ? null : roomsMin?.toString(),
        'roomsMax': roomsMax == 0 ? null : roomsMax?.toString(),
        'sqmMin': sqmMin == 0 ? null : sqmMin?.toString(),
        'sqmMax': sqmMax == 0 ? null : sqmMax?.toString(),
        'livingRoomsSqmMin':
            livingRoomsSqmMin == 0 ? null : livingRoomsSqmMin?.toString(),
        'livingRoomsSqmMax':
            livingRoomsSqmMax == 0 ? null : livingRoomsSqmMax?.toString(),
        'kitchenSqmMin': kitchenSqmMin == 0 ? null : kitchenSqmMin?.toString(),
        'kitchenSqmMax': kitchenSqmMax == 0 ? null : kitchenSqmMax?.toString(),
        'lotSqmMin': lotSqmMin == 0 ? null : lotSqmMin?.toString(),
        'lotSqmMax': lotSqmMax == 0 ? null : lotSqmMax?.toString(),
      };
}
