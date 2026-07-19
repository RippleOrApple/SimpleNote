// ignore_for_file: recursive_getters

import 'package:drift/drift.dart';

@DataClassName('HabitCheckinRow')
class HabitCheckins extends Table {
  @override
  String get tableName => 'habit_checkins';

  TextColumn get id => text()();
  TextColumn get habitId => text().named('habit_id')();
  IntColumn get checkinDay => integer().named('checkin_day')();
  TextColumn get status => text().check(status.isIn(const ['done']))();
  TextColumn get note => text().withDefault(const Constant(''))();
  IntColumn get createdAt => integer().named('created_at')();
  IntColumn get updatedAt => integer().named('updated_at')();
  IntColumn get deletedAt => integer().named('deleted_at').nullable()();
  TextColumn get deviceId => text().named('device_id')();
  IntColumn get version => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}
