import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/id_generator.dart';
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
    await _seedPresets();
    return _load();
  }

  Future<ThemeState> _load({AppThemeScheme? draftTheme}) async {
    final activeTheme = await _repository.getActiveTheme();
    final savedThemes = await _repository.getSavedThemes();
    return ThemeState(
      activeTheme: activeTheme,
      savedThemes: savedThemes,
      draftTheme: draftTheme ?? activeTheme,
    );
  }

  Future<void> applyTheme(AppThemeScheme scheme) async {
    await _repository.saveTheme(scheme.copyWith(isActive: true));
    await _repository.activateTheme(scheme.id);
    state = await AsyncValue.guard(
      () => _load(draftTheme: scheme.copyWith(isActive: true)),
    );
  }

  Future<void> restoreDefaultTheme() {
    return applyTheme(AppThemeScheme.minimalLight);
  }

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
      name: 'Custom Preview',
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

  Future<void> saveCustomTheme({String? name}) async {
    final current = state.valueOrNull;
    if (current == null) {
      return;
    }
    final themeName = name?.trim().isNotEmpty == true
        ? name!.trim()
        : 'Custom Theme ${current.savedThemes.length + 1}';
    final customTheme = current.draftTheme.copyWith(
      id: IdGenerator.create(),
      name: themeName,
      isActive: true,
    );
    await _repository.saveTheme(customTheme);
    await _repository.activateTheme(customTheme.id);
    state = await AsyncValue.guard(
      () => _load(draftTheme: customTheme),
    );
  }

  Future<void> _seedPresets() async {
    final savedThemes = await _repository.getSavedThemes();
    final savedIds = savedThemes.map((theme) => theme.id).toSet();
    for (final preset in AppThemeScheme.presets) {
      if (!savedIds.contains(preset.id)) {
        await _repository.saveTheme(
          preset.copyWith(
              isActive: preset.id == AppThemeScheme.minimalLight.id),
        );
      }
    }
  }
}
