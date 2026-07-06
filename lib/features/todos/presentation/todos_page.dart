import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/app_shell.dart';
import '../../../shared/widgets/empty_state.dart';
import '../application/todos_controller.dart';
import '../domain/todo.dart';

class TodosPage extends ConsumerWidget {
  const TodosPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todosState = ref.watch(todosControllerProvider);

    return AppShell(
      title: 'Todos',
      floatingActionButton: FloatingActionButton(
        tooltip: 'New todo',
        onPressed: () =>
            ref.read(todosControllerProvider.notifier).createTodo('New todo'),
        child: const Icon(Icons.add),
      ),
      child: todosState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) =>
            Center(child: Text('Could not load todos: $error')),
        data: (state) => _TodosWorkspace(state: state),
      ),
    );
  }
}

class _TodosWorkspace extends ConsumerWidget {
  const _TodosWorkspace({required this.state});

  final TodosState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(todosControllerProvider.notifier);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 840;
        final list = _TodosList(
          state: state,
          onCreateTodo: () => controller.createTodo('New todo'),
          onSelectTodo: controller.selectTodo,
          onToggleTodo: controller.toggleTodo,
          onFilterChanged: controller.setFilter,
        );
        final editor = state.selectedTodo == null
            ? EmptyState(
                icon: Icons.add_task_outlined,
                title: 'No todo selected',
                message: state.todos.isEmpty
                    ? 'Add a todo to plan your day.'
                    : 'Select a todo from the list.',
                actionLabel: 'New todo',
                onActionPressed: () => controller.createTodo('New todo'),
              )
            : _TodoEditor(
                todo: state.selectedTodo!,
                onTitleChanged: (value) => controller.updateTodo(
                  state.selectedTodo!.id,
                  title: value,
                ),
                onDescriptionChanged: (value) => controller.updateTodo(
                  state.selectedTodo!.id,
                  description: value,
                ),
                onCompletedChanged: (value) => controller.updateTodo(
                  state.selectedTodo!.id,
                  completed: value,
                ),
                onDueAtChanged: (value) => controller.updateTodo(
                  state.selectedTodo!.id,
                  dueAt: value,
                ),
                onClearDueAt: () => controller.updateTodo(
                  state.selectedTodo!.id,
                  clearDueAt: true,
                ),
                onPriorityChanged: (value) => controller.updateTodo(
                  state.selectedTodo!.id,
                  priority: value,
                ),
                onDelete: () => controller.deleteTodo(state.selectedTodo!.id),
              );

        if (isWide) {
          return Row(
            children: [
              SizedBox(width: 320, child: list),
              const VerticalDivider(width: 1),
              Expanded(child: editor),
            ],
          );
        }

        return state.selectedTodo == null || state.visibleTodos.isEmpty
            ? list
            : editor;
      },
    );
  }
}

class _TodosList extends StatelessWidget {
  const _TodosList({
    required this.state,
    required this.onCreateTodo,
    required this.onSelectTodo,
    required this.onToggleTodo,
    required this.onFilterChanged,
  });

  final TodosState state;
  final VoidCallback onCreateTodo;
  final ValueChanged<String> onSelectTodo;
  final ValueChanged<String> onToggleTodo;
  final ValueChanged<TodoFilter> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    if (state.todos.isEmpty) {
      return EmptyState(
        icon: Icons.add_task_outlined,
        title: 'No todos yet',
        message: 'Add a task to make the next step obvious.',
        actionLabel: 'New todo',
        onActionPressed: onCreateTodo,
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: SegmentedButton<TodoFilter>(
            segments: const [
              ButtonSegment(value: TodoFilter.all, label: Text('All')),
              ButtonSegment(value: TodoFilter.active, label: Text('Active')),
              ButtonSegment(
                value: TodoFilter.completed,
                label: Text('Done'),
              ),
            ],
            selected: {state.filter},
            onSelectionChanged: (values) => onFilterChanged(values.first),
          ),
        ),
        Expanded(
          child: state.visibleTodos.isEmpty
              ? const Center(child: Text('No todos in this filter.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.visibleTodos.length,
                  itemBuilder: (context, index) {
                    final todo = state.visibleTodos[index];
                    final selected = todo.id == state.selectedTodoId;
                    return Card(
                      color: selected
                          ? Theme.of(context).colorScheme.primaryContainer
                          : null,
                      child: CheckboxListTile(
                        value: todo.completed,
                        title: Text(
                          todo.title,
                          style: todo.completed
                              ? const TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                )
                              : null,
                        ),
                        subtitle: Text(_todoSubtitle(todo)),
                        onChanged: (_) => onToggleTodo(todo.id),
                        secondary: IconButton(
                          tooltip: 'Edit todo',
                          icon: const Icon(Icons.edit_outlined),
                          onPressed: () => onSelectTodo(todo.id),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  String _todoSubtitle(Todo todo) {
    final parts = <String>['Priority: ${todo.priority.name}'];
    if (todo.dueAt != null) {
      parts.add('Due: ${_formatDate(todo.dueAt!)}');
    }
    return parts.join(' · ');
  }
}

class _TodoEditor extends StatefulWidget {
  const _TodoEditor({
    required this.todo,
    required this.onTitleChanged,
    required this.onDescriptionChanged,
    required this.onCompletedChanged,
    required this.onDueAtChanged,
    required this.onClearDueAt,
    required this.onPriorityChanged,
    required this.onDelete,
  });

  final Todo todo;
  final ValueChanged<String> onTitleChanged;
  final ValueChanged<String> onDescriptionChanged;
  final ValueChanged<bool> onCompletedChanged;
  final ValueChanged<int> onDueAtChanged;
  final VoidCallback onClearDueAt;
  final ValueChanged<TodoPriority> onPriorityChanged;
  final VoidCallback onDelete;

  @override
  State<_TodoEditor> createState() => _TodoEditorState();
}

class _TodoEditorState extends State<_TodoEditor> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todo.title);
    _descriptionController =
        TextEditingController(text: widget.todo.description);
  }

  @override
  void didUpdateWidget(covariant _TodoEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.todo.id != widget.todo.id ||
        oldWidget.todo.title != widget.todo.title) {
      _titleController.text = widget.todo.title;
    }
    if (oldWidget.todo.id != widget.todo.id ||
        oldWidget.todo.description != widget.todo.description) {
      _descriptionController.text = widget.todo.description;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                key: const Key('todo-title-field'),
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                onChanged: widget.onTitleChanged,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              tooltip: 'Delete todo',
              icon: const Icon(Icons.delete_outline),
              onPressed: widget.onDelete,
            ),
          ],
        ),
        const SizedBox(height: 12),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Completed'),
          value: widget.todo.completed,
          onChanged: widget.onCompletedChanged,
        ),
        const SizedBox(height: 12),
        TextField(
          key: const Key('todo-description-field'),
          controller: _descriptionController,
          minLines: 4,
          maxLines: null,
          decoration: const InputDecoration(
            labelText: 'Description',
            alignLabelWithHint: true,
            border: OutlineInputBorder(),
          ),
          onChanged: widget.onDescriptionChanged,
        ),
        const SizedBox(height: 16),
        Text('Priority', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        SegmentedButton<TodoPriority>(
          segments: const [
            ButtonSegment(value: TodoPriority.low, label: Text('Low')),
            ButtonSegment(value: TodoPriority.medium, label: Text('Medium')),
            ButtonSegment(value: TodoPriority.high, label: Text('High')),
          ],
          selected: {widget.todo.priority},
          onSelectionChanged: (values) =>
              widget.onPriorityChanged(values.first),
        ),
        const SizedBox(height: 16),
        Text('Due date', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                key: const Key('todo-due-date-button'),
                onPressed: () => _pickDueDate(context),
                icon: const Icon(Icons.event_outlined),
                label: Text(
                  widget.todo.dueAt == null
                      ? 'No due date'
                      : _formatDate(widget.todo.dueAt!),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              tooltip: 'Clear due date',
              onPressed: widget.todo.dueAt == null ? null : widget.onClearDueAt,
              icon: const Icon(Icons.close),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _pickDueDate(BuildContext context) async {
    final initialDate = widget.todo.dueAt == null
        ? DateTime.now()
        : DateTime.fromMillisecondsSinceEpoch(widget.todo.dueAt!);
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null) {
      widget.onDueAtChanged(selectedDate.millisecondsSinceEpoch);
    }
  }
}

String _formatDate(int millis) {
  final date = DateTime.fromMillisecondsSinceEpoch(millis);
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '${date.year}-$month-$day';
}
