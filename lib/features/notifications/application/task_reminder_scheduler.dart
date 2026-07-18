import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../tasks/data/tasks_repository.dart';
import '../../tasks/domain/task_reminder_schedule.dart';
import '../domain/local_notification_request.dart';
import '../infrastructure/local_notification_scheduler.dart';

final taskReminderSchedulerProvider = Provider<TaskReminderScheduler>((ref) {
  return TaskReminderScheduler(
    repository: ref.watch(tasksRepositoryProvider),
    notifications: ref.watch(localNotificationSchedulerProvider),
  );
});

class TaskReminderScheduler {
  const TaskReminderScheduler({
    required TasksRepository repository,
    required LocalNotificationScheduler notifications,
  })  : _repository = repository,
        _notifications = notifications;

  static const notificationIdPrefix = 'task-reminder:';

  final TasksRepository _repository;
  final LocalNotificationScheduler _notifications;

  Future<void> reconcile({
    required int now,
    required int before,
  }) async {
    final schedules = await _repository.listPendingTaskReminderSchedules(
      now: now,
      before: before,
    );
    final expectedIds = {
      for (final schedule in schedules) notificationIdFor(schedule.reminder.id),
    };
    final pendingIds = await _notifications.pendingNotificationIds();
    final staleIds = pendingIds.where(
      (id) => id.startsWith(notificationIdPrefix) && !expectedIds.contains(id),
    );
    for (final id in staleIds) {
      await _notifications.cancel(id);
    }
    for (final schedule in schedules) {
      await _notifications.schedule(_requestFor(schedule));
    }
  }

  Future<void> markFired(String reminderId, int firedAt) async {
    await _repository.markTaskReminderFired(reminderId, firedAt);
    await _notifications.cancel(notificationIdFor(reminderId));
  }

  static String notificationIdFor(String reminderId) {
    return '$notificationIdPrefix$reminderId';
  }

  static LocalNotificationRequest _requestFor(TaskReminderSchedule schedule) {
    return LocalNotificationRequest(
      id: notificationIdFor(schedule.reminder.id),
      title: schedule.task.title,
      body: 'Task reminder',
      scheduledAt: schedule.fireAt,
      payload: {
        'taskId': schedule.task.id,
        'reminderId': schedule.reminder.id,
      },
    );
  }
}
