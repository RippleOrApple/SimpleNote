import 'package:drift/drift.dart';

@DataClassName('TodoRow')
class Todos extends Table {
  @override
  String get tableName => 'todos';

  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
  IntColumn get dueAt => integer().named('due_at').nullable()();
  IntColumn get priority => integer().withDefault(const Constant(1))();
  IntColumn get createdAt => integer().named('created_at')();
  IntColumn get updatedAt => integer().named('updated_at')();
  IntColumn get deletedAt => integer().named('deleted_at').nullable()();
  TextColumn get deviceId => text().named('device_id')();
  IntColumn get version => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}
