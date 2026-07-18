import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_note/core/theme/derived_surface_palette.dart';
import 'package:simple_note/features/appearance/domain/rgb_color.dart';

void main() {
  test('derived text meets WCAG contrast thresholds', () {
    final palette = DerivedSurfacePalette.from(
      accent: const RgbColor(0x596790),
      background: const RgbColor(0xDFE8F5),
      brightness: Brightness.light,
    );

    expect(
      contrastRatio(palette.onSurface, palette.surface),
      greaterThanOrEqualTo(4.5),
    );
    expect(
      contrastRatio(palette.onAccent, palette.accent),
      greaterThanOrEqualTo(4.5),
    );
    expect(
      contrastRatio(palette.onBackground, palette.background),
      greaterThanOrEqualTo(4.5),
    );
    expect(
      contrastRatio(palette.onLowTintSurface, palette.lowTintSurface),
      greaterThanOrEqualTo(4.5),
    );
  });

  test('light derivation follows the approved blend formula', () {
    const accent = Color(0xFF596790);
    const background = Color(0xFFDFE8F5);
    final expectedSurface = Color.lerp(
      background,
      const Color(0xFFFFFFFF),
      0.88,
    )!;
    final expectedTint = Color.alphaBlend(
      const Color(0x1F596790),
      expectedSurface,
    );

    final palette = DerivedSurfacePalette.from(
      accent: const RgbColor(0x596790),
      background: const RgbColor(0xDFE8F5),
      brightness: Brightness.light,
    );

    expect(palette.accent, accent);
    expect(palette.background, background);
    expect(palette.surface, expectedSurface);
    expect(palette.lowTintSurface, expectedTint);
    expect(palette.glassSurface.toARGB32() >> 24, 184);
    expect(palette.glassBorder.toARGB32() >> 24, 36);
  });

  test('dark derivation does not mutate persisted RGB inputs', () {
    const accent = RgbColor(0xCA806E);
    const background = RgbColor(0xEEDBD5);
    final expectedBackground = Color.lerp(
      background.toColor(),
      const Color(0xFF111318),
      0.72,
    );
    final expectedSurface = Color.lerp(
      expectedBackground,
      const Color(0xFF1F232B),
      0.72,
    );

    final palette = DerivedSurfacePalette.from(
      accent: accent,
      background: background,
      brightness: Brightness.dark,
    );

    expect(accent.value, 0xCA806E);
    expect(background.value, 0xEEDBD5);
    expect(palette.background, expectedBackground);
    expect(palette.surface, expectedSurface);
    expect(palette.glassSurface.toARGB32() >> 24, 199);
  });

  test('contrast ratio matches the WCAG black-white reference', () {
    expect(
      contrastRatio(const Color(0xFF000000), const Color(0xFFFFFFFF)),
      closeTo(21, 0.000001),
    );
  });
}
