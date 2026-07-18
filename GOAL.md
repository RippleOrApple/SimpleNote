# Goal

## Objective

Complete V2 Task 16: add task completion events and recurring-task advancement.

Task completion should become a durable event stream for future history and statistics. Completing a recurring task should write a completion event, compute the next occurrence, keep the same task ID, and advance the task back to an incomplete future occurrence.

## Scope

- Add `task_completions` persistence and domain contracts.
- Add repository APIs for listing completion events and completing a task occurrence transactionally.
- Record completion events for normal task completion.
- For recurring tasks, compute the next occurrence before writing any data.
- Support daily, workday, weekly, monthly, and yearly recurrence rules with optional `INTERVAL`.
- Support weekly `BYDAY` selections.
- Respect recurrence end dates and occurrence counts.
- Preserve task state if recurrence parsing or next-date calculation fails.
- Route `TasksController.toggleTask` through the repository completion transaction.
- Update schema, domain, repository, and controller tests.
- Update planning files with findings and verification results.

## Non-goals

- Do not build recurrence editing UI yet.
- Do not add calendar views yet.
- Do not schedule native notifications yet.
- Do not implement per-occurrence exceptions.
- Do not re-enable V2 sync.

## Acceptance Criteria

- [x] New databases include `task_completions`.
- [x] Schema 2 databases migrate to include `task_completions`.
- [x] `TaskCompletion` JSON round-trips.
- [x] Completing a normal task marks it completed and writes one completion event.
- [x] Completing a recurring task writes one completion event and advances the same task ID to the next incomplete occurrence.
- [x] Daily, workday, weekly `BYDAY`, monthly, and yearly rules calculate the expected next occurrence.
- [x] Recurrence `INTERVAL` is respected.
- [x] Recurrence end date and count stop further advancement.
- [x] Invalid recurrence rules leave the task unchanged and write no completion event.
- [x] Controller completion uses the transactional completion path.
- [x] `dart run build_runner build --delete-conflicting-outputs` passes.
- [x] `dart format --output=none --set-exit-if-changed lib test` passes.
- [x] `flutter analyze` passes.
- [x] Relevant tests pass.

## Constraints

- Keep recurrence parsing deterministic and dependency-free.
- Keep recurrence data in the existing `recurrence_rule`, `recurrence_end_at`, and `recurrence_count` task fields.
- Keep Task 16 limited to persistence, domain, and application behavior.
- Keep V1 sync disabled in production.

## Notes

- Accepted rule shape is `FREQ=DAILY`, `FREQ=WORKDAYS`, `FREQ=WEEKLY;BYDAY=MO,WE`, `FREQ=MONTHLY`, or `FREQ=YEARLY`, with optional `INTERVAL=n`.
- Task 17 should make date filtering richer.
- Task 18 should introduce calendar aggregation.
- Task 19 should schedule native reminders.
