import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_note/database/app_database.dart';
import 'package:simple_note/features/todos/application/todos_controller.dart';
import 'package:simple_note/features/todos/domain/todo.dart';

void main() {
  late AppDatabase database;
  late ProviderContainer container;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(database)],
    );
  });

  tearDown(() async {
    container.dispose();
    await database.close();
  });

  test('creates edits reloads filters completes and deletes a todo', () async {
    final controller = container.read(todosControllerProvider.notifier);

    await container.read(todosControllerProvider.future);
    await controller.createTodo('Draft plan');

    var state = await container.read(todosControllerProvider.future);
    final todoId = state.todos.single.id;

    await controller.updateTodo(
      todoId,
      title: 'Ship plan',
      description: 'Write the MVP task list',
      dueAt: 1783344000000,
      priority: TodoPriority.high,
    );

    state = await container.read(todosControllerProvider.future);
    expect(state.todos.single.title, 'Ship plan');
    expect(state.todos.single.description, 'Write the MVP task list');
    expect(state.todos.single.dueAt, 1783344000000);
    expect(state.todos.single.priority, TodoPriority.high);
    final updatedAt = state.todos.single.updatedAt;

    await controller.reload();
    state = await container.read(todosControllerProvider.future);
    expect(state.todos.single.id, todoId);

    await controller.toggleTodo(todoId);
    state = await container.read(todosControllerProvider.future);
    expect(state.todos.single.completed, isTrue);
    expect(state.todos.single.updatedAt, greaterThanOrEqualTo(updatedAt));

    await controller.setFilter(TodoFilter.active);
    state = await container.read(todosControllerProvider.future);
    expect(state.visibleTodos, isEmpty);

    await controller.setFilter(TodoFilter.completed);
    state = await container.read(todosControllerProvider.future);
    expect(state.visibleTodos.single.id, todoId);

    await controller.toggleTodo(todoId);
    state = await container.read(todosControllerProvider.future);
    expect(state.todos.single.completed, isFalse);

    await controller.updateTodo(todoId, clearDueAt: true);
    state = await container.read(todosControllerProvider.future);
    expect(state.todos.single.dueAt, isNull);

    await controller.updateTodo(todoId, priority: TodoPriority.low);
    state = await container.read(todosControllerProvider.future);
    expect(state.todos.single.priority, TodoPriority.low);

    await controller.deleteTodo(todoId);
    state = await container.read(todosControllerProvider.future);
    expect(state.todos, isEmpty);
  });
}
