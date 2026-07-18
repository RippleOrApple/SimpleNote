import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/calendar_repository.dart';
import '../domain/calendar_entry.dart';

final calendarControllerProvider =
    AsyncNotifierProvider<CalendarController, CalendarState>(
  CalendarController.new,
);

class CalendarState {
  const CalendarState({
    required this.from,
    required this.before,
    required this.days,
  });

  final int from;
  final int before;
  final List<CalendarDay> days;
}

class CalendarController extends AsyncNotifier<CalendarState> {
  late final CalendarRepository _repository;

  @override
  Future<CalendarState> build() async {
    _repository = ref.watch(calendarRepositoryProvider);
    final now = DateTime.now();
    final from = DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
    final before = DateTime(now.year, now.month, now.day)
        .add(const Duration(days: 30))
        .millisecondsSinceEpoch;
    return _load(from: from, before: before);
  }

  Future<void> loadRange({
    required int from,
    required int before,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _load(from: from, before: before));
  }

  Future<CalendarState> _load({
    required int from,
    required int before,
  }) async {
    final days = await _repository.queryDays(from: from, before: before);
    return CalendarState(from: from, before: before, days: days);
  }
}
