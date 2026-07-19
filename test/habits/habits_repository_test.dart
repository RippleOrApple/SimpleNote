import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_note/database/app_database.dart';
import 'package:simple_note/features/habits/data/habits_repository.dart';
import 'package:simple_note/features/habits/domain/habit.dart';
import 'package:simple_note/features/habits/domain/habit_schedule.dart';

void main() {
  late AppDatabase database;
  late DriftHabitsRepository habits;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    habits = DriftHabitsRepository(database);
  });

  tearDown(() => database.close());

  test('upserts habits and queries active day plans by schedule', () async {
    await habits.upsertHabit(_habit(
      'daily',
      name: 'Drink water',
      schedule: HabitSchedule.daily(),
      sortOrder: 2,
    ));
    await habits.upsertHabit(_habit(
      'weekday',
      name: 'Read',
      schedule: HabitSchedule.weekdays(),
      sortOrder: 1,
    ));
    await habits.upsertHabit(_habit(
      'monday',
      name: 'Plan week',
      schedule: HabitSchedule.weekly({DateTime.monday}),
      sortOrder: 3,
    ));
    await habits.upsertHabit(_habit(
      'tuesday',
      schedule: HabitSchedule.weekly({DateTime.tuesday}),
      sortOrder: 4,
    ));
    await habits.upsertHabit(_habit(
      'archived',
      archived: true,
      schedule: HabitSchedule.daily(),
      sortOrder: 5,
    ));
    await habits.upsertHabit(_habit(
      'deleted',
      deletedAt: _day(2026, 7, 19),
      schedule: HabitSchedule.daily(),
      sortOrder: 6,
    ));

    final mondayPlan = await habits.listHabitsForDay(_day(2026, 7, 20));
    final active = await habits.listHabits();
    final withArchived = await habits.listHabits(includeArchived: true);

    expect(mondayPlan.map((habit) => habit.id), [
      'weekday',
      'daily',
      'monday',
    ]);
    expect(active.map((habit) => habit.id), [
      'weekday',
      'daily',
      'monday',
      'tuesday',
    ]);
    expect(withArchived.map((habit) => habit.id), [
      'weekday',
      'daily',
      'monday',
      'tuesday',
      'archived',
    ]);

    await habits.archiveHabit(
      'daily',
      archived: true,
      updatedAt: _day(2026, 7, 21),
    );
    expect(await habits.findHabit('daily'), isNotNull);
    expect(
      (await habits.listHabitsForDay(_day(2026, 7, 22)))
          .map((habit) => habit.id),
      ['weekday'],
    );

    await habits.softDeleteHabit('weekday', _day(2026, 7, 22));
    expect(await habits.findHabit('weekday'), isNull);
  });

  test('checkin is idempotent per day and cancellation is soft delete',
      () async {
    await habits.upsertHabit(_habit('daily', schedule: HabitSchedule.daily()));

    final first = await habits.checkInHabit(
      id: 'checkin-1',
      habitId: 'daily',
      checkinDay: _day(2026, 7, 20),
      now: _day(2026, 7, 20, 8),
      deviceId: 'device-a',
      note: 'first',
    );
    final duplicate = await habits.checkInHabit(
      id: 'checkin-2',
      habitId: 'daily',
      checkinDay: _day(2026, 7, 20),
      now: _day(2026, 7, 20, 9),
      deviceId: 'device-a',
      note: 'duplicate',
    );

    expect(duplicate.id, first.id);
    expect(await habits.listCheckins('daily'), hasLength(1));
    expect((await habits.listCheckins('daily')).single.note, 'first');

    await habits.cancelCheckin(
      habitId: 'daily',
      checkinDay: _day(2026, 7, 20),
      deletedAt: _day(2026, 7, 20, 10),
    );

    expect(await habits.listCheckins('daily'), isEmpty);
    final deleted = await habits.listCheckins('daily', includeDeleted: true);
    expect(deleted.single.deletedAt, _day(2026, 7, 20, 10));
    expect(deleted.single.version, 2);

    final secondActive = await habits.checkInHabit(
      id: 'checkin-3',
      habitId: 'daily',
      checkinDay: _day(2026, 7, 20),
      now: _day(2026, 7, 20, 11),
      deviceId: 'device-a',
    );

    expect(secondActive.id, 'checkin-3');
    expect(await habits.listCheckins('daily'), hasLength(1));
    expect(
      (await habits.listCheckins('daily', includeDeleted: true))
          .map((item) => item.id),
      ['checkin-1', 'checkin-3'],
    );
  });

  test('statistics counts planned days and streaks across weeks', () async {
    await habits.upsertHabit(_habit(
      'training',
      schedule: HabitSchedule.weekly({
        DateTime.monday,
        DateTime.wednesday,
        DateTime.friday,
      }),
    ));
    for (final day in [
      _day(2026, 7, 6),
      _day(2026, 7, 8),
      _day(2026, 7, 10),
      _day(2026, 7, 13),
    ]) {
      await habits.checkInHabit(
        id: 'checkin-$day',
        habitId: 'training',
        checkinDay: day,
        now: day,
        deviceId: 'device-a',
      );
    }

    final statistics = await habits.habitStatistics(
      'training',
      from: _day(2026, 7, 6),
      before: _day(2026, 7, 14),
      asOfDay: _day(2026, 7, 13),
    );

    expect(statistics.plannedDays, 4);
    expect(statistics.completedDays, 4);
    expect(statistics.completionRate, 1);
    expect(statistics.currentStreak, 4);
    expect(statistics.longestStreak, 4);
  });

  test('statistics handles cross-month interval schedules', () async {
    await habits.upsertHabit(_habit(
      'interval',
      schedule: HabitSchedule.interval(
        everyDays: 3,
        anchorDay: _day(2026, 6, 28),
      ),
    ));
    for (final day in [
      _day(2026, 6, 28),
      _day(2026, 7, 1),
      _day(2026, 7, 2),
      _day(2026, 7, 7),
    ]) {
      await habits.checkInHabit(
        id: 'checkin-$day',
        habitId: 'interval',
        checkinDay: day,
        now: day,
        deviceId: 'device-a',
      );
    }

    final statistics = await habits.habitStatistics(
      'interval',
      from: _day(2026, 6, 28),
      before: _day(2026, 7, 8),
      asOfDay: _day(2026, 7, 7),
    );

    expect(statistics.plannedDays, 4);
    expect(statistics.completedDays, 3);
    expect(statistics.completionRate, moreOrLessEquals(0.75));
    expect(statistics.currentStreak, 1);
    expect(statistics.longestStreak, 2);
  });
}

Habit _habit(
  String id, {
  String? name,
  HabitSchedule? schedule,
  int sortOrder = 0,
  bool archived = false,
  int? deletedAt,
}) {
  return Habit(
    id: id,
    name: name ?? id,
    iconKey: 'sparkle',
    color: 0x3366CC,
    schedule: schedule ?? HabitSchedule.daily(),
    sortOrder: sortOrder,
    archived: archived,
    createdAt: 1,
    updatedAt: 1,
    deletedAt: deletedAt,
    deviceId: 'device-a',
  );
}

int _day(int year, int month, int day, [int hour = 0]) {
  return DateTime(year, month, day, hour).millisecondsSinceEpoch;
}
