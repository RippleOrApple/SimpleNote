import 'package:drift/drift.dart';

@DataClassName('CustomColorRow')
class CustomColors extends Table {
  @override
  String get tableName => 'custom_colors';

  TextColumn get id => text()();
  TextColumn get name => text()();
  // ignore: recursive_getters
  IntColumn get rgb => integer().check(rgb.isBetweenValues(0, 0xFFFFFF))();
  IntColumn get sortOrder =>
      integer().named('sort_order').withDefault(const Constant(0))();
  IntColumn get createdAt => integer().named('created_at')();
  IntColumn get updatedAt => integer().named('updated_at')();
  IntColumn get deletedAt => integer().named('deleted_at').nullable()();
  TextColumn get deviceId => text().named('device_id')();
  IntColumn get version => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}
