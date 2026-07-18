import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:simple_note/core/routing/app_routes.dart';
import 'package:simple_note/database/app_database.dart';
import 'package:simple_note/features/appearance/presentation/appearance_page.dart';
import 'package:simple_note/features/navigation/domain/app_module.dart';
import 'package:simple_note/features/navigation/presentation/adaptive_app_shell.dart';
import 'package:simple_note/features/notes/presentation/notes_page.dart';
import 'package:simple_note/features/settings/presentation/settings_page.dart';
import 'package:simple_note/features/sync/data/sync_repository.dart';
import 'package:simple_note/features/sync/domain/device_info.dart';
import 'package:simple_note/shared/widgets/frosted_surface.dart';

void main() {
  testWidgets(
      '390x844 renders icon-only semantic Android navigation with 48dp targets',
      (tester) async {
    final harness = await _pumpShell(
      tester,
      device: _androidDevice,
      size: const Size(390, 844),
    );
    addTearDown(harness.dispose);

    final navigation = find.byType(NavigationBar);
    expect(navigation, findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);
    expect(
      tester.widget<NavigationBar>(navigation).labelBehavior,
      NavigationDestinationLabelBehavior.alwaysHide,
    );
    expect(
      find.descendant(of: navigation, matching: find.byType(Text)),
      findsNothing,
    );

    for (final module in const [
      AppModuleKey.today,
      AppModuleKey.calendar,
      AppModuleKey.habits,
      AppModuleKey.notes,
      AppModuleKey.more,
    ]) {
      final target = find.byKey(Key('android-nav-${module.name}'));
      expect(target, findsOneWidget, reason: module.name);
      final size = tester.getSize(target);
      expect(size.width, greaterThanOrEqualTo(48), reason: module.name);
      expect(size.height, greaterThanOrEqualTo(48), reason: module.name);
      final semantics = tester.getSemantics(target);
      expect(semantics.label, module.label);
      expect(
        find.descendant(of: target, matching: find.byType(PhosphorIcon)),
        findsOneWidget,
      );
      expect(
        tester
            .widget<PhosphorIcon>(
              find.descendant(
                of: target,
                matching: find.byType(PhosphorIcon),
              ),
            )
            .size,
        24,
      );
    }
  });

  testWidgets('1280x800 renders a frosted functional Windows rail',
      (tester) async {
    final harness = await _pumpShell(
      tester,
      device: _windowsDevice,
      size: const Size(1280, 800),
    );
    addTearDown(harness.dispose);

    final rail = find.byKey(const Key('windows-functional-rail'));
    expect(rail, findsOneWidget);
    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
    expect(
      find.ancestor(of: rail, matching: find.byType(FrostedSurface)),
      findsOneWidget,
    );
  });

  testWidgets('Android More opens settings with the sync upgrade notice',
      (tester) async {
    final harness = await _pumpShell(
      tester,
      device: _androidDevice,
      size: const Size(390, 844),
    );
    addTearDown(harness.dispose);

    await tester.tap(find.byKey(const Key('android-nav-more')));
    await tester.pumpAndSettle();

    expect(find.byType(SettingsPage), findsOneWidget);
    expect(find.byKey(const Key('sync-upgrade-notice')), findsOneWidget);
    expect(find.byKey(const Key('sync-start-server-button')), findsNothing);
  });

  testWidgets('switching modules preserves editor state in an IndexedStack',
      (tester) async {
    final harness = await _pumpShell(
      tester,
      device: _androidDevice,
      size: const Size(390, 844),
      moduleBuilders: {
        AppModuleKey.today: (_) => const _SentinelEditor(),
        AppModuleKey.notes: (_) => const Center(child: Text('Notes sentinel')),
      },
    );
    addTearDown(harness.dispose);

    expect(find.byType(IndexedStack), findsOneWidget);
    await tester.enterText(
      find.byKey(const Key('editor-state-sentinel')),
      'keep me',
    );

    await tester.tap(find.byKey(const Key('android-nav-notes')));
    await tester.pumpAndSettle();
    expect(find.text('Notes sentinel'), findsOneWidget);

    await tester.tap(find.byKey(const Key('android-nav-today')));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<TextField>(find.byKey(const Key('editor-state-sentinel')))
          .controller
          ?.text,
      'keep me',
    );
  });

  testWidgets('navigation editor exposes stable keys and protects today',
      (tester) async {
    final harness = await _pumpPage(
      tester,
      const AppearancePage(),
      device: _androidDevice,
      size: const Size(900, 2200),
    );
    addTearDown(harness.dispose);

    for (final module in AppModuleCatalog.forPlatform('android')) {
      expect(
        find.byKey(Key('nav-editor-${module.name}')),
        findsOneWidget,
      );
      expect(
        find.byKey(Key('nav-hide-${module.name}')),
        findsOneWidget,
      );
      expect(
        find.byKey(Key('nav-default-${module.name}')),
        findsOneWidget,
      );
    }
    final todayHide = tester.widget<IconButton>(
      find.byKey(const Key('nav-hide-today')),
    );
    expect(todayHide.onPressed, isNull);
    expect(find.byType(ReorderableListView), findsNWidgets(2));
  });

  testWidgets('compatibility routes select modules in the single shell',
      (tester) async {
    final harness = await _pumpShell(
      tester,
      device: _windowsDevice,
      size: const Size(1280, 800),
    );
    addTearDown(harness.dispose);

    final navigator = Navigator.of(
      tester.element(find.byType(AdaptiveAppShell)),
    );

    navigator.pushReplacementNamed(AppRoutes.todos);
    await tester.pumpAndSettle();
    expect(find.byType(AdaptiveAppShell), findsOneWidget);
    expect(find.byKey(const Key('task-list-pane')), findsOneWidget);
    expect(find.byType(Scaffold), findsOneWidget);

    Navigator.of(tester.element(find.byType(AdaptiveAppShell)))
        .pushReplacementNamed(AppRoutes.notes);
    await tester.pumpAndSettle();
    expect(find.byType(AdaptiveAppShell), findsOneWidget);
    expect(find.byType(NotesPage), findsOneWidget);
    expect(find.byType(Scaffold), findsOneWidget);

    Navigator.of(tester.element(find.byType(AdaptiveAppShell)))
        .pushReplacementNamed(AppRoutes.settings);
    await tester.pumpAndSettle();
    expect(find.byType(AdaptiveAppShell), findsOneWidget);
    expect(find.byType(SettingsPage), findsOneWidget);
    expect(find.byType(Scaffold), findsOneWidget);

    final routesSource =
        File('lib/core/routing/app_routes.dart').readAsStringSync();
    expect(routesSource, isNot(contains('todos_page.dart')));
    expect(routesSource, isNot(contains('TodosPage')));
  });
}

class _SentinelEditor extends StatefulWidget {
  const _SentinelEditor();

  @override
  State<_SentinelEditor> createState() => _SentinelEditorState();
}

class _SentinelEditorState extends State<_SentinelEditor> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: const Key('editor-state-sentinel'),
      controller: controller,
    );
  }
}

Future<_WidgetHarness> _pumpShell(
  WidgetTester tester, {
  required DeviceInfo device,
  required Size size,
  Map<AppModuleKey, WidgetBuilder> moduleBuilders = const {},
}) {
  return _pumpPage(
    tester,
    AdaptiveAppShell(moduleBuilders: moduleBuilders),
    device: device,
    size: size,
    routes: AppRoutes.routes,
    onGenerateRoute: AppRoutes.onGenerateRoute,
  );
}

Future<_WidgetHarness> _pumpPage(
  WidgetTester tester,
  Widget page, {
  required DeviceInfo device,
  required Size size,
  Map<String, WidgetBuilder>? routes,
  RouteFactory? onGenerateRoute,
}) async {
  await tester.binding.setSurfaceSize(size);
  final database = AppDatabase(NativeDatabase.memory());
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(database),
        deviceInfoProvider.overrideWithValue(device),
      ],
      child: MaterialApp(
        home: page,
        routes: routes ?? const {},
        onGenerateRoute: onGenerateRoute,
      ),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 200));
  return _WidgetHarness(database, tester);
}

final class _WidgetHarness {
  const _WidgetHarness(this.database, this.tester);

  final AppDatabase database;
  final WidgetTester tester;

  Future<void> dispose() async {
    await tester.pumpWidget(const SizedBox.shrink());
    await database.close();
    await tester.binding.setSurfaceSize(null);
  }
}

const _windowsDevice = DeviceInfo(
  deviceId: 'shell-device',
  deviceName: 'Windows',
  platform: 'windows',
  appVersion: '1.0.0',
);

const _androidDevice = DeviceInfo(
  deviceId: 'shell-device',
  deviceName: 'Android',
  platform: 'android',
  appVersion: '1.0.0',
);
