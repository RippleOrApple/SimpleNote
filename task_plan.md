# Task Plan: SimpleNote Phase 4 Todos MVP

## Goal

Build a database-backed Todos MVP with create, edit, complete/uncomplete, delete, due date, priority, filtering, and persistence.

## Current Phase

Complete

## Phases

### Phase 1: Requirements & Discovery

- [x] Read `GOAL.md`
- [x] Identify P4 scope, non-goals, constraints, and acceptance criteria
- [x] Inspect current todos controller, todos UI, repository, DAO, and tests
- [x] Document findings in `findings.md`
- **Status:** complete

### Phase 2: Planning & Structure

- [x] Choose controller state shape
- [x] Choose todos repository additions
- [x] Choose editor UI structure
- [x] Choose test strategy
- **Status:** complete

### Phase 3: Implementation

- [x] Add todo repository methods needed by UI
- [x] Rework todos controller to load and persist todos
- [x] Build todo list filtering
- [x] Build todo editor with title/description editing
- [x] Add completion, due date, priority, and delete controls
- **Status:** complete

### Phase 4: Testing & Verification

- [x] Add or update todo tests
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

1. Should todos controller become database-backed now?
   - Yes. P4 explicitly requires persisted todos and reload behavior.
2. Should todos editor be a separate route?
   - No. Use an in-page list/detail editor, mirroring Notes MVP.
3. Should date selection use a calendar package?
   - No. Use Flutter Material `showDatePicker` and a clear-date action.

## Decisions Made

| Decision | Rationale |
|----------|-----------|
| Use `AsyncNotifier<TodosState>` for todos | Mirrors Notes MVP and supports async database persistence |
| Keep editor inside `TodosPage` | Provides a usable MVP without adding route complexity |
| Use built-in Material date picker | Meets due-date requirement without adding dependencies |
| Test controller with in-memory Drift database | Verifies persistence without platform filesystem setup |

## Errors Encountered

| Error | Attempt | Resolution |
|-------|---------|------------|
| Todos widget test tapped `New todo` before the async Todos page finished loading | 1 | Wait longer after navigation and tap the `New todo` FAB by tooltip |
| Todos widget test navigation by rail label was unstable | 2 | Navigate directly to `/todos` in the feature-focused widget test |

## Notes

- If interrupted before completion, create `P4_STATUS.md` with completed and remaining items.
- Keep notes, theme, sync, and advanced reminders out of scope.
- Update `progress.md` after implementation and testing steps.
