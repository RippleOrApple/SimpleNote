import '../../../shared/models/syncable.dart';

enum TaskPriority { none, low, medium, high }

class Task implements Syncable {
  const Task({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    required this.deviceId,
    this.parentId,
    this.listId,
    this.descriptionMarkdown = '',
    this.completed = false,
    this.priority = TaskPriority.none,
    this.startAt,
    this.dueAt,
    this.allDay = false,
    this.sortOrder = 0,
    this.recurrenceRule,
    this.recurrenceEndAt,
    this.recurrenceCount,
    this.completedAt,
    this.deletedAt,
    this.version = 1,
  });

  @override
  final String id;
  final String? parentId;
  final String? listId;
  final String title;
  final String descriptionMarkdown;
  final bool completed;
  final TaskPriority priority;
  final int? startAt;
  final int? dueAt;
  final bool allDay;
  final int sortOrder;
  final String? recurrenceRule;
  final int? recurrenceEndAt;
  final int? recurrenceCount;
  final int? completedAt;
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
        'parentId': parentId,
        'listId': listId,
        'title': title,
        'descriptionMarkdown': descriptionMarkdown,
        'completed': completed,
        'priority': priority.name,
        'startAt': startAt,
        'dueAt': dueAt,
        'allDay': allDay,
        'sortOrder': sortOrder,
        'recurrenceRule': recurrenceRule,
        'recurrenceEndAt': recurrenceEndAt,
        'recurrenceCount': recurrenceCount,
        'completedAt': completedAt,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'deletedAt': deletedAt,
        'deviceId': deviceId,
        'version': version,
      };

  factory Task.fromJson(Map<String, Object?> json) {
    return Task(
      id: _requiredString(json, 'id'),
      parentId: json['parentId'] as String?,
      listId: json['listId'] as String?,
      title: _requiredString(json, 'title'),
      descriptionMarkdown: json['descriptionMarkdown'] as String? ?? '',
      completed: json['completed'] as bool? ?? false,
      priority: TaskPriority.values.byName(
        json['priority'] as String? ?? TaskPriority.none.name,
      ),
      startAt: json['startAt'] as int?,
      dueAt: json['dueAt'] as int?,
      allDay: json['allDay'] as bool? ?? false,
      sortOrder: json['sortOrder'] as int? ?? 0,
      recurrenceRule: json['recurrenceRule'] as String?,
      recurrenceEndAt: json['recurrenceEndAt'] as int?,
      recurrenceCount: json['recurrenceCount'] as int?,
      completedAt: json['completedAt'] as int?,
      createdAt: _requiredInt(json, 'createdAt'),
      updatedAt: _requiredInt(json, 'updatedAt'),
      deletedAt: json['deletedAt'] as int?,
      deviceId: _requiredString(json, 'deviceId'),
      version: json['version'] as int? ?? 1,
    );
  }

  Task copyWith({
    String? id,
    String? parentId,
    String? listId,
    String? title,
    String? descriptionMarkdown,
    bool? completed,
    TaskPriority? priority,
    int? startAt,
    int? dueAt,
    bool? allDay,
    int? sortOrder,
    String? recurrenceRule,
    int? recurrenceEndAt,
    int? recurrenceCount,
    int? completedAt,
    int? createdAt,
    int? updatedAt,
    int? deletedAt,
    String? deviceId,
    int? version,
    bool clearParentId = false,
    bool clearListId = false,
    bool clearStartAt = false,
    bool clearDueAt = false,
    bool clearRecurrenceRule = false,
    bool clearRecurrenceEndAt = false,
    bool clearRecurrenceCount = false,
    bool clearCompletedAt = false,
    bool clearDeletedAt = false,
  }) {
    return Task(
      id: id ?? this.id,
      parentId: clearParentId ? null : parentId ?? this.parentId,
      listId: clearListId ? null : listId ?? this.listId,
      title: title ?? this.title,
      descriptionMarkdown: descriptionMarkdown ?? this.descriptionMarkdown,
      completed: completed ?? this.completed,
      priority: priority ?? this.priority,
      startAt: clearStartAt ? null : startAt ?? this.startAt,
      dueAt: clearDueAt ? null : dueAt ?? this.dueAt,
      allDay: allDay ?? this.allDay,
      sortOrder: sortOrder ?? this.sortOrder,
      recurrenceRule:
          clearRecurrenceRule ? null : recurrenceRule ?? this.recurrenceRule,
      recurrenceEndAt:
          clearRecurrenceEndAt ? null : recurrenceEndAt ?? this.recurrenceEndAt,
      recurrenceCount:
          clearRecurrenceCount ? null : recurrenceCount ?? this.recurrenceCount,
      completedAt: clearCompletedAt ? null : completedAt ?? this.completedAt,
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
