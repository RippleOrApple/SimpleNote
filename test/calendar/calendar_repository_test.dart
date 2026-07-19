import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_note/database/app_database.dart';
import 'package:simple_note/features/calendar/data/calendar_repository.dart';
import 'package:simple_note/features/calendar/domain/calendar_entry.dart';
import 'package:simple_note/features/habits/data/habits_repository.dart';
import 'package:simple_note/features/habits/domain/habit.dart';
import 'package:simple_note/features/habits/domain/habit_schedule.dart';
import 'package:simple_note/features/notes/data/notes_repository.dart';
import 'package:simple_note/features/notes/domain/note.dart';
import 'package:simple_note/features/tasks/data/tasks_repository.dart';
import 'package:simple_note/features/tasks/domain/task.dart';

void main() {
  late AppDatabase database;
  late DriftCalendarRepository calendar;
  late DriftTasksRepository tasks;
  late DriftNotesRepository notes;
  late DriftHabitsRepository habits;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    calendar = DriftCalendarRepository(database);
    tasks = DriftTasksRepository(database);
    notes = DriftNotesRepository(database);
    habits = DriftHabitsRepository(database);
  });

  tearDown(() => database.close());

  test('aggregates task markers and note creation dates by local day',
      () async {
    await tasks.upsertTask(_task(
      'plan',
      title: 'Plan release',
      startAt: _millis(2026, 7, 18, 9),
      dueAt: _millis(2026, 7, 19, 17),
    ));
    await tasks.upsertTask(_task(
      'done',
      title: 'Done task',
      completed: true,
      dueAt: _millis(2026, 7, 18, 12),
    ));
    await tasks.upsertTask(_task(
      'child-parent',
      dueAt: _millis(2026, 7, 18, 15),
    ));
    await tasks.upsertTask(_task(
      'child',
      parentId: 'child-parent',
      dueAt: _millis(2026, 7, 18, 16),
    ));
    await tasks.upsertTask(_task(
      'deleted-task',
      dueAt: _millis(2026, 7, 18, 18),
      deletedAt: _millis(2026, 7, 18, 19),
    ));
    await notes.upsert(_note(
      'note',
      title: 'Created note',
      createdAt: _millis(2026, 7, 19, 10),
    ));
    await notes.upsert(_note(
      'deleted-note',
      createdAt: _millis(2026, 7, 19, 11),
      deletedAt: _millis(2026, 7, 19, 12),
    ));

    final days = await calendar.queryDays(
      from: _millis(2026, 7, 18),
      before: _millis(2026, 7, 21),
    );

    expect(days.map((day) => day.dayStart), [
      _millis(2026, 7, 18),
      _millis(2026, 7, 19),
    ]);
    expect(days.first.taskCount, 3);
    expect(days.first.noteCount, 0);
    expect(days.first.entries.map((entry) => entry.id), [
      'task:plan:taskStart:${_millis(2026, 7, 18, 9)}',
      'task:done:taskDue:${_millis(2026, 7, 18, 12)}',
      'task:child-parent:taskDue:${_millis(2026, 7, 18, 15)}',
    ]);
    expect(days.first.entries[1].completed, isTrue);
    expect(days.last.taskCount, 1);
    expect(days.last.noteCount, 1);
    expect(days.last.entries.map((entry) => entry.kind), [
      CalendarEntryKind.noteCreated,
      CalendarEntryKind.taskDue,
    ]);
  });

  test('expands recurring tasks and caps them by end date and count', () async {
    await tasks.upsertTask(_task(
      'daily-end',
      dueAt: _millis(2026, 7, 18, 8),
      recurrenceRule: 'FREQ=DAILY',
      recurrenceEndAt: _millis(2026, 7, 20, 23),
    ));
    await tasks.upsertTask(_task(
      'daily-count',
      dueAt: _millis(2026, 7, 18, 9),
      recurrenceRule: 'FREQ=DAILY',
      recurrenceCount: 2,
    ));
    await tasks.upsertTask(_task(
      'invalid',
      dueAt: _millis(2026, 7, 18, 10),
      recurrenceRule: 'FREQ=NOPE',
    ));

    final entries = await calendar.queryEntries(
      from: _millis(2026, 7, 18),
      before: _millis(2026, 7, 23),
    );

    expect(
      entries
          .where((entry) => entry.sourceId == 'daily-end')
          .map((entry) => entry.scheduledAt),
      [
        _millis(2026, 7, 18, 8),
        _millis(2026, 7, 19, 8),
        _millis(2026, 7, 20, 8),
      ],
    );
    expect(
      entries
          .where((entry) => entry.sourceId == 'daily-count')
          .map((entry) => entry.scheduledAt),
      [
        _millis(2026, 7, 18, 9),
        _millis(2026, 7, 19, 9),
      ],
    );
    expect(
      entries
          .where((entry) => entry.sourceId == 'invalid')
          .map((entry) => entry.scheduledAt),
      [_millis(2026, 7, 18, 10)],
    );
  });

  test('adds scheduled habit entries with checkin completion state', () async {
    await habits.upsertHabit(_habit(
      'daily',
      name: 'Drink water',
      color: 0x2F80ED,
      schedule: HabitSchedule.daily(),
    ));
    await habits.upsertHabit(_habit(
      'weekly',
      name: 'Sunday review',
      color: 0x27AE60,
      schedule: HabitSchedule.weekly({DateTime.sunday}),
    ));
    await habits.upsertHabit(_habit(
      'archived',
      archived: true,
      schedule: HabitSchedule.daily(),
    ));
    await habits.softDeleteHabit('deleted', _millis(2026, 7, 18, 8));
    await habits.upsertHabit(_habit(
      'deleted',
      deletedAt: _millis(2026, 7, 18, 8),
      schedule: HabitSchedule.daily(),
    ));
    await habits.checkInHabit(
      id: 'checkin-daily',
      habitId: 'daily',
      checkinDay: _millis(2026, 7, 19),
      now: _millis(2026, 7, 19, 9),
      deviceId: 'device',
    );

    final days = await calendar.queryDays(
      from: _millis(2026, 7, 18),
      before: _millis(2026, 7, 21),
    );
    final habitEntries = [
      for (final day in days)
        ...day.entries.where(
          (entry) => entry.source == CalendarEntrySource.habit,
        ),
    ];

    expect(habitEntries.map((entry) => entry.id), [
      'habit:daily:habitPlanned:${_millis(2026, 7, 18)}',
      'habit:daily:habitPlanned:${_millis(2026, 7, 19)}',
      'habit:weekly:habitPlanned:${_millis(2026, 7, 19)}',
      'habit:daily:habitPlanned:${_millis(2026, 7, 20)}',
    ]);
    expect(days[1].habitCount, 2);
    expect(
      habitEntries
          .singleWhere((entry) => entry.sourceId == 'daily' && entry.completed)
          .color,
      0x2F80ED,
    );
    expect(
      habitEntries.where((entry) => entry.sourceId == 'archived'),
      isEmpty,
    );
    expect(
      habitEntries.where((entry) => entry.sourceId == 'deleted'),
      isEmpty,
    );
  });
}

Task _task(
  String id, {
  String? parentId,
  String? title,
  bool completed = false,
  int? startAt,
  int? dueAt,
  int? deletedAt,
  String? recurrenceRule,
  int? recurrenceEndAt,
  int? recurrenceCount,
}) {
  return Task(
    id: id,
    parentId: parentId,
    title: title ?? id,
    completed: completed,
    completedAt: completed ? 2 : null,
    startAt: startAt,
    dueAt: dueAt,
    deletedAt: deletedAt,
    recurrenceRule: recurrenceRule,
    recurrenceEndAt: recurrenceEndAt,
    recurrenceCount: recurrenceCount,
    createdAt: 1,
    updatedAt: 1,
    deviceId: 'device',
  );
}

Note _note(
  String id, {
  String? title,
  required int createdAt,
  int? deletedAt,
}) {
  return Note(
    id: id,
    title: title ?? id,
    content: '',
    createdAt: createdAt,
    updatedAt: createdAt,
    deletedAt: deletedAt,
    deviceId: 'device',
  );
}

Habit _habit(
  String id, {
  String? name,
  int color = 0xFF0000,
  bool archived = false,
  int? deletedAt,
  required HabitSchedule schedule,
}) {
  return Habit(
    id: id,
    name: name ?? id,
    iconKey: 'sparkle',
    color: color,
    schedule: schedule,
    archived: archived,
    createdAt: 1,
    updatedAt: 1,
    deletedAt: deletedAt,
    deviceId: 'device',
  );
}

int _millis(int year, int month, int day, [int hour = 0]) {
  return DateTime(year, month, day, hour).millisecondsSinceEpoch;
}
