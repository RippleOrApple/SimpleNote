part of '../app_database.dart';

@DriftAccessor(tables: [ThemeSchemes])
class ThemeSchemesDao extends DatabaseAccessor<AppDatabase>
    with _$ThemeSchemesDaoMixin {
  ThemeSchemesDao(super.db);

  Future<ThemeSchemeRow?> activeTheme() {
    return (select(themeSchemes)..where((theme) => theme.isActive.equals(true)))
        .getSingleOrNull();
  }

  Future<List<ThemeSchemeRow>> savedThemes() {
    return (select(themeSchemes)
          ..orderBy([(theme) => OrderingTerm.asc(theme.name)]))
        .get();
  }

  Future<void> upsertTheme(ThemeSchemesCompanion theme) {
    return into(themeSchemes).insertOnConflictUpdate(theme);
  }

  Future<void> activateTheme(String id) async {
    await transaction(() async {
      await update(themeSchemes).write(
        const ThemeSchemesCompanion(isActive: Value(false)),
      );
      await (update(themeSchemes)..where((theme) => theme.id.equals(id))).write(
        const ThemeSchemesCompanion(isActive: Value(true)),
      );
    });
  }
}
