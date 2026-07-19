import '../../../shared/models/syncable.dart';

enum HabitCheckinStatus { done }

class HabitCheckin implements Syncable {
  const HabitCheckin({
    required this.id,
    required this.habitId,
    required this.checkinDay,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.deviceId,
    this.note = '',
    this.deletedAt,
    this.version = 1,
  });

  @override
  final String id;
  final String habitId;
  final int checkinDay;
  final HabitCheckinStatus status;
  final String note;
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
        'habitId': habitId,
        'checkinDay': checkinDay,
        'status': status.name,
        'note': note,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'deletedAt': deletedAt,
        'deviceId': deviceId,
        'version': version,
      };

  factory HabitCheckin.fromJson(Map<String, Object?> json) {
    return HabitCheckin(
      id: _requiredString(json, 'id'),
      habitId: _requiredString(json, 'habitId'),
      checkinDay: _requiredInt(json, 'checkinDay'),
      status: HabitCheckinStatus.values.byName(
        _requiredString(json, 'status'),
      ),
      note: json['note'] as String? ?? '',
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
  if (value is! String) throw FormatException('$key must be a string.');
  return value;
}

int _requiredInt(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is! int) throw FormatException('$key must be an integer.');
  return value;
}
