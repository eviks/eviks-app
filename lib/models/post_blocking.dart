class PostBlocking {
  String user;
  String username;
  DateTime blockingExpires;

  PostBlocking({
    required this.user,
    required this.username,
    required this.blockingExpires,
  });

  factory PostBlocking.fromJson(dynamic json) {
    return PostBlocking(
      user: json['user'] as String,
      username: json['username'] as String,
      blockingExpires: DateTime.parse(json['blockingExpires'] as String),
    );
  }
}
