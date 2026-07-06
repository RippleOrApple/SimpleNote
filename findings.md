# Findings & Decisions

## Requirements

- Complete Phase 1 from `GOAL.md`: application shell and page navigation.
- Users must be able to open Notes, Todos, and Settings.
- Navigation must not throw errors.
- Page titles, empty states, and primary actions should be clear and consistent.
- Layout should work on Android-sized screens and remain reasonable on Windows-sized screens.
- Relevant widget tests must be added or updated.
- `flutter analyze` and `flutter test` must pass.

## Research Findings

- Current project is a Flutter app using `MaterialApp`, Riverpod, feature folders, and route definitions in `lib/core/routing/app_routes.dart`.
- Current `AppShell` uses a bottom `NavigationBar` only, which is suitable for Android but less ideal for Windows-sized layouts.
- Current pages exist for Notes, Todos, and Settings, but their page content is still skeletal and inconsistent.
- Current tests include:
  - `test/domain/merge_policy_test.dart`
  - `test/widget_test.dart`
- Phase 0 created an Android emulator named `SimpleNote_Pixel` under `D:\Tool\Android Studio\avd`.

## Technical Decisions

| Decision | Rationale |
|----------|-----------|
| Use responsive navigation in `AppShell` | Satisfies Android and Windows layout acceptance criteria without duplicating pages |
| Keep route names centralized in `AppRoutes` | Matches existing architecture and `GOAL.md` constraints |
| Use simple Material components only | Avoids adding UI dependencies during Phase 1 |
| Use widget tests for startup and route navigation | Directly validates the user-facing acceptance criteria |
| Add a small shared `EmptyState` widget | Standardizes page empty states and primary actions without adding dependencies |

## Issues Encountered

| Issue | Resolution |
|-------|------------|
| `app_shell.dart` briefly contained leftover old code after patching | Inspected the file and removed the duplicate trailing block before running tests |
| Dart formatter was run against Markdown files | Logged as a workflow error and switched to formatting only `lib` and `test` |
| Widget test surface reset failed outside test body | Use `addTearDown` from inside the helper that sets the test surface size |

## Resources

- `GOAL.md`
- `docs/DEVELOPMENT_PHASES.md`
- `docs/ARCHITECTURE.md`
- `docs/PHASE_0_SETUP_REPORT.md`
- `lib/shared/widgets/app_shell.dart`
- `lib/core/routing/app_routes.dart`

## Visual/Browser Findings

- No browser or image findings for this implementation step.
