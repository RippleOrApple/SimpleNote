part of '../app_database.dart';

@DriftAccessor(tables: [NoteTags])
class NoteTagsDao extends DatabaseAccessor<AppDatabase>
    with _$NoteTagsDaoMixin {
  NoteTagsDao(super.db);

  Future<List<NoteTagRow>> linksForNote(String noteId) {
    return (select(noteTags)..where((link) => link.noteId.equals(noteId)))
        .get();
  }

  Future<void> upsertLink(NoteTagsCompanion link) {
    return into(noteTags).insertOnConflictUpdate(link);
  }

  Future<void> removeLink(String noteId, String tagId) {
    return (delete(noteTags)
          ..where(
              (link) => link.noteId.equals(noteId) & link.tagId.equals(tagId)))
        .go();
  }
}
