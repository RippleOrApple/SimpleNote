import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/statistics_controller.dart';
import '../domain/statistics_range.dart';
import '../domain/statistics_summary.dart';

class StatisticsPage extends ConsumerWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statistics = ref.watch(statisticsControllerProvider);
    return statistics.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Text('Statistics failed to load: $error'),
      ),
      data: (state) => Material(
        child: _StatisticsContent(
          state: state,
          controller: ref.read(statisticsControllerProvider.notifier),
        ),
      ),
    );
  }
}

class _StatisticsContent extends StatelessWidget {
  const _StatisticsContent({
    required this.state,
    required this.controller,
  });

  final StatisticsState state;
  final StatisticsController controller;

  @override
  Widget build(BuildContext context) {
    final summary = state.summary;
    return ListView(
      key: const Key('statistics-page'),
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Statistics',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    state.range.label,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            IconButton(
              key: const Key('statistics-refresh-button'),
              tooltip: 'Refresh statistics',
              onPressed: () => unawaited(
                controller.selectRange(state.range.kind),
              ),
              icon: const Icon(Icons.refresh_rounded),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SegmentedButton<StatisticsRangeKind>(
          selected: {state.range.kind},
          onSelectionChanged: (selected) {
            unawaited(controller.selectRange(selected.single));
          },
          segments: const [
            ButtonSegment(
              value: StatisticsRangeKind.week,
              label: Text('Week', key: Key('statistics-range-week')),
              icon: Icon(Icons.view_week_outlined),
            ),
            ButtonSegment(
              value: StatisticsRangeKind.month,
              label: Text('Month', key: Key('statistics-range-month')),
              icon: Icon(Icons.calendar_month_outlined),
            ),
            ButtonSegment(
              value: StatisticsRangeKind.year,
              label: Text('Year', key: Key('statistics-range-year')),
              icon: Icon(Icons.event_available_outlined),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _MetricTile(
              key: const Key('statistics-task-completions'),
              label: 'Task completions',
              value: '${summary.taskCompletions}',
            ),
            _MetricTile(
              key: const Key('statistics-habit-checkins'),
              label: 'Habit checkins',
              value: '${summary.habitCheckins}',
            ),
            _MetricTile(
              key: const Key('statistics-habit-completion'),
              label: 'Habit completion',
              value: _percent(summary.habitCompletionRate),
            ),
            _MetricTile(
              key: const Key('statistics-current-streak'),
              label: 'Current streak',
              value: '${summary.currentHabitStreak}',
            ),
            _MetricTile(
              key: const Key('statistics-longest-streak'),
              label: 'Longest streak',
              value: '${summary.longestHabitStreak}',
            ),
          ],
        ),
        const SizedBox(height: 24),
        _SummaryBand(summary: summary),
      ],
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.label,
    required this.value,
    super.key,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.labelMedium),
              const SizedBox(height: 10),
              Text(value, style: Theme.of(context).textTheme.headlineMedium),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryBand extends StatelessWidget {
  const _SummaryBand({required this.summary});

  final StatisticsSummary summary;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Range overview', style: textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              'Planned habit days: ${summary.habitPlannedDays}  ·  '
              'Completed habit days: ${summary.habitCompletedDays}',
              style: textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

String _percent(double value) => '${(value * 100).round()}%';
