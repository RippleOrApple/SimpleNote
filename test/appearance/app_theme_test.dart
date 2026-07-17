import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_note/core/motion/app_motion.dart';
import 'package:simple_note/core/theme/app_theme.dart';
import 'package:simple_note/core/theme/derived_surface_palette.dart';
import 'package:simple_note/features/appearance/domain/appearance_presets.dart';
import 'package:simple_note/features/appearance/domain/appearance_settings.dart';
import 'package:simple_note/features/appearance/domain/rgb_color.dart';
import 'package:simple_note/features/settings/domain/theme_scheme.dart';

void main() {
  test('builds the appearance theme with the approved fonts and radii', () {
    final settings = AppearanceSettings.defaults().copyWith(
      accent: const RgbColor(0x5E9D83),
      typography: AppearanceSettings.defaults().typography.copyWith(
            uiScale: UiScale.standard,
          ),
    );

    final theme = AppTheme.fromAppearance(settings, Brightness.light);

    expect(theme.brightness, Brightness.light);
    expect(theme.textTheme.bodyMedium?.fontFamily, 'ResourceHanRoundedCN');
    expect(
      theme.textTheme.bodyMedium?.fontFamilyFallback,
      contains('NotoSansSC'),
    );
    expect(
      (theme.cardTheme.shape! as RoundedRectangleBorder).borderRadius,
      BorderRadius.circular(16),
    );
    expect(
      (theme.dialogTheme.shape! as RoundedRectangleBorder).borderRadius,
      BorderRadius.circular(18),
    );
    expect(
      (theme.inputDecorationTheme.border! as OutlineInputBorder).borderRadius,
      BorderRadius.circular(10),
    );
    expect(
      (theme.filledButtonTheme.style!.shape!.resolve({})!
              as RoundedRectangleBorder)
          .borderRadius,
      BorderRadius.circular(10),
    );
  });

  test('resolves brightness and derives selected and low-tint colors', () {
    final settings = AppearanceSettings.defaults().copyWith(
      brightnessMode: AppBrightnessMode.system,
      accent: const RgbColor(0x5E9D83),
      motion: MotionLevel.natural,
    );
    final expected = DerivedSurfacePalette.from(
      accent: settings.accent,
      background: settings.lastPureBackground,
      brightness: Brightness.dark,
    );

    final theme = AppTheme.fromAppearance(settings, Brightness.dark);

    expect(theme.brightness, Brightness.dark);
    expect(theme.appBarTheme.backgroundColor, expected.accent);
    expect(theme.appBarTheme.foregroundColor, expected.onAccent);
    expect(theme.inputDecorationTheme.fillColor, expected.lowTintSurface);
    expect(theme.colorScheme.primary, expected.accent);
    expect(
      theme.extension<AppMotionTheme>()?.controlDuration,
      AppMotion.standard,
    );
    expect(
      theme.filledButtonTheme.style?.animationDuration,
      AppMotion.standard,
    );
  });

  test('exposes note and code typography through the theme', () {
    final settings = AppearanceSettings.defaults().copyWith(
      typography: AppearanceSettings.defaults().typography.copyWith(
            noteFontSize: 21,
            noteLineHeight: 1.9,
          ),
    );

    final theme = AppTheme.fromAppearance(settings, Brightness.light);
    final typography = theme.extension<AppTypographyTheme>()!;

    expect(typography.noteBodyStyle.fontFamily, 'LXGWWenKai');
    expect(typography.noteBodyStyle.fontSize, 21);
    expect(typography.noteBodyStyle.height, 1.9);
    expect(typography.codeStyle.fontFamily, 'monospace');
    expect(typography.notePaperColor, settings.notePaper.toColor());
  });

  test('maps motion levels and accessibility reduction deterministically', () {
    expect(
      AppMotion.durationFor(MotionLevel.expressive),
      AppMotion.expressive,
    );
    expect(AppMotion.durationFor(MotionLevel.natural), AppMotion.standard);
    expect(AppMotion.durationFor(MotionLevel.reduced), AppMotion.reduced);
    expect(
      AppMotion.durationFor(
        MotionLevel.expressive,
        reduceMotion: true,
      ),
      AppMotion.reduced,
    );
  });

  test('maps tint strength into interactive surfaces', () {
    final defaults = AppearanceSettings.defaults();
    final noTint = AppTheme.fromAppearance(
      defaults.copyWith(tintStrength: 0),
      Brightness.light,
    );
    final fullTint = AppTheme.fromAppearance(
      defaults.copyWith(tintStrength: 1),
      Brightness.light,
    );

    expect(
      noTint.inputDecorationTheme.fillColor,
      isNot(fullTint.inputDecorationTheme.fillColor),
    );
    expect(noTint.hoverColor, noTint.colorScheme.surface);
  });

  test('maps device density into Material visual density', () {
    expect(
      AppTheme.visualDensityFor(LayoutDensity.compact),
      VisualDensity.compact,
    );
    expect(
      AppTheme.visualDensityFor(LayoutDensity.standard),
      VisualDensity.standard,
    );
    expect(
      AppTheme.visualDensityFor(LayoutDensity.relaxed).vertical,
      greaterThan(VisualDensity.standard.vertical),
    );
  });

  test('uses the approved UI font for legacy theme schemes', () {
    final theme = AppTheme.fromScheme(AppThemeScheme.minimalLight);

    expect(theme.textTheme.bodyMedium?.fontFamily, 'ResourceHanRoundedCN');
    expect(
      theme.textTheme.bodyMedium?.fontFamilyFallback,
      contains('NotoSansSC'),
    );
  });
}
