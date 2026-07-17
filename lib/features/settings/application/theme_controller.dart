import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/id_generator.dart';
import '../../appearance/application/appearance_controller.dart';
import '../../appearance/domain/appearance_presets.dart';
import '../../appearance/domain/appearance_settings.dart';
import '../../appearance/domain/rgb_color.dart';
import '../data/theme_repository.dart';
import '../domain/theme_scheme.dart';

final themeControllerProvider =
    AsyncNotifierProvider<ThemeController, ThemeState>(ThemeController.new);

class ThemeState {
  const ThemeState({
    required this.activeTheme,
    required this.savedThemes,
    required this.draftTheme,
  });

  final AppThemeScheme activeTheme;
  final List<AppThemeScheme> savedThemes;
  final AppThemeScheme draftTheme;

  ThemeState copyWith({
    AppThemeScheme? activeTheme,
    List<AppThemeScheme>? savedThemes,
    AppThemeScheme? draftTheme,
  }) {
    return ThemeState(
      activeTheme: activeTheme ?? this.activeTheme,
      savedThemes: savedThemes ?? this.savedThemes,
      draftTheme: draftTheme ?? this.draftTheme,
    );
  }
}

class ThemeController extends AsyncNotifier<ThemeState> {
  late ThemeRepository _repository;

  @override
  Future<ThemeState> build() async {
    _repository = ref.watch(themeRepositoryProvider);
    final appearance = await ref.watch(appearanceControllerProvider.future);
    await _seedPresets();
    return _load(portable: appearance.portable);
  }

  Future<ThemeState> _load({
    AppearanceSettings? portable,
    AppThemeScheme? draftTheme,
  }) async {
    final legacyActive = await _repository.getActiveTheme();
    final appearance = portable ??
        (await ref.read(appearanceControllerProvider.future)).portable;
    final activeTheme = _repository.fromAppearance(
      appearance,
      metadata: legacyActive,
    );
    final savedThemes = await _repository.getSavedThemes();
    return ThemeState(
      activeTheme: activeTheme,
      savedThemes: savedThemes,
      draftTheme: draftTheme ?? activeTheme,
    );
  }

  @Deprecated('Use appearanceControllerProvider for appearance writes.')
  Future<void> applyTheme(AppThemeScheme scheme) async {
    await _repository.saveTheme(scheme.copyWith(isActive: true));
    await _repository.activateTheme(scheme.id);
    await _applySchemeToAppearance(scheme);
    state = await AsyncValue.guard(
      () => _load(draftTheme: scheme.copyWith(isActive: true)),
    );
  }

  @Deprecated('Use appearanceControllerProvider for appearance writes.')
  Future<void> restoreDefaultTheme() {
    return applyTheme(AppThemeScheme.minimalLight);
  }

  @Deprecated('Use appearanceControllerProvider for appearance writes.')
  void updateDraft({
    Color? backgroundColor,
    Color? primaryColor,
    Color? textColor,
    Color? surfaceColor,
    Brightness? brightness,
  }) {
    final current = state.valueOrNull;
    if (current == null) {
      return;
    }
    final draftTheme = current.draftTheme.copyWith(
      id: 'draft-theme',
      name: '自定义预览',
      backgroundColor: backgroundColor,
      primaryColor: primaryColor,
      textColor: textColor,
      surfaceColor: surfaceColor,
      brightness: brightness,
      isActive: true,
    );
    state = AsyncData(
      current.copyWith(
        activeTheme: draftTheme,
        draftTheme: draftTheme,
      ),
    );
  }

  @Deprecated('Use appearanceControllerProvider for appearance writes.')
  Future<void> saveCustomTheme({String? name}) async {
    final current = state.valueOrNull;
    if (current == null) {
      return;
    }
    final themeName = name?.trim().isNotEmpty == true
        ? name!.trim()
        : '自定义主题 ${current.savedThemes.length + 1}';
    final customTheme = current.draftTheme.copyWith(
      id: IdGenerator.create(),
      name: themeName,
      isActive: true,
    );
    await _repository.saveTheme(customTheme);
    await _repository.activateTheme(customTheme.id);
    await _applySchemeToAppearance(customTheme);
    state = await AsyncValue.guard(
      () => _load(draftTheme: customTheme),
    );
  }

  Future<void> _applySchemeToAppearance(AppThemeScheme scheme) async {
    await ref.read(appearanceControllerProvider.future);
    final controller = ref.read(appearanceControllerProvider.notifier);
    await controller.setAccent(RgbColor.fromColor(scheme.primaryColor));
    final background = RgbColor.fromColor(scheme.backgroundColor);
    final selection = AppearancePresets.backgroundColors.contains(background)
        ? BackgroundSelection.presetColor(background)
        : BackgroundSelection.customColor(background);
    await controller.setBackground(selection);
  }

  Future<void> _seedPresets() async {
    final savedThemes = await _repository.getSavedThemes();
    final savedIds = savedThemes.map((theme) => theme.id).toSet();
    for (final preset in AppThemeScheme.presets) {
      if (!savedIds.contains(preset.id)) {
        await _repository.saveTheme(
          preset.copyWith(isActive: false),
        );
      }
    }
    if (!savedThemes.any((theme) => theme.isActive)) {
      await _repository.activateTheme(AppThemeScheme.minimalLight.id);
    }
  }
}
