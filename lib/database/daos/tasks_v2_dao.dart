part of '../app_database.dart';

@DriftAccessor(tables: [TasksV2])
class TasksV2Dao extends DatabaseAccessor<AppDatabase> with _$TasksV2DaoMixin {
  TasksV2Dao(super.db);
}
