import 'dart:convert';

import '../../../shared/models/syncable.dart';
import 'task.dart';
import 'task_sort_mode.dart';

class TaskFilterRules {
  const TaskFilterRules({
    this.listIds = const {},
    this.tagIds = const {},
    this.completed,
    this.priorities = const {},
  });

  final Set<String> listIds;
  final Set<String> tagIds;
  final bool? completed;
  final Set<TaskPriority> priorities;

  Map<String, Object?> toJson() => {
        'listIds': listIds.toList()..sort(),
        'tagIds': tagIds.toList()..sort(),
        'completed': completed,
        'priorities': priorities.map((value) => value.name).toList()..sort(),
      };

  factory TaskFilterRules.fromJson(Map<String, Object?> json) {
    return TaskFilterRules(
      listIds: _stringSet(json['listIds']),
      tagIds: _stringSet(json['tagIds']),
      completed: json['completed'] as bool?,
      priorities: {
        for (final value in (json['priorities'] as List? ?? const []))
          TaskPriority.values.byName(value as String),
      },
    );
  }
}

class SmartFilter implements Syncable {
  const SmartFilter({
    required this.id,
    required this.name,
    required this.rules,
    required this.sortMode,
    required this.createdAt,
    required this.updatedAt,
    required this.deviceId,
    this.sortOrder = 0,
    this.pinned = false,
    this.deletedAt,
    this.version = 1,
  });

  @override
  final String id;
  final String name;
  final TaskFilterRules rules;
  final TaskSortMode sortMode;
  final int sortOrder;
  final bool pinned;
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
        'rules': rules.toJson(),
        'sortMode': sortMode.name,
        'sortOrder': sortOrder,
        'pinned': pinned,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'deletedAt': deletedAt,
        'deviceId': deviceId,
        'version': version,
      };

  factory SmartFilter.fromJson(Map<String, Object?> json) => SmartFilter(
        id: json['id']! as String,
        name: json['name']! as String,
        rules: TaskFilterRules.fromJson(
          (json['rules']! as Map).cast<String, Object?>(),
        ),
        sortMode: TaskSortMode.values.byName(
          json['sortMode']! as String,
        ),
        sortOrder: json['sortOrder'] as int? ?? 0,
        pinned: json['pinned'] as bool? ?? false,
        createdAt: json['createdAt']! as int,
        updatedAt: json['updatedAt']! as int,
        deletedAt: json['deletedAt'] as int?,
        deviceId: json['deviceId']! as String,
        version: json['version'] as int? ?? 1,
      );

  String get rulesJson => jsonEncode(rules.toJson());
}

Set<String> _stringSet(Object? value) {
  return {
    for (final item in (value as List? ?? const [])) item as String,
  };
}
