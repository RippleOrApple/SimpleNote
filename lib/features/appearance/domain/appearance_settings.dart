import '../../../core/theme/typography_preferences.dart';
import 'appearance_presets.dart';
import 'rgb_color.dart';

final class BackgroundSelection {
  const BackgroundSelection._({
    required this.kind,
    this.color,
    this.assetPath,
    this.imageId,
  });

  factory BackgroundSelection.presetColor(RgbColor color) {
    return BackgroundSelection._(
      kind: BackgroundKind.presetColor,
      color: color,
    );
  }

  factory BackgroundSelection.customColor(RgbColor color) {
    return BackgroundSelection._(
      kind: BackgroundKind.customColor,
      color: color,
    );
  }

  factory BackgroundSelection.bundledImage(String assetPath) {
    _requireNonBlank(assetPath, 'assetPath');
    return BackgroundSelection._(
      kind: BackgroundKind.bundledImage,
      assetPath: assetPath,
    );
  }

  factory BackgroundSelection.syncedImage(String imageId) {
    _requireNonBlank(imageId, 'imageId');
    return BackgroundSelection._(
      kind: BackgroundKind.syncedImage,
      imageId: imageId,
    );
  }

  final BackgroundKind kind;
  final RgbColor? color;
  final String? assetPath;
  final String? imageId;

  BackgroundSelection copyWith({
    BackgroundKind? kind,
    RgbColor? color,
    String? assetPath,
    String? imageId,
    bool clearColor = false,
    bool clearAssetPath = false,
    bool clearImageId = false,
  }) {
    final nextKind = kind ?? this.kind;
    final nextColor = clearColor ? null : color ?? this.color;
    final nextAssetPath = clearAssetPath ? null : assetPath ?? this.assetPath;
    final nextImageId = clearImageId ? null : imageId ?? this.imageId;
    return switch (nextKind) {
      BackgroundKind.presetColor => BackgroundSelection.presetColor(
          nextColor ?? (throw ArgumentError.notNull('color')),
        ),
      BackgroundKind.customColor => BackgroundSelection.customColor(
          nextColor ?? (throw ArgumentError.notNull('color')),
        ),
      BackgroundKind.bundledImage => BackgroundSelection.bundledImage(
          nextAssetPath ?? (throw ArgumentError.notNull('assetPath')),
        ),
      BackgroundKind.syncedImage => BackgroundSelection.syncedImage(
          nextImageId ?? (throw ArgumentError.notNull('imageId')),
        ),
    };
  }

  Map<String, Object?> toJson() => {
        'kind': kind.name,
        'color': color?.value,
        'assetPath': assetPath,
        'imageId': imageId,
      };

  factory BackgroundSelection.fromJson(Map<String, Object?> json) {
    final kind = _requiredEnum(
      json,
      'kind',
      BackgroundKind.values,
      'BackgroundKind',
    );
    final colorValue = json['color'];
    final assetPathValue = json['assetPath'];
    final imageIdValue = json['imageId'];
    if (colorValue != null && colorValue is! int) {
      throw const FormatException('color must be a 24-bit integer or null.');
    }
    if (assetPathValue != null && assetPathValue is! String) {
      throw const FormatException('assetPath must be a string or null.');
    }
    if (imageIdValue != null && imageIdValue is! String) {
      throw const FormatException('imageId must be a string or null.');
    }
    try {
      return switch (kind) {
        BackgroundKind.presetColor
            when assetPathValue == null && imageIdValue == null =>
          BackgroundSelection.presetColor(_rgbFromValue(colorValue, 'color')),
        BackgroundKind.customColor
            when assetPathValue == null && imageIdValue == null =>
          BackgroundSelection.customColor(_rgbFromValue(colorValue, 'color')),
        BackgroundKind.bundledImage
            when colorValue == null && imageIdValue == null =>
          BackgroundSelection.bundledImage(
            assetPathValue as String? ??
                (throw const FormatException('assetPath is required.')),
          ),
        BackgroundKind.syncedImage
            when colorValue == null && assetPathValue == null =>
          BackgroundSelection.syncedImage(
            imageIdValue as String? ??
                (throw const FormatException('imageId is required.')),
          ),
        _ => throw const FormatException(
            'Background fields do not match the selected kind.',
          ),
      };
    } on ArgumentError catch (error) {
      throw FormatException('Invalid background selection: $error');
    }
  }

  @override
  bool operator ==(Object other) {
    return other is BackgroundSelection &&
        other.kind == kind &&
        other.color == color &&
        other.assetPath == assetPath &&
        other.imageId == imageId;
  }

  @override
  int get hashCode => Object.hash(kind, color, assetPath, imageId);
}

final class AppearanceSettings {
  factory AppearanceSettings({
    required int schemaVersion,
    required AppBrightnessMode brightnessMode,
    required RgbColor accent,
    required BackgroundSelection background,
    required RgbColor lastPureBackground,
    required RgbColor notePaper,
    required TypographyPreferences typography,
    required MotionLevel motion,
    required double tintStrength,
    required double glassOpacity,
    required double darkOverlay,
  }) {
    if (schemaVersion != 1) {
      throw ArgumentError.value(schemaVersion, 'schemaVersion');
    }
    return AppearanceSettings._(
      schemaVersion: schemaVersion,
      brightnessMode: brightnessMode,
      accent: accent,
      background: background,
      lastPureBackground: lastPureBackground,
      notePaper: notePaper,
      typography: typography,
      motion: motion,
      tintStrength: _clampUnit(tintStrength, 'tintStrength'),
      glassOpacity: _clampUnit(glassOpacity, 'glassOpacity'),
      darkOverlay: _clampUnit(darkOverlay, 'darkOverlay'),
    );
  }

  const AppearanceSettings._({
    required this.schemaVersion,
    required this.brightnessMode,
    required this.accent,
    required this.background,
    required this.lastPureBackground,
    required this.notePaper,
    required this.typography,
    required this.motion,
    required this.tintStrength,
    required this.glassOpacity,
    required this.darkOverlay,
  });

  factory AppearanceSettings.defaults() {
    return AppearanceSettings(
      schemaVersion: 1,
      brightnessMode: AppBrightnessMode.system,
      accent: AppearancePresets.accentColors.first,
      background: BackgroundSelection.presetColor(
        AppearancePresets.backgroundColors.first,
      ),
      lastPureBackground: AppearancePresets.backgroundColors.first,
      notePaper: AppearancePresets.notePaperColors.first,
      typography: TypographyPreferences.defaults(),
      motion: MotionLevel.expressive,
      tintStrength: 0.35,
      glassOpacity: 0.62,
      darkOverlay: 0.42,
    );
  }

  final int schemaVersion;
  final AppBrightnessMode brightnessMode;
  final RgbColor accent;
  final BackgroundSelection background;
  final RgbColor lastPureBackground;
  final RgbColor notePaper;
  final TypographyPreferences typography;
  final MotionLevel motion;
  final double tintStrength;
  final double glassOpacity;
  final double darkOverlay;

  AppearanceSettings copyWith({
    int? schemaVersion,
    AppBrightnessMode? brightnessMode,
    RgbColor? accent,
    BackgroundSelection? background,
    RgbColor? lastPureBackground,
    RgbColor? notePaper,
    TypographyPreferences? typography,
    MotionLevel? motion,
    double? tintStrength,
    double? glassOpacity,
    double? darkOverlay,
  }) {
    return AppearanceSettings(
      schemaVersion: schemaVersion ?? this.schemaVersion,
      brightnessMode: brightnessMode ?? this.brightnessMode,
      accent: accent ?? this.accent,
      background: background ?? this.background,
      lastPureBackground: lastPureBackground ?? this.lastPureBackground,
      notePaper: notePaper ?? this.notePaper,
      typography: typography ?? this.typography,
      motion: motion ?? this.motion,
      tintStrength: tintStrength ?? this.tintStrength,
      glassOpacity: glassOpacity ?? this.glassOpacity,
      darkOverlay: darkOverlay ?? this.darkOverlay,
    );
  }

  Map<String, Object?> toJson() => {
        'schemaVersion': schemaVersion,
        'brightnessMode': brightnessMode.name,
        'accent': accent.value,
        'background': background.toJson(),
        'lastPureBackground': lastPureBackground.value,
        'notePaper': notePaper.value,
        'typography': typography.toJson(),
        'motion': motion.name,
        'tintStrength': tintStrength,
        'glassOpacity': glassOpacity,
        'darkOverlay': darkOverlay,
      };

  factory AppearanceSettings.fromJson(Map<String, Object?> json) {
    final schemaVersion = _requiredInt(json, 'schemaVersion');
    if (schemaVersion != 1) {
      throw FormatException(
        'Unsupported appearance schema version: $schemaVersion.',
      );
    }
    try {
      return AppearanceSettings(
        schemaVersion: schemaVersion,
        brightnessMode: _requiredEnum(
          json,
          'brightnessMode',
          AppBrightnessMode.values,
          'AppBrightnessMode',
        ),
        accent: _rgbFromValue(json['accent'], 'accent'),
        background: BackgroundSelection.fromJson(
          _requiredMap(json, 'background'),
        ),
        lastPureBackground: _rgbFromValue(
          json['lastPureBackground'],
          'lastPureBackground',
        ),
        notePaper: _rgbFromValue(json['notePaper'], 'notePaper'),
        typography: TypographyPreferences.fromJson(
          _requiredMap(json, 'typography'),
        ),
        motion: _requiredEnum(
          json,
          'motion',
          MotionLevel.values,
          'MotionLevel',
        ),
        tintStrength: _requiredDouble(json, 'tintStrength'),
        glassOpacity: _requiredDouble(json, 'glassOpacity'),
        darkOverlay: _requiredDouble(json, 'darkOverlay'),
      );
    } on FormatException {
      rethrow;
    } on ArgumentError catch (error) {
      throw FormatException('Invalid appearance settings: $error');
    }
  }

  @override
  bool operator ==(Object other) {
    return other is AppearanceSettings &&
        other.schemaVersion == schemaVersion &&
        other.brightnessMode == brightnessMode &&
        other.accent == accent &&
        other.background == background &&
        other.lastPureBackground == lastPureBackground &&
        other.notePaper == notePaper &&
        other.typography == typography &&
        other.motion == motion &&
        other.tintStrength == tintStrength &&
        other.glassOpacity == glassOpacity &&
        other.darkOverlay == darkOverlay;
  }

  @override
  int get hashCode => Object.hash(
        schemaVersion,
        brightnessMode,
        accent,
        background,
        lastPureBackground,
        notePaper,
        typography,
        motion,
        tintStrength,
        glassOpacity,
        darkOverlay,
      );
}

void _requireNonBlank(String value, String name) {
  if (value.trim().isEmpty) {
    throw ArgumentError.value(value, name, 'Must not be blank.');
  }
}

double _clampUnit(double value, String name) {
  if (!value.isFinite) {
    throw ArgumentError.value(value, name, 'Must be finite.');
  }
  return value.clamp(0, 1).toDouble();
}

int _requiredInt(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is! int) {
    throw FormatException('$key must be an integer.');
  }
  return value;
}

double _requiredDouble(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is! num || !value.isFinite) {
    throw FormatException('$key must be a finite number.');
  }
  return value.toDouble();
}

Map<String, Object?> _requiredMap(
  Map<String, Object?> json,
  String key,
) {
  final value = json[key];
  if (value is! Map) {
    throw FormatException('$key must be an object.');
  }
  try {
    return Map<String, Object?>.from(value);
  } on TypeError {
    throw FormatException('$key must contain string keys.');
  }
}

T _requiredEnum<T extends Enum>(
  Map<String, Object?> json,
  String key,
  List<T> values,
  String typeName,
) {
  final value = json[key];
  if (value is! String) {
    throw FormatException('$key must be a $typeName name.');
  }
  return values.firstWhere(
    (candidate) => candidate.name == value,
    orElse: () => throw FormatException('Unknown $typeName: $value.'),
  );
}

RgbColor _rgbFromValue(Object? value, String key) {
  if (value is! int || value < 0 || value > 0xFFFFFF) {
    throw FormatException('$key must be a 24-bit integer.');
  }
  return RgbColor(value);
}
