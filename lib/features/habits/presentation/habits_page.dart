import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/app_shell_embed_scope.dart';
import '../../../shared/widgets/empty_state.dart';
import '../application/habits_controller.dart';
import '../domain/habit.dart';
import '../domain/habit_schedule.dart';

const habitCompactBreakpoint = 600.0;
const habitFullWorkspaceBreakpoint = 1060.0;

class HabitsPage extends ConsumerWidget {
  const HabitsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(habitsControllerProvider);
    return state.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('习惯加载失败：$error')),
      data: (value) => Material(
        child: _HabitsWorkspace(
          state: value,
          controller: ref.read(habitsControllerProvider.notifier),
        ),
      ),
    );
  }
}

class _HabitsWorkspace extends StatelessWidget {
  const _HabitsWorkspace({required this.state, required this.controller});

  final HabitsState state;
  final HabitsController controller;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final workspaceWidth =
            width + (AppShellEmbedScope.maybeOf(context) ? 112 : 0);
        if (workspaceWidth >= habitFullWorkspaceBreakpoint) {
          return Row(
            children: [
              SizedBox(
                width: 360,
                child: _HabitListPane(state: state, controller: controller),
              ),
              const VerticalDivider(width: 1),
              Expanded(
                child: _HabitDetailPane(state: state, controller: controller),
              ),
            ],
          );
        }

        if (width < habitCompactBreakpoint && state.selectedHabit != null) {
          return _HabitDetailPane(
            state: state,
            controller: controller,
            onBack: controller.clearSelection,
          );
        }
        return _HabitListPane(state: state, controller: controller);
      },
    );
  }
}

class _HabitListPane extends StatelessWidget {
  const _HabitListPane({required this.state, required this.controller});

  final HabitsState state;
  final HabitsController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const Key('habit-list-pane'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 12, 10),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '习惯',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              IconButton(
                key: const Key('habit-create-button'),
                tooltip: '创建习惯',
                onPressed: () => _createQuickHabit(context),
                icon: const Icon(Icons.add_rounded),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
          child: Text(
            '今天计划 ${state.todayHabits.length} 个习惯',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: state.habits.isEmpty
              ? EmptyState(
                  icon: Icons.check_circle_outline_rounded,
                  title: '还没有习惯',
                  message: '创建一个每日习惯，从今天开始记录。',
                  actionLabel: '创建',
                  onActionPressed: () => _createQuickHabit(context),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
                  itemCount: state.habits.length,
                  itemBuilder: (context, index) {
                    final habit = state.habits[index];
                    return _HabitRow(
                      habit: habit,
                      selected: state.selectedHabitId == habit.id,
                      checked: state.isCheckedInToday(habit.id),
                      onTap: () => controller.selectHabit(habit.id),
                    );
                  },
                ),
        ),
      ],
    );
  }

  void _createQuickHabit(BuildContext context) {
    unawaited(controller.createHabit(
      name: '新习惯',
      prompt: '',
      iconKey: 'sparkle',
      color: Theme.of(context).colorScheme.primary.toARGB32() & 0xFFFFFF,
      schedule: HabitSchedule.daily(),
    ));
  }
}

class _HabitRow extends StatelessWidget {
  const _HabitRow({
    required this.habit,
    required this.selected,
    required this.checked,
    required this.onTap,
  });

  final Habit habit;
  final bool selected;
  final bool checked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = Color(0xFF000000 | habit.color);
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: ListTile(
        key: Key('habit-row-${habit.id}'),
        selected: selected,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.14),
          foregroundColor: color,
          child: Icon(checked ? Icons.check_rounded : Icons.flag_outlined),
        ),
        title: Text(habit.name, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(
          checked ? '今天已打卡' : _scheduleLabel(habit.schedule),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: onTap,
      ),
    );
  }
}

class _HabitDetailPane extends StatelessWidget {
  const _HabitDetailPane({
    required this.state,
    required this.controller,
    this.onBack,
  });

  final HabitsState state;
  final HabitsController controller;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final habit = state.selectedHabit ??
        (state.habits.isNotEmpty ? state.habits.first : null);
    if (habit == null) {
      return const EmptyState(
        key: Key('habit-detail-pane'),
        icon: Icons.spa_outlined,
        title: '选择一个习惯',
        message: '选择习惯后查看今日状态、连续周期和最近打卡。',
      );
    }
    final checked = state.isCheckedInToday(habit.id);
    final statistics =
        state.selectedHabitId == habit.id ? state.selectedStatistics : null;
    return ListView(
      key: const Key('habit-detail-pane'),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      children: [
        Row(
          children: [
            if (onBack != null)
              IconButton(
                key: const Key('habit-detail-back'),
                tooltip: '返回',
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back_rounded),
              ),
            Expanded(
              child: Text(
                habit.name,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            IconButton(
              key: const Key('habit-edit-button'),
              tooltip: '编辑习惯',
              onPressed: () => _renameHabit(context, habit),
              icon: const Icon(Icons.edit_outlined),
            ),
            IconButton(
              key: const Key('habit-archive-button'),
              tooltip: habit.archived ? '取消归档习惯' : '归档习惯',
              onPressed: () => controller.archiveHabit(
                habit.id,
                archived: !habit.archived,
              ),
              icon: Icon(
                habit.archived
                    ? Icons.unarchive_outlined
                    : Icons.archive_outlined,
              ),
            ),
            IconButton(
              key: const Key('habit-delete-button'),
              tooltip: '删除习惯',
              onPressed: () => controller.deleteHabit(habit.id),
              icon: const Icon(Icons.delete_outline_rounded),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          habit.prompt.isEmpty ? _scheduleLabel(habit.schedule) : habit.prompt,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 20),
        FilledButton.icon(
          key: const Key('habit-checkin-button'),
          onPressed: checked
              ? () => controller.cancelTodayCheckin(habit.id)
              : () => controller.checkInToday(habit.id),
          icon: Icon(
            checked
                ? Icons.remove_done_outlined
                : Icons.check_circle_outline_rounded,
          ),
          label: Text(checked ? '今天已打卡' : '今天打卡'),
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _MetricTile(
              label: '当前连续',
              value: '${statistics?.currentStreak ?? 0}',
            ),
            _MetricTile(
              label: '最长连续',
              value: '${statistics?.longestStreak ?? 0}',
            ),
            _MetricTile(
              label: '完成率',
              value: '${(((statistics?.completionRate ?? 0) * 100).round())}%',
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text('最近打卡', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        if (state.selectedCheckins.isEmpty)
          Text(
            '还没有打卡记录',
            style: Theme.of(context).textTheme.bodyMedium,
          )
        else
          for (final checkin in state.selectedCheckins.reversed.take(14))
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.check_rounded),
              title: Text(_dayLabel(checkin.checkinDay)),
            ),
      ],
    );
  }

  void _renameHabit(BuildContext context, Habit habit) {
    unawaited(controller.updateHabit(
      habit.id,
      name: '${habit.name} 已更新',
      prompt: habit.prompt,
      iconKey: habit.iconKey,
      color: habit.color,
      schedule: habit.schedule,
    ));
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 148,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.labelMedium),
              const SizedBox(height: 8),
              Text(value, style: Theme.of(context).textTheme.headlineSmall),
            ],
          ),
        ),
      ),
    );
  }
}

String _scheduleLabel(HabitSchedule schedule) {
  return switch (schedule.type) {
    HabitScheduleType.daily => '每天',
    HabitScheduleType.weekdays => '工作日',
    HabitScheduleType.weekly => '每周',
    HabitScheduleType.interval => '每 ${schedule.everyDays} 天',
  };
}

String _dayLabel(int value) {
  final date = DateTime.fromMillisecondsSinceEpoch(value);
  return '${date.year}/${date.month}/${date.day}';
}
