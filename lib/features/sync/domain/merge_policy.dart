import '../../../shared/models/syncable.dart';

class MergePolicy {
  const MergePolicy._();

  static T chooseLatest<T extends Syncable>(T local, T remote) {
    final localChangedAt = local.deletedAt ?? local.updatedAt;
    final remoteChangedAt = remote.deletedAt ?? remote.updatedAt;
    return remoteChangedAt > localChangedAt ? remote : local;
  }
}
