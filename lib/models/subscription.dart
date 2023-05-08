class Subscription {
  final String id;
  final String name;
  final String url;
  final String? deviceToken;

  Subscription({
    required this.id,
    required this.name,
    required this.url,
    required this.deviceToken,
  });

  factory Subscription.fromJson({required dynamic json}) {
    return Subscription(
      id: json['_id'] as String,
      name: json['name'] as String,
      url: json['url'] as String,
      deviceToken:
          json['deviceToken'] == null ? null : json['deviceToken'] as String,
    );
  }

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'url': url, 'deviceToken': deviceToken};
}
