# Task Plan: SimpleNote V2 Phase 3 Task 22 Habit Schema

## Goal

建立习惯能力的数据基础：schema 4、习惯表、打卡表、迁移和领域模型。

## Current Phase

Complete

## Phases

### V2 Task 23 Phase 1: Requirements & Discovery

- [x] Read `GOAL.md`
- [x] Read approved Phase 3/4 plan
- [x] Inspect current habit domain models and schema v4 tables
- [x] Inspect existing repository and test patterns
- **Status:** complete

### V2 Task 23 Phase 2: Test-First Contract

- [x] Add failing repository tests for habit CRUD and day-plan queries
- [x] Add failing repository tests for checkin idempotency, cancellation, and re-checkin after cancellation
- [x] Add failing statistics tests for completion rate, cross-week/month streaks, and interval schedules
- **Status:** complete

### V2 Task 23 Phase 3: Implementation

- [x] Add `HabitStatistics`
- [x] Add `HabitsRepository` and Drift implementation
- [x] Add schedule day matching and planned-day iteration helpers
- [x] Add checkin idempotency and soft-delete cancellation behavior
- **Status:** complete

### V2 Task 23 Phase 4: Testing & Verification

- [x] Run focused habits tests
- [x] Run `dart format --output=none --set-exit-if-changed lib test`
- [x] Run `flutter analyze`
- [x] Run broader relevant tests
- **Status:** complete

### V2 Task 23 Phase 5: Delivery

- [x] Update `GOAL.md` acceptance checkboxes
- [x] Update planning files with final results
- **Status:** complete

### Phase 1: Requirements & Discovery

- [x] Read `GOAL.md`
- [x] Read approved V2 design and Phase 3/4 plan
- [x] Inspect current schema v3 database and migrations
- [x] Inspect existing database/domain test patterns
- [x] Inspect generated Drift update requirements
- **Status:** complete

### Phase 2: Planning & Structure

- [x] Choose table definitions and constraints
- [x] Choose `HabitSchedule` JSON shape
- [x] Choose migration coverage
- **Status:** complete

### Phase 3: Implementation

- [x] Add failing schema/domain tests
- [x] Add habit database tables and schema v4 migration
- [x] Add habit domain models
- [x] Run Drift code generation
- **Status:** complete

### Phase 4: Testing & Verification

- [x] Run focused database/habits tests
- [x] Run `dart run build_runner build --delete-conflicting-outputs`
- [x] Run `dart format --output=none --set-exit-if-changed lib test`
- [x] Run `flutter analyze`
- [x] Run relevant broader tests
- [x] Verify acceptance criteria against `GOAL.md`
- **Status:** complete

### Phase 5: Delivery

- [x] Update `GOAL.md` acceptance checkboxes
- [x] Update planning files with final results
- **Status:** complete

## Decisions Made

| Decision | Rationale |
|----------|-----------|
| Start Phase 3 with Task 21 | The approved plan says Calendar UI should be completed before habit entries are added |
| Use existing `CalendarController` | Calendar aggregation already exists and keeps UI away from direct database access |
| Use existing task/note controllers for selection | Avoids adding a calendar-owned detail state |
| Ship an agenda-style first Calendar page | Matches Task 21's minimum page requirement while leaving month/week/day views for later |
| Keep Task 22 below repository layer | The approved plan separates schema/domain from repository/controller/UI in Task 23/24 |
| Store schedule as `schedule_type` plus JSON payload | Matches the approved database design and keeps future schedule variants extensible |
| Keep Task 23 below controller/UI | The approved split assigns application state and pages to Task 24 |
| Compute streaks over planned occurrences | Daily, weekly, weekdays, and interval schedules have different calendar gaps; streaks should count consecutive scheduled opportunities, not raw calendar days |

## Errors Encountered

| Error | Attempt | Resolution |
|-------|---------|------------|
| Compact back action did not really clear selected item because selected getters returned the first item when no id was selected | 1 | Updated selected getters to return null when no selected id exists |
| Todo compact delete test could not find the edit tooltip before the selected getter fix | 1 | Fixed selected state behavior, then reran widget tests |
| `dart format --set-exit-if-changed` repeatedly changed `adaptive_app_shell.dart` | 3 | Found mixed CRLF/LF line endings and rewrote the file with consistent LF line endings before rerunning format |
| PowerShell rejected `git add -A && git status --short && git commit ...` | 1 | Ran the Git commands separately |
| Drift table DSL rejected `length(trim(name))` inside a column check | 1 | Moved the non-empty habit-name validation to a table-level SQL `CHECK` constraint |
| Formatter repeatedly changed mixed-line-ending files after Git checkout/write | 2 | Normalized touched Dart files to LF and reran formatter until stable |
| `dart format --set-exit-if-changed` repeatedly reported `habits_repository.dart` as changed even though the file hash stayed identical | 2 | Used `dart format --output=show` to identify the switch-arm layout it expected, then applied that layout manually |

## V2 Task 22: Habit Schema and Domain Models

- **Status:** complete
- **Started:** 2026-07-19
- Add schema 4 tables for habits and habit checkins.
- Add schema 4 migration and production pre-v4 backup.
- Add `Habit`, `HabitCheckin`, and `HabitSchedule`.
- Cover schema creation, constraints, migrations, and JSON round-trips.
- **Verification:** build_runner, formatter, `flutter analyze`, focused database/habits tests, and full `flutter test` passed with 226 tests.
- **Next:** V2 Task 23, habit repository and statistics calculation foundation.

## V2 Task 21: Calendar Page Completion

- **Status:** complete
- **Started:** 2026-07-19
- Replace the Calendar placeholder with a real page.
- Use the existing read-only calendar aggregation controller.
- Display task start/due entries, recurring task occurrences, and note creation entries.
- Select the matching task or note when an entry is tapped.
- Keep habit source/kind expansion possible for Task 26.
- **Verification:** formatter, `flutter analyze`, focused calendar/navigation tests, and full `flutter test` passed with 220 tests.
- **Next:** V2 Task 22, schema 4 and habit domain models.

## V2 Task 7: Customizable Adaptive Navigation

- **Status:** complete
- **Completed:** 2026-07-18
- Added platform catalogs, navigation persistence, protected Today selection, and per-platform profiles.
- Added the adaptive shell with Android icon-only navigation, Windows frosted rail, and IndexedStack state preservation.
- Added navigation settings with reorder, hide/show, and default-module controls.
- Migrated compatibility routes and updated regression tests to the v2 shell contract.
- **Verification:** `flutter analyze` passed; `flutter test` passed with 130 tests.
- **Next:** V2 Task 8, task domain models, queries, and repository.

## V2 Task 8: Task Domain, Queries, and Repository

- **Status:** complete
- **Completed:** 2026-07-18
- Added Task, TaskList, TaskTag, SmartFilter, TaskFilterRules, TaskQuery, TaskPriority, and TaskSortMode contracts.
- Added tasks_v2 and taxonomy DAO operations plus the transactional V2 task repository.
- Added inbox, today, next-seven-days, all, list, smart-filter, and cross-taxonomy search semantics.
- Enforced one subtask level, parent list inheritance, cascading soft deletes, and active-tag validation.
- **Verification:** `flutter analyze` passed; `flutter test` passed with 141 tests.
- **Next:** V2 Task 9, task application state, smart sources, lists, tags, and filters.

## V2 Task 9: Task Application State and Sources

- **Status:** complete
- **Completed:** 2026-07-18
- Added `tasksControllerProvider`, application state, built-in sources, selection, subtasks, search results, and save status.
- Added quick add, task edits, completion, deletion, subtasks, list/tag/filter CRUD, source selection, sorting, and completed visibility controls.
- Added debounced search with cancellation safety and restoration of the last non-search source.
- Added transactional list deletion that moves tasks back to virtual Inbox and active-tag filtering for task links.
- **Verification:** `flutter analyze` passed; `flutter test` passed with 147 tests.
- **Next:** V2 Task 10, Windows and Android task workspaces.

## V2 Task 10: Windows and Android Task Workspaces

- **Status:** complete
- **Completed:** 2026-07-18
- Added the responsive task source, list, and detail panes for Windows and Android.
- Added search, quick add, completed visibility, list tinting, sorting, priority, tags, subtasks, taxonomy editors, smart filters, save status, and delete confirmation.
- Replaced the Today placeholder with `TasksPage` and removed the legacy Todo page and temporary AppShell wrapper.
- Added completion animation and post-commit Android haptic feedback for completion and deletion.
- **Verification:** `flutter analyze` passed; `flutter test` passed with 150 tests.
- **Next:** V2 Task 11, transactional attachment import, storage, and metadata.

## V2 Task 11: Transactional Content Attachments

- **Status:** complete
- **Completed:** 2026-07-18
- Added attachment owner, input, metadata, picker, Markdown edit, file-store, repository, and import-service contracts.
- Added content-addressed JPEG/PNG/WebP originals, 720px JPEG thumbnails, 20 MB preflight validation, atomic moves, and shared-SHA rollback leases.
- Added atomic Note/Task Markdown plus metadata imports and exact Markdown-node plus metadata deletion transactions.
- Added Android lost-image retrieval as pending imports without silently changing the active editor.
- **Verification:** `flutter analyze` passed; `flutter test` passed with 162 tests.
- **Next:** V2 Task 12, shared Markdown toolbar, editor, and attachment renderer.

## V2 Task 12: Shared Markdown Editor and Attachment Renderer

- **Status:** complete
- **Completed:** 2026-07-18
- Added shared Markdown selection wrapping, insertion, line-prefix operations, syntax toolbar, and image-source/alt-text dialog.
- Added local `attachment://` rendering with asynchronous metadata resolution, thumbnail-first loading, remote-image rejection, and missing-file states.
- Added full-screen original-image preview with zoom/pan and confirmed inline-image deletion callbacks.
- Added stable 280x180 inline image dimensions and cached resolver Futures to avoid repeated queries and layout churn.
- **Verification:** `flutter analyze` passed; `flutter test` passed with 174 tests.
- **Next:** V2 Task 13, inline-image integration for Notes and Tasks.

## V2 Task 13: Inline Images in Notes and Tasks

- **Status:** complete
- **Completed:** 2026-07-18
- Added transactional image insert, delete, resolve, save status, and failure handling to Notes and Tasks controllers.
- Replaced both raw Markdown fields and previews with the shared embedded editor and attachment renderer.
- Added cancellation-safe note debouncing that preserves `createdAt` and flushes cross-note pending edits.
- Added a non-blocking Android recovery banner with explicit current-note/current-task targets and no automatic attachment.
- **Verification:** `flutter analyze` passed; `flutter test` passed with 184 tests.
- **Next:** V2 Task 14, disable V1 sync in production and record Phase 1 acceptance.

## V2 Task 14: V1 Sync Guard and Phase 1 Acceptance

- **Status:** complete
- **Completed:** 2026-07-18
- Added a production-default V1 sync guard with explicit test-only compatibility enablement.
- Replaced all production sync controls with a first-viewport Phase 4 upgrade notice.
- Routed Android More through Settings so the notice and embedded Appearance controls are reachable.
- Added the Phase 1 acceptance matrix, README status, Android emulator smoke results, and hardware follow-up boundaries.
- Stabilized Android debug builds on the mixed Kotlin plugin tree with AGP 8.9.1, Gradle 8.11.1, JDK 17, and non-incremental Kotlin compilation.
- **Verification:** formatter, build_runner, `flutter analyze`, 186 tests, Windows Debug build, and Android Debug APK build passed.
- **Next:** Phase 1 implementation is complete; physical-device release QA remains documented in the acceptance record.

## V2 Task 15: Task Time and Reminder Foundation

- **Status:** complete
- **Started:** 2026-07-18
- **Completed:** 2026-07-18
- Move the database to schema version 3.
- Add `task_reminders` with sync metadata and exactly-one trigger validation.
- Add `TaskReminder` domain and repository contracts.
- Preserve the existing Phase 1 `tasks_v2` time and recurrence fields.
- Cover schema 1 -> 3, schema 2 -> 3, repository, and domain behavior with tests.
- **Verification:** build_runner, formatter, `flutter analyze`, targeted task/database tests, and full `flutter test` passed.
- **Next:** V2 Task 16, recurrence completion events and next-date advancement.

## V2 Task 16: Completion Events and Recurrence Advancement

- **Status:** complete
- **Started:** 2026-07-18
- **Completed:** 2026-07-18
- Add `task_completions` persistence and domain contracts.
- Add transactional task completion that records events.
- Advance recurring tasks in place while preserving their stable task ID.
- Support daily, workday, weekly `BYDAY`, monthly, yearly, interval, end-date, and count semantics.
- Preserve existing task state when recurrence parsing or next-date calculation fails.
- Cover schema, domain, repository, and controller paths with tests.
- **Verification:** build_runner, formatter, `flutter analyze`, targeted task/database tests, and full `flutter test` passed with 205 tests.
- **Next:** V2 Task 17, richer date filters for Today, Next 7 Days, and smart filters.

## V2 Task 17: Date Queries and Smart Filter Date Rules

- **Status:** complete
- **Started:** 2026-07-18
- **Completed:** 2026-07-18
- Extend `TaskFilterRules` with active start and due date ranges.
- Make Today include overdue, due-today, and start-today tasks.
- Make Next 7 Days include tasks with start or due dates inside the seven-day window.
- Apply date ranges inside repository smart-filter evaluation.
- Replace the disabled date-rule placeholder in the smart-filter editor with active controls.
- Cover JSON compatibility, repository semantics, controller persistence, and widget UI.
- **Verification:** formatter, `flutter analyze`, targeted task tests, and full `flutter test` passed with 208 tests.
- **Next:** V2 Task 18, calendar aggregation.

## V2 Task 18: Calendar Aggregation

- **Status:** complete
- **Started:** 2026-07-18
- **Completed:** 2026-07-18
- Add read-only calendar domain objects for entries and day buckets.
- Aggregate task start/due markers and note creation dates over a requested range.
- Expand active recurring task schedules without creating calendar-owned data.
- Exclude deleted source records and subtasks.
- Add a Calendar controller for loading date ranges.
- Cover grouping, sorting, recurrence caps, invalid recurrence fallback, and controller reload behavior.
- **Verification:** formatter, `flutter analyze`, targeted calendar tests, and full `flutter test` passed with 211 tests.
- **Next:** V2 Task 19, reminder scheduling.

## V2 Task 19: Reminder Scheduling

- **Status:** complete
- **Started:** 2026-07-18
- **Completed:** 2026-07-18
- Add a notification scheduling interface with a no-op default adapter.
- Add task reminder schedule domain objects.
- Resolve pending absolute and relative task reminders through the task repository.
- Reconcile pending reminders into platform notification requests.
- Cancel stale task reminder notification IDs and mark reminders fired.
- Cover repository filtering, relative trigger resolution, reconciliation, cancellation, and fired-state persistence.
- **Verification:** formatter, `flutter analyze`, targeted task/notification tests, and full `flutter test` passed with 215 tests.
- **Next:** V2 Task 20, reminder UI and scheduling hooks.

## V2 Task 20: Reminder UI and Scheduling Hooks

- **Status:** complete
- **Started:** 2026-07-18
- **Completed:** 2026-07-18
- Load selected task reminders into task state.
- Add controller APIs for absolute reminders, relative reminders, and reminder deletion.
- Reconcile reminder scheduling after task time/completion/deletion and reminder changes.
- Add compact reminder controls and removal actions to the task detail pane.
- Cover controller state, scheduling hooks, and widget reminder controls.
- **Verification:** formatter, `flutter analyze`, targeted task tests, and full `flutter test` passed with 217 tests.
- **Next:** confirm V2 Task 21 scope.
