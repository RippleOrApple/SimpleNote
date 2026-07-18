# Goal

## Objective

Complete V2 Task 15: establish the Phase 2 task time and reminder foundation.

Phase 1 already introduced the core task time fields on `tasks_v2`; this task should finish the first Phase 2 database step by moving the schema to version 3, adding reminder persistence, and exposing reminder contracts through the task domain and repository layer.

## Scope

- Add schema v3 migration support.
- Add the `task_reminders` table.
- Keep existing `tasks_v2` start time, due time, all-day, and recurrence columns intact.
- Add a `TaskReminder` domain model with JSON round-trip support.
- Add repository methods for listing, upserting, and soft-deleting task reminders.
- Validate that a reminder uses exactly one of absolute `triggerAt` or relative `offsetMinutes`.
- Ensure reminders belong to an existing active task.
- Soft-delete reminders when their task is soft-deleted.
- Update schema, migration, domain, and repository tests.
- Update planning files with findings and verification results.

## Non-goals

- Do not build reminder UI in the task detail pane yet.
- Do not schedule platform notifications yet.
- Do not implement recurrence advancement or completion event history yet.
- Do not build calendar views yet.
- Do not re-enable V2 sync.

## Acceptance Criteria

- [x] New databases use schema version 3.
- [x] Existing schema 1 databases migrate through schema 2 and schema 3.
- [x] Existing schema 2 databases migrate to schema 3 without losing V2 tasks.
- [x] `task_reminders` exists with required sync metadata fields.
- [x] `task_reminders` enforces exactly one of `trigger_at` or `offset_minutes`.
- [x] Task reminders can be created, updated, listed, and soft-deleted through the repository.
- [x] Creating a reminder for a missing or deleted task fails.
- [x] Soft-deleting a task also soft-deletes its reminders.
- [x] Task and reminder domain JSON round-trip tests pass.
- [x] `dart run build_runner build --delete-conflicting-outputs` passes.
- [x] `dart format --output=none --set-exit-if-changed lib test` passes.
- [x] `flutter analyze` passes.
- [x] Relevant tests pass.

## Constraints

- Keep Flutter, Riverpod, Drift, and the current feature-layer structure.
- Keep Task 15 limited to persistence/domain/application contracts.
- Prefer repository-level behavior tests before UI work.
- Keep V1 sync disabled in production.

## Notes

- V2 Phase 2 covers time, recurrence, reminders, and calendar.
- Task 16 should own recurrence completion events and next-date advancement.
- Task 17 should make date rules in Today, Next 7 Days, and smart filters richer.
- Task 18 should introduce calendar aggregation UI.
- Task 19 should schedule native reminders.
