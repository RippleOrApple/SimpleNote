# Goal

## Objective

Complete V2 Task 20: add reminder UI and scheduling hooks.

Task reminders can already be persisted and reconciled into notification
requests. This task exposes reminder management from the task detail workflow
and triggers reminder reconciliation after task/reminder changes.

## Scope

- Load selected-task reminders into task application state.
- Add controller operations to create absolute reminders.
- Add controller operations to create relative reminders.
- Add controller operations to delete reminders.
- Trigger reminder reconciliation after task time, completion, deletion, and
  reminder changes.
- Add reminder controls to the task detail pane.
- Show existing reminders with deterministic labels and remove actions.
- Disable reminder creation when a task has no start/due anchor.
- Add controller and widget tests.
- Update planning files with findings and verification results.

## Non-goals

- Do not add a real native notification plugin yet.
- Do not request Android notification permissions yet.
- Do not build complex custom date/time pickers.
- Do not add recurring reminder UI.
- Do not add sync behavior.

## Acceptance Criteria

- [x] Selecting a task loads its active reminders into task state.
- [x] Controller can create an absolute reminder for the selected task.
- [x] Controller can create a relative reminder for the selected task.
- [x] Controller can delete an active reminder.
- [x] Reminder create/delete triggers task reminder reconciliation.
- [x] Task time changes trigger task reminder reconciliation.
- [x] Task completion and deletion trigger reminder reconciliation.
- [x] Task detail pane exposes reminder controls.
- [x] Task detail pane displays existing reminders and remove actions.
- [x] Reminder creation controls are disabled when the task has no start/due anchor.
- [x] `dart format --output=none --set-exit-if-changed lib test` passes.
- [x] `flutter analyze` passes.
- [x] Relevant tests pass.

## Constraints

- Keep date values as epoch milliseconds.
- Keep native notification integration behind the existing interface.
- Keep UI controls compact and consistent with the existing task detail panel.
- Use repository and scheduler APIs instead of direct database access from UI.

## Notes

- Full native notification delivery remains a later task.
- V2 sync remains Phase 4.
