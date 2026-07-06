import 'package:drift/native.dart';
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
    );
    addTearDown(controller.dispose);

    await controller.startServer(port: 0);
    expect(controller.state.isServerRunning, isTrue);

    await controller.syncWithPeer('');
    expect(controller.state.status, SyncStatus.error);
    expect(controller.state.errorMessage, contains('Peer address'));

    await controller.stopServer();
    expect(controller.state.isServerRunning, isFalse);
  });
}
