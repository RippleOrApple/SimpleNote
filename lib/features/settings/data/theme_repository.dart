import '../domain/theme_scheme.dart';

abstract class ThemeRepository {
  Future<AppThemeScheme> getActiveTheme();
  Future<List<AppThemeScheme>> getSavedThemes();
  Future<void> saveTheme(AppThemeScheme scheme);
  Future<void> activateTheme(String id);
}
