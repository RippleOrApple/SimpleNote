import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_note/database/app_database.dart';

void main() {
  test('schema v2 creates every phase one table', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    await database.open();

    expect(database.schemaVersion, 2);

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

    final indexRows = await database
        .customSelect("SELECT name FROM sqlite_master WHERE type = 'index'")
        .get();
    final indexNames = indexRows.map((row) => row.read<String>('name')).toSet();
    expect(
      indexNames,
      containsAll({
        'custom_colors_rgb_active',
        'content_attachments_owner_active',
        'tasks_v2_due_active',
      }),
    );

    await expectLater(
      database.customStatement(
        'INSERT INTO content_attachments '
        '(id, owner_type, owner_id, sha256, mime_type, byte_size, width, '
        'height, relative_path, thumbnail_relative_path, sort_order, '
        'created_at, updated_at, device_id, version) '
        "VALUES ('bad', 'habit', 'h1', 'sha', 'image/png', 1, 1, 1, "
        "'a', 'b', 0, 1, 1, 'device', 1)",
      ),
      throwsA(anything),
    );
  });

  test('schema v2 enforces phase one value checks', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    await database.open();

    Future<void> expectRejected(String statement) async {
      await expectLater(database.customStatement(statement), throwsA(anything));
    }

    await expectRejected(
      'INSERT INTO tasks_v2 '
      '(id, title, priority, created_at, updated_at, device_id) '
      "VALUES ('bad-priority', 'Bad', 4, 1, 1, 'device')",
    );
    await expectRejected(
      'INSERT INTO custom_colors '
      '(id, name, rgb, sort_order, created_at, updated_at, device_id) '
      "VALUES ('bad-rgb', 'Bad', 16777216, 0, 1, 1, 'device')",
    );
    await expectRejected(
      'INSERT INTO device_appearance_profiles '
      '(id, platform, density, nav_order_json, hidden_nav_json, '
      'start_module, background_focus_x, background_focus_y, '
      'background_zoom, background_blur, background_overlay, '
      'haptics_mode, updated_at) '
      "VALUES ('bad-focus', 'windows', 'standard', '[]', '[]', 'today', "
      "1.1, 0.5, 1.0, 0.0, 0.0, 'off', 1)",
    );
    await expectRejected(
      'INSERT INTO device_appearance_profiles '
      '(id, platform, density, nav_order_json, hidden_nav_json, '
      'start_module, background_focus_x, background_focus_y, '
      'background_zoom, background_blur, background_overlay, '
      'haptics_mode, updated_at) '
      "VALUES ('bad-zoom', 'windows', 'standard', '[]', '[]', 'today', "
      "0.5, 0.5, 0.0, 0.0, 0.0, 'off', 1)",
    );
    await expectRejected(
      'INSERT INTO device_appearance_profiles '
      '(id, platform, density, nav_order_json, hidden_nav_json, '
      'start_module, background_focus_x, background_focus_y, '
      'background_zoom, background_blur, background_overlay, '
      'haptics_mode, updated_at) '
      "VALUES ('bad-blur', 'windows', 'standard', '[]', '[]', 'today', "
      "0.5, 0.5, 1.0, -0.1, 0.0, 'off', 1)",
    );
  });
}
