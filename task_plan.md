# Task Plan: SimpleNote Phase 1 App Shell

## Goal

Build a clear, low-clutter application shell so users can navigate between Notes, Todos, and Settings on Android and Windows-sized layouts without errors.

## Current Phase

Complete

## Phases

### Phase 1: Requirements & Discovery

- [x] Read `GOAL.md`
- [x] Identify scope, non-goals, constraints, and acceptance criteria
- [x] Inspect current app shell, routes, pages, and tests
- [x] Document findings in `findings.md`
- **Status:** complete

### Phase 2: Planning & Structure

- [x] Decide responsive shell approach
- [x] Decide page empty-state and action patterns
- [x] Decide test coverage needed for navigation and shell behavior
- **Status:** complete

### Phase 3: Implementation

- [x] Improve shared `AppShell`
- [x] Improve Notes, Todos, and Settings page layouts
- [x] Keep scope limited to navigation and shell UI
- **Status:** complete

### Phase 4: Testing & Verification

- [x] Add or update widget tests
- [x] Run `flutter analyze`
- [x] Run `flutter test`
- [x] Verify acceptance criteria against `GOAL.md`
- **Status:** complete

### Phase 5: Delivery

- [x] Update `GOAL.md` acceptance checkboxes
- [x] Update planning files with final results
- [x] Summarize changes and residual risk
- **Status:** complete

## Key Questions

1. How should navigation adapt across Android and Windows-sized layouts?
   - Use a bottom `NavigationBar` on compact screens and a side `NavigationRail` on wider screens.
2. How much functionality should Phase 1 implement?
   - Only the app shell, navigation, consistent page structure, empty states, and obvious primary actions. Persistence, full editing, and sync stay out of scope.
3. What tests are needed?
   - Widget tests should verify app startup, navigation to all pages, and basic responsive shell behavior.

## Decisions Made

| Decision | Rationale |
|----------|-----------|
| Use `NavigationBar` for compact layouts and `NavigationRail` for wide layouts | Matches Android and desktop expectations while keeping one shared shell |
| Keep page content as lightweight placeholders plus current in-memory demo actions | Phase 1 is about navigation and structure, not full feature implementation |
| Add reusable empty-state presentation inside pages instead of a new dependency | Keeps UI consistent without adding heavy packages |
| Continue using Material icons and existing Flutter/Riverpod dependencies | Preserves current stack and avoids scope creep |

## Errors Encountered

| Error | Attempt | Resolution |
|-------|---------|------------|
| Dart formatter was run against Markdown files | 1 | Re-run formatter only on Dart source folders: `lib test` |
| Widget tests failed because `setSurfaceSize(null)` ran outside a widget test | 1 | Move surface reset into per-test `addTearDown` inside a helper |
| `git push` failed with connection reset | 1 | Retry push after transient network failure |

## Notes

- Re-read this plan before major decisions.
- Keep all changes within the Phase 1 scope from `GOAL.md`.
- Update `progress.md` after implementation and testing steps.