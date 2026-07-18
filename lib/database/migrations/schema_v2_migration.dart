part of '../app_database.dart';

class SchemaV2Migration {
  const SchemaV2Migration._();

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

  static Future<void> createIndexes(AppDatabase db) async {
    await db.customStatement(
      'CREATE UNIQUE INDEX IF NOT EXISTS custom_colors_rgb_active '
      'ON custom_colors(rgb) WHERE deleted_at IS NULL',
    );
    await db.customStatement(
      'CREATE INDEX IF NOT EXISTS content_attachments_owner_active '
      'ON content_attachments(owner_type, owner_id, sort_order) '
      'WHERE deleted_at IS NULL',
    );
    await db.customStatement(
      'CREATE INDEX IF NOT EXISTS tasks_v2_due_active '
      'ON tasks_v2(due_at, completed) WHERE deleted_at IS NULL',
    );
  }
}
