# Goal

## Objective

Complete Phase 7: polish the SimpleNote user experience and basic error handling.

The app should feel less like a raw MVP and more like a usable product. Common actions should be clear, destructive actions should be protected, mobile navigation should be smoother, and visible copy should be clean.

## Scope

- What should change:
  - Add a mobile-friendly way to leave note and todo editors and return to the list.
  - Add confirmation before deleting a note.
  - Add confirmation before deleting a todo.
  - Show a lightweight success message after deleting a note or todo.
  - Clean up odd visible text or separator artifacts.
  - Keep Settings and LAN sync controls understandable.
  - Preserve existing app shell, notes, todos, theme customization, and LAN sync behavior.

- What files, features, or workflows are in scope:
  - `lib/features/notes/application/notes_controller.dart`
  - `lib/features/notes/presentation/notes_page.dart`
  - `lib/features/todos/application/todos_controller.dart`
  - `lib/features/todos/presentation/todos_page.dart`
  - `lib/features/settings/presentation/settings_page.dart`
  - Widget tests covering polish behavior.
  - `task_plan.md`
  - `findings.md`
  - `progress.md`

## Non-goals

- What should not change:
  - Do not redesign the full app.
  - Do not add undo stacks in this phase.
  - Do not add notifications, reminders, calendar views, or background sync.
  - Do not change the database schema unless absolutely necessary.
  - Do not expand LAN sync beyond manual address entry.

- What should be left for later:
  - Full visual design pass.
  - Undo/restore after delete.
  - Rich conflict UI for sync.
  - Packaging and presentation assets.

## Acceptance Criteria

- [x] On compact/mobile layouts, the note editor has a clear back-to-list action.
- [x] On compact/mobile layouts, the todo editor has a clear back-to-list action.
- [x] Deleting a note asks for confirmation first.
- [x] Canceling note deletion keeps the note.
- [x] Confirming note deletion deletes the note.
- [x] Deleting a todo asks for confirmation first.
- [x] Canceling todo deletion keeps the todo.
- [x] Confirming todo deletion deletes the todo.
- [x] A note deletion shows a lightweight success message.
- [x] A todo deletion shows a lightweight success message.
- [x] Todo subtitles use a clean separator.
- [x] Existing Notes behavior remains covered by tests.
- [x] Existing Todos behavior remains covered by tests.
- [x] Existing Settings, Theme, and LAN sync behavior remains covered by tests.
- [x] Relevant polish tests are added or updated.
- [x] `flutter analyze` passes.
- [x] `flutter test` passes.
- [x] The final result is ready for Phase 8 packaging and presentation work.

## Constraints

- Existing patterns to preserve:
  - Keep Flutter as the cross-platform framework.
  - Keep Riverpod as the state management direction.
  - Keep Drift persistence unchanged.
  - Keep the feature-based directory structure.
  - Keep UI simple and suitable for Windows and Android.
  - Keep P6 LAN sync and P5 theme customization intact.

- Technical limits:
  - Avoid new dependencies.
  - Prefer focused widget-level polish over broad redesign.
  - Keep destructive-action handling simple and testable.

## Notes

- Extra context:
  - This goal corresponds to `docs/DEVELOPMENT_PHASES.md`, Phase 7 experience polish and error handling.
  - Phase 6 completed manual LAN sync MVP.
  - The most visible rough edges are editor navigation on compact layouts and immediate deletion without confirmation.

- Links or examples:
  - `docs/DEVELOPMENT_PHASES.md`
  - `docs/ARCHITECTURE.md`
  - `task_plan.md`
  - `findings.md`
  - `progress.md`
