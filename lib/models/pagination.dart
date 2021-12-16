class Pagination {
  final int current;
  final int? skipped;
  final int? available;

  Pagination({
    required this.current,
    this.skipped,
    this.available,
  });

  factory Pagination.fromJson(dynamic json) {
    return Pagination(
      current: json['current'] as int,
      available: json['available'] == null ? null : json['available'] as int,
      skipped: json['skipped'] == null ? null : json?['skipped'] as int,
    );
  }
}
