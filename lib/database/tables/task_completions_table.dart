import 'package:drift/drift.dart';

@DataClassName('TaskCompletionRow')
class TaskCompletions extends Table {
  @override
  String get tableName => 'task_completions';

  TextColumn get id => text()();
  TextColumn get taskId => text().named('task_id')();
  IntColumn get scheduledAt => integer().named('scheduled_at')();
  IntColumn get completedAt => integer().named('completed_at')();
  IntColumn get createdAt => integer().named('created_at')();
  IntColumn get updatedAt => integer().named('updated_at')();
  IntColumn get deletedAt => integer().named('deleted_at').nullable()();
  TextColumn get deviceId => text().named('device_id')();
  IntColumn get version => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}
