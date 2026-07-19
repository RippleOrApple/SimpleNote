import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../database/app_database.dart';
import '../../habits/domain/habit_schedule.dart';
import '../../tasks/domain/task_recurrence.dart';
import '../domain/calendar_entry.dart';

final calendarRepositoryProvider = Provider<CalendarRepository>((ref) {
  return DriftCalendarRepository(ref.watch(appDatabaseProvider));
});

abstract class CalendarRepository {
  Future<List<CalendarEntry>> queryEntries({
    required int from,
    required int before,
  });

  Future<List<CalendarDay>> queryDays({
    required int from,
    required int before,
  });
}

class DriftCalendarRepository implements CalendarRepository {
  const DriftCalendarRepository(this._database);

  final AppDatabase _database;

  @override
  Future<List<CalendarEntry>> queryEntries({
    required int from,
    required int before,
  }) async {
    if (before <= from) return const [];
    final taskRows = await (_database.select(_database.tasksV2)
          ..where(
            (task) =>
                task.deletedAt.isNull() &
                task.parentId.isNull() &
                (task.startAt.isNotNull() | task.dueAt.isNotNull()),
          ))
        .get();
    final noteRows = await (_database.select(_database.notes)
          ..where(
            (note) =>
                note.deletedAt.isNull() &
                note.createdAt.isBiggerOrEqualValue(from) &
                note.createdAt.isSmallerThanValue(before),
          ))
        .get();
    final completionCounts = await _completionCountsFor(taskRows);
    final entries = <CalendarEntry>[];
    for (final task in taskRows) {
      _addTaskEntries(
        entries,
        task,
        from: from,
        before: before,
        activeCompletionCount: completionCounts[task.id] ?? 0,
      );
    }
    for (final note in noteRows) {
      entries.add(CalendarEntry(
        id: 'note:${note.id}:noteCreated:${note.createdAt}',
        sourceId: note.id,
        source: CalendarEntrySource.note,
        kind: CalendarEntryKind.noteCreated,
        title: note.title.trim().isEmpty ? 'Untitled note' : note.title,
        scheduledAt: note.createdAt,
        dayStart: _dayStart(note.createdAt),
      ));
    }
    entries.addAll(await _habitEntries(from: from, before: before));
    entries.sort(_entryComparator);
    return entries;
  }

  @override
  Future<List<CalendarDay>> queryDays({
    required int from,
    required int before,
  }) async {
    final entries = await queryEntries(from: from, before: before);
    final grouped = <int, List<CalendarEntry>>{};
    for (final entry in entries) {
      grouped.putIfAbsent(entry.dayStart, () => []).add(entry);
    }
    return [
      for (final dayStart in grouped.keys.toList()..sort())
        CalendarDay(
          dayStart: dayStart,
          entries: grouped[dayStart]!,
        ),
    ];
  }

  Future<Map<String, int>> _completionCountsFor(List<TaskV2Row> tasks) async {
    final recurringIds = tasks
        .where((task) => task.recurrenceRule?.trim().isNotEmpty ?? false)
        .map((task) => task.id)
        .toSet();
    if (recurringIds.isEmpty) return const {};
    final rows = await (_database.select(_database.taskCompletions)
          ..where(
            (completion) =>
                completion.deletedAt.isNull() &
                completion.taskId.isIn(recurringIds),
          ))
        .get();
    final counts = <String, int>{};
    for (final row in rows) {
      counts[row.taskId] = (counts[row.taskId] ?? 0) + 1;
    }
    return counts;
  }

  void _addTaskEntries(
    List<CalendarEntry> entries,
    TaskV2Row task, {
    required int from,
    required int before,
    required int activeCompletionCount,
  }) {
    final recurrenceRule = task.recurrenceRule;
    if (task.completed ||
        recurrenceRule == null ||
        recurrenceRule.trim().isEmpty) {
      _addTaskOccurrence(entries, task, delta: 0, from: from, before: before);
      return;
    }

    final anchor = task.dueAt ?? task.startAt;
    if (anchor == null) return;
    final remainingOccurrences = task.recurrenceCount == null
        ? null
        : task.recurrenceCount! - activeCompletionCount;
    if (remainingOccurrences != null && remainingOccurrences <= 0) return;

    late final TaskRecurrenceRule parsedRule;
    try {
      parsedRule = TaskRecurrenceRule.parse(recurrenceRule);
    } on FormatException {
      _addTaskOccurrence(entries, task, delta: 0, from: from, before: before);
      return;
    }

    var occurrenceAnchor = anchor;
    var emitted = 0;
    var guard = 0;
    while (occurrenceAnchor < before && guard < 4096) {
      guard++;
      if (task.recurrenceEndAt != null &&
          occurrenceAnchor > task.recurrenceEndAt!) {
        break;
      }
      if (remainingOccurrences != null && emitted >= remainingOccurrences) {
        break;
      }
      _addTaskOccurrence(
        entries,
        task,
        delta: occurrenceAnchor - anchor,
        from: from,
        before: before,
      );
      emitted++;
      final next = parsedRule.nextScheduledAt(occurrenceAnchor);
      if (next <= occurrenceAnchor) break;
      occurrenceAnchor = next;
    }
  }

  void _addTaskOccurrence(
    List<CalendarEntry> entries,
    TaskV2Row task, {
    required int delta,
    required int from,
    required int before,
  }) {
    final startAt = task.startAt == null ? null : task.startAt! + delta;
    final dueAt = task.dueAt == null ? null : task.dueAt! + delta;
    if (startAt != null && _inRange(startAt, from, before)) {
      entries.add(_taskEntry(
        task,
        kind: CalendarEntryKind.taskStart,
        scheduledAt: startAt,
      ));
    }
    if (dueAt != null && _inRange(dueAt, from, before)) {
      entries.add(_taskEntry(
        task,
        kind: CalendarEntryKind.taskDue,
        scheduledAt: dueAt,
      ));
    }
  }

  CalendarEntry _taskEntry(
    TaskV2Row task, {
    required CalendarEntryKind kind,
    required int scheduledAt,
  }) {
    return CalendarEntry(
      id: 'task:${task.id}:${kind.name}:$scheduledAt',
      sourceId: task.id,
      source: CalendarEntrySource.task,
      kind: kind,
      title: task.title,
      scheduledAt: scheduledAt,
      dayStart: _dayStart(scheduledAt),
      allDay: task.allDay,
      completed: task.completed,
    );
  }

  Future<List<CalendarEntry>> _habitEntries({
    required int from,
    required int before,
  }) async {
    final habitRows = await (_database.select(_database.habits)
          ..where(
            (habit) => habit.deletedAt.isNull() & habit.archived.equals(false),
          ))
        .get();
    if (habitRows.isEmpty) return const [];

    final checkinRows = await (_database.select(_database.habitCheckins)
          ..where(
            (checkin) =>
                checkin.deletedAt.isNull() &
                checkin.checkinDay.isBiggerOrEqualValue(_dayStart(from)) &
                checkin.checkinDay.isSmallerThanValue(before),
          ))
        .get();
    final completedDaysByHabit = <String, Set<int>>{};
    for (final checkin in checkinRows) {
      completedDaysByHabit
          .putIfAbsent(checkin.habitId, () => <int>{})
          .add(checkin.checkinDay);
    }

    final entries = <CalendarEntry>[];
    var day = _dayStart(from);
    while (day < before) {
      for (final habit in habitRows) {
        final schedule = HabitSchedule.fromJson(
          habit.scheduleType,
          (jsonDecode(habit.scheduleJson) as Map).cast<String, Object?>(),
        );
        if (!_isHabitScheduledOn(schedule, day)) continue;
        entries.add(CalendarEntry(
          id: 'habit:${habit.id}:habitPlanned:$day',
          sourceId: habit.id,
          source: CalendarEntrySource.habit,
          kind: CalendarEntryKind.habitPlanned,
          title: habit.name,
          scheduledAt: day,
          dayStart: day,
          allDay: true,
          completed: completedDaysByHabit[habit.id]?.contains(day) ?? false,
          color: habit.color,
        ));
      }
      day += _dayMillis;
    }
    return entries;
  }
}

bool _inRange(int value, int from, int before) {
  return value >= from && value < before;
}

int _entryComparator(CalendarEntry left, CalendarEntry right) {
  final day = left.dayStart.compareTo(right.dayStart);
  if (day != 0) return day;
  final time = left.scheduledAt.compareTo(right.scheduledAt);
  if (time != 0) return time;
  final source = left.source.index.compareTo(right.source.index);
  if (source != 0) return source;
  final kind = left.kind.index.compareTo(right.kind.index);
  if (kind != 0) return kind;
  return left.title.compareTo(right.title);
}

int _dayStart(int value) {
  final date = DateTime.fromMillisecondsSinceEpoch(value);
  return DateTime(date.year, date.month, date.day).millisecondsSinceEpoch;
}

bool _isHabitScheduledOn(HabitSchedule schedule, int dayStart) {
  final weekday = DateTime.fromMillisecondsSinceEpoch(dayStart).weekday;
  return switch (schedule.type) {
    HabitScheduleType.daily => true,
    HabitScheduleType.weekdays =>
      weekday >= DateTime.monday && weekday <= DateTime.friday,
    HabitScheduleType.weekly => schedule.weekdays.contains(weekday),
    HabitScheduleType.interval => _matchesHabitInterval(schedule, dayStart),
  };
}

bool _matchesHabitInterval(HabitSchedule schedule, int dayStart) {
  final everyDays = schedule.everyDays;
  final anchorDay = schedule.anchorDay;
  if (everyDays == null || anchorDay == null || dayStart < anchorDay) {
    return false;
  }
  final deltaDays = (dayStart - _dayStart(anchorDay)) ~/ _dayMillis;
  return deltaDays % everyDays == 0;
}

const _dayMillis = 24 * 60 * 60 * 1000;
