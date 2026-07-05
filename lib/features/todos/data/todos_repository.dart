import '../domain/todo.dart';

abstract class TodosRepository {
  Future<List<Todo>> watchActiveTodos();
  Future<void> upsert(Todo todo);
  Future<void> softDelete(String id, int deletedAt);
}
