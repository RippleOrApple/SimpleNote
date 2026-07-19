import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/id_generator.dart';
import '../../../core/utils/time.dart';
import '../../sync/data/sync_repository.dart';
import '../data/habits_repository.dart';
import '../domain/habit.dart';
import '../domain/habit_checkin.dart';
import '../domain/habit_schedule.dart';
import '../domain/habit_statistics.dart';

final habitsControllerProvider =
    AsyncNotifierProvider<HabitsController, HabitsState>(
  HabitsController.new,
);

enum HabitSaveStatus { idle, saving, saved, failed }

class HabitsState {
  HabitsState({
    required Iterable<Habit> habits,
    required Iterable<Habit> todayHabits,
    required Iterable<Habit> archivedHabits,
    required Iterable<HabitCheckin> todayCheckins,
    required Iterable<HabitCheckin> selectedCheckins,
    required this.today,
    this.selectedHabitId,
    this.selectedStatistics,
    this.saveStatus = HabitSaveStatus.idle,
    this.errorMessage,
  })  : habits = List.unmodifiable(habits),
        todayHabits = List.unmodifiable(todayHabits),
        archivedHabits = List.unmodifiable(archivedHabits),
        todayCheckins = List.unmodifiable(todayCheckins),
        selectedCheckins = List.unmodifiable(selectedCheckins);

  final List<Habit> habits;
  final List<Habit> todayHabits;
  final List<Habit> archivedHabits;
  final List<HabitCheckin> todayCheckins;
  final List<HabitCheckin> selectedCheckins;
  final int today;
  final String? selectedHabitId;
  final HabitStatistics? selectedStatistics;
  final HabitSaveStatus saveStatus;
  final String? errorMessage;

  Habit? get selectedHabit {
    for (final habit in [...habits, ...archivedHabits]) {
      if (habit.id == selectedHabitId) return habit;
    }
    return null;
  }

  bool isCheckedInToday(String habitId) {
    return todayCheckins.any((checkin) => checkin.habitId == habitId);
  }

  HabitsState copyWith({
    Iterable<Habit>? habits,
    Iterable<Habit>? todayHabits,
    Iterable<Habit>? archivedHabits,
    Iterable<HabitCheckin>? todayCheckins,
    Iterable<HabitCheckin>? selectedCheckins,
    int? today,
    String? selectedHabitId,
    bool clearSelectedHabitId = false,
    HabitStatistics? selectedStatistics,
    bool clearSelectedStatistics = false,
    HabitSaveStatus? saveStatus,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return HabitsState(
      habits: habits ?? this.habits,
      todayHabits: todayHabits ?? this.todayHabits,
      archivedHabits: archivedHabits ?? this.archivedHabits,
      todayCheckins: todayCheckins ?? this.todayCheckins,
      selectedCheckins: selectedCheckins ?? this.selectedCheckins,
      today: today ?? this.today,
      selectedHabitId:
          clearSelectedHabitId ? null : selectedHabitId ?? this.selectedHabitId,
      selectedStatistics: clearSelectedStatistics
          ? null
          : selectedStatistics ?? this.selectedStatistics,
      saveStatus: saveStatus ?? this.saveStatus,
      errorMessage:
          clearErrorMessage ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class HabitsController extends AsyncNotifier<HabitsState> {
  late HabitsRepository _repository;
  late String _deviceId;

  @override
  Future<HabitsState> build() async {
    _repository = ref.watch(habitsRepositoryProvider);
    _deviceId = ref.watch(deviceInfoProvider).deviceId;
    return _load(today: _today());
  }

  Future<void> reload() async {
    final current = state.valueOrNull;
    state = AsyncData(await _load(
      today: _today(),
      selectedHabitId: current?.selectedHabitId,
      saveStatus: current?.saveStatus ?? HabitSaveStatus.idle,
    ));
  }

  Future<void> createHabit({
    required String name,
    required String iconKey,
    required int color,
    required HabitSchedule schedule,
    String prompt = '',
  }) async {
    final normalized = name.trim();
    if (normalized.isEmpty) return;
    final now = Clock.nowMillis();
    final habit = Habit(
      id: IdGenerator.create(),
      name: normalized,
      prompt: prompt.trim(),
      iconKey: iconKey,
      color: color,
      schedule: schedule,
      createdAt: now,
      updatedAt: now,
      deviceId: _deviceId,
    );
    await _write(
      () => _repository.upsertHabit(habit),
      selectedHabitId: habit.id,
    );
  }

  Future<void> updateHabit(
    String id, {
    required String name,
    required String iconKey,
    required int color,
    required HabitSchedule schedule,
    String prompt = '',
  }) async {
    final current = state.valueOrNull;
    final habit = current == null ? null : _findHabit(current, id);
    final normalized = name.trim();
    if (habit == null || normalized.isEmpty) return;
    final updated = Habit(
      id: habit.id,
      name: normalized,
      prompt: prompt.trim(),
      iconKey: iconKey,
      color: color,
      schedule: schedule,
      sortOrder: habit.sortOrder,
      archived: habit.archived,
      createdAt: habit.createdAt,
      updatedAt: Clock.nowMillis(),
      deletedAt: habit.deletedAt,
      deviceId: habit.deviceId,
      version: habit.version + 1,
    );
    await _write(
      () => _repository.upsertHabit(updated),
      selectedHabitId: id,
    );
  }

  Future<void> archiveHabit(
    String id, {
    required bool archived,
  }) {
    return _write(
      () => _repository.archiveHabit(
        id,
        archived: archived,
        updatedAt: Clock.nowMillis(),
      ),
      selectedHabitId: id,
    );
  }

  Future<void> deleteHabit(String id) {
    return _write(
      () => _repository.softDeleteHabit(id, Clock.nowMillis()),
      clearSelection: true,
    );
  }

  Future<void> checkInToday(String habitId) {
    final now = Clock.nowMillis();
    return _write(
      () => _repository.checkInHabit(
        id: IdGenerator.create(),
        habitId: habitId,
        checkinDay: state.valueOrNull?.today ?? _today(),
        now: now,
        deviceId: _deviceId,
      ),
      selectedHabitId: habitId,
    );
  }

  Future<void> cancelTodayCheckin(String habitId) {
    return _write(
      () => _repository.cancelCheckin(
        habitId: habitId,
        checkinDay: state.valueOrNull?.today ?? _today(),
        deletedAt: Clock.nowMillis(),
      ),
      selectedHabitId: habitId,
    );
  }

  void selectHabit(String id) {
    final current = state.valueOrNull;
    if (current == null || _findHabit(current, id) == null) return;
    unawaited(_selectHabit(current, id));
  }

  void clearSelection() {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(current.copyWith(
      clearSelectedHabitId: true,
      selectedCheckins: const [],
      clearSelectedStatistics: true,
    ));
  }

  Future<void> _selectHabit(HabitsState current, String id) async {
    final selected = await _selectedDetails(id, today: current.today);
    if (state.valueOrNull != current) return;
    state = AsyncData(current.copyWith(
      selectedHabitId: id,
      selectedCheckins: selected.checkins,
      selectedStatistics: selected.statistics,
    ));
  }

  Future<void> _write(
    Future<void> Function() operation, {
    String? selectedHabitId,
    bool clearSelection = false,
  }) async {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(current.copyWith(
      saveStatus: HabitSaveStatus.saving,
      clearErrorMessage: true,
    ));
    try {
      await operation();
      state = AsyncData(await _load(
        today: current.today,
        selectedHabitId:
            clearSelection ? null : selectedHabitId ?? current.selectedHabitId,
        saveStatus: HabitSaveStatus.saved,
      ));
    } catch (error) {
      state = AsyncData(current.copyWith(
        saveStatus: HabitSaveStatus.failed,
        errorMessage: error.toString(),
      ));
    }
  }

  Future<HabitsState> _load({
    required int today,
    String? selectedHabitId,
    HabitSaveStatus saveStatus = HabitSaveStatus.idle,
    String? errorMessage,
  }) async {
    final habits = await _repository.listHabits();
    final todayHabits = await _repository.listHabitsForDay(today);
    final archived = (await _repository.listHabits(includeArchived: true))
        .where((habit) => habit.archived)
        .toList();
    final todayCheckins = <HabitCheckin>[];
    for (final habit in habits) {
      todayCheckins.addAll((await _repository.listCheckins(habit.id))
          .where((checkin) => checkin.checkinDay == today));
    }
    final selection = selectedHabitId != null &&
            [...habits, ...archived].any(
              (habit) => habit.id == selectedHabitId,
            )
        ? selectedHabitId
        : null;
    final selected = selection == null
        ? const _SelectedHabitDetails()
        : await _selectedDetails(selection, today: today);
    return HabitsState(
      habits: habits,
      todayHabits: todayHabits,
      archivedHabits: archived,
      todayCheckins: todayCheckins,
      selectedCheckins: selected.checkins,
      today: today,
      selectedHabitId: selection,
      selectedStatistics: selected.statistics,
      saveStatus: saveStatus,
      errorMessage: errorMessage,
    );
  }

  Future<_SelectedHabitDetails> _selectedDetails(
    String habitId, {
    required int today,
  }) async {
    final from = today - const Duration(days: 29).inMilliseconds;
    final before = today + const Duration(days: 1).inMilliseconds;
    return _SelectedHabitDetails(
      checkins: await _repository.listCheckins(habitId),
      statistics: await _repository.habitStatistics(
        habitId,
        from: from,
        before: before,
        asOfDay: today,
      ),
    );
  }

  Habit? _findHabit(HabitsState state, String id) {
    for (final habit in [...state.habits, ...state.archivedHabits]) {
      if (habit.id == id) return habit;
    }
    return null;
  }
}

class _SelectedHabitDetails {
  const _SelectedHabitDetails({
    this.checkins = const [],
    this.statistics,
  });

  final List<HabitCheckin> checkins;
  final HabitStatistics? statistics;
}

int _today() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
}
