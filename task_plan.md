# Task Plan: SimpleNote Phase 3 Notes MVP

## Goal

Build a database-backed Notes MVP with create, edit, delete, search, tags, tag filtering, and Markdown edit/preview.

## Current Phase

Complete

## Phases

### Phase 1: Requirements & Discovery

- [x] Read `GOAL.md`
- [x] Identify P3 scope, non-goals, constraints, and acceptance criteria
- [x] Inspect current notes controller, notes UI, repositories, tags, DAOs, and tests
- [x] Document findings in `findings.md`
- **Status:** complete

### Phase 2: Planning & Structure

- [x] Choose controller state shape
- [x] Choose notes/tag repository additions
- [x] Choose editor UI structure
- [x] Choose test strategy
- **Status:** complete

### Phase 3: Implementation

- [x] Add note/tag repository methods needed by UI
- [x] Rework notes controller to load and persist notes/tags
- [x] Build notes list search and tag filtering
- [x] Build note editor with title/body editing
- [x] Add edit/preview mode switching
- [x] Add tag creation and assignment
- **Status:** complete

### Phase 4: Testing & Verification

- [x] Add or update notes tests
- [x] Run code generation if needed
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

1. Should notes controller become database-backed now?
   - Yes. P3 explicitly requires persisted notes and reload behavior.
2. Should the notes editor be a separate route?
   - No for this MVP. Keep it inside the Notes page as a responsive list/detail workspace to minimize routing churn.
3. Should tag assignment support multiple tags?
   - Yes at the data layer and UI list chips; filtering can focus on one selected tag at a time.

## Decisions Made

| Decision | Rationale |
|----------|-----------|
| Use `AsyncNotifier<NotesState>` for notes | Handles database loading and async persistence while remaining Riverpod-native |
| Keep editor inside `NotesPage` | Provides a usable MVP without adding route complexity |
| Add repository methods for note-tag links | Keeps UI/controller out of DAO details |
| Test controller/repository behavior with in-memory Drift database | Verifies persistence without relying on platform paths |

## Errors Encountered

| Error | Attempt | Resolution |
|-------|---------|------------|
| Widget tests timed out in `pumpAndSettle` because Notes loading uses an animated progress indicator | 1 | Inject in-memory database and use fixed pumps instead of waiting for all animations to settle |
| Markdown widget test could not find bold text with `find.text` | 1 | Assert rendered Markdown inline content through `RichText.toPlainText()` |

## Notes

- Re-read this plan before major decisions.
- Keep todos and sync out of scope.
- Update `progress.md` after implementation and testing steps.
