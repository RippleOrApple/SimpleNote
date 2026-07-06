import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_note/database/app_database.dart';
import 'package:simple_note/features/notes/domain/note.dart';
import 'package:simple_note/features/sync/data/sync_repository.dart';
import 'package:simple_note/features/sync/domain/device_info.dart';
import 'package:simple_note/features/sync/domain/sync_snapshot.dart';
import 'package:simple_note/features/tags/domain/tag.dart';
import 'package:simple_note/features/todos/domain/todo.dart';

void main() {
  test('exports and merges snapshots using latest effective change time',
      () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    const device = DeviceInfo(
      deviceId: 'local',
      deviceName: 'Local',
      platform: 'test',
      appVersion: '0.1.0',
    );
    final repository = DriftSyncRepository(database, device);

    await database.notesDao.upsertNote(
      const NotesCompanion(
        id: Value('note-1'),
        title: Value('Old local'),
        content: Value('local'),
        createdAt: Value(100),
        updatedAt: Value(100),
        deviceId: Value('local'),
        version: Value(1),
      ),
    );
    await database.todosDao.upsertTodo(
      const TodosCompanion(
        id: Value('todo-1'),
        title: Value('Local todo'),
        createdAt: Value(100),
        updatedAt: Value(100),
        deviceId: Value('local'),
        version: Value(1),
      ),
    );

    final exported = await repository.exportSnapshot();
    expect(exported.device.deviceId, 'local');
    expect(exported.notes, hasLength(1));
    expect(exported.todos, hasLength(1));

    final result = await repository.mergeSnapshot(
      const SyncSnapshot(
        device: DeviceInfo(
          deviceId: 'remote',
          deviceName: 'Remote',
          platform: 'test',
          appVersion: '0.1.0',
        ),
        exportedAt: 300,
        notes: [
          Note(
            id: 'note-1',
            title: 'New remote',
            content: 'remote',
            createdAt: 100,
            updatedAt: 300,
            deviceId: 'remote',
            version: 2,
          ),
          Note(
            id: 'note-2',
            title: 'Inserted remote',
            content: 'new',
            createdAt: 250,
            updatedAt: 250,
            deviceId: 'remote',
          ),
        ],
        todos: [
          Todo(
            id: 'todo-1',
            title: 'Deleted remote',
            createdAt: 100,
            updatedAt: 100,
            deletedAt: 400,
            deviceId: 'remote',
            version: 2,
          ),
          Todo(
            id: 'todo-2',
            title: 'Inserted todo',
            createdAt: 250,
            updatedAt: 250,
            deviceId: 'remote',
          ),
        ],
        tags: [
          Tag(
            id: 'tag-1',
            name: 'remote',
            createdAt: 200,
            updatedAt: 200,
            deviceId: 'remote',
          ),
        ],
        themeSchemes: [],
      ),
    );

    expect(result.success, isTrue);
    expect(result.notesCreated, 1);
    expect(result.notesUpdated, 1);
    expect(result.todosCreated, 1);
    expect(result.todosDeleted, 1);

    final mergedNote = await database.notesDao.findById('note-1');
    expect(mergedNote?.title, 'New remote');
    final insertedNote = await database.notesDao.findById('note-2');
    expect(insertedNote?.title, 'Inserted remote');
    final deletedTodo = await database.todosDao.findById('todo-1');
    expect(deletedTodo?.deletedAt, 400);
    final tag = await database.tagsDao.findById('tag-1');
    expect(tag?.name, 'remote');
  });
}
