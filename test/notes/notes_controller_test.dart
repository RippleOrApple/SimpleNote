import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_note/database/app_database.dart';
import 'package:simple_note/features/notes/application/notes_controller.dart';

void main() {
  late AppDatabase database;
  late ProviderContainer container;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(database)],
    );
  });

  tearDown(() async {
    container.dispose();
    await database.close();
  });

  test('creates, edits, reloads, searches, tags, filters, and deletes a note',
      () async {
    final controller = container.read(notesControllerProvider.notifier);

    await container.read(notesControllerProvider.future);
    await controller.createNote();

    var state = await container.read(notesControllerProvider.future);
    final noteId = state.notes.single.id;

    await controller.updateNote(
      noteId,
      title: 'Project plan',
      content: '# Heading\n\n- item\n\nImportant body',
    );

    state = await container.read(notesControllerProvider.future);
    expect(state.notes.single.title, 'Project plan');
    expect(state.notes.single.content, contains('Important body'));
    final updatedAt = state.notes.single.updatedAt;

    await controller.reload();
    state = await container.read(notesControllerProvider.future);
    expect(state.notes.single.id, noteId);

    await controller.updateSearchQuery('Project');
    state = await container.read(notesControllerProvider.future);
    expect(state.notes, hasLength(1));

    await controller.updateSearchQuery('Important');
    state = await container.read(notesControllerProvider.future);
    expect(state.notes, hasLength(1));

    await controller.createTag('work');
    state = await container.read(notesControllerProvider.future);
    final tag = state.tags.single;

    await controller.toggleTagForSelectedNote(tag.id);
    state = await container.read(notesControllerProvider.future);
    expect(state.tagIdsFor(noteId), contains(tag.id));
    expect(state.notes.single.updatedAt, greaterThanOrEqualTo(updatedAt));

    await controller.selectTag(tag.id);
    state = await container.read(notesControllerProvider.future);
    expect(state.notes.single.id, noteId);

    await controller.deleteNote(noteId);
    state = await container.read(notesControllerProvider.future);
    expect(state.notes, isEmpty);
  });
}
