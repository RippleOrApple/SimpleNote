import '../../features/appearance/domain/appearance_presets.dart';

final class TypographyPreferences {
  factory TypographyPreferences({
    required String uiFontFamily,
    required String noteFontFamily,
    required UiScale uiScale,
    required double noteFontSize,
    required double noteLineHeight,
  }) {
    if (uiFontFamily.trim().isEmpty) {
      throw ArgumentError.value(uiFontFamily, 'uiFontFamily');
    }
    if (noteFontFamily.trim().isEmpty) {
      throw ArgumentError.value(noteFontFamily, 'noteFontFamily');
    }
    return TypographyPreferences._(
      uiFontFamily: uiFontFamily,
      noteFontFamily: noteFontFamily,
      uiScale: uiScale,
      noteFontSize: _clampFinite(
        noteFontSize,
        14,
        28,
        'noteFontSize',
      ),
      noteLineHeight: _clampFinite(
        noteLineHeight,
        1.3,
        2.2,
        'noteLineHeight',
      ),
    );
  }

  const TypographyPreferences._({
    required this.uiFontFamily,
    required this.noteFontFamily,
    required this.uiScale,
    required this.noteFontSize,
    required this.noteLineHeight,
  });

  factory TypographyPreferences.defaults() {
    return TypographyPreferences(
      uiFontFamily: 'ResourceHanRoundedCN',
      noteFontFamily: 'LXGWWenKai',
      uiScale: UiScale.standard,
      noteFontSize: 17,
      noteLineHeight: 1.75,
    );
  }

  final String uiFontFamily;
  final String noteFontFamily;
  final UiScale uiScale;
  final double noteFontSize;
  final double noteLineHeight;

  TypographyPreferences copyWith({
    String? uiFontFamily,
    String? noteFontFamily,
    UiScale? uiScale,
    double? noteFontSize,
    double? noteLineHeight,
  }) {
    return TypographyPreferences(
      uiFontFamily: uiFontFamily ?? this.uiFontFamily,
      noteFontFamily: noteFontFamily ?? this.noteFontFamily,
      uiScale: uiScale ?? this.uiScale,
      noteFontSize: noteFontSize ?? this.noteFontSize,
      noteLineHeight: noteLineHeight ?? this.noteLineHeight,
    );
  }

  Map<String, Object?> toJson() => {
        'uiFontFamily': uiFontFamily,
        'noteFontFamily': noteFontFamily,
        'uiScale': uiScale.name,
        'noteFontSize': noteFontSize,
        'noteLineHeight': noteLineHeight,
      };

  factory TypographyPreferences.fromJson(Map<String, Object?> json) {
    try {
      return TypographyPreferences(
        uiFontFamily: _requiredString(json, 'uiFontFamily'),
        noteFontFamily: _requiredString(json, 'noteFontFamily'),
        uiScale: _requiredUiScale(json, 'uiScale'),
        noteFontSize: _requiredDouble(json, 'noteFontSize'),
        noteLineHeight: _requiredDouble(json, 'noteLineHeight'),
      );
    } on FormatException {
      rethrow;
    } on ArgumentError catch (error) {
      throw FormatException('Invalid typography preferences: $error');
    }
  }

  @override
  bool operator ==(Object other) {
    return other is TypographyPreferences &&
        other.uiFontFamily == uiFontFamily &&
        other.noteFontFamily == noteFontFamily &&
        other.uiScale == uiScale &&
        other.noteFontSize == noteFontSize &&
        other.noteLineHeight == noteLineHeight;
  }

  @override
  int get hashCode => Object.hash(
        uiFontFamily,
        noteFontFamily,
        uiScale,
        noteFontSize,
        noteLineHeight,
      );
}

double _clampFinite(double value, double minimum, double maximum, String name) {
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

double _requiredDouble(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is! num || !value.isFinite) {
    throw FormatException('$key must be a finite number.');
  }
  return value.toDouble();
}

UiScale _requiredUiScale(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is! String) {
    throw FormatException('$key must be a UiScale name.');
  }
  return UiScale.values.firstWhere(
    (candidate) => candidate.name == value,
    orElse: () => throw FormatException('Unknown UiScale: $value.'),
  );
}
