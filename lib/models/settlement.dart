class Settlement {
  final String id;
  final String name;
  List<Settlement>? children;
  Settlement({required this.id, required this.name, this.children});

  factory Settlement.fromJson(dynamic json) {
    return Settlement(
      id: json['id'] as String,
      name: json['name'] as String,
      children: json['children'] != null
          ? List<Settlement>.from((json['children'] as List)
              .map((model) => Settlement.fromJson(model)))
          : [],
    );
  }
}
