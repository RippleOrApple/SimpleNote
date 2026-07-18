import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:simple_note/database/app_database.dart';
import 'package:simple_note/features/sync/data/device_identity_repository.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() => database.close());

  test('reuses one durable device ID across repository reconstruction',
      () async {
    final previousWarningSetting =
        driftRuntimeOptions.dontWarnAboutMultipleDatabases;
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    addTearDown(() {
      driftRuntimeOptions.dontWarnAboutMultipleDatabases =
          previousWarningSetting;
    });
    final directory = await Directory.systemTemp.createTemp(
      'simple_note_identity_',
    );
    final databaseFile = File(p.join(directory.path, 'identity.sqlite'));
    final firstDatabase = AppDatabase(NativeDatabase(databaseFile));
    final firstRepository = DeviceIdentityRepository(
      firstDatabase,
      deviceName: 'Windows PC',
      platform: 'windows',
      appVersion: '1.0.0',
      createId: () => 'first-id',
    );

    final first = await firstRepository.loadOrCreate();
    await firstDatabase.close();

    final reconstructedDatabase = AppDatabase(NativeDatabase(databaseFile));
    addTearDown(() async {
      await reconstructedDatabase.close();
      await directory.delete(recursive: true);
    });
    final reconstructed = await DeviceIdentityRepository(
      reconstructedDatabase,
      deviceName: 'Renamed PC',
      platform: 'windows',
      appVersion: '1.0.1',
      createId: () => 'must-not-be-used',
    ).loadOrCreate();

    expect(first.deviceId, 'local-first-id');
    expect(reconstructed.deviceId, first.deviceId);
    expect(reconstructed.deviceName, 'Renamed PC');
    expect(reconstructed.platform, 'windows');
    expect(reconstructed.appVersion, '1.0.1');

    final stored = await reconstructedDatabase.appSettingsDao.getValue(
      DeviceIdentityRepository.identitySettingsKey,
    );
    expect(
      jsonDecode(stored!)['deviceId'],
      first.deviceId,
    );
  });

  test('replaces malformed persisted identity JSON', () async {
    await database.appSettingsDao.setValue(
      DeviceIdentityRepository.identitySettingsKey,
      '{"deviceId":42}',
    );
    final repository = DeviceIdentityRepository(
      database,
      deviceName: 'Android Phone',
      platform: 'android',
      appVersion: '1.0.0',
      createId: () => 'replacement-id',
    );

    final recovered = await repository.loadOrCreate();

    expect(recovered.deviceId, 'local-replacement-id');
    expect(recovered.deviceName, 'Android Phone');
    expect(recovered.platform, 'android');
    expect(recovered.appVersion, '1.0.0');
    final stored = await database.appSettingsDao.getValue(
      DeviceIdentityRepository.identitySettingsKey,
    );
    expect(
      jsonDecode(stored!),
      recovered.toJson(),
    );
  });

  test('keeps a valid device ID when other identity fields are malformed',
      () async {
    final malformedIdentities = [
      <String, Object?>{'deviceId': 'local-stable-id'},
      <String, Object?>{
        'deviceId': 'local-stable-id',
        'deviceName': 42,
        'platform': null,
        'appVersion': false,
      },
    ];

    for (final malformed in malformedIdentities) {
      await database.appSettingsDao.setValue(
        DeviceIdentityRepository.identitySettingsKey,
        jsonEncode(malformed),
      );
      final identity = await DeviceIdentityRepository(
        database,
        deviceName: 'Current device',
        platform: 'windows',
        appVersion: '1.0.1',
        createId: () => throw StateError('Must preserve the stored ID.'),
      ).loadOrCreate();

      expect(identity.deviceId, 'local-stable-id');
      expect(identity.deviceName, 'Current device');
      expect(identity.platform, 'windows');
      expect(identity.appVersion, '1.0.1');
      expect(
        jsonDecode(
          (await database.appSettingsDao.getValue(
            DeviceIdentityRepository.identitySettingsKey,
          ))!,
        ),
        identity.toJson(),
      );
    }
  });
}
