import 'dart:convert';

import '../../../shared/models/syncable.dart';
import 'habit_schedule.dart';

class Habit implements Syncable {
  const Habit({
    required this.id,
    required this.name,
    required this.iconKey,
    required this.color,
    required this.schedule,
    required this.createdAt,
    required this.updatedAt,
    required this.deviceId,
    this.prompt = '',
    this.sortOrder = 0,
    this.archived = false,
    this.deletedAt,
    this.version = 1,
  });

  @override
  final String id;
  final String name;
  final String prompt;
  final String iconKey;
  final int color;
  final HabitSchedule schedule;
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

  String get scheduleType => schedule.type.name;
  String get scheduleJson => jsonEncode(schedule.toJson());

  Map<String, Object?> toJson() => {
        'id': id,
        'name': name,
        'prompt': prompt,
        'iconKey': iconKey,
        'color': color,
        'scheduleType': scheduleType,
        'scheduleJson': schedule.toJson(),
        'sortOrder': sortOrder,
        'archived': archived,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'deletedAt': deletedAt,
        'deviceId': deviceId,
        'version': version,
      };

  factory Habit.fromJson(Map<String, Object?> json) {
    final scheduleJson = json['scheduleJson'];
    final scheduleMap = scheduleJson is Map
        ? scheduleJson.cast<String, Object?>()
        : throw const FormatException('scheduleJson 必须是对象。');
    return Habit(
      id: _requiredString(json, 'id'),
      name: _requiredString(json, 'name'),
      prompt: json['prompt'] as String? ?? '',
      iconKey: _requiredString(json, 'iconKey'),
      color: _requiredInt(json, 'color'),
      schedule: HabitSchedule.fromJson(
        _requiredString(json, 'scheduleType'),
        scheduleMap,
      ),
      sortOrder: json['sortOrder'] as int? ?? 0,
      archived: json['archived'] as bool? ?? false,
      createdAt: _requiredInt(json, 'createdAt'),
      updatedAt: _requiredInt(json, 'updatedAt'),
      deletedAt: json['deletedAt'] as int?,
      deviceId: _requiredString(json, 'deviceId'),
      version: json['version'] as int? ?? 1,
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
