import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../database/app_database.dart';
import '../domain/todo.dart';

final todosRepositoryProvider = Provider<TodosRepository>((ref) {
  return DriftTodosRepository(ref.watch(appDatabaseProvider));
});

abstract class TodosRepository {
  Future<List<Todo>> watchActiveTodos();
  Future<void> upsert(Todo todo);
  Future<void> softDelete(String id, int deletedAt);
}

class DriftTodosRepository implements TodosRepository {
  const DriftTodosRepository(this._database);

  final AppDatabase _database;

  @override
  Future<List<Todo>> watchActiveTodos() async {
    final rows = await _database.todosDao.activeTodos();
    return rows.map(_fromRow).toList();
  }

  @override
  Future<void> upsert(Todo todo) {
    return _database.todosDao.upsertTodo(_toCompanion(todo));
  }

  @override
  Future<void> softDelete(String id, int deletedAt) {
    return _database.todosDao.softDeleteTodo(id, deletedAt);
  }

  TodosCompanion _toCompanion(Todo todo) {
    return TodosCompanion(
      id: Value(todo.id),
      title: Value(todo.title),
      description: Value(todo.description),
      completed: Value(todo.completed),
      dueAt: Value(todo.dueAt),
      priority: Value(todo.priority.index),
      createdAt: Value(todo.createdAt),
      updatedAt: Value(todo.updatedAt),
      deletedAt: Value(todo.deletedAt),
      deviceId: Value(todo.deviceId),
      version: Value(todo.version),
    );
  }

  Todo _fromRow(TodoRow row) {
    return Todo(
      id: row.id,
      title: row.title,
      description: row.description,
      completed: row.completed,
      dueAt: row.dueAt,
      priority: TodoPriority.values[row.priority],
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      deletedAt: row.deletedAt,
      deviceId: row.deviceId,
      version: row.version,
    );
  }
}
