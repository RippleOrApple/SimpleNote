part of '../app_database.dart';

@DriftAccessor(tables: [Notes])
class NotesDao extends DatabaseAccessor<AppDatabase> with _$NotesDaoMixin {
  NotesDao(super.db);

  Future<List<NoteRow>> activeNotes() {
    return (select(notes)
          ..where((note) => note.deletedAt.isNull())
          ..orderBy([
            (note) => OrderingTerm.desc(note.pinned),
            (note) => OrderingTerm.desc(note.updatedAt),
          ]))
        .get();
  }

  Future<List<NoteRow>> searchActive(String query) {
    final pattern = '%$query%';
    return (select(notes)
          ..where(
            (note) =>
                note.deletedAt.isNull() &
                (note.title.like(pattern) | note.content.like(pattern)),
          )
          ..orderBy([(note) => OrderingTerm.desc(note.updatedAt)]))
        .get();
  }

  Future<void> upsertNote(NotesCompanion note) {
    return into(notes).insertOnConflictUpdate(note);
  }

  Future<void> softDeleteNote(String id, int deletedAt) {
    return (update(notes)..where((note) => note.id.equals(id))).write(
      NotesCompanion(
        deletedAt: Value(deletedAt),
        updatedAt: Value(deletedAt),
      ),
    );
  }
}
