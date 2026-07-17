// ignore_for_file: recursive_getters

import 'package:drift/drift.dart';

@DataClassName('ContentAttachmentRow')
class ContentAttachments extends Table {
  @override
  String get tableName => 'content_attachments';

  TextColumn get id => text()();
  TextColumn get ownerType => text()
      .named('owner_type')
      .check(ownerType.isIn(const ['task', 'note']))();
  TextColumn get ownerId => text().named('owner_id')();
  TextColumn get sha256 => text()();
  TextColumn get mimeType => text().named('mime_type')();
  IntColumn get byteSize => integer().named('byte_size')();
  IntColumn get width => integer()();
  IntColumn get height => integer()();
  TextColumn get relativePath => text().named('relative_path')();
  TextColumn get thumbnailRelativePath =>
      text().named('thumbnail_relative_path')();
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
