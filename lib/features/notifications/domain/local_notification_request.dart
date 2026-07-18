class LocalNotificationRequest {
  const LocalNotificationRequest({
    required this.id,
    required this.title,
    required this.body,
    required this.scheduledAt,
    this.payload = const {},
  });

  final String id;
  final String title;
  final String body;
  final int scheduledAt;
  final Map<String, String> payload;
}
