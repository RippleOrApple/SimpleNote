# V2 Phase 1 Acceptance

Date: 2026-07-18

Branch: `codex/ticktick-v2-phase1`

## Automated Acceptance

| Area | Verification | Result |
|---|---|---|
| Database migration and backup | `flutter test test/database/migration_v2_test.dart test/database/schema_v2_test.dart` | PASS. Retry-safe schema 2 migration, pre-migration backup, legacy task mapping, and schema constraints are covered. |
| Appearance presets and custom inputs | `flutter test test/appearance/appearance_page_test.dart test/appearance/rgb_color_test.dart test/appearance/palette_extractor_test.dart` | PASS. Presets, RGB/HEX validation, extraction, and wallpaper controls are covered. |
| Platform-local density, navigation, and crop | `flutter test test/appearance/appearance_controller_test.dart test/appearance/appearance_repository_test.dart test/navigation/navigation_controller_test.dart` | PASS. Portable and device-local boundaries persist independently. |
| Windows four-zone workspace | `flutter test test/tasks/tasks_page_test.dart test/navigation/adaptive_app_shell_test.dart` | PASS at the 1280x800 Windows test viewport. |
| Android icon-only navigation | `flutter test test/navigation/adaptive_app_shell_test.dart` | PASS at 390x844 with hidden labels, semantic labels, and 48dp targets. |
| Task search, lists, tags, filters, subtasks, and priorities | `flutter test test/tasks` | PASS across domain, repository, controller, and workspace tests. |
| Note and task inline images | `flutter test test/notes/note_inline_image_test.dart test/tasks/task_inline_image_test.dart test/attachments/embedded_markdown_view_test.dart` | PASS for insertion, rendering, preview, deletion, metadata, and immutable creation dates. |
| Missing-image and failed-import recovery | `flutter test test/attachments test/notes/note_inline_image_test.dart test/tasks/task_inline_image_test.dart` | PASS for missing files, rollback, failed status, recovered-image target choice, and no automatic attachment. |
| V1 sync production guard | `flutter test test/sync/sync_controller_test.dart test/widget_test.dart` | PASS. Production defaults to disabled, while an explicit test-only override retains V1 compatibility coverage. |
| Accessibility and reduced motion | `flutter test test/accessibility test/appearance/app_haptics_test.dart test/appearance/app_theme_test.dart` | PASS for transparency preference, reduced-motion theme behavior, and haptic policy. |
| Windows debug build | `flutter build windows --debug` | PASS. Produced `build/windows/x64/runner/Debug/simple_note.exe`. This machine used generated junctions because Windows Developer Mode is disabled. |
| Android debug APK build | `flutter build apk --debug` | PASS with JDK 17. Produced `build/app/outputs/flutter-apk/app-debug.apk`. |

Full gate results:

- `dart format --output=none --set-exit-if-changed lib test`: PASS, 159 files unchanged.
- `dart run build_runner build --delete-conflicting-outputs`: PASS, 295 outputs written; build_runner reports that the compatibility flag is now ignored.
- `flutter analyze`: PASS, no issues.
- `flutter test`: PASS, 186 tests.

## Emulator Smoke Check

Android emulator `SimpleNote_Pixel`:

- Installed the generated debug APK and launched `com.example.simple_note/.MainActivity`: PASS.
- Today workspace rendered after startup with icon-only bottom navigation and no overlap: PASS.
- Tapped `More`; Settings opened with the V2 sync upgrade notice in the first viewport and no V1 sync controls: PASS.

## Hardware Follow-up

No physical Android device was connected, so gallery, camera, real vibration, system reduced-motion behavior, and picker-process recovery were not manually exercised on hardware. Their application behavior is covered by attachment picker, recovery, motion, and haptic tests.

Windows migration from a copied user database, image persistence after a real process restart, and appearance persistence after a real process restart were not manually repeated in this session. Migration, persistence, image transaction, and reconstruction tests cover those paths automatically.

## Build Compatibility Notes

- The current plugin tree mixes legacy Kotlin Gradle Plugin users with plugins preparing for AGP 9 Built-in Kotlin. The project uses AGP 8.9.1, Gradle 8.11.1, JDK 17, and `kotlin.incremental=false` for reliable Android builds when the Pub Cache and project are on different Windows drives.
- Flutter warns that AGP 8.9.1, Gradle 8.11.1, and `file_picker`'s legacy KGP integration will require a coordinated future upgrade. These warnings do not fail the current debug build.
- Windows plugin builds require Developer Mode/symlink privilege in a clean checkout. This session used directory junctions only inside `windows/flutter/ephemeral` and did not change the system security setting.
