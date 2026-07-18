import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../application/tasks_controller.dart';
import '../domain/task.dart';
import '../domain/task_list.dart';
import '../domain/task_query.dart';
import 'quick_add_task.dart';

class TaskListPane extends StatelessWidget {
  const TaskListPane({
    required this.state,
    required this.controller,
    this.onOpenSources,
    super.key,
  });

  final TasksState state;
  final TasksController controller;
  final VoidCallback? onOpenSources;

  @override
  Widget build(BuildContext context) {
    final activeList = _activeList(state);
    final content = Column(
      key: const Key('task-list-pane'),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Row(
            children: [
              if (onOpenSources != null)
                IconButton(
                  key: const Key('task-source-button'),
                  tooltip: '任务来源',
                  onPressed: onOpenSources,
                  icon: const Icon(Icons.menu),
                ),
              Expanded(
                child: TextField(
                  key: const Key('task-search-field'),
                  decoration: const InputDecoration(
                    hintText: '搜索任务',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: controller.setSearchText,
                ),
              ),
              const SizedBox(width: 8),
              PopupMenuButton<TaskSortMode>(
                tooltip: '排序',
                onSelected: controller.setSortMode,
                itemBuilder: (_) => [
                  for (final mode in TaskSortMode.values)
                    PopupMenuItem(value: mode, child: Text(_sortLabel(mode))),
                ],
                icon: const Icon(Icons.sort),
              ),
            ],
          ),
        ),
        if (state.query is AllTaskQuery)
          SwitchListTile(
            key: const Key('task-include-completed'),
            dense: true,
            title: const Text('显示已完成'),
            value: (state.query as AllTaskQuery).includeCompleted,
            onChanged: controller.setIncludeCompleted,
          ),
        Expanded(
          child: state.tasks.isEmpty
              ? const Center(child: Text('当前来源没有任务'))
              : ListView.builder(
                  itemExtent: 56,
                  itemCount: state.tasks.length,
                  itemBuilder: (context, index) {
                    final task = state.tasks[index];
                    return _TaskRow(
                      task: task,
                      selected: state.selectedTaskId == task.id,
                      list: state.lists
                          .where((list) => list.id == task.listId)
                          .firstOrNull,
                      tagNames: state.tags
                          .where((tag) =>
                              state.tagIdsFor(task.id).contains(tag.id))
                          .map((tag) => tag.name)
                          .toList(),
                      onTap: () => controller.selectTask(task.id),
                      onToggle: () => controller.toggleTask(task.id),
                    );
                  },
                ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: QuickAddTask(onSubmit: controller.quickAdd),
        ),
      ],
    );
    if (activeList == null) return content;
    final tint = Color(0xFF000000 | activeList.color);
    return Material(
      key: const Key('task-list-tinted-surface'),
      color: Color.alphaBlend(
        tint.withValues(alpha: 0.10),
        Theme.of(context).colorScheme.surface,
      ),
      child: content,
    );
  }
}

class _TaskRow extends StatelessWidget {
  const _TaskRow({
    required this.task,
    required this.selected,
    required this.list,
    required this.tagNames,
    required this.onTap,
    required this.onToggle,
  });

  final Task task;
  final bool selected;
  final TaskList? list;
  final List<String> tagNames;
  final VoidCallback onTap;
  final Future<void> Function() onToggle;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final duration = MediaQuery.disableAnimationsOf(context)
        ? const Duration(milliseconds: 90)
        : const Duration(milliseconds: 340);
    return AnimatedOpacity(
      duration: duration,
      opacity: task.completed ? 0.62 : 1,
      child: AnimatedScale(
        duration: duration,
        scale: task.completed ? 0.98 : 1,
        child: ListTile(
          key: Key('task-row-${task.id}'),
          selected: selected,
          selectedTileColor: colorScheme.primaryContainer,
          leading: IconButton(
            tooltip: task.completed ? '标记未完成' : '完成任务',
            onPressed: onToggle,
            icon: Icon(task.completed
                ? Icons.check_circle
                : Icons.radio_button_unchecked),
          ),
          title: Text(
            task.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              decoration: task.completed ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: _metadata(context),
          trailing: PhosphorIcon(
            _priorityIcon(task.priority),
            color: _priorityColor(task.priority, colorScheme),
            size: 18,
          ),
          onTap: onTap,
        ),
      ),
    );
  }

  Widget? _metadata(BuildContext context) {
    final values = <String>[
      if (task.dueAt != null) _dateLabel(task.dueAt!),
      if (list != null) list!.name,
      ...tagNames,
    ];
    if (values.isEmpty) return null;
    return Text(
      values.join(' · '),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

TaskList? _activeList(TasksState state) {
  final query = state.query;
  if (query is! ListTaskQuery) return null;
  for (final list in state.lists) {
    if (list.id == query.listId) return list;
  }
  return null;
}

String _dateLabel(int milliseconds) {
  final date = DateTime.fromMillisecondsSinceEpoch(milliseconds);
  return '${date.month}/${date.day}';
}

IconData _priorityIcon(TaskPriority priority) => switch (priority) {
      TaskPriority.none => PhosphorIconsRegular.minus,
      TaskPriority.low => PhosphorIconsRegular.flag,
      TaskPriority.medium => PhosphorIconsBold.flag,
      TaskPriority.high => PhosphorIconsFill.flag,
    };

Color _priorityColor(TaskPriority priority, ColorScheme scheme) =>
    switch (priority) {
      TaskPriority.none => scheme.outline,
      TaskPriority.low => Colors.green.shade600,
      TaskPriority.medium => Colors.amber.shade800,
      TaskPriority.high => scheme.error,
    };

String _sortLabel(TaskSortMode value) => switch (value) {
      TaskSortMode.manual => '手动排序',
      TaskSortMode.dueAt => '截止日期',
      TaskSortMode.priority => '优先级',
      TaskSortMode.createdAt => '创建时间',
    };
