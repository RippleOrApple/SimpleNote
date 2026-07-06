# Task Plan: SimpleNote Phase 2 Local Database

## Goal

Connect SimpleNote to local SQLite persistence with Drift so core data can be stored and queried through database-backed repositories.

## Current Phase

Complete

## Phases

### Phase 1: Requirements & Discovery

- [x] Read `GOAL.md`
- [x] Identify Phase 2 scope, non-goals, constraints, and acceptance criteria
- [x] Inspect current database placeholders, repository interfaces, models, and tests
- [x] Document findings in `findings.md`
- **Status:** complete

### Phase 2: Planning & Structure

- [x] Choose Drift schema layout
- [x] Choose repository implementation pattern
- [x] Choose test strategy for local database behavior
- **Status:** complete

### Phase 3: Implementation

- [x] Add Drift / SQLite dependencies
- [x] Define database tables
- [x] Add DAOs
- [x] Add database provider and initialization
- [x] Implement database-backed repositories
- [x] Generate Drift code
- **Status:** complete

### Phase 4: Testing & Verification

- [x] Add or update database/repository tests
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

1. Should tables live in separate files or inside `app_database.dart`?
   - Tables will live in separate files under `lib/database/tables/`.
2. Should current UI controllers be rewired to repositories in this phase?
   - Not yet. Phase 2 will add database-backed repositories and providers while preserving Phase 1 in-memory UI behavior.
3. How should tests verify persistence without relying on platform file paths?
   - Use Drift in-memory databases for repository tests.

## Decisions Made

| Decision | Rationale |
|----------|-----------|
| Define Drift tables in `lib/database/tables/` and DAOs in `lib/database/daos/` | Matches `GOAL.md` scope and keeps schema/database access organized |
| Keep current UI controllers in memory for now, but add database-backed repositories and providers | Preserves Phase 1 behavior while preparing Phase 3/4 to consume real persistence |
| Use in-memory Drift databases in tests | Verifies repository behavior without depending on platform file paths |

## Errors Encountered

| Error | Attempt | Resolution |
|-------|---------|------------|
| Drift warned that `tableName` must directly return string literals | 1 | Replace table name constants in Drift table classes with string literals |

## Notes

- Re-read this plan before major decisions.
- Keep all changes within the Phase 2 scope from `GOAL.md`.
- Update `progress.md` after implementation and testing steps.
