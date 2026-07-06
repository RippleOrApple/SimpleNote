import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/id_generator.dart';
import '../../../core/utils/time.dart';
import '../../../database/app_database.dart';
import '../../notes/domain/note.dart';
import '../../settings/domain/theme_scheme.dart';
import '../../tags/domain/tag.dart';
import '../../todos/domain/todo.dart';
import '../domain/device_info.dart';
import '../domain/merge_policy.dart';
import '../domain/sync_result.dart';
import '../domain/sync_snapshot.dart';

final deviceInfoProvider = Provider<DeviceInfo>((ref) {
  return DeviceInfo(
    deviceId: 'local-${IdGenerator.create()}',
    deviceName: Platform.localHostname,
    platform: Platform.operatingSystem,
    appVersion: '0.1.0',
  );
});

final syncRepositoryProvider = Provider<SyncRepository>((ref) {
  return DriftSyncRepository(
    ref.watch(appDatabaseProvider),
    ref.watch(deviceInfoProvider),
  );
});

abstract class SyncRepository {
  DeviceInfo get device;
  Future<SyncSnapshot> exportSnapshot();
  Future<SyncResult> mergeSnapshot(SyncSnapshot snapshot);
}

class DriftSyncRepository implements SyncRepository {
  const DriftSyncRepository(this._database, this.device);

  final AppDatabase _database;

  @override
  final DeviceInfo device;

  @override
  Future<SyncSnapshot> exportSnapshot() async {
    final notes = await _database.notesDao.allNotes();
    final todos = await _database.todosDao.allTodos();
    final tags = await _database.tagsDao.allTags();
    final themes = await _database.themeSchemesDao.savedThemes();

    return SyncSnapshot(
      device: device,
      exportedAt: Clock.nowMillis(),
      notes: notes.map(_noteFromRow).toList(),
      todos: todos.map(_todoFromRow).toList(),
      tags: tags.map(_tagFromRow).toList(),
      themeSchemes: themes.map(_themeFromRow).toList(),
    );
  }

  @override
  Future<SyncResult> mergeSnapshot(SyncSnapshot snapshot) async {
    var notesCreated = 0;
    var notesUpdated = 0;
    var notesDeleted = 0;
    var todosCreated = 0;
    var todosUpdated = 0;
    var todosDeleted = 0;

    await _database.transaction(() async {
      for (final remoteNote in snapshot.notes) {
        final localRow = await _database.notesDao.findById(remoteNote.id);
        if (localRow == null) {
          await _database.notesDao.upsertNote(_noteToCompanion(remoteNote));
          if (remoteNote.isDeleted) {
            notesDeleted++;
          } else {
            notesCreated++;
          }
          continue;
        }

        final localNote = _noteFromRow(localRow);
        final chosen = MergePolicy.chooseLatest(localNote, remoteNote);
        if (identical(chosen, remoteNote)) {
          await _database.notesDao.upsertNote(_noteToCompanion(remoteNote));
          if (remoteNote.isDeleted) {
            notesDeleted++;
          } else {
            notesUpdated++;
          }
        }
      }

      for (final remoteTodo in snapshot.todos) {
        final localRow = await _database.todosDao.findById(remoteTodo.id);
        if (localRow == null) {
          await _database.todosDao.upsertTodo(_todoToCompanion(remoteTodo));
          if (remoteTodo.isDeleted) {
            todosDeleted++;
          } else {
            todosCreated++;
          }
          continue;
        }

        final localTodo = _todoFromRow(localRow);
        final chosen = MergePolicy.chooseLatest(localTodo, remoteTodo);
        if (identical(chosen, remoteTodo)) {
          await _database.todosDao.upsertTodo(_todoToCompanion(remoteTodo));
          if (remoteTodo.isDeleted) {
            todosDeleted++;
          } else {
            todosUpdated++;
          }
        }
      }

      for (final remoteTag in snapshot.tags) {
        final localRow = await _database.tagsDao.findById(remoteTag.id);
        if (localRow == null ||
            _effectiveChangedAt(remoteTag.deletedAt, remoteTag.updatedAt) >
                _effectiveChangedAt(localRow.deletedAt, localRow.updatedAt)) {
          await _database.tagsDao.upsertTag(_tagToCompanion(remoteTag));
        }
      }

      for (final remoteTheme in snapshot.themeSchemes) {
        final localRow =
            await _database.themeSchemesDao.findById(remoteTheme.id);
        if (localRow == null || remoteTheme.isActive) {
          await _database.themeSchemesDao.upsertTheme(
            _themeToCompanion(remoteTheme),
          );
        }
      }
    });

    return SyncResult(
      success: true,
      notesCreated: notesCreated,
      notesUpdated: notesUpdated,
      notesDeleted: notesDeleted,
      todosCreated: todosCreated,
      todosUpdated: todosUpdated,
      todosDeleted: todosDeleted,
    );
  }

  static int _effectiveChangedAt(int? deletedAt, int updatedAt) {
    return deletedAt ?? updatedAt;
  }

  static Note _noteFromRow(NoteRow row) {
    return Note(
      id: row.id,
      title: row.title,
      content: row.content,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      deletedAt: row.deletedAt,
      pinned: row.pinned,
      deviceId: row.deviceId,
      version: row.version,
    );
  }

  static NotesCompanion _noteToCompanion(Note note) {
    return NotesCompanion(
      id: Value(note.id),
      title: Value(note.title),
      content: Value(note.content),
      createdAt: Value(note.createdAt),
      updatedAt: Value(note.updatedAt),
      deletedAt: Value(note.deletedAt),
      pinned: Value(note.pinned),
      deviceId: Value(note.deviceId),
      version: Value(note.version),
    );
  }

  static Todo _todoFromRow(TodoRow row) {
    return Todo(
      id: row.id,
      title: row.title,
      description: row.description,
      completed: row.completed,
      dueAt: row.dueAt,
      priority: TodoPriority.values[row.priority],
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      deletedAt: row.deletedAt,
      deviceId: row.deviceId,
      version: row.version,
    );
  }

  static TodosCompanion _todoToCompanion(Todo todo) {
    return TodosCompanion(
      id: Value(todo.id),
      title: Value(todo.title),
      description: Value(todo.description),
      completed: Value(todo.completed),
      dueAt: Value(todo.dueAt),
      priority: Value(todo.priority.index),
      createdAt: Value(todo.createdAt),
      updatedAt: Value(todo.updatedAt),
      deletedAt: Value(todo.deletedAt),
      deviceId: Value(todo.deviceId),
      version: Value(todo.version),
    );
  }

  static Tag _tagFromRow(TagRow row) {
    return Tag(
      id: row.id,
      name: row.name,
      color: row.color,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      deletedAt: row.deletedAt,
      deviceId: row.deviceId,
    );
  }

  static TagsCompanion _tagToCompanion(Tag tag) {
    return TagsCompanion(
      id: Value(tag.id),
      name: Value(tag.name),
      color: Value(tag.color),
      createdAt: Value(tag.createdAt),
      updatedAt: Value(tag.updatedAt),
      deletedAt: Value(tag.deletedAt),
      deviceId: Value(tag.deviceId),
    );
  }

  static AppThemeScheme _themeFromRow(ThemeSchemeRow row) {
    return AppThemeScheme(
      id: row.id,
      name: row.name,
      backgroundColor: Color(row.backgroundColor),
      primaryColor: Color(row.primaryColor),
      textColor: Color(row.textColor),
      surfaceColor: Color(row.surfaceColor),
      brightness: row.brightness == Brightness.dark.name
          ? Brightness.dark
          : Brightness.light,
      isActive: row.isActive,
    );
  }

  static ThemeSchemesCompanion _themeToCompanion(AppThemeScheme theme) {
    final now = Clock.nowMillis();
    return ThemeSchemesCompanion(
      id: Value(theme.id),
      name: Value(theme.name),
      backgroundColor: Value(theme.backgroundColor.toARGB32()),
      primaryColor: Value(theme.primaryColor.toARGB32()),
      textColor: Value(theme.textColor.toARGB32()),
      surfaceColor: Value(theme.surfaceColor.toARGB32()),
      brightness: Value(theme.brightness.name),
      createdAt: Value(now),
      updatedAt: Value(now),
      isActive: Value(theme.isActive),
    );
  }
}
