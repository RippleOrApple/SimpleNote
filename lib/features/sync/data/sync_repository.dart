import '../domain/sync_result.dart';
import '../domain/sync_snapshot.dart';

abstract class SyncRepository {
  Future<SyncSnapshot> exportSnapshot();
  Future<SyncResult> mergeSnapshot(SyncSnapshot snapshot);
}
