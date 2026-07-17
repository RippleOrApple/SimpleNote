import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/id_generator.dart';
import '../../../core/utils/time.dart';
import '../../../database/app_database.dart';
import '../../sync/data/sync_repository.dart';
import '../../sync/domain/device_info.dart';
import '../domain/appearance_presets.dart';
import '../domain/appearance_settings.dart';
import '../domain/custom_color.dart';
import '../domain/device_appearance_profile.dart';
import '../domain/rgb_color.dart';

final appearanceRepositoryProvider = Provider<AppearanceRepository>((ref) {
  return DriftAppearanceRepository(
    ref.watch(appDatabaseProvider),
    ref.watch(deviceInfoProvider),
  );
});

abstract class AppearanceRepository {
  static const portableSettingsKey = 'appearance.v2.portable';

  Future<AppearanceSettings> loadPortable();
  Future<void> savePortable(AppearanceSettings settings);
  Future<DeviceAppearanceProfile> loadDeviceProfile(String platform);
  Future<void> saveDeviceProfile(DeviceAppearanceProfile profile);
  Future<List<CustomColor>> listCustomColors();
  Future<CustomColor> addCustomColor({
    required String name,
    required RgbColor color,
  });
  Future<void> renameCustomColor(String id, String name);
  Future<void> reorderCustomColors(List<String> orderedIds);
  Future<void> deleteCustomColor(String id);
}

final class DriftAppearanceRepository implements AppearanceRepository {
  const DriftAppearanceRepository(this._database, this._device);

  final AppDatabase _database;
  final DeviceInfo _device;

  @override
  Future<AppearanceSettings> loadPortable() async {
    final stored = await _database.appSettingsDao.getValue(
      AppearanceRepository.portableSettingsKey,
    );
    final decoded = _decodePortable(stored);
    if (decoded != null) {
      return decoded;
    }

    return _database.transaction(() async {
      final current = await _database.appSettingsDao.getValue(
        AppearanceRepository.portableSettingsKey,
      );
      final concurrentlyInitialized = _decodePortable(current);
      if (concurrentlyInitialized != null) {
        return concurrentlyInitialized;
      }

      final legacy = await _database.themeSchemesDao.activeTheme();
      final accent = legacy == null
          ? AppearanceSettings.defaults().accent
          : RgbColor(legacy.primaryColor & 0xFFFFFF);
      final portable = AppearanceSettings.defaults().copyWith(accent: accent);

      if (!AppearancePresets.accentColors.contains(accent)) {
        await _addCustomColor(
          name: 'Imported color',
          color: accent,
          now: Clock.nowMillis(),
        );
      }
      await savePortable(portable);
      await _loadOrCreateDeviceProfile(_device.platform);
      return portable;
    });
  }

  @override
  Future<void> savePortable(AppearanceSettings settings) {
    return _database.appSettingsDao.setValue(
      AppearanceRepository.portableSettingsKey,
      jsonEncode(settings.toJson()),
    );
  }

  @override
  Future<DeviceAppearanceProfile> loadDeviceProfile(String platform) {
    return _database.transaction(() => _loadOrCreateDeviceProfile(platform));
  }

  @override
  Future<void> saveDeviceProfile(DeviceAppearanceProfile profile) {
    final canonical = profile.copyWith(
      id: _profileId(profile.platform),
      platform: profile.platform.trim(),
    );
    return _database.appearanceDao.upsertDeviceProfile(
      _deviceProfileToCompanion(canonical),
    );
  }

  @override
  Future<List<CustomColor>> listCustomColors() async {
    final rows = await _database.appearanceDao.activeCustomColors();
    return rows.map(_customColorFromRow).toList(growable: false);
  }

  @override
  Future<CustomColor> addCustomColor({
    required String name,
    required RgbColor color,
  }) {
    return _database.transaction(
      () => _addCustomColor(
        name: name,
        color: color,
        now: Clock.nowMillis(),
      ),
    );
  }

  @override
  Future<void> renameCustomColor(String id, String name) {
    return _database.transaction(() async {
      final row = await _database.appearanceDao.customColorById(id);
      if (row == null || row.deletedAt != null) {
        throw StateError('Custom color not found: $id');
      }
      final renamed = _customColorFromRow(row).copyWith(
        name: name.trim(),
        updatedAt: Clock.nowMillis(),
        deviceId: _device.deviceId,
        version: row.version + 1,
      );
      await _database.appearanceDao.upsertCustomColor(
        _customColorToCompanion(renamed),
      );
    });
  }

  @override
  Future<void> reorderCustomColors(List<String> orderedIds) {
    return _database.transaction(() async {
      final existing = await listCustomColors();
      final normalizedIds = <String>[];
      final seen = <String>{};
      for (final id in orderedIds) {
        final normalized = id.trim();
        if (normalized.isNotEmpty && seen.add(normalized)) {
          normalizedIds.add(normalized);
        }
      }
      final existingIds = existing.map((entry) => entry.id).toSet();
      if (normalizedIds.length != existing.length ||
          !existingIds.containsAll(normalizedIds)) {
        throw ArgumentError.value(
          orderedIds,
          'orderedIds',
          'Must contain every active custom color exactly once.',
        );
      }
      final byId = {for (final entry in existing) entry.id: entry};
      final now = Clock.nowMillis();
      for (var index = 0; index < normalizedIds.length; index++) {
        final entry = byId[normalizedIds[index]]!;
        if (entry.sortOrder == index) {
          continue;
        }
        await _database.appearanceDao.upsertCustomColor(
          _customColorToCompanion(
            entry.copyWith(
              sortOrder: index,
              updatedAt: now,
              deviceId: _device.deviceId,
              version: entry.version + 1,
            ),
          ),
        );
      }
    });
  }

  @override
  Future<void> deleteCustomColor(String id) {
    return _database.transaction(() async {
      final row = await _database.appearanceDao.customColorById(id);
      if (row == null || row.deletedAt != null) {
        return;
      }
      final now = Clock.nowMillis();
      await _database.appearanceDao.upsertCustomColor(
        _customColorToCompanion(
          _customColorFromRow(row).copyWith(
            deletedAt: now,
            updatedAt: now,
            deviceId: _device.deviceId,
            version: row.version + 1,
          ),
        ),
      );
      final remaining = await listCustomColors();
      for (var index = 0; index < remaining.length; index++) {
        final entry = remaining[index];
        if (entry.sortOrder == index) {
          continue;
        }
        await _database.appearanceDao.upsertCustomColor(
          _customColorToCompanion(
            entry.copyWith(
              sortOrder: index,
              updatedAt: now,
              deviceId: _device.deviceId,
              version: entry.version + 1,
            ),
          ),
        );
      }
    });
  }

  AppearanceSettings? _decodePortable(String? stored) {
    if (stored == null) {
      return null;
    }
    try {
      final decoded = jsonDecode(stored);
      if (decoded is! Map) {
        return null;
      }
      return AppearanceSettings.fromJson(
        Map<String, Object?>.from(decoded),
      );
    } on FormatException {
      return null;
    } on TypeError {
      return null;
    }
  }

  Future<CustomColor> _addCustomColor({
    required String name,
    required RgbColor color,
    required int now,
  }) async {
    final existing = await listCustomColors();
    for (final entry in existing) {
      if (entry.color.value == color.value) {
        return entry;
      }
    }
    if (existing.length >= 24) {
      throw StateError('My Colors supports at most 24 colors.');
    }
    final custom = CustomColor(
      id: IdGenerator.create(),
      name: name.trim(),
      color: color,
      sortOrder: existing.length,
      createdAt: now,
      updatedAt: now,
      deviceId: _device.deviceId,
      version: 1,
    );
    await _database.appearanceDao.upsertCustomColor(
      _customColorToCompanion(custom),
    );
    return custom;
  }

  Future<DeviceAppearanceProfile> _loadOrCreateDeviceProfile(
    String platform,
  ) async {
    final normalizedPlatform = platform.trim();
    if (normalizedPlatform.isEmpty) {
      throw ArgumentError.value(platform, 'platform', 'Must not be blank.');
    }
    final id = _profileId(normalizedPlatform);
    final row = await _database.appearanceDao.deviceProfileById(id);
    if (row != null) {
      try {
        return _deviceProfileFromRow(row);
      } on FormatException {
        // Repository-owned fallback keeps malformed older profiles readable.
      } on ArgumentError {
        // Repository-owned fallback keeps malformed older profiles readable.
      }
    }
    final defaults = DeviceAppearanceProfile.defaults(
      id: id,
      platform: normalizedPlatform,
      updatedAt: Clock.nowMillis(),
    );
    await _database.appearanceDao.upsertDeviceProfile(
      _deviceProfileToCompanion(defaults),
    );
    return defaults;
  }

  String _profileId(String platform) =>
      '${_device.deviceId}:${platform.trim()}';

  static CustomColor _customColorFromRow(CustomColorRow row) {
    return CustomColor(
      id: row.id,
      name: row.name,
      color: RgbColor(row.rgb),
      sortOrder: row.sortOrder,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      deletedAt: row.deletedAt,
      deviceId: row.deviceId,
      version: row.version,
    );
  }

  static CustomColorsCompanion _customColorToCompanion(CustomColor color) {
    return CustomColorsCompanion(
      id: Value(color.id),
      name: Value(color.name),
      rgb: Value(color.color.value),
      sortOrder: Value(color.sortOrder),
      createdAt: Value(color.createdAt),
      updatedAt: Value(color.updatedAt),
      deletedAt: Value(color.deletedAt),
      deviceId: Value(color.deviceId),
      version: Value(color.version),
    );
  }

  static DeviceAppearanceProfile _deviceProfileFromRow(
    DeviceAppearanceProfileRow row,
  ) {
    return DeviceAppearanceProfile(
      id: row.id,
      platform: row.platform,
      density: LayoutDensity.values.firstWhere(
        (value) => value.name == row.density,
        orElse: () => throw FormatException(
          'Unknown LayoutDensity: ${row.density}.',
        ),
      ),
      navOrder: _decodeStringList(row.navOrderJson),
      hiddenNav: _decodeStringList(row.hiddenNavJson),
      startModule: row.startModule,
      localBackgroundImageId: row.localBackgroundImageId,
      backgroundFocusX: row.backgroundFocusX,
      backgroundFocusY: row.backgroundFocusY,
      backgroundZoom: row.backgroundZoom,
      backgroundBlur: row.backgroundBlur,
      backgroundOverlay: row.backgroundOverlay,
      hapticsMode: HapticsMode.values.firstWhere(
        (value) => value.name == row.hapticsMode,
        orElse: () => throw FormatException(
          'Unknown HapticsMode: ${row.hapticsMode}.',
        ),
      ),
      updatedAt: row.updatedAt,
    );
  }

  static DeviceAppearanceProfilesCompanion _deviceProfileToCompanion(
    DeviceAppearanceProfile profile,
  ) {
    final sortedHidden = profile.hiddenNav.toList()..sort();
    return DeviceAppearanceProfilesCompanion(
      id: Value(profile.id),
      platform: Value(profile.platform),
      density: Value(profile.density.name),
      navOrderJson: Value(jsonEncode(profile.navOrder)),
      hiddenNavJson: Value(jsonEncode(sortedHidden)),
      startModule: Value(profile.startModule),
      localBackgroundImageId: Value(profile.localBackgroundImageId),
      backgroundFocusX: Value(profile.backgroundFocusX),
      backgroundFocusY: Value(profile.backgroundFocusY),
      backgroundZoom: Value(profile.backgroundZoom),
      backgroundBlur: Value(profile.backgroundBlur),
      backgroundOverlay: Value(profile.backgroundOverlay),
      hapticsMode: Value(profile.hapticsMode.name),
      updatedAt: Value(profile.updatedAt),
    );
  }

  static List<String> _decodeStringList(String encoded) {
    final decoded = jsonDecode(encoded);
    if (decoded is! List || decoded.any((value) => value is! String)) {
      throw const FormatException('Expected a JSON list of strings.');
    }
    return decoded.cast<String>();
  }
}
