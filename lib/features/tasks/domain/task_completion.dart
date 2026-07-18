import '../../../shared/models/syncable.dart';

class TaskCompletion implements Syncable {
  const TaskCompletion({
    required this.id,
    required this.taskId,
    required this.scheduledAt,
    required this.completedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.deviceId,
    this.deletedAt,
    this.version = 1,
  });

  @override
  final String id;
  final String taskId;
  final int scheduledAt;
  final int completedAt;
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
        'taskId': taskId,
        'scheduledAt': scheduledAt,
        'completedAt': completedAt,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'deletedAt': deletedAt,
        'deviceId': deviceId,
        'version': version,
      };

  factory TaskCompletion.fromJson(Map<String, Object?> json) {
    return TaskCompletion(
      id: _requiredString(json, 'id'),
      taskId: _requiredString(json, 'taskId'),
      scheduledAt: _requiredInt(json, 'scheduledAt'),
      completedAt: _requiredInt(json, 'completedAt'),
      createdAt: _requiredInt(json, 'createdAt'),
      updatedAt: _requiredInt(json, 'updatedAt'),
      deletedAt: json['deletedAt'] as int?,
      deviceId: _requiredString(json, 'deviceId'),
      version: json['version'] as int? ?? 1,
    );
  }

  TaskCompletion copyWith({
    String? id,
    String? taskId,
    int? scheduledAt,
    int? completedAt,
    int? createdAt,
    int? updatedAt,
    int? deletedAt,
    String? deviceId,
    int? version,
    bool clearDeletedAt = false,
  }) {
    return TaskCompletion(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: clearDeletedAt ? null : deletedAt ?? this.deletedAt,
      deviceId: deviceId ?? this.deviceId,
      version: version ?? this.version,
    );
  }
}

String _requiredString(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is! String) throw FormatException('$key must be a string.');
  return value;
}

int _requiredInt(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is! int) throw FormatException('$key must be an integer.');
  return value;
}
