import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_note/app.dart';
import 'package:simple_note/database/app_database.dart';
import 'package:simple_note/features/settings/presentation/settings_page.dart';
import 'package:simple_note/features/sync/data/sync_repository.dart';
import 'package:simple_note/features/sync/domain/device_info.dart';

void main() {
  testWidgets('settings page keeps scroll offset after choosing a saved theme',
      (tester) async {
    await _pumpSettings(tester);
    final before = await _scrollTo(
      tester,
      find.byKey(const Key('saved-theme-night-black')),
    );

    await tester.tap(find.byTooltip('应用 夜间黑'));
    await tester.pumpAndSettle();

    _expectScrollOffsetPreserved(tester, before);
  });

  testWidgets('settings page keeps scroll offset after choosing a color',
      (tester) async {
    await _pumpSettings(tester);
    final before = await _scrollTo(
      tester,
      find.byKey(const Key('background-preset-E3ECDD')),
    );

    await tester.tap(find.byKey(const Key('background-preset-E3ECDD')));
    await tester.pumpAndSettle();

    _expectScrollOffsetPreserved(tester, before);
  });

  testWidgets('settings page keeps scroll offset after changing layout density',
      (tester) async {
    await _pumpSettings(tester);
    final before = await _scrollTo(
      tester,
      find.byKey(const Key('appearance-density')),
    );

    await tester.tap(find.byKey(const Key('appearance-density')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('紧凑').last);
    await tester.pumpAndSettle();

    _expectScrollOffsetPreserved(tester, before, tolerance: 80);
  });
}

Future<void> _pumpSettings(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(const Size(1280, 800));
  final database = AppDatabase(NativeDatabase.memory());
  addTearDown(() async {
    await database.close();
    await tester.binding.setSurfaceSize(null);
  });

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(database),
        deviceInfoProvider.overrideWithValue(_windowsDevice),
      ],
      child: const SimpleNoteApp(),
    ),
  );
  await tester.pumpAndSettle();
  await tester.tap(find.text('设置'));
  await tester.pumpAndSettle();
  expect(find.byType(SettingsPage), findsOneWidget);
}

Future<double> _scrollTo(WidgetTester tester, Finder target) async {
  await tester.scrollUntilVisible(
    target,
    500,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.drag(find.byType(Scrollable).first, const Offset(0, -20));
  await tester.pumpAndSettle();
  final offset = _settingsScrollOffset(tester);
  expect(offset, greaterThan(0));
  return offset;
}

void _expectScrollOffsetPreserved(
  WidgetTester tester,
  double before, {
  double tolerance = 1,
}) {
  final after = _settingsScrollOffset(tester);
  expect(after, closeTo(before, tolerance));
}

double _settingsScrollOffset(WidgetTester tester) {
  final listView = tester.widget<ListView>(
    find.byKey(const Key('settings-list')),
  );
  return listView.controller!.position.pixels;
}

const _windowsDevice = DeviceInfo(
  deviceId: 'settings-scroll-device',
  deviceName: 'Windows',
  platform: 'windows',
  appVersion: '1.0.0',
);
