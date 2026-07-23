import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_note/database/app_database.dart';
import 'package:simple_note/features/navigation/domain/app_module.dart';
import 'package:simple_note/features/navigation/presentation/adaptive_app_shell.dart';
import 'package:simple_note/features/statistics/presentation/statistics_page.dart';
import 'package:simple_note/features/sync/data/sync_repository.dart';
import 'package:simple_note/features/sync/domain/device_info.dart';
import 'package:simple_note/features/tasks/data/tasks_repository.dart';
import 'package:simple_note/features/tasks/domain/task.dart';

void main() {
  testWidgets('statistics module replaces placeholder and shows summary',
      (tester) async {
    final harness = await _pumpShell(tester, seed: true);
    addTearDown(harness.dispose);

    expect(find.byType(StatisticsPage), findsOneWidget);
    expect(
      find.text('统计模块将在后续阶段完成。'),
      findsNothing,
    );
    expect(find.text('任务完成'), findsOneWidget);
    expect(find.text('习惯打卡'), findsOneWidget);
    expect(find.text('习惯完成率'), findsOneWidget);
    expect(find.text('1'), findsWidgets);
  });

  testWidgets('statistics page switches range tabs', (tester) async {
    final harness = await _pumpPage(tester, const StatisticsPage());
    addTearDown(harness.dispose);

    expect(find.byKey(const Key('statistics-page')), findsOneWidget);
    expect(find.byKey(const Key('statistics-range-month')), findsOneWidget);

    await tester.tap(find.byKey(const Key('statistics-range-week')));
    await tester.pumpAndSettle();
    expect(find.text('本周'), findsWidgets);

    await tester.tap(find.byKey(const Key('statistics-range-year')));
    await tester.pumpAndSettle();
    expect(find.text('本年'), findsWidgets);
  });
}

Future<_WidgetHarness> _pumpShell(
  WidgetTester tester, {
  bool seed = false,
}) {
  return _pumpPage(
    tester,
    const AdaptiveAppShell(initialModule: AppModuleKey.statistics),
    seed: seed,
  );
}

Future<_WidgetHarness> _pumpPage(
  WidgetTester tester,
  Widget page, {
  bool seed = false,
}) async {
  await tester.binding.setSurfaceSize(const Size(1280, 800));
  final database = AppDatabase(NativeDatabase.memory());
  if (seed) {
    final tasks = DriftTasksRepository(database);
    await tasks.upsertTask(Task(
      id: 'done',
      title: 'Done',
      completed: true,
      completedAt: DateTime.now().millisecondsSinceEpoch,
      createdAt: 1,
      updatedAt: 1,
      deviceId: 'device',
    ));
  }
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(database),
        deviceInfoProvider.overrideWithValue(_device),
      ],
      child: MaterialApp(home: page),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 250));
  return _WidgetHarness(database, tester);
}

class _WidgetHarness {
  const _WidgetHarness(this.database, this.tester);

  final AppDatabase database;
  final WidgetTester tester;

  Future<void> dispose() async {
    await tester.pumpWidget(const SizedBox.shrink());
    await database.close();
    await tester.binding.setSurfaceSize(null);
  }
}

const _device = DeviceInfo(
  deviceId: 'statistics-page-device',
  deviceName: 'Windows',
  platform: 'windows',
  appVersion: '1.0.0',
);
