import 'package:drift/drift.dart';

@DataClassName('SyncLogRow')
class SyncLogs extends Table {
  @override
  String get tableName => 'sync_logs';

  TextColumn get id => text()();
  TextColumn get peerDeviceId => text().named('peer_device_id').nullable()();
  TextColumn get peerDeviceName =>
      text().named('peer_device_name').nullable()();
  IntColumn get startedAt => integer().named('started_at')();
  IntColumn get finishedAt => integer().named('finished_at').nullable()();
  TextColumn get status => text()();
  IntColumn get notesCreated =>
      integer().named('notes_created').withDefault(const Constant(0))();
  IntColumn get notesUpdated =>
      integer().named('notes_updated').withDefault(const Constant(0))();
  IntColumn get notesDeleted =>
      integer().named('notes_deleted').withDefault(const Constant(0))();
  IntColumn get todosCreated =>
      integer().named('todos_created').withDefault(const Constant(0))();
  IntColumn get todosUpdated =>
      integer().named('todos_updated').withDefault(const Constant(0))();
  IntColumn get todosDeleted =>
      integer().named('todos_deleted').withDefault(const Constant(0))();
  TextColumn get errorMessage => text().named('error_message').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
