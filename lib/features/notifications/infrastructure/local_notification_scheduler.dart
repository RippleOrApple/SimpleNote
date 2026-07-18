import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/local_notification_request.dart';

final localNotificationSchedulerProvider =
    Provider<LocalNotificationScheduler>((ref) {
  return const NoopLocalNotificationScheduler();
});

abstract class LocalNotificationScheduler {
  Future<Set<String>> pendingNotificationIds();
  Future<void> schedule(LocalNotificationRequest request);
  Future<void> cancel(String id);
}

class NoopLocalNotificationScheduler implements LocalNotificationScheduler {
  const NoopLocalNotificationScheduler();

  @override
  Future<Set<String>> pendingNotificationIds() async => const {};

  @override
  Future<void> schedule(LocalNotificationRequest request) async {}

  @override
  Future<void> cancel(String id) async {}
}
