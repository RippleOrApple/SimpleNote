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
