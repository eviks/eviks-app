class Settlement {
  final String id;
  final String name;
  final double? x;
  final double? y;
  List<Settlement>? children;
  Settlement({
    required this.id,
    required this.name,
    this.x,
    this.y,
    this.children,
  });

  factory Settlement.fromJson(dynamic json) {
    return Settlement(
      id: json['id'] as String,
      name: json['name'] as String,
      x: json['x'] != null ? json['x'] as double : null,
      y: json['y'] != null ? json['y'] as double : null,
      children: json['children'] != null
          ? List<Settlement>.from(
              (json['children'] as List).map(
                (model) => Settlement.fromJson(model),
              ),
            )
          : [],
    );
  }
}
