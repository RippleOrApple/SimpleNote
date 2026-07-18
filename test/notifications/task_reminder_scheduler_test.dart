import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_note/database/app_database.dart';
import 'package:simple_note/features/notifications/application/task_reminder_scheduler.dart';
import 'package:simple_note/features/notifications/domain/local_notification_request.dart';
import 'package:simple_note/features/notifications/infrastructure/local_notification_scheduler.dart';
import 'package:simple_note/features/tasks/data/tasks_repository.dart';
import 'package:simple_note/features/tasks/domain/task.dart';
import 'package:simple_note/features/tasks/domain/task_reminder.dart';

void main() {
  late AppDatabase database;
  late DriftTasksRepository repository;
  late _FakeLocalNotificationScheduler notifications;
  late TaskReminderScheduler scheduler;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = DriftTasksRepository(database);
    notifications = _FakeLocalNotificationScheduler({
      'task-reminder:stale',
      'other-module:keep',
    });
    scheduler = TaskReminderScheduler(
      repository: repository,
      notifications: notifications,
    );
  });

  tearDown(() => database.close());

  test('reconciles pending task reminders into notification requests',
      () async {
    await repository.upsertTask(_task(
      'absolute-task',
      title: 'Absolute task',
    ));
    await repository.upsertTaskReminder(_reminder(
      'absolute',
      'absolute-task',
      triggerAt: 5000,
    ));
    await repository.upsertTask(_task(
      'relative-task',
      title: 'Relative task',
      dueAt: 10000000,
    ));
    await repository.upsertTaskReminder(_reminder(
      'relative',
      'relative-task',
      offsetMinutes: -30,
    ));

    await scheduler.reconcile(now: 1000, before: 20000000);

    expect(notifications.cancelled, ['task-reminder:stale']);
    expect(notifications.pendingIds, contains('other-module:keep'));
    expect(notifications.scheduled.map((request) => request.id), [
      'task-reminder:absolute',
      'task-reminder:relative',
    ]);
    expect(notifications.scheduled.map((request) => request.scheduledAt), [
      5000,
      8200000,
    ]);
    expect(notifications.scheduled.first.title, 'Absolute task');
    expect(
      notifications.scheduled.first.payload,
      {'taskId': 'absolute-task', 'reminderId': 'absolute'},
    );
  });

  test('markFired persists firedAt and cancels the platform request', () async {
    await repository.upsertTask(_task('task'));
    await repository.upsertTaskReminder(_reminder(
      'reminder',
      'task',
      triggerAt: 5000,
    ));
    notifications.pendingIds.add('task-reminder:reminder');

    await scheduler.markFired('reminder', 6000);

    expect((await repository.listTaskReminders('task')).single.firedAt, 6000);
    expect(notifications.cancelled, ['task-reminder:reminder']);
  });
}

class _FakeLocalNotificationScheduler implements LocalNotificationScheduler {
  _FakeLocalNotificationScheduler(Set<String> pendingIds)
      : pendingIds = {...pendingIds};

  final Set<String> pendingIds;
  final scheduled = <LocalNotificationRequest>[];
  final cancelled = <String>[];

  @override
  Future<Set<String>> pendingNotificationIds() async => {...pendingIds};

  @override
  Future<void> schedule(LocalNotificationRequest request) async {
    scheduled.add(request);
    pendingIds.add(request.id);
  }

  @override
  Future<void> cancel(String id) async {
    cancelled.add(id);
    pendingIds.remove(id);
  }
}

Task _task(
  String id, {
  String? title,
  int? startAt,
  int? dueAt,
}) {
  return Task(
    id: id,
    title: title ?? id,
    startAt: startAt,
    dueAt: dueAt,
    createdAt: 1,
    updatedAt: 1,
    deviceId: 'device',
  );
}

TaskReminder _reminder(
  String id,
  String taskId, {
  int? triggerAt,
  int? offsetMinutes,
}) {
  return TaskReminder(
    id: id,
    taskId: taskId,
    triggerAt: triggerAt,
    offsetMinutes: offsetMinutes,
    createdAt: 1,
    updatedAt: 1,
    deviceId: 'device',
  );
}
