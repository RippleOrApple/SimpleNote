import '../../../shared/models/syncable.dart';

class TaskTag implements Syncable {
  const TaskTag({
    required this.id,
    required this.name,
    required this.color,
    required this.createdAt,
    required this.updatedAt,
    required this.deviceId,
    this.deletedAt,
    this.version = 1,
  });

  @override
  final String id;
  final String name;
  final int color;
  @override
  final int createdAt;
  @override
  final int updatedAt;
  @override
  final int? deletedAt;
  @override
  final String deviceId;
  @override
  final int version;

  @override
  bool get isDeleted => deletedAt != null;

  Map<String, Object?> toJson() => {
        'id': id,
        'name': name,
        'color': color,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'deletedAt': deletedAt,
        'deviceId': deviceId,
        'version': version,
      };

  factory TaskTag.fromJson(Map<String, Object?> json) => TaskTag(
        id: json['id']! as String,
        name: json['name']! as String,
        color: json['color']! as int,
        createdAt: json['createdAt']! as int,
        updatedAt: json['updatedAt']! as int,
        deletedAt: json['deletedAt'] as int?,
        deviceId: json['deviceId']! as String,
        version: json['version'] as int? ?? 1,
      );

  TaskTag copyWith({
    String? name,
    int? color,
    int? updatedAt,
    int? deletedAt,
    int? version,
    bool clearDeletedAt = false,
  }) {
    return TaskTag(
      id: id,
      name: name ?? this.name,
      color: color ?? this.color,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: clearDeletedAt ? null : deletedAt ?? this.deletedAt,
      deviceId: deviceId,
      version: version ?? this.version,
    );
  }
}
