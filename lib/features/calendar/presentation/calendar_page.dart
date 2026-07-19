import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/empty_state.dart';
import '../../navigation/application/navigation_controller.dart';
import '../../navigation/domain/app_module.dart';
import '../../notes/application/notes_controller.dart';
import '../../tasks/application/tasks_controller.dart';
import '../../tasks/domain/task_query.dart';
import '../application/calendar_controller.dart';
import '../domain/calendar_entry.dart';

class CalendarPage extends ConsumerWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calendar = ref.watch(calendarControllerProvider);
    return calendar.when(
      loading: () => const Center(
        key: Key('calendar-loading'),
        child: CircularProgressIndicator(),
      ),
      error: (error, _) => Center(
        child: Text('日历加载失败：$error'),
      ),
      data: (state) => _CalendarAgenda(state: state),
    );
  }
}

class _CalendarAgenda extends ConsumerWidget {
  const _CalendarAgenda({required this.state});

  final CalendarState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      key: const Key('calendar-page'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Calendar', style: textTheme.headlineSmall),
                    const SizedBox(height: 4),
                    Text(
                      '${_dateLabel(state.from)} - ${_dateLabel(state.before - 1)}',
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              IconButton(
                key: const Key('calendar-reload-button'),
                tooltip: '刷新日历',
                onPressed: () => _reloadCurrentRange(ref),
                icon: const Icon(Icons.refresh_rounded),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: state.days.isEmpty
              ? const EmptyState(
                  icon: Icons.calendar_month_outlined,
                  title: '未来 30 天暂无日程',
                  message: '带有开始时间、截止时间的任务，以及新建笔记会出现在这里。',
                )
              : ListView.builder(
                  key: const Key('calendar-day-list'),
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  itemCount: state.days.length,
                  itemBuilder: (context, index) {
                    final day = state.days[index];
                    return _CalendarDaySection(
                      day: day,
                      onEntryTap: (entry) => _openEntry(ref, entry),
                    );
                  },
                ),
        ),
      ],
    );
  }

  void _reloadCurrentRange(WidgetRef ref) {
    unawaited(
      ref.read(calendarControllerProvider.notifier).loadRange(
            from: state.from,
            before: state.before,
          ),
    );
  }

  Future<void> _openEntry(WidgetRef ref, CalendarEntry entry) async {
    switch (entry.source) {
      case CalendarEntrySource.task:
        final tasks = ref.read(tasksControllerProvider.notifier);
        await tasks.selectQuery(TaskQuery.all(includeCompleted: true));
        tasks.selectTask(entry.sourceId);
        ref.read(navigationControllerProvider.notifier).select(
              AppModuleKey.today,
            );
      case CalendarEntrySource.note:
        await ref.read(notesControllerProvider.future);
        ref.read(notesControllerProvider.notifier).selectNote(entry.sourceId);
        ref.read(navigationControllerProvider.notifier).select(
              AppModuleKey.notes,
            );
    }
  }
}

class _CalendarDaySection extends StatelessWidget {
  const _CalendarDaySection({
    required this.day,
    required this.onEntryTap,
  });

  final CalendarDay day;
  final ValueChanged<CalendarEntry> onEntryTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      key: Key('calendar-day-${day.dayStart}'),
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _fullDateLabel(day.dayStart),
                    style: textTheme.titleMedium,
                  ),
                ),
                Text(
                  '${day.taskCount} tasks · ${day.noteCount} notes',
                  style: textTheme.labelMedium,
                ),
              ],
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).dividerColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                for (var index = 0; index < day.entries.length; index++) ...[
                  _CalendarEntryTile(
                    entry: day.entries[index],
                    onTap: () => onEntryTap(day.entries[index]),
                  ),
                  if (index != day.entries.length - 1)
                    const Divider(height: 1, indent: 56),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarEntryTile extends StatelessWidget {
  const _CalendarEntryTile({
    required this.entry,
    required this.onTap,
  });

  final CalendarEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final sourceColor = switch (entry.source) {
      CalendarEntrySource.task => colorScheme.primary,
      CalendarEntrySource.note => colorScheme.tertiary,
    };
    return ListTile(
      key: Key('calendar-entry-${entry.sourceId}'),
      minVerticalPadding: 8,
      leading: CircleAvatar(
        radius: 18,
        backgroundColor: sourceColor.withValues(alpha: 0.14),
        foregroundColor: sourceColor,
        child: Icon(_entryIcon(entry.kind), size: 20),
      ),
      title: Text(
        entry.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          decoration: entry.completed ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: Text(_entrySubtitle(entry)),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    );
  }
}

IconData _entryIcon(CalendarEntryKind kind) {
  return switch (kind) {
    CalendarEntryKind.taskStart => Icons.play_circle_outline_rounded,
    CalendarEntryKind.taskDue => Icons.flag_outlined,
    CalendarEntryKind.noteCreated => Icons.article_outlined,
  };
}

String _entrySubtitle(CalendarEntry entry) {
  final parts = [
    _timeLabel(entry),
    switch (entry.kind) {
      CalendarEntryKind.taskStart => '任务开始',
      CalendarEntryKind.taskDue => '任务截止',
      CalendarEntryKind.noteCreated => '笔记创建',
    },
    if (entry.completed) '已完成',
  ];
  return parts.where((part) => part.isNotEmpty).join(' · ');
}

String _timeLabel(CalendarEntry entry) {
  if (entry.allDay) return '全天';
  final date = DateTime.fromMillisecondsSinceEpoch(entry.scheduledAt);
  return '${date.hour.toString().padLeft(2, '0')}:'
      '${date.minute.toString().padLeft(2, '0')}';
}

String _dateLabel(int value) {
  final date = DateTime.fromMillisecondsSinceEpoch(value);
  return '${date.month}/${date.day}';
}

String _fullDateLabel(int value) {
  final date = DateTime.fromMillisecondsSinceEpoch(value);
  const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  return '${date.year}/${date.month}/${date.day} ${weekdays[date.weekday - 1]}';
}
