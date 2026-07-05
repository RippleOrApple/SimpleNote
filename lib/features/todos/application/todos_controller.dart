import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/id_generator.dart';
import '../../../core/utils/time.dart';
import '../domain/todo.dart';

final todosControllerProvider =
    StateNotifierProvider<TodosController, List<Todo>>((ref) {
  return TodosController();
});

class TodosController extends StateNotifier<List<Todo>> {
  TodosController() : super(const []);

  void createTodo(String title, {String deviceId = 'local-device'}) {
    final now = Clock.nowMillis();
    final todo = Todo(
      id: IdGenerator.create(),
      title: title,
      createdAt: now,
      updatedAt: now,
      deviceId: deviceId,
    );
    state = [todo, ...state];
  }

  void toggleTodo(String id) {
    final now = Clock.nowMillis();
    state = [
      for (final todo in state)
        if (todo.id == id)
          todo.copyWith(
            completed: !todo.completed,
            updatedAt: now,
            version: todo.version + 1,
          )
        else
          todo,
    ];
  }

  void deleteTodo(String id) {
    state = state.where((todo) => todo.id != id).toList();
  }
}
