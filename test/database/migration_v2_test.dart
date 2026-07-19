import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:simple_note/core/constants/app_constants.dart';
import 'package:simple_note/database/app_database.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('production open backs up schema 1 and migrates a todo once', () async {
    final supportDirectory =
        await Directory.systemTemp.createTemp('simple_note_v2_migration_');
    addTearDown(() => supportDirectory.delete(recursive: true));
    final databaseFile =
        File(p.join(supportDirectory.path, AppConstants.databaseName));
    _seedV1Database(databaseFile);

    _mockApplicationSupportDirectory(supportDirectory.path);

    var database = AppDatabase();
    addTearDown(() async => database.close());
    await database.open();

    final migrated = await database
        .customSelect(
          "SELECT * FROM tasks_v2 WHERE id = 'legacy-task'",
        )
        .getSingle();
    expect(migrated.read<String>('id'), 'legacy-task');
    expect(migrated.read<String>('title'), 'Legacy title');
    expect(
      migrated.read<String>('description_markdown'),
      'legacy body',
    );
    expect(migrated.read<int>('priority'), 3);
    expect(migrated.read<bool>('completed'), isTrue);
    expect(migrated.read<int?>('completed_at'), 200);
    expect(migrated.read<int?>('due_at'), 300);
    expect(migrated.read<String?>('list_id'), isNull);
    expect(migrated.read<int>('created_at'), 100);
    expect(migrated.read<int>('updated_at'), 200);
    expect(migrated.read<int?>('deleted_at'), 150);
    expect(migrated.read<String>('device_id'), 'legacy-device');
    expect(migrated.read<int>('version'), 7);

    final originalTodo = await (database.select(database.todos)
          ..where((todo) => todo.id.equals('legacy-task')))
        .getSingle();
    expect(originalTodo.id, 'legacy-task');
    expect(originalTodo.title, 'Legacy title');
    expect(originalTodo.description, 'legacy body');
    expect(originalTodo.completed, isTrue);
    expect(originalTodo.dueAt, 300);
    expect(originalTodo.priority, 2);
    expect(originalTodo.createdAt, 100);
    expect(originalTodo.updatedAt, 200);
    expect(originalTodo.deletedAt, 150);
    expect(originalTodo.deviceId, 'legacy-device');
    expect(originalTodo.version, 7);

    await database.close();
    database = AppDatabase();
    await database.open();

    final migratedCount = await database
        .customSelect(
          'SELECT COUNT(*) AS count FROM tasks_v2 '
          "WHERE id = 'legacy-task'",
        )
        .getSingle();
    expect(migratedCount.read<int>('count'), 1);

    final backupDirectory = Directory(p.join(supportDirectory.path, 'backups'));
    final backupFiles = backupDirectory
        .listSync()
        .whereType<File>()
        .where(
          (file) => p.basename(file.path).startsWith('simple_note.pre-v2.'),
        )
        .toList();
    expect(backupFiles, hasLength(1));

    final backup = sqlite.sqlite3.open(
      backupFiles.single.path,
      mode: sqlite.OpenMode.readOnly,
    );
    addTearDown(backup.close);
    expect(backup.userVersion, 1);
    expect(
      backup
          .select(
            "SELECT COUNT(*) AS count FROM todos WHERE id = 'legacy-task'",
          )
          .single['count'],
      1,
    );
  });

  test('production open safely resumes a partial schema 2 migration', () async {
    final supportDirectory =
        await Directory.systemTemp.createTemp('simple_note_v2_partial_');
    addTearDown(() => supportDirectory.delete(recursive: true));
    final databaseFile =
        File(p.join(supportDirectory.path, AppConstants.databaseName));
    _seedV1Database(databaseFile);
    _seedPartialV2State(databaseFile);

    _mockApplicationSupportDirectory(supportDirectory.path);

    final database = AppDatabase();
    addTearDown(database.close);
    await database.open();

    final legacyRows = await database
        .customSelect(
          "SELECT * FROM tasks_v2 WHERE id = 'legacy-task'",
        )
        .get();
    expect(legacyRows, hasLength(1));
    final legacy = legacyRows.single;
    expect(legacy.read<String>('title'), 'Legacy title');
    expect(legacy.read<int>('priority'), 3);
    expect(legacy.read<int?>('deleted_at'), 150);
    expect(legacy.read<int>('version'), 7);

    final preservedV2 = await database
        .customSelect(
          "SELECT * FROM tasks_v2 WHERE id = 'existing-v2'",
        )
        .getSingle();
    expect(preservedV2.read<String>('title'), 'Existing V2');
    expect(preservedV2.read<int>('version'), 4);

    final preservedList = await database
        .customSelect(
          "SELECT name FROM task_lists WHERE id = 'existing-list'",
        )
        .getSingle();
    expect(preservedList.read<String>('name'), 'Existing list');

    final originalTodo = await (database.select(database.todos)
          ..where((todo) => todo.id.equals('legacy-task')))
        .getSingle();
    expect(originalTodo.title, 'Legacy title');
    expect(originalTodo.description, 'legacy body');
    expect(originalTodo.priority, 2);
    expect(originalTodo.deletedAt, 150);
    expect(originalTodo.version, 7);

    final tables = await database
        .customSelect(
          'SELECT COUNT(*) AS count FROM sqlite_master '
          "WHERE type = 'table' AND name IN ("
          "'task_lists', 'tasks_v2', 'task_tags', 'task_tag_links', "
          "'smart_filters', 'content_attachments', 'custom_colors', "
          "'background_images', 'device_appearance_profiles', "
          "'task_reminders', 'task_completions')",
        )
        .getSingle();
    expect(tables.read<int>('count'), 11);

    final indexes = await database
        .customSelect(
          'SELECT COUNT(*) AS count FROM sqlite_master '
          "WHERE type = 'index' AND name IN ("
          "'custom_colors_rgb_active', "
          "'content_attachments_owner_active', 'tasks_v2_due_active', "
          "'task_reminders_task_active', 'task_completions_task_active')",
        )
        .getSingle();
    expect(indexes.read<int>('count'), 5);

    final version =
        await database.customSelect('PRAGMA user_version').getSingle();
    expect(version.read<int>('user_version'), 4);
  });

  test('production open backs up schema 3 and migrates habits tables',
      () async {
    final supportDirectory =
        await Directory.systemTemp.createTemp('simple_note_v4_migration_');
    addTearDown(() => supportDirectory.delete(recursive: true));
    final databaseFile =
        File(p.join(supportDirectory.path, AppConstants.databaseName));
    _seedV3Database(databaseFile);

    _mockApplicationSupportDirectory(supportDirectory.path);

    final database = AppDatabase();
    addTearDown(database.close);
    await database.open();

    final version =
        await database.customSelect('PRAGMA user_version').getSingle();
    expect(version.read<int>('user_version'), 4);

    final existingTask = await database
        .customSelect(
          "SELECT title FROM tasks_v2 WHERE id = 'existing-v3-task'",
        )
        .getSingle();
    expect(existingTask.read<String>('title'), 'Existing V3 Task');

    final existingNote = await database
        .customSelect(
          "SELECT title FROM notes WHERE id = 'existing-note'",
        )
        .getSingle();
    expect(existingNote.read<String>('title'), 'Existing note');

    await database.customStatement(
      'INSERT INTO habits '
      '(id, name, icon_key, color, schedule_type, schedule_json, '
      'created_at, updated_at, device_id) '
      "VALUES ('habit', 'Read', 'book', 1, 'daily', '{}', 1, 1, 'device')",
    );

    final backupDirectory = Directory(p.join(supportDirectory.path, 'backups'));
    final backupFiles = backupDirectory
        .listSync()
        .whereType<File>()
        .where(
          (file) => p.basename(file.path).startsWith('simple_note.pre-v4.'),
        )
        .toList();
    expect(backupFiles, hasLength(1));

    final backup = sqlite.sqlite3.open(
      backupFiles.single.path,
      mode: sqlite.OpenMode.readOnly,
    );
    addTearDown(backup.close);
    expect(backup.userVersion, 3);
  });

  test('production open backs up schema 2 and migrates reminders table',
      () async {
    final supportDirectory =
        await Directory.systemTemp.createTemp('simple_note_v3_migration_');
    addTearDown(() => supportDirectory.delete(recursive: true));
    final databaseFile =
        File(p.join(supportDirectory.path, AppConstants.databaseName));
    _seedV2Database(databaseFile);

    _mockApplicationSupportDirectory(supportDirectory.path);

    final database = AppDatabase();
    addTearDown(database.close);
    await database.open();

    final version =
        await database.customSelect('PRAGMA user_version').getSingle();
    expect(version.read<int>('user_version'), 4);

    final existing = await database
        .customSelect(
          "SELECT title FROM tasks_v2 WHERE id = 'existing-v2'",
        )
        .getSingle();
    expect(existing.read<String>('title'), 'Existing V2');

    await database.customStatement(
      'INSERT INTO task_reminders '
      '(id, task_id, trigger_at, created_at, updated_at, device_id) '
      "VALUES ('reminder', 'existing-v2', 500, 1, 1, 'device')",
    );

    final backupDirectory = Directory(p.join(supportDirectory.path, 'backups'));
    final backupFiles = backupDirectory
        .listSync()
        .whereType<File>()
        .where(
          (file) => p.basename(file.path).startsWith('simple_note.pre-v3.'),
        )
        .toList();
    expect(backupFiles, hasLength(1));

    final backup = sqlite.sqlite3.open(
      backupFiles.single.path,
      mode: sqlite.OpenMode.readOnly,
    );
    addTearDown(backup.close);
    expect(backup.userVersion, 2);
  });

  test('backup failure aborts before the production database is upgraded',
      () async {
    final supportDirectory =
        await Directory.systemTemp.createTemp('simple_note_v2_backup_failure_');
    addTearDown(() => supportDirectory.delete(recursive: true));
    final databaseFile =
        File(p.join(supportDirectory.path, AppConstants.databaseName));
    _seedV1Database(databaseFile);
    await File(p.join(supportDirectory.path, 'backups'))
        .writeAsString('blocks backup directory creation');

    _mockApplicationSupportDirectory(supportDirectory.path);

    final database = AppDatabase();
    await expectLater(database.open(), throwsA(anything));

    final original = sqlite.sqlite3.open(
      databaseFile.path,
      mode: sqlite.OpenMode.readOnly,
    );
    addTearDown(original.close);
    expect(original.userVersion, 1);
    expect(
      original
          .select(
            'SELECT COUNT(*) AS count FROM sqlite_master '
            "WHERE type = 'table' AND name = 'tasks_v2'",
          )
          .single['count'],
      0,
    );
  });
}

void _seedV1Database(File file) {
  final database = sqlite.sqlite3.open(file.path);
  try {
    database.execute('''
      CREATE TABLE todos (
        id TEXT NOT NULL PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT NOT NULL DEFAULT '',
        completed INTEGER NOT NULL DEFAULT 0,
        due_at INTEGER,
        priority INTEGER NOT NULL DEFAULT 1,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        deleted_at INTEGER,
        device_id TEXT NOT NULL,
        version INTEGER NOT NULL DEFAULT 1
      )
    ''');
    database.execute('''
      INSERT INTO todos (
        id, title, description, completed, due_at, priority, created_at,
        updated_at, deleted_at, device_id, version
      ) VALUES (
        'legacy-task', 'Legacy title', 'legacy body', 1, 300, 2, 100,
        200, 150, 'legacy-device', 7
      )
    ''');
    database.userVersion = 1;
  } finally {
    database.close();
  }
}

void _seedPartialV2State(File file) {
  final database = sqlite.sqlite3.open(file.path);
  try {
    database.execute('''
      CREATE TABLE task_lists (
        id TEXT NOT NULL,
        name TEXT NOT NULL,
        color INTEGER NOT NULL,
        icon_key TEXT NOT NULL,
        sort_order INTEGER NOT NULL DEFAULT 0,
        archived INTEGER NOT NULL DEFAULT 0 CHECK (archived IN (0, 1)),
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        deleted_at INTEGER,
        device_id TEXT NOT NULL,
        version INTEGER NOT NULL DEFAULT 1,
        PRIMARY KEY (id)
      )
    ''');
    database.execute('''
      CREATE TABLE tasks_v2 (
        id TEXT NOT NULL,
        parent_id TEXT,
        list_id TEXT,
        title TEXT NOT NULL,
        description_markdown TEXT NOT NULL DEFAULT '',
        completed INTEGER NOT NULL DEFAULT 0 CHECK (completed IN (0, 1)),
        priority INTEGER NOT NULL DEFAULT 0 CHECK (priority BETWEEN 0 AND 3),
        start_at INTEGER,
        due_at INTEGER,
        all_day INTEGER NOT NULL DEFAULT 0 CHECK (all_day IN (0, 1)),
        sort_order INTEGER NOT NULL DEFAULT 0,
        recurrence_rule TEXT,
        recurrence_end_at INTEGER,
        recurrence_count INTEGER,
        completed_at INTEGER,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        deleted_at INTEGER,
        device_id TEXT NOT NULL,
        version INTEGER NOT NULL DEFAULT 1,
        PRIMARY KEY (id)
      )
    ''');
    database.execute('''
      INSERT INTO task_lists (
        id, name, color, icon_key, sort_order, archived, created_at,
        updated_at, deleted_at, device_id, version
      ) VALUES (
        'existing-list', 'Existing list', 1, 'list', 0, 0, 50, 60,
        NULL, 'partial-device', 2
      )
    ''');
    database.execute('''
      INSERT INTO tasks_v2 (
        id, parent_id, list_id, title, description_markdown, completed,
        priority, start_at, due_at, all_day, sort_order, recurrence_rule,
        recurrence_end_at, recurrence_count, completed_at, created_at,
        updated_at, deleted_at, device_id, version
      ) VALUES
        (
          'legacy-task', NULL, NULL, 'Legacy title', 'legacy body', 1,
          3, NULL, 300, 1, 100, NULL, NULL, NULL, 200, 100, 200, 150,
          'legacy-device', 7
        ),
        (
          'existing-v2', NULL, 'existing-list', 'Existing V2', '', 0,
          0, NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, 70, 80, NULL,
          'partial-device', 4
        )
    ''');
    database.execute('''
      CREATE INDEX tasks_v2_due_active
      ON tasks_v2(due_at, completed) WHERE deleted_at IS NULL
    ''');
    database.userVersion = 1;
  } finally {
    database.close();
  }
}

void _seedV2Database(File file) {
  final database = sqlite.sqlite3.open(file.path);
  try {
    database.execute('''
      CREATE TABLE tasks_v2 (
        id TEXT NOT NULL,
        parent_id TEXT,
        list_id TEXT,
        title TEXT NOT NULL,
        description_markdown TEXT NOT NULL DEFAULT '',
        completed INTEGER NOT NULL DEFAULT 0 CHECK (completed IN (0, 1)),
        priority INTEGER NOT NULL DEFAULT 0 CHECK (priority BETWEEN 0 AND 3),
        start_at INTEGER,
        due_at INTEGER,
        all_day INTEGER NOT NULL DEFAULT 0 CHECK (all_day IN (0, 1)),
        sort_order INTEGER NOT NULL DEFAULT 0,
        recurrence_rule TEXT,
        recurrence_end_at INTEGER,
        recurrence_count INTEGER,
        completed_at INTEGER,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        deleted_at INTEGER,
        device_id TEXT NOT NULL,
        version INTEGER NOT NULL DEFAULT 1,
        PRIMARY KEY (id)
      )
    ''');
    database.execute('''
      INSERT INTO tasks_v2 (
        id, title, description_markdown, completed, priority, all_day,
        sort_order, created_at, updated_at, device_id, version
      ) VALUES (
        'existing-v2', 'Existing V2', '', 0, 0, 0, 0, 1, 1, 'device', 1
      )
    ''');
    database.userVersion = 2;
  } finally {
    database.close();
  }
}

void _seedV3Database(File file) {
  final database = sqlite.sqlite3.open(file.path);
  try {
    database.execute('''
      CREATE TABLE notes (
        id TEXT NOT NULL PRIMARY KEY,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        deleted_at INTEGER,
        pinned INTEGER NOT NULL DEFAULT 0 CHECK (pinned IN (0, 1)),
        device_id TEXT NOT NULL,
        version INTEGER NOT NULL DEFAULT 1
      )
    ''');
    database.execute('''
      CREATE TABLE tasks_v2 (
        id TEXT NOT NULL,
        parent_id TEXT,
        list_id TEXT,
        title TEXT NOT NULL,
        description_markdown TEXT NOT NULL DEFAULT '',
        completed INTEGER NOT NULL DEFAULT 0 CHECK (completed IN (0, 1)),
        priority INTEGER NOT NULL DEFAULT 0 CHECK (priority BETWEEN 0 AND 3),
        start_at INTEGER,
        due_at INTEGER,
        all_day INTEGER NOT NULL DEFAULT 0 CHECK (all_day IN (0, 1)),
        sort_order INTEGER NOT NULL DEFAULT 0,
        recurrence_rule TEXT,
        recurrence_end_at INTEGER,
        recurrence_count INTEGER,
        completed_at INTEGER,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        deleted_at INTEGER,
        device_id TEXT NOT NULL,
        version INTEGER NOT NULL DEFAULT 1,
        PRIMARY KEY (id)
      )
    ''');
    database.execute('''
      CREATE TABLE task_completions (
        id TEXT NOT NULL PRIMARY KEY,
        task_id TEXT NOT NULL,
        scheduled_at INTEGER NOT NULL,
        completed_at INTEGER NOT NULL,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        deleted_at INTEGER,
        device_id TEXT NOT NULL,
        version INTEGER NOT NULL DEFAULT 1
      )
    ''');
    database.execute('''
      CREATE TABLE task_reminders (
        id TEXT NOT NULL PRIMARY KEY,
        task_id TEXT NOT NULL,
        trigger_at INTEGER,
        offset_minutes INTEGER,
        fired_at INTEGER,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        deleted_at INTEGER,
        device_id TEXT NOT NULL,
        version INTEGER NOT NULL DEFAULT 1,
        CHECK ((trigger_at IS NULL) != (offset_minutes IS NULL))
      )
    ''');
    database.execute('''
      INSERT INTO notes (
        id, title, content, created_at, updated_at, device_id
      ) VALUES (
        'existing-note', 'Existing note', '', 1, 1, 'device'
      )
    ''');
    database.execute('''
      INSERT INTO tasks_v2 (
        id, title, description_markdown, completed, priority, all_day,
        sort_order, created_at, updated_at, device_id, version
      ) VALUES (
        'existing-v3-task', 'Existing V3 Task', '', 0, 0, 0, 0, 1, 1,
        'device', 1
      )
    ''');
    database.userVersion = 3;
  } finally {
    database.close();
  }
}

void _mockApplicationSupportDirectory(String supportPath) {
  const channel = MethodChannel('plugins.flutter.io/path_provider');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  messenger.setMockMethodCallHandler(channel, (call) async {
    if (call.method == 'getApplicationSupportDirectory') {
      return supportPath;
    }
    throw MissingPluginException(
      'Unexpected path_provider call: ${call.method}',
    );
  });
  addTearDown(() => messenger.setMockMethodCallHandler(channel, null));
}
