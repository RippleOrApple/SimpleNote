part of '../app_database.dart';

@DriftAccessor(tables: [SyncLogs])
class SyncLogsDao extends DatabaseAccessor<AppDatabase>
    with _$SyncLogsDaoMixin {
  SyncLogsDao(super.db);

  Future<List<SyncLogRow>> recentLogs({int limit = 20}) {
    return (select(syncLogs)
          ..orderBy([(log) => OrderingTerm.desc(log.startedAt)])
          ..limit(limit))
        .get();
  }

  Future<void> insertLog(SyncLogsCompanion log) {
    return into(syncLogs).insert(log);
  }
}
