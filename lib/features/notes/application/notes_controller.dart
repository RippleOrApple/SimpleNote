import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/id_generator.dart';
import '../../../core/utils/time.dart';
import '../domain/note.dart';

final notesControllerProvider =
    StateNotifierProvider<NotesController, List<Note>>((ref) {
  return NotesController();
});

class NotesController extends StateNotifier<List<Note>> {
  NotesController() : super(const []);

  void createNote({String deviceId = 'local-device'}) {
    final now = Clock.nowMillis();
    final note = Note(
      id: IdGenerator.create(),
      title: 'Untitled note',
      content: '',
      createdAt: now,
      updatedAt: now,
      deviceId: deviceId,
    );
    state = [note, ...state];
  }

  void updateNote(String id, {String? title, String? content}) {
    final now = Clock.nowMillis();
    state = [
      for (final note in state)
        if (note.id == id)
          note.copyWith(
            title: title,
            content: content,
            updatedAt: now,
            version: note.version + 1,
          )
        else
          note,
    ];
  }

  void deleteNote(String id) {
    state = state.where((note) => note.id != id).toList();
  }
}
