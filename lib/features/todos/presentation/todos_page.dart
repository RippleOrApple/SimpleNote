import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/app_shell.dart';
import '../../../shared/widgets/empty_state.dart';
import '../application/todos_controller.dart';

class TodosPage extends ConsumerWidget {
  const TodosPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todosControllerProvider);
    final todosController = ref.read(todosControllerProvider.notifier);

    return AppShell(
      title: 'Todos',
      floatingActionButton: FloatingActionButton(
        tooltip: 'New todo',
        onPressed: () => todosController.createTodo('New todo'),
        child: const Icon(Icons.add),
      ),
      child: todos.isEmpty
          ? EmptyState(
              icon: Icons.add_task_outlined,
              title: 'No todos yet',
              message: 'Add a task to make the next step obvious.',
              actionLabel: 'New todo',
              onActionPressed: () => todosController.createTodo('New todo'),
            )
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