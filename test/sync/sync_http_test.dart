import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_note/database/app_database.dart';
import 'package:simple_note/features/sync/data/sync_repository.dart';
import 'package:simple_note/features/sync/domain/device_info.dart';
import 'package:simple_note/features/sync/domain/sync_snapshot.dart';
import 'package:simple_note/features/sync/infrastructure/local_sync_server.dart';
import 'package:simple_note/features/sync/infrastructure/sync_api_client.dart';

void main() {
  test('legacy compatibility server retains its HTTP contract for tests',
      () async {
    final serverDatabase = AppDatabase(NativeDatabase.memory());
    addTearDown(serverDatabase.close);

    final serverRepository = DriftSyncRepository(
      serverDatabase,
      const DeviceInfo(
        deviceId: 'server',
        deviceName: 'Server',
        platform: 'test',
        appVersion: '0.1.0',
      ),
    );
    final server = LocalSyncServer(serverRepository);
    addTearDown(server.stop);

    await server.start(port: 0);
    final baseUri = Uri.parse('http://127.0.0.1:${server.port}');
    const apiClient = SyncApiClient();

    expect(await apiClient.healthCheck(baseUri), isTrue);
    final device = await apiClient.device(baseUri);
    expect(device.deviceId, 'server');
    final snapshot = await apiClient.snapshot(baseUri);
    expect(snapshot.device.deviceId, 'server');

    final result = await apiClient.sendSnapshot(
      baseUri,
      const SyncSnapshot(
        device: DeviceInfo(
          deviceId: 'client',
          deviceName: 'Client',
          platform: 'test',
          appVersion: '0.1.0',
        ),
        exportedAt: 100,
        notes: [],
        todos: [],
        tags: [],
        themeSchemes: [],
      ),
    );
    expect(result.success, isTrue);
  });
}
