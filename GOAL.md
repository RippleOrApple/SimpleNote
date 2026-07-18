# Goal

## Objective

Complete V2 Task 17: make task date queries and smart-filter date rules fully active.

Today, Next 7 Days, and saved smart filters should understand both task start time and due time instead of only matching the old due-date path. Date filtering should be deterministic, repository-backed, and available to the existing filter editor.

## Scope

- Extend task filter rules with start-date and due-date ranges.
- Preserve JSON compatibility for existing smart filters that do not contain date rules.
- Update Today to include unfinished top-level tasks that are overdue, due today, or start today.
- Update Next 7 Days to include unfinished top-level tasks whose start or due time falls inside the seven-day window.
- Update smart-filter repository evaluation to apply start and due ranges.
- Replace the disabled date placeholder in the smart-filter editor with active date-range controls.
- Update domain, repository, controller, and widget tests.
- Update planning files with findings and verification results.

## Non-goals

- Do not build calendar views yet.
- Do not add natural-language date parsing.
- Do not add drag-to-reschedule.
- Do not schedule native notifications.
- Do not re-enable V2 sync.

## Acceptance Criteria

- [x] Task filter rules JSON round-trips start and due date ranges.
- [x] Existing smart-filter JSON without date ranges still loads.
- [x] Inbox excludes tasks with either `startAt` or `dueAt`.
- [x] Today includes overdue tasks, tasks due today, and tasks starting today.
- [x] Today excludes tasks starting after today and tasks due after today.
- [x] Next 7 Days includes tasks whose start or due time falls in the seven-day window.
- [x] Smart filters can match start ranges, due ranges, and combined start/due ranges.
- [x] Date filters combine with list, tag, completion, and priority rules.
- [x] The smart-filter editor exposes active start/due date-range controls instead of a disabled placeholder.
- [x] `dart format --output=none --set-exit-if-changed lib test` passes.
- [x] `flutter analyze` passes.
- [x] Relevant tests pass.

## Constraints

- Keep date values as epoch milliseconds.
- Keep date ranges inclusive at the lower bound and exclusive at the upper bound.
- Keep query behavior top-level only unless explicitly listing subtasks.
- Prefer repository-level date behavior over UI-only filtering.

## Notes

- Calendar aggregation remains Task 18.
- Reminder scheduling remains Task 19.
- V2 sync remains Phase 4.
