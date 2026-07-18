import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../core/constants/app_constants.dart';
import 'backup/database_backup_service.dart';
import 'tables/background_images_table.dart';
import 'tables/content_attachments_table.dart';
import 'tables/custom_colors_table.dart';
import 'tables/device_appearance_profiles_table.dart';
import 'tables/app_settings_table.dart';
import 'tables/note_tags_table.dart';
import 'tables/notes_table.dart';
import 'tables/smart_filters_table.dart';
import 'tables/sync_logs_table.dart';
import 'tables/tags_table.dart';
import 'tables/task_completions_table.dart';
import 'tables/task_lists_table.dart';
import 'tables/task_reminders_table.dart';
import 'tables/task_tag_links_table.dart';
import 'tables/task_tags_table.dart';
import 'tables/tasks_v2_table.dart';
import 'tables/theme_schemes_table.dart';
import 'tables/todos_table.dart';

part 'app_database.g.dart';
part 'migrations/schema_v2_migration.dart';
part 'migrations/schema_v3_migration.dart';
part 'daos/appearance_dao.dart';
part 'daos/app_settings_dao.dart';
part 'daos/attachments_dao.dart';
part 'daos/note_tags_dao.dart';
part 'daos/notes_dao.dart';
part 'daos/sync_logs_dao.dart';
part 'daos/tags_dao.dart';
part 'daos/task_taxonomy_dao.dart';
part 'daos/tasks_v2_dao.dart';
part 'daos/theme_schemes_dao.dart';
part 'daos/todos_dao.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});

@DriftDatabase(
  tables: [
    Notes,
    Todos,
    Tags,
    NoteTags,
    ThemeSchemes,
    SyncLogs,
    AppSettings,
    TaskLists,
    TasksV2,
    TaskCompletions,
    TaskReminders,
    TaskTags,
    TaskTagLinks,
    SmartFilters,
    ContentAttachments,
    CustomColors,
    BackgroundImages,
    DeviceAppearanceProfiles,
  ],
  daos: [
    NotesDao,
    TodosDao,
    TagsDao,
    NoteTagsDao,
    ThemeSchemesDao,
    SyncLogsDao,
    AppSettingsDao,
    TasksV2Dao,
    TaskTaxonomyDao,
    AttachmentsDao,
    AppearanceDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (migrator) async {
          await migrator.createAll();
          await SchemaV2Migration.createIndexes(this);
          await SchemaV3Migration.createIndexes(this);
        },
        onUpgrade: (migrator, from, to) async {
          if (from < 2) {
            await SchemaV2Migration.run(this, migrator);
          }
          if (from < 3) {
            await SchemaV3Migration.run(this, migrator);
          }
        },
      );

  Future<void> open() async {
    await customSelect('SELECT 1').get();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final directory = await getApplicationSupportDirectory();
    final file = File(p.join(directory.path, AppConstants.databaseName));
    await DatabaseBackupService.prepare(
      databaseFile: file,
      supportDirectory: directory,
    );
    return NativeDatabase.createInBackground(file);
  });
}
