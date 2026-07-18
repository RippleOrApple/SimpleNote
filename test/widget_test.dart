import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_note/app.dart';
import 'package:simple_note/database/app_database.dart';
import 'package:simple_note/features/navigation/presentation/adaptive_app_shell.dart';
import 'package:simple_note/features/notes/presentation/notes_page.dart';
import 'package:simple_note/features/settings/presentation/settings_page.dart';
import 'package:simple_note/features/sync/data/sync_repository.dart';
import 'package:simple_note/features/sync/domain/device_info.dart';
import 'package:simple_note/shared/widgets/app_background.dart';

void main() {
  testWidgets('SimpleNote starts on the Today module', (tester) async {
    await _pumpApp(tester, device: _androidDevice);

    expect(find.byKey(const Key('android-nav-today')), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
  });

  testWidgets('SimpleNote installs the appearance theme and global background',
      (tester) async {
    await _pumpApp(tester, device: _androidDevice);

    expect(find.byType(AppBackground), findsOneWidget);
    final theme = Theme.of(tester.element(find.byType(Scaffold).first));
    expect(theme.textTheme.bodyMedium?.fontFamily, 'ResourceHanRoundedCN');
  });

  testWidgets('compact navigation opens the Notes module', (tester) async {
    await _pumpApp(
      tester,
      surfaceSize: const Size(390, 844),
      device: _androidDevice,
    );

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);
    await tester.tap(find.byKey(const Key('android-nav-notes')));
    await tester.pumpAndSettle();

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byKey(const Key('note-title-field')), findsNothing);
  });

  testWidgets('wide screens use the functional side rail', (tester) async {
    await _pumpApp(
      tester,
      surfaceSize: const Size(1024, 768),
      device: _windowsDevice,
    );

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
    expect(find.byKey(const Key('windows-functional-rail')), findsOneWidget);
  });

  testWidgets('notes route preserves the existing NotesPage module',
      (tester) async {
    await _pumpApp(
      tester,
      surfaceSize: const Size(1024, 1000),
      device: _windowsDevice,
    );
    Navigator.of(tester.element(find.byType(AdaptiveAppShell).first))
        .pushReplacementNamed('/notes');
    await tester.pumpAndSettle();

    expect(find.byType(NotesPage), findsOneWidget);
  });

  testWidgets('settings compatibility route selects Settings in the shell',
      (tester) async {
    await _pumpApp(
      tester,
      surfaceSize: const Size(1024, 768),
      device: _windowsDevice,
    );
    Navigator.of(tester.element(find.byType(AdaptiveAppShell).first))
        .pushReplacementNamed('/settings');
    await tester.pumpAndSettle();

    expect(find.byType(AdaptiveAppShell), findsOneWidget);
    expect(find.byType(SettingsPage), findsOneWidget);
  });
}

Future<void> _pumpApp(
  WidgetTester tester, {
  required DeviceInfo device,
  Size? surfaceSize,
}) async {
  if (surfaceSize != null) {
    await tester.binding.setSurfaceSize(surfaceSize);
    addTearDown(() => tester.binding.setSurfaceSize(null));
  }

  final database = AppDatabase(NativeDatabase.memory());
  addTearDown(database.close);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(database),
        deviceInfoProvider.overrideWithValue(device),
      ],
      child: const SimpleNoteApp(),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 100));
}

const _androidDevice = DeviceInfo(
  deviceId: 'widget-device',
  deviceName: 'Android',
  platform: 'android',
  appVersion: '1.0.0',
);

const _windowsDevice = DeviceInfo(
  deviceId: 'widget-device',
  deviceName: 'Windows',
  platform: 'windows',
  appVersion: '1.0.0',
);
