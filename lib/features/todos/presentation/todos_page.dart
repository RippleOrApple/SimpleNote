import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/app_shell.dart';
import '../application/todos_controller.dart';

class TodosPage extends ConsumerWidget {
  const TodosPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todosControllerProvider);

    return AppShell(
      title: 'Todos',
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            ref.read(todosControllerProvider.notifier).createTodo('New todo'),
        child: const Icon(Icons.add),
      ),
      child: todos.isEmpty
          ? const Center(child: Text('Add a todo to plan your day.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                return CheckboxListTile(
                  value: todo.completed,
                  title: Text(todo.title),
                  subtitle: Text('Priority: ${todo.priority.name}'),
                  onChanged: (_) => ref
                      .read(todosControllerProvider.notifier)
                      .toggleTodo(todo.id),
                );
              },
            ),
    );
  }
}
