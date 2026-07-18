import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_note/database/app_database.dart';
import 'package:simple_note/features/appearance/data/appearance_repository.dart';
import 'package:simple_note/features/appearance/domain/appearance_presets.dart';
import 'package:simple_note/features/appearance/domain/appearance_settings.dart';
import 'package:simple_note/features/appearance/domain/rgb_color.dart';
import 'package:simple_note/features/sync/domain/device_info.dart';

void main() {
  late AppDatabase database;
  late DriftAppearanceRepository repository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = DriftAppearanceRepository(database, _windowsDevice);
  });

  tearDown(() => database.close());

  test('initializes portable settings from the active V1 accent', () async {
    await _insertActiveTheme(database, primaryColor: 0xFF123456);

    final portable = await repository.loadPortable();

    expect(portable.typography.uiScale, UiScale.standard);
    expect(portable.accent, const RgbColor(0x123456));
    final stored = await database.appSettingsDao.getValue(
      AppearanceRepository.portableSettingsKey,
    );
    expect(stored, contains('"accent":1193046'));
    final customColors = await repository.listCustomColors();
    expect(customColors, hasLength(1));
    expect(customColors.single.color, const RgbColor(0x123456));
    expect(customColors.single.sortOrder, 0);
  });

  test('does not add an approved migrated accent to My Colors', () async {
    await _insertActiveTheme(
      database,
      primaryColor: 0xFF000000 | AppearancePresets.accentColors[2].value,
    );

    final portable = await repository.loadPortable();

    expect(portable.accent, AppearancePresets.accentColors[2]);
    expect(await repository.listCustomColors(), isEmpty);
  });

  test('falls back to defaults when portable JSON cannot be decoded', () async {
    await database.appSettingsDao.setValue(
      AppearanceRepository.portableSettingsKey,
      '{"schemaVersion":999}',
    );

    final portable = await repository.loadPortable();

    expect(portable, equals(AppearanceSettings.defaults()));
    expect(
      await database.appSettingsDao.getValue(
        AppearanceRepository.portableSettingsKey,
      ),
      contains('"schemaVersion":1'),
    );
  });

  test('deduplicates My Colors by normalized 24-bit RGB', () async {
    await repository.loadPortable();

    final first = await repository.addCustomColor(
      name: 'Sea',
      color: const RgbColor(0x4D8BB8),
    );
    final duplicate = await repository.addCustomColor(
      name: 'Duplicate',
      color: const RgbColor(0x4D8BB8),
    );

    expect(duplicate.id, first.id);
    expect(await repository.listCustomColors(), hasLength(1));
  });

  test('renames, reorders, and soft-deletes My Colors', () async {
    final sea = await repository.addCustomColor(
      name: 'Sea',
      color: const RgbColor(0x4D8BB8),
    );
    final rose = await repository.addCustomColor(
      name: 'Rose',
      color: const RgbColor(0xB66B86),
    );

    await repository.renameCustomColor(sea.id, 'Ocean');
    await repository.reorderCustomColors([rose.id, sea.id]);

    final reordered = await repository.listCustomColors();
    expect(reordered.map((entry) => entry.id), [rose.id, sea.id]);
    expect(reordered.last.name, 'Ocean');
    expect(reordered.map((entry) => entry.sortOrder), [0, 1]);

    await repository.deleteCustomColor(rose.id);
    final remaining = await repository.listCustomColors();
    expect(remaining.map((entry) => entry.id), [sea.id]);
    expect(remaining.single.sortOrder, 0);
  });

  test('limits My Colors to 24 active RGB values', () async {
    for (var index = 0; index < 24; index++) {
      await repository.addCustomColor(
        name: 'Color $index',
        color: RgbColor(index),
      );
    }

    expect(
      () => repository.addCustomColor(
        name: 'Overflow',
        color: const RgbColor(24),
      ),
      throwsA(
        isA<StateError>().having(
          (error) => error.message,
          'message',
          'My Colors supports at most 24 colors.',
        ),
      ),
    );
  });

  test('repairs portable JSON when legacy accent import finds My Colors full',
      () async {
    for (var index = 0; index < 24; index++) {
      await repository.addCustomColor(
        name: 'Color $index',
        color: RgbColor(index),
      );
    }
    await _insertActiveTheme(database, primaryColor: 0xFF123456);
    await database.appSettingsDao.setValue(
      AppearanceRepository.portableSettingsKey,
      '{"schemaVersion":999}',
    );

    final portable = await repository.loadPortable();

    expect(portable.accent, const RgbColor(0x123456));
    expect(await repository.listCustomColors(), hasLength(24));
    expect(
      await database.appSettingsDao.getValue(
        AppearanceRepository.portableSettingsKey,
      ),
      contains('"accent":1193046'),
    );
    expect(
      () => repository.addCustomColor(
        name: 'Still full',
        color: const RgbColor(0x654321),
      ),
      throwsA(isA<StateError>()),
    );
  });

  test('deleting a custom color does not change the portable accent', () async {
    final originalAccent = (await repository.loadPortable()).accent;
    final custom = await repository.addCustomColor(
      name: 'Sea',
      color: const RgbColor(0x4D8BB8),
    );

    await repository.deleteCustomColor(custom.id);

    expect(
      (await repository.loadPortable()).accent.value,
      originalAccent.value,
    );
  });

  test('keeps Windows and Android device profiles separate', () async {
    final windows = await repository.loadDeviceProfile('windows');
    await repository.saveDeviceProfile(
      windows.copyWith(
        density: LayoutDensity.compact,
        localBackgroundImageId: 'windows-image',
        backgroundZoom: 2.2,
        hapticsMode: HapticsMode.rich,
      ),
    );

    final android = await repository.loadDeviceProfile('android');

    expect(windows.id, 'test-device:windows');
    expect(android.id, 'test-device:android');
    expect(android.density, LayoutDensity.standard);
    expect(android.localBackgroundImageId, isNull);
    expect(android.backgroundZoom, 1);
    expect(android.hapticsMode, HapticsMode.off);

    final reloadedWindows = await repository.loadDeviceProfile('windows');
    expect(reloadedWindows.density, LayoutDensity.compact);
    expect(reloadedWindows.localBackgroundImageId, 'windows-image');
    expect(reloadedWindows.backgroundZoom, 2.2);
    expect(reloadedWindows.hapticsMode, HapticsMode.rich);
  });
}

const _windowsDevice = DeviceInfo(
  deviceId: 'test-device',
  deviceName: 'Test',
  platform: 'windows',
  appVersion: '1.0.0',
);

Future<void> _insertActiveTheme(
  AppDatabase database, {
  required int primaryColor,
}) {
  return database.themeSchemesDao.upsertTheme(
    ThemeSchemesCompanion(
      id: const Value('legacy-active'),
      name: const Value('Legacy'),
      backgroundColor: const Value(0xFFF8F8F6),
      primaryColor: Value(primaryColor),
      textColor: const Value(0xFF202124),
      surfaceColor: const Value(0xFFFFFFFF),
      brightness: const Value('light'),
      createdAt: const Value(1),
      updatedAt: const Value(1),
      isActive: const Value(true),
    ),
  );
}
