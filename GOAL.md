# Goal

## Objective

Complete Phase 6: build the LAN sync MVP for SimpleNote.

Windows and Android devices on the same Wi-Fi should be able to manually exchange local snapshots. One device can start a local sync server, another device can connect by host/port, exchange snapshots, merge newer records, and show a clear result.

## Scope

- What should change:
  - Export a local sync snapshot containing notes, todos, tags, and theme schemes.
  - Import a remote sync snapshot and merge it into the local database.
  - Keep merge rules simple and safe:
    - Insert records missing locally.
    - For matching notes and todos, keep the record with the latest effective change time.
    - Treat `deletedAt` as a real change time when resolving delete/update conflicts.
    - Never erase local data because a sync request fails.
  - Add JSON serialization for device info, notes, todos, tags, theme schemes, sync snapshots, and sync results.
  - Implement a local HTTP sync server with:
    - `GET /health`
    - `GET /device`
    - `GET /snapshot`
    - `POST /sync`
  - Implement an HTTP sync client that can:
    - Check peer health.
    - Read peer device info.
    - Read peer snapshot.
    - Send local snapshot to peer.
  - Implement a sync controller that can:
    - Start and stop the local server.
    - Show server host/port/status.
    - Connect to a peer URI.
    - Pull the peer snapshot into the local database.
    - Push the local snapshot to the peer.
    - Show the last sync result or error.
  - Add Settings page controls for manual LAN sync.
  - Preserve existing Notes, Todos, Settings, Theme, and navigation behavior.

- What files, features, or workflows are in scope:
  - `lib/features/sync/domain/device_info.dart`
  - `lib/features/sync/domain/sync_snapshot.dart`
  - `lib/features/sync/domain/sync_result.dart`
  - `lib/features/sync/domain/merge_policy.dart`
  - `lib/features/sync/data/sync_repository.dart`
  - `lib/features/sync/application/sync_controller.dart`
  - `lib/features/sync/infrastructure/local_sync_server.dart`
  - `lib/features/sync/infrastructure/sync_api_client.dart`
  - `lib/features/settings/presentation/settings_page.dart`
  - Repository/DAO methods needed for snapshot export/import.
  - Sync-focused tests.
  - `task_plan.md`
  - `findings.md`
  - `progress.md`

## Non-goals

- What should not change:
  - Do not implement cloud sync, accounts, authentication, or encryption in this phase.
  - Do not implement automatic device discovery/mDNS in this phase.
  - Do not implement background sync.
  - Do not implement conflict UI.
  - Do not redesign Notes, Todos, or Theme customization.
  - Do not make sync destructive if the peer is unreachable or sends invalid data.

- What should be left for later:
  - QR code pairing.
  - Device discovery.
  - Authenticated sync sessions.
  - More detailed conflict history.
  - Sync logs UI.

## Acceptance Criteria

- [x] A local sync snapshot can be exported from the database.
- [x] Exported snapshots include device info.
- [x] Exported snapshots include notes.
- [x] Exported snapshots include todos.
- [x] Exported snapshots include tags.
- [x] Exported snapshots include theme schemes.
- [x] A remote snapshot can be merged into the local database.
- [x] Missing remote notes are inserted locally.
- [x] Missing remote todos are inserted locally.
- [x] Matching notes keep the newest effective change time.
- [x] Matching todos keep the newest effective change time.
- [x] Delete/update conflicts compare `deletedAt` and `updatedAt`.
- [x] Sync failure does not delete local data.
- [x] `GET /health` returns a success response.
- [x] `GET /device` returns local device information.
- [x] `GET /snapshot` returns a JSON snapshot.
- [x] `POST /sync` accepts a JSON snapshot and returns a JSON result.
- [x] The client can read peer health.
- [x] The client can read peer device information.
- [x] The client can read peer snapshots.
- [x] The client can send a local snapshot to the peer.
- [x] The sync controller can start the local server.
- [x] The sync controller can stop the local server.
- [x] The sync controller rejects an empty peer address with a clear error state.
- [x] The sync controller can sync with a valid peer URI.
- [x] Settings exposes manual LAN sync controls.
- [x] Existing Notes, Todos, Settings, and Theme behavior remains covered by tests.
- [x] Relevant sync tests are added or updated.
- [x] `flutter analyze` passes.
- [x] `flutter test` passes.
- [x] The final result is ready for Phase 7 without expanding into polish work.

## Constraints

- Existing patterns to preserve:
  - Keep Flutter as the cross-platform framework.
  - Keep Riverpod as the state management direction.
  - Keep Drift as the local persistence layer.
  - Keep sync code under `lib/features/sync/`.
  - Keep manual sync controls inside Settings.
  - Keep the current feature-based directory structure.
  - Keep P5 theme customization and lightweight route transitions intact.

- Technical limits:
  - Use `dart:io` HTTP server/client for this MVP.
  - Keep the server local-network oriented and simple.
  - Avoid adding heavy networking or discovery dependencies.
  - Android runtime verification may still need emulator or a real device.
  - Windows firewall may ask for permission when the sync server binds to a local port.

- Compatibility requirements:
  - The app should continue to target Windows and Android.
  - The app should continue to build with Flutter 3.44.4 / Dart 3.12.2.
  - The Android emulator target is Android 16 / API 36.

## Notes

- Extra context:
  - This goal corresponds to `docs/DEVELOPMENT_PHASES.md`, Phase 6 LAN sync MVP.
  - Phase 1 completed the app shell and navigation.
  - Phase 2 completed the Drift database and database-backed repositories.
  - Phase 3 completed the Notes MVP.
  - Phase 4 completed the Todos MVP.
  - Phase 5 completed theme customization.
  - Sync server/client files already exist but are mostly scaffolds.

- Links or examples:
  - `docs/DEVELOPMENT_PHASES.md`
  - `docs/ARCHITECTURE.md`
  - `task_plan.md`
  - `findings.md`
  - `progress.md`
