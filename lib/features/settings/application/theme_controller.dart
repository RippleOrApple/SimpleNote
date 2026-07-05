import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/theme_scheme.dart';

final themeControllerProvider =
    StateNotifierProvider<ThemeController, AppThemeScheme>((ref) {
  return ThemeController();
});

class ThemeController extends StateNotifier<AppThemeScheme> {
  ThemeController() : super(AppThemeScheme.minimalLight);

  void applyTheme(AppThemeScheme scheme) {
    state = scheme;
  }
}
