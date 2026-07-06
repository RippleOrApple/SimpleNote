import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/id_generator.dart';
import '../../../core/utils/time.dart';
import '../data/todos_repository.dart';
import '../domain/todo.dart';

final todosControllerProvider =
    AsyncNotifierProvider<TodosController, TodosState>(TodosController.new);

enum TodoFilter { all, active, completed }

class TodosState {
  const TodosState({
    required this.todos,
    this.selectedTodoId,
    this.filter = TodoFilter.all,
  });

  final List<Todo> todos;
  final String? selectedTodoId;
  final TodoFilter filter;

  List<Todo> get visibleTodos {
    return switch (filter) {
      TodoFilter.all => todos,
      TodoFilter.active => todos.where((todo) => !todo.completed).toList(),
      TodoFilter.completed => todos.where((todo) => todo.completed).toList(),
    };
  }

  Todo? get selectedTodo {
    for (final todo in todos) {
      if (todo.id == selectedTodoId) {
        return todo;
      }
    }
    return visibleTodos.isEmpty ? null : visibleTodos.first;
  }

  TodosState copyWith({
    List<Todo>? todos,
    String? selectedTodoId,
    bool clearSelectedTodoId = false,
    TodoFilter? filter,
  }) {
    return TodosState(
      todos: todos ?? this.todos,
      selectedTodoId:
          clearSelectedTodoId ? null : selectedTodoId ?? this.selectedTodoId,
      filter: filter ?? this.filter,
    );
  }
}

class TodosController extends AsyncNotifier<TodosState> {
  late final TodosRepository _repository;

  @override
  Future<TodosState> build() async {
    _repository = ref.watch(todosRepositoryProvider);
    return _load();
  }

  Future<TodosState> _load({
    TodoFilter filter = TodoFilter.all,
    String? selectedTodoId,
  }) async {
    final todos = await _repository.watchActiveTodos();
    final visibleTodos = switch (filter) {
      TodoFilter.all => todos,
      TodoFilter.active => todos.where((todo) => !todo.completed).toList(),
      TodoFilter.completed => todos.where((todo) => todo.completed).toList(),
    };
    final nextSelectedId = selectedTodoId != null &&
            visibleTodos.any((todo) => todo.id == selectedTodoId)
        ? selectedTodoId
        : _firstOrNull(visibleTodos)?.id;
    return TodosState(
      todos: todos,
      filter: filter,
      selectedTodoId: nextSelectedId,
    );
  }

  Future<void> reload() async {
    final current = state.valueOrNull;
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _load(
        filter: current?.filter ?? TodoFilter.all,
        selectedTodoId: current?.selectedTodoId,
      ),
    );
  }

  Future<void> createTodo(
    String title, {
    String deviceId = 'local-device',
  }) async {
    final now = Clock.nowMillis();
    final todo = Todo(
      id: IdGenerator.create(),
      title: title.trim().isEmpty ? 'New todo' : title.trim(),
      createdAt: now,
      updatedAt: now,
      deviceId: deviceId,
    );
    await _repository.upsert(todo);
    state = await AsyncValue.guard(
      () => _load(
        filter: state.valueOrNull?.filter ?? TodoFilter.all,
        selectedTodoId: todo.id,
      ),
    );
  }

  Future<void> updateTodo(
    String id, {
    String? title,
    String? description,
    bool? completed,
    int? dueAt,
    bool clearDueAt = false,
    TodoPriority? priority,
  }) async {
    final current = state.valueOrNull;
    final todo = _firstOrNull(current?.todos.where((todo) => todo.id == id));
    if (todo == null) {
      return;
    }
    final updated = todo.copyWith(
      title: title,
      description: description,
      completed: completed,
      dueAt: clearDueAt ? null : dueAt,
      clearDueAt: clearDueAt,
      priority: priority,
      updatedAt: Clock.nowMillis(),
      version: todo.version + 1,
    );
    await _repository.upsert(updated);
    state = await AsyncValue.guard(
      () => _load(
        filter: current?.filter ?? TodoFilter.all,
        selectedTodoId: id,
      ),
    );
  }

  Future<void> toggleTodo(String id) async {
    final current = state.valueOrNull;
    final todo = _firstOrNull(current?.todos.where((todo) => todo.id == id));
    if (todo == null) {
      return;
    }
    await updateTodo(id, completed: !todo.completed);
  }

  Future<void> deleteTodo(String id) async {
    final current = state.valueOrNull;
    await _repository.softDelete(id, Clock.nowMillis());
    state = await AsyncValue.guard(
      () => _load(filter: current?.filter ?? TodoFilter.all),
    );
  }

  void selectTodo(String id) {
    final current = state.valueOrNull;
    if (current == null) {
      return;
    }
    state = AsyncData(current.copyWith(selectedTodoId: id));
  }

  Future<void> setFilter(TodoFilter filter) async {
    final current = state.valueOrNull;
    state = await AsyncValue.guard(
      () => _load(
        filter: filter,
        selectedTodoId: current?.selectedTodoId,
      ),
    );
  }
}

T? _firstOrNull<T>(Iterable<T>? values) {
  if (values == null || values.isEmpty) {
    return null;
  }
  return values.first;
}
