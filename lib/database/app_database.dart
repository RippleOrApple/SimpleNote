import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../core/constants/app_constants.dart';
import 'tables/app_settings_table.dart';
import 'tables/note_tags_table.dart';
import 'tables/notes_table.dart';
import 'tables/sync_logs_table.dart';
import 'tables/tags_table.dart';
import 'tables/theme_schemes_table.dart';
import 'tables/todos_table.dart';

part 'app_database.g.dart';
part 'daos/app_settings_dao.dart';
part 'daos/note_tags_dao.dart';
part 'daos/notes_dao.dart';
part 'daos/sync_logs_dao.dart';
part 'daos/tags_dao.dart';
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
  ],
  daos: [
    NotesDao,
    TodosDao,
    TagsDao,
    NoteTagsDao,
    ThemeSchemesDao,
    SyncLogsDao,
    AppSettingsDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (migrator) => migrator.createAll(),
        onUpgrade: (migrator, from, to) async {},
      );

  Future<void> open() async {
    await customSelect('SELECT 1').get();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final directory = await getApplicationSupportDirectory();
    final file = File(p.join(directory.path, AppConstants.databaseName));
    return NativeDatabase.createInBackground(file);
  });
}
