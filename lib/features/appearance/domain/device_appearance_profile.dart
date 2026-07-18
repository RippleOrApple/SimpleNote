import 'appearance_presets.dart';
import '../../navigation/domain/app_module.dart';

final class DeviceAppearanceProfile {
  factory DeviceAppearanceProfile({
    required String id,
    required String platform,
    required LayoutDensity density,
    required Iterable<String> navOrder,
    required Iterable<String> hiddenNav,
    required String startModule,
    String? localBackgroundImageId,
    required double backgroundFocusX,
    required double backgroundFocusY,
    required double backgroundZoom,
    required double backgroundBlur,
    required double backgroundOverlay,
    required HapticsMode hapticsMode,
    required int updatedAt,
  }) {
    _requireNonBlank(id, 'id');
    _requireNonBlank(platform, 'platform');
    if (updatedAt < 0) {
      throw ArgumentError.value(
          updatedAt, 'updatedAt', 'Must be non-negative.');
    }

    final catalog = AppModuleCatalog.forPlatform(platform);
    final normalizedOrder = AppModuleCatalog.normalizeOrder(
      platform,
      navOrder,
    ).map((module) => module.name).toList();
    final catalogNames = catalog.map((module) => module.name).toSet();
    final normalizedHidden = _normalizeSet(hiddenNav)
      ..retainAll(catalogNames)
      ..remove(AppModuleKey.today.name);
    final normalizedStart = startModule.trim();
    final safeStart = normalizedStart.isNotEmpty &&
            normalizedOrder.contains(normalizedStart) &&
            !normalizedHidden.contains(normalizedStart)
        ? normalizedStart
        : 'today';
    final normalizedLocalImageId = localBackgroundImageId?.trim();

    return DeviceAppearanceProfile._(
      id: id,
      platform: platform,
      density: density,
      navOrder: List.unmodifiable(normalizedOrder),
      hiddenNav: Set.unmodifiable(normalizedHidden),
      startModule: safeStart,
      localBackgroundImageId:
          normalizedLocalImageId == null || normalizedLocalImageId.isEmpty
              ? null
              : normalizedLocalImageId,
      backgroundFocusX: _clamp(
        backgroundFocusX,
        0,
        1,
        'backgroundFocusX',
      ),
      backgroundFocusY: _clamp(
        backgroundFocusY,
        0,
        1,
        'backgroundFocusY',
      ),
      backgroundZoom: _clamp(
        backgroundZoom,
        0.5,
        3,
        'backgroundZoom',
      ),
      backgroundBlur: _clamp(
        backgroundBlur,
        0,
        40,
        'backgroundBlur',
      ),
      backgroundOverlay: _clamp(
        backgroundOverlay,
        0,
        1,
        'backgroundOverlay',
      ),
      hapticsMode: hapticsMode,
      updatedAt: updatedAt,
    );
  }

  const DeviceAppearanceProfile._({
    required this.id,
    required this.platform,
    required this.density,
    required this.navOrder,
    required this.hiddenNav,
    required this.startModule,
    required this.localBackgroundImageId,
    required this.backgroundFocusX,
    required this.backgroundFocusY,
    required this.backgroundZoom,
    required this.backgroundBlur,
    required this.backgroundOverlay,
    required this.hapticsMode,
    required this.updatedAt,
  });

  factory DeviceAppearanceProfile.defaults({
    required String id,
    required String platform,
    required int updatedAt,
  }) {
    return DeviceAppearanceProfile(
      id: id,
      platform: platform,
      density: LayoutDensity.standard,
      navOrder:
          AppModuleCatalog.forPlatform(platform).map((module) => module.name),
      hiddenNav: const {},
      startModule: 'today',
      backgroundFocusX: 0.5,
      backgroundFocusY: 0.5,
      backgroundZoom: 1,
      backgroundBlur: 0,
      backgroundOverlay: 0,
      hapticsMode: HapticsMode.off,
      updatedAt: updatedAt,
    );
  }

  final String id;
  final String platform;
  final LayoutDensity density;
  final List<String> navOrder;
  final Set<String> hiddenNav;
  final String startModule;
  final String? localBackgroundImageId;
  final double backgroundFocusX;
  final double backgroundFocusY;
  final double backgroundZoom;
  final double backgroundBlur;
  final double backgroundOverlay;
  final HapticsMode hapticsMode;
  final int updatedAt;

  DeviceAppearanceProfile copyWith({
    String? id,
    String? platform,
    LayoutDensity? density,
    Iterable<String>? navOrder,
    Iterable<String>? hiddenNav,
    String? startModule,
    String? localBackgroundImageId,
    bool clearLocalBackgroundImageId = false,
    double? backgroundFocusX,
    double? backgroundFocusY,
    double? backgroundZoom,
    double? backgroundBlur,
    double? backgroundOverlay,
    HapticsMode? hapticsMode,
    int? updatedAt,
  }) {
    return DeviceAppearanceProfile(
      id: id ?? this.id,
      platform: platform ?? this.platform,
      density: density ?? this.density,
      navOrder: navOrder ?? this.navOrder,
      hiddenNav: hiddenNav ?? this.hiddenNav,
      startModule: startModule ?? this.startModule,
      localBackgroundImageId: clearLocalBackgroundImageId
          ? null
          : localBackgroundImageId ?? this.localBackgroundImageId,
      backgroundFocusX: backgroundFocusX ?? this.backgroundFocusX,
      backgroundFocusY: backgroundFocusY ?? this.backgroundFocusY,
      backgroundZoom: backgroundZoom ?? this.backgroundZoom,
      backgroundBlur: backgroundBlur ?? this.backgroundBlur,
      backgroundOverlay: backgroundOverlay ?? this.backgroundOverlay,
      hapticsMode: hapticsMode ?? this.hapticsMode,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, Object?> toJson() {
    final sortedHidden = hiddenNav.toList()..sort();
    return {
      'id': id,
      'platform': platform,
      'density': density.name,
      'navOrder': navOrder.toList(),
      'hiddenNav': sortedHidden,
      'startModule': startModule,
      'localBackgroundImageId': localBackgroundImageId,
      'backgroundFocusX': backgroundFocusX,
      'backgroundFocusY': backgroundFocusY,
      'backgroundZoom': backgroundZoom,
      'backgroundBlur': backgroundBlur,
      'backgroundOverlay': backgroundOverlay,
      'hapticsMode': hapticsMode.name,
      'updatedAt': updatedAt,
    };
  }

  factory DeviceAppearanceProfile.fromJson(Map<String, Object?> json) {
    try {
      return DeviceAppearanceProfile(
        id: _requiredString(json, 'id'),
        platform: _requiredString(json, 'platform'),
        density: _requiredEnum(
          json,
          'density',
          LayoutDensity.values,
          'LayoutDensity',
        ),
        navOrder: _requiredStringList(json, 'navOrder'),
        hiddenNav: _requiredStringList(json, 'hiddenNav'),
        startModule: _requiredString(json, 'startModule'),
        localBackgroundImageId: _optionalString(
          json,
          'localBackgroundImageId',
        ),
        backgroundFocusX: _requiredDouble(json, 'backgroundFocusX'),
        backgroundFocusY: _requiredDouble(json, 'backgroundFocusY'),
        backgroundZoom: _requiredDouble(json, 'backgroundZoom'),
        backgroundBlur: _requiredDouble(json, 'backgroundBlur'),
        backgroundOverlay: _requiredDouble(json, 'backgroundOverlay'),
        hapticsMode: _requiredEnum(
          json,
          'hapticsMode',
          HapticsMode.values,
          'HapticsMode',
        ),
        updatedAt: _requiredInt(json, 'updatedAt'),
      );
    } on FormatException {
      rethrow;
    } on ArgumentError catch (error) {
      throw FormatException('Invalid device appearance profile: $error');
    }
  }

  @override
  bool operator ==(Object other) {
    return other is DeviceAppearanceProfile &&
        other.id == id &&
        other.platform == platform &&
        other.density == density &&
        _orderedEquals(other.navOrder, navOrder) &&
        _setEquals(other.hiddenNav, hiddenNav) &&
        other.startModule == startModule &&
        other.localBackgroundImageId == localBackgroundImageId &&
        other.backgroundFocusX == backgroundFocusX &&
        other.backgroundFocusY == backgroundFocusY &&
        other.backgroundZoom == backgroundZoom &&
        other.backgroundBlur == backgroundBlur &&
        other.backgroundOverlay == backgroundOverlay &&
        other.hapticsMode == hapticsMode &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    final sortedHidden = hiddenNav.toList()..sort();
    return Object.hash(
      id,
      platform,
      density,
      Object.hashAll(navOrder),
      Object.hashAll(sortedHidden),
      startModule,
      localBackgroundImageId,
      backgroundFocusX,
      backgroundFocusY,
      backgroundZoom,
      backgroundBlur,
      backgroundOverlay,
      hapticsMode,
      updatedAt,
    );
  }
}

Set<String> _normalizeSet(Iterable<String> values) {
  return {
    for (final value in values)
      if (value.trim().isNotEmpty) value.trim(),
  };
}

void _requireNonBlank(String value, String name) {
  if (value.trim().isEmpty) {
    throw ArgumentError.value(value, name, 'Must not be blank.');
  }
}

double _clamp(double value, double minimum, double maximum, String name) {
  if (!value.isFinite) {
    throw ArgumentError.value(value, name, 'Must be finite.');
  }
  return value.clamp(minimum, maximum).toDouble();
}

String _requiredString(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is! String) {
    throw FormatException('$key must be a string.');
  }
  return value;
}

String? _optionalString(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value != null && value is! String) {
    throw FormatException('$key must be a string or null.');
  }
  return value as String?;
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

List<String> _requiredStringList(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is! List || value.any((item) => item is! String)) {
    throw FormatException('$key must be a list of strings.');
  }
  return value.cast<String>();
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

bool _orderedEquals(List<String> left, List<String> right) {
  if (left.length != right.length) {
    return false;
  }
  for (var index = 0; index < left.length; index++) {
    if (left[index] != right[index]) {
      return false;
    }
  }
  return true;
}

bool _setEquals(Set<String> left, Set<String> right) {
  return left.length == right.length && left.containsAll(right);
}
