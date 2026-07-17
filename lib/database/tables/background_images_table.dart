import 'package:drift/drift.dart';

@DataClassName('BackgroundImageRow')
class BackgroundImages extends Table {
  @override
  String get tableName => 'background_images';

  TextColumn get id => text()();
  TextColumn get sha256 => text()();
  TextColumn get mimeType => text().named('mime_type')();
  IntColumn get byteSize => integer().named('byte_size')();
  IntColumn get width => integer()();
  IntColumn get height => integer()();
  TextColumn get relativePath => text().named('relative_path')();
  BoolColumn get syncEnabled =>
      boolean().named('sync_enabled').withDefault(const Constant(false))();
  IntColumn get createdAt => integer().named('created_at')();
  IntColumn get updatedAt => integer().named('updated_at')();
  IntColumn get deletedAt => integer().named('deleted_at').nullable()();
  TextColumn get deviceId => text().named('device_id')();
  IntColumn get version => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}
