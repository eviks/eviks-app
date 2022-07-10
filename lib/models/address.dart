class Address {
  final String name;
  final String address;
  double longitude;
  double latitude;
  Address({
    required this.name,
    required this.address,
    required this.longitude,
    required this.latitude,
  });

  factory Address.fromJson(dynamic json) {
    return Address(
      name: json['nm'] as String,
      address: json['addr'] as String,
      longitude: json['x'] as double,
      latitude: json['y'] as double,
    );
  }
}
