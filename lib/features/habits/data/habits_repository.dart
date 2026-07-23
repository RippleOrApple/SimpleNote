import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../database/app_database.dart';
import '../domain/habit.dart';
import '../domain/habit_checkin.dart';
import '../domain/habit_schedule.dart';
import '../domain/habit_statistics.dart';

final habitsRepositoryProvider = Provider<HabitsRepository>(
  (ref) => DriftHabitsRepository(ref.watch(appDatabaseProvider)),
);

abstract class HabitsRepository {
  Future<Habit?> findHabit(String id);
  Future<List<Habit>> listHabits({bool includeArchived = false});
  Future<List<Habit>> listHabitsForDay(int dayStart);
  Future<void> upsertHabit(Habit habit);
  Future<void> archiveHabit(
    String id, {
    required bool archived,
    required int updatedAt,
  });
  Future<void> softDeleteHabit(String id, int deletedAt);
  Future<HabitCheckin> checkInHabit({
    required String id,
    required String habitId,
    required int checkinDay,
    required int now,
    required String deviceId,
    String note = '',
  });
  Future<void> cancelCheckin({
    required String habitId,
    required int checkinDay,
    required int deletedAt,
  });
  Future<List<HabitCheckin>> listCheckins(
    String habitId, {
    bool includeDeleted = false,
  });
  Future<HabitStatistics> habitStatistics(
    String habitId, {
    required int from,
    required int before,
    required int asOfDay,
  });
}

class DriftHabitsRepository implements HabitsRepository {
  const DriftHabitsRepository(this._database);

  final AppDatabase _database;

  @override
  Future<Habit?> findHabit(String id) async {
    final row = await (_database.select(_database.habits)
          ..where((habit) => habit.id.equals(id) & habit.deletedAt.isNull()))
        .getSingleOrNull();
    return row == null ? null : _fromHabitRow(row);
  }

  @override
  Future<List<Habit>> listHabits({bool includeArchived = false}) async {
    final rows = await (_database.select(_database.habits)
          ..where((habit) {
            var expression = habit.deletedAt.isNull();
            if (!includeArchived) {
              expression = expression & habit.archived.equals(false);
            }
            return expression;
          })
          ..orderBy([
            (habit) => OrderingTerm.asc(habit.sortOrder),
            (habit) => OrderingTerm.asc(habit.createdAt),
          ]))
        .get();
    return rows.map(_fromHabitRow).toList();
  }

  @override
  Future<List<Habit>> listHabitsForDay(int dayStart) async {
    final active = await listHabits();
    return active
        .where((habit) => _isScheduledOn(habit.schedule, dayStart))
        .toList();
  }

  @override
  Future<void> upsertHabit(Habit habit) {
    return _database.into(_database.habits).insertOnConflictUpdate(
          _toHabitCompanion(habit),
        );
  }

  @override
  Future<void> archiveHabit(
    String id, {
    required bool archived,
    required int updatedAt,
  }) async {
    final row = await (_database.select(_database.habits)
          ..where((habit) => habit.id.equals(id) & habit.deletedAt.isNull()))
        .getSingleOrNull();
    if (row == null) return;
    await (_database.update(_database.habits)
          ..where((habit) => habit.id.equals(id)))
        .write(HabitsCompanion(
      archived: Value(archived),
      updatedAt: Value(updatedAt),
      version: Value(row.version + 1),
    ));
  }

  @override
  Future<void> softDeleteHabit(String id, int deletedAt) async {
    final row = await (_database.select(_database.habits)
          ..where((habit) => habit.id.equals(id) & habit.deletedAt.isNull()))
        .getSingleOrNull();
    if (row == null) return;
    await (_database.update(_database.habits)
          ..where((habit) => habit.id.equals(id)))
        .write(HabitsCompanion(
      deletedAt: Value(deletedAt),
      updatedAt: Value(deletedAt),
      version: Value(row.version + 1),
    ));
  }

  @override
  Future<HabitCheckin> checkInHabit({
    required String id,
    required String habitId,
    required int checkinDay,
    required int now,
    required String deviceId,
    String note = '',
  }) async {
    final habit = await findHabit(habitId);
    if (habit == null) {
      throw StateError('无法为不存在或已删除的习惯打卡。');
    }
    final existing = await _activeCheckin(habitId, checkinDay);
    if (existing != null) return _fromCheckinRow(existing);
    final companion = HabitCheckinsCompanion.insert(
      id: id,
      habitId: habitId,
      checkinDay: checkinDay,
      status: HabitCheckinStatus.done.name,
      note: Value(note),
      createdAt: now,
      updatedAt: now,
      deviceId: deviceId,
    );
    await _database.into(_database.habitCheckins).insert(companion);
    final inserted = await _activeCheckin(habitId, checkinDay);
    if (inserted == null) {
      throw StateError('习惯打卡未能保存。');
    }
    return _fromCheckinRow(inserted);
  }

  @override
  Future<void> cancelCheckin({
    required String habitId,
    required int checkinDay,
    required int deletedAt,
  }) async {
    final row = await _activeCheckin(habitId, checkinDay);
    if (row == null) return;
    await (_database.update(_database.habitCheckins)
          ..where((checkin) => checkin.id.equals(row.id)))
        .write(HabitCheckinsCompanion(
      deletedAt: Value(deletedAt),
      updatedAt: Value(deletedAt),
      version: Value(row.version + 1),
    ));
  }

  @override
  Future<List<HabitCheckin>> listCheckins(
    String habitId, {
    bool includeDeleted = false,
  }) async {
    final rows = await (_database.select(_database.habitCheckins)
          ..where((checkin) {
            var expression = checkin.habitId.equals(habitId);
            if (!includeDeleted) {
              expression = expression & checkin.deletedAt.isNull();
            }
            return expression;
          })
          ..orderBy([
            (checkin) => OrderingTerm.asc(checkin.checkinDay),
            (checkin) => OrderingTerm.asc(checkin.createdAt),
          ]))
        .get();
    return rows.map(_fromCheckinRow).toList();
  }

  @override
  Future<HabitStatistics> habitStatistics(
    String habitId, {
    required int from,
    required int before,
    required int asOfDay,
  }) async {
    if (before <= from) {
      return HabitStatistics(
        habitId: habitId,
        from: from,
        before: before,
        asOfDay: asOfDay,
        plannedDays: 0,
        completedDays: 0,
        currentStreak: 0,
        longestStreak: 0,
      );
    }
    final habit = await findHabit(habitId);
    if (habit == null) {
      throw StateError('无法为不存在的习惯计算统计。');
    }
    final checkins = await listCheckins(habitId);
    final completedDays = checkins.map((checkin) => checkin.checkinDay).toSet();
    final plannedDays = _plannedDays(
      habit.schedule,
      from: from,
      before: before,
    );

    var completedPlannedDays = 0;
    var longestStreak = 0;
    var runningStreak = 0;
    for (final day in plannedDays) {
      if (completedDays.contains(day)) {
        completedPlannedDays++;
        runningStreak++;
        if (runningStreak > longestStreak) {
          longestStreak = runningStreak;
        }
      } else {
        runningStreak = 0;
      }
    }

    var currentStreak = 0;
    for (final day in plannedDays.reversed) {
      if (day > asOfDay) continue;
      if (!completedDays.contains(day)) break;
      currentStreak++;
    }

    return HabitStatistics(
      habitId: habitId,
      from: from,
      before: before,
      asOfDay: asOfDay,
      plannedDays: plannedDays.length,
      completedDays: completedPlannedDays,
      currentStreak: currentStreak,
      longestStreak: longestStreak,
    );
  }

  Future<HabitCheckinRow?> _activeCheckin(
    String habitId,
    int checkinDay,
  ) {
    return (_database.select(_database.habitCheckins)
          ..where(
            (checkin) =>
                checkin.habitId.equals(habitId) &
                checkin.checkinDay.equals(checkinDay) &
                checkin.deletedAt.isNull(),
          ))
        .getSingleOrNull();
  }

  static HabitsCompanion _toHabitCompanion(Habit habit) => HabitsCompanion(
        id: Value(habit.id),
        name: Value(habit.name),
        prompt: Value(habit.prompt),
        iconKey: Value(habit.iconKey),
        color: Value(habit.color),
        scheduleType: Value(habit.scheduleType),
        scheduleJson: Value(habit.scheduleJson),
        sortOrder: Value(habit.sortOrder),
        archived: Value(habit.archived),
        createdAt: Value(habit.createdAt),
        updatedAt: Value(habit.updatedAt),
        deletedAt: Value(habit.deletedAt),
        deviceId: Value(habit.deviceId),
        version: Value(habit.version),
      );

  static Habit _fromHabitRow(HabitRow row) {
    return Habit(
      id: row.id,
      name: row.name,
      prompt: row.prompt,
      iconKey: row.iconKey,
      color: row.color,
      schedule: HabitSchedule.fromJson(
        row.scheduleType,
        (jsonDecode(row.scheduleJson) as Map).cast<String, Object?>(),
      ),
      sortOrder: row.sortOrder,
      archived: row.archived,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      deletedAt: row.deletedAt,
      deviceId: row.deviceId,
      version: row.version,
    );
  }

  static HabitCheckin _fromCheckinRow(HabitCheckinRow row) => HabitCheckin(
        id: row.id,
        habitId: row.habitId,
        checkinDay: row.checkinDay,
        status: HabitCheckinStatus.values.byName(row.status),
        note: row.note,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
        deletedAt: row.deletedAt,
        deviceId: row.deviceId,
        version: row.version,
      );
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

int _dayStart(int value) {
  final date = DateTime.fromMillisecondsSinceEpoch(value);
  return DateTime(date.year, date.month, date.day).millisecondsSinceEpoch;
}

const _dayMillis = 24 * 60 * 60 * 1000;
