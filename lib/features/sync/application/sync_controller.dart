import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../data/sync_repository.dart';
import '../domain/sync_result.dart';
import '../infrastructure/local_sync_server.dart';
import '../infrastructure/sync_api_client.dart';

enum SyncStatus { idle, startingServer, serverRunning, syncing, success, error }

final syncApiClientProvider = Provider<SyncApiClient>((ref) {
  return const SyncApiClient();
});

final legacySyncEnabledProvider = Provider<bool>((ref) => false);

final syncControllerProvider =
    StateNotifierProvider<SyncController, SyncState>((ref) {
  return SyncController(
    repository: ref.watch(syncRepositoryProvider),
    client: ref.watch(syncApiClientProvider),
    legacySyncEnabled: ref.watch(legacySyncEnabledProvider),
  );
});

const legacySyncUpgradeMessage = 'V2 同步将在第四阶段启用；当前版本不会启动旧同步协议。';

class SyncState {
  const SyncState({
    this.status = SyncStatus.idle,
    this.serverAddress,
    this.serverPort,
    this.peerAddress = '',
    this.lastResult,
    this.errorMessage,
  });

  final SyncStatus status;
  final String? serverAddress;
  final int? serverPort;
  final String peerAddress;
  final SyncResult? lastResult;
  final String? errorMessage;

  bool get isServerRunning => serverAddress != null && serverPort != null;

  String? get serverUri {
    if (!isServerRunning) {
      return null;
    }
    return 'http://$serverAddress:$serverPort';
  }

  SyncState copyWith({
    SyncStatus? status,
    String? serverAddress,
    bool clearServerAddress = false,
    int? serverPort,
    bool clearServerPort = false,
    String? peerAddress,
    SyncResult? lastResult,
    bool clearLastResult = false,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return SyncState(
      status: status ?? this.status,
      serverAddress:
          clearServerAddress ? null : serverAddress ?? this.serverAddress,
      serverPort: clearServerPort ? null : serverPort ?? this.serverPort,
      peerAddress: peerAddress ?? this.peerAddress,
      lastResult: clearLastResult ? null : lastResult ?? this.lastResult,
      errorMessage:
          clearErrorMessage ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class SyncController extends StateNotifier<SyncState> {
  SyncController({
    required SyncRepository repository,
    required SyncApiClient client,
    required bool legacySyncEnabled,
  })  : _repository = repository,
        _client = client,
        _legacySyncEnabled = legacySyncEnabled,
        _server = LocalSyncServer(repository),
        super(const SyncState());

  final SyncRepository _repository;
  final SyncApiClient _client;
  final bool _legacySyncEnabled;
  final LocalSyncServer _server;

  Future<void> startServer({
    int port = AppConstants.defaultSyncPort,
  }) async {
    if (!_legacySyncEnabled) {
      _rejectLegacySync();
      return;
    }
    state = state.copyWith(
      status: SyncStatus.startingServer,
      clearErrorMessage: true,
    );
    try {
      await _server.start(port: port);
      final displayAddress = await _findLanAddress();
      state = state.copyWith(
        status: SyncStatus.serverRunning,
        serverAddress: displayAddress,
        serverPort: _server.port,
        clearErrorMessage: true,
      );
    } catch (error) {
      state = state.copyWith(
        status: SyncStatus.error,
        errorMessage: error.toString(),
      );
    }
  }

  Future<void> stopServer() async {
    await _server.stop();
    state = state.copyWith(
      status: SyncStatus.idle,
      clearServerAddress: true,
      clearServerPort: true,
    );
  }

  void updatePeerAddress(String value) {
    state = state.copyWith(peerAddress: value);
  }

  Future<void> syncWithPeer([String? address]) async {
    if (!_legacySyncEnabled) {
      _rejectLegacySync();
      return;
    }
    final rawAddress = (address ?? state.peerAddress).trim();
    if (rawAddress.isEmpty) {
      state = state.copyWith(
        status: SyncStatus.error,
        errorMessage: '请输入对端地址。',
      );
      return;
    }

    state = state.copyWith(
      status: SyncStatus.syncing,
      peerAddress: rawAddress,
      clearErrorMessage: true,
      clearLastResult: true,
    );

    try {
      final peerUri = _normalizeUri(rawAddress);
      final healthy = await _client.healthCheck(peerUri);
      if (!healthy) {
        throw StateError('对端健康检查失败。');
      }

      final remoteSnapshot = await _client.snapshot(peerUri);
      final pullResult = await _repository.mergeSnapshot(remoteSnapshot);
      final localSnapshot = await _repository.exportSnapshot();
      final pushResult = await _client.sendSnapshot(peerUri, localSnapshot);

      if (!pushResult.success) {
        throw StateError(pushResult.errorMessage ?? '对端拒绝了同步快照。');
      }

      state = state.copyWith(
        status: SyncStatus.success,
        lastResult: _combineResults(pullResult, pushResult),
        clearErrorMessage: true,
      );
    } catch (error) {
      state = state.copyWith(
        status: SyncStatus.error,
        errorMessage: error.toString(),
      );
    }
  }

  void _rejectLegacySync() {
    state = state.copyWith(
      status: SyncStatus.error,
      errorMessage: legacySyncUpgradeMessage,
      clearLastResult: true,
    );
  }

  @override
  void dispose() {
    _server.stop();
    super.dispose();
  }

  static Uri _normalizeUri(String value) {
    final withScheme =
        value.startsWith('http://') || value.startsWith('https://')
            ? value
            : 'http://$value';
    final uri = Uri.parse(withScheme);
    if (!uri.hasScheme || uri.host.isEmpty) {
      throw FormatException('对端地址无效：$value');
    }
    return uri;
  }

  static Future<String> _findLanAddress() async {
    final interfaces = await NetworkInterface.list(
      includeLoopback: false,
      type: InternetAddressType.IPv4,
    );
    for (final interface in interfaces) {
      for (final address in interface.addresses) {
        return address.address;
      }
    }
    return InternetAddress.loopbackIPv4.address;
  }

  static SyncResult _combineResults(SyncResult local, SyncResult peer) {
    return SyncResult(
      success: local.success && peer.success,
      notesCreated: local.notesCreated + peer.notesCreated,
      notesUpdated: local.notesUpdated + peer.notesUpdated,
      notesDeleted: local.notesDeleted + peer.notesDeleted,
      todosCreated: local.todosCreated + peer.todosCreated,
      todosUpdated: local.todosUpdated + peer.todosUpdated,
      todosDeleted: local.todosDeleted + peer.todosDeleted,
      errorMessage: local.errorMessage ?? peer.errorMessage,
    );
  }
}
