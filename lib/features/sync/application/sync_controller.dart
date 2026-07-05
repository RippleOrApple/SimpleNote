import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SyncStatus { idle, startingServer, syncing, success, error }

final syncControllerProvider =
    StateNotifierProvider<SyncController, SyncStatus>((ref) {
  return SyncController();
});

class SyncController extends StateNotifier<SyncStatus> {
  SyncController() : super(SyncStatus.idle);

  Future<void> startServer() async {
    state = SyncStatus.startingServer;
    state = SyncStatus.success;
  }

  Future<void> syncWithPeer(String address) async {
    state = SyncStatus.syncing;
    if (address.trim().isEmpty) {
      state = SyncStatus.error;
      return;
    }
    state = SyncStatus.success;
  }
}
