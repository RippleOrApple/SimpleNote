import '../domain/note.dart';

abstract class NotesRepository {
  Future<List<Note>> watchActiveNotes();
  Future<List<Note>> search(String query);
  Future<void> upsert(Note note);
  Future<void> softDelete(String id, int deletedAt);
}
