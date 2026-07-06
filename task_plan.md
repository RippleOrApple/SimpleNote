# Task Plan: SimpleNote Phase 6 LAN Sync MVP

## Goal

Build manual same-Wi-Fi sync with database snapshots, JSON HTTP endpoints, client exchange, merge rules, controller state, Settings controls, and tests.

## Current Phase

Complete

## Phases

### Phase 1: Requirements & Discovery

- [x] Read `GOAL.md`
- [x] Inspect existing sync domain, controller, repository, server, client, Settings UI, and database repositories
- [x] Document findings in `findings.md`
- **Status:** complete

### Phase 2: Planning & Structure

- [x] Choose snapshot JSON format
- [x] Choose merge strategy for notes and todos
- [x] Choose HTTP endpoint contract
- [x] Choose controller state shape
- [x] Choose test strategy
- **Status:** complete

### Phase 3: Implementation

- [x] Add JSON serialization for sync models and synced entities
- [x] Add repository/DAO methods for all-record export and merge import
- [x] Implement Drift-backed sync repository
- [x] Implement local sync server endpoints
- [x] Implement sync API client methods
- [x] Rework sync controller for server lifecycle and peer sync
- [x] Add manual LAN sync controls to Settings
- **Status:** complete

### Phase 4: Testing & Verification

- [x] Add sync repository tests
- [x] Add server/client tests
- [x] Add controller or widget coverage for Settings sync controls
- [x] Run `flutter analyze`
- [x] Run `flutter test`
- [x] Verify acceptance criteria against `GOAL.md`
- **Status:** complete

### Phase 5: Delivery

- [x] Update `GOAL.md` acceptance checkboxes
- [x] Update planning files with final results
- [x] Submit PR with `scripts/update_pr.ps1`
- **Status:** complete

## Key Questions

1. Should sync use automatic device discovery?
   - No. P6 is manual address entry only.
2. Should tags and themes use full conflict accounting?
   - Keep notes/todos counts in `SyncResult`; still merge tags/themes by latest timestamps or active flags for usable snapshots.
3. Should the sync server own repository creation?
   - Inject `SyncRepository` and `DeviceInfo` so tests can use in-memory databases.

## Decisions Made

| Decision | Rationale |
|----------|-----------|
| Use JSON over `dart:io` HTTP | No dependency and works for Windows/Android LAN MVP |
| Use pull-then-push peer sync | Both devices receive the newest snapshot in one manual action |
| Merge by effective changed time | Matches existing `MergePolicy` and handles deletion conflicts |
| Keep Settings controls simple | P6 is functional sync, polish belongs to P7 |

## Errors Encountered

| Error | Attempt | Resolution |
|-------|---------|------------|
| Analyzer flagged unnecessary nested `const` in sync repository test | 1 | Removed inner `const` keywords |
| Widget test scroll target matched multiple route-transition widgets | 1 | Added a stable `settings-list` key and used `dragUntilVisible` |

## Notes

- Preserve P5 theme customization and route transition changes.
- Keep sync failure non-destructive.
- PR submission remains the last step.
