# Goal

## Objective

Complete Phase 5: build theme customization for SimpleNote.

Users should be able to personalize the app by changing background color, primary button color, text color, and surface/card color. Themes should be saved locally, selectable later, and restored automatically when the app starts.

## Scope

- What should change:
  - Load the active theme from the local Drift database when the app starts.
  - Save theme schemes through the existing theme repository.
  - Allow users to edit:
    - Background color.
    - Primary/action button color.
    - Text color.
    - Surface/card color.
    - Light/dark brightness.
  - Show an immediate live preview when a theme is applied.
  - Save custom theme schemes.
  - Switch between saved theme schemes.
  - Restore the default theme.
  - Provide useful preset themes:
    - Minimal Light.
    - Night Black.
    - Eye Comfort Green.
    - Soft Purple.
    - Cool Gray Blue.
  - Preserve the existing Notes MVP, Todos MVP, database, and navigation behavior.

- What files, features, or workflows are in scope:
  - `lib/core/theme/app_theme.dart`
  - `lib/features/settings/domain/theme_scheme.dart`
  - `lib/features/settings/application/theme_controller.dart`
  - `lib/features/settings/data/theme_repository.dart`
  - `lib/features/settings/presentation/settings_page.dart`
  - `lib/database/daos/theme_schemes_dao.dart`
  - Theme-focused tests.
  - `task_plan.md`
  - `findings.md`
  - `progress.md`

## Non-goals

- What should not change:
  - Do not implement LAN sync in this phase.
  - Do not implement cloud accounts or authentication.
  - Do not redesign the Notes MVP.
  - Do not redesign the Todos MVP.
  - Do not introduce heavy design-system or color-picker dependencies unless necessary.
  - Do not build image backgrounds or font customization in this phase.

- What should be left for later:
  - Phase 6: LAN sync MVP.
  - Advanced appearance controls such as fonts, spacing, and background images.
  - Import/export of theme packs.
  - Per-note or per-todo themes.

## Acceptance Criteria

- [x] The app loads the active theme from local storage on startup.
- [x] If no theme is saved, the app uses Minimal Light.
- [x] Preset themes are available in Settings.
- [x] A user can switch to Minimal Light.
- [x] A user can switch to Night Black.
- [x] A user can switch to Eye Comfort Green.
- [x] A user can switch to Soft Purple.
- [x] A user can switch to Cool Gray Blue.
- [x] A user can edit the background color.
- [x] A user can edit the primary/action button color.
- [x] A user can edit the text color.
- [x] A user can edit the surface/card color.
- [x] A user can toggle light/dark brightness.
- [x] Theme changes visibly apply to the app immediately.
- [x] A custom theme can be saved.
- [x] A saved custom theme appears in the saved themes list.
- [x] A saved custom theme can be activated later.
- [x] Restoring the default theme activates Minimal Light.
- [x] Theme changes persist after the controller/app reloads.
- [x] Existing Notes, Todos, and Settings navigation still works.
- [x] Notes MVP behavior remains covered by tests.
- [x] Todos MVP behavior remains covered by tests.
- [x] Relevant theme tests are added or updated.
- [x] `flutter analyze` passes.
- [x] `flutter test` passes.
- [x] The final result is ready for Phase 6 without expanding into sync work.

## Constraints

- Existing patterns to preserve:
  - Keep Flutter as the cross-platform framework.
  - Keep Riverpod as the state management direction.
  - Keep the current feature-based directory structure.
  - Keep theme persistence under the existing Drift database and theme repository.
  - Keep Settings as the home for customization controls.
  - Keep the UI simple, direct, and suitable for Windows and Android.
  - Keep the recently improved lightweight route transition behavior intact.

- Technical limits:
  - Avoid adding a large color-picker dependency for this MVP.
  - Use simple swatches or compact controls that are easy to test.
  - Windows desktop runtime may still require Visual Studio C++ workload.
  - Android verification should use the `SimpleNote_Pixel` emulator when runtime validation is needed.

- Compatibility requirements:
  - The app should continue to target Windows and Android.
  - The app should continue to build with Flutter 3.44.4 / Dart 3.12.2.
  - The Android emulator target is Android 16 / API 36.

## Notes

- Extra context:
  - This goal corresponds to `docs/DEVELOPMENT_PHASES.md`, Phase 5 theme customization.
  - Phase 1 completed the app shell and navigation.
  - Phase 2 completed the Drift database and database-backed repositories.
  - Phase 3 completed the Notes MVP.
  - Phase 4 completed the Todos MVP.
  - A small local navigation transition improvement currently exists and should be preserved.

- Links or examples:
  - `docs/DEVELOPMENT_PHASES.md`
  - `docs/ARCHITECTURE.md`
  - `task_plan.md`
  - `findings.md`
  - `progress.md`
