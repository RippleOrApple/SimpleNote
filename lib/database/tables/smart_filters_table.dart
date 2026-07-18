import 'package:drift/drift.dart';

@DataClassName('SmartFilterRow')
class SmartFilters extends Table {
  @override
  String get tableName => 'smart_filters';

  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get rulesJson => text().named('rules_json')();
  TextColumn get sortMode => text().named('sort_mode')();
  IntColumn get sortOrder =>
      integer().named('sort_order').withDefault(const Constant(0))();
  BoolColumn get pinned => boolean().withDefault(const Constant(false))();
  IntColumn get createdAt => integer().named('created_at')();
  IntColumn get updatedAt => integer().named('updated_at')();
  IntColumn get deletedAt => integer().named('deleted_at').nullable()();
  TextColumn get deviceId => text().named('device_id')();
  IntColumn get version => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}
