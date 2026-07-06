part of '../app_database.dart';

@DriftAccessor(tables: [Todos])
class TodosDao extends DatabaseAccessor<AppDatabase> with _$TodosDaoMixin {
  TodosDao(super.db);

  Future<List<TodoRow>> activeTodos() {
    return (select(todos)
          ..where((todo) => todo.deletedAt.isNull())
          ..orderBy([
            (todo) => OrderingTerm.asc(todo.completed),
            (todo) => OrderingTerm.desc(todo.updatedAt),
          ]))
        .get();
  }

  Future<List<TodoRow>> allTodos() {
    return select(todos).get();
  }

  Future<TodoRow?> findById(String id) {
    return (select(todos)..where((todo) => todo.id.equals(id)))
        .getSingleOrNull();
  }

  Future<void> upsertTodo(TodosCompanion todo) {
    return into(todos).insertOnConflictUpdate(todo);
  }

  Future<void> softDeleteTodo(String id, int deletedAt) {
    return (update(todos)..where((todo) => todo.id.equals(id))).write(
      TodosCompanion(
        deletedAt: Value(deletedAt),
        updatedAt: Value(deletedAt),
      ),
    );
  }
}
