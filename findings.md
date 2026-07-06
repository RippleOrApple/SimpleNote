# Findings & Decisions

## Requirements

- Complete Phase 3 from `GOAL.md`: Notes MVP.
- Support note create, edit, delete, search, Markdown edit/preview, tag creation, tag assignment, and tag filtering.
- Persist notes and tags through the Phase 2 Drift database.
- Preserve Phase 1 navigation and Phase 2 database structure.
- Add/update relevant tests.
- `flutter analyze` and `flutter test` must pass.

## Research Findings

- `NotesController` currently stores an in-memory `List<Note>` and does not use `NotesRepository`.
- `NotesPage` currently renders a simple list and does not provide title/body editing, search, or tag controls.
- `NotesRepository` supports active notes, search, upsert, and soft delete but does not yet expose note-tag relationships.
- `TagsRepository` supports active tags, upsert, and soft delete but does not yet expose tag creation helpers or note assignment.
- `NoteTagsDao` already supports link insert/remove and fetching links for one note.
- Existing database tests use in-memory Drift and can be extended for note/tag relationships.

## Technical Decisions

| Decision | Rationale |
|----------|-----------|
| Use `AsyncNotifier<NotesState>` for notes | Keeps loading/error states explicit and makes database persistence natural |
| Keep `NotesPage` as list/detail editor | Good MVP shape for both mobile and desktop without new routes |
| Add note-tag methods to repositories rather than using DAOs from UI | Preserves feature boundaries |
| Use plain `TextField` for Markdown editing and `flutter_markdown` for preview | Meets MVP while avoiding heavy editor dependencies |
| Keep tag filtering to one selected tag at a time | Simple MVP behavior that still supports multiple assigned tags per note |

## Issues Encountered

| Issue | Resolution |
|-------|------------|
| Widget tests timed out waiting for animated loading state | Switched test helper to in-memory database and fixed-duration pumps |
| Markdown inline text was not found by `find.text` | Used RichText plain-text matching for inline Markdown assertions |

## Resources

- `GOAL.md`
- `docs/DEVELOPMENT_PHASES.md`
- `lib/features/notes/application/notes_controller.dart`
- `lib/features/notes/presentation/notes_page.dart`
- `lib/features/notes/data/notes_repository.dart`
- `lib/features/tags/data/tags_repository.dart`
- `lib/database/daos/note_tags_dao.dart`

## Visual/Browser Findings

- No browser or image findings for this implementation step.
