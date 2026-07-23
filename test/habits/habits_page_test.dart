import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_note/database/app_database.dart';
import 'package:simple_note/features/habits/data/habits_repository.dart';
import 'package:simple_note/features/habits/domain/habit.dart';
import 'package:simple_note/features/habits/domain/habit_schedule.dart';
import 'package:simple_note/features/habits/presentation/habits_page.dart';
import 'package:simple_note/features/navigation/domain/app_module.dart';
import 'package:simple_note/features/navigation/presentation/adaptive_app_shell.dart';
import 'package:simple_note/features/sync/data/sync_repository.dart';
import 'package:simple_note/features/sync/domain/device_info.dart';

void main() {
  testWidgets('habits module replaces placeholder and shows wide panes',
      (tester) async {
    final harness = await _pumpShell(
      tester,
      device: _windowsDevice,
      size: const Size(1280, 800),
      seed: true,
    );
    addTearDown(harness.dispose);

    await tester.tap(find.text('习惯').first);
    await tester.pumpAndSettle();

    expect(find.byType(HabitsPage), findsOneWidget);
    expect(find.text('习惯模块将在后续阶段完成。'), findsNothing);
    expect(find.byKey(const Key('habit-list-pane')), findsOneWidget);
    expect(find.byKey(const Key('habit-detail-pane')), findsOneWidget);
    expect(find.text('Read'), findsWidgets);
    expect(find.text('当前连续'), findsOneWidget);
  });

  testWidgets('compact habits list opens detail and can check in',
      (tester) async {
    final harness = await _pumpPage(
      tester,
      const HabitsPage(),
      device: _androidDevice,
      size: const Size(390, 844),
      seed: true,
    );
    addTearDown(harness.dispose);

    expect(find.byKey(const Key('habit-list-pane')), findsOneWidget);
    expect(find.byKey(const Key('habit-detail-pane')), findsNothing);

    await tester.tap(find.byKey(const Key('habit-row-read')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('habit-detail-pane')), findsOneWidget);
    expect(find.byKey(const Key('habit-detail-back')), findsOneWidget);
    expect(find.text('Read'), findsWidgets);

    await tester.tap(find.byKey(const Key('habit-checkin-button')));
    await tester.pumpAndSettle();
    expect(find.text('今天已打卡'), findsOneWidget);

    await tester.tap(find.byKey(const Key('habit-detail-back')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('habit-list-pane')), findsOneWidget);
  });
}

Future<_WidgetHarness> _pumpShell(
  WidgetTester tester, {
  required DeviceInfo device,
  required Size size,
  bool seed = false,
}) {
  return _pumpPage(
    tester,
    const AdaptiveAppShell(initialModule: AppModuleKey.habits),
    device: device,
    size: size,
    seed: seed,
  );
}

Future<_WidgetHarness> _pumpPage(
  WidgetTester tester,
  Widget page, {
  required DeviceInfo device,
  required Size size,
  bool seed = false,
}) async {
  await tester.binding.setSurfaceSize(size);
  final database = AppDatabase(NativeDatabase.memory());
  if (seed) {
    await DriftHabitsRepository(database).upsertHabit(_habit('read', 'Read'));
  }
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(database),
        deviceInfoProvider.overrideWithValue(device),
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

Habit _habit(String id, String name) {
  return Habit(
    id: id,
    name: name,
    prompt: '10 pages',
    iconKey: 'book',
    color: 0x3366CC,
    schedule: HabitSchedule.daily(),
    createdAt: 1,
    updatedAt: 1,
    deviceId: _windowsDevice.deviceId,
  );
}

const _windowsDevice = DeviceInfo(
  deviceId: 'habits-page-device',
  deviceName: 'Windows',
  platform: 'windows',
  appVersion: '1.0.0',
);

const _androidDevice = DeviceInfo(
  deviceId: 'habits-page-device',
  deviceName: 'Android',
  platform: 'android',
  appVersion: '1.0.0',
);
