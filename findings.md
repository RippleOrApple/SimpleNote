# Findings & Decisions

## Requirements

- Complete Phase 5 from `GOAL.md`: theme customization.
- Load active theme from local storage at startup.
- Provide preset themes and saved custom themes.
- Allow editing background, primary/action, text, surface/card colors, and brightness.
- Save and activate custom themes through the existing Drift-backed theme repository.
- Preserve Notes MVP, Todos MVP, and navigation behavior.
- Add/update tests.
- `flutter analyze` and `flutter test` must pass.

## Research Findings

- `AppThemeScheme` currently only defines `minimalLight`.
- `AppTheme.fromScheme` already applies background, primary, text, surface, and brightness inputs.
- `ThemeRepository` already supports active theme lookup, saved theme lookup, save, and activate.
- `ThemeSchemesDao.activateTheme` deactivates all themes and activates the requested id in one transaction.
- `ThemeController` is currently synchronous and in-memory only.
- `SettingsPage` only shows the current theme and restore-default action.
- `MaterialApp` currently watches `themeControllerProvider` directly, so it must handle async startup cleanly.
- A local route transition improvement is currently uncommitted and should be preserved.

## Technical Decisions

| Decision | Rationale |
|----------|-----------|
| Use `AsyncNotifier<ThemeState>` | Supports database loading and saved-theme lists |
| Keep Minimal Light as the startup fallback while loading | Avoids a blank app during database startup |
| Seed presets before reading saved themes | Makes presets available on first launch |
| Use fixed color swatches | Satisfies MVP customization without heavy dependencies |
| Save custom themes with generated ids | Prevents overwriting presets while keeping the UI simple |

## Issues Encountered

| Issue | Resolution |
|-------|------------|
| `ThemeController` can rebuild after invalidation in tests, so a `late final` repository field is too strict | Use `late ThemeRepository` and assign during `build()` |
| Settings page grew beyond the old first-viewport assumptions | Updated widget tests to assert visible P5 controls and custom theme behavior |

## Resources

- `GOAL.md`
- `docs/DEVELOPMENT_PHASES.md`
- `lib/core/theme/app_theme.dart`
- `lib/features/settings/domain/theme_scheme.dart`
- `lib/features/settings/application/theme_controller.dart`
- `lib/features/settings/data/theme_repository.dart`
- `lib/features/settings/presentation/settings_page.dart`
- `lib/database/daos/theme_schemes_dao.dart`

## Visual/Browser Findings

- No browser or image findings for this implementation step.
