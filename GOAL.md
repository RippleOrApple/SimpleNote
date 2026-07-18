# Goal

## Objective

Complete V2 Task 18: add a calendar aggregation layer.

Calendar should be able to query a deterministic time window and return
read-only entries from existing modules. It must not own task, note, habit, or
notification data.

## Scope

- Add calendar domain objects for entries and day buckets.
- Aggregate active top-level task start and due markers.
- Aggregate active note creation dates.
- Expand active recurring task schedules inside a queried range.
- Keep completed tasks visible with completion metadata.
- Exclude soft-deleted tasks, soft-deleted notes, and subtasks.
- Provide a Riverpod controller for loading calendar ranges.
- Add repository and controller tests.
- Update planning files with findings and verification results.

## Non-goals

- Do not build the full month/week/day calendar UI yet.
- Do not add drag-to-reschedule.
- Do not schedule native notifications.
- Do not add habit aggregation until habits exist.
- Do not add sync behavior.

## Acceptance Criteria

- [x] Calendar entries represent task starts, task dues, and note creation dates.
- [x] Calendar day buckets are grouped by local day start and sorted deterministically.
- [x] Tasks with both start and due dates produce the expected markers.
- [x] Completed non-deleted tasks remain visible as completed calendar entries.
- [x] Soft-deleted tasks, soft-deleted notes, and subtasks are excluded.
- [x] Recurring active tasks expand inside the requested range.
- [x] Recurrence end dates and recurrence counts cap expanded entries.
- [x] Invalid recurrence rules do not crash calendar aggregation.
- [x] The calendar controller can load and replace a requested date range.
- [x] `dart format --output=none --set-exit-if-changed lib test` passes.
- [x] `flutter analyze` passes.
- [x] Relevant tests pass.

## Constraints

- Keep date values as epoch milliseconds.
- Keep queried ranges inclusive at the lower bound and exclusive at the upper
  bound.
- Calendar must remain a read-only aggregation layer.
- Prefer repository-level aggregation over UI-only filtering.

## Notes

- Full visual calendar screens can build on this aggregation in a later task.
- Reminder scheduling remains Task 19.
- V2 sync remains Phase 4.
