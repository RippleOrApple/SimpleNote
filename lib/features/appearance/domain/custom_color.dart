import 'rgb_color.dart';

final class CustomColor {
  factory CustomColor({
    required String id,
    required String name,
    required RgbColor color,
    required int sortOrder,
    required int createdAt,
    required int updatedAt,
    int? deletedAt,
    required String deviceId,
    required int version,
  }) {
    _requireNonBlank(id, 'id');
    _requireNonBlank(name, 'name');
    _requireNonBlank(deviceId, 'deviceId');
    _requireAtLeast(sortOrder, 0, 'sortOrder');
    _requireAtLeast(createdAt, 0, 'createdAt');
    _requireAtLeast(updatedAt, 0, 'updatedAt');
    if (deletedAt != null) {
      _requireAtLeast(deletedAt, 0, 'deletedAt');
    }
    _requireAtLeast(version, 1, 'version');
    return CustomColor._(
      id: id,
      name: name,
      color: color,
      sortOrder: sortOrder,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
      deviceId: deviceId,
      version: version,
    );
  }

  const CustomColor._({
    required this.id,
    required this.name,
    required this.color,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.deviceId,
    required this.version,
  });

  final String id;
  final String name;
  final RgbColor color;
  final int sortOrder;
  final int createdAt;
  final int updatedAt;
  final int? deletedAt;
  final String deviceId;
  final int version;

  CustomColor copyWith({
    String? id,
    String? name,
    RgbColor? color,
    int? sortOrder,
    int? createdAt,
    int? updatedAt,
    int? deletedAt,
    bool clearDeletedAt = false,
    String? deviceId,
    int? version,
  }) {
    return CustomColor(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: clearDeletedAt ? null : deletedAt ?? this.deletedAt,
      deviceId: deviceId ?? this.deviceId,
      version: version ?? this.version,
    );
  }

  Map<String, Object?> toJson() => {
        'id': id,
        'name': name,
        'color': color.value,
        'sortOrder': sortOrder,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'deletedAt': deletedAt,
        'deviceId': deviceId,
        'version': version,
      };

  factory CustomColor.fromJson(Map<String, Object?> json) {
    try {
      return CustomColor(
        id: _requiredString(json, 'id'),
        name: _requiredString(json, 'name'),
        color: _requiredRgb(json, 'color'),
        sortOrder: _requiredInt(json, 'sortOrder'),
        createdAt: _requiredInt(json, 'createdAt'),
        updatedAt: _requiredInt(json, 'updatedAt'),
        deletedAt: _optionalInt(json, 'deletedAt'),
        deviceId: _requiredString(json, 'deviceId'),
        version: _requiredInt(json, 'version'),
      );
    } on FormatException {
      rethrow;
    } on ArgumentError catch (error) {
      throw FormatException('Invalid custom color: $error');
    }
  }

  @override
  bool operator ==(Object other) {
    return other is CustomColor &&
        other.id == id &&
        other.name == name &&
        other.color == color &&
        other.sortOrder == sortOrder &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.deletedAt == deletedAt &&
        other.deviceId == deviceId &&
        other.version == version;
  }

  @override
  int get hashCode => Object.hash(
        id,
        name,
        color,
        sortOrder,
        createdAt,
        updatedAt,
        deletedAt,
        deviceId,
        version,
      );
}

void _requireNonBlank(String value, String name) {
  if (value.trim().isEmpty) {
    throw ArgumentError.value(value, name, 'Must not be blank.');
  }
}

void _requireAtLeast(int value, int minimum, String name) {
  if (value < minimum) {
    throw ArgumentError.value(value, name, 'Must be at least $minimum.');
  }
}

String _requiredString(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is! String) {
    throw FormatException('$key must be a string.');
  }
  return value;
}

int _requiredInt(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is! int) {
    throw FormatException('$key must be an integer.');
  }
  return value;
}

int? _optionalInt(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value != null && value is! int) {
    throw FormatException('$key must be an integer or null.');
  }
  return value as int?;
}

RgbColor _requiredRgb(Map<String, Object?> json, String key) {
  final value = _requiredInt(json, key);
  if (value < 0 || value > 0xFFFFFF) {
    throw FormatException('$key must be a 24-bit integer.');
  }
  return RgbColor(value);
}
