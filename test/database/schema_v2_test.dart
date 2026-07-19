import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_note/database/app_database.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

void main() {
  test('schema v4 creates phase one, reminder, and habit tables', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    await database.open();

    expect(database.schemaVersion, 4);

    final rows = await database
        .customSelect("SELECT name FROM sqlite_master WHERE type = 'table'")
        .get();
    final names = rows.map((row) => row.read<String>('name')).toSet();

    expect(
      names,
      containsAll({
        'task_lists',
        'tasks_v2',
        'task_completions',
        'task_reminders',
        'task_tags',
        'task_tag_links',
        'smart_filters',
        'content_attachments',
        'custom_colors',
        'background_images',
        'device_appearance_profiles',
        'habits',
        'habit_checkins',
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
        'task_completions_task_active',
        'task_reminders_task_active',
        'habits_active_order',
        'habit_checkins_active_day',
        'habit_checkins_day_active',
      }),
    );
  });

  test('schema v4 accepts legal check-constraint boundary values', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    await database.open();

    await database.customStatement(
      'INSERT INTO tasks_v2 '
      '(id, title, priority, created_at, updated_at, device_id) '
      "VALUES ('priority-min', 'Min', 0, 1, 1, 'device')",
    );
    await database.customStatement(
      'INSERT INTO tasks_v2 '
      '(id, title, priority, created_at, updated_at, device_id) '
      "VALUES ('priority-max', 'Max', 3, 1, 1, 'device')",
    );
    await database.customStatement(_reminderInsert('absolute', 100, null));
    await database.customStatement(_reminderInsert('relative', null, -30));
    await database.customStatement(_attachmentInsert('owner-task', 'task'));
    await database.customStatement(_attachmentInsert('owner-note', 'note'));
    await database.customStatement(_colorInsert('rgb-min', 0));
    await database.customStatement(_colorInsert('rgb-max', 0xFFFFFF));
    await database.customStatement(_habitInsert(
      'habit-min',
      name: 'Habit min',
      color: 0,
      scheduleType: 'daily',
      archived: 0,
    ));
    await database.customStatement(_habitInsert(
      'habit-max',
      name: 'Habit max',
      color: 0xFFFFFF,
      scheduleType: 'interval',
      archived: 1,
    ));
    await database.customStatement(_checkinInsert(
      'checkin',
      habitId: 'habit-min',
      day: 1000,
      status: 'done',
    ));
    await database.customStatement(
      _profileInsert(
        'legal-profile',
        focusX: 0,
        focusY: 1,
        zoom: 0.1,
        blur: 0,
      ),
    );
  });

  test('schema v4 rejects only check-constraint violations', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    await database.open();

    await _expectCheckFailure(
      database,
      'INSERT INTO tasks_v2 '
      '(id, title, priority, created_at, updated_at, device_id) '
      "VALUES ('priority-low', 'Bad', -1, 1, 1, 'device')",
    );
    await _expectCheckFailure(
      database,
      'INSERT INTO tasks_v2 '
      '(id, title, priority, created_at, updated_at, device_id) '
      "VALUES ('priority-high', 'Bad', 4, 1, 1, 'device')",
    );
    await _expectCheckFailure(
      database,
      _reminderInsert('missing-trigger', null, null),
    );
    await _expectCheckFailure(
      database,
      _reminderInsert('two-triggers', 100, -10),
    );
    await _expectCheckFailure(
      database,
      _attachmentInsert('owner-invalid', 'habit'),
    );
    await _expectCheckFailure(database, _colorInsert('rgb-low', -1));
    await _expectCheckFailure(database, _colorInsert('rgb-high', 0x1000000));
    await _expectCheckFailure(
      database,
      _habitInsert(
        'habit-empty-name',
        name: '   ',
        color: 1,
        scheduleType: 'daily',
        archived: 0,
      ),
    );
    await _expectCheckFailure(
      database,
      _habitInsert(
        'habit-low-color',
        name: 'Habit',
        color: -1,
        scheduleType: 'daily',
        archived: 0,
      ),
    );
    await _expectCheckFailure(
      database,
      _habitInsert(
        'habit-high-color',
        name: 'Habit',
        color: 0x1000000,
        scheduleType: 'daily',
        archived: 0,
      ),
    );
    await _expectCheckFailure(
      database,
      _habitInsert(
        'habit-bad-schedule',
        name: 'Habit',
        color: 1,
        scheduleType: 'monthly',
        archived: 0,
      ),
    );
    await _expectCheckFailure(
      database,
      _habitInsert(
        'habit-bad-archive',
        name: 'Habit',
        color: 1,
        scheduleType: 'daily',
        archived: 2,
      ),
    );
    await _expectCheckFailure(
      database,
      _checkinInsert(
        'bad-checkin',
        habitId: 'habit',
        day: 1000,
        status: 'skipped',
      ),
    );
    await _expectCheckFailure(
      database,
      _profileInsert(
        'focus-x-low',
        focusX: -0.1,
        focusY: 0.5,
        zoom: 1,
        blur: 0,
      ),
    );
    await _expectCheckFailure(
      database,
      _profileInsert(
        'focus-y-high',
        focusX: 0.5,
        focusY: 1.1,
        zoom: 1,
        blur: 0,
      ),
    );
    await _expectCheckFailure(
      database,
      _profileInsert(
        'zoom-zero',
        focusX: 0.5,
        focusY: 0.5,
        zoom: 0,
        blur: 0,
      ),
    );
    await _expectCheckFailure(
      database,
      _profileInsert(
        'blur-negative',
        focusX: 0.5,
        focusY: 0.5,
        zoom: 1,
        blur: -0.1,
      ),
    );
  });

  test('schema v4 permits one active checkin per habit and day', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    await database.open();

    await database.customStatement(_habitInsert(
      'habit',
      name: 'Habit',
      color: 1,
      scheduleType: 'daily',
      archived: 0,
    ));
    await database.customStatement(_checkinInsert(
      'first',
      habitId: 'habit',
      day: 1000,
      status: 'done',
    ));

    await expectLater(
      database.customStatement(_checkinInsert(
        'duplicate',
        habitId: 'habit',
        day: 1000,
        status: 'done',
      )),
      throwsA(isA<sqlite.SqliteException>()),
    );

    await database.customStatement(
      "UPDATE habit_checkins SET deleted_at = 2000 WHERE id = 'first'",
    );
    await database.customStatement(_checkinInsert(
      'second',
      habitId: 'habit',
      day: 1000,
      status: 'done',
    ));
  });
}

Future<void> _expectCheckFailure(
  AppDatabase database,
  String statement,
) async {
  await expectLater(
    database.customStatement(statement),
    throwsA(
      isA<sqlite.SqliteException>()
          .having((error) => error.resultCode, 'resultCode', 19)
          .having(
            (error) => error.message,
            'message',
            contains('CHECK constraint failed'),
          ),
    ),
  );
}

String _attachmentInsert(String id, String ownerType) {
  return 'INSERT INTO content_attachments '
      '(id, owner_type, owner_id, sha256, mime_type, byte_size, width, '
      'height, relative_path, thumbnail_relative_path, sort_order, '
      'created_at, updated_at, device_id, version) '
      "VALUES ('$id', '$ownerType', 'owner', 'sha-$id', 'image/png', "
      "1, 1, 1, '$id', '$id-thumb', 0, 1, 1, 'device', 1)";
}

String _reminderInsert(String id, int? triggerAt, int? offsetMinutes) {
  return 'INSERT INTO task_reminders '
      '(id, task_id, trigger_at, offset_minutes, created_at, updated_at, '
      'device_id, version) '
      "VALUES ('$id', 'task', ${_sqlInt(triggerAt)}, "
      "${_sqlInt(offsetMinutes)}, 1, 1, 'device', 1)";
}

String _sqlInt(int? value) => value == null ? 'NULL' : '$value';

String _colorInsert(String id, int rgb) {
  return 'INSERT INTO custom_colors '
      '(id, name, rgb, sort_order, created_at, updated_at, device_id) '
      "VALUES ('$id', '$id', $rgb, 0, 1, 1, 'device')";
}

String _habitInsert(
  String id, {
  required String name,
  required int color,
  required String scheduleType,
  required int archived,
}) {
  return 'INSERT INTO habits '
      '(id, name, prompt, icon_key, color, schedule_type, schedule_json, '
      'sort_order, archived, created_at, updated_at, device_id, version) '
      "VALUES ('$id', '$name', '', 'book', $color, '$scheduleType', "
      "'{}', 0, $archived, 1, 1, 'device', 1)";
}

String _checkinInsert(
  String id, {
  required String habitId,
  required int day,
  required String status,
}) {
  return 'INSERT INTO habit_checkins '
      '(id, habit_id, checkin_day, status, note, created_at, updated_at, '
      'device_id, version) '
      "VALUES ('$id', '$habitId', $day, '$status', '', 1, 1, 'device', 1)";
}

String _profileInsert(
  String id, {
  required double focusX,
  required double focusY,
  required double zoom,
  required double blur,
}) {
  return 'INSERT INTO device_appearance_profiles '
      '(id, platform, density, nav_order_json, hidden_nav_json, '
      'start_module, background_focus_x, background_focus_y, '
      'background_zoom, background_blur, background_overlay, '
      'haptics_mode, updated_at) '
      "VALUES ('$id', 'windows', 'standard', '[]', '[]', 'today', "
      "$focusX, $focusY, $zoom, $blur, 0.0, 'off', 1)";
}
