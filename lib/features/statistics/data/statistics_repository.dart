import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../database/app_database.dart';
import '../../habits/domain/habit_schedule.dart';
import '../domain/statistics_range.dart';
import '../domain/statistics_summary.dart';

final statisticsRepositoryProvider = Provider<StatisticsRepository>(
  (ref) => DriftStatisticsRepository(ref.watch(appDatabaseProvider)),
);

abstract class StatisticsRepository {
  Future<StatisticsSummary> loadSummary(StatisticsRange range);
}

class DriftStatisticsRepository implements StatisticsRepository {
  const DriftStatisticsRepository(this._database);

  final AppDatabase _database;

  @override
  Future<StatisticsSummary> loadSummary(StatisticsRange range) async {
    final taskCompletions = await _taskCompletionCount(range);
    final habitRows = await (_database.select(_database.habits)
          ..where(
            (habit) => habit.deletedAt.isNull() & habit.archived.equals(false),
          ))
        .get();
    var plannedDays = 0;
    var completedDays = 0;
    var habitCheckins = 0;
    var currentHabitStreak = 0;
    var longestHabitStreak = 0;
    for (final habit in habitRows) {
      final schedule = HabitSchedule.fromJson(
        habit.scheduleType,
        (jsonDecode(habit.scheduleJson) as Map).cast<String, Object?>(),
      );
      final checkins = await (_database.select(_database.habitCheckins)
            ..where(
              (checkin) =>
                  checkin.habitId.equals(habit.id) &
                  checkin.deletedAt.isNull() &
                  checkin.checkinDay.isBiggerOrEqualValue(range.from) &
                  checkin.checkinDay.isSmallerThanValue(range.before),
            ))
          .get();
      final completedSet =
          checkins.map((checkin) => checkin.checkinDay).toSet();
      final planned = _plannedDays(
        schedule,
        from: range.from,
        before: range.before,
      );
      plannedDays += planned.length;
      habitCheckins += checkins.length;
      completedDays += planned.where(completedSet.contains).length;
      final streaks = _streaks(
        plannedDays: planned,
        completedDays: completedSet,
        asOfDay: range.anchorDay,
      );
      currentHabitStreak += streaks.current;
      if (streaks.longest > longestHabitStreak) {
        longestHabitStreak = streaks.longest;
      }
    }
    return StatisticsSummary(
      range: range,
      taskCompletions: taskCompletions,
      habitCheckins: habitCheckins,
      habitPlannedDays: plannedDays,
      habitCompletedDays: completedDays,
      currentHabitStreak: currentHabitStreak,
      longestHabitStreak: longestHabitStreak,
    );
  }

  Future<int> _taskCompletionCount(StatisticsRange range) async {
    final completionCount = await (_database.selectOnly(
      _database.taskCompletions,
    )
          ..addColumns([_database.taskCompletions.id.count()])
          ..where(
            _database.taskCompletions.deletedAt.isNull() &
                _database.taskCompletions.completedAt
                    .isBiggerOrEqualValue(range.from) &
                _database.taskCompletions.completedAt
                    .isSmallerThanValue(range.before),
          ))
        .map((row) => row.read(_database.taskCompletions.id.count()) ?? 0)
        .getSingle();

    final oneOffCount = await (_database.selectOnly(_database.tasksV2)
          ..addColumns([_database.tasksV2.id.count()])
          ..where(
            _database.tasksV2.deletedAt.isNull() &
                _database.tasksV2.parentId.isNull() &
                _database.tasksV2.completed.equals(true) &
                _database.tasksV2.completedAt.isNotNull() &
                _database.tasksV2.recurrenceRule.isNull() &
                _database.tasksV2.completedAt.isBiggerOrEqualValue(range.from) &
                _database.tasksV2.completedAt.isSmallerThanValue(range.before),
          ))
        .map((row) => row.read(_database.tasksV2.id.count()) ?? 0)
        .getSingle();
    return completionCount + oneOffCount;
  }
}

List<int> _plannedDays(
  HabitSchedule schedule, {
  required int from,
  required int before,
}) {
  final days = <int>[];
  var day = _dayStart(from);
  while (day < before) {
    if (_isScheduledOn(schedule, day)) {
      days.add(day);
    }
    day += _dayMillis;
  }
  return days;
}

bool _isScheduledOn(HabitSchedule schedule, int dayStart) {
  final weekday = DateTime.fromMillisecondsSinceEpoch(dayStart).weekday;
  return switch (schedule.type) {
    HabitScheduleType.daily => true,
    HabitScheduleType.weekdays =>
      weekday >= DateTime.monday && weekday <= DateTime.friday,
    HabitScheduleType.weekly => schedule.weekdays.contains(weekday),
    HabitScheduleType.interval => _matchesInterval(schedule, dayStart),
  };
}

bool _matchesInterval(HabitSchedule schedule, int dayStart) {
  final everyDays = schedule.everyDays;
  final anchorDay = schedule.anchorDay;
  if (everyDays == null || anchorDay == null || dayStart < anchorDay) {
    return false;
  }
  final deltaDays = (dayStart - _dayStart(anchorDay)) ~/ _dayMillis;
  return deltaDays % everyDays == 0;
}

_HabitStreaks _streaks({
  required List<int> plannedDays,
  required Set<int> completedDays,
  required int asOfDay,
}) {
  var longest = 0;
  var running = 0;
  for (final day in plannedDays) {
    if (completedDays.contains(day)) {
      running++;
      if (running > longest) longest = running;
    } else {
      running = 0;
    }
  }
  var current = 0;
  for (final day in plannedDays.reversed) {
    if (day > asOfDay) continue;
    if (!completedDays.contains(day)) break;
    current++;
  }
  return _HabitStreaks(current: current, longest: longest);
}

class _HabitStreaks {
  const _HabitStreaks({required this.current, required this.longest});

  final int current;
  final int longest;
}

int _dayStart(int value) {
  final date = DateTime.fromMillisecondsSinceEpoch(value);
  return DateTime(date.year, date.month, date.day).millisecondsSinceEpoch;
}

const _dayMillis = 24 * 60 * 60 * 1000;
