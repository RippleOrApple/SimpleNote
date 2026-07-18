import 'package:flutter/material.dart';

import '../application/tasks_controller.dart';
import '../domain/task.dart';
import '../domain/task_query.dart';

class TaskFilterEditor extends StatefulWidget {
  const TaskFilterEditor({
    required this.state,
    required this.onSave,
    super.key,
  });

  final TasksState state;
  final Future<void> Function({
    required String name,
    required TaskFilterRules rules,
    required TaskSortMode sortMode,
  }) onSave;

  @override
  State<TaskFilterEditor> createState() => _TaskFilterEditorState();
}

class _TaskFilterEditorState extends State<TaskFilterEditor> {
  final _nameController = TextEditingController();
  final _listIds = <String>{};
  final _tagIds = <String>{};
  final _priorities = <TaskPriority>{};
  bool? _completed;
  TaskSortMode _sortMode = TaskSortMode.manual;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('新建智能筛选'),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                key: const Key('task-filter-name-field'),
                controller: _nameController,
                decoration: const InputDecoration(labelText: '名称'),
              ),
              const SizedBox(height: 16),
              Text('清单', style: Theme.of(context).textTheme.labelLarge),
              Wrap(
                spacing: 8,
                children: [
                  for (final list in widget.state.lists)
                    FilterChip(
                      label: Text(list.name),
                      selected: _listIds.contains(list.id),
                      onSelected: (selected) => setState(() {
                        selected
                            ? _listIds.add(list.id)
                            : _listIds.remove(list.id);
                      }),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text('标签', style: Theme.of(context).textTheme.labelLarge),
              Wrap(
                spacing: 8,
                children: [
                  for (final tag in widget.state.tags)
                    FilterChip(
                      label: Text(tag.name),
                      selected: _tagIds.contains(tag.id),
                      onSelected: (selected) => setState(() {
                        selected ? _tagIds.add(tag.id) : _tagIds.remove(tag.id);
                      }),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<bool?>(
                initialValue: _completed,
                decoration: const InputDecoration(labelText: '完成状态'),
                items: const [
                  DropdownMenuItem(value: null, child: Text('不限')),
                  DropdownMenuItem(value: false, child: Text('未完成')),
                  DropdownMenuItem(value: true, child: Text('已完成')),
                ],
                onChanged: (value) => setState(() => _completed = value),
              ),
              const SizedBox(height: 12),
              Text('优先级', style: Theme.of(context).textTheme.labelLarge),
              Wrap(
                spacing: 8,
                children: [
                  for (final priority in TaskPriority.values)
                    FilterChip(
                      label: Text(_priorityLabel(priority)),
                      selected: _priorities.contains(priority),
                      onSelected: (selected) => setState(() {
                        selected
                            ? _priorities.add(priority)
                            : _priorities.remove(priority);
                      }),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<TaskSortMode>(
                initialValue: _sortMode,
                decoration: const InputDecoration(labelText: '排序'),
                items: [
                  for (final mode in TaskSortMode.values)
                    DropdownMenuItem(
                      value: mode,
                      child: Text(_sortLabel(mode)),
                    ),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => _sortMode = value);
                },
              ),
              const SizedBox(height: 16),
              const InputDecorator(
                decoration: InputDecoration(
                  labelText: '时间筛选',
                  enabled: false,
                ),
                child: Text('时间筛选将在 Phase 2 启用'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        FilledButton(
          onPressed: () async {
            if (_nameController.text.trim().isEmpty) return;
            await widget.onSave(
              name: _nameController.text,
              rules: TaskFilterRules(
                listIds: _listIds,
                tagIds: _tagIds,
                completed: _completed,
                priorities: _priorities,
              ),
              sortMode: _sortMode,
            );
            if (context.mounted) Navigator.of(context).pop();
          },
          child: const Text('保存'),
        ),
      ],
    );
  }
}

String _priorityLabel(TaskPriority value) => switch (value) {
      TaskPriority.none => '无',
      TaskPriority.low => '低',
      TaskPriority.medium => '中',
      TaskPriority.high => '高',
    };

String _sortLabel(TaskSortMode value) => switch (value) {
      TaskSortMode.manual => '手动',
      TaskSortMode.dueAt => '截止日期',
      TaskSortMode.priority => '优先级',
      TaskSortMode.createdAt => '创建时间',
    };
