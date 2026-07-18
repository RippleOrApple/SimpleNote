import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_note/database/app_database.dart';
import 'package:simple_note/features/appearance/application/appearance_controller.dart';
import 'package:simple_note/features/appearance/domain/appearance_presets.dart';
import 'package:simple_note/features/appearance/domain/device_appearance_profile.dart';
import 'package:simple_note/features/navigation/application/navigation_controller.dart';
import 'package:simple_note/features/navigation/domain/app_module.dart';
import 'package:simple_note/features/sync/data/sync_repository.dart';
import 'package:simple_note/features/sync/domain/device_info.dart';

void main() {
  test('Android and Windows expose their exact platform catalogs', () {
    expect(
      AppModuleCatalog.forPlatform('android'),
      const [
        AppModuleKey.today,
        AppModuleKey.calendar,
        AppModuleKey.habits,
        AppModuleKey.notes,
        AppModuleKey.more,
      ],
    );
    expect(
      AppModuleCatalog.forPlatform('windows'),
      const [
        AppModuleKey.today,
        AppModuleKey.calendar,
        AppModuleKey.habits,
        AppModuleKey.notes,
        AppModuleKey.statistics,
        AppModuleKey.settings,
      ],
    );
  });

  test('saved profiles ignore unknowns and normalize missing duplicates', () {
    final android = DeviceAppearanceProfile(
      id: 'device:android',
      platform: 'android',
      density: LayoutDensity.standard,
      navOrder: const ['notes', 'future-module', 'notes', 'today'],
      hiddenNav: const {'today', 'future-module', 'habits'},
      startModule: 'future-module',
      backgroundFocusX: 0.5,
      backgroundFocusY: 0.5,
      backgroundZoom: 1,
      backgroundBlur: 0,
      backgroundOverlay: 0,
      hapticsMode: HapticsMode.off,
      updatedAt: 1,
    );

    expect(
      android.navOrder,
      const ['notes', 'today', 'calendar', 'habits', 'more'],
    );
    expect(android.hiddenNav, const {'habits'});
    expect(android.startModule, 'today');

    final windows = DeviceAppearanceProfile.defaults(
      id: 'device:windows',
      platform: 'windows',
      updatedAt: 1,
    );
    expect(
      windows.navOrder,
      const [
        'today',
        'calendar',
        'habits',
        'notes',
        'statistics',
        'settings',
      ],
    );
  });

  test('today cannot be hidden', () async {
    final harness = await _NavigationHarness.create(_androidDevice);
    addTearDown(harness.dispose);

    await harness.controller.setHidden(AppModuleKey.today, true);

    expect(harness.state.hiddenModules, isNot(contains(AppModuleKey.today)));
    expect(harness.state.visibleModules.first, AppModuleKey.today);
  });

  test('start module cannot be hidden or unavailable', () async {
    final harness = await _NavigationHarness.create(_windowsDevice);
    addTearDown(harness.dispose);

    await harness.controller.setStartModule(AppModuleKey.notes);
    await harness.controller.setHidden(AppModuleKey.notes, true);

    expect(harness.state.startModule, AppModuleKey.notes);
    expect(harness.state.hiddenModules, isNot(contains(AppModuleKey.notes)));

    await harness.controller.setStartModule(AppModuleKey.more);

    expect(harness.state.startModule, AppModuleKey.today);
  });

  test('hidden modules keep their saved order when restored', () async {
    final harness = await _NavigationHarness.create(_androidDevice);
    addTearDown(harness.dispose);

    await harness.controller.reorder(const [
      AppModuleKey.today,
      AppModuleKey.notes,
      AppModuleKey.habits,
      AppModuleKey.calendar,
      AppModuleKey.more,
    ]);
    await harness.controller.setHidden(AppModuleKey.notes, true);
    await harness.controller.setHidden(AppModuleKey.habits, true);
    await harness.controller.setHidden(AppModuleKey.notes, false);

    expect(
      harness.state.order,
      const [
        AppModuleKey.today,
        AppModuleKey.notes,
        AppModuleKey.habits,
        AppModuleKey.calendar,
        AppModuleKey.more,
      ],
    );
    expect(harness.state.hiddenModules, const {AppModuleKey.habits});
  });

  test('navigation persistence remains local to the current platform',
      () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);

    final windows = await _NavigationHarness.create(
      _windowsDevice,
      database: database,
      ownsDatabase: false,
    );
    await windows.controller.reorder(const [
      AppModuleKey.today,
      AppModuleKey.settings,
      AppModuleKey.notes,
      AppModuleKey.calendar,
      AppModuleKey.habits,
      AppModuleKey.statistics,
    ]);
    await windows.controller.setHidden(AppModuleKey.statistics, true);
    await windows.controller.setStartModule(AppModuleKey.settings);
    windows.container.dispose();

    final android = await _NavigationHarness.create(
      _androidDevice,
      database: database,
      ownsDatabase: false,
    );
    expect(
      android.state.order,
      AppModuleCatalog.forPlatform('android'),
    );
    expect(android.state.hiddenModules, isEmpty);
    expect(android.state.startModule, AppModuleKey.today);
    await android.controller.setHidden(AppModuleKey.habits, true);
    android.container.dispose();

    final reloadedWindows = await _NavigationHarness.create(
      _windowsDevice,
      database: database,
      ownsDatabase: false,
    );
    addTearDown(() => reloadedWindows.container.dispose());

    expect(
      reloadedWindows.state.order,
      const [
        AppModuleKey.today,
        AppModuleKey.settings,
        AppModuleKey.notes,
        AppModuleKey.calendar,
        AppModuleKey.habits,
        AppModuleKey.statistics,
      ],
    );
    expect(
      reloadedWindows.state.hiddenModules,
      const {AppModuleKey.statistics},
    );
    expect(reloadedWindows.state.startModule, AppModuleKey.settings);
  });
}

final class _NavigationHarness {
  const _NavigationHarness(
    this.container,
    this.database, {
    required this.ownsDatabase,
  });

  final ProviderContainer container;
  final AppDatabase database;
  final bool ownsDatabase;

  NavigationController get controller =>
      container.read(navigationControllerProvider.notifier);

  NavigationState get state => container.read(navigationControllerProvider);

  static Future<_NavigationHarness> create(
    DeviceInfo device, {
    AppDatabase? database,
    bool ownsDatabase = true,
  }) async {
    final actualDatabase = database ?? AppDatabase(NativeDatabase.memory());
    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(actualDatabase),
        deviceInfoProvider.overrideWithValue(device),
      ],
    );
    await container.read(appearanceControllerProvider.future);
    container.read(navigationControllerProvider);
    await container.pump();
    return _NavigationHarness(
      container,
      actualDatabase,
      ownsDatabase: ownsDatabase,
    );
  }

  Future<void> dispose() async {
    container.dispose();
    if (ownsDatabase) {
      await database.close();
    }
  }
}

const _windowsDevice = DeviceInfo(
  deviceId: 'navigation-device',
  deviceName: 'Windows',
  platform: 'windows',
  appVersion: '1.0.0',
);

const _androidDevice = DeviceInfo(
  deviceId: 'navigation-device',
  deviceName: 'Android',
  platform: 'android',
  appVersion: '1.0.0',
);
