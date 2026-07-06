import '../../../shared/models/syncable.dart';

enum TodoPriority { low, medium, high }

class Todo implements Syncable {
  const Todo({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    required this.deviceId,
    this.description = '',
    this.completed = false,
    this.dueAt,
    this.priority = TodoPriority.medium,
    this.deletedAt,
    this.version = 1,
  });

  @override
  final String id;
  final String title;
  final String description;
  final bool completed;
  final int? dueAt;
  final TodoPriority priority;
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
        'title': title,
        'description': description,
        'completed': completed,
        'dueAt': dueAt,
        'priority': priority.name,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'deletedAt': deletedAt,
        'deviceId': deviceId,
        'version': version,
      };

  factory Todo.fromJson(Map<String, Object?> json) {
    return Todo(
      id: json['id']! as String,
      title: json['title']! as String,
      description: json['description'] as String? ?? '',
      completed: json['completed'] as bool? ?? false,
      dueAt: json['dueAt'] as int?,
      priority: TodoPriority.values.byName(
        json['priority'] as String? ?? TodoPriority.medium.name,
      ),
      createdAt: json['createdAt']! as int,
      updatedAt: json['updatedAt']! as int,
      deletedAt: json['deletedAt'] as int?,
      deviceId: json['deviceId']! as String,
      version: json['version'] as int? ?? 1,
    );
  }

  Todo copyWith({
    String? title,
    String? description,
    bool? completed,
    int? dueAt,
    TodoPriority? priority,
    int? updatedAt,
    int? deletedAt,
    bool clearDueAt = false,
    int? version,
  }) {
    return Todo(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
      dueAt: clearDueAt ? null : dueAt ?? this.dueAt,
      priority: priority ?? this.priority,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      deviceId: deviceId,
      version: version ?? this.version,
    );
  }
}
