class Subscription {
  final String id;
  final String name;
  final String url;
  final String? deviceToken;
  final bool notify;
  final int numberOfElements;

  Subscription({
    required this.id,
    required this.name,
    required this.url,
    required this.deviceToken,
    required this.notify,
    required this.numberOfElements,
  });

  factory Subscription.fromJson({required dynamic json}) {
    print(json);
    return Subscription(
      id: json['_id'] as String,
      name: json['name'] as String,
      url: json['url'] as String,
      deviceToken:
          json['deviceToken'] == null ? null : json['deviceToken'] as String,
      // ignore: avoid_bool_literals_in_conditional_expressions
      notify: json['notify'] == null ? false : json['notify'] as bool,
      numberOfElements: json['numberOfElements'] == null
          ? 0
          : json['numberOfElements'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'url': url,
        'deviceToken': deviceToken,
        'notify': notify
      };
}
