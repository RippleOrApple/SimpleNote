import 'package:drift/drift.dart';

@DataClassName('TaskReminderRow')
class TaskReminders extends Table {
  @override
  String get tableName => 'task_reminders';

  TextColumn get id => text()();
  TextColumn get taskId => text().named('task_id')();
  IntColumn get triggerAt => integer().named('trigger_at').nullable()();
  IntColumn get offsetMinutes => integer().named('offset_minutes').nullable()();
  IntColumn get firedAt => integer().named('fired_at').nullable()();
  IntColumn get createdAt => integer().named('created_at')();
  IntColumn get updatedAt => integer().named('updated_at')();
  IntColumn get deletedAt => integer().named('deleted_at').nullable()();
  TextColumn get deviceId => text().named('device_id')();
  IntColumn get version => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
        'CHECK ((trigger_at IS NULL) != (offset_minutes IS NULL))',
      ];
}
