# Goal

## Objective

Complete Phase 3: build the Notes MVP for SimpleNote.

Users should be able to create, edit, delete, search, tag, and preview Markdown notes, with note data persisted through the local database created in Phase 2.

## Scope

- What should change:
  - Build a usable notes list.
  - Build a note editor experience.
  - Support editing note title and Markdown body.
  - Support Markdown preview.
  - Support edit / preview mode switching.
  - Support searching note titles and bodies.
  - Support creating tags.
  - Support assigning tags to notes.
  - Support filtering notes by tag.
  - Persist notes and tags through the local database.
  - Preserve existing app shell navigation and Phase 2 database structure.

- What files, features, or workflows are in scope:
  - `lib/features/notes/domain/note.dart`
  - `lib/features/notes/application/notes_controller.dart`
  - `lib/features/notes/data/notes_repository.dart`
  - `lib/features/notes/presentation/notes_page.dart`
  - `lib/features/tags/`
  - `lib/database/daos/notes_dao.dart`
  - `lib/database/daos/tags_dao.dart`
  - `lib/database/daos/note_tags_dao.dart`
  - Notes and tags tests.

## Non-goals

- What should not change:
  - Do not build the todos MVP in this phase.
  - Do not implement LAN sync in this phase.
  - Do not implement cloud sync, accounts, or authentication.
  - Do not add attachment/image management.
  - Do not build a full rich text editor.
  - Do not redesign the whole app shell.

- What should be left for later:
  - Phase 4: todos MVP.
  - Phase 5: theme customization.
  - Phase 6: LAN sync MVP.
  - Import/export and backup flows.
  - Advanced Markdown shortcuts and code highlighting.

## Acceptance Criteria

- [x] A note can be created from the Notes page.
- [x] A note title can be edited.
- [x] A note body can be edited.
- [x] A note can be deleted.
- [x] Notes are persisted in the local database.
- [x] A persisted note is loaded when the app/controller reloads.
- [x] Notes can be searched by title.
- [x] Notes can be searched by body content.
- [x] Markdown edit mode is available.
- [x] Markdown preview mode is available.
- [x] Markdown preview renders headings.
- [x] Markdown preview renders lists.
- [x] Markdown preview renders task lists.
- [x] Markdown preview renders bold text.
- [x] Markdown preview renders links.
- [x] Markdown preview renders inline code.
- [x] Markdown preview renders code blocks.
- [x] Markdown preview renders blockquotes.
- [x] Tags can be created.
- [x] A note can be assigned a tag.
- [x] Notes can be filtered by tag.
- [x] Note `updatedAt` changes when title/body/tag state changes.
- [x] Existing Notes, Todos, and Settings navigation still works.
- [x] Relevant tests are added or updated.
- [x] `flutter analyze` passes.
- [x] `flutter test` passes.
- [x] The final result is ready for Phase 4 without expanding into todo work.

## Constraints

- Existing patterns to preserve:
  - Keep Flutter as the cross-platform framework.
  - Keep Riverpod as the state management direction.
  - Keep the current feature-based directory structure.
  - Keep database code under `lib/database/`.
  - Keep feature repositories under each feature's `data/` directory.
  - Keep Phase 1 shell/navigation behavior intact.
  - Keep Phase 2 database schema compatible unless a small additive change is required.

- Technical limits:
  - Windows desktop runtime may still require Visual Studio C++ workload.
  - Android verification should use the `SimpleNote_Pixel` emulator when runtime validation is needed.
  - Avoid adding heavy editor dependencies.
  - Prefer existing `flutter_markdown` for preview.
  - Keep the notes MVP simple and usable rather than exhaustive.

- Compatibility requirements:
  - The app should continue to target Windows and Android.
  - The app should continue to build with Flutter 3.44.4 / Dart 3.12.2.
  - The Android emulator target is Android 16 / API 36.

## Notes

- Extra context:
  - This goal corresponds to `docs/DEVELOPMENT_PHASES.md`, section `阶段 3：笔记模块 MVP`.
  - Phase 1 completed the app shell and navigation.
  - Phase 2 completed the Drift database and database-backed repositories.
  - The current notes UI is still a simple list with in-memory state, so this phase should connect notes to real persistence.

- Links or examples:
  - `docs/DEVELOPMENT_PHASES.md`
  - `docs/ARCHITECTURE.md`
  - `task_plan.md`
  - `findings.md`
  - `progress.md`
