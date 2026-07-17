import 'dart:io';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:simple_note/core/theme/typography_preferences.dart';
import 'package:simple_note/database/app_database.dart';
import 'package:simple_note/features/appearance/application/appearance_controller.dart';
import 'package:simple_note/features/appearance/domain/appearance_presets.dart';
import 'package:simple_note/features/appearance/domain/appearance_settings.dart';
import 'package:simple_note/features/appearance/domain/rgb_color.dart';
import 'package:simple_note/features/sync/data/device_identity_repository.dart';
import 'package:simple_note/features/sync/data/sync_repository.dart';
import 'package:simple_note/features/sync/domain/device_info.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() => database.close());

  test('persists portable accent and current-platform density', () async {
    final container = _container(database, _windowsDevice);
    addTearDown(container.dispose);
    await container.read(appearanceControllerProvider.future);
    final controller = container.read(appearanceControllerProvider.notifier);

    await controller.setDensity(LayoutDensity.compact);
    await controller.setAccent(const RgbColor(0x5E9D83));
    container.invalidate(appearanceControllerProvider);
    final reloaded = await container.read(appearanceControllerProvider.future);

    expect(reloaded.deviceProfile.density, LayoutDensity.compact);
    expect(reloaded.portable.accent.value, 0x5E9D83);
  });

  test('serializes concurrent portable mutations without lost updates',
      () async {
    final container = _container(database, _windowsDevice);
    addTearDown(container.dispose);
    await container.read(appearanceControllerProvider.future);
    final controller = container.read(appearanceControllerProvider.notifier);

    await Future.wait([
      controller.setTintStrength(0.8),
      controller.setGlassOpacity(0.2),
    ]);
    container.invalidate(appearanceControllerProvider);
    final reloaded = await container.read(appearanceControllerProvider.future);

    expect(reloaded.portable.tintStrength, 0.8);
    expect(reloaded.portable.glassOpacity, 0.2);
  });

  test('keeps in-memory portable and local state after concurrent mutations',
      () async {
    final container = _container(database, _windowsDevice);
    addTearDown(container.dispose);
    await container.read(appearanceControllerProvider.future);
    final controller = container.read(appearanceControllerProvider.notifier);

    await Future.wait([
      controller.setAccent(const RgbColor(0x5E9D83)),
      controller.setDensity(LayoutDensity.compact),
    ]);
    final current = await container.read(appearanceControllerProvider.future);

    expect(current.portable.accent, const RgbColor(0x5E9D83));
    expect(current.deviceProfile.density, LayoutDensity.compact);
  });

  test('updates last pure background only for pure selections', () async {
    final container = _container(database, _windowsDevice);
    addTearDown(container.dispose);
    final initial = await container.read(appearanceControllerProvider.future);
    final originalPure = initial.portable.lastPureBackground;
    final controller = container.read(appearanceControllerProvider.notifier);

    await controller.setBackground(
      BackgroundSelection.bundledImage('assets/backgrounds/presets/paper.png'),
    );
    var state = await container.read(appearanceControllerProvider.future);
    expect(state.portable.lastPureBackground, originalPure);

    const custom = RgbColor(0x123456);
    await controller.setBackground(BackgroundSelection.customColor(custom));
    state = await container.read(appearanceControllerProvider.future);
    expect(state.portable.background.color, custom);
    expect(state.portable.lastPureBackground, custom);
  });

  test('keeps local image and presentation out of portable settings', () async {
    final container = _container(database, _windowsDevice);
    addTearDown(container.dispose);
    await container.read(appearanceControllerProvider.future);
    final controller = container.read(appearanceControllerProvider.notifier);
    final portableBackground =
        BackgroundSelection.syncedImage('synced-background');
    await controller.setBackground(portableBackground);

    await controller.setLocalBackgroundImage('local-background');
    await controller.setBackgroundPresentation(
      focusX: -1,
      focusY: 2,
      zoom: 8,
      blur: 100,
      overlay: -0.5,
    );

    var state = await container.read(appearanceControllerProvider.future);
    expect(state.portable.background, portableBackground);
    expect(state.deviceProfile.localBackgroundImageId, 'local-background');
    expect(state.deviceProfile.backgroundFocusX, 0);
    expect(state.deviceProfile.backgroundFocusY, 1);
    expect(state.deviceProfile.backgroundZoom, 3);
    expect(state.deviceProfile.backgroundBlur, 40);
    expect(state.deviceProfile.backgroundOverlay, 0);

    await controller.setLocalBackgroundImage(null);
    state = await container.read(appearanceControllerProvider.future);
    expect(state.deviceProfile.localBackgroundImageId, isNull);
    expect(state.portable.background, portableBackground);
  });

  test('persists the remaining portable and local mutations', () async {
    final container = _container(database, _windowsDevice);
    addTearDown(container.dispose);
    await container.read(appearanceControllerProvider.future);
    final controller = container.read(appearanceControllerProvider.notifier);
    final typography = TypographyPreferences(
      uiFontFamily: 'ResourceHanRoundedCN',
      noteFontFamily: 'LXGWWenKai',
      uiScale: UiScale.large,
      noteFontSize: 100,
      noteLineHeight: 0,
    );

    await controller.setNotePaper(const RgbColor(0xF8F0DE));
    await controller.setTintStrength(2);
    await controller.setGlassOpacity(-1);
    await controller.setDarkOverlay(0.8);
    await controller.setTypography(typography);
    await controller.setMotion(MotionLevel.reduced);
    await controller.setHaptics(HapticsMode.keyActions);

    container.invalidate(appearanceControllerProvider);
    final reloaded = await container.read(appearanceControllerProvider.future);
    expect(reloaded.portable.notePaper, const RgbColor(0xF8F0DE));
    expect(reloaded.portable.tintStrength, 1);
    expect(reloaded.portable.glassOpacity, 0);
    expect(reloaded.portable.darkOverlay, 0.8);
    expect(reloaded.portable.typography.uiScale, UiScale.large);
    expect(reloaded.portable.typography.noteFontSize, 28);
    expect(reloaded.portable.typography.noteLineHeight, 1.3);
    expect(reloaded.portable.motion, MotionLevel.reduced);
    expect(reloaded.deviceProfile.hapticsMode, HapticsMode.keyActions);
  });

  test('does not overwrite another platform local profile', () async {
    final windowsContainer = _container(database, _windowsDevice);
    await windowsContainer.read(appearanceControllerProvider.future);
    await windowsContainer
        .read(appearanceControllerProvider.notifier)
        .setDensity(LayoutDensity.compact);
    await windowsContainer
        .read(appearanceControllerProvider.notifier)
        .setLocalBackgroundImage('windows-image');
    windowsContainer.dispose();

    final androidContainer = _container(database, _androidDevice);
    await androidContainer.read(appearanceControllerProvider.future);
    final android = await androidContainer.read(
      appearanceControllerProvider.future,
    );
    expect(android.deviceProfile.density, LayoutDensity.standard);
    expect(android.deviceProfile.localBackgroundImageId, isNull);
    await androidContainer
        .read(appearanceControllerProvider.notifier)
        .setHaptics(HapticsMode.rich);
    androidContainer.dispose();

    final reloadedWindowsContainer = _container(database, _windowsDevice);
    addTearDown(reloadedWindowsContainer.dispose);
    final windows = await reloadedWindowsContainer.read(
      appearanceControllerProvider.future,
    );
    expect(windows.deviceProfile.density, LayoutDensity.compact);
    expect(windows.deviceProfile.localBackgroundImageId, 'windows-image');
    expect(windows.deviceProfile.hapticsMode, HapticsMode.off);
  });

  test('reloads the same profile from a reconstructed durable identity',
      () async {
    final previousWarningSetting =
        driftRuntimeOptions.dontWarnAboutMultipleDatabases;
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    addTearDown(() {
      driftRuntimeOptions.dontWarnAboutMultipleDatabases =
          previousWarningSetting;
    });
    final directory = await Directory.systemTemp.createTemp(
      'simple_note_appearance_identity_',
    );
    final databaseFile = File(p.join(directory.path, 'appearance.sqlite'));
    final firstDatabase = AppDatabase(NativeDatabase(databaseFile));
    final firstIdentity = await DeviceIdentityRepository(
      firstDatabase,
      deviceName: 'Test PC',
      platform: 'windows',
      appVersion: '1.0.0',
      createId: () => 'durable-id',
    ).loadOrCreate();
    final firstContainer = _container(firstDatabase, firstIdentity);
    await firstContainer.read(appearanceControllerProvider.future);
    await firstContainer
        .read(appearanceControllerProvider.notifier)
        .setDensity(LayoutDensity.compact);
    firstContainer.dispose();
    await firstDatabase.close();

    final reconstructedDatabase = AppDatabase(NativeDatabase(databaseFile));
    final reconstructedIdentity = await DeviceIdentityRepository(
      reconstructedDatabase,
      deviceName: 'Renamed Test PC',
      platform: 'windows',
      appVersion: '1.0.1',
      createId: () => 'different-id',
    ).loadOrCreate();
    final reconstructedContainer = _container(
      reconstructedDatabase,
      reconstructedIdentity,
    );
    addTearDown(() async {
      reconstructedContainer.dispose();
      await reconstructedDatabase.close();
      await directory.delete(recursive: true);
    });

    final reloaded = await reconstructedContainer.read(
      appearanceControllerProvider.future,
    );

    expect(reconstructedIdentity.deviceId, firstIdentity.deviceId);
    expect(reloaded.deviceProfile.id, '${firstIdentity.deviceId}:windows');
    expect(reloaded.deviceProfile.density, LayoutDensity.compact);
  });
}

ProviderContainer _container(AppDatabase database, DeviceInfo device) {
  return ProviderContainer(
    overrides: [
      appDatabaseProvider.overrideWithValue(database),
      deviceInfoProvider.overrideWithValue(device),
    ],
  );
}

const _windowsDevice = DeviceInfo(
  deviceId: 'test-device',
  deviceName: 'Windows',
  platform: 'windows',
  appVersion: '1.0.0',
);

const _androidDevice = DeviceInfo(
  deviceId: 'test-device',
  deviceName: 'Android',
  platform: 'android',
  appVersion: '1.0.0',
);
