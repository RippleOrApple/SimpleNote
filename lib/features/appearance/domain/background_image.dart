final class BackgroundImage {
  factory BackgroundImage({
    required String id,
    required String sha256,
    required String mimeType,
    required int byteSize,
    required int width,
    required int height,
    required String relativePath,
    required String absolutePath,
    required bool syncEnabled,
    required int createdAt,
    required int updatedAt,
    int? deletedAt,
    required String deviceId,
    required int version,
  }) {
    for (final entry in {
      'id': id,
      'mimeType': mimeType,
      'relativePath': relativePath,
      'absolutePath': absolutePath,
      'deviceId': deviceId,
    }.entries) {
      _requireNonBlank(entry.value, entry.key);
    }
    if (!RegExp(r'^[0-9a-f]{64}$').hasMatch(sha256)) {
      throw ArgumentError.value(
        sha256,
        'sha256',
        'Must be a lowercase hexadecimal SHA-256.',
      );
    }
    _requireAtLeast(byteSize, 1, 'byteSize');
    _requireAtLeast(width, 1, 'width');
    _requireAtLeast(height, 1, 'height');
    _requireAtLeast(createdAt, 0, 'createdAt');
    _requireAtLeast(updatedAt, 0, 'updatedAt');
    if (deletedAt != null) {
      _requireAtLeast(deletedAt, 0, 'deletedAt');
    }
    _requireAtLeast(version, 1, 'version');
    return BackgroundImage._(
      id: id,
      sha256: sha256,
      mimeType: mimeType,
      byteSize: byteSize,
      width: width,
      height: height,
      relativePath: relativePath,
      absolutePath: absolutePath,
      syncEnabled: syncEnabled,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
      deviceId: deviceId,
      version: version,
    );
  }

  const BackgroundImage._({
    required this.id,
    required this.sha256,
    required this.mimeType,
    required this.byteSize,
    required this.width,
    required this.height,
    required this.relativePath,
    required this.absolutePath,
    required this.syncEnabled,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.deviceId,
    required this.version,
  });

  final String id;
  final String sha256;
  final String mimeType;
  final int byteSize;
  final int width;
  final int height;
  final String relativePath;
  final String absolutePath;
  final bool syncEnabled;
  final int createdAt;
  final int updatedAt;
  final int? deletedAt;
  final String deviceId;
  final int version;

  BackgroundImage copyWith({
    String? id,
    String? sha256,
    String? mimeType,
    int? byteSize,
    int? width,
    int? height,
    String? relativePath,
    String? absolutePath,
    bool? syncEnabled,
    int? createdAt,
    int? updatedAt,
    int? deletedAt,
    bool clearDeletedAt = false,
    String? deviceId,
    int? version,
  }) {
    return BackgroundImage(
      id: id ?? this.id,
      sha256: sha256 ?? this.sha256,
      mimeType: mimeType ?? this.mimeType,
      byteSize: byteSize ?? this.byteSize,
      width: width ?? this.width,
      height: height ?? this.height,
      relativePath: relativePath ?? this.relativePath,
      absolutePath: absolutePath ?? this.absolutePath,
      syncEnabled: syncEnabled ?? this.syncEnabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: clearDeletedAt ? null : deletedAt ?? this.deletedAt,
      deviceId: deviceId ?? this.deviceId,
      version: version ?? this.version,
    );
  }

  Map<String, Object?> toJson() => {
        'id': id,
        'sha256': sha256,
        'mimeType': mimeType,
        'byteSize': byteSize,
        'width': width,
        'height': height,
        'relativePath': relativePath,
        'syncEnabled': syncEnabled,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'deletedAt': deletedAt,
        'deviceId': deviceId,
        'version': version,
      };

  factory BackgroundImage.fromJson(
    Map<String, Object?> json, {
    required String absolutePath,
  }) {
    try {
      return BackgroundImage(
        id: _requiredString(json, 'id'),
        sha256: _requiredString(json, 'sha256'),
        mimeType: _requiredString(json, 'mimeType'),
        byteSize: _requiredInt(json, 'byteSize'),
        width: _requiredInt(json, 'width'),
        height: _requiredInt(json, 'height'),
        relativePath: _requiredString(json, 'relativePath'),
        absolutePath: absolutePath,
        syncEnabled: _requiredBool(json, 'syncEnabled'),
        createdAt: _requiredInt(json, 'createdAt'),
        updatedAt: _requiredInt(json, 'updatedAt'),
        deletedAt: _optionalInt(json, 'deletedAt'),
        deviceId: _requiredString(json, 'deviceId'),
        version: _requiredInt(json, 'version'),
      );
    } on FormatException {
      rethrow;
    } on ArgumentError catch (error) {
      throw FormatException('Invalid background image: $error');
    }
  }

  @override
  bool operator ==(Object other) {
    return other is BackgroundImage &&
        other.id == id &&
        other.sha256 == sha256 &&
        other.mimeType == mimeType &&
        other.byteSize == byteSize &&
        other.width == width &&
        other.height == height &&
        other.relativePath == relativePath &&
        other.absolutePath == absolutePath &&
        other.syncEnabled == syncEnabled &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.deletedAt == deletedAt &&
        other.deviceId == deviceId &&
        other.version == version;
  }

  @override
  int get hashCode => Object.hash(
        id,
        sha256,
        mimeType,
        byteSize,
        width,
        height,
        relativePath,
        absolutePath,
        syncEnabled,
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

bool _requiredBool(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is! bool) {
    throw FormatException('$key must be a boolean.');
  }
  return value;
}
