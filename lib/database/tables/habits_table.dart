// ignore_for_file: recursive_getters

import 'package:drift/drift.dart';

@DataClassName('HabitRow')
class Habits extends Table {
  @override
  String get tableName => 'habits';

  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get prompt => text().withDefault(const Constant(''))();
  TextColumn get iconKey => text().named('icon_key')();
  IntColumn get color => integer().check(color.isBetweenValues(0, 0xFFFFFF))();
  TextColumn get scheduleType =>
      text().named('schedule_type').check(scheduleType.isIn(const [
            'daily',
            'weekdays',
            'weekly',
            'interval',
          ]))();
  TextColumn get scheduleJson => text().named('schedule_json')();
  IntColumn get sortOrder =>
      integer().named('sort_order').withDefault(const Constant(0))();
  BoolColumn get archived => boolean().withDefault(const Constant(false))();
  IntColumn get createdAt => integer().named('created_at')();
  IntColumn get updatedAt => integer().named('updated_at')();
  IntColumn get deletedAt => integer().named('deleted_at').nullable()();
  TextColumn get deviceId => text().named('device_id')();
  IntColumn get version => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
        'CHECK (length(trim(name)) > 0)',
      ];
}
