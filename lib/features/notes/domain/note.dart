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

  Map<String, Object?> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'deletedAt': deletedAt,
        'pinned': pinned,
        'deviceId': deviceId,
        'version': version,
      };

  factory Note.fromJson(Map<String, Object?> json) {
    return Note(
      id: json['id']! as String,
      title: json['title']! as String,
      content: json['content']! as String,
      createdAt: json['createdAt']! as int,
      updatedAt: json['updatedAt']! as int,
      deletedAt: json['deletedAt'] as int?,
      pinned: json['pinned'] as bool? ?? false,
      deviceId: json['deviceId']! as String,
      version: json['version'] as int? ?? 1,
    );
  }

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
