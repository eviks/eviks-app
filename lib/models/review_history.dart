class ReviewHistory {
  String user;
  DateTime date;
  bool result;
  String comment;

  ReviewHistory({
    required this.user,
    required this.date,
    required this.result,
    required this.comment,
  });

  factory ReviewHistory.fromJson(dynamic json) {
    return ReviewHistory(
      user: json['user'] as String,
      date: DateTime.parse(json['date'] as String),
      result: json['result'] as bool,
      comment: json['comment'] as String,
    );
  }
}
