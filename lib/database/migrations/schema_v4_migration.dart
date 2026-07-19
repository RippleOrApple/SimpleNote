part of '../app_database.dart';

class SchemaV4Migration {
  const SchemaV4Migration._();

  static Future<void> run(AppDatabase db, Migrator migrator) async {
    await migrator.createTable(db.habits);
    await migrator.createTable(db.habitCheckins);
    await createIndexes(db);
  }

  static Future<void> createIndexes(AppDatabase db) async {
    await db.customStatement(
      'CREATE INDEX IF NOT EXISTS habits_active_order '
      'ON habits(archived, sort_order, updated_at) '
      'WHERE deleted_at IS NULL',
    );
    await db.customStatement(
      'CREATE UNIQUE INDEX IF NOT EXISTS habit_checkins_active_day '
      'ON habit_checkins(habit_id, checkin_day) '
      'WHERE deleted_at IS NULL',
    );
    await db.customStatement(
      'CREATE INDEX IF NOT EXISTS habit_checkins_day_active '
      'ON habit_checkins(checkin_day, habit_id) '
      'WHERE deleted_at IS NULL',
    );
  }
}
