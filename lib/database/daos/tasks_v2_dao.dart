part of '../app_database.dart';

@DriftAccessor(tables: [TasksV2])
class TasksV2Dao extends DatabaseAccessor<AppDatabase> with _$TasksV2DaoMixin {
  TasksV2Dao(super.db);

  Future<TaskV2Row?> findById(String id) {
    return (select(tasksV2)..where((task) => task.id.equals(id)))
        .getSingleOrNull();
  }

  Future<void> upsertTask(TasksV2Companion task) {
    return into(tasksV2).insertOnConflictUpdate(task);
  }

  Future<List<TaskV2Row>> directChildren(String parentId) {
    return (select(tasksV2)..where((task) => task.parentId.equals(parentId)))
        .get();
  }
}
