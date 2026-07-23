import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;

import '../../../core/utils/id_generator.dart';
import '../../../core/utils/time.dart';
import '../../../database/app_database.dart';
import '../../sync/data/sync_repository.dart';
import '../../sync/domain/device_info.dart';
import '../domain/appearance_presets.dart';
import '../domain/appearance_settings.dart';
import '../domain/background_image.dart';
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
  Future<List<BackgroundImage>> listBackgroundImages({
    required Directory rootDirectory,
  });
  Future<BackgroundImage> addOrReuseBackgroundImage({
    required String sha256,
    required String mimeType,
    required int byteSize,
    required int width,
    required int height,
    required String relativePath,
    required String absolutePath,
    required bool syncEnabled,
  });
  Future<bool> hasBackgroundImageWithSha256(String sha256);
  Future<void> deleteBackgroundImage(String id);
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
          name: '导入的颜色',
          color: accent,
          now: Clock.nowMillis(),
          skipIfFull: true,
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
    return _database.transaction(() async {
      return (await _addCustomColor(
        name: name,
        color: color,
        now: Clock.nowMillis(),
      ))!;
    });
  }

  @override
  Future<void> renameCustomColor(String id, String name) {
    return _database.transaction(() async {
      final row = await _database.appearanceDao.customColorById(id);
      if (row == null || row.deletedAt != null) {
        throw StateError('自定义颜色不存在：$id');
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
          '必须且只能包含每个有效的自定义颜色一次。',
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

  @override
  Future<List<BackgroundImage>> listBackgroundImages({
    required Directory rootDirectory,
  }) async {
    if (!p.isAbsolute(rootDirectory.path)) {
      throw ArgumentError.value(
        rootDirectory.path,
        'rootDirectory',
        '必须是绝对路径的应用支持目录。',
      );
    }
    final rows = await _database.appearanceDao.activeBackgroundImages();
    return rows
        .map(
          (row) => _backgroundImageFromRow(
            row,
            absolutePath: p.join(rootDirectory.path, row.relativePath),
          ),
        )
        .toList(growable: false);
  }

  @override
  Future<BackgroundImage> addOrReuseBackgroundImage({
    required String sha256,
    required String mimeType,
    required int byteSize,
    required int width,
    required int height,
    required String relativePath,
    required String absolutePath,
    required bool syncEnabled,
  }) {
    return _database.transaction(() async {
      final existing =
          await _database.appearanceDao.activeBackgroundImageByContent(
        sha256: sha256,
        syncEnabled: syncEnabled,
      );
      if (existing != null) {
        return _backgroundImageFromRow(
          existing,
          absolutePath: absolutePath,
        );
      }

      final now = Clock.nowMillis();
      final backgroundImage = BackgroundImage(
        id: IdGenerator.create(),
        sha256: sha256,
        mimeType: mimeType,
        byteSize: byteSize,
        width: width,
        height: height,
        relativePath: relativePath,
        absolutePath: absolutePath,
        syncEnabled: syncEnabled,
        createdAt: now,
        updatedAt: now,
        deviceId: _device.deviceId,
        version: 1,
      );
      await _database.appearanceDao.upsertBackgroundImage(
        _backgroundImageToCompanion(backgroundImage),
      );
      return backgroundImage;
    });
  }

  @override
  Future<bool> hasBackgroundImageWithSha256(String sha256) async {
    final rows = await _database.appearanceDao.backgroundImagesBySha256(sha256);
    return rows.isNotEmpty;
  }

  @override
  Future<void> deleteBackgroundImage(String id) {
    return _database.transaction(() async {
      final row = await _database.appearanceDao.backgroundImageById(id);
      if (row == null || row.deletedAt != null) {
        return;
      }

      final now = Clock.nowMillis();
      await _database.appearanceDao.upsertBackgroundImage(
        _softDeletedBackgroundImageToCompanion(
          row,
          deletedAt: now,
          deviceId: _device.deviceId,
        ),
      );

      if (row.syncEnabled) {
        final storedPortable = await _database.appSettingsDao.getValue(
          AppearanceRepository.portableSettingsKey,
        );
        final portable = _decodePortable(storedPortable);
        if (portable?.background.kind == BackgroundKind.syncedImage &&
            portable?.background.imageId == id) {
          final pureBackground = AppearancePresets.backgroundColors.contains(
            portable!.lastPureBackground,
          )
              ? BackgroundSelection.presetColor(
                  portable.lastPureBackground,
                )
              : BackgroundSelection.customColor(
                  portable.lastPureBackground,
                );
          await savePortable(
            portable.copyWith(background: pureBackground),
          );
        }
      }

      final profileId = _profileId(_device.platform);
      final profileRow =
          await _database.appearanceDao.deviceProfileById(profileId);
      if (profileRow?.localBackgroundImageId == id) {
        final profile = _deviceProfileFromRow(profileRow!).copyWith(
          clearLocalBackgroundImageId: true,
          updatedAt: now,
        );
        await _database.appearanceDao.upsertDeviceProfile(
          _deviceProfileToCompanion(profile),
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

  Future<CustomColor?> _addCustomColor({
    required String name,
    required RgbColor color,
    required int now,
    bool skipIfFull = false,
  }) async {
    final existing = await listCustomColors();
    for (final entry in existing) {
      if (entry.color.value == color.value) {
        return entry;
      }
    }
    if (existing.length >= 24) {
      if (skipIfFull) {
        return null;
      }
      throw StateError('我的颜色最多支持 24 个。');
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
      throw ArgumentError.value(platform, 'platform', '不能为空。');
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

  static BackgroundImage _backgroundImageFromRow(
    BackgroundImageRow row, {
    required String absolutePath,
  }) {
    return BackgroundImage(
      id: row.id,
      sha256: row.sha256,
      mimeType: row.mimeType,
      byteSize: row.byteSize,
      width: row.width,
      height: row.height,
      relativePath: row.relativePath,
      absolutePath: absolutePath,
      syncEnabled: row.syncEnabled,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      deletedAt: row.deletedAt,
      deviceId: row.deviceId,
      version: row.version,
    );
  }

  static BackgroundImagesCompanion _backgroundImageToCompanion(
    BackgroundImage backgroundImage,
  ) {
    return BackgroundImagesCompanion(
      id: Value(backgroundImage.id),
      sha256: Value(backgroundImage.sha256),
      mimeType: Value(backgroundImage.mimeType),
      byteSize: Value(backgroundImage.byteSize),
      width: Value(backgroundImage.width),
      height: Value(backgroundImage.height),
      relativePath: Value(backgroundImage.relativePath),
      syncEnabled: Value(backgroundImage.syncEnabled),
      createdAt: Value(backgroundImage.createdAt),
      updatedAt: Value(backgroundImage.updatedAt),
      deletedAt: Value(backgroundImage.deletedAt),
      deviceId: Value(backgroundImage.deviceId),
      version: Value(backgroundImage.version),
    );
  }

  static BackgroundImagesCompanion _softDeletedBackgroundImageToCompanion(
    BackgroundImageRow row, {
    required int deletedAt,
    required String deviceId,
  }) {
    return BackgroundImagesCompanion(
      id: Value(row.id),
      sha256: Value(row.sha256),
      mimeType: Value(row.mimeType),
      byteSize: Value(row.byteSize),
      width: Value(row.width),
      height: Value(row.height),
      relativePath: Value(row.relativePath),
      syncEnabled: Value(row.syncEnabled),
      createdAt: Value(row.createdAt),
      updatedAt: Value(deletedAt),
      deletedAt: Value(deletedAt),
      deviceId: Value(deviceId),
      version: Value(row.version + 1),
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
          '未知布局密度：${row.density}。',
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
          '未知触感模式：${row.hapticsMode}。',
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
      throw const FormatException('预期为字符串 JSON 列表。');
    }
    return decoded.cast<String>();
  }
}
