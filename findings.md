# Findings & Decisions

## Requirements

- Complete Phase 7 from `GOAL.md`: experience polish and basic error handling.
- Add mobile-friendly editor back actions.
- Protect note/todo deletion with confirmation.
- Show lightweight feedback after deletion.
- Clean visible copy/separators.
- Preserve prior phase behavior and tests.

## Research Findings

- Compact notes/todos layouts currently replace the list with the editor after selecting an item.
- There is no explicit back-to-list action in compact editors.
- Notes and todos currently delete immediately from editor icon buttons.
- `TodosPage._todoSubtitle` contains an odd visible separator character.
- Existing widget tests already cover notes, todos, settings, theme, and LAN sync flows.

## Technical Decisions

| Decision | Rationale |
|----------|-----------|
| Add `clearSelection` to controllers | Simple state-level way to return compact editors to lists |
| Show confirmation dialogs from editor widgets | Keeps destructive-action UX close to the action |
| Show SnackBars after confirmed deletes | Gives clear feedback without adding undo scope |
| Use ASCII separator in todo subtitles | Avoids encoding/display oddities |

## Issues Encountered

| Issue | Resolution |
|-------|------------|
| None yet | - |

## V2 Task 7 Findings

- Existing navigation code covered the controller and domain model; the presentation shell, route integration, and navigation editor were missing.
- The Android contract requires an icon-only `NavigationBar` with no descendant `Text` widgets, so the implementation uses custom 48dp icon targets inside `NavigationBar`.
- Windows rail selection uses the injected device platform, with the 920 logical-pixel breakpoint as the adaptive fallback.
- Legacy `/todos`, `/notes`, and `/settings` routes now resolve through the adaptive shell; Notes and Settings remain compatible modules while Today is the Task 10 placeholder.
- Appearance navigation settings are persisted through `AppearanceController.setNavigation` and normalized by `DeviceAppearanceProfile`.

## V2 Task 8 Findings

- The V2 tables and migration already existed, but `TasksV2Dao` and `TaskTaxonomyDao` were empty accessors.
- Routed task work must use `tasks_v2`; the legacy Todo domain remains compatibility code only.
- Search uses one parameterized SQL query across task title, Markdown body, active list name, and active tag name, with wildcard escaping and `DISTINCT` task rows.
- Smart-filter list, completion, priority, and tag rules are intersections; multiple selected tags require every tag.
- Subtasks inherit the parent's list, cannot have children, cannot reference themselves, and are soft-deleted with their direct parent transactionally.

## V2 Task 9 Findings

- Built-in task sources can be represented directly by stable `TaskQuery` objects; `TasksState.sources` exposes the four standard source descriptors.
- A task moved between Inbox and a custom list must also move the active query so the selected task remains valid.
- Deleting a custom list is one transaction: clear active task `list_id` values, then soft-delete the list.
- Search debounce cancellation must complete superseded Futures; otherwise rapid typing can leave callers waiting forever.
- Soft-deleted tags remain sync history, but active task-tag maps and smart-filter evaluation must ignore their links.

## V2 Task 10 Findings

- The full task workspace breakpoint must include the 112 logical pixels consumed by the outer Windows functional rail; `AppShellEmbedScope` supplies that explicit layout context.
- A custom-list tint surface must be a `Material`, not a `ColoredBox`, so task-row selection colors and ink reactions remain visible.
- Task title and Markdown description controllers remain mounted across saves and failures; only task selection changes replace their text, while writes debounce for 350 ms.
- Completion and deletion haptics belong after the repository write reports `saved`; failed transactions must not emit feedback.
- The temporary AppShell could be removed by retaining only a narrow embed scope and letting Notes and Settings own their standalone Scaffold fallback.

## V2 Task 11 Findings

- Attachment paths stored in syncable metadata must remain support-directory-relative; absolute original and thumbnail paths are local computed fields and are omitted from JSON.
- File staging and database transactions need separate rollback coordination: temporary and final files are outside SQLite, so the service explicitly resolves a staged-file lease after commit or failure.
- Same-SHA concurrent imports require a shared lease per absolute storage root and SHA. One successful commit preserves the files; files are removed only after every lease fails.
- Import transactions validate the Note or Task owner inside the transaction, update Markdown and owner version, and insert metadata as one unit.
- Delete transactions validate attachment ownership and require an exact Markdown image node before soft-deleting metadata; physical files remain for Phase 1 cleanup policy.
- Android `retrieveLostData()` is called once through a cached provider, and recovered images remain pending until an editor explicitly consumes them.

## V2 Task 12 Findings

- Programmatic Markdown toolbar edits do not trigger `TextField.onChanged`, so toolbar actions explicitly emit the updated string while service-returned image edits remain controller-owned commits.
- Image insertion must snapshot editor selection before opening the source dialog; dialog focus must not replace the target selection.
- The installed `flutter_markdown` version deprecates `imageBuilder` and has legacy argument-order behavior, so `sizedImageBuilder` provides unambiguous URI, alt, and title fields.
- Attachment resolver Futures must be cached in `AttachmentImage`; creating one on every build repeatedly queries metadata and can leave the image in a loading loop.
- A stable 280x180 inline image canvas prevents Markdown `Wrap` relayout shifts across loading, missing, and loaded states while full-screen preview preserves the original aspect ratio.
- Widget tests that perform real temporary-file IO inside Flutter fake async must use synchronous operations or `runAsync`; direct async `File.delete()` can stall the test isolate.

## V2 Task 13 Findings

- Image insertion must flush pending Markdown edits before taking the owner snapshot; otherwise the attachment transaction can overwrite recently typed text.
- Picker cancellation returns before save-state mutation, preserving Markdown, timestamps, version, selection, and focus.
- Note text writes need one merged 350 ms debounce for title and content, plus repository lookup by ID so filtering or switching notes cannot discard pending edits.
- Recovered Android images remain inert until the user chooses the currently selected note or task from a non-modal banner; target buttons update as editor selection changes.
- In-memory `XFile.fromData` values can expose an empty `name` with the installed `cross_file` version, so recovered images use `recovered image` as a non-empty alt-text fallback.
- Real attachment file IO should be tested through directly awaited controller tests; Flutter widget fake async is suitable for verifying the recovery prompt and no-auto-import behavior, but not for awaiting the disk transaction started by a button callback.

## V2 Task 14 Findings

- Guarding only the settings UI is insufficient: `SyncController.startServer` and `syncWithPeer` must reject V1 by default so alternate callers cannot start the legacy protocol.
- V1 compatibility remains testable through the explicit `legacySyncEnabledProvider`/constructor flag and direct `LocalSyncServer` HTTP contract tests.
- Android More previously opened Appearance directly, making Settings and the sync upgrade notice unreachable; Settings now owns both the notice and embedded Appearance controls.
- Flutter plugin builds on Windows require symlink privilege, but pre-created directory junctions in `windows/flutter/ephemeral` satisfy the generated plugin layout without changing Developer Mode.
- The current Android plugin tree is incompatible with AGP 9 because `file_picker` expects Built-in Kotlin while `flutter_plugin_android_lifecycle` still applies legacy KGP. AGP 8.9.1 plus Gradle 8.11.1 and JDK 17 builds successfully.
- Kotlin incremental caches cannot relativize Pub Cache sources on `C:` against a project on `D:`; `kotlin.incremental=false` avoids that cross-drive failure.
- The Android emulator confirmed final APK startup, icon-only navigation, Android More routing, and first-viewport sync notice rendering without overlap.

## V2 Task 15 Findings

- Phase 1 already created `tasks_v2.start_at`, `due_at`, `all_day`, `recurrence_rule`, `recurrence_end_at`, and `recurrence_count`, and the task domain/repository already round-trip them.
- The missing Task 15 persistence piece is `task_reminders`, plus schema version 3 migration and repository contracts.
- `DatabaseBackupService` currently backs up only schema 1 before schema 2 migration; schema 2 -> 3 should also create a pre-v3 backup for production files.
- Reminder UI, native notification scheduling, recurrence completion events, and calendar aggregation are separate Phase 2 tasks.

## V2 Task 16 Findings

- The spec defines `task_completions` as the durable source for future task history and statistics.
- A recurring task keeps one stable task ID; completing an occurrence records an event, computes the next date, then restores the task to incomplete with advanced dates.
- Recurrence calculation must happen before the database transaction writes anything so invalid rules cannot leave a completion event without an advanced task.
- Phase 2 has not shipped from `main`, so Task 16 can add `task_completions` to the same schema v3 migration introduced by Task 15.
- `recurrence_count` is treated as the maximum number of active completion events; when the newly written event reaches that count, the task stays completed instead of advancing.

## V2 Task 17 Findings

- `TaskFilterRules` currently covers list IDs, tag IDs, completion, and priority only; date controls in the editor were intentionally disabled during Phase 1.
- Built-in Today currently considers `dueAt < nextDayStart`, which includes overdue and due-today tasks but misses tasks with only `startAt`.
- Built-in Next 7 Days currently considers only `dueAt` in range; Phase 2 should include either start or due dates in range.
- Date range checks should run in repository predicates so search, saved filters, and controller reloads share one behavior.
- Drift nullable integer columns should be passed as generated columns for date helper predicates; `Expression<int?>` violates Drift's non-nullable generic bound.
- The smart-filter date editor control key needs to live on the real `OutlinedButton`, not the outer row, so widget tests and pointer hit testing exercise the active control.

## V2 Task 18 Findings

- The design spec defines Calendar as a read-only aggregation module; it must not create calendar-owned task, note, or habit tables.
- Notes belong on the calendar by immutable `createdAt`; editing a note must not move its calendar entry.
- Calendar aggregation can query Drift directly through a dedicated repository because it spans multiple modules, while presentation should use a controller/provider.
- Until a full visual calendar exists, the important deliverable is deterministic range aggregation that later UI can reuse.
- Recurring task expansion can reuse `TaskRecurrenceRule`; invalid rules should fall back to the current task marker instead of breaking the entire calendar query.
- A recurring task's `recurrenceCount` must be interpreted against active completion events because completed occurrences are stored separately in `task_completions`.
