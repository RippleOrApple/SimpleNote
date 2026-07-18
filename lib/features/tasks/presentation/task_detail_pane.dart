import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../../shared/models/markdown_edit.dart';
import '../../../shared/widgets/embedded_markdown_editor.dart';
import '../../../shared/widgets/embedded_markdown_view.dart';
import '../../appearance/domain/rgb_color.dart';
import '../../attachments/domain/content_attachment.dart';
import '../application/tasks_controller.dart';
import '../domain/task.dart';
import '../domain/task_list.dart';
import '../domain/task_reminder.dart';
import '../domain/task_tag.dart';

class TaskDetailPane extends StatefulWidget {
  const TaskDetailPane({
    required this.state,
    required this.controller,
    this.onBack,
    super.key,
  });

  final TasksState state;
  final TasksController controller;
  final VoidCallback? onBack;

  @override
  State<TaskDetailPane> createState() => _TaskDetailPaneState();
}

class _TaskDetailPaneState extends State<TaskDetailPane> {
  final _titleController = TextEditingController();
  Timer? _titleDebounce;
  Timer? _descriptionDebounce;
  String? _pendingDescription;
  String? _pendingDescriptionTaskId;
  String? _taskId;
  bool _previewMode = false;

  @override
  void initState() {
    super.initState();
    _syncTask(force: true);
  }

  @override
  void didUpdateWidget(covariant TaskDetailPane oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncTask(
      force: oldWidget.state.selectedTaskId != widget.state.selectedTaskId,
    );
  }

  void _syncTask({required bool force}) {
    final task = widget.state.selectedTask;
    if (!force && _taskId == task?.id) return;
    _titleDebounce?.cancel();
    _descriptionDebounce?.cancel();
    _taskId = task?.id;
    _titleController.text = task?.title ?? '';
    _pendingDescription = null;
    _pendingDescriptionTaskId = null;
    if (force) _previewMode = false;
  }

  @override
  void dispose() {
    _titleDebounce?.cancel();
    _descriptionDebounce?.cancel();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.state.selectedTask;
    return Material(
      key: const Key('task-detail-pane'),
      color: Colors.transparent,
      child: task == null
          ? const Center(child: Text('选择一个任务查看详情'))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                  children: [
                    if (widget.onBack != null) ...[
                      IconButton(
                        key: const Key('task-detail-back'),
                        tooltip: '返回任务列表',
                        onPressed: widget.onBack,
                        icon: const Icon(Icons.arrow_back),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Expanded(
                      child: TextField(
                        key: const Key('task-title-field'),
                        controller: _titleController,
                        decoration: const InputDecoration(labelText: '标题'),
                        onChanged: (value) => _debounceTitle(task.id, value),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      key: const Key('task-delete-button'),
                      tooltip: '删除任务',
                      onPressed: () => _confirmDelete(task),
                      icon: const Icon(Icons.delete_outline),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment(
                      value: false,
                      icon: Icon(Icons.edit_outlined),
                      label: Text('编辑'),
                    ),
                    ButtonSegment(
                      value: true,
                      icon: Icon(Icons.visibility_outlined),
                      label: Text('预览'),
                    ),
                  ],
                  selected: {_previewMode},
                  onSelectionChanged: (values) =>
                      _setPreviewMode(task.id, values.first),
                ),
                const SizedBox(height: 12),
                if (_previewMode)
                  Container(
                    key: const Key('task-markdown-preview'),
                    constraints: const BoxConstraints(minHeight: 240),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).dividerColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: EmbeddedMarkdownView(
                      markdown: task.descriptionMarkdown.isEmpty
                          ? '_暂无可预览内容。_'
                          : task.descriptionMarkdown,
                      styleSheet: MarkdownStyleSheet.fromTheme(
                        Theme.of(context),
                      ),
                      resolveAttachment: widget.controller.resolveAttachment,
                      onDeleteAttachment: widget.controller.deleteImage,
                    ),
                  )
                else
                  EmbeddedMarkdownEditor(
                    key: const Key('task-description-field'),
                    initialValue: task.descriptionMarkdown,
                    textStyle: Theme.of(context).textTheme.bodyLarge!,
                    onChanged: (value) => _debounceDescription(task.id, value),
                    onInsertImage: (source, selection, {required altText}) =>
                        _insertImage(
                      task.id,
                      source,
                      selection,
                      altText: altText,
                    ),
                  ),
                const SizedBox(height: 16),
                Text('优先级', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final priority in TaskPriority.values)
                      ChoiceChip(
                        key: Key('task-priority-${priority.name}'),
                        selected: task.priority == priority,
                        avatar: Icon(
                          priority == TaskPriority.none
                              ? Icons.remove
                              : priority == TaskPriority.high
                                  ? Icons.flag
                                  : Icons.flag_outlined,
                          size: 18,
                        ),
                        label: Text(_priorityLabel(priority)),
                        onSelected: (_) => widget.controller.updateTask(
                          task.id,
                          priority: priority,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String?>(
                        key: const Key('task-list-picker'),
                        initialValue: task.listId,
                        decoration: const InputDecoration(labelText: '清单'),
                        items: [
                          const DropdownMenuItem(
                              value: null, child: Text('收集箱')),
                          for (final list in widget.state.lists)
                            DropdownMenuItem(
                                value: list.id, child: Text(list.name)),
                        ],
                        onChanged: (value) => widget.controller.updateTask(
                          task.id,
                          listId: value,
                          clearListId: value == null,
                        ),
                      ),
                    ),
                    IconButton(
                      key: const Key('task-list-color-picker'),
                      tooltip: '清单颜色',
                      onPressed: task.listId == null
                          ? null
                          : () => _editListColor(task.listId!),
                      icon: const Icon(Icons.palette_outlined),
                    ),
                    IconButton(
                      key: const Key('task-list-icon-picker'),
                      tooltip: '清单图标',
                      onPressed: task.listId == null
                          ? null
                          : () => _editListIcon(task.listId!),
                      icon: const Icon(Icons.category_outlined),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _TagPicker(
                  key: const Key('task-tags-picker'),
                  tags: widget.state.tags,
                  selectedIds: widget.state.tagIdsFor(task.id),
                  onChanged: (ids) =>
                      widget.controller.setTaskTags(task.id, ids),
                ),
                const SizedBox(height: 16),
                _ReminderSection(
                  task: task,
                  reminders: widget.state.selectedTaskReminders,
                  controller: widget.controller,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    key: const Key('task-tag-color-picker'),
                    tooltip: '标签颜色在任务来源中编辑',
                    onPressed: widget.state.tags.isEmpty
                        ? null
                        : () => _showTagColorInfo(context),
                    icon: const Icon(Icons.color_lens_outlined),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text('子任务', style: Theme.of(context).textTheme.titleSmall),
                    const Spacer(),
                    IconButton(
                      key: const Key('task-add-subtask'),
                      tooltip: '添加子任务',
                      onPressed: () => _addSubtask(task.id),
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
                for (final subtask in widget.state.subtasks)
                  CheckboxListTile(
                    dense: true,
                    value: subtask.completed,
                    title: Text(subtask.title),
                    onChanged: (_) => widget.controller.toggleTask(subtask.id),
                  ),
                const SizedBox(height: 12),
                _SaveStatus(status: widget.state.saveStatus),
              ],
            ),
    );
  }

  void _debounceTitle(String id, String value) {
    _titleDebounce?.cancel();
    _titleDebounce = Timer(const Duration(milliseconds: 350), () {
      widget.controller.updateTask(id, title: value);
    });
  }

  void _debounceDescription(String id, String value) {
    _descriptionDebounce?.cancel();
    _pendingDescriptionTaskId = id;
    _pendingDescription = value;
    _descriptionDebounce = Timer(const Duration(milliseconds: 350), () {
      _flushDescription();
    });
  }

  Future<void> _flushDescription() async {
    _descriptionDebounce?.cancel();
    _descriptionDebounce = null;
    final id = _pendingDescriptionTaskId;
    final value = _pendingDescription;
    _pendingDescriptionTaskId = null;
    _pendingDescription = null;
    if (id != null && value != null) {
      await widget.controller.updateTask(id, descriptionMarkdown: value);
    }
  }

  Future<MarkdownEditResult?> _insertImage(
    String taskId,
    AttachmentPickSource source,
    MarkdownSelection selection, {
    required String altText,
  }) async {
    if (_pendingDescriptionTaskId == taskId) await _flushDescription();
    return widget.controller.insertImage(
      source,
      selection,
      altText: altText,
    );
  }

  Future<void> _setPreviewMode(String taskId, bool value) async {
    if (_pendingDescriptionTaskId == taskId) await _flushDescription();
    if (mounted) setState(() => _previewMode = value);
  }

  TaskList? _listById(String id) {
    for (final list in widget.state.lists) {
      if (list.id == id) return list;
    }
    return null;
  }

  Future<void> _editListColor(String id) async {
    final list = _listById(id);
    if (list == null) return;
    const colors = [0x596790, 0x4D8BB8, 0x5E9D83, 0xB66B86, 0x8A6FB0];
    final color = await showDialog<int>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('清单颜色'),
        children: [
          Wrap(
            alignment: WrapAlignment.center,
            children: [
              for (final value in colors)
                IconButton(
                  onPressed: () => Navigator.of(context).pop(value),
                  icon: Icon(Icons.circle, color: Color(0xFF000000 | value)),
                ),
            ],
          ),
        ],
      ),
    );
    if (color != null) {
      await widget.controller.updateListStyle(
        id,
        color: RgbColor(color),
        iconKey: list.iconKey,
      );
    }
  }

  Future<void> _editListIcon(String id) async {
    final list = _listById(id);
    if (list == null) return;
    final icon = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('清单图标'),
        children: [
          for (final value in const [
            'list',
            'briefcase',
            'folder-open',
            'house'
          ])
            SimpleDialogOption(
              onPressed: () => Navigator.of(context).pop(value),
              child: Text(value),
            ),
        ],
      ),
    );
    if (icon != null) {
      await widget.controller.updateListStyle(
        id,
        color: RgbColor(list.color),
        iconKey: icon,
      );
    }
  }

  Future<void> _addSubtask(String parentId) async {
    final input = TextEditingController();
    final title = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('添加子任务'),
        content: TextField(
          autofocus: true,
          controller: input,
          textInputAction: TextInputAction.done,
          onSubmitted: (value) => Navigator.of(context).pop(value),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(input.text),
            child: const Text('添加'),
          ),
        ],
      ),
    );
    input.dispose();
    if (title != null) await widget.controller.addSubtask(parentId, title);
  }

  Future<void> _confirmDelete(Task task) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除任务？'),
        content: Text('“${task.title}”及其子任务会被删除。'),
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
    if (confirmed == true) await widget.controller.deleteTask(task.id);
  }
}

class _ReminderSection extends StatelessWidget {
  const _ReminderSection({
    required this.task,
    required this.reminders,
    required this.controller,
  });

  final Task task;
  final List<TaskReminder> reminders;
  final TasksController controller;

  @override
  Widget build(BuildContext context) {
    final anchor = task.dueAt ?? task.startAt;
    return InputDecorator(
      key: const Key('task-reminders-section'),
      decoration: const InputDecoration(labelText: 'Reminders'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final reminder in reminders)
                InputChip(
                  key: const Key('task-reminder-item'),
                  label: Text(_reminderLabel(reminder)),
                  onDeleted: () => controller.deleteTaskReminder(reminder.id),
                  deleteIcon: const Icon(
                    Icons.close_rounded,
                    key: Key('task-remove-reminder'),
                  ),
                ),
              if (reminders.isEmpty)
                Text(
                  'No reminders',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
            ],
          ),
          const SizedBox(height: 8),
          PopupMenuButton<int>(
            key: const Key('task-add-reminder'),
            enabled: anchor != null,
            tooltip: 'Add reminder',
            onSelected: (value) {
              if (value == 0) {
                controller.createAbsoluteTaskReminder(
                  task.id,
                  triggerAt: anchor!,
                );
              } else {
                controller.createRelativeTaskReminder(
                  task.id,
                  offsetMinutes: value,
                );
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                key: Key('task-reminder-absolute'),
                value: 0,
                child: Text('At task time'),
              ),
              PopupMenuItem(
                key: Key('task-reminder-relative-10'),
                value: -10,
                child: Text('10 minutes before'),
              ),
              PopupMenuItem(
                key: Key('task-reminder-relative-60'),
                value: -60,
                child: Text('1 hour before'),
              ),
            ],
            child: TextButton.icon(
              onPressed: null,
              icon: const Icon(Icons.add_alert_outlined),
              label: Text(anchor == null ? 'Set a time first' : 'Add reminder'),
            ),
          ),
        ],
      ),
    );
  }
}

class _TagPicker extends StatelessWidget {
  const _TagPicker({
    required this.tags,
    required this.selectedIds,
    required this.onChanged,
    super.key,
  });

  final List<TaskTag> tags;
  final Set<String> selectedIds;
  final ValueChanged<Set<String>> onChanged;

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: const InputDecoration(labelText: '标签'),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          if (tags.isEmpty) const Text('暂无标签'),
          for (final tag in tags)
            FilterChip(
              label: Text(tag.name),
              selected: selectedIds.contains(tag.id),
              avatar:
                  CircleAvatar(backgroundColor: Color(0xFF000000 | tag.color)),
              onSelected: (selected) {
                final next = {...selectedIds};
                selected ? next.add(tag.id) : next.remove(tag.id);
                onChanged(next);
              },
            ),
        ],
      ),
    );
  }
}

class _SaveStatus extends StatelessWidget {
  const _SaveStatus({required this.status});

  final TaskSaveStatus status;

  @override
  Widget build(BuildContext context) {
    final label = switch (status) {
      TaskSaveStatus.idle => '',
      TaskSaveStatus.saving => '保存中',
      TaskSaveStatus.saved => '已保存',
      TaskSaveStatus.failed => '保存失败',
    };

    return Semantics(
      key: const Key('task-save-status'),
      liveRegion: true,
      child: Text(label, style: Theme.of(context).textTheme.labelMedium),
    );
  }
}

void _showTagColorInfo(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('标签颜色'),
      content: const Text('请在任务来源面板中编辑标签颜色。'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('知道了'),
        ),
      ],
    ),
  );
}

String _priorityLabel(TaskPriority priority) => switch (priority) {
      TaskPriority.none => '无',
      TaskPriority.low => '低',
      TaskPriority.medium => '中',
      TaskPriority.high => '高',
    };

String _reminderLabel(TaskReminder reminder) {
  final triggerAt = reminder.triggerAt;
  if (triggerAt != null) {
    final date = DateTime.fromMillisecondsSinceEpoch(triggerAt);
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$month/$day $hour:$minute';
  }
  final offset = reminder.offsetMinutes ?? 0;
  if (offset == 0) return 'At task time';
  final abs = offset.abs();
  final unit = abs == 1 ? 'minute' : 'minutes';
  return offset < 0 ? '$abs $unit before' : '$abs $unit after';
}
