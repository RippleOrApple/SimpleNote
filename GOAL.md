# Goal

## Objective

Complete Phase 1: build a clear application shell and page navigation structure for SimpleNote.

Users should be able to move between Notes, Todos, and Settings without errors, and each page should have a simple, consistent layout that works as the foundation for later feature development.

## Scope

- What should change:
  - Improve the shared app shell.
  - Improve navigation between Notes, Todos, and Settings.
  - Make the three core pages visually consistent.
  - Standardize page titles, empty states, and primary actions.
  - Keep the UI simple and suitable for both Windows and Android.

- What files, features, or workflows are in scope:
  - `lib/app.dart`
  - `lib/core/routing/app_routes.dart`
  - `lib/shared/widgets/app_shell.dart`
  - `lib/features/notes/presentation/notes_page.dart`
  - `lib/features/todos/presentation/todos_page.dart`
  - `lib/features/settings/presentation/settings_page.dart`
  - Basic navigation workflow:
    - Notes page
    - Todos page
    - Settings page

## Non-goals

- What should not change:
  - Do not implement SQLite or Drift persistence yet.
  - Do not implement full note editing yet.
  - Do not implement full todo editing yet.
  - Do not implement real LAN sync yet.
  - Do not introduce account login, cloud sync, or user authentication.

- What should be left for later:
  - Phase 2: local database integration.
  - Phase 3: notes MVP.
  - Phase 4: todos MVP.
  - Phase 5: theme customization.
  - Phase 6: LAN sync MVP.

## Acceptance Criteria

- [x] The app starts successfully.
- [x] The Notes page can be opened.
- [x] The Todos page can be opened.
- [x] The Settings page can be opened.
- [x] Navigation between the three pages does not throw errors.
- [x] Page titles are clear and consistent.
- [x] Empty states are clear and consistent.
- [x] Primary actions are easy to identify.
- [x] The layout is usable on Android-sized screens.
- [x] The layout remains reasonable on Windows-sized screens.
- [x] Relevant widget tests are added or updated.
- [x] `flutter analyze` passes.
- [x] `flutter test` passes.
- [x] The final result matches the intended simple, low-clutter user experience.

## Constraints

- Existing patterns to preserve:
  - Keep Flutter as the cross-platform framework.
  - Keep Riverpod as the state management direction.
  - Keep the current feature-based directory structure.
  - Keep shared UI shell logic in `lib/shared/widgets/app_shell.dart`.
  - Keep route definitions centralized in `lib/core/routing/app_routes.dart`.

- Technical limits:
  - Windows desktop runtime may still require Visual Studio C++ workload.
  - Android verification should use the `SimpleNote_Pixel` emulator.
  - Avoid adding heavy UI dependencies at this stage.
  - Avoid implementing storage or sync logic before the UI shell is stable.

- Compatibility requirements:
  - The app should continue to target Windows and Android.
  - The app should continue to build with Flutter 3.44.4 / Dart 3.12.2.
  - The Android emulator target is Android 16 / API 36.

## Notes

- Extra context:
  - This goal corresponds to `docs/DEVELOPMENT_PHASES.md`, section `?? 1:??????????`.
  - Phase 0 has already initialized the Flutter scaffold and Android emulator.
  - The UI should stay minimal and practical, matching the product direction of a local-first notes and todos app.

- Links or examples:
  - `docs/DEVELOPMENT_PHASES.md`
  - `docs/PHASE_0_SETUP_REPORT.md`
  - `docs/ARCHITECTURE.md`