class NotificationData {
  final String? user;
  final String title;
  final String body;
  final String payload;

  NotificationData({
    this.user,
    required this.title,
    required this.body,
    required this.payload,
  });

  factory NotificationData.fromJson({required dynamic json}) {
    return NotificationData(
      user: json['user'] == null ? null : json['user'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      payload: json['payload'] as String,
    );
  }
}
