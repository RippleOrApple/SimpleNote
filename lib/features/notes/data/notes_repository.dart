import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../database/app_database.dart';
import '../domain/note.dart';

final notesRepositoryProvider = Provider<NotesRepository>((ref) {
  return DriftNotesRepository(ref.watch(appDatabaseProvider));
});

abstract class NotesRepository {
  Future<List<Note>> watchActiveNotes();
  Future<List<Note>> search(String query);
  Future<List<String>> noteIdsForTag(String tagId);
  Future<Map<String, List<String>>> tagIdsByNoteId();
  Future<void> upsert(Note note);
  Future<void> setNoteTags(
      String noteId, Iterable<String> tagIds, int updatedAt);
  Future<void> softDelete(String id, int deletedAt);
}

class DriftNotesRepository implements NotesRepository {
  const DriftNotesRepository(this._database);

  final AppDatabase _database;

  @override
  Future<List<Note>> watchActiveNotes() async {
    final rows = await _database.notesDao.activeNotes();
    return rows.map(_fromRow).toList();
  }

  @override
  Future<List<Note>> search(String query) async {
    final rows = await _database.notesDao.searchActive(query);
    return rows.map(_fromRow).toList();
  }

  @override
  Future<List<String>> noteIdsForTag(String tagId) {
    return _database.noteTagsDao.noteIdsForTag(tagId);
  }

  @override
  Future<Map<String, List<String>>> tagIdsByNoteId() async {
    final links = await _database.noteTagsDao.allLinks();
    final result = <String, List<String>>{};
    for (final link in links) {
      result.putIfAbsent(link.noteId, () => []).add(link.tagId);
    }
    return result;
  }

  @override
  Future<void> upsert(Note note) {
    return _database.notesDao.upsertNote(_toCompanion(note));
  }

  @override
  Future<void> setNoteTags(
    String noteId,
    Iterable<String> tagIds,
    int updatedAt,
  ) async {
    await _database.noteTagsDao.replaceLinksForNote(noteId, tagIds, updatedAt);
    final note = await _database.notesDao.findById(noteId);
    if (note != null) {
      await _database.notesDao.upsertNote(
        NotesCompanion(
          id: Value(note.id),
          title: Value(note.title),
          content: Value(note.content),
          createdAt: Value(note.createdAt),
          updatedAt: Value(updatedAt),
          deletedAt: Value(note.deletedAt),
          pinned: Value(note.pinned),
          deviceId: Value(note.deviceId),
          version: Value(note.version + 1),
        ),
      );
    }
  }

  @override
  Future<void> softDelete(String id, int deletedAt) {
    return _database.notesDao.softDeleteNote(id, deletedAt);
  }

  NotesCompanion _toCompanion(Note note) {
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

  Note _fromRow(NoteRow row) {
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
}
