class Settlement {
  final String id;
  final String name;
  Settlement({required this.id, required this.name});

  factory Settlement.fromJson(dynamic json) {
    return Settlement(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }
}
