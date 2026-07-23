import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_note/database/app_database.dart';
import 'package:simple_note/features/sync/application/sync_controller.dart';
import 'package:simple_note/features/sync/data/sync_repository.dart';
import 'package:simple_note/features/sync/domain/device_info.dart';
import 'package:simple_note/features/sync/infrastructure/sync_api_client.dart';

void main() {
  test('sync controller starts stops and validates peer address', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final repository = DriftSyncRepository(
      database,
      const DeviceInfo(
        deviceId: 'local',
        deviceName: 'Local',
        platform: 'test',
        appVersion: '0.1.0',
      ),
    );
    final controller = SyncController(
      repository: repository,
      client: const SyncApiClient(),
      legacySyncEnabled: true,
    );
    addTearDown(controller.dispose);

    await controller.startServer(port: 0);
    expect(controller.state.isServerRunning, isTrue);

    await controller.syncWithPeer('');
    expect(controller.state.status, SyncStatus.error);
    expect(controller.state.errorMessage, contains('对端地址'));

    await controller.stopServer();
    expect(controller.state.isServerRunning, isFalse);
  });

  test('production provider blocks the legacy sync protocol', () async {
    final database = AppDatabase(NativeDatabase.memory());
    final container = ProviderContainer(overrides: [
      appDatabaseProvider.overrideWithValue(database),
      deviceInfoProvider.overrideWithValue(const DeviceInfo(
        deviceId: 'production-guard',
        deviceName: 'Guard test',
        platform: 'windows',
        appVersion: '2.0.0',
      )),
    ]);
    addTearDown(() async {
      container.dispose();
      await database.close();
    });
    final controller = container.read(syncControllerProvider.notifier);

    await controller.startServer(port: 0);
    expect(container.read(syncControllerProvider).status, SyncStatus.error);
    expect(
      container.read(syncControllerProvider).errorMessage,
      contains('V2 同步将在第四阶段启用'),
    );
    expect(container.read(syncControllerProvider).isServerRunning, isFalse);

    await controller.syncWithPeer('http://127.0.0.1:8787');
    expect(container.read(syncControllerProvider).status, SyncStatus.error);
    expect(
      container.read(syncControllerProvider).errorMessage,
      contains('V2 同步将在第四阶段启用'),
    );
  });
}
