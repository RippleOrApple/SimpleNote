part of '../app_database.dart';

@DriftAccessor(
  tables: [TaskLists, TaskTags, TaskTagLinks, SmartFilters, TasksV2],
)
class TaskTaxonomyDao extends DatabaseAccessor<AppDatabase>
    with _$TaskTaxonomyDaoMixin {
  TaskTaxonomyDao(super.db);
}
