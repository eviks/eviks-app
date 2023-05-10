class PostLocation {
  final int id;
  final List<double> location;
  final int price;

  PostLocation({
    required this.id,
    required this.location,
    required this.price,
  });

  factory PostLocation.fromJson({
    required dynamic json,
  }) {
    return PostLocation(
      id: json['_id'] as int,
      location: (json['location'] as List<dynamic>).cast<double>(),
      price: json['price'] as int,
    );
  }
}
