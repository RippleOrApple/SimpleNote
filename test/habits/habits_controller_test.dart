import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_note/database/app_database.dart';
import 'package:simple_note/features/habits/application/habits_controller.dart';
import 'package:simple_note/features/habits/data/habits_repository.dart';
import 'package:simple_note/features/habits/domain/habit.dart';
import 'package:simple_note/features/habits/domain/habit_schedule.dart';
import 'package:simple_note/features/sync/data/sync_repository.dart';
import 'package:simple_note/features/sync/domain/device_info.dart';

void main() {
  test('creates, edits, selects, checks in, cancels, and deletes a habit',
      () async {
    final harness = await _Harness.create();
    addTearDown(harness.dispose);
    final controller = harness.controller;

    await controller.createHabit(
      name: '  Read  ',
      prompt: '10 pages',
      iconKey: 'book',
      color: 0x3366CC,
      schedule: HabitSchedule.daily(),
    );
    var state = await harness.state;
    final habitId = state.selectedHabitId!;

    expect(state.habits.single.name, 'Read');
    expect(state.todayHabits.single.id, habitId);
    expect(state.selectedHabit?.prompt, '10 pages');
    expect(state.selectedStatistics?.plannedDays, greaterThan(0));

    await controller.updateHabit(
      habitId,
      name: 'Read deeply',
      prompt: '20 pages',
      iconKey: 'books',
      color: 0x55AA77,
      schedule: HabitSchedule.weekdays(),
    );
    state = await harness.state;
    expect(state.selectedHabit?.name, 'Read deeply');
    expect(state.selectedHabit?.iconKey, 'books');
    expect(state.saveStatus, HabitSaveStatus.saved);

    await controller.checkInToday(habitId);
    state = await harness.state;
    expect(state.isCheckedInToday(habitId), isTrue);
    expect(state.selectedCheckins, hasLength(1));

    await controller.cancelTodayCheckin(habitId);
    state = await harness.state;
    expect(state.isCheckedInToday(habitId), isFalse);
    expect(state.selectedCheckins, isEmpty);

    await controller.archiveHabit(habitId, archived: true);
    state = await harness.state;
    expect(state.habits, isEmpty);
    expect(state.archivedHabits.single.id, habitId);

    await controller.archiveHabit(habitId, archived: false);
    expect((await harness.state).habits.single.id, habitId);

    await controller.deleteHabit(habitId);
    state = await harness.state;
    expect(state.habits, isEmpty);
    expect(state.selectedHabitId, isNull);
  });

  test('loads existing today plan and supports explicit selection', () async {
    final harness = await _Harness.create();
    addTearDown(harness.dispose);
    final repository = DriftHabitsRepository(harness.database);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;

    await repository.upsertHabit(_habit(
      'daily',
      name: 'Hydrate',
      schedule: HabitSchedule.daily(),
      sortOrder: 2,
    ));
    await repository.upsertHabit(_habit(
      'weekly',
      name: 'Weekly review',
      schedule: HabitSchedule.weekly({DateTime.now().weekday}),
      sortOrder: 1,
    ));
    await repository.checkInHabit(
      id: 'checkin',
      habitId: 'weekly',
      checkinDay: today,
      now: today,
      deviceId: _device.deviceId,
    );

    await harness.controller.reload();
    var state = await harness.state;

    expect(state.todayHabits.map((habit) => habit.id), ['weekly', 'daily']);
    expect(state.isCheckedInToday('weekly'), isTrue);

    harness.controller.selectHabit('weekly');
    await Future<void>.delayed(Duration.zero);
    state = await harness.state;
    expect(state.selectedHabit?.id, 'weekly');
    expect(state.selectedCheckins.single.habitId, 'weekly');
    expect(state.selectedStatistics?.completedDays, greaterThanOrEqualTo(1));
  });
}

class _Harness {
  const _Harness(this.container, this.database);

  final ProviderContainer container;
  final AppDatabase database;

  HabitsController get controller =>
      container.read(habitsControllerProvider.notifier);
  Future<HabitsState> get state =>
      container.read(habitsControllerProvider.future);

  static Future<_Harness> create() async {
    final database = AppDatabase(NativeDatabase.memory());
    final container = ProviderContainer(overrides: [
      appDatabaseProvider.overrideWithValue(database),
      deviceInfoProvider.overrideWithValue(_device),
    ]);
    await container.read(habitsControllerProvider.future);
    return _Harness(container, database);
  }

  Future<void> dispose() async {
    container.dispose();
    await database.close();
  }
}

const _device = DeviceInfo(
  deviceId: 'habits-controller-device',
  deviceName: 'Test device',
  platform: 'windows',
  appVersion: '1.0.0',
);

Habit _habit(
  String id, {
  required String name,
  required HabitSchedule schedule,
  int sortOrder = 0,
}) {
  return Habit(
    id: id,
    name: name,
    iconKey: 'sparkle',
    color: 0x3366CC,
    schedule: schedule,
    sortOrder: sortOrder,
    createdAt: 1,
    updatedAt: 1,
    deviceId: _device.deviceId,
  );
}
