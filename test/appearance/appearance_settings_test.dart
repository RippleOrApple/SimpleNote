import 'package:flutter_test/flutter_test.dart';
import 'package:simple_note/core/theme/typography_preferences.dart';
import 'package:simple_note/features/appearance/domain/appearance_presets.dart';
import 'package:simple_note/features/appearance/domain/appearance_settings.dart';
import 'package:simple_note/features/appearance/domain/background_image.dart';
import 'package:simple_note/features/appearance/domain/custom_color.dart';
import 'package:simple_note/features/appearance/domain/device_appearance_profile.dart';
import 'package:simple_note/features/appearance/domain/rgb_color.dart';

void main() {
  test('presets contain the three exact approved seven-color lists', () {
    expect(
      AppearancePresets.backgroundColors.map((color) => color.value),
      [0xDFE8F5, 0xE3ECDD, 0xF1E3E7, 0xEAE2F2, 0xF1E9DC, 0xDDECE9, 0xEEDBD5],
    );
    expect(
      AppearancePresets.accentColors.map((color) => color.value),
      [0x596790, 0x4D8BB8, 0x5E9D83, 0x78A65A, 0xB66B86, 0xCA806E, 0x8A6FB0],
    );
    expect(
      AppearancePresets.notePaperColors.map((color) => color.value),
      [0xFAFAF7, 0xF8F0DE, 0xEEE4D1, 0xE5EFE5, 0xE4EDF5, 0xF3E5E8, 0xECE6F3],
    );
  });

  test('appearance defaults have stable enum names and 24-bit RGB JSON', () {
    final settings = AppearanceSettings.defaults();
    final json = settings.toJson();

    expect(settings.brightnessMode, AppBrightnessMode.system);
    expect(settings.accent, const RgbColor(0x596790));
    expect(
      settings.background,
      BackgroundSelection.presetColor(const RgbColor(0xDFE8F5)),
    );
    expect(settings.lastPureBackground, const RgbColor(0xDFE8F5));
    expect(settings.notePaper, const RgbColor(0xFAFAF7));
    expect(settings.motion, MotionLevel.expressive);
    expect(json['brightnessMode'], 'system');
    expect(json['accent'], 0x596790);
    expect(json['lastPureBackground'], 0xDFE8F5);
    expect(json['notePaper'], 0xFAFAF7);
    expect(AppearanceSettings.fromJson(json), settings);
  });

  test('appearance and typography numeric inputs are clamped', () {
    final typography = TypographyPreferences(
      uiFontFamily: 'ResourceHanRoundedCN',
      noteFontFamily: 'LXGWWenKai',
      uiScale: UiScale.large,
      noteFontSize: 100,
      noteLineHeight: 0.5,
    );
    final settings = AppearanceSettings(
      schemaVersion: 1,
      brightnessMode: AppBrightnessMode.dark,
      accent: const RgbColor(0x596790),
      background: BackgroundSelection.customColor(
        const RgbColor(0x123456),
      ),
      lastPureBackground: const RgbColor(0x123456),
      notePaper: const RgbColor(0xFAFAF7),
      typography: typography,
      motion: MotionLevel.reduced,
      tintStrength: -1,
      glassOpacity: 4,
      darkOverlay: 2,
    );

    expect(typography.noteFontSize, 28);
    expect(typography.noteLineHeight, 1.3);
    expect(settings.tintStrength, 0);
    expect(settings.glassOpacity, 1);
    expect(settings.darkOverlay, 1);
    expect(
      TypographyPreferences.fromJson(typography.toJson()),
      typography,
    );
    expect(AppearanceSettings.fromJson(settings.toJson()), settings);
  });

  test('appearance JSON rejects unknown versions and enum values', () {
    final json = AppearanceSettings.defaults().toJson();

    expect(
      () => AppearanceSettings.fromJson({...json, 'schemaVersion': 2}),
      throwsFormatException,
    );
    expect(
      () => AppearanceSettings.fromJson({...json, 'motion': 'cinematic'}),
      throwsFormatException,
    );
    expect(
      () => AppearanceSettings.fromJson({...json, 'accent': '0x596790'}),
      throwsFormatException,
    );
  });

  test('background selections enforce kind-specific stable JSON', () {
    final selections = [
      BackgroundSelection.presetColor(const RgbColor(0xDFE8F5)),
      BackgroundSelection.customColor(const RgbColor(0x123456)),
      BackgroundSelection.bundledImage('assets/backgrounds/presets/fog.png'),
      BackgroundSelection.syncedImage('image-1'),
    ];

    for (final selection in selections) {
      final json = selection.toJson();
      expect(json.keys, ['kind', 'color', 'assetPath', 'imageId']);
      expect(BackgroundSelection.fromJson(json), selection);
      expect(selection.copyWith(), selection);
    }
    expect(
      () => BackgroundSelection.bundledImage('  '),
      throwsArgumentError,
    );
  });

  test('custom colors round trip and copyWith can clear deletion', () {
    final color = CustomColor(
      id: 'color-1',
      name: 'Ocean',
      color: const RgbColor(0x4D8BB8),
      sortOrder: 2,
      createdAt: 10,
      updatedAt: 20,
      deletedAt: 30,
      deviceId: 'device-1',
      version: 3,
    );

    expect(CustomColor.fromJson(color.toJson()), color);
    expect(color.copyWith(clearDeletedAt: true).deletedAt, isNull);
    expect(
      () => CustomColor(
        id: '',
        name: 'Ocean',
        color: const RgbColor(0x4D8BB8),
        sortOrder: 0,
        createdAt: 0,
        updatedAt: 0,
        deviceId: 'device-1',
        version: 1,
      ),
      throwsArgumentError,
    );
  });

  test('background image JSON omits the device-local absolute path', () {
    final image = BackgroundImage(
      id: 'image-1',
      sha256: 'a' * 64,
      mimeType: 'image/png',
      byteSize: 128,
      width: 32,
      height: 16,
      relativePath: 'backgrounds/image-1.png',
      absolutePath: r'C:\data\backgrounds\image-1.png',
      syncEnabled: true,
      createdAt: 10,
      updatedAt: 20,
      deletedAt: 30,
      deviceId: 'device-1',
      version: 2,
    );

    final json = image.toJson();
    expect(json, isNot(contains('absolutePath')));
    expect(
      BackgroundImage.fromJson(
        json,
        absolutePath: r'D:\restored\backgrounds\image-1.png',
      ).absolutePath,
      r'D:\restored\backgrounds\image-1.png',
    );
    expect(image.copyWith(clearDeletedAt: true).deletedAt, isNull);
  });

  test('device profile normalizes navigation and clamps presentation', () {
    final profile = DeviceAppearanceProfile(
      id: 'device-1:android',
      platform: 'android',
      density: LayoutDensity.compact,
      navOrder: [' notes ', '', 'notes', 'more'],
      hiddenNav: {' today ', '', 'notes'},
      startModule: 'notes',
      localBackgroundImageId: '  ',
      backgroundFocusX: -1,
      backgroundFocusY: 4,
      backgroundZoom: 10,
      backgroundBlur: -2,
      backgroundOverlay: 8,
      hapticsMode: HapticsMode.rich,
      updatedAt: 50,
    );

    expect(
      profile.navOrder,
      ['notes', 'more', 'today', 'calendar', 'habits'],
    );
    expect(profile.hiddenNav, {'notes'});
    expect(profile.startModule, 'today');
    expect(profile.localBackgroundImageId, isNull);
    expect(profile.backgroundFocusX, 0);
    expect(profile.backgroundFocusY, 1);
    expect(profile.backgroundZoom, 3);
    expect(profile.backgroundBlur, 0);
    expect(profile.backgroundOverlay, 1);
    expect(profile.toJson()['hiddenNav'], ['notes']);
    expect(DeviceAppearanceProfile.fromJson(profile.toJson()), profile);
  });

  test('device profile defaults are Android-safe and stable', () {
    final profile = DeviceAppearanceProfile.defaults(
      id: 'device-1:android',
      platform: 'android',
      updatedAt: 100,
    );

    expect(
      profile.navOrder,
      ['today', 'calendar', 'habits', 'notes', 'more'],
    );
    expect(profile.hiddenNav, isEmpty);
    expect(profile.startModule, 'today');
    expect(profile.density, LayoutDensity.standard);
    expect(profile.hapticsMode, HapticsMode.off);
    expect(profile.backgroundFocusX, 0.5);
    expect(profile.backgroundFocusY, 0.5);
    expect(profile.backgroundZoom, 1);
    expect(profile.backgroundBlur, 0);
    expect(profile.backgroundOverlay, 0);
    expect(profile.copyWith(clearLocalBackgroundImageId: true), profile);
  });
}
