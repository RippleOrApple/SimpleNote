# Goal

## Objective

Complete Phase 2: connect SimpleNote to local SQLite persistence using Drift.

Notes, todos, tags, theme schemes, sync logs, and app settings should have clear database tables and repository implementations so later feature phases can store and retrieve real local data instead of relying on in-memory state.

## Scope

- What should change:
  - Add Drift and SQLite-related dependencies.
  - Define the local database schema.
  - Create DAO classes for core tables.
  - Implement repository classes backed by the database.
  - Initialize the database from the Flutter app.
  - Add a basic migration/versioning strategy.
  - Keep existing Phase 1 navigation and UI behavior working.

- What files, features, or workflows are in scope:
  - `pubspec.yaml`
  - `pubspec.lock`
  - `lib/database/app_database.dart`
  - `lib/database/tables/`
  - `lib/database/daos/`
  - `lib/features/notes/data/notes_repository.dart`
  - `lib/features/todos/data/todos_repository.dart`
  - `lib/features/tags/data/tags_repository.dart`
  - `lib/features/settings/data/theme_repository.dart`
  - Database initialization and provider wiring.
  - Repository tests or database-focused tests.

## Non-goals

- What should not change:
  - Do not build the full note editor in this phase.
  - Do not build the full todo editor in this phase.
  - Do not implement Markdown editing improvements in this phase.
  - Do not implement real LAN sync in this phase.
  - Do not add cloud sync, account login, or authentication.
  - Do not redesign the Phase 1 app shell unless required for database wiring.

- What should be left for later:
  - Phase 3: notes MVP.
  - Phase 4: todos MVP.
  - Phase 5: theme customization.
  - Phase 6: LAN sync MVP.
  - Import/export and backup flows.

## Acceptance Criteria

- [x] Drift and SQLite dependencies are added successfully.
- [x] The project can generate Drift code.
- [x] A database file can be created locally.
- [x] The database schema includes `notes`.
- [x] The database schema includes `todos`.
- [x] The database schema includes `tags`.
- [x] The database schema includes `note_tags`.
- [x] The database schema includes `theme_schemes`.
- [x] The database schema includes `sync_logs`.
- [x] The database schema includes `app_settings`.
- [x] Notes can be inserted through a repository.
- [x] Notes can be read back through a repository.
- [x] Todos can be inserted through a repository.
- [x] Todos can be read back through a repository.
- [x] Delete operations use soft-delete fields where applicable.
- [x] Repository implementations no longer rely only on in-memory state.
- [x] Existing Notes, Todos, and Settings navigation still works.
- [x] Relevant tests are added or updated.
- [x] `flutter analyze` passes.
- [x] `flutter test` passes.
- [x] The final result prepares the app cleanly for Phase 3 and Phase 4 feature work.

## Constraints

- Existing patterns to preserve:
  - Keep Flutter as the cross-platform framework.
  - Keep Riverpod as the state management direction.
  - Keep the current feature-based directory structure.
  - Keep database code under `lib/database/`.
  - Keep feature repositories under each feature's `data/` directory.
  - Keep Phase 1 shell and navigation behavior intact.

- Technical limits:
  - Windows desktop runtime may still require Visual Studio C++ workload.
  - Android verification should use the `SimpleNote_Pixel` emulator when runtime validation is needed.
  - Avoid adding heavy dependencies unrelated to local persistence.
  - Keep schema versioning simple but explicit.
  - Generated Drift files should be committed if they are required to build.

- Compatibility requirements:
  - The app should continue to target Windows and Android.
  - The app should continue to build with Flutter 3.44.4 / Dart 3.12.2.
  - The Android emulator target is Android 16 / API 36.

## Notes

- Extra context:
  - This goal corresponds to `docs/DEVELOPMENT_PHASES.md`, section `阶段 2：本地数据库接入`.
  - Phase 1 has completed the app shell and page navigation.
  - The project already has placeholder repository interfaces and database files.
  - Prefer a small, testable database layer over premature feature UI work.

- Links or examples:
  - `docs/DEVELOPMENT_PHASES.md`
  - `docs/ARCHITECTURE.md`
  - `task_plan.md`
  - `findings.md`
  - `progress.md`
