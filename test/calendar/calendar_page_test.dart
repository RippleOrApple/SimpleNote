import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_note/database/app_database.dart';
import 'package:simple_note/features/calendar/data/calendar_repository.dart';
import 'package:simple_note/features/calendar/domain/calendar_entry.dart';
import 'package:simple_note/features/habits/application/habits_controller.dart';
import 'package:simple_note/features/habits/data/habits_repository.dart';
import 'package:simple_note/features/habits/domain/habit.dart';
import 'package:simple_note/features/habits/domain/habit_schedule.dart';
import 'package:simple_note/features/navigation/application/navigation_controller.dart';
import 'package:simple_note/features/navigation/domain/app_module.dart';
import 'package:simple_note/features/navigation/presentation/adaptive_app_shell.dart';
import 'package:simple_note/features/notes/application/notes_controller.dart';
import 'package:simple_note/features/notes/data/notes_repository.dart';
import 'package:simple_note/features/notes/domain/note.dart';
import 'package:simple_note/features/sync/data/sync_repository.dart';
import 'package:simple_note/features/sync/domain/device_info.dart';
import 'package:simple_note/features/tasks/application/tasks_controller.dart';
import 'package:simple_note/features/tasks/data/tasks_repository.dart';
import 'package:simple_note/features/tasks/domain/task.dart';

void main() {
  testWidgets('calendar module shows entries instead of the placeholder',
      (tester) async {
    final dayStart = _todayStart();
    final harness = await _pumpCalendarShell(
      tester,
      repository: _FakeCalendarRepository([
        _day(dayStart, [
          _taskEntry('task-a', 'Write report', dayStart + _hour(9)),
          _noteEntry('note-a', 'Research note', dayStart + _hour(11)),
          _habitEntry('habit-a', 'Drink water', dayStart, completed: true),
        ]),
      ]),
      seed: (database) async {
        await DriftTasksRepository(database).upsertTask(_task(
          'task-a',
          'Write report',
          dueAt: dayStart + _hour(9),
        ));
        await DriftNotesRepository(database).upsert(_note(
          'note-a',
          'Research note',
          createdAt: dayStart + _hour(11),
        ));
        await DriftHabitsRepository(database).upsertHabit(_habit(
          'habit-a',
          'Drink water',
          schedule: HabitSchedule.daily(),
        ));
      },
    );
    addTearDown(harness.dispose);

    expect(find.byKey(const Key('calendar-page')), findsOneWidget);
    expect(find.textContaining('planned for a later phase'), findsNothing);
    expect(find.text('Write report'), findsOneWidget);
    expect(find.text('Research note'), findsOneWidget);
    expect(find.text('Drink water'), findsOneWidget);
    expect(find.textContaining('1 habits'), findsOneWidget);
    expect(find.byKey(Key('calendar-day-$dayStart')), findsOneWidget);
  });

  testWidgets('tapping a task entry switches to tasks and selects the task',
      (tester) async {
    final dayStart = _todayStart();
    final harness = await _pumpCalendarShell(
      tester,
      repository: _FakeCalendarRepository([
        _day(dayStart, [
          _taskEntry('task-a', 'Write report', dayStart + _hour(9)),
        ]),
      ]),
      seed: (database) async {
        await DriftTasksRepository(database).upsertTask(_task(
          'task-a',
          'Write report',
          dueAt: dayStart + _hour(9),
        ));
      },
    );
    addTearDown(harness.dispose);

    await tester.tap(find.byKey(const Key('calendar-entry-task-a')));
    await tester.pumpAndSettle();

    final container = harness.container;
    expect(
      container.read(navigationControllerProvider).selectedModule,
      AppModuleKey.today,
    );
    expect(
      (await container.read(tasksControllerProvider.future)).selectedTaskId,
      'task-a',
    );
  });

  testWidgets('tapping a note entry switches to notes and selects the note',
      (tester) async {
    final dayStart = _todayStart();
    final harness = await _pumpCalendarShell(
      tester,
      repository: _FakeCalendarRepository([
        _day(dayStart, [
          _noteEntry('note-a', 'Research note', dayStart + _hour(11)),
        ]),
      ]),
      seed: (database) async {
        await DriftNotesRepository(database).upsert(_note(
          'note-a',
          'Research note',
          createdAt: dayStart + _hour(11),
        ));
      },
    );
    addTearDown(harness.dispose);

    await tester.tap(find.byKey(const Key('calendar-entry-note-a')));
    await tester.pumpAndSettle();

    final container = harness.container;
    expect(
      container.read(navigationControllerProvider).selectedModule,
      AppModuleKey.notes,
    );
    expect(
      (await container.read(notesControllerProvider.future)).selectedNoteId,
      'note-a',
    );
  });

  testWidgets('tapping a habit entry switches to habits and selects the habit',
      (tester) async {
    final dayStart = _todayStart();
    final harness = await _pumpCalendarShell(
      tester,
      repository: _FakeCalendarRepository([
        _day(dayStart, [
          _habitEntry('habit-a', 'Drink water', dayStart),
        ]),
      ]),
      seed: (database) async {
        await DriftHabitsRepository(database).upsertHabit(_habit(
          'habit-a',
          'Drink water',
          schedule: HabitSchedule.daily(),
        ));
      },
    );
    addTearDown(harness.dispose);

    await tester.tap(find.byKey(const Key('calendar-entry-habit-a')));
    await tester.pumpAndSettle();

    final container = harness.container;
    expect(
      container.read(navigationControllerProvider).selectedModule,
      AppModuleKey.habits,
    );
    expect(
      (await container.read(habitsControllerProvider.future)).selectedHabitId,
      'habit-a',
    );
  });
}

Future<_Harness> _pumpCalendarShell(
  WidgetTester tester, {
  required CalendarRepository repository,
  required Future<void> Function(AppDatabase database) seed,
}) async {
  await tester.binding.setSurfaceSize(const Size(1280, 800));
  final database = AppDatabase(NativeDatabase.memory());
  await seed(database);
  late ProviderContainer container;
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(database),
        calendarRepositoryProvider.overrideWithValue(repository),
        deviceInfoProvider.overrideWithValue(_windowsDevice),
      ],
      child: Builder(
        builder: (context) {
          container = ProviderScope.containerOf(context);
          return const MaterialApp(
            home: AdaptiveAppShell(initialModule: AppModuleKey.calendar),
          );
        },
      ),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 200));
  await tester.pumpAndSettle();
  return _Harness(database, container, tester);
}

final class _Harness {
  const _Harness(this.database, this.container, this.tester);

  final AppDatabase database;
  final ProviderContainer container;
  final WidgetTester tester;

  Future<void> dispose() async {
    await tester.pumpWidget(const SizedBox.shrink());
    await database.close();
    await tester.binding.setSurfaceSize(null);
  }
}

class _FakeCalendarRepository implements CalendarRepository {
  const _FakeCalendarRepository(this.days);

  final List<CalendarDay> days;

  @override
  Future<List<CalendarEntry>> queryEntries({
    required int from,
    required int before,
  }) async {
    return [
      for (final day in days) ...day.entries,
    ];
  }

  @override
  Future<List<CalendarDay>> queryDays({
    required int from,
    required int before,
  }) async {
    return days;
  }
}

CalendarDay _day(int dayStart, List<CalendarEntry> entries) {
  return CalendarDay(dayStart: dayStart, entries: entries);
}

CalendarEntry _taskEntry(String id, String title, int scheduledAt) {
  return CalendarEntry(
    id: 'task:$id:taskDue:$scheduledAt',
    sourceId: id,
    source: CalendarEntrySource.task,
    kind: CalendarEntryKind.taskDue,
    title: title,
    scheduledAt: scheduledAt,
    dayStart: _dayStart(scheduledAt),
  );
}

CalendarEntry _noteEntry(String id, String title, int scheduledAt) {
  return CalendarEntry(
    id: 'note:$id:noteCreated:$scheduledAt',
    sourceId: id,
    source: CalendarEntrySource.note,
    kind: CalendarEntryKind.noteCreated,
    title: title,
    scheduledAt: scheduledAt,
    dayStart: _dayStart(scheduledAt),
  );
}

CalendarEntry _habitEntry(
  String id,
  String title,
  int scheduledAt, {
  bool completed = false,
}) {
  return CalendarEntry(
    id: 'habit:$id:habitPlanned:$scheduledAt',
    sourceId: id,
    source: CalendarEntrySource.habit,
    kind: CalendarEntryKind.habitPlanned,
    title: title,
    scheduledAt: scheduledAt,
    dayStart: _dayStart(scheduledAt),
    allDay: true,
    completed: completed,
    color: 0x2F80ED,
  );
}

Task _task(String id, String title, {int? dueAt}) {
  return Task(
    id: id,
    title: title,
    dueAt: dueAt,
    createdAt: 1,
    updatedAt: 1,
    deviceId: 'device',
  );
}

Note _note(String id, String title, {required int createdAt}) {
  return Note(
    id: id,
    title: title,
    content: '',
    createdAt: createdAt,
    updatedAt: createdAt,
    deviceId: 'device',
  );
}

Habit _habit(
  String id,
  String name, {
  required HabitSchedule schedule,
}) {
  return Habit(
    id: id,
    name: name,
    iconKey: 'sparkle',
    color: 0x2F80ED,
    schedule: schedule,
    createdAt: 1,
    updatedAt: 1,
    deviceId: 'device',
  );
}

int _todayStart() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
}

int _dayStart(int value) {
  final date = DateTime.fromMillisecondsSinceEpoch(value);
  return DateTime(date.year, date.month, date.day).millisecondsSinceEpoch;
}

int _hour(int value) => Duration(hours: value).inMilliseconds;

const _windowsDevice = DeviceInfo(
  deviceId: 'calendar-page-test',
  deviceName: 'Windows',
  platform: 'windows',
  appVersion: '1.0.0',
);
