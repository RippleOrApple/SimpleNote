part of '../app_database.dart';

class SchemaV3Migration {
  const SchemaV3Migration._();

  static Future<void> run(AppDatabase db, Migrator migrator) async {
    await migrator.createTable(db.taskReminders);
    await createIndexes(db);
  }

  static Future<void> createIndexes(AppDatabase db) async {
    await db.customStatement(
      'CREATE INDEX IF NOT EXISTS task_reminders_task_active '
      'ON task_reminders(task_id, trigger_at, offset_minutes) '
      'WHERE deleted_at IS NULL',
    );
  }
}
