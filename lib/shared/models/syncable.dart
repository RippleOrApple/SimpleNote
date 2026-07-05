abstract class Syncable {
  String get id;
  int get createdAt;
  int get updatedAt;
  int? get deletedAt;
  String get deviceId;
  int get version;

  bool get isDeleted => deletedAt != null;
}
