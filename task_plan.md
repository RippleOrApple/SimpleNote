# Task Plan: SimpleNote Phase 5 Theme Customization

## Goal

Build database-backed theme customization with presets, editable colors, saved themes, activation, reset, and startup restore.

## Current Phase

Complete

## Phases

### Phase 1: Requirements & Discovery

- [x] Read `GOAL.md`
- [x] Inspect existing theme model, repository, controller, Settings UI, and database DAO
- [x] Document findings in `findings.md`
- **Status:** complete

### Phase 2: Planning & Structure

- [x] Choose theme controller state shape
- [x] Choose low-dependency color editing approach
- [x] Choose preset and saved theme activation flow
- [x] Choose test strategy
- **Status:** complete

### Phase 3: Implementation

- [x] Expand theme model with presets and copy helpers
- [x] Connect theme controller to `ThemeRepository`
- [x] Load active theme on startup
- [x] Build Settings theme preset and saved-theme controls
- [x] Build simple color swatches and brightness toggle
- [x] Save custom themes and restore default theme
- **Status:** complete

### Phase 4: Testing & Verification

- [x] Add or update theme controller tests
- [x] Add or update widget tests for settings theme behavior
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

1. Should P5 add a full color picker dependency?
   - No. Use curated swatches and simple controls for the MVP.
2. Should theme state remain synchronous?
   - No. It must load persisted active theme, so use async state with a safe Minimal Light fallback in `MaterialApp`.
3. Should saved custom themes be separate from presets?
   - Use the same database-backed list, seeding presets first and allowing custom themes to appear alongside them.

## Decisions Made

| Decision | Rationale |
|----------|-----------|
| Use `AsyncNotifier<ThemeState>` | Matches async persistence and startup restore needs |
| Seed presets through the repository/controller | Ensures Settings always has useful selectable themes |
| Use Material swatches instead of a package | Keeps P5 small and testable |
| Keep reset as activating Minimal Light | Matches user expectation and avoids deleting custom themes |

## Errors Encountered

| Error | Attempt | Resolution |
|-------|---------|------------|
| `ThemeController` failed after provider invalidation because `_repository` was `late final` | 1 | Changed `_repository` to `late` so Riverpod rebuilds can refresh the dependency |
| Settings widget test expected `LAN sync` in the first viewport after Settings grew longer | 1 | Updated the test to assert the visible P5 theme controls instead |
| Settings widget test used `scrollUntilVisible` with a finder matching multiple widgets | 1 | Removed the unnecessary scroll and asserted the saved custom theme text |

## Notes

- Preserve the local lightweight route transition improvement.
- Keep LAN sync out of scope.
- Update `progress.md` after implementation and testing steps.
