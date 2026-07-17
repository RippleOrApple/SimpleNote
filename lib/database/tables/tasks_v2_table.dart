// ignore_for_file: recursive_getters

import 'package:drift/drift.dart';

@DataClassName('TaskV2Row')
class TasksV2 extends Table {
  @override
  String get tableName => 'tasks_v2';

  TextColumn get id => text()();
  TextColumn get parentId => text().named('parent_id').nullable()();
  TextColumn get listId => text().named('list_id').nullable()();
  TextColumn get title => text()();
  TextColumn get descriptionMarkdown =>
      text().named('description_markdown').withDefault(const Constant(''))();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
  IntColumn get priority => integer()
      .check(priority.isBetweenValues(0, 3))
      .withDefault(const Constant(0))();
  IntColumn get startAt => integer().named('start_at').nullable()();
  IntColumn get dueAt => integer().named('due_at').nullable()();
  BoolColumn get allDay =>
      boolean().named('all_day').withDefault(const Constant(false))();
  IntColumn get sortOrder =>
      integer().named('sort_order').withDefault(const Constant(0))();
  TextColumn get recurrenceRule => text().named('recurrence_rule').nullable()();
  IntColumn get recurrenceEndAt =>
      integer().named('recurrence_end_at').nullable()();
  IntColumn get recurrenceCount =>
      integer().named('recurrence_count').nullable()();
  IntColumn get completedAt => integer().named('completed_at').nullable()();
  IntColumn get createdAt => integer().named('created_at')();
  IntColumn get updatedAt => integer().named('updated_at')();
  IntColumn get deletedAt => integer().named('deleted_at').nullable()();
  TextColumn get deviceId => text().named('device_id')();
  IntColumn get version => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}
