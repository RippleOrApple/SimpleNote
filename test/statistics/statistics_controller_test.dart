import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_note/database/app_database.dart';
import 'package:simple_note/features/statistics/application/statistics_controller.dart';
import 'package:simple_note/features/statistics/data/statistics_repository.dart';
import 'package:simple_note/features/statistics/domain/statistics_range.dart';

void main() {
  test('loads month by default and switches ranges', () async {
    final harness = await _Harness.create();
    addTearDown(harness.dispose);

    var state = await harness.state;
    expect(state.range.kind, StatisticsRangeKind.month);
    expect(state.summary.range, state.range);

    await harness.controller.selectRange(StatisticsRangeKind.week);
    state = await harness.state;
    expect(state.range.kind, StatisticsRangeKind.week);
    expect(state.summary.range.kind, StatisticsRangeKind.week);

    await harness.controller.selectRange(StatisticsRangeKind.year);
    state = await harness.state;
    expect(state.range.kind, StatisticsRangeKind.year);
    expect(state.summary.range.kind, StatisticsRangeKind.year);
  });
}

class _Harness {
  const _Harness(this.container, this.database);

  final ProviderContainer container;
  final AppDatabase database;

  StatisticsController get controller =>
      container.read(statisticsControllerProvider.notifier);
  Future<StatisticsState> get state =>
      container.read(statisticsControllerProvider.future);

  static Future<_Harness> create() async {
    final database = AppDatabase(NativeDatabase.memory());
    final container = ProviderContainer(overrides: [
      appDatabaseProvider.overrideWithValue(database),
      statisticsRepositoryProvider.overrideWithValue(
        DriftStatisticsRepository(database),
      ),
    ]);
    await container.read(statisticsControllerProvider.future);
    return _Harness(container, database);
  }

  Future<void> dispose() async {
    container.dispose();
    await database.close();
  }
}
