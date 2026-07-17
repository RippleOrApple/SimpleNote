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
    expect(
      migrated.read<String>('description_markdown'),
      'legacy body',
    );
    expect(migrated.read<int>('priority'), 3);
    expect(migrated.read<bool>('completed'), isTrue);
    expect(migrated.read<int?>('completed_at'), 200);
    expect(migrated.read<int?>('due_at'), 300);
    expect(migrated.read<String?>('list_id'), isNull);

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
        200, NULL, 'legacy-device', 7
      )
    ''');
    database.userVersion = 1;
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
