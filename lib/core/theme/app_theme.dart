import 'package:flutter/material.dart';

import '../../features/appearance/domain/appearance_presets.dart';
import '../../features/appearance/domain/appearance_settings.dart';
import '../../features/appearance/domain/rgb_color.dart';
import '../../features/settings/domain/theme_scheme.dart';
import '../motion/app_motion.dart';
import 'derived_surface_palette.dart';

class AppTheme {
  const AppTheme._();

  static const fontFamily = 'ResourceHanRoundedCN';
  static const fontFamilyFallback = ['NotoSansSC'];

  static ThemeData fromAppearance(
    AppearanceSettings settings,
    Brightness platformBrightness, {
    bool reduceMotion = false,
  }) {
    final brightness = switch (settings.brightnessMode) {
      AppBrightnessMode.system => platformBrightness,
      AppBrightnessMode.light => Brightness.light,
      AppBrightnessMode.dark => Brightness.dark,
    };
    final background = settings.background.color ?? settings.lastPureBackground;
    final palette = DerivedSurfacePalette.from(
      accent: settings.accent,
      background: background,
      brightness: brightness,
    );
    final interactiveTint = _interactiveTint(
      accent: palette.accent,
      surface: palette.surface,
      brightness: brightness,
      strength: settings.tintStrength,
    );
    final motion = AppMotionTheme.fromLevel(
      settings.motion,
      reduceMotion: reduceMotion,
    );
    final uiScale = switch (settings.typography.uiScale) {
      UiScale.small => 0.92,
      UiScale.standard => 1.0,
      UiScale.large => 1.1,
    };
    final textTheme = (brightness == Brightness.dark
            ? Typography.material2021().white
            : Typography.material2021().black)
        .apply(
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      fontSizeFactor: uiScale,
      bodyColor: palette.onBackground,
      displayColor: palette.onBackground,
    );
    final colorScheme = ColorScheme.fromSeed(
      seedColor: palette.accent,
      brightness: brightness,
    ).copyWith(
      primary: palette.accent,
      onPrimary: palette.onAccent,
      surface: palette.surface,
      onSurface: palette.onSurface,
      surfaceContainerLow: palette.lowTintSurface,
    );
    final buttonStyle = ButtonStyle(
      animationDuration: motion.controlDuration,
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    final notePaper = settings.notePaper.toColor();
    final noteForeground =
        ThemeData.estimateBrightnessForColor(notePaper) == Brightness.dark
            ? Colors.white
            : Colors.black;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: Colors.transparent,
      canvasColor: palette.surface,
      hoverColor: interactiveTint,
      focusColor: palette.accent.withValues(alpha: 0.16),
      textTheme: textTheme,
      extensions: [
        motion,
        AppTypographyTheme(
          noteBodyStyle: TextStyle(
            fontFamily: settings.typography.noteFontFamily,
            fontFamilyFallback: fontFamilyFallback,
            fontSize: settings.typography.noteFontSize,
            height: settings.typography.noteLineHeight,
            color: noteForeground,
          ),
          codeStyle: TextStyle(
            fontFamily: 'monospace',
            fontSize: settings.typography.noteFontSize * 0.9,
            height: settings.typography.noteLineHeight,
            color: noteForeground,
          ),
          notePaperColor: notePaper,
        ),
      ],
      cardTheme: CardThemeData(
        color: palette.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: palette.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: palette.accent,
        foregroundColor: palette.onAccent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: palette.surface,
        indicatorColor: palette.accent,
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? palette.onAccent
                : palette.onSurface,
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            color: states.contains(WidgetState.selected)
                ? palette.accent
                : palette.onSurface,
            fontFamily: fontFamily,
            fontFamilyFallback: fontFamilyFallback,
          ),
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: palette.surface,
        indicatorColor: palette.accent,
        selectedIconTheme: IconThemeData(color: palette.onAccent),
        selectedLabelTextStyle: TextStyle(
          color: palette.accent,
          fontFamily: fontFamily,
          fontFamilyFallback: fontFamilyFallback,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: interactiveTint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: palette.glassBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: palette.glassBorder),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(style: buttonStyle),
      elevatedButtonTheme: ElevatedButtonThemeData(style: buttonStyle),
      outlinedButtonTheme: OutlinedButtonThemeData(style: buttonStyle),
      textButtonTheme: TextButtonThemeData(style: buttonStyle),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: buttonStyle.copyWith(
          backgroundColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? palette.accent
                : interactiveTint,
          ),
          foregroundColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? palette.onAccent
                : palette.onLowTintSurface,
          ),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.selected) ? palette.accent : null,
        ),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? palette.accent
              : palette.onSurface,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.selected) ? palette.onAccent : null,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.selected) ? palette.accent : null,
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: palette.accent,
        thumbColor: palette.accent,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: palette.accent,
        foregroundColor: palette.onAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  static ThemeData fromScheme(AppThemeScheme scheme) {
    final palette = DerivedSurfacePalette.from(
      accent: RgbColor.fromColor(scheme.primaryColor),
      background: RgbColor.fromColor(scheme.backgroundColor),
      brightness: scheme.brightness,
    );
    final colorScheme = ColorScheme.fromSeed(
      seedColor: palette.accent,
      brightness: scheme.brightness,
    ).copyWith(
      primary: palette.accent,
      onPrimary: palette.onAccent,
      surface: palette.surface,
      onSurface: palette.onSurface,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: scheme.brightness,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: palette.background,
      textTheme: (scheme.brightness == Brightness.dark
              ? Typography.material2021().white
              : Typography.material2021().black)
          .apply(
        fontFamily: fontFamily,
        fontFamilyFallback: fontFamilyFallback,
        bodyColor: palette.onBackground,
        displayColor: palette.onBackground,
      ),
      cardTheme: CardThemeData(
        color: palette.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: palette.background,
        foregroundColor: palette.onBackground,
        elevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: palette.surface,
        indicatorColor: palette.accent.withValues(alpha: 0.18),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: palette.surface,
        indicatorColor: palette.accent.withValues(alpha: 0.18),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: palette.surface,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: palette.accent,
        foregroundColor: palette.onAccent,
      ),
    );
  }

  static VisualDensity visualDensityFor(LayoutDensity density) {
    return switch (density) {
      LayoutDensity.compact => VisualDensity.compact,
      LayoutDensity.standard => VisualDensity.standard,
      LayoutDensity.relaxed => const VisualDensity(horizontal: 1, vertical: 1),
    };
  }
}

Color _interactiveTint({
  required Color accent,
  required Color surface,
  required Brightness brightness,
  required double strength,
}) {
  final defaultOpacity = brightness == Brightness.light ? 0.12 : 0.20;
  final opacity = (defaultOpacity * strength / 0.35).clamp(0.0, 1.0);
  final alpha = (opacity * 255).round();
  final tint = Color((alpha << 24) | (accent.toARGB32() & 0xFFFFFF));
  return Color.alphaBlend(tint, surface);
}

@immutable
final class AppTypographyTheme extends ThemeExtension<AppTypographyTheme> {
  const AppTypographyTheme({
    required this.noteBodyStyle,
    required this.codeStyle,
    required this.notePaperColor,
  });

  final TextStyle noteBodyStyle;
  final TextStyle codeStyle;
  final Color notePaperColor;

  @override
  AppTypographyTheme copyWith({
    TextStyle? noteBodyStyle,
    TextStyle? codeStyle,
    Color? notePaperColor,
  }) {
    return AppTypographyTheme(
      noteBodyStyle: noteBodyStyle ?? this.noteBodyStyle,
      codeStyle: codeStyle ?? this.codeStyle,
      notePaperColor: notePaperColor ?? this.notePaperColor,
    );
  }

  @override
  AppTypographyTheme lerp(
    covariant ThemeExtension<AppTypographyTheme>? other,
    double t,
  ) {
    if (other is! AppTypographyTheme) {
      return this;
    }
    return AppTypographyTheme(
      noteBodyStyle: TextStyle.lerp(noteBodyStyle, other.noteBodyStyle, t)!,
      codeStyle: TextStyle.lerp(codeStyle, other.codeStyle, t)!,
      notePaperColor:
          Color.lerp(notePaperColor, other.notePaperColor, t) ?? notePaperColor,
    );
  }
}
