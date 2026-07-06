part of '../app_database.dart';

@DriftAccessor(tables: [NoteTags])
class NoteTagsDao extends DatabaseAccessor<AppDatabase>
    with _$NoteTagsDaoMixin {
  NoteTagsDao(super.db);

  Future<List<NoteTagRow>> linksForNote(String noteId) {
    return (select(noteTags)..where((link) => link.noteId.equals(noteId)))
        .get();
  }

  Future<List<NoteTagRow>> allLinks() {
    return select(noteTags).get();
  }

  Future<List<String>> noteIdsForTag(String tagId) async {
    final rows = await (select(noteTags)
          ..where((link) => link.tagId.equals(tagId)))
        .get();
    return rows.map((row) => row.noteId).toList();
  }

  Future<void> replaceLinksForNote(
    String noteId,
    Iterable<String> tagIds,
    int createdAt,
  ) async {
    await transaction(() async {
      await (delete(noteTags)..where((link) => link.noteId.equals(noteId)))
          .go();
      for (final tagId in tagIds) {
        await upsertLink(
          NoteTagsCompanion.insert(
            noteId: noteId,
            tagId: tagId,
            createdAt: createdAt,
          ),
        );
      }
    });
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
