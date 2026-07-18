import 'package:drift/drift.dart';

@DataClassName('TaskTagLinkRow')
class TaskTagLinks extends Table {
  @override
  String get tableName => 'task_tag_links';

  TextColumn get taskId => text().named('task_id')();
  TextColumn get tagId => text().named('tag_id')();
  IntColumn get createdAt => integer().named('created_at')();
  IntColumn get updatedAt => integer().named('updated_at')();
  IntColumn get deletedAt => integer().named('deleted_at').nullable()();
  TextColumn get deviceId => text().named('device_id')();
  IntColumn get version => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {taskId, tagId};
}
