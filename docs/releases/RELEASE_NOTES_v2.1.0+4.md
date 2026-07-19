# Release Notes: v2.1.0+4

Date: 2026-07-19

## Summary

SimpleNote `v2.1.0+4` completes V2 Phase 3. This release adds the full habit loop, global statistics, a real Calendar experience, and Calendar integration for habit plans and checkins while keeping the app local-first and offline-capable.

## Added

- Calendar module page with agenda-style day grouping.
- Calendar aggregation for task start/due markers, recurring task occurrences, note creation dates, and habit plans.
- Habit schema, domain models, repository, application controller, and adaptive Habits page.
- Habit CRUD, archive/unarchive, soft deletion, daily checkin, checkin cancellation, history, completion rate, and streak calculations.
- Statistics module with week/month/year ranges.
- Statistics aggregation for task completions, one-off completed tasks, habit checkins, habit completion rate, current streak, and longest streak.
- Phase 3 acceptance record at `docs/acceptance/V2_PHASE_3_ACCEPTANCE.md`.

## Changed

- App version advanced from `2.0.0+3` to `2.1.0+4`.
- README now describes the current Phase 3 project state and release boundaries.
- Documentation indexes now include the Phase 3 acceptance and release notes.

## Boundaries

- V2 LAN sync remains Phase 4 and is not enabled in this release.
- The old V1 sync entry remains disabled in production because it cannot safely handle V2 data.
- Native platform notification delivery is still not claimed by this release.
- Calendar remains a focused agenda view; richer calendar editing is future work.

## Verification

- `dart format --output=none --set-exit-if-changed lib test`: PASS.
- `flutter analyze`: PASS, no issues found.
- `flutter test`: PASS, 241 tests.
- `flutter build windows --release`: PASS.
- `flutter build apk --release`: PASS. Android emitted Gradle, AGP, KGP, and SDK XML compatibility warnings that do not fail this release.

## Release Artifacts

- `SimpleNote-v2.1.0+4-windows-x64.zip`
- `SimpleNote-v2.1.0+4-android-release.apk`
