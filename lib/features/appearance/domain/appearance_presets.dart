import 'rgb_color.dart';

enum AppBrightnessMode { system, light, dark }

enum BackgroundKind { presetColor, customColor, bundledImage, syncedImage }

enum UiScale { small, standard, large }

enum LayoutDensity { compact, standard, relaxed }

enum MotionLevel { reduced, natural, expressive }

enum HapticsMode { off, keyActions, rich }

abstract final class AppearancePresets {
  static const backgroundColors = [
    RgbColor(0xDFE8F5),
    RgbColor(0xE3ECDD),
    RgbColor(0xF1E3E7),
    RgbColor(0xEAE2F2),
    RgbColor(0xF1E9DC),
    RgbColor(0xDDECE9),
    RgbColor(0xEEDBD5),
  ];

  static const accentColors = [
    RgbColor(0x596790),
    RgbColor(0x4D8BB8),
    RgbColor(0x5E9D83),
    RgbColor(0x78A65A),
    RgbColor(0xB66B86),
    RgbColor(0xCA806E),
    RgbColor(0x8A6FB0),
  ];

  static const notePaperColors = [
    RgbColor(0xFAFAF7),
    RgbColor(0xF8F0DE),
    RgbColor(0xEEE4D1),
    RgbColor(0xE5EFE5),
    RgbColor(0xE4EDF5),
    RgbColor(0xF3E5E8),
    RgbColor(0xECE6F3),
  ];
}
