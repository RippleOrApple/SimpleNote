import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../../appearance/domain/rgb_color.dart';
import '../application/tasks_controller.dart';
import '../domain/task_list.dart';
import '../domain/task_query.dart';
import '../domain/task_tag.dart';
import 'task_filter_editor.dart';

class TaskSourcesPane extends StatelessWidget {
  const TaskSourcesPane({
    required this.state,
    required this.controller,
    super.key,
  });

  final TasksState state;
  final TasksController controller;

  @override
  Widget build(BuildContext context) {
    return Material(
      key: const Key('task-sources-pane'),
      color: Colors.transparent,
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _SourceTile(
            key: const Key('task-source-inbox'),
            label: '收集箱',
            icon: PhosphorIconsRegular.tray,
            selected: state.query is InboxTaskQuery,
            onTap: () => controller.selectQuery(TaskQuery.inbox(
              sortMode: state.query.sortMode,
            )),
          ),
          _SourceTile(
            key: const Key('task-source-today'),
            label: '今天',
            icon: PhosphorIconsRegular.sun,
            selected: state.query is TodayTaskQuery,
            onTap: () => controller.selectQuery(_todayQuery(state.query)),
          ),
          _SourceTile(
            key: const Key('task-source-next-seven-days'),
            label: '最近 7 天',
            icon: PhosphorIconsRegular.calendarDots,
            selected: state.query is NextSevenDaysTaskQuery,
            onTap: () => controller.selectQuery(_nextSevenDays(state.query)),
          ),
          _SourceTile(
            key: const Key('task-source-all'),
            label: '全部任务',
            icon: PhosphorIconsRegular.listChecks,
            selected: state.query is AllTaskQuery,
            onTap: () => controller.selectQuery(TaskQuery.all(
              sortMode: state.query.sortMode,
            )),
          ),
          const Divider(height: 28),
          _SectionHeader(
            title: '自定义清单',
            tooltip: '新建清单',
            onAdd: () => _showCreateList(context),
          ),
          for (final list in state.lists)
            _ListSourceTile(
              list: list,
              selected: state.query is ListTaskQuery &&
                  (state.query as ListTaskQuery).listId == list.id,
              onTap: () => controller.selectQuery(TaskQuery.list(
                list.id,
                sortMode: state.query.sortMode,
              )),
              onEdit: () => _showEditList(context, list),
            ),
          const Divider(height: 28),
          _SectionHeader(
            title: '标签',
            tooltip: '新建标签',
            onAdd: () => _showCreateTag(context),
          ),
          for (final tag in state.tags)
            _TagSourceTile(
              tag: tag,
              onTap: () => controller.selectQuery(TaskQuery.filter(
                TaskFilterRules(tagIds: {tag.id}),
                sortMode: state.query.sortMode,
              )),
              onEdit: () => _showEditTag(context, tag),
            ),
          const Divider(height: 28),
          _SectionHeader(
            title: '智能筛选',
            tooltip: '新建筛选',
            onAdd: () => showDialog<void>(
              context: context,
              builder: (_) => TaskFilterEditor(
                state: state,
                onSave: controller.saveSmartFilter,
              ),
            ),
          ),
          for (final filter in state.filters)
            _SourceTile(
              key: Key('task-filter-source-${filter.id}'),
              label: filter.name,
              icon: PhosphorIconsRegular.funnel,
              selected: state.query is FilteredTaskQuery &&
                  (state.query as FilteredTaskQuery).rules == filter.rules,
              onTap: () => controller.selectQuery(TaskQuery.filter(
                filter.rules,
                sortMode: filter.sortMode,
              )),
            ),
        ],
      ),
    );
  }

  Future<void> _showCreateList(BuildContext context) async {
    final result = await _showTaxonomyEditor(
      context,
      title: '新建清单',
      initialName: '',
      initialColor: const RgbColor(0x4D8BB8),
      initialIcon: 'list',
      showIcon: true,
    );
    if (result != null) {
      await controller.createList(
        result.name,
        color: result.color,
        iconKey: result.iconKey,
      );
    }
  }

  Future<void> _showEditList(BuildContext context, TaskList list) async {
    final result = await _showTaxonomyEditor(
      context,
      title: '编辑清单',
      initialName: list.name,
      initialColor: RgbColor(list.color),
      initialIcon: list.iconKey,
      showIcon: true,
      allowDelete: true,
    );
    if (result == null) return;
    if (result.delete) {
      if (!context.mounted) return;
      final confirmed = await _confirm(
        context,
        '删除清单？',
        '清单中的任务会移到收集箱。',
      );
      if (confirmed) await controller.deleteList(list.id);
      return;
    }
    await controller.renameList(list.id, result.name);
    await controller.updateListStyle(
      list.id,
      color: result.color,
      iconKey: result.iconKey,
    );
  }

  Future<void> _showCreateTag(BuildContext context) async {
    final result = await _showTaxonomyEditor(
      context,
      title: '新建标签',
      initialName: '',
      initialColor: const RgbColor(0x8A6FB0),
      initialIcon: '',
      showIcon: false,
    );
    if (result != null) {
      await controller.createTag(result.name, color: result.color);
    }
  }

  Future<void> _showEditTag(BuildContext context, TaskTag tag) async {
    final result = await _showTaxonomyEditor(
      context,
      title: '编辑标签',
      initialName: tag.name,
      initialColor: RgbColor(tag.color),
      initialIcon: '',
      showIcon: false,
      allowDelete: true,
    );
    if (result == null) return;
    if (result.delete) {
      if (!context.mounted) return;
      final confirmed = await _confirm(
        context,
        '删除标签？',
        '任务内容不会改变，只会移除标签关联。',
      );
      if (confirmed) await controller.deleteTag(tag.id);
      return;
    }
    await controller.updateTag(
      tag.id,
      name: result.name,
      color: result.color,
    );
  }
}

class _SourceTile extends StatelessWidget {
  const _SourceTile({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      selected: selected,
      leading: PhosphorIcon(icon, size: 20),
      title: Text(label),
      onTap: onTap,
    );
  }
}

class _ListSourceTile extends StatelessWidget {
  const _ListSourceTile({
    required this.list,
    required this.selected,
    required this.onTap,
    required this.onEdit,
  });

  final TaskList list;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: Key('task-list-source-${list.id}'),
      dense: true,
      selected: selected,
      leading: CircleAvatar(
        radius: 8,
        backgroundColor: Color(0xFF000000 | list.color),
      ),
      title: Text(list.name),
      trailing: IconButton(
        tooltip: '编辑清单',
        onPressed: onEdit,
        icon: const Icon(Icons.more_horiz, size: 18),
      ),
      onTap: onTap,
    );
  }
}

class _TagSourceTile extends StatelessWidget {
  const _TagSourceTile({
    required this.tag,
    required this.onTap,
    required this.onEdit,
  });

  final TaskTag tag;
  final VoidCallback onTap;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: Key('task-tag-source-${tag.id}'),
      dense: true,
      leading: const Icon(Icons.tag, size: 18),
      title: Text(tag.name),
      trailing: IconButton(
        tooltip: '编辑标签',
        onPressed: onEdit,
        icon: const Icon(Icons.more_horiz, size: 18),
      ),
      onTap: onTap,
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.tooltip,
    required this.onAdd,
  });

  final String title;
  final String tooltip;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.labelLarge),
        ),
        IconButton(
          tooltip: tooltip,
          onPressed: onAdd,
          icon: const Icon(Icons.add, size: 18),
        ),
      ],
    );
  }
}

TaskQuery _todayQuery(TaskQuery current) {
  final now = DateTime.now();
  final start = DateTime(now.year, now.month, now.day);
  return TaskQuery.today(
    dayStart: start.millisecondsSinceEpoch,
    nextDayStart: start.add(const Duration(days: 1)).millisecondsSinceEpoch,
    sortMode: current.sortMode,
  );
}

TaskQuery _nextSevenDays(TaskQuery current) {
  final now = DateTime.now();
  final start = DateTime(now.year, now.month, now.day);
  return TaskQuery.nextSevenDays(
    dayStart: start.millisecondsSinceEpoch,
    eighthDayStart: start.add(const Duration(days: 8)).millisecondsSinceEpoch,
    sortMode: current.sortMode,
  );
}

Future<_TaxonomyResult?> _showTaxonomyEditor(
  BuildContext context, {
  required String title,
  required String initialName,
  required RgbColor initialColor,
  required String initialIcon,
  required bool showIcon,
  bool allowDelete = false,
}) {
  return showDialog<_TaxonomyResult>(
    context: context,
    builder: (_) => _TaxonomyEditorDialog(
      title: title,
      initialName: initialName,
      initialColor: initialColor,
      initialIcon: initialIcon,
      showIcon: showIcon,
      allowDelete: allowDelete,
    ),
  );
}

class _TaxonomyEditorDialog extends StatefulWidget {
  const _TaxonomyEditorDialog({
    required this.title,
    required this.initialName,
    required this.initialColor,
    required this.initialIcon,
    required this.showIcon,
    required this.allowDelete,
  });

  final String title;
  final String initialName;
  final RgbColor initialColor;
  final String initialIcon;
  final bool showIcon;
  final bool allowDelete;

  @override
  State<_TaxonomyEditorDialog> createState() => _TaxonomyEditorDialogState();
}

class _TaxonomyEditorDialogState extends State<_TaxonomyEditorDialog> {
  late final TextEditingController _name;
  late RgbColor _color;
  late String _icon;

  static const colors = [
    RgbColor(0x596790),
    RgbColor(0x4D8BB8),
    RgbColor(0x5E9D83),
    RgbColor(0xB66B86),
    RgbColor(0x8A6FB0),
  ];

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.initialName);
    _color = widget.initialColor;
    _icon = widget.initialIcon;
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _name,
            decoration: const InputDecoration(labelText: '名称'),
          ),
          const SizedBox(height: 16),
          InputDecorator(
            key: widget.showIcon
                ? const Key('task-list-color-picker')
                : const Key('task-tag-color-picker'),
            decoration: const InputDecoration(labelText: '颜色'),
            child: Wrap(
              spacing: 8,
              children: [
                for (final color in colors)
                  IconButton(
                    tooltip: color.toHex(),
                    onPressed: () => setState(() => _color = color),
                    icon: Icon(
                      _color == color ? Icons.check_circle : Icons.circle,
                      color: color.toColor(),
                    ),
                  ),
              ],
            ),
          ),
          if (widget.showIcon) ...[
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              key: const Key('task-list-icon-picker'),
              initialValue: _icon,
              decoration: const InputDecoration(labelText: '图标'),
              items: const [
                DropdownMenuItem(value: 'list', child: Text('列表')),
                DropdownMenuItem(value: 'briefcase', child: Text('工作')),
                DropdownMenuItem(value: 'folder-open', child: Text('文件夹')),
                DropdownMenuItem(value: 'house', child: Text('家庭')),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _icon = value);
              },
            ),
          ],
        ],
      ),
      actions: [
        if (widget.allowDelete)
          TextButton(
            onPressed: () => Navigator.of(context).pop(
              _TaxonomyResult(
                name: _name.text,
                color: _color,
                iconKey: _icon,
                delete: true,
              ),
            ),
            child: const Text('删除'),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        FilledButton(
          onPressed: () {
            if (_name.text.trim().isEmpty) return;
            Navigator.of(context).pop(_TaxonomyResult(
              name: _name.text.trim(),
              color: _color,
              iconKey: _icon,
            ));
          },
          child: const Text('保存'),
        ),
      ],
    );
  }
}

class _TaxonomyResult {
  const _TaxonomyResult({
    required this.name,
    required this.color,
    required this.iconKey,
    this.delete = false,
  });

  final String name;
  final RgbColor color;
  final String iconKey;
  final bool delete;
}

Future<bool> _confirm(
    BuildContext context, String title, String message) async {
  return await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(title),
          content: Text(message),
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
      ) ??
      false;
}
