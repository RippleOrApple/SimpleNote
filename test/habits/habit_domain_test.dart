import 'package:flutter_test/flutter_test.dart';
import 'package:simple_note/features/habits/domain/habit.dart';
import 'package:simple_note/features/habits/domain/habit_checkin.dart';
import 'package:simple_note/features/habits/domain/habit_schedule.dart';

void main() {
  test('habit schedule supports daily, weekdays, weekly, and interval json',
      () {
    final schedules = [
      HabitSchedule.daily(),
      HabitSchedule.weekdays(),
      HabitSchedule.weekly({1, 3, 5}),
      HabitSchedule.interval(everyDays: 3, anchorDay: 1000),
    ];

    for (final schedule in schedules) {
      final restored = HabitSchedule.fromJson(
        schedule.type.name,
        schedule.toJson(),
      );
      expect(restored, schedule);
    }
  });

  test('habit schedule rejects invalid weekly days and intervals', () {
    expect(
      () => HabitSchedule.weekly({0}),
      throwsA(isA<FormatException>()),
    );
    expect(
      () => HabitSchedule.weekly({8}),
      throwsA(isA<FormatException>()),
    );
    expect(
      () => HabitSchedule.interval(everyDays: 0, anchorDay: 1000),
      throwsA(isA<FormatException>()),
    );
  });

  test('habit json round-trips schedule and sync metadata', () {
    final habit = Habit(
      id: 'habit',
      name: 'Read',
      prompt: 'Read before sleep',
      iconKey: 'book',
      color: 0x596790,
      schedule: HabitSchedule.weekly({1, 3, 5}),
      sortOrder: 2,
      archived: true,
      createdAt: 10,
      updatedAt: 20,
      deletedAt: 30,
      deviceId: 'device',
      version: 4,
    );

    final restored = Habit.fromJson(habit.toJson());

    expect(restored.toJson(), habit.toJson());
    expect(restored.isDeleted, isTrue);
  });

  test('habit checkin json round-trips status and soft deletion', () {
    const checkin = HabitCheckin(
      id: 'checkin',
      habitId: 'habit',
      checkinDay: 1000,
      status: HabitCheckinStatus.done,
      note: 'Backfilled',
      createdAt: 10,
      updatedAt: 20,
      deletedAt: 30,
      deviceId: 'device',
      version: 2,
    );

    final restored = HabitCheckin.fromJson(checkin.toJson());

    expect(restored.toJson(), checkin.toJson());
    expect(restored.isDeleted, isTrue);
  });
}
