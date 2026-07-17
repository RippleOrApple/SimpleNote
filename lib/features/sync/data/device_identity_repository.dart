import 'dart:convert';
import 'dart:io';

import '../../../core/utils/id_generator.dart';
import '../../../database/app_database.dart';
import '../domain/device_info.dart';

typedef DeviceIdFactory = String Function();

final class DeviceIdentityRepository {
  DeviceIdentityRepository(
    this._database, {
    String? deviceName,
    String? platform,
    String appVersion = '1.0.1',
    DeviceIdFactory createId = IdGenerator.create,
  })  : _deviceName = deviceName ?? Platform.localHostname,
        _platform = platform ?? Platform.operatingSystem,
        _appVersion = appVersion,
        _createId = createId {
    _requireNonBlank(_deviceName, 'deviceName');
    _requireNonBlank(_platform, 'platform');
    _requireNonBlank(_appVersion, 'appVersion');
  }

  static const identitySettingsKey = 'device.identity.v1';

  final AppDatabase _database;
  final String _deviceName;
  final String _platform;
  final String _appVersion;
  final DeviceIdFactory _createId;

  Future<DeviceInfo> loadOrCreate() {
    return _database.transaction(() async {
      final encoded = await _database.appSettingsDao.getValue(
        identitySettingsKey,
      );
      final stored = _decode(encoded);
      if (stored != null) {
        final current = DeviceInfo(
          deviceId: stored.deviceId,
          deviceName: _deviceName,
          platform: _platform,
          appVersion: _appVersion,
        );
        if (stored.deviceName != current.deviceName ||
            stored.platform != current.platform ||
            stored.appVersion != current.appVersion) {
          await _save(current);
        }
        return current;
      }

      final generated = _createId().trim();
      if (generated.isEmpty) {
        throw StateError('The device ID generator returned a blank value.');
      }
      final created = DeviceInfo(
        deviceId: 'local-$generated',
        deviceName: _deviceName,
        platform: _platform,
        appVersion: _appVersion,
      );
      await _save(created);
      return created;
    });
  }

  DeviceInfo? _decode(String? encoded) {
    if (encoded == null) {
      return null;
    }
    try {
      final decoded = jsonDecode(encoded);
      if (decoded is! Map) {
        return null;
      }
      final json = Map<String, Object?>.from(decoded);
      final deviceId = _requiredString(json, 'deviceId');
      final deviceName = _requiredString(json, 'deviceName');
      final platform = _requiredString(json, 'platform');
      final appVersion = _requiredString(json, 'appVersion');
      return DeviceInfo(
        deviceId: deviceId,
        deviceName: deviceName,
        platform: platform,
        appVersion: appVersion,
      );
    } on FormatException {
      return null;
    } on TypeError {
      return null;
    }
  }

  Future<void> _save(DeviceInfo identity) {
    return _database.appSettingsDao.setValue(
      identitySettingsKey,
      jsonEncode(identity.toJson()),
    );
  }
}

String _requiredString(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is! String || value.trim().isEmpty) {
    throw FormatException('$key must be a non-blank string.');
  }
  return value.trim();
}

void _requireNonBlank(String value, String name) {
  if (value.trim().isEmpty) {
    throw ArgumentError.value(value, name, 'Must not be blank.');
  }
}
