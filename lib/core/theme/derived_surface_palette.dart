import 'package:flutter/material.dart';

import '../../features/appearance/domain/rgb_color.dart';

final class DerivedSurfacePalette {
  const DerivedSurfacePalette._({
    required this.accent,
    required this.onAccent,
    required this.background,
    required this.onBackground,
    required this.surface,
    required this.onSurface,
    required this.lowTintSurface,
    required this.onLowTintSurface,
    required this.glassSurface,
    required this.glassBorder,
  });

  factory DerivedSurfacePalette.from({
    required RgbColor accent,
    required RgbColor background,
    required Brightness brightness,
  }) {
    final isLight = brightness == Brightness.light;
    final rawAccent = accent.toColor();
    final rawBackground = isLight
        ? background.toColor()
        : _blend(
            background.toColor(),
            const Color(0xFF111318),
            0.72,
          );
    final rawSurface = isLight
        ? _blend(rawBackground, const Color(0xFFFFFFFF), 0.88)
        : _blend(rawBackground, const Color(0xFF1F232B), 0.72);

    final accentPair = _accessiblePair(rawAccent);
    final backgroundPair = _accessiblePair(rawBackground);
    final surfacePair = _accessiblePair(rawSurface);
    final rawLowTintSurface = Color.alphaBlend(
      _withAlpha(rawAccent, isLight ? 0.12 : 0.20),
      surfacePair.background,
    );
    final lowTintPair = _accessiblePair(rawLowTintSurface);

    return DerivedSurfacePalette._(
      accent: accentPair.background,
      onAccent: accentPair.foreground,
      background: backgroundPair.background,
      onBackground: backgroundPair.foreground,
      surface: surfacePair.background,
      onSurface: surfacePair.foreground,
      lowTintSurface: lowTintPair.background,
      onLowTintSurface: lowTintPair.foreground,
      glassSurface: _withAlpha(
        surfacePair.background,
        isLight ? 0.72 : 0.78,
      ),
      glassBorder: _withAlpha(surfacePair.foreground, 0.14),
    );
  }

  final Color accent;
  final Color onAccent;
  final Color background;
  final Color onBackground;
  final Color surface;
  final Color onSurface;
  final Color lowTintSurface;
  final Color onLowTintSurface;
  final Color glassSurface;
  final Color glassBorder;
}

double contrastRatio(Color foreground, Color background) {
  final foregroundLuminance = foreground.computeLuminance();
  final backgroundLuminance = background.computeLuminance();
  final lighter = foregroundLuminance > backgroundLuminance
      ? foregroundLuminance
      : backgroundLuminance;
  final darker = foregroundLuminance > backgroundLuminance
      ? backgroundLuminance
      : foregroundLuminance;
  return (lighter + 0.05) / (darker + 0.05);
}

Color _blend(Color from, Color to, double amount) {
  return Color.lerp(from, to, amount)!;
}

Color _withAlpha(Color color, double opacity) {
  final alpha = (opacity * 255).round().clamp(0, 255);
  return Color((alpha << 24) | (color.toARGB32() & 0xFFFFFF));
}

_AccessiblePair _accessiblePair(Color rawBackground) {
  const black = Color(0xFF000000);
  const white = Color(0xFFFFFFFF);
  final blackContrast = contrastRatio(black, rawBackground);
  final whiteContrast = contrastRatio(white, rawBackground);
  final foreground = blackContrast >= whiteContrast ? black : white;
  if (contrastRatio(foreground, rawBackground) >= 4.5) {
    return _AccessiblePair(rawBackground, foreground);
  }

  final hsl = HSLColor.fromColor(rawBackground);
  final direction = foreground == black ? 1.0 : -1.0;
  var lightness = hsl.lightness;
  var adjusted = rawBackground;
  while (contrastRatio(foreground, adjusted) < 4.5) {
    final next = (lightness + direction * 0.01).clamp(0.0, 1.0);
    if (next == lightness) {
      break;
    }
    lightness = next;
    adjusted = hsl.withLightness(lightness).toColor();
  }
  return _AccessiblePair(adjusted, foreground);
}

final class _AccessiblePair {
  const _AccessiblePair(this.background, this.foreground);

  final Color background;
  final Color foreground;
}
