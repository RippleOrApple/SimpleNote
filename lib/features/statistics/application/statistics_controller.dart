import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/statistics_repository.dart';
import '../domain/statistics_range.dart';
import '../domain/statistics_summary.dart';

final statisticsControllerProvider =
    AsyncNotifierProvider<StatisticsController, StatisticsState>(
  StatisticsController.new,
);

class StatisticsState {
  const StatisticsState({
    required this.range,
    required this.summary,
  });

  final StatisticsRange range;
  final StatisticsSummary summary;
}

class StatisticsController extends AsyncNotifier<StatisticsState> {
  late StatisticsRepository _repository;

  @override
  Future<StatisticsState> build() async {
    _repository = ref.watch(statisticsRepositoryProvider);
    return _load(_rangeFor(StatisticsRangeKind.month));
  }

  Future<void> selectRange(StatisticsRangeKind kind) async {
    state = AsyncData(await _load(_rangeFor(kind)));
  }

  Future<StatisticsState> _load(StatisticsRange range) async {
    return StatisticsState(
      range: range,
      summary: await _repository.loadSummary(range),
    );
  }
}

StatisticsRange _rangeFor(StatisticsRangeKind kind) {
  final anchor = _today();
  return switch (kind) {
    StatisticsRangeKind.week => StatisticsRange.week(anchorDay: anchor),
    StatisticsRangeKind.month => StatisticsRange.month(anchorDay: anchor),
    StatisticsRangeKind.year => StatisticsRange.year(anchorDay: anchor),
  };
}

int _today() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
}
