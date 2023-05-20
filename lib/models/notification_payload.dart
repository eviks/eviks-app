enum NotificationPayloadType {
  subscription,
}

class NotificationPayload {
  final NotificationPayloadType type;
  final String? subscriptionUrl;

  NotificationPayload({
    required this.type,
    this.subscriptionUrl,
  });

  factory NotificationPayload.fromJson({required dynamic json}) {
    return NotificationPayload(
      type: NotificationPayloadType.values.firstWhere(
        (element) =>
            element.toString() ==
            'NotificationPayloadType.${json['type'] as String}',
      ),
      subscriptionUrl: json['subscriptionUrl'] == null
          ? null
          : json['subscriptionUrl'] as String,
    );
  }
}
