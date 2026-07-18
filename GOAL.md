# Goal

## Objective

Complete V2 Task 19: add reminder scheduling.

Task reminders already persist as absolute or relative definitions. This task
adds the application scheduling layer that resolves those definitions into
local notification requests without letting notification code own task data.

## Scope

- Add a platform notification scheduling interface and no-op default adapter.
- Add reminder schedule domain objects.
- Query pending task reminder schedules from the task repository.
- Resolve absolute `triggerAt` reminders.
- Resolve relative `offsetMinutes` reminders from due time, falling back to
  start time.
- Exclude fired, past, deleted, completed, and unanchored relative reminders.
- Reconcile pending reminders into platform notification requests.
- Cancel task reminder notifications for deleted or completed tasks.
- Mark reminders as fired.
- Add repository and scheduler tests.
- Update planning files with findings and verification results.

## Non-goals

- Do not add reminder UI controls yet.
- Do not add a real native notification plugin in this task.
- Do not request Android notification permissions yet.
- Do not add recurring reminder UI.
- Do not add sync behavior.

## Acceptance Criteria

- [x] Absolute reminders are converted to scheduled notification requests.
- [x] Relative reminders are resolved from due time, falling back to start time.
- [x] Fired reminders are excluded from pending schedules.
- [x] Past reminders are excluded from pending schedules.
- [x] Reminders for completed or soft-deleted tasks are excluded.
- [x] Relative reminders without a task start/due anchor are excluded.
- [x] Reminder reconciliation cancels stale task reminder notification IDs.
- [x] Reminder reconciliation schedules all pending reminders inside the horizon.
- [x] Marking a reminder fired persists `firedAt` and cancels its notification.
- [x] `dart format --output=none --set-exit-if-changed lib test` passes.
- [x] `flutter analyze` passes.
- [x] Relevant tests pass.

## Constraints

- Keep date values as epoch milliseconds.
- Keep notification platform integration behind an interface.
- Keep task repository as the source of reminder/task truth.
- Use deterministic notification IDs derived from reminder IDs.

## Notes

- A native notification adapter can replace the no-op adapter later.
- Reminder UI remains a later task.
- V2 sync remains Phase 4.
