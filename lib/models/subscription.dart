class Subscription {
  final String id;
  final String name;
  final String url;
  final String? deviceToken;
  final int numberOfElements;

  Subscription({
    required this.id,
    required this.name,
    required this.url,
    required this.deviceToken,
    required this.numberOfElements,
  });

  factory Subscription.fromJson({required dynamic json}) {
    return Subscription(
      id: json['_id'] as String,
      name: json['name'] as String,
      url: json['url'] as String,
      deviceToken:
          json['deviceToken'] == null ? null : json['deviceToken'] as String,
      numberOfElements: json['numberOfElements'] == null
          ? 0
          : json['numberOfElements'] as int,
    );
  }

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'url': url, 'deviceToken': deviceToken};
}
