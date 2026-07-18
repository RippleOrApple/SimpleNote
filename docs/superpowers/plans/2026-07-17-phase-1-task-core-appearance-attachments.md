# SimpleNote V2 Phase 1 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Deliver a testable V2 foundation on Windows and Android with the adaptive app shell, full appearance customization, V2 task core, safe V1-to-V2 migration, and inline images in task and note Markdown.

**Architecture:** Keep the existing Flutter + Riverpod + Drift layering, but make the app shell own navigation instead of letting every feature page create its own shell. Add isolated Appearance, Tasks V2, and Attachments modules; preserve the V1 `todos` table and sync types as read-only compatibility code while all routed task UI writes only `tasks_v2`. Store portable appearance JSON in `app_settings`, device-only layout settings in `device_appearance_profiles`, and image metadata in dedicated Drift tables backed by content-addressed files.

**Tech Stack:** Flutter 3.44.4, Dart 3.12.2, Riverpod 2.6.x, Drift 2.34.x, SQLite, `flutter_markdown`, `file_picker`, `image_picker`, `cross_file`, `image`, `crypto`, and `phosphor_flutter`.

## Global Constraints

- Target Windows and Android; Android minimum SDK is 24 and Windows minimum is Windows 10.
- Keep every core workflow offline-first; do not add accounts, cloud services, web support, collaboration, or Pomodoro.
- Do not copy TickTick names, artwork, icons, or brand assets.
- Only the internal `today` navigation entry is mandatory; every other navigation entry is reorderable, hideable, and recoverable from settings.
- Android bottom navigation shows rounded 24dp icons without persistent text, retains semantic labels, and keeps each target at least 48×48dp.
- Default layout density is standard; Windows and Android persist density, navigation, crop, and haptics independently.
- Default corner hierarchy is 16px cards, 18px dialogs, and 10px compact controls.
- Default motion is expressive (300–380ms for completion/check-in), but system reduced-motion replaces translation, spring, and large scale with short fades.
- Android haptics default to off.
- Notes remain independent from tasks. A note's calendar ownership remains its immutable `createdAt`; editing changes only `updatedAt`.
- Task descriptions and note bodies persist Markdown with `attachment://<id>` URIs; JPEG, PNG, and WebP imports are limited to 20 MB each.
- Phase 1 disables the V1 sync controls. Phase 4 owns V2 metadata and file synchronization.
- Keep files focused: presentation widgets do not run Drift SQL or filesystem operations; controllers coordinate repositories and services.
- Follow TDD for every behavior change. Run the focused red test before implementation and the focused green test afterward.
- Run `dart format`, `flutter analyze`, and `flutter test` before the final Phase 1 checkpoint.

---

## Planned File Structure

```text
assets/
├─ backgrounds/presets/                  # four approved generated wallpapers
├─ fonts/
│  ├─ NotoSansCJKsc-Regular.otf
│  ├─ ResourceHanRoundedCN-Regular.ttf
│  └─ LXGWWenKai-Regular.ttf
└─ licenses/
   ├─ Resource-Han-Rounded-LICENSE.txt
   ├─ LXGW-WenKai-OFL.txt
   └─ THIRD_PARTY_FONTS.md
lib/
├─ core/
│  ├─ feedback/app_haptics.dart
│  ├─ motion/app_motion.dart
│  ├─ routing/app_routes.dart
│  └─ theme/
│     ├─ app_theme.dart
│     ├─ derived_surface_palette.dart
│     └─ typography_preferences.dart
├─ database/
│  ├─ app_database.dart
│  ├─ backup/database_backup_service.dart
│  ├─ migrations/schema_v2_migration.dart
│  ├─ daos/
│  │  ├─ appearance_dao.dart
│  │  ├─ attachments_dao.dart
│  │  ├─ task_taxonomy_dao.dart
│  │  └─ tasks_v2_dao.dart
│  └─ tables/
│     ├─ background_images_table.dart
│     ├─ content_attachments_table.dart
│     ├─ custom_colors_table.dart
│     ├─ device_appearance_profiles_table.dart
│     ├─ smart_filters_table.dart
│     ├─ task_lists_table.dart
│     ├─ task_tag_links_table.dart
│     ├─ task_tags_table.dart
│     └─ tasks_v2_table.dart
├─ features/
│  ├─ appearance/
│  │  ├─ application/appearance_controller.dart
│  │  ├─ data/appearance_repository.dart
│  │  ├─ domain/
│  │  │  ├─ appearance_presets.dart
│  │  │  ├─ appearance_settings.dart
│  │  │  ├─ background_image.dart
│  │  │  ├─ custom_color.dart
│  │  │  ├─ device_appearance_profile.dart
│  │  │  └─ rgb_color.dart
│  │  ├─ infrastructure/
│  │  │  ├─ background_image_service.dart
│  │  │  └─ palette_extractor.dart
│  │  └─ presentation/
│  │     ├─ appearance_page.dart
│  │     ├─ background_settings_section.dart
│  │     ├─ color_settings_section.dart
│  │     ├─ layout_settings_section.dart
│  │     ├─ navigation_settings_section.dart
│  │     └─ typography_settings_section.dart
│  ├─ attachments/
│  │  ├─ application/attachment_import_service.dart
│  │  ├─ data/attachments_repository.dart
│  │  ├─ domain/content_attachment.dart
│  │  ├─ infrastructure/
│  │  │  ├─ attachment_file_store.dart
│  │  │  └─ attachment_picker.dart
│  │  └─ presentation/attachment_image.dart
│  ├─ navigation/
│  │  ├─ application/navigation_controller.dart
│  │  ├─ domain/app_module.dart
│  │  └─ presentation/
│  │     ├─ adaptive_app_shell.dart
│  │     ├─ placeholder_module_page.dart
│  │     └─ rounded_icon_navigation.dart
│  ├─ notes/presentation/notes_page.dart
│  ├─ settings/presentation/settings_page.dart
│  ├─ sync/presentation/sync_upgrade_notice.dart
│  └─ tasks/
│     ├─ application/tasks_controller.dart
│     ├─ data/tasks_repository.dart
│     ├─ domain/
│     │  ├─ smart_filter.dart
│     │  ├─ task.dart
│     │  ├─ task_list.dart
│     │  ├─ task_query.dart
│     │  └─ task_tag.dart
│     └─ presentation/
│        ├─ quick_add_task.dart
│        ├─ task_detail_pane.dart
│        ├─ task_filter_editor.dart
│        ├─ task_list_pane.dart
│        ├─ task_sources_pane.dart
│        └─ tasks_page.dart
└─ shared/
   ├─ models/markdown_edit.dart
   └─ widgets/
      ├─ app_background.dart
      ├─ embedded_markdown_editor.dart
      ├─ embedded_markdown_view.dart
      └─ frosted_surface.dart
test/
├─ appearance/
├─ assets/
├─ attachments/
├─ database/
├─ navigation/
├─ notes/
└─ tasks/
```

## Task 1: Pin Dependencies, Fonts, Licenses, and Asset Manifests

**Files:**
- Modify: `pubspec.yaml`
- Modify: `android/app/build.gradle.kts`
- Create: `assets/fonts/ResourceHanRoundedCN-Regular.ttf`
- Create: `assets/fonts/LXGWWenKai-Regular.ttf`
- Create: `assets/licenses/Resource-Han-Rounded-LICENSE.txt`
- Create: `assets/licenses/LXGW-WenKai-OFL.txt`
- Create: `assets/licenses/THIRD_PARTY_FONTS.md`
- Create: `test/assets/asset_bundle_test.dart`

**Interfaces:**
- Produces font families `ResourceHanRoundedCN` and `LXGWWenKai`.
- Produces bundled background directory `assets/backgrounds/presets/`.
- Adds direct package APIs used by later tasks: `XFile`, `FilePicker`, `ImagePicker`, `img.decodeImage`, `sha256`, and `PhosphorIcons`.

- [ ] **Step 1: Write the failing asset-bundle test**

```dart
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('approved fonts and wallpaper presets are bundled', () async {
    const paths = [
      'assets/fonts/ResourceHanRoundedCN-Regular.ttf',
      'assets/fonts/LXGWWenKai-Regular.ttf',
      'assets/backgrounds/presets/mist-morning.png',
      'assets/backgrounds/presets/berry-dusk.png',
      'assets/backgrounds/presets/lavender-moon.png',
      'assets/backgrounds/presets/eucalyptus-valley.png',
    ];

    for (final path in paths) {
      final data = await rootBundle.load(path);
      expect(data.lengthInBytes, greaterThan(1024), reason: path);
    }
  });
}
```

- [ ] **Step 2: Run the focused test and verify the red state**

Run:

```powershell
flutter test test/assets/asset_bundle_test.dart
```

Expected: FAIL because the two new font assets are not declared or present.

- [ ] **Step 3: Add pinned dependencies and declare assets**

Use these exact main dependencies:

```yaml
dependencies:
  cross_file: ^0.3.5+4
  crypto: ^3.0.7
  file_picker: ^11.0.2
  image: ^4.9.1
  image_picker: ^1.2.3
  mime: ^2.0.0
  phosphor_flutter: ^2.1.0
  sqlite3: ^3.3.4
```

Extend the Flutter section:

```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/backgrounds/presets/
    - assets/licenses/
  fonts:
    - family: NotoSansSC
      fonts:
        - asset: assets/fonts/NotoSansCJKsc-Regular.otf
    - family: ResourceHanRoundedCN
      fonts:
        - asset: assets/fonts/ResourceHanRoundedCN-Regular.ttf
    - family: LXGWWenKai
      fonts:
        - asset: assets/fonts/LXGWWenKai-Regular.ttf
```

Set Android minimum SDK explicitly:

```kotlin
defaultConfig {
    applicationId = "com.example.simple_note"
    minSdk = 24
    targetSdk = flutter.targetSdkVersion
    versionCode = flutter.versionCode
    versionName = flutter.versionName
}
```

- [ ] **Step 4: Copy the verified fonts and fetch pinned license texts**

Run from the repository root:

```powershell
$fontPreviewRoot = '.superpowers\brainstorm\25852-1784304497.79858\content\font-assets-v23'
$resourceSource = Join-Path $fontPreviewRoot 'ResourceHanRoundedCN-Regular.ttf'
$wenKaiSource = Join-Path $fontPreviewRoot 'LXGWWenKai-Regular.ttf'
$resourceHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $resourceSource).Hash.ToLower()
$wenKaiHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $wenKaiSource).Hash.ToLower()
if ($resourceHash -ne '1c5c623f008eabef10c45135a48b01b46311f9369c28857355872cfe05f48dc0') { throw 'Resource Han Rounded hash mismatch' }
if ($wenKaiHash -ne '39ad71264b588165b469e35e6afb162a378dacd1f95348160240ba9038ac3009') { throw 'LXGW WenKai hash mismatch' }
New-Item -ItemType Directory -Force -Path 'assets\fonts','assets\licenses' | Out-Null
Copy-Item -LiteralPath $resourceSource -Destination 'assets\fonts\ResourceHanRoundedCN-Regular.ttf'
Copy-Item -LiteralPath $wenKaiSource -Destination 'assets\fonts\LXGWWenKai-Regular.ttf'
Invoke-WebRequest -UseBasicParsing -Uri 'https://raw.githubusercontent.com/CyanoHao/Resource-Han-Rounded/v0.990/LICENSE.txt' -OutFile 'assets\licenses\Resource-Han-Rounded-LICENSE.txt'
Invoke-WebRequest -UseBasicParsing -Uri 'https://raw.githubusercontent.com/lxgw/LxgwWenKai/v1.522/OFL.txt' -OutFile 'assets\licenses\LXGW-WenKai-OFL.txt'
```

Create `THIRD_PARTY_FONTS.md` with the exact versions, upstream URLs, license names, and the two verified SHA-256 values above.

- [ ] **Step 5: Resolve dependencies and verify assets**

Run:

```powershell
flutter pub get
flutter test test/assets/asset_bundle_test.dart
```

Expected: dependency resolution succeeds and the focused test passes.

- [ ] **Step 6: Commit**

```powershell
git add pubspec.yaml pubspec.lock android/app/build.gradle.kts assets/fonts assets/licenses test/assets/asset_bundle_test.dart
git commit -m "build: add phase one visual and media assets"
```

## Task 2: Add Schema V2, Pre-Migration Backup, and Legacy Todo Migration

**Files:**
- Modify: `lib/database/app_database.dart`
- Modify: `lib/database/tables/database_tables.dart`
- Create: `lib/database/backup/database_backup_service.dart`
- Create: `lib/database/migrations/schema_v2_migration.dart`
- Create: `lib/database/tables/task_lists_table.dart`
- Create: `lib/database/tables/tasks_v2_table.dart`
- Create: `lib/database/tables/task_tags_table.dart`
- Create: `lib/database/tables/task_tag_links_table.dart`
- Create: `lib/database/tables/smart_filters_table.dart`
- Create: `lib/database/tables/content_attachments_table.dart`
- Create: `lib/database/tables/custom_colors_table.dart`
- Create: `lib/database/tables/background_images_table.dart`
- Create: `lib/database/tables/device_appearance_profiles_table.dart`
- Create: `lib/database/daos/tasks_v2_dao.dart`
- Create: `lib/database/daos/task_taxonomy_dao.dart`
- Create: `lib/database/daos/attachments_dao.dart`
- Create: `lib/database/daos/appearance_dao.dart`
- Regenerate: `lib/database/app_database.g.dart`
- Create: `test/database/schema_v2_test.dart`
- Create: `test/database/migration_v2_test.dart`

**Interfaces:**
- Produces `AppDatabase.schemaVersion == 2`.
- Produces Drift row types `TaskV2Row`, `TaskListRow`, `TaskTagRow`, `TaskTagLinkRow`, `SmartFilterRow`, `ContentAttachmentRow`, `CustomColorRow`, `BackgroundImageRow`, and `DeviceAppearanceProfileRow`.
- Preserves the V1 `todos` table unchanged and migrates each legacy row once into `tasks_v2` with the same ID.
- Treats Inbox as the virtual `today` task module's system smart source; migrated tasks keep `list_id = NULL`.

- [ ] **Step 1: Write failing schema and migration tests**

Create `schema_v2_test.dart`:

```dart
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_note/database/app_database.dart';

void main() {
  test('schema v2 creates every phase one table', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    await database.open();

    final rows = await database
        .customSelect("SELECT name FROM sqlite_master WHERE type = 'table'")
        .get();
    final names = rows.map((row) => row.read<String>('name')).toSet();

    expect(
      names,
      containsAll({
        'task_lists',
        'tasks_v2',
        'task_tags',
        'task_tag_links',
        'smart_filters',
        'content_attachments',
        'custom_colors',
        'background_images',
        'device_appearance_profiles',
      }),
    );

    await expectLater(
      database.customStatement(
        "INSERT INTO content_attachments "
        "(id, owner_type, owner_id, sha256, mime_type, byte_size, width, "
        "height, relative_path, thumbnail_relative_path, sort_order, "
        "created_at, updated_at, device_id, version) "
        "VALUES ('bad', 'habit', 'h1', 'sha', 'image/png', 1, 1, 1, "
        "'a', 'b', 0, 1, 1, 'device', 1)",
      ),
      throwsA(anything),
    );
  });
}
```

Create `migration_v2_test.dart` around a temporary SQLite file. Seed one V1 todo with priority `2`, `completed = 1`, and a due date; open it through the production file-opening path; then assert:

```dart
expect(migrated.id, 'legacy-task');
expect(migrated.descriptionMarkdown, 'legacy body');
expect(migrated.priority, 3);
expect(migrated.completed, isTrue);
expect(migrated.completedAt, 200);
expect(migrated.dueAt, 300);
expect(migrated.listId, isNull);
expect(backupFiles, hasLength(1));
```

- [ ] **Step 2: Run both tests and verify the red state**

Run:

```powershell
flutter test test/database/schema_v2_test.dart test/database/migration_v2_test.dart
```

Expected: FAIL because `schemaVersion` is still 1 and the V2 tables do not exist.

- [ ] **Step 3: Define the exact table contracts**

Use these core definitions; every syncable table also includes `created_at`, `updated_at`, nullable `deleted_at`, `device_id`, and `version` exactly as shown in the approved spec:

```dart
@DataClassName('TaskV2Row')
class TasksV2 extends Table {
  @override
  String get tableName => 'tasks_v2';

  TextColumn get id => text()();
  TextColumn get parentId => text().named('parent_id').nullable()();
  TextColumn get listId => text().named('list_id').nullable()();
  TextColumn get title => text()();
  TextColumn get descriptionMarkdown =>
      text().named('description_markdown').withDefault(const Constant(''))();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
  IntColumn get priority => integer().withDefault(const Constant(0))();
  IntColumn get startAt => integer().named('start_at').nullable()();
  IntColumn get dueAt => integer().named('due_at').nullable()();
  BoolColumn get allDay =>
      boolean().named('all_day').withDefault(const Constant(false))();
  IntColumn get sortOrder =>
      integer().named('sort_order').withDefault(const Constant(0))();
  TextColumn get recurrenceRule =>
      text().named('recurrence_rule').nullable()();
  IntColumn get recurrenceEndAt =>
      integer().named('recurrence_end_at').nullable()();
  IntColumn get recurrenceCount =>
      integer().named('recurrence_count').nullable()();
  IntColumn get completedAt => integer().named('completed_at').nullable()();
  IntColumn get createdAt => integer().named('created_at')();
  IntColumn get updatedAt => integer().named('updated_at')();
  IntColumn get deletedAt => integer().named('deleted_at').nullable()();
  TextColumn get deviceId => text().named('device_id')();
  IntColumn get version => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}
```

```dart
@DataClassName('ContentAttachmentRow')
class ContentAttachments extends Table {
  @override
  String get tableName => 'content_attachments';

  TextColumn get id => text()();
  TextColumn get ownerType => text().named('owner_type')();
  TextColumn get ownerId => text().named('owner_id')();
  TextColumn get sha256 => text()();
  TextColumn get mimeType => text().named('mime_type')();
  IntColumn get byteSize => integer().named('byte_size')();
  IntColumn get width => integer()();
  IntColumn get height => integer()();
  TextColumn get relativePath => text().named('relative_path')();
  TextColumn get thumbnailRelativePath =>
      text().named('thumbnail_relative_path')();
  IntColumn get sortOrder =>
      integer().named('sort_order').withDefault(const Constant(0))();
  IntColumn get createdAt => integer().named('created_at')();
  IntColumn get updatedAt => integer().named('updated_at')();
  IntColumn get deletedAt => integer().named('deleted_at').nullable()();
  TextColumn get deviceId => text().named('device_id')();
  IntColumn get version => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}
```

Define the remaining tables with the approved fields and these constraints:

```text
task_lists: id, name, color, icon_key, sort_order, archived, sync metadata
task_tags: id, name, color, sync metadata
task_tag_links: task_id + tag_id composite key, sync metadata
smart_filters: id, name, rules_json, sort_mode, sort_order, pinned, sync metadata
custom_colors: id, name, rgb, sort_order, sync metadata
background_images: id, sha256, mime_type, byte_size, width, height,
                   relative_path, sync_enabled, sync metadata
device_appearance_profiles: id, platform, density, nav_order_json,
                            hidden_nav_json, start_module,
                            local_background_image_id, background_focus_x,
                            background_focus_y, background_zoom,
                            background_blur, background_overlay,
                            haptics_mode, updated_at
```

Add table checks for task priority `0...3`, attachment owner type `task|note`, custom RGB `0...0xFFFFFF`, normalized focus `0...1`, non-negative blur, and positive zoom. Add active-query indexes in `SchemaV2Migration`:

```dart
await db.customStatement(
  "CREATE UNIQUE INDEX custom_colors_rgb_active "
  "ON custom_colors(rgb) WHERE deleted_at IS NULL",
);
await db.customStatement(
  "CREATE INDEX content_attachments_owner_active "
  "ON content_attachments(owner_type, owner_id, sort_order) "
  "WHERE deleted_at IS NULL",
);
await db.customStatement(
  "CREATE INDEX tasks_v2_due_active "
  "ON tasks_v2(due_at, completed) WHERE deleted_at IS NULL",
);
```

- [ ] **Step 4: Implement backup-before-upgrade and V1 row migration**

`DatabaseBackupService.prepare` must read `PRAGMA user_version` before Drift opens the production connection. If the version is from 1 through 1, copy the database to `<support>/backups/simple_note.pre-v2.<millis>.sqlite`; if the copy fails, throw and do not open the mutable database.

Use this migration body:

```dart
static Future<void> run(AppDatabase db, Migrator migrator) async {
  await migrator.createTable(db.taskLists);
  await migrator.createTable(db.tasksV2);
  await migrator.createTable(db.taskTags);
  await migrator.createTable(db.taskTagLinks);
  await migrator.createTable(db.smartFilters);
  await migrator.createTable(db.contentAttachments);
  await migrator.createTable(db.customColors);
  await migrator.createTable(db.backgroundImages);
  await migrator.createTable(db.deviceAppearanceProfiles);

  await db.customStatement('''
    INSERT OR IGNORE INTO tasks_v2 (
      id, parent_id, list_id, title, description_markdown, completed,
      priority, start_at, due_at, all_day, sort_order, recurrence_rule,
      recurrence_end_at, recurrence_count, completed_at, created_at,
      updated_at, deleted_at, device_id, version
    )
    SELECT
      id, NULL, NULL, title, description, completed,
      CASE priority WHEN 0 THEN 1 WHEN 1 THEN 2 ELSE 3 END,
      NULL, due_at, 1, created_at, NULL, NULL, NULL,
      CASE WHEN completed = 1 THEN updated_at ELSE NULL END,
      created_at, updated_at, deleted_at, device_id, version
    FROM todos
  ''');
  await createIndexes(db);
}
```

Set:

```dart
@override
int get schemaVersion => 2;

@override
MigrationStrategy get migration => MigrationStrategy(
  onCreate: (migrator) async {
    await migrator.createAll();
    await SchemaV2Migration.createIndexes(this);
  },
  onUpgrade: (migrator, from, to) async {
    if (from < 2) {
      await SchemaV2Migration.run(this, migrator);
    }
  },
);
```

- [ ] **Step 5: Generate Drift code and run the focused tests**

Run:

```powershell
dart run build_runner build --delete-conflicting-outputs
dart format lib/database test/database
flutter test test/database/schema_v2_test.dart test/database/migration_v2_test.dart
```

Expected: generated code succeeds; both tests pass; migration creates exactly one backup and preserves the legacy row.

- [ ] **Step 6: Commit**

```powershell
git add lib/database test/database
git commit -m "feat: add v2 schema and legacy task migration"
```

## Task 3: Implement Appearance Value Objects, Presets, Contrast, and Image Palette Extraction

**Files:**
- Create: `lib/features/appearance/domain/rgb_color.dart`
- Create: `lib/features/appearance/domain/appearance_presets.dart`
- Create: `lib/features/appearance/domain/appearance_settings.dart`
- Create: `lib/features/appearance/domain/custom_color.dart`
- Create: `lib/features/appearance/domain/background_image.dart`
- Create: `lib/features/appearance/domain/device_appearance_profile.dart`
- Create: `lib/features/appearance/infrastructure/palette_extractor.dart`
- Create: `lib/core/theme/derived_surface_palette.dart`
- Create: `lib/core/theme/typography_preferences.dart`
- Create: `test/appearance/rgb_color_test.dart`
- Create: `test/appearance/palette_extractor_test.dart`
- Create: `test/appearance/derived_surface_palette_test.dart`

**Interfaces:**
- Produces `RgbColor.parse(String)`, `RgbColor.value`, and `RgbColor.toHex()`.
- Produces immutable `AppearanceSettings` and `DeviceAppearanceProfile` JSON contracts.
- Produces `const PaletteExtractor()` and `PaletteExtractor.extract(Uint8List bytes) -> List<RgbColor>` with at most five distinct candidates.
- Produces `DerivedSurfacePalette.from(accent, background, brightness)` with contrast-safe foreground colors.

- [ ] **Step 1: Write failing value-object and extraction tests**

```dart
test('parses hex and comma RGB into the same normalized value', () {
  expect(RgbColor.parse('#5E9D83').value, 0x5E9D83);
  expect(RgbColor.parse('5e9d83').value, 0x5E9D83);
  expect(RgbColor.parse('94,157,131').value, 0x5E9D83);
  expect(() => RgbColor.parse('300,0,0'), throwsFormatException);
});
```

```dart
test('extracts five separated candidates from a deterministic image', () {
  final image = img.Image(width: 50, height: 10);
  const colors = [0x596790, 0x4D8BB8, 0x5E9D83, 0xB66B86, 0x8A6FB0];
  for (var x = 0; x < image.width; x++) {
    final rgb = colors[x ~/ 10];
    for (var y = 0; y < image.height; y++) {
      image.setPixelRgb(x, y, rgb >> 16, (rgb >> 8) & 0xff, rgb & 0xff);
    }
  }
  final result = PaletteExtractor().extract(Uint8List.fromList(img.encodePng(image)));
  expect(result.map((color) => color.value).toSet(), containsAll(colors));
});
```

```dart
test('derived text meets WCAG contrast thresholds', () {
  final palette = DerivedSurfacePalette.from(
    accent: const RgbColor(0x596790),
    background: const RgbColor(0xDFE8F5),
    brightness: Brightness.light,
  );
  expect(contrastRatio(palette.onSurface, palette.surface), greaterThanOrEqualTo(4.5));
  expect(contrastRatio(palette.onAccent, palette.accent), greaterThanOrEqualTo(4.5));
});
```

- [ ] **Step 2: Run focused tests and verify the red state**

Run:

```powershell
flutter test test/appearance/rgb_color_test.dart test/appearance/palette_extractor_test.dart test/appearance/derived_surface_palette_test.dart
```

Expected: FAIL because the appearance types do not exist.

- [ ] **Step 3: Implement exact preset and settings contracts**

`RgbColor`:

```dart
final class RgbColor {
  const RgbColor(this.value) : assert(value >= 0 && value <= 0xFFFFFF);

  final int value;

  factory RgbColor.parse(String input) {
    final value = input.trim();
    if (value.contains(',')) {
      final parts = value.split(',').map((part) => int.tryParse(part.trim())).toList();
      if (parts.length != 3 || parts.any((part) => part == null || part < 0 || part > 255)) {
        throw FormatException('RGB must contain three values from 0 to 255.');
      }
      return RgbColor((parts[0]! << 16) | (parts[1]! << 8) | parts[2]!);
    }
    final normalized = value.replaceFirst('#', '');
    if (!RegExp(r'^[0-9a-fA-F]{6}$').hasMatch(normalized)) {
      throw FormatException('HEX must contain exactly six hexadecimal digits.');
    }
    return RgbColor(int.parse(normalized, radix: 16));
  }

  String toHex() => '#${value.toRadixString(16).padLeft(6, '0').toUpperCase()}';

  @override
  bool operator ==(Object other) => other is RgbColor && other.value == value;

  @override
  int get hashCode => value.hashCode;
}
```

Define these exact enums:

```dart
enum AppBrightnessMode { system, light, dark }
enum BackgroundKind { presetColor, customColor, bundledImage, syncedImage }
enum UiScale { small, standard, large }
enum LayoutDensity { compact, standard, relaxed }
enum MotionLevel { reduced, natural, expressive }
enum HapticsMode { off, keyActions, rich }
```

Define preset lists with the exact approved values:

```dart
static const backgroundColors = [
  RgbColor(0xDFE8F5),
  RgbColor(0xE3ECDD),
  RgbColor(0xF1E3E7),
  RgbColor(0xEAE2F2),
  RgbColor(0xF1E9DC),
  RgbColor(0xDDECE9),
  RgbColor(0xEEDBD5),
];

static const accentColors = [
  RgbColor(0x596790),
  RgbColor(0x4D8BB8),
  RgbColor(0x5E9D83),
  RgbColor(0x78A65A),
  RgbColor(0xB66B86),
  RgbColor(0xCA806E),
  RgbColor(0x8A6FB0),
];

static const notePaperColors = [
  RgbColor(0xFAFAF7),
  RgbColor(0xF8F0DE),
  RgbColor(0xEEE4D1),
  RgbColor(0xE5EFE5),
  RgbColor(0xE4EDF5),
  RgbColor(0xF3E5E8),
  RgbColor(0xECE6F3),
];
```

`AppearanceSettings` stores both the active background selection and `lastPureBackground`, which is updated only when a valid pure background is selected. `AppearanceSettings.defaults()` must use fog blue for both values, indigo, soft-white note paper, `ResourceHanRoundedCN`, `LXGWWenKai`, standard UI scale, note size 17, line height 1.75, expressive motion, tint strength 0.35, glass opacity 0.62, and dark overlay 0.42.

- [ ] **Step 4: Implement deterministic palette extraction and contrast derivation**

Algorithm:

1. Reject undecodable input with `FormatException`.
2. Resize the longest side to 96 pixels.
3. Ignore pixels with alpha below 128, luminance above 0.96, or luminance below 0.04.
4. Quantize each RGB channel into 32-value buckets and count buckets.
5. Sort by population, then by integer RGB value for deterministic ties.
6. Keep a candidate only when Euclidean RGB distance from every accepted candidate is at least 48.
7. Return at most five candidates; if fewer than five survive, append unused approved accent presets.

`PaletteExtractor` has a `const PaletteExtractor()` constructor so the background service can use it as a default injected dependency.

`DerivedSurfacePalette` must choose black or white foreground by the larger contrast ratio, then adjust only the derived surface lightness until normal text reaches 4.5:1. Never mutate the persisted user RGB.

- [ ] **Step 5: Run the focused tests**

Run:

```powershell
dart format lib/features/appearance/domain lib/features/appearance/infrastructure lib/core/theme test/appearance
flutter test test/appearance/rgb_color_test.dart test/appearance/palette_extractor_test.dart test/appearance/derived_surface_palette_test.dart
```

Expected: all appearance unit tests pass.

- [ ] **Step 6: Commit**

```powershell
git add lib/features/appearance lib/core/theme test/appearance
git commit -m "feat: define v2 appearance rules"
```

## Task 4: Persist Portable Appearance and Device-Local Profiles

**Files:**
- Modify: `lib/database/daos/app_settings_dao.dart`
- Modify: `lib/database/daos/appearance_dao.dart`
- Create: `lib/features/appearance/data/appearance_repository.dart`
- Create: `lib/features/appearance/application/appearance_controller.dart`
- Modify: `lib/features/settings/data/theme_repository.dart`
- Modify: `lib/features/settings/application/theme_controller.dart`
- Create: `test/appearance/appearance_repository_test.dart`
- Create: `test/appearance/appearance_controller_test.dart`

**Interfaces:**
- Produces `AppearanceRepository.loadPortable()`, `savePortable()`, `loadDeviceProfile(platform)`, `saveDeviceProfile()`, `listCustomColors()`, `addCustomColor()`, `renameCustomColor()`, `reorderCustomColors()`, and `deleteCustomColor()`.
- Produces `appearanceControllerProvider` with separate portable and local state.
- Preserves the active V1 primary color during first initialization; non-preset colors become the first “My Colors” entry.

- [ ] **Step 1: Write failing repository and controller tests**

Repository assertions:

```dart
expect((await repository.loadPortable()).uiScale, UiScale.standard);
await repository.addCustomColor(name: 'Sea', color: const RgbColor(0x4D8BB8));
await repository.addCustomColor(name: 'Duplicate', color: const RgbColor(0x4D8BB8));
expect(await repository.listCustomColors(), hasLength(1));
await repository.deleteCustomColor((await repository.listCustomColors()).single.id);
expect((await repository.loadPortable()).accent.value, originalAccent.value);
```

Controller assertions:

```dart
await controller.setDensity(LayoutDensity.compact);
await controller.setAccent(const RgbColor(0x5E9D83));
container.invalidate(appearanceControllerProvider);
final reloaded = await container.read(appearanceControllerProvider.future);
expect(reloaded.deviceProfile.density, LayoutDensity.compact);
expect(reloaded.portable.accent.value, 0x5E9D83);
```

- [ ] **Step 2: Run focused tests and verify the red state**

Run:

```powershell
flutter test test/appearance/appearance_repository_test.dart test/appearance/appearance_controller_test.dart
```

Expected: FAIL because the repository and controller do not exist.

- [ ] **Step 3: Implement repository storage boundaries**

Use one portable settings key:

```dart
static const portableSettingsKey = 'appearance.v2.portable';
```

Serialize `AppearanceSettings.toJson()` with `jsonEncode`. Save device-only values in `device_appearance_profiles`, keyed by `'$deviceId:$platform'`. On first load:

1. Read `appearance.v2.portable`.
2. If absent, read the active V1 `theme_schemes` row.
3. Start from `AppearanceSettings.defaults()`.
4. Replace the accent with `primary_color & 0xFFFFFF`.
5. Add that accent to `custom_colors` only if it is not one of the seven approved presets.
6. Persist the V2 portable JSON.
7. Create a device profile with standard density, `today` start module, center crop, zoom 1.0, blur 0, overlay 0, and haptics off.

At this stage, `DeviceAppearanceProfile` serializes navigation order, hidden entries, and the start module as stable string keys such as `today` and `notes`. Task 7 introduces `AppModuleKey` and maps those strings with `AppModuleKey.name`, ignoring unknown values during normalization so older profiles remain readable.

Enforce custom-color rules in the repository:

```dart
if (existing.any((entry) => entry.color.value == color.value)) {
  return existing.firstWhere((entry) => entry.color.value == color.value);
}
if (existing.length >= 24) {
  throw StateError('My Colors supports at most 24 colors.');
}
```

- [ ] **Step 4: Implement the controller API**

Expose these exact mutations:

```dart
Future<void> setAccent(RgbColor value);
Future<void> setBackground(BackgroundSelection value);
Future<void> setLocalBackgroundImage(String? backgroundImageId);
Future<void> setBackgroundPresentation({
  required double focusX,
  required double focusY,
  required double zoom,
  required double blur,
  required double overlay,
});
Future<void> setNotePaper(RgbColor value);
Future<void> setTintStrength(double value);
Future<void> setGlassOpacity(double value);
Future<void> setDarkOverlay(double value);
Future<void> setTypography(TypographyPreferences value);
Future<void> setMotion(MotionLevel value);
Future<void> setDensity(LayoutDensity value);
Future<void> setHaptics(HapticsMode value);
```

Clamp tint, glass, overlay, focus coordinates, zoom, blur, note size, and line height inside domain constructors, not inside widgets.

`setBackground` updates `lastPureBackground` only for a pure preset or custom RGB. `setLocalBackgroundImage` changes only the current platform profile; it never overwrites the portable background selection. `setBackgroundPresentation` also writes only the current platform profile.

Keep `themeControllerProvider` as a temporary read-only adapter that maps V2 appearance state to `AppThemeScheme`; mark its write methods deprecated and route all new settings UI to `appearanceControllerProvider`.

- [ ] **Step 5: Run focused tests**

Run:

```powershell
dart format lib/database/daos lib/features/appearance lib/features/settings test/appearance
flutter test test/appearance/appearance_repository_test.dart test/appearance/appearance_controller_test.dart test/settings/theme_controller_test.dart
```

Expected: appearance tests pass and the existing theme test still passes through the compatibility adapter.

- [ ] **Step 6: Commit**

```powershell
git add lib/database/daos lib/features/appearance lib/features/settings test/appearance test/settings
git commit -m "feat: persist portable and local appearance settings"
```

## Task 5: Import, Extract, Display, and Remove User Background Images

**Files:**
- Modify: `lib/database/daos/appearance_dao.dart`
- Modify: `lib/features/appearance/data/appearance_repository.dart`
- Create: `lib/features/appearance/infrastructure/background_image_service.dart`
- Create: `test/appearance/background_image_service_test.dart`

**Interfaces:**
- Produces `BackgroundImageService.importImage(XFile source, {required bool syncEnabled})`.
- Produces `BackgroundImageService.extractColors(XFile source)` without retaining the source.
- Produces `BackgroundImageService.deleteImage(String id)` with active-background fallback.
- Stores content-addressed files under `<application-support>/backgrounds/<sha256>.<extension>`.

- [ ] **Step 1: Write failing service tests**

Create a temporary directory, an in-memory database, and a deterministic 64×32 PNG. Assert:

```dart
final imported = await service.importImage(
  XFile.fromData(
    Uint8List.fromList(img.encodePng(sourceImage)),
    name: 'sample.png',
    mimeType: 'image/png',
  ),
  syncEnabled: false,
);

expect(imported.width, 64);
expect(imported.height, 32);
expect(imported.mimeType, 'image/png');
expect(imported.syncEnabled, isFalse);
expect(File(imported.absolutePath).existsSync(), isTrue);
expect(await repository.listBackgroundImages(), hasLength(1));
```

Also assert that an undecodable payload throws `FormatException`, a source with `length() > 20 * 1024 * 1024` throws `FileSystemException`, and `extractColors` leaves both the database and background directory unchanged.

- [ ] **Step 2: Run the focused test and verify the red state**

Run:

```powershell
flutter test test/appearance/background_image_service_test.dart
```

Expected: FAIL because `BackgroundImageService` does not exist.

- [ ] **Step 3: Implement the import pipeline**

Use this order:

```text
read reported byte length
reject values above 20 MB
read bytes
decode JPEG, PNG, or WebP
derive the MIME type from decoded format, not the filename
calculate SHA-256
write <sha>.tmp in the background directory
flush the temporary file
rename to <sha>.<extension>
insert or reuse background_images metadata
return a domain BackgroundImage with an absolute display path
```

If metadata insertion fails after the rename, remove the newly-created file only when no other `background_images` record references that SHA-256. If a final content-addressed file already exists, reuse it without rewriting.

Use constructor injection:

```dart
class BackgroundImageService {
  BackgroundImageService({
    required AppearanceRepository repository,
    required Directory rootDirectory,
    PaletteExtractor paletteExtractor = const PaletteExtractor(),
  });

  Future<BackgroundImage> importImage(
    XFile source, {
    required bool syncEnabled,
  });

  Future<List<RgbColor>> extractColors(XFile source);
  Future<void> deleteImage(String id);
}
```

- [ ] **Step 4: Implement deletion and fallback**

In one database transaction:

1. Mark the background row deleted.
2. If portable appearance references the deleted synchronized image, replace it with `lastPureBackground`.
3. If the local device profile references it, clear `local_background_image_id`.

Do not physically delete the content-addressed file in Phase 1. Record `deleted_at`; the Phase 4 cleanup queue owns 30-day deletion.

- [ ] **Step 5: Run the focused tests**

Run:

```powershell
dart format lib/features/appearance lib/database/daos test/appearance
flutter test test/appearance/background_image_service_test.dart test/appearance/appearance_repository_test.dart
```

Expected: both test files pass.

- [ ] **Step 6: Commit**

```powershell
git add lib/features/appearance lib/database/daos test/appearance
git commit -m "feat: manage local background images"
```

## Task 6: Build the Appearance-Driven Theme, Background Layer, and Settings UI

**Files:**
- Modify: `lib/core/theme/app_theme.dart`
- Create: `lib/core/motion/app_motion.dart`
- Create: `lib/core/feedback/app_haptics.dart`
- Create: `lib/shared/widgets/app_background.dart`
- Create: `lib/shared/widgets/frosted_surface.dart`
- Create: `lib/features/appearance/presentation/appearance_page.dart`
- Create: `lib/features/appearance/presentation/background_settings_section.dart`
- Create: `lib/features/appearance/presentation/color_settings_section.dart`
- Create: `lib/features/appearance/presentation/typography_settings_section.dart`
- Create: `lib/features/appearance/presentation/layout_settings_section.dart`
- Modify: `lib/features/settings/presentation/settings_page.dart`
- Modify: `lib/app.dart`
- Create: `test/appearance/appearance_page_test.dart`
- Create: `test/appearance/app_theme_test.dart`
- Create: `test/appearance/app_haptics_test.dart`

**Interfaces:**
- Produces `AppTheme.fromAppearance(AppearanceSettings settings, Brightness platformBrightness)`.
- Produces `AppBackground` for color, bundled image, synchronized image, and local image modes.
- Produces `FrostedSurface` with contrast-safe blur and opacity.
- Produces `AppHaptics.trigger(HapticEvent)` with Android-only, mode-aware feedback and an off-by-default path.
- Produces settings controls with stable widget keys for presets, RGB input, extraction, wallpapers, crop focus, zoom, blur, typography, density, tint, glass, dark overlay, motion, and haptics.

- [ ] **Step 1: Write failing theme and widget tests**

Theme assertions:

```dart
final theme = AppTheme.fromAppearance(
  AppearanceSettings.defaults().copyWith(
    accent: const RgbColor(0x5E9D83),
    uiScale: UiScale.standard,
  ),
  Brightness.light,
);
expect(theme.textTheme.bodyMedium?.fontFamily, 'ResourceHanRoundedCN');
expect(theme.cardTheme.shape, isA<RoundedRectangleBorder>());
expect(
  (theme.cardTheme.shape! as RoundedRectangleBorder).borderRadius,
  BorderRadius.circular(16),
);
```

Widget assertions:

```dart
expect(find.byKey(const Key('background-preset-DFE8F5')), findsOneWidget);
expect(find.byKey(const Key('accent-preset-596790')), findsOneWidget);
expect(find.byKey(const Key('appearance-rgb-field')), findsOneWidget);
expect(find.byKey(const Key('appearance-extract-color-button')), findsOneWidget);
expect(find.byKey(const Key('appearance-background-image-button')), findsOneWidget);
expect(find.byKey(const Key('appearance-background-focus')), findsOneWidget);
expect(find.byKey(const Key('appearance-background-zoom-slider')), findsOneWidget);
expect(find.byKey(const Key('appearance-background-blur-slider')), findsOneWidget);
expect(find.byKey(const Key('appearance-note-size-slider')), findsOneWidget);
expect(find.byKey(const Key('appearance-glass-slider')), findsOneWidget);
expect(find.byKey(const Key('appearance-haptics-mode')), findsOneWidget);
```

- [ ] **Step 2: Run focused tests and verify the red state**

Run:

```powershell
flutter test test/appearance/app_theme_test.dart test/appearance/appearance_page_test.dart
```

Expected: FAIL because the V2 theme and appearance page do not exist.

- [ ] **Step 3: Implement theme and typography**

`AppTheme.fromAppearance` must:

- Resolve system brightness when `AppBrightnessMode.system` is selected.
- Use `ResourceHanRoundedCN` as the default font family and `NotoSansSC` in `fontFamilyFallback`.
- Apply 16px card, 18px dialog, and 10px input/button radii.
- Use the current accent as the solid app bar color.
- Use derived low-tint colors for inputs and hover.
- Use selected accent for selected states.
- Set route and control durations from `AppMotion`:

```dart
abstract final class AppMotion {
  static const hover = Duration(milliseconds: 150);
  static const standard = Duration(milliseconds: 220);
  static const expressive = Duration(milliseconds: 340);
  static const reduced = Duration(milliseconds: 90);
}
```

The note editor and Markdown view override body font to `LXGWWenKai`, size to `noteFontSize`, and height to `noteLineHeight`. Code blocks use `monospace`.

- [ ] **Step 4: Implement background and frosted surfaces**

`AppBackground` structure:

```dart
Stack(
  fit: StackFit.expand,
  children: [
    Positioned.fill(child: background),
    if (blurSigma > 0)
      Positioned.fill(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: const SizedBox.expand(),
        ),
      ),
    Positioned.fill(child: ColoredBox(color: overlayColor)),
    child,
  ],
)
```

Map normalized focus `(0, 0)` to `Alignment.topLeft`, `(0.5, 0.5)` to center, and `(1, 1)` to bottom-right. Use `BoxFit.cover` and the device profile zoom. Dark mode desaturates through a `ColorFiltered` matrix and adds the configured dark overlay. If a file is missing or decoding fails, render the last valid pure background color and expose a settings warning.

`FrostedSurface` uses `BackdropFilter`, the current glass opacity, and an automatically-derived border. It must disable blur when platform accessibility requests reduced transparency, while retaining the translucent color.

- [ ] **Step 5: Implement mode-aware haptic feedback**

Define:

```dart
enum HapticEvent { complete, delete, navigation, selection, reorder }

abstract interface class HapticDriver {
  Future<void> lightImpact();
  Future<void> mediumImpact();
  Future<void> selectionClick();
}
```

`AppHaptics` receives the current `HapticsMode`, platform, and injected `HapticDriver`. It is always a no-op outside Android. `off` never calls the driver; `keyActions` responds only to `complete` and `delete`; `rich` also responds to navigation, selection, and reorder. The production driver delegates to Flutter `HapticFeedback`, which respects Android's system-level haptic setting. Unit tests use a recording fake driver and prove the default `off` mode emits no calls.

- [ ] **Step 6: Implement the appearance settings sections**

Use explicit keys and controller calls:

```text
background-preset-<RRGGBB>
accent-preset-<RRGGBB>
note-paper-<RRGGBB>
appearance-color-target
appearance-rgb-field
appearance-save-color-button
appearance-extract-color-button
appearance-background-image-button
appearance-background-sync-switch
appearance-background-focus
appearance-background-zoom-slider
appearance-background-blur-slider
appearance-background-overlay-slider
appearance-tint-slider
appearance-glass-slider
appearance-dark-overlay-slider
appearance-ui-scale
appearance-density
appearance-note-size-slider
appearance-note-line-height-slider
appearance-motion-level
appearance-haptics-mode
```

The color target selector chooses background, accent, or note paper before RGB/HEX input or image extraction is applied. Note paper accepts extracted colors but never stores an image. The background image button opens `FilePicker.pickFiles(type: FileType.image)`; Android additionally offers gallery and camera through `ImagePicker`. RGB validation stays inline and never replaces the previous valid color on failure. “My Colors” shows at most 24 entries with rename, drag reorder, and delete actions.

The background editor shows a draggable normalized focus target over a preview and sliders for zoom, blur, and overlay. It updates only the current platform's `DeviceAppearanceProfile`. The haptics selector is enabled on Android and displays an explanatory no-op state on Windows.

Task 6 builds every appearance section except navigation customization. `AppearancePage` adds `NavigationSettingsSection` only in Task 7, after `AppModuleKey` and the navigation controller exist.

- [ ] **Step 7: Run focused and compatibility tests**

Run:

```powershell
dart format lib/core lib/shared/widgets lib/features/appearance/presentation lib/features/settings/presentation lib/app.dart test/appearance
flutter test test/appearance/app_theme_test.dart test/appearance/appearance_page_test.dart test/appearance/app_haptics_test.dart test/settings/theme_controller_test.dart
```

Expected: all focused tests and the V1 theme compatibility test pass.

- [ ] **Step 8: Commit**

```powershell
git add lib/core lib/shared/widgets lib/features/appearance/presentation lib/features/settings/presentation lib/app.dart test/appearance
git commit -m "feat: add personalized v2 appearance UI"
```

## Task 7: Replace Page-Owned Shells with Customizable Adaptive Navigation

**Files:**
- Create: `lib/features/navigation/domain/app_module.dart`
- Create: `lib/features/navigation/application/navigation_controller.dart`
- Create: `lib/features/navigation/presentation/adaptive_app_shell.dart`
- Create: `lib/features/navigation/presentation/rounded_icon_navigation.dart`
- Create: `lib/features/navigation/presentation/placeholder_module_page.dart`
- Create: `lib/features/appearance/presentation/navigation_settings_section.dart`
- Modify: `lib/features/appearance/application/appearance_controller.dart`
- Modify: `lib/features/appearance/domain/device_appearance_profile.dart`
- Modify: `lib/shared/widgets/app_shell.dart`
- Modify: `lib/core/routing/app_routes.dart`
- Modify: `lib/app.dart`
- Modify: `lib/features/notes/presentation/notes_page.dart`
- Modify: `lib/features/settings/presentation/settings_page.dart`
- Create: `test/navigation/navigation_controller_test.dart`
- Create: `test/navigation/adaptive_app_shell_test.dart`

**Interfaces:**
- Produces `AppModuleKey` values `today`, `calendar`, `habits`, `notes`, `statistics`, `settings`, and `more`.
- Produces platform catalogs: Android `[today, calendar, habits, notes, more]`; Windows `[today, calendar, habits, notes, statistics, settings]`.
- Produces `NavigationController.select`, `reorder`, `setHidden`, and `setStartModule`.
- Makes `AdaptiveAppShell` the single routed application shell.

- [x] **Step 1: Write failing navigation invariant tests**

```dart
test('today cannot be hidden and start module must remain visible', () async {
  await controller.setHidden(AppModuleKey.today, true);
  expect(controller.state.hidden, isNot(contains(AppModuleKey.today)));

  await controller.setHidden(AppModuleKey.notes, true);
  await controller.setStartModule(AppModuleKey.notes);
  expect(controller.state.startModule, AppModuleKey.today);
});
```

Widget assertions on a 390×844 surface:

```dart
final navigationBar = tester.widget<NavigationBar>(find.byType(NavigationBar));
expect(
  navigationBar.labelBehavior,
  NavigationDestinationLabelBehavior.alwaysHide,
);
expect(find.bySemanticsLabel('日历'), findsOneWidget);
expect(tester.getSize(find.byKey(const Key('nav-today'))).height, greaterThanOrEqualTo(48));
```

Widget assertions on a 1280×800 surface:

```dart
expect(find.byType(NavigationRail), findsOneWidget);
expect(find.byKey(const Key('windows-functional-rail')), findsOneWidget);
```

- [x] **Step 2: Run focused tests and verify the red state**

Run:

```powershell
flutter test test/navigation/navigation_controller_test.dart test/navigation/adaptive_app_shell_test.dart
```

Expected: FAIL because navigation remains hard-coded in the old `AppShell`.

- [x] **Step 3: Define the module catalog**

```dart
enum AppModuleKey {
  today,
  calendar,
  habits,
  notes,
  statistics,
  settings,
  more,
}

final class AppModuleDescriptor {
  const AppModuleDescriptor({
    required this.key,
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final AppModuleKey key;
  final String label;
  final IconData icon;
  final IconData selectedIcon;
}
```

Use Phosphor rounded-weight equivalents through `PhosphorIcons.regular` and `PhosphorIcons.fill`. The bottom bar passes labels only to semantics and tooltips, never to a persistent `Text` widget.

- [x] **Step 4: Implement controller invariants**

Normalize every saved profile:

```dart
NavigationState normalize(NavigationState input, List<AppModuleKey> catalog) {
  final order = <AppModuleKey>[
    ...input.order.where(catalog.contains),
    ...catalog.where((key) => !input.order.contains(key)),
  ];
  final hidden = {...input.hidden}..remove(AppModuleKey.today);
  final visible = order.where((key) => !hidden.contains(key)).toSet();
  final start = visible.contains(input.startModule)
      ? input.startModule
      : AppModuleKey.today;
  return input.copyWith(order: order, hidden: hidden, startModule: start);
}
```

Persist changes through `AppearanceController.setNavigation`. Windows and Android load separate profiles using `Platform.operatingSystem`.

Add this method to `AppearanceController` in this task, after `AppModuleKey` exists:

```dart
Future<void> setNavigation({
  required List<AppModuleKey> order,
  required Set<AppModuleKey> hidden,
  required AppModuleKey startModule,
});
```

- [x] **Step 5: Implement the single adaptive shell**

`SimpleNoteApp` uses:

```dart
MaterialApp(
  title: '简记',
  debugShowCheckedModeBanner: false,
  theme: theme,
  darkTheme: darkTheme,
  home: const AdaptiveAppShell(),
  onGenerateRoute: AppRoutes.onGenerateRoute,
)
```

`AdaptiveAppShell` watches navigation and appearance state, wraps the selected body in `AppBackground`, uses a frosted Windows rail above 920 logical pixels, and uses the icon-only bottom bar below that breakpoint. It hosts module bodies in an `IndexedStack` so selection does not discard editor state.

`today` initially uses a `PlaceholderModulePage` until Task 10 supplies `TasksPage`. `calendar`, `habits`, and `statistics` display explicit phase ownership. `more` lists Appearance, Settings, and the sync upgrade notice.

`AppRoutes.home` and the legacy `/todos` route both resolve to the single shell with `today` selected; remove the direct `TodosPage` import here. Keep named routes for notes and settings only as compatibility redirects that select the corresponding shell module.

Remove `AppShell` wrapping from `NotesPage` and `SettingsPage`; keep `lib/shared/widgets/app_shell.dart` as a deprecated forwarding export for one task so intermediate commits compile, then remove it in Task 10.

- [x] **Step 6: Implement the navigation editor**

The editor:

- Shows the platform catalog in saved order.
- Disables the hide control for `today`.
- Uses `ReorderableListView` for visible and hidden entries.
- Restores hidden entries without resetting their saved order.
- Requires a new visible default before hiding the current start module.
- Exposes keys `nav-editor-<module>`, `nav-hide-<module>`, and `nav-default-<module>`.

- [x] **Step 7: Run focused tests**

Run:

```powershell
dart format lib/features/navigation lib/features/appearance/presentation/navigation_settings_section.dart lib/shared/widgets lib/core/routing lib/app.dart lib/features/notes/presentation lib/features/settings/presentation test/navigation
flutter test test/navigation/navigation_controller_test.dart test/navigation/adaptive_app_shell_test.dart test/widget_test.dart
```

Expected: focused tests pass; update `test/widget_test.dart` expectations from text navigation to semantic icon navigation so the existing suite passes.

- [ ] **Step 8: Commit**

```powershell
git add lib/features/navigation lib/features/appearance/presentation/navigation_settings_section.dart lib/shared/widgets lib/core/routing lib/app.dart lib/features/notes/presentation lib/features/settings/presentation test/navigation test/widget_test.dart
git commit -m "feat: add adaptive customizable navigation"
```

## Task 8: Implement V2 Task Domain Models, Queries, and Repository

**Files:**
- Create: `lib/features/tasks/domain/task.dart`
- Create: `lib/features/tasks/domain/task_list.dart`
- Create: `lib/features/tasks/domain/task_tag.dart`
- Create: `lib/features/tasks/domain/smart_filter.dart`
- Create: `lib/features/tasks/domain/task_query.dart`
- Create: `lib/features/tasks/data/tasks_repository.dart`
- Modify: `lib/database/daos/tasks_v2_dao.dart`
- Modify: `lib/database/daos/task_taxonomy_dao.dart`
- Create: `test/tasks/task_domain_test.dart`
- Create: `test/tasks/tasks_repository_test.dart`

**Interfaces:**
- Produces `TaskPriority { none, low, medium, high }`.
- Produces `Task`, `TaskList`, `TaskTag`, `SmartFilter`, `TaskFilterRules`, `TaskQuery`, and `TaskSortMode`.
- Produces `TasksRepository.queryTasks`, `searchTasks(query, {sortMode, includeCompleted})`, `findTask`, `upsertTask`, `softDeleteTask`, `replaceTaskTags`, and taxonomy CRUD.
- Enforces only one subtask level.

- [x] **Step 1: Write failing domain and repository tests**

Domain JSON assertions:

```dart
final restored = Task.fromJson(task.toJson());
expect(restored.priority, TaskPriority.high);
expect(restored.descriptionMarkdown, '# Plan');
expect(restored.parentId, isNull);
```

Repository assertions:

```dart
expect((await repository.queryTasks(TaskQuery.inbox())).map((task) => task.id), ['inbox']);
expect(
  (await repository.queryTasks(TaskQuery.today(dayStart: 1000, nextDayStart: 2000)))
      .map((task) => task.id),
  containsAll(['overdue', 'today']),
);
expect(
  (await repository.searchTasks('release')).map((task) => task.id),
  containsAll(['title-match', 'body-match', 'list-match', 'tag-match']),
);
await expectLater(
  repository.upsertTask(grandchild),
  throwsA(isA<StateError>()),
);
```

- [x] **Step 2: Run focused tests and verify the red state**

Run:

```powershell
flutter test test/tasks/task_domain_test.dart test/tasks/tasks_repository_test.dart
```

Expected: FAIL because V2 task domain and repository files do not exist.

- [x] **Step 3: Implement the exact Task contract**

```dart
enum TaskPriority { none, low, medium, high }
enum TaskSortMode { manual, dueAt, priority, createdAt }

class Task implements Syncable {
  const Task({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    required this.deviceId,
    this.parentId,
    this.listId,
    this.descriptionMarkdown = '',
    this.completed = false,
    this.priority = TaskPriority.none,
    this.startAt,
    this.dueAt,
    this.allDay = false,
    this.sortOrder = 0,
    this.recurrenceRule,
    this.recurrenceEndAt,
    this.recurrenceCount,
    this.completedAt,
    this.deletedAt,
    this.version = 1,
  });

  @override
  final String id;
  final String? parentId;
  final String? listId;
  final String title;
  final String descriptionMarkdown;
  final bool completed;
  final TaskPriority priority;
  final int? startAt;
  final int? dueAt;
  final bool allDay;
  final int sortOrder;
  final String? recurrenceRule;
  final int? recurrenceEndAt;
  final int? recurrenceCount;
  final int? completedAt;
  @override
  final int createdAt;
  @override
  final int updatedAt;
  @override
  final int? deletedAt;
  @override
  final String deviceId;
  @override
  final int version;
}
```

Implement complete `toJson`, `fromJson`, and `copyWith`, including explicit clear flags for nullable fields.

- [x] **Step 4: Implement query semantics**

```dart
sealed class TaskQuery {
  const TaskQuery({this.sortMode = TaskSortMode.manual});
  final TaskSortMode sortMode;

  factory TaskQuery.inbox({TaskSortMode sortMode = TaskSortMode.manual}) = InboxTaskQuery;
  factory TaskQuery.today({
    required int dayStart,
    required int nextDayStart,
    TaskSortMode sortMode = TaskSortMode.manual,
  }) = TodayTaskQuery;
  factory TaskQuery.nextSevenDays({
    required int dayStart,
    required int eighthDayStart,
    TaskSortMode sortMode = TaskSortMode.manual,
  }) = NextSevenDaysTaskQuery;
  factory TaskQuery.all({
    bool includeCompleted = false,
    TaskSortMode sortMode = TaskSortMode.manual,
  }) = AllTaskQuery;
  factory TaskQuery.list(String listId, {TaskSortMode sortMode = TaskSortMode.manual}) = ListTaskQuery;
  factory TaskQuery.filter(TaskFilterRules rules, {required TaskSortMode sortMode}) = FilteredTaskQuery;
}
```

Semantics:

- Inbox: unfinished active top-level tasks with `list_id IS NULL`, `start_at IS NULL`, and `due_at IS NULL`.
- Today: unfinished active top-level tasks with `due_at < nextDayStart`; include overdue tasks.
- Next seven days: unfinished active top-level tasks with `due_at >= dayStart AND due_at < eighthDayStart`.
- All: every active top-level task; `includeCompleted` controls whether completed rows appear.
- Custom list: exact `list_id`.
- Smart filter: intersect selected list IDs, tag IDs, completion state, and priorities.
- Search: trim and case-fold the query, escape SQL wildcard characters, and match task title, Markdown body text, custom-list name, or any task-tag name. Return each top-level task once even when multiple tags match, preserve the selected sort mode, and open the matching task directly from results.

- [x] **Step 5: Enforce subtask and transaction rules**

Before writing a task whose `parentId` is non-null:

1. Load the parent.
2. Reject missing or deleted parents.
3. Reject parents whose own `parentId` is non-null.
4. Force the child `listId` to the parent's list ID.

`softDeleteTask` soft-deletes direct children in the same transaction. `replaceTaskTags` rejects tag IDs that are missing or soft-deleted.

- [x] **Step 6: Run focused tests**

Run:

```powershell
dart format lib/features/tasks lib/database/daos test/tasks
flutter test test/tasks/task_domain_test.dart test/tasks/tasks_repository_test.dart test/database/migration_v2_test.dart
```

Expected: all task and migration tests pass.

- [x] **Step 7: Commit**

```powershell
git add lib/features/tasks lib/database/daos test/tasks test/database
git commit -m "feat: add v2 task repository"
```

## Task 9: Implement Task Application State, Smart Sources, Lists, Tags, and Filters

**Files:**
- Create: `lib/features/tasks/application/tasks_controller.dart`
- Create: `test/tasks/tasks_controller_test.dart`

**Interfaces:**
- Produces `tasksControllerProvider`.
- Produces `TasksState` with sources, current query, search text/results, visible tasks, selected task, lists, tags, filters, and save status.
- Produces quick add, search, edit, complete, delete, child task, list, tag, filter, source selection, and sort operations.

- [x] **Step 1: Write the failing controller workflow test**

```dart
await controller.quickAdd('Prepare release');
var state = await container.read(tasksControllerProvider.future);
final taskId = state.tasks.single.id;
expect(state.selectedTaskId, taskId);

await controller.createList('Work', color: const RgbColor(0x4D8BB8), iconKey: 'briefcase');
final listId = (await container.read(tasksControllerProvider.future)).lists.single.id;
await controller.updateListStyle(
  listId,
  color: const RgbColor(0x5E9D83),
  iconKey: 'folder-open',
);
await controller.updateTask(taskId, listId: listId, priority: TaskPriority.high);
await controller.createTag('focus', color: const RgbColor(0x8A6FB0));
final tagId = (await container.read(tasksControllerProvider.future)).tags.single.id;
await controller.updateTag(
  tagId,
  name: 'deep focus',
  color: const RgbColor(0xB66B86),
);
await controller.setTaskTags(taskId, {tagId});
await controller.addSubtask(taskId, 'Write checks');

state = await container.read(tasksControllerProvider.future);
expect(state.selectedTask?.priority, TaskPriority.high);
expect(state.subtasks, hasLength(1));
expect(state.tagIdsFor(taskId), {tagId});
```

Also test quick-add trims input and ignores a blank title, four priority values survive reload, source changes preserve only valid selection, and deleting a list moves its tasks to virtual Inbox by clearing `list_id`.

- [x] **Step 2: Run the focused test and verify the red state**

Run:

```powershell
flutter test test/tasks/tasks_controller_test.dart
```

Expected: FAIL because `TasksController` does not exist.

- [x] **Step 3: Define application state**

```dart
enum TaskSaveStatus { idle, saving, saved, failed }

class TasksState {
  const TasksState({
    required this.tasks,
    required this.lists,
    required this.tags,
    required this.filters,
    required this.tagIdsByTaskId,
    required this.query,
    required this.searchText,
    required this.subtasks,
    this.selectedTaskId,
    this.saveStatus = TaskSaveStatus.idle,
    this.errorMessage,
  });

  final List<Task> tasks;
  final List<TaskList> lists;
  final List<TaskTag> tags;
  final List<SmartFilter> filters;
  final Map<String, Set<String>> tagIdsByTaskId;
  final TaskQuery query;
  final String searchText;
  final List<Task> subtasks;
  final String? selectedTaskId;
  final TaskSaveStatus saveStatus;
  final String? errorMessage;

  Task? get selectedTask {
    for (final task in tasks) {
      if (task.id == selectedTaskId) {
        return task;
      }
    }
    return null;
  }

  Set<String> tagIdsFor(String taskId) =>
      tagIdsByTaskId[taskId] ?? const <String>{};
}
```

- [x] **Step 4: Implement exact controller operations**

```dart
Future<void> quickAdd(String title);
Future<void> updateTask(
  String id, {
  String? title,
  String? descriptionMarkdown,
  bool? completed,
  TaskPriority? priority,
  String? listId,
  bool clearListId,
});
Future<void> toggleTask(String id);
Future<void> deleteTask(String id);
Future<void> addSubtask(String parentId, String title);
Future<void> createList(String name, {required RgbColor color, required String iconKey});
Future<void> renameList(String id, String name);
Future<void> updateListStyle(
  String id, {
  required RgbColor color,
  required String iconKey,
});
Future<void> archiveList(String id);
Future<void> deleteList(String id);
Future<void> createTag(String name, {required RgbColor color});
Future<void> updateTag(
  String id, {
  required String name,
  required RgbColor color,
});
Future<void> deleteTag(String id);
Future<void> setTaskTags(String taskId, Set<String> tagIds);
Future<void> saveSmartFilter({
  required String name,
  required TaskFilterRules rules,
  required TaskSortMode sortMode,
});
Future<void> selectQuery(TaskQuery query);
Future<void> setSortMode(TaskSortMode value);
Future<void> setIncludeCompleted(bool value);
Future<void> setSearchText(String value);
void selectTask(String id);
void clearSelection();
```

Every write sets `saveStatus = saving`, commits through the repository, reloads, then sets `saved`. On failure, retain current state and selection, set `failed`, and expose the error string. Use a 350ms debounce for title and Markdown changes in presentation; quick add and toggles save immediately. Search uses a separate 250ms debounce, preserves the last non-search source query, and restores that source when the trimmed search text becomes empty.

- [x] **Step 5: Run the focused test**

Run:

```powershell
dart format lib/features/tasks/application test/tasks
flutter test test/tasks/tasks_controller_test.dart test/tasks/tasks_repository_test.dart
```

Expected: both controller and repository tests pass.

- [x] **Step 6: Commit**

```powershell
git add lib/features/tasks/application test/tasks
git commit -m "feat: add task sources and application workflows"
```

## Task 10: Build the Windows Four-Zone and Android Task Workspaces

**Files:**
- Create: `lib/features/tasks/presentation/tasks_page.dart`
- Create: `lib/features/tasks/presentation/task_sources_pane.dart`
- Create: `lib/features/tasks/presentation/task_list_pane.dart`
- Create: `lib/features/tasks/presentation/task_detail_pane.dart`
- Create: `lib/features/tasks/presentation/quick_add_task.dart`
- Create: `lib/features/tasks/presentation/task_filter_editor.dart`
- Modify: `lib/features/navigation/presentation/adaptive_app_shell.dart`
- Delete: `lib/features/todos/presentation/todos_page.dart`
- Delete: `lib/shared/widgets/app_shell.dart`
- Modify: `test/widget_test.dart`
- Create: `test/tasks/tasks_page_test.dart`

**Interfaces:**
- Replaces the `today` placeholder with `TasksPage`.
- Produces Windows source/list/detail panes inside the outer functional rail.
- Produces Android source sheet, task list, and full-page detail flow.
- Exposes quick add, search, completed visibility, four priorities, one-level subtasks, editable list/tag styles, filters, sorting, and delete confirmation.

- [x] **Step 1: Write failing responsive task widget tests**

At 1280×800:

```dart
expect(find.byKey(const Key('windows-functional-rail')), findsOneWidget);
expect(find.byKey(const Key('task-sources-pane')), findsOneWidget);
expect(find.byKey(const Key('task-list-pane')), findsOneWidget);
expect(find.byKey(const Key('task-detail-pane')), findsOneWidget);
```

Source-specific controls with seeded custom list `work`:

```dart
await tester.tap(find.byKey(const Key('task-source-all')));
await tester.pumpAndSettle();
expect(find.byKey(const Key('task-include-completed')), findsOneWidget);

await tester.tap(find.byKey(const Key('task-list-source-work')));
await tester.pumpAndSettle();
expect(find.byKey(const Key('task-list-tinted-surface')), findsOneWidget);
```

At 390×844:

```dart
expect(find.byKey(const Key('task-list-pane')), findsOneWidget);
expect(find.byKey(const Key('task-sources-pane')), findsNothing);
await tester.tap(find.byKey(const Key('task-source-button')));
await tester.pumpAndSettle();
expect(find.text('收集箱'), findsOneWidget);
```

Search flow:

```dart
await tester.enterText(find.byKey(const Key('task-search-field')), 'release');
await tester.pump(const Duration(milliseconds: 250));
expect(find.text('Prepare release'), findsOneWidget);
```

Quick-add flow:

```dart
await tester.enterText(find.byKey(const Key('quick-add-task-field')), 'Prepare demo');
await tester.testTextInput.receiveAction(TextInputAction.done);
await tester.pumpAndSettle();
expect(find.text('Prepare demo'), findsWidgets);
```

- [x] **Step 2: Run the focused test and verify the red state**

Run:

```powershell
flutter test test/tasks/tasks_page_test.dart
```

Expected: FAIL because the task presentation files do not exist.

- [x] **Step 3: Implement responsive breakpoints and pane ownership**

Use:

```dart
const compactBreakpoint = 600.0;
const desktopBreakpoint = 920.0;
const fullWorkspaceBreakpoint = 1180.0;
```

At `>= 1180`, render source pane at 248px, list pane at 360px, and the remaining width as detail. The outer functional rail supplied by `AdaptiveAppShell` is the fourth zone. From 920 through 1179, hide the source pane behind a toolbar button. Below 600, show either list or detail; the detail back button clears selection.

Standard density values:

```dart
const taskRowHeight = 56.0;
const panePadding = 16.0;
const paneGap = 12.0;
```

Compact and relaxed values derive from the device profile, but Android touch targets never fall below 48px.

- [x] **Step 4: Implement source, list, and quick-add panes**

Source order:

```text
收集箱
今天
最近 7 天
全部任务
自定义清单
标签
智能筛选
```

Use stable source keys `task-source-inbox`, `task-source-today`, `task-source-next-seven-days`, `task-source-all`, `task-list-source-<id>`, `task-tag-source-<id>`, and `task-filter-source-<id>`.

`QuickAddTask` is a one-line `TextField` with key `quick-add-task-field`, a submit icon, and `TextInputAction.done`. Blank input does not create a row. On successful creation it clears the field and selects the new task.

Place a search field with key `task-search-field` above the task list on Windows and in the task toolbar on Android. Search spans titles, Markdown body text, list names, and task-tag names. Clearing the field returns to the previously selected source without losing a valid detail selection.

Task rows show:

- Circular completion control.
- Title with strike-through only when completed.
- Four-state priority marker using icon plus color.
- Due-date summary when legacy migration supplied a date.
- List and tag chips when space permits.

Selection uses solid accent; hover uses the derived low-tint surface.

When the active query is a custom list, wrap the list content area in a surface keyed `task-list-tinted-surface` whose background is derived from that list's saved color and the global tint-strength setting. Smart sources, tags, and filters use the global neutral surface. The outer background, top bar, navigation, and detail pane remain governed by the global appearance.

- [x] **Step 5: Implement detail, taxonomy, and filter editors**

`TaskDetailPane` exposes stable keys:

```text
task-title-field
task-description-field
task-priority-none
task-priority-low
task-priority-medium
task-priority-high
task-list-picker
task-list-color-picker
task-list-icon-picker
task-tags-picker
task-tag-color-picker
task-add-subtask
task-delete-button
task-save-status
```

Use a plain multiline Markdown field in this task; Task 12 replaces it with the shared editor. Show `保存中`, `已保存`, or `保存失败` from `TaskSaveStatus`. Debounce title and description by 350ms while retaining the active text controller and focus if saving fails.

The `全部任务` source exposes `task-include-completed`; changing it calls `setIncludeCompleted` and preserves the current sort mode. List editing exposes name, one approved or custom color, and a rounded Phosphor icon key. Tag editing exposes name and color. List deletion confirmation states that tasks move to Inbox. Tag deletion confirmation states that task content is unchanged. Smart-filter rules use list, tag, completion, and priority controls; date rules are visible but disabled with the label `时间筛选将在 Phase 2 启用`.

- [x] **Step 6: Add expressive completion animation and haptic feedback**

Use `AnimatedScale` and `AnimatedOpacity` for 340ms when motion is expressive. When `MediaQuery.disableAnimations` is true or motion level is reduced, use only 90ms opacity. Do not remove the row until the animation completes; then reload the active query.

After a completion or confirmed delete commits successfully, call `AppHaptics.trigger` with the matching key-action event. Never emit feedback before the transaction succeeds.

- [x] **Step 7: Run focused and existing widget tests**

Run:

```powershell
dart format lib/features/tasks/presentation lib/features/navigation/presentation test/tasks test/widget_test.dart
flutter test test/tasks/tasks_page_test.dart test/tasks/tasks_controller_test.dart test/widget_test.dart
```

Expected: task page, controller, and updated application widget tests pass.

- [x] **Step 8: Commit**

```powershell
git add lib/features/tasks/presentation lib/features/navigation/presentation lib/features/todos/presentation lib/shared/widgets/app_shell.dart test/tasks test/widget_test.dart
git commit -m "feat: add adaptive v2 task workspace"
```

## Task 11: Implement Transactional Attachment Import, Storage, and Metadata

**Files:**
- Create: `lib/features/attachments/domain/content_attachment.dart`
- Create: `lib/shared/models/markdown_edit.dart`
- Create: `lib/features/attachments/data/attachments_repository.dart`
- Create: `lib/features/attachments/infrastructure/attachment_file_store.dart`
- Create: `lib/features/attachments/infrastructure/attachment_picker.dart`
- Create: `lib/features/attachments/application/attachment_import_service.dart`
- Modify: `lib/database/daos/attachments_dao.dart`
- Create: `test/attachments/attachment_file_store_test.dart`
- Create: `test/attachments/attachment_import_service_test.dart`

**Interfaces:**
- Produces `AttachmentOwnerType { task, note }`, `AttachmentOwner`, and `ContentAttachment`.
- Produces `AttachmentPicker.pick(AttachmentPickSource)` for files, gallery, and camera.
- Produces `AttachmentImportService.importAndAttach` and `deleteAndDetach`.
- Generates original and thumbnail content-addressed files and commits owner Markdown plus metadata in one database transaction.

- [x] **Step 1: Write failing file and transaction tests**

Use a temporary directory, memory database, and 80×40 PNG:

```dart
final result = await service.importAndAttach(
  owner: const AttachmentOwner(AttachmentOwnerType.note, 'note-1'),
  input: MemoryAttachmentInput(
    name: 'photo.png',
    bytes: Uint8List.fromList(img.encodePng(image)),
  ),
  currentMarkdown: 'Before\nAfter',
  selection: const MarkdownSelection(baseOffset: 7, extentOffset: 7),
  altText: 'photo',
);

expect(result.markdown, contains('![photo](attachment://${result.attachment.id})'));
expect((await repository.forOwner(result.attachment.owner)), hasLength(1));
expect(File(result.attachment.absolutePath).existsSync(), isTrue);
expect(File(result.attachment.thumbnailAbsolutePath).existsSync(), isTrue);
```

Inject a repository that throws during commit and assert that no attachment record, Markdown reference, temporary file, original file, or thumbnail remains.

- [x] **Step 2: Run focused tests and verify the red state**

Run:

```powershell
flutter test test/attachments/attachment_file_store_test.dart test/attachments/attachment_import_service_test.dart
```

Expected: FAIL because the attachment module does not exist.

- [x] **Step 3: Define attachment contracts**

```dart
enum AttachmentOwnerType { task, note }
enum AttachmentPickSource { files, gallery, camera }

final class AttachmentOwner {
  const AttachmentOwner(this.type, this.id);
  final AttachmentOwnerType type;
  final String id;
}

abstract interface class AttachmentInput {
  String get name;
  Future<int> length();
  Future<Uint8List> readAsBytes();
}

class XFileAttachmentInput implements AttachmentInput {
  XFileAttachmentInput(this.file);
  final XFile file;

  @override
  String get name => file.name;

  @override
  Future<int> length() => file.length();

  @override
  Future<Uint8List> readAsBytes() => file.readAsBytes();
}
```

`ContentAttachment` contains every approved table field plus computed absolute original and thumbnail paths. JSON serialization omits both local paths.

Define the shared edit result in `lib/shared/models/markdown_edit.dart`:

```dart
final class MarkdownSelection {
  const MarkdownSelection({
    required this.baseOffset,
    required this.extentOffset,
  });

  final int baseOffset;
  final int extentOffset;
}

final class MarkdownEditResult {
  const MarkdownEditResult({
    required this.markdown,
    required this.selection,
  });

  final String markdown;
  final MarkdownSelection selection;
}
```

Define the service result explicitly:

```dart
final class AttachmentImportResult {
  const AttachmentImportResult({
    required this.attachment,
    required this.markdown,
    required this.selection,
  });

  final ContentAttachment attachment;
  final String markdown;
  final MarkdownSelection selection;

  MarkdownEditResult get edit => MarkdownEditResult(
        markdown: markdown,
        selection: selection,
      );
}
```

Controllers return `result.edit` to presentation after reloading the committed owner.

- [x] **Step 4: Implement picker behavior**

```dart
Future<XFile?> pick(AttachmentPickSource source) {
  return switch (source) {
    AttachmentPickSource.files => _pickFile(),
    AttachmentPickSource.gallery =>
      imagePicker.pickImage(source: ImageSource.gallery),
    AttachmentPickSource.camera =>
      imagePicker.pickImage(source: ImageSource.camera),
  };
}
```

`_pickFile` calls:

```dart
FilePicker.platform.pickFiles(
  type: FileType.custom,
  allowedExtensions: const ['jpg', 'jpeg', 'png', 'webp'],
  allowMultiple: false,
  withData: false,
);
```

On Android startup, call `ImagePicker.retrieveLostData()` once and route recovered images to a pending-import prompt instead of silently inserting them into whichever editor is open.

- [x] **Step 5: Implement the file store**

Validation and storage:

1. Read `length()` and reject values above 20 MB before reading bytes.
2. Decode bytes and accept only JPEG, PNG, or WebP.
3. Compute SHA-256.
4. Generate a thumbnail whose longest side is at most 720px and encode it as JPEG quality 82.
5. Write original and thumbnail to unique `.tmp` files under `<support>/attachments/tmp`.
6. Flush both files.
7. Atomically rename into `<support>/attachments/content/<sha>.<ext>` and `<sha>.thumb.jpg`.
8. Return a `StagedAttachment` that knows whether each final file pre-existed.

On rollback, remove only files created by the current stage.

- [x] **Step 6: Implement repository transactions**

`commitImport` switches on owner type inside one Drift transaction:

```text
validate owner exists and is not deleted
insert content_attachments row
replace owner Markdown with updated Markdown
increment owner version
set owner updated_at to the supplied timestamp
```

`deleteAndDetach` removes exactly the `attachment://<id>` image node from Markdown and soft-deletes the attachment in the same transaction. It does not physically remove files in Phase 1.

- [x] **Step 7: Run focused tests**

Run:

```powershell
dart format lib/features/attachments lib/database/daos test/attachments
flutter test test/attachments/attachment_file_store_test.dart test/attachments/attachment_import_service_test.dart
```

Expected: file validation, thumbnail creation, transactional commit, and rollback tests pass.

- [x] **Step 8: Commit**

```powershell
git add lib/features/attachments lib/database/daos test/attachments
git commit -m "feat: add transactional content attachments"
```

## Task 12: Build the Shared Markdown Toolbar, Editor, and Attachment Renderer

**Files:**
- Create: `lib/shared/widgets/embedded_markdown_editor.dart`
- Create: `lib/shared/widgets/embedded_markdown_view.dart`
- Create: `lib/features/attachments/presentation/attachment_image.dart`
- Create: `test/attachments/embedded_markdown_editor_test.dart`
- Create: `test/attachments/embedded_markdown_view_test.dart`

**Interfaces:**
- Produces `MarkdownEditingController.wrapSelection` and `insertAtSelection`.
- Produces `EmbeddedMarkdownEditor` with syntax toolbar and image-source menu.
- Produces `EmbeddedMarkdownView` that resolves `attachment://` without storing device absolute paths in Markdown.
- Produces full-screen preview and delete confirmation for embedded images.

- [x] **Step 1: Write failing editor and renderer tests**

Selection insertion:

```dart
controller
  ..text = 'alpha beta'
  ..selection = const TextSelection(baseOffset: 6, extentOffset: 10);
controller.wrapSelection('**', '**');
expect(controller.text, 'alpha **beta**');
expect(controller.selection.baseOffset, 8);
expect(controller.selection.extentOffset, 12);
```

Image flow:

```dart
await tester.tap(find.byKey(const Key('markdown-image-button')));
await tester.tap(find.byKey(const Key('markdown-image-gallery')));
await tester.pumpAndSettle();
expect(onPickSource, AttachmentPickSource.gallery);
```

Rendering:

```dart
expect(find.byKey(const Key('attachment-image-att-1')), findsOneWidget);
await tester.tap(find.byKey(const Key('attachment-image-att-1')));
await tester.pumpAndSettle();
expect(find.byKey(const Key('attachment-fullscreen-att-1')), findsOneWidget);
```

- [x] **Step 2: Run focused tests and verify the red state**

Run:

```powershell
flutter test test/attachments/embedded_markdown_editor_test.dart test/attachments/embedded_markdown_view_test.dart
```

Expected: FAIL because the shared Markdown widgets do not exist.

- [x] **Step 3: Implement toolbar editing operations**

Toolbar operations:

```text
heading: prefix "# "
bold: wrap "**"
italic: wrap "*"
unordered list: prefix "- "
task list: prefix "- [ ] "
quote: prefix "> "
inline code: wrap "`"
code block: wrap "```\n" and "\n```"
link: wrap "[" and "](https://)"
image: open source menu
```

Exact public widget API:

```dart
class EmbeddedMarkdownEditor extends StatefulWidget {
  const EmbeddedMarkdownEditor({
    required this.initialValue,
    required this.onChanged,
    required this.onInsertImage,
    required this.textStyle,
    super.key,
  });

  final String initialValue;
  final ValueChanged<String> onChanged;
  final Future<MarkdownEditResult?> Function(
    AttachmentPickSource source,
    MarkdownSelection selection,
    {required String altText},
  ) onInsertImage;
  final TextStyle textStyle;
}
```

The image menu includes a compact alt-text field initialized to `图片`; trim it and fall back to `图片` when blank. Pass it to `onInsertImage`. When the callback returns a result, replace editor text and restore the returned selection. When the user cancels, do not mutate text or selection.

- [x] **Step 4: Implement attachment rendering**

`EmbeddedMarkdownView` passes:

```dart
imageBuilder: (uri, title, alt) {
  if (uri.scheme != 'attachment') {
    return const _UnsupportedRemoteImage();
  }
  final id = uri.host.isNotEmpty ? uri.host : uri.path;
  return AttachmentImage(
    key: Key('attachment-image-$id'),
    attachmentId: id,
    altText: alt ?? '图片',
    onDelete: onDeleteAttachment,
  );
}
```

`AttachmentImage`:

- Loads thumbnail first.
- Shows a recognizable missing-file placeholder on resolver failure.
- Opens the original in a full-screen dialog on tap.
- Uses `InteractiveViewer` for zoom and pan.
- Shows delete only when an `onDelete` callback is supplied.
- Requires confirmation text `从正文中删除这张图片？`.

- [x] **Step 5: Run focused tests**

Run:

```powershell
dart format lib/shared/widgets lib/features/attachments/presentation test/attachments
flutter test test/attachments/embedded_markdown_editor_test.dart test/attachments/embedded_markdown_view_test.dart
```

Expected: selection, toolbar, insertion, preview, missing-file, and delete-confirmation tests pass.

- [x] **Step 6: Commit**

```powershell
git add lib/shared/widgets lib/features/attachments/presentation test/attachments
git commit -m "feat: add inline markdown image editor"
```

## Task 13: Integrate Inline Images into Notes and Tasks

**Files:**
- Modify: `lib/features/notes/application/notes_controller.dart`
- Modify: `lib/features/notes/data/notes_repository.dart`
- Modify: `lib/features/notes/presentation/notes_page.dart`
- Modify: `lib/features/tasks/application/tasks_controller.dart`
- Modify: `lib/features/tasks/presentation/task_detail_pane.dart`
- Modify: `lib/main.dart`
- Modify: `test/notes/notes_controller_test.dart`
- Modify: `test/tasks/tasks_controller_test.dart`
- Create: `test/notes/note_inline_image_test.dart`
- Create: `test/tasks/task_inline_image_test.dart`

**Interfaces:**
- Produces `NotesController.insertImage`, `deleteImage`, and debounced save status.
- Produces matching task controller operations.
- Keeps note `createdAt` immutable while image insertion changes `updatedAt`.
- Surfaces file, Android gallery, and Android camera options in both editors.

- [x] **Step 1: Write failing controller integration tests**

Note assertions:

```dart
final before = state.selectedNote!;
await controller.insertImage(
  AttachmentPickSource.files,
  const MarkdownSelection(baseOffset: 0, extentOffset: 0),
  altText: 'diagram',
);
final after = (await container.read(notesControllerProvider.future)).selectedNote!;
expect(after.content, matches(r'!\[diagram\]\(attachment://[^)]+\)'));
expect(after.createdAt, before.createdAt);
expect(after.updatedAt, greaterThanOrEqualTo(before.updatedAt));
```

Task assertions mirror the note test but verify `descriptionMarkdown`.

Add cancellation tests where the picker returns null and neither Markdown nor timestamps change.

- [x] **Step 2: Run focused tests and verify the red state**

Run:

```powershell
flutter test test/notes/note_inline_image_test.dart test/tasks/task_inline_image_test.dart
```

Expected: FAIL because controllers do not expose image operations.

- [x] **Step 3: Integrate service calls into controllers**

Exact signatures:

```dart
Future<MarkdownEditResult?> insertImage(
  AttachmentPickSource source,
  MarkdownSelection selection, {
  required String altText,
});

Future<void> deleteImage(String attachmentId);
```

Flow:

1. Read the selected note or task.
2. Ask `AttachmentPicker` for the selected source.
3. Return without state changes when picker result is null.
4. Set save status to saving.
5. Call `AttachmentImportService.importAndAttach`.
6. Reload the selected owner, mark saved, and return `result.edit`.
7. On error, retain editor text and focus, mark failed, and expose a retryable message.

Use provider overrides in tests for fake picker, file store root, and deterministic clock.

- [x] **Step 4: Replace both raw Markdown fields with shared widgets**

For notes:

```dart
EmbeddedMarkdownEditor(
  key: const Key('note-content-field'),
  initialValue: note.content,
  textStyle: noteBodyStyle,
  onChanged: onContentChanged,
  onInsertImage: onInsertImage,
)
```

For task descriptions, use the same widget with key `task-description-field`. Both preview modes use `EmbeddedMarkdownView`. Keep current tag controls and note search behavior unchanged.

Show file source on Windows. On Android show files, gallery, and camera. If the app starts with `retrieveLostData()` results, display a non-blocking prompt that lets the user choose the target currently-open note or task; do not auto-attach.

- [x] **Step 5: Verify created-date invariance and widget flows**

Run:

```powershell
dart format lib/features/notes lib/features/tasks lib/main.dart test/notes test/tasks
flutter test test/notes/notes_controller_test.dart test/notes/note_inline_image_test.dart test/tasks/tasks_controller_test.dart test/tasks/task_inline_image_test.dart test/widget_test.dart
```

Expected: note and task controller tests, image integrations, and main widget flows pass.

- [x] **Step 6: Commit**

```powershell
git add lib/features/notes lib/features/tasks lib/main.dart test/notes test/tasks test/widget_test.dart
git commit -m "feat: add inline images to notes and tasks"
```

## Task 14: Disable V1 Sync Entry, Run Full Regression, and Record Phase 1 Acceptance

**Files:**
- Modify: `lib/features/sync/application/sync_controller.dart`
- Create: `lib/features/sync/presentation/sync_upgrade_notice.dart`
- Modify: `lib/features/settings/presentation/settings_page.dart`
- Modify: `lib/features/navigation/presentation/adaptive_app_shell.dart`
- Modify: `test/sync/sync_controller_test.dart`
- Modify: `test/sync/sync_http_test.dart`
- Modify: `test/widget_test.dart`
- Modify: `README.md`
- Create: `docs/V2_PHASE_1_ACCEPTANCE.md`

**Interfaces:**
- Produces `legacySyncEnabledProvider`, defaulting to false in the application.
- Keeps V1 sync implementation testable only through explicit test override.
- Shows a clear Phase 4 upgrade notice instead of start-server and sync buttons.
- Produces a verified Phase 1 acceptance record.

- [x] **Step 1: Write the failing production guard and widget tests**

Controller assertion:

```dart
final container = ProviderContainer();
addTearDown(container.dispose);
final controller = container.read(syncControllerProvider.notifier);
await controller.startServer();
expect(container.read(syncControllerProvider).status, SyncStatus.error);
expect(
  container.read(syncControllerProvider).errorMessage,
  contains('V2 同步将在 Phase 4 启用'),
);
```

Widget assertion:

```dart
expect(find.byKey(const Key('sync-upgrade-notice')), findsOneWidget);
expect(find.byKey(const Key('sync-start-server-button')), findsNothing);
expect(find.byKey(const Key('sync-now-button')), findsNothing);
```

- [x] **Step 2: Run focused tests and verify the red state**

Run:

```powershell
flutter test test/sync/sync_controller_test.dart test/widget_test.dart
```

Expected: FAIL because production still exposes V1 sync controls.

- [x] **Step 3: Add the explicit V1 sync guard**

```dart
final legacySyncEnabledProvider = Provider<bool>((ref) => false);
```

Inject the value into `SyncController`. At the start of `startServer` and `syncWithPeer`, when false:

```dart
state = state.copyWith(
  status: SyncStatus.error,
  errorMessage: 'V2 同步将在 Phase 4 启用；当前版本不会启动旧同步协议。',
);
return;
```

Override `legacySyncEnabledProvider` to true only in existing V1 HTTP and merge tests so compatibility code remains covered.

- [x] **Step 4: Replace sync controls with the upgrade notice**

`SyncUpgradeNotice` uses key `sync-upgrade-notice` and states:

```text
局域网同步正在升级
V2 任务、外观和正文图片不能由旧协议安全识别。Phase 4 完成前，
本版本不会开启旧同步服务；所有本地功能仍可离线使用。
```

Do not render peer address, start, stop, or sync buttons in production.

- [x] **Step 5: Update documentation and acceptance matrix**

`docs/V2_PHASE_1_ACCEPTANCE.md` records:

```text
Database migration and backup
Appearance presets and custom inputs
Platform-local density/navigation/crop
Windows four-zone workspace
Android icon-only navigation
Task search/lists/tags/filters/subtasks/priorities
Note and task inline images
Missing-image and failed-import recovery
V1 sync production guard
Accessibility and reduced motion
Windows debug build
Android debug APK build
```

For each row, record the exact automated command or manual device check and its result.

- [x] **Step 6: Run the complete verification suite**

Run:

```powershell
dart format --output=none --set-exit-if-changed lib test
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
flutter build windows --debug
flutter build apk --debug
```

Expected:

```text
formatter exits 0
build_runner exits 0 with no conflicting outputs
flutter analyze reports No issues found
flutter test reports all tests passed
Windows debug build succeeds
Android debug APK build succeeds
```

- [x] **Step 7: Perform manual smoke checks**

Windows:

1. Launch with a copy of a V1 database and confirm a backup appears before migration.
2. Confirm migrated tasks keep title, Markdown description, completion, due date, priority, and ID.
3. Verify four-zone task layout at 1280×800 and collapsed panes below 1180.
4. Import a PNG into a task and a note, preview full-screen, delete one, and restart.
5. Change background, focus, zoom, blur, font, density, navigation order, and default module; restart and confirm persistence.
6. Search by task title, Markdown body text, list name, and tag name; clear search and confirm the previous source returns.

Android:

1. Confirm icon-only bottom navigation, 48dp targets, and `today` cannot be hidden.
2. Insert one gallery image and one camera image into different owners.
3. Enable system reduced motion and confirm completion uses a short fade.
4. Confirm default haptics produce no vibration.
5. Restart during an image-picker round trip and confirm recovered media prompts for a target.

- [x] **Step 8: Commit**

```powershell
git add lib/features/sync lib/features/settings lib/features/navigation test/sync test/widget_test.dart README.md docs/V2_PHASE_1_ACCEPTANCE.md
git commit -m "chore: verify v2 phase one"
```

---

## Phase 1 Completion Gate

Phase 1 is complete only when:

- All fourteen task commits exist and each focused test was observed failing before its implementation.
- `tasks_v2` is the only task store used by routed UI.
- V1 database backup and migration tests pass without altering legacy tables.
- Windows and Android pass their responsive shell and navigation widget tests.
- Appearance settings persist with correct portable/device-local boundaries.
- Notes and tasks both insert, render, preview, and transactionally delete inline images.
- Production cannot start V1 sync.
- `flutter analyze`, `flutter test`, Windows debug build, and Android debug build all exit successfully.
- The acceptance record contains no unresolved failures.
