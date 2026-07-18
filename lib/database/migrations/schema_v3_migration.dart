part of '../app_database.dart';

class SchemaV3Migration {
  const SchemaV3Migration._();

  static Future<void> run(AppDatabase db, Migrator migrator) async {
    await migrator.createTable(db.taskCompletions);
    await migrator.createTable(db.taskReminders);
    await createIndexes(db);
  }

  static Future<void> createIndexes(AppDatabase db) async {
    await db.customStatement(
      'CREATE INDEX IF NOT EXISTS task_completions_task_active '
      'ON task_completions(task_id, scheduled_at, completed_at) '
      'WHERE deleted_at IS NULL',
    );
    await db.customStatement(
      'CREATE INDEX IF NOT EXISTS task_reminders_task_active '
      'ON task_reminders(task_id, trigger_at, offset_minutes) '
      'WHERE deleted_at IS NULL',
    );
  }
}
