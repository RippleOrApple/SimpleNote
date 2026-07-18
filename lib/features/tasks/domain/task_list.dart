import '../../../shared/models/syncable.dart';

class TaskList implements Syncable {
  const TaskList({
    required this.id,
    required this.name,
    required this.color,
    required this.iconKey,
    required this.createdAt,
    required this.updatedAt,
    required this.deviceId,
    this.sortOrder = 0,
    this.archived = false,
    this.deletedAt,
    this.version = 1,
  });

  @override
  final String id;
  final String name;
  final int color;
  final String iconKey;
  final int sortOrder;
  final bool archived;
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
        'iconKey': iconKey,
        'sortOrder': sortOrder,
        'archived': archived,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'deletedAt': deletedAt,
        'deviceId': deviceId,
        'version': version,
      };

  factory TaskList.fromJson(Map<String, Object?> json) => TaskList(
        id: json['id']! as String,
        name: json['name']! as String,
        color: json['color']! as int,
        iconKey: json['iconKey']! as String,
        sortOrder: json['sortOrder'] as int? ?? 0,
        archived: json['archived'] as bool? ?? false,
        createdAt: json['createdAt']! as int,
        updatedAt: json['updatedAt']! as int,
        deletedAt: json['deletedAt'] as int?,
        deviceId: json['deviceId']! as String,
        version: json['version'] as int? ?? 1,
      );

  TaskList copyWith({
    String? name,
    int? color,
    String? iconKey,
    int? sortOrder,
    bool? archived,
    int? updatedAt,
    int? deletedAt,
    int? version,
    bool clearDeletedAt = false,
  }) {
    return TaskList(
      id: id,
      name: name ?? this.name,
      color: color ?? this.color,
      iconKey: iconKey ?? this.iconKey,
      sortOrder: sortOrder ?? this.sortOrder,
      archived: archived ?? this.archived,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: clearDeletedAt ? null : deletedAt ?? this.deletedAt,
      deviceId: deviceId,
      version: version ?? this.version,
    );
  }
}
