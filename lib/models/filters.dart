import 'package:eviks_mobile/models/post.dart';

class Filters {
  EstateType? estateType;
  ApartmentType? apartmentType;
  int? priceMin;
  int? priceMax;
  int? roomsMin;
  int? roomsMax;

  Filters({
    this.estateType,
    this.apartmentType,
    this.priceMin,
    this.priceMax,
    this.roomsMin,
    this.roomsMax,
  });

  Map<String, dynamic> toQueryParameters() => {
        'estateType': estateType?.toString().replaceAll('EstateType.', ''),
        'apartmentType':
            apartmentType?.toString().replaceAll('ApartmentType.', ''),
        'priceMin': priceMin == 0 ? null : priceMin?.toString(),
        'priceMax': priceMax == 0 ? null : priceMax?.toString(),
        'roomsMin': roomsMin == 0 ? null : roomsMin?.toString(),
        'roomsMax': roomsMax == 0 ? null : roomsMax?.toString(),
      };
}
