import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_note/database/app_database.dart';
import 'package:simple_note/features/habits/data/habits_repository.dart';
import 'package:simple_note/features/habits/domain/habit.dart';
import 'package:simple_note/features/habits/domain/habit_schedule.dart';
import 'package:simple_note/features/statistics/data/statistics_repository.dart';
import 'package:simple_note/features/statistics/domain/statistics_range.dart';
import 'package:simple_note/features/tasks/data/tasks_repository.dart';
import 'package:simple_note/features/tasks/domain/task.dart';

void main() {
  late AppDatabase database;
  late DriftTasksRepository tasks;
  late DriftHabitsRepository habits;
  late DriftStatisticsRepository statistics;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    tasks = DriftTasksRepository(database);
    habits = DriftHabitsRepository(database);
    statistics = DriftStatisticsRepository(database);
  });

  tearDown(() => database.close());

  test('summarizes task completions and habit checkins in range', () async {
    final range = StatisticsRange.month(anchorDay: _day(2026, 7, 19));
    await tasks.upsertTask(_task(
      'one-off',
      completed: true,
      completedAt: _day(2026, 7, 2, 9),
    ));
    await tasks.upsertTask(_task(
      'outside',
      completed: true,
      completedAt: _day(2026, 8, 1, 9),
    ));
    await tasks.upsertTask(_task(
      'deleted-task',
      completed: true,
      completedAt: _day(2026, 7, 2, 10),
      deletedAt: _day(2026, 7, 3),
    ));
    await tasks.upsertTask(_task(
      'recurring',
      recurrenceRule: 'FREQ=DAILY',
      dueAt: _day(2026, 7, 4),
    ));
    await tasks.completeTaskOccurrence(
      'recurring',
      completedAt: _day(2026, 7, 4, 8),
      completionId: 'completion-1',
    );

    await habits.upsertHabit(_habit(
      'daily',
      schedule: HabitSchedule.daily(),
    ));
    await habits.upsertHabit(_habit(
      'archived',
      archived: true,
      schedule: HabitSchedule.daily(),
    ));
    await habits.upsertHabit(_habit(
      'deleted',
      deletedAt: _day(2026, 7, 10),
      schedule: HabitSchedule.daily(),
    ));
    await habits.checkInHabit(
      id: 'checkin-1',
      habitId: 'daily',
      checkinDay: _day(2026, 7, 1),
      now: _day(2026, 7, 1, 7),
      deviceId: 'device',
    );
    await habits.checkInHabit(
      id: 'checkin-2',
      habitId: 'daily',
      checkinDay: _day(2026, 7, 2),
      now: _day(2026, 7, 2, 7),
      deviceId: 'device',
    );
    await habits.cancelCheckin(
      habitId: 'daily',
      checkinDay: _day(2026, 7, 2),
      deletedAt: _day(2026, 7, 2, 8),
    );
    await habits.checkInHabit(
      id: 'archived-checkin',
      habitId: 'archived',
      checkinDay: _day(2026, 7, 1),
      now: _day(2026, 7, 1),
      deviceId: 'device',
    );

    final summary = await statistics.loadSummary(range);

    expect(summary.range, range);
    expect(summary.taskCompletions, 2);
    expect(summary.habitCheckins, 1);
    expect(summary.habitPlannedDays, 31);
    expect(summary.habitCompletedDays, 1);
    expect(summary.habitCompletionRate, moreOrLessEquals(1 / 31));
    expect(summary.currentHabitStreak, 0);
    expect(summary.longestHabitStreak, 1);
  });

  test('empty summary uses neutral zero values', () async {
    final summary = await statistics.loadSummary(
      StatisticsRange.week(anchorDay: _day(2026, 7, 19)),
    );

    expect(summary.taskCompletions, 0);
    expect(summary.habitCheckins, 0);
    expect(summary.habitPlannedDays, 0);
    expect(summary.habitCompletionRate, 0);
    expect(summary.currentHabitStreak, 0);
    expect(summary.longestHabitStreak, 0);
  });
}

Task _task(
  String id, {
  bool completed = false,
  int? completedAt,
  int? dueAt,
  String? recurrenceRule,
  int? deletedAt,
}) {
  return Task(
    id: id,
    title: id,
    completed: completed,
    completedAt: completedAt,
    dueAt: dueAt,
    recurrenceRule: recurrenceRule,
    deletedAt: deletedAt,
    createdAt: 1,
    updatedAt: 1,
    deviceId: 'device',
  );
}

Habit _habit(
  String id, {
  required HabitSchedule schedule,
  bool archived = false,
  int? deletedAt,
}) {
  return Habit(
    id: id,
    name: id,
    iconKey: 'sparkle',
    color: 0x3366CC,
    schedule: schedule,
    archived: archived,
    createdAt: 1,
    updatedAt: 1,
    deletedAt: deletedAt,
    deviceId: 'device',
  );
}

int _day(int year, int month, int day, [int hour = 0]) {
  return DateTime(year, month, day, hour).millisecondsSinceEpoch;
}
