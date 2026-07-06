# Findings & Decisions

## Requirements

- Complete Phase 6 from `GOAL.md`: LAN sync MVP.
- Export notes, todos, tags, and theme schemes as a JSON snapshot with device info.
- Merge remote snapshots into the local database without destructive failure behavior.
- Provide `/health`, `/device`, `/snapshot`, and `/sync` endpoints.
- Provide client methods and controller flow for manual peer sync.
- Expose controls in Settings.
- Add/update relevant tests.
- `flutter analyze` and `flutter test` must pass.

## Research Findings

- `SyncController` currently only flips enum states and does not use a repository/server/client.
- `SyncRepository` is only an abstract shell.
- `LocalSyncServer` only supports `/health`.
- `SyncApiClient` only supports a health check.
- `SyncSnapshot`, `DeviceInfo`, and `SyncResult` do not yet have `fromJson` constructors.
- Notes/todos repositories only expose active rows; sync needs all rows including soft-deleted rows.
- MergePolicy already has `chooseLatest` for `Syncable` entities and handles `deletedAt ?? updatedAt`.
- Settings currently has a static LAN sync list item.

## Technical Decisions

| Decision | Rationale |
|----------|-----------|
| Add `toJson`/`fromJson` on sync/domain models | Keeps HTTP server/client simple |
| Export all rows for sync, including deleted rows | Required for delete propagation |
| Merge notes/todos by `MergePolicy.chooseLatest` | Satisfies newest-change and delete/update conflict rules |
| Use injected repository in `LocalSyncServer` | Keeps tests fast and deterministic |
| Use `SyncState` instead of an enum | UI needs server address, peer address, result, and errors |

## Issues Encountered

| Issue | Resolution |
|-------|------------|
| None yet | - |

## Resources

- `GOAL.md`
- `docs/DEVELOPMENT_PHASES.md`
- `lib/features/sync/domain/*`
- `lib/features/sync/data/sync_repository.dart`
- `lib/features/sync/infrastructure/local_sync_server.dart`
- `lib/features/sync/infrastructure/sync_api_client.dart`
- `lib/features/settings/presentation/settings_page.dart`
- `lib/database/daos/*`

## Visual/Browser Findings

- No browser or image findings for this implementation step.
