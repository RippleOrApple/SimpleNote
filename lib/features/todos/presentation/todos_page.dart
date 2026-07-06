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
      title: '待办',
      floatingActionButton: FloatingActionButton(
        tooltip: '新建待办',
        onPressed: () =>
            ref.read(todosControllerProvider.notifier).createTodo('新待办'),
        child: const Icon(Icons.add),
      ),
      child: todosState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('待办加载失败：$error')),
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
          onCreateTodo: () => controller.createTodo('新待办'),
          onSelectTodo: controller.selectTodo,
          onToggleTodo: controller.toggleTodo,
          onFilterChanged: controller.setFilter,
        );
        final editor = state.selectedTodo == null
            ? EmptyState(
                icon: Icons.add_task_outlined,
                title: '未选择待办',
                message: state.todos.isEmpty ? '添加一个待办，安排下一步。' : '从列表中选择一个待办。',
                actionLabel: '新建待办',
                onActionPressed: () => controller.createTodo('新待办'),
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
                onBack: isWide ? null : controller.clearSelection,
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
        title: '还没有待办',
        message: '添加一个任务，让下一步更清楚。',
        actionLabel: '新建待办',
        onActionPressed: onCreateTodo,
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: SegmentedButton<TodoFilter>(
            segments: const [
              ButtonSegment(value: TodoFilter.all, label: Text('全部')),
              ButtonSegment(value: TodoFilter.active, label: Text('进行中')),
              ButtonSegment(
                value: TodoFilter.completed,
                label: Text('已完成'),
              ),
            ],
            selected: {state.filter},
            onSelectionChanged: (values) => onFilterChanged(values.first),
          ),
        ),
        Expanded(
          child: state.visibleTodos.isEmpty
              ? const Center(child: Text('当前筛选下没有待办。'))
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
                          tooltip: '编辑待办',
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
    final parts = <String>['优先级：${_priorityLabel(todo.priority)}'];
    if (todo.dueAt != null) {
      parts.add('截止：${_formatDate(todo.dueAt!)}');
    }
    return parts.join(' | ');
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
    this.onBack,
  });

  final Todo todo;
  final ValueChanged<String> onTitleChanged;
  final ValueChanged<String> onDescriptionChanged;
  final ValueChanged<bool> onCompletedChanged;
  final ValueChanged<int> onDueAtChanged;
  final VoidCallback onClearDueAt;
  final ValueChanged<TodoPriority> onPriorityChanged;
  final Future<void> Function() onDelete;
  final VoidCallback? onBack;

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
            if (widget.onBack != null) ...[
              IconButton(
                key: const Key('todo-back-button'),
                tooltip: '返回待办列表',
                onPressed: widget.onBack,
                icon: const Icon(Icons.arrow_back),
              ),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: TextField(
                key: const Key('todo-title-field'),
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: '标题',
                  border: OutlineInputBorder(),
                ),
                onChanged: widget.onTitleChanged,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              tooltip: '删除待办',
              icon: const Icon(Icons.delete_outline),
              onPressed: _confirmDelete,
            ),
          ],
        ),
        const SizedBox(height: 12),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('已完成'),
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
            labelText: '描述',
            alignLabelWithHint: true,
            border: OutlineInputBorder(),
          ),
          onChanged: widget.onDescriptionChanged,
        ),
        const SizedBox(height: 16),
        Text('优先级', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        SegmentedButton<TodoPriority>(
          segments: const [
            ButtonSegment(value: TodoPriority.low, label: Text('低')),
            ButtonSegment(value: TodoPriority.medium, label: Text('中')),
            ButtonSegment(value: TodoPriority.high, label: Text('高')),
          ],
          selected: {widget.todo.priority},
          onSelectionChanged: (values) =>
              widget.onPriorityChanged(values.first),
        ),
        const SizedBox(height: 16),
        Text('截止日期', style: Theme.of(context).textTheme.titleMedium),
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
                      ? '无截止日期'
                      : _formatDate(widget.todo.dueAt!),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              tooltip: '清除截止日期',
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

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除这个待办？'),
        content: const Text('这个待办会从当前设备移除。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('删除'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) {
      return;
    }
    await widget.onDelete();
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('待办已删除')),
    );
  }
}

String _formatDate(int millis) {
  final date = DateTime.fromMillisecondsSinceEpoch(millis);
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '${date.year}-$month-$day';
}

String _priorityLabel(TodoPriority priority) {
  return switch (priority) {
    TodoPriority.low => '低',
    TodoPriority.medium => '中',
    TodoPriority.high => '高',
  };
}
