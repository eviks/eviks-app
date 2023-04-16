class Subscription {
  final String id;
  final String name;
  final String url;

  Subscription({required this.id, required this.name, required this.url});

  factory Subscription.fromJson({required dynamic json}) {
    return Subscription(
      id: json['id'] as String,
      name: json['name'] as String,
      url: json['url'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'url': url};
}
