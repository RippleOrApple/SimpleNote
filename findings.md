# Findings & Decisions

## Requirements

- Complete Phase 2 from `GOAL.md`: local database integration using Drift and SQLite.
- Add Drift/SQLite dependencies.
- Define schema for `notes`, `todos`, `tags`, `note_tags`, `theme_schemes`, `sync_logs`, and `app_settings`.
- Add DAO classes and database-backed repository implementations.
- Initialize the database from the Flutter app through provider wiring.
- Add a simple schema version/migration strategy.
- Add or update tests.
- Preserve Phase 1 navigation and shell behavior.
- `flutter analyze` and `flutter test` must pass.

## Research Findings

- `lib/database/app_database.dart` is currently a placeholder with `open()` and `close()` no-ops.
- `lib/database/tables/database_tables.dart` already lists required table names.
- Feature repositories currently define interfaces only:
  - `NotesRepository`
  - `TodosRepository`
  - `TagsRepository`
  - `ThemeRepository`
- Notes and todos domain models already include sync-friendly fields: `id`, `createdAt`, `updatedAt`, `deletedAt`, `deviceId`, and `version`.
- Current UI controllers still keep in-memory state; Phase 2 can preserve that UI while adding database-backed repository implementations for later phases.
- Existing tests are small and fast, so database tests should stay focused and use an in-memory executor.

## Technical Decisions

| Decision | Rationale |
|----------|-----------|
| Define tables as separate files under `lib/database/tables/` | Keeps schema aligned with the architecture document and avoids a huge `app_database.dart` |
| Define DAOs as Drift part files under `lib/database/daos/` | Lets generated mixins access the database while keeping DAO code organized |
| Add concrete `Drift*Repository` classes next to repository interfaces | Preserves feature ownership and makes later controller wiring straightforward |
| Use in-memory Drift databases in tests | Avoids platform-specific filesystem setup while proving repository insert/read/soft-delete behavior |
| Keep Phase 2 UI controllers unchanged | Prevents async UI rewiring from expanding scope; Phase 3/4 can connect controllers to repositories |

## Issues Encountered

| Issue | Resolution |
|-------|------------|
| Drift generator required literal table names | Replaced table-name constants in table classes with direct string literals |
| Database file test initially created an extra in-memory database through shared setup | Changed tests to create only the database each test needs |

## Resources

- `GOAL.md`
- `docs/DEVELOPMENT_PHASES.md`
- `docs/ARCHITECTURE.md`
- `lib/database/app_database.dart`
- `lib/database/tables/`
- `lib/database/daos/`

## Visual/Browser Findings

- No browser or image findings for this implementation step.
