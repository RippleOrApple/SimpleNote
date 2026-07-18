# Task Plan: SimpleNote Phase 7 Experience Polish

## Goal

Improve day-to-day usability with compact editor back actions, delete confirmations, success feedback, cleaner visible text, and tests.

## Current Phase

Complete

## Phases

### Phase 1: Requirements & Discovery

- [x] Read `GOAL.md`
- [x] Inspect notes/todos presentation and controller patterns
- [x] Inspect existing widget tests
- **Status:** complete

### Phase 2: Planning & Structure

- [x] Choose compact editor back action approach
- [x] Choose delete confirmation flow
- [x] Choose test coverage
- **Status:** complete

### Phase 3: Implementation

- [x] Add clear selection actions to notes and todos controllers
- [x] Add compact back buttons to note and todo editors
- [x] Add note delete confirmation and success snackbar
- [x] Add todo delete confirmation and success snackbar
- [x] Clean todo subtitle separator text
- **Status:** complete

### Phase 4: Testing & Verification

- [x] Add/update widget tests for polish behavior
- [x] Run `flutter analyze`
- [x] Run `flutter test`
- [x] Verify acceptance criteria against `GOAL.md`
- **Status:** complete

### Phase 5: Delivery

- [x] Update `GOAL.md` acceptance checkboxes
- [x] Update planning files with final results
- [x] Submit PR with `scripts/update_pr.ps1`
- **Status:** complete

## Decisions Made

| Decision | Rationale |
|----------|-----------|
| Add controller `clearSelection` methods | Keeps compact back navigation in state instead of route hacks |
| Use Material confirmation dialogs | Native, dependency-free, and easy to test |
| Use SnackBar for success feedback | Lightweight and familiar |
| Keep undo out of scope | P7 is polish, not full history/restore |

## Errors Encountered

| Error | Attempt | Resolution |
|-------|---------|------------|
| Compact back action did not really clear selected item because selected getters returned the first item when no id was selected | 1 | Updated selected getters to return null when no selected id exists |
| Todo compact delete test could not find the edit tooltip before the selected getter fix | 1 | Fixed selected state behavior, then reran widget tests |

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
