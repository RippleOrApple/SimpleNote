part of '../app_database.dart';

@DriftAccessor(
  tables: [TaskLists, TaskTags, TaskTagLinks, SmartFilters, TasksV2],
)
class TaskTaxonomyDao extends DatabaseAccessor<AppDatabase>
    with _$TaskTaxonomyDaoMixin {
  TaskTaxonomyDao(super.db);

  Future<TaskListRow?> findListById(String id) {
    return (select(taskLists)..where((item) => item.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<TaskListRow>> activeLists() {
    return (select(taskLists)
          ..where((item) => item.deletedAt.isNull())
          ..orderBy([(item) => OrderingTerm.asc(item.sortOrder)]))
        .get();
  }

  Future<void> upsertList(TaskListsCompanion list) {
    return into(taskLists).insertOnConflictUpdate(list);
  }

  Future<TaskTagRow?> findTagById(String id) {
    return (select(taskTags)..where((item) => item.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<TaskTagRow>> activeTags() {
    return (select(taskTags)..where((item) => item.deletedAt.isNull())).get();
  }

  Future<void> upsertTag(TaskTagsCompanion tag) {
    return into(taskTags).insertOnConflictUpdate(tag);
  }

  Future<List<TaskTagLinkRow>> activeLinksForTasks(Iterable<String> taskIds) {
    final ids = taskIds.toList();
    if (ids.isEmpty) return Future.value(const []);
    return (select(taskTagLinks)
          ..where((link) => link.deletedAt.isNull() & link.taskId.isIn(ids)))
        .get();
  }

  Future<void> replaceLinks(
    String taskId,
    Iterable<TaskTagLinksCompanion> links,
    int deletedAt,
  ) async {
    await (update(taskTagLinks)..where((link) => link.taskId.equals(taskId)))
        .write(TaskTagLinksCompanion(deletedAt: Value(deletedAt)));
    for (final link in links) {
      await into(taskTagLinks).insertOnConflictUpdate(link);
    }
  }

  Future<List<SmartFilterRow>> activeFilters() {
    return (select(smartFilters)
          ..where((item) => item.deletedAt.isNull())
          ..orderBy([(item) => OrderingTerm.asc(item.sortOrder)]))
        .get();
  }

  Future<void> upsertFilter(SmartFiltersCompanion filter) {
    return into(smartFilters).insertOnConflictUpdate(filter);
  }
}
