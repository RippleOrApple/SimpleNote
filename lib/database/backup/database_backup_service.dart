import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart' as sqlite;

class DatabaseBackupService {
  const DatabaseBackupService._();

  static Future<File?> prepare({
    required File databaseFile,
    required Directory supportDirectory,
  }) async {
    if (!await databaseFile.exists()) {
      return null;
    }

    final database = sqlite.sqlite3.open(
      databaseFile.path,
      mode: sqlite.OpenMode.readOnly,
    );
    late final int currentVersion;
    try {
      currentVersion = database.userVersion;
    } finally {
      database.close();
    }

    if (currentVersion < 1 || currentVersion > 1) {
      return null;
    }

    final backupDirectory = Directory(p.join(supportDirectory.path, 'backups'));
    await backupDirectory.create(recursive: true);
    final backupFile = File(
      p.join(
        backupDirectory.path,
        'simple_note.pre-v2.${DateTime.now().millisecondsSinceEpoch}.sqlite',
      ),
    );
    return databaseFile.copy(backupFile.path);
  }
}
