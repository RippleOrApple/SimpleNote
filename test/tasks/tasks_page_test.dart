import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_note/database/app_database.dart';
import 'package:simple_note/features/navigation/presentation/adaptive_app_shell.dart';
import 'package:simple_note/features/tasks/presentation/tasks_page.dart';
import 'package:simple_note/features/sync/data/sync_repository.dart';
import 'package:simple_note/features/sync/domain/device_info.dart';
import 'package:simple_note/features/tasks/data/tasks_repository.dart';
import 'package:simple_note/features/tasks/domain/task.dart';
import 'package:simple_note/features/tasks/domain/task_list.dart';

void main() {
  testWidgets('1280x800 renders the Windows four-zone workspace',
      (tester) async {
    final harness = await _pumpTasks(
      tester,
      size: const Size(1280, 800),
      useShell: true,
    );
    addTearDown(harness.dispose);

    expect(find.byKey(const Key('windows-functional-rail')), findsOneWidget);
    expect(find.byKey(const Key('task-sources-pane')), findsOneWidget);
    expect(find.byKey(const Key('task-list-pane')), findsOneWidget);
    expect(find.byKey(const Key('task-detail-pane')), findsOneWidget);

    await tester.tap(find.byKey(const Key('task-source-all')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('task-include-completed')), findsOneWidget);

    await tester.tap(find.byKey(const Key('task-list-source-work')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('task-list-tinted-surface')), findsOneWidget);
  });

  testWidgets('compact task workspace opens sources in a bottom sheet',
      (tester) async {
    final harness = await _pumpTasks(
      tester,
      size: const Size(390, 844),
      device: _androidDevice,
    );
    addTearDown(harness.dispose);

    expect(find.byKey(const Key('task-list-pane')), findsOneWidget);
    expect(find.byKey(const Key('task-sources-pane')), findsNothing);
    await tester.tap(find.byKey(const Key('task-source-button')));
    await tester.pumpAndSettle();
    expect(find.text('收集箱'), findsOneWidget);
    expect(find.byKey(const Key('task-sources-pane')), findsOneWidget);
  });

  testWidgets('search, quick add, and detail controls work together',
      (tester) async {
    final harness = await _pumpTasks(tester, size: const Size(1280, 800));
    addTearDown(harness.dispose);

    await tester.enterText(
      find.byKey(const Key('task-search-field')),
      'release',
    );
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();
    expect(find.text('Prepare release'), findsWidgets);

    await tester.enterText(find.byKey(const Key('task-search-field')), '');
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('quick-add-task-field')),
      'Prepare demo',
    );
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(find.text('Prepare demo'), findsWidgets);

    expect(find.byKey(const Key('task-title-field')), findsOneWidget);
    expect(find.byKey(const Key('task-description-field')), findsOneWidget);
    expect(find.byKey(const Key('task-priority-none')), findsOneWidget);
    expect(find.byKey(const Key('task-priority-low')), findsOneWidget);
    expect(find.byKey(const Key('task-priority-medium')), findsOneWidget);
    expect(find.byKey(const Key('task-priority-high')), findsOneWidget);

    await tester.tap(find.byKey(const Key('task-priority-high')));
    await tester.pumpAndSettle();
    final priority = tester.widget<ChoiceChip>(
      find.byKey(const Key('task-priority-high')),
    );
    expect(priority.selected, isTrue);
  });

  testWidgets('task detail exposes reminder controls', (tester) async {
    final harness = await _pumpTasks(tester, size: const Size(1280, 800));
    addTearDown(harness.dispose);

    await tester.tap(find.byKey(const Key('task-row-release')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('task-reminders-section')), findsOneWidget);
    await tester.tap(find.byKey(const Key('task-add-reminder')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('task-reminder-relative-10')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('task-reminder-item')), findsOneWidget);
    expect(find.byKey(const Key('task-remove-reminder')), findsOneWidget);
  });
}

Future<_Harness> _pumpTasks(
  WidgetTester tester, {
  required Size size,
  DeviceInfo device = _windowsDevice,
  bool useShell = false,
}) async {
  await tester.binding.setSurfaceSize(size);
  final database = AppDatabase(NativeDatabase.memory());
  final repository = DriftTasksRepository(database);
  final now = DateTime.now().millisecondsSinceEpoch;
  await repository.upsertTaskList(TaskList(
    id: 'work',
    name: 'Work',
    color: 0x4D8BB8,
    iconKey: 'briefcase',
    createdAt: now,
    updatedAt: now,
    deviceId: 'task-page-device',
  ));
  await repository.upsertTask(Task(
    id: 'release',
    title: 'Prepare release',
    descriptionMarkdown: 'Release checklist',
    dueAt: now + const Duration(hours: 1).inMilliseconds,
    createdAt: now,
    updatedAt: now,
    deviceId: 'task-page-device',
  ));
  await repository.upsertTask(Task(
    id: 'work-task',
    listId: 'work',
    title: 'Work item',
    createdAt: now + 1,
    updatedAt: now + 1,
    deviceId: 'task-page-device',
  ));

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(database),
        deviceInfoProvider.overrideWithValue(device),
      ],
      child: MaterialApp(
        home: useShell
            ? const AdaptiveAppShell()
            : const Scaffold(body: TasksPage()),
      ),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 200));
  return _Harness(tester, database);
}

class _Harness {
  const _Harness(this.tester, this.database);

  final WidgetTester tester;
  final AppDatabase database;

  Future<void> dispose() async {
    await tester.pumpWidget(const SizedBox.shrink());
    await database.close();
    await tester.binding.setSurfaceSize(null);
  }
}

const _windowsDevice = DeviceInfo(
  deviceId: 'task-page-device',
  deviceName: 'Windows',
  platform: 'windows',
  appVersion: '1.0.0',
);

const _androidDevice = DeviceInfo(
  deviceId: 'task-page-device',
  deviceName: 'Android',
  platform: 'android',
  appVersion: '1.0.0',
);
