import '../../../shared/models/syncable.dart';

class Note implements Syncable {
  const Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.deviceId,
    this.deletedAt,
    this.pinned = false,
    this.version = 1,
  });

  @override
  final String id;
  final String title;
  final String content;
  @override
  final int createdAt;
  @override
  final int updatedAt;
  @override
  final int? deletedAt;
  final bool pinned;
  @override
  final String deviceId;
  @override
  final int version;

  @override
  bool get isDeleted => deletedAt != null;

  Note copyWith({
    String? title,
    String? content,
    int? updatedAt,
    int? deletedAt,
    bool? pinned,
    int? version,
  }) {
    return Note(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      pinned: pinned ?? this.pinned,
      deviceId: deviceId,
      version: version ?? this.version,
    );
  }
}
