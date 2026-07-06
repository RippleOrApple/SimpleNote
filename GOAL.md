# Goal

## Objective

Complete Phase 4: build the Todos MVP for SimpleNote.

Users should be able to create, edit, complete, delete, prioritize, date, filter, and persist todos through the local database created in Phase 2.

## Scope

- What should change:
  - Build a usable todos list.
  - Support quick todo creation.
  - Support editing todo title and description.
  - Support completing and uncompleting todos.
  - Support deleting todos.
  - Support due dates.
  - Support priority values: low, medium, high.
  - Support filtering by all, active, and completed.
  - Persist todos through the local database.
  - Preserve existing app shell navigation, notes MVP, and database structure.
  - If work is interrupted, leave `P4_STATUS.md` with completed and remaining items.

- What files, features, or workflows are in scope:
  - `lib/features/todos/domain/todo.dart`
  - `lib/features/todos/application/todos_controller.dart`
  - `lib/features/todos/data/todos_repository.dart`
  - `lib/features/todos/presentation/todos_page.dart`
  - `lib/database/daos/todos_dao.dart`
  - Todo-focused tests.
  - `P4_STATUS.md` only if the task cannot be completed in this run.

## Non-goals

- What should not change:
  - Do not implement LAN sync in this phase.
  - Do not implement cloud sync, accounts, or authentication.
  - Do not redesign the notes MVP.
  - Do not build complex calendar views.
  - Do not add system notifications or recurring tasks.

- What should be left for later:
  - Phase 5: theme customization.
  - Phase 6: LAN sync MVP.
  - Advanced reminders.
  - Calendar integration.
  - Todo-note linking.

## Acceptance Criteria

- [x] A todo can be created from the Todos page.
- [x] A todo title can be edited.
- [x] A todo description can be edited.
- [x] A todo can be marked completed.
- [x] A todo can be marked active again.
- [x] A todo can be deleted.
- [x] Todos are persisted in the local database.
- [x] A persisted todo is loaded when the app/controller reloads.
- [x] A todo can have no due date.
- [x] A todo can have a due date.
- [x] A todo can be set to low priority.
- [x] A todo can be set to medium priority.
- [x] A todo can be set to high priority.
- [x] Todos can be filtered to show all.
- [x] Todos can be filtered to show active only.
- [x] Todos can be filtered to show completed only.
- [x] Todo `updatedAt` changes when title, description, completion, due date, or priority changes.
- [x] Existing Notes, Todos, and Settings navigation still works.
- [x] Notes MVP behavior remains covered by tests.
- [x] Relevant todo tests are added or updated.
- [x] `flutter analyze` passes.
- [x] `flutter test` passes.
- [x] The final result is ready for Phase 5 without expanding into sync or theme work.

## Constraints

- Existing patterns to preserve:
  - Keep Flutter as the cross-platform framework.
  - Keep Riverpod as the state management direction.
  - Keep the current feature-based directory structure.
  - Keep database code under `lib/database/`.
  - Keep feature repositories under each feature's `data/` directory.
  - Keep Phase 1 shell/navigation behavior intact.
  - Keep Phase 2 database structure compatible unless a small additive change is required.
  - Keep Phase 3 notes MVP behavior intact.

- Technical limits:
  - Windows desktop runtime may still require Visual Studio C++ workload.
  - Android verification should use the `SimpleNote_Pixel` emulator when runtime validation is needed.
  - Avoid adding heavy calendar or reminder dependencies.
  - Keep the todos MVP simple and usable.

- Compatibility requirements:
  - The app should continue to target Windows and Android.
  - The app should continue to build with Flutter 3.44.4 / Dart 3.12.2.
  - The Android emulator target is Android 16 / API 36.

## Notes

- Extra context:
  - This goal corresponds to `docs/DEVELOPMENT_PHASES.md`, section `阶段 4：待办模块 MVP`.
  - Phase 1 completed the app shell and navigation.
  - Phase 2 completed the Drift database and database-backed repositories.
  - Phase 3 completed the Notes MVP.
  - The current todos UI is still a simple in-memory list, so this phase should connect todos to real persistence.

- Links or examples:
  - `docs/DEVELOPMENT_PHASES.md`
  - `docs/ARCHITECTURE.md`
  - `task_plan.md`
  - `findings.md`
  - `progress.md`
