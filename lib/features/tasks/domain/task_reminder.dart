import '../../../shared/models/syncable.dart';

class TaskReminder implements Syncable {
  const TaskReminder({
    required this.id,
    required this.taskId,
    required this.createdAt,
    required this.updatedAt,
    required this.deviceId,
    this.triggerAt,
    this.offsetMinutes,
    this.firedAt,
    this.deletedAt,
    this.version = 1,
  }) : assert(
          (triggerAt == null) != (offsetMinutes == null),
          '提醒必须且只能使用一种触发类型。',
        );

  @override
  final String id;
  final String taskId;
  final int? triggerAt;
  final int? offsetMinutes;
  final int? firedAt;
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

  bool get isAbsolute => triggerAt != null;
  bool get isRelative => offsetMinutes != null;

  @override
  bool get isDeleted => deletedAt != null;

  Map<String, Object?> toJson() => {
        'id': id,
        'taskId': taskId,
        'triggerAt': triggerAt,
        'offsetMinutes': offsetMinutes,
        'firedAt': firedAt,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'deletedAt': deletedAt,
        'deviceId': deviceId,
        'version': version,
      };

  factory TaskReminder.fromJson(Map<String, Object?> json) {
    return TaskReminder(
      id: _requiredString(json, 'id'),
      taskId: _requiredString(json, 'taskId'),
      triggerAt: json['triggerAt'] as int?,
      offsetMinutes: json['offsetMinutes'] as int?,
      firedAt: json['firedAt'] as int?,
      createdAt: _requiredInt(json, 'createdAt'),
      updatedAt: _requiredInt(json, 'updatedAt'),
      deletedAt: json['deletedAt'] as int?,
      deviceId: _requiredString(json, 'deviceId'),
      version: json['version'] as int? ?? 1,
    );
  }

  TaskReminder copyWith({
    String? id,
    String? taskId,
    int? triggerAt,
    int? offsetMinutes,
    int? firedAt,
    int? createdAt,
    int? updatedAt,
    int? deletedAt,
    String? deviceId,
    int? version,
    bool clearTriggerAt = false,
    bool clearOffsetMinutes = false,
    bool clearFiredAt = false,
    bool clearDeletedAt = false,
  }) {
    return TaskReminder(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      triggerAt: clearTriggerAt ? null : triggerAt ?? this.triggerAt,
      offsetMinutes:
          clearOffsetMinutes ? null : offsetMinutes ?? this.offsetMinutes,
      firedAt: clearFiredAt ? null : firedAt ?? this.firedAt,
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
  if (value is! String) throw FormatException('$key 必须是字符串。');
  return value;
}

int _requiredInt(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is! int) throw FormatException('$key 必须是整数。');
  return value;
}
