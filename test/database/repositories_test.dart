import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:simple_note/database/app_database.dart';
import 'package:simple_note/features/notes/data/notes_repository.dart';
import 'package:simple_note/features/notes/domain/note.dart';
import 'package:simple_note/features/todos/data/todos_repository.dart';
import 'package:simple_note/features/todos/domain/todo.dart';

void main() {
  test('database can be created as a local sqlite file', () async {
    final tempDirectory = await Directory.systemTemp.createTemp('simple_note_');
    final file = File(p.join(tempDirectory.path, 'simple_note.sqlite'));
    final fileDatabase = AppDatabase(NativeDatabase(file));

    addTearDown(() async {
      await fileDatabase.close();
      if (tempDirectory.existsSync()) {
        tempDirectory.deleteSync(recursive: true);
      }
    });

    await fileDatabase.open();

    expect(file.existsSync(), isTrue);
  });

  test('database schema includes all phase 2 tables', () async {
    final database = _createMemoryDatabase();

    await database.open();

    final rows = await database
        .customSelect(
          "SELECT name FROM sqlite_master WHERE type = 'table'",
        )
        .get();
    final tableNames = rows.map((row) => row.data['name'] as String).toSet();

    expect(tableNames, contains('notes'));
    expect(tableNames, contains('todos'));
    expect(tableNames, contains('tags'));
    expect(tableNames, contains('note_tags'));
    expect(tableNames, contains('theme_schemes'));
    expect(tableNames, contains('sync_logs'));
    expect(tableNames, contains('app_settings'));
  });

  test('notes repository inserts, reads, searches, and soft deletes notes',
      () async {
    final database = _createMemoryDatabase();
    final repository = DriftNotesRepository(database);
    const note = Note(
      id: 'note-1',
      title: 'Local first',
      content: 'Markdown content',
      createdAt: 100,
      updatedAt: 100,
      deviceId: 'test-device',
    );

    await repository.upsert(note);

    final notes = await repository.watchActiveNotes();
    expect(notes, hasLength(1));
    expect(notes.single.title, 'Local first');

    final searchResults = await repository.search('Markdown');
    expect(searchResults, hasLength(1));

    await repository.softDelete('note-1', 200);

    final activeNotes = await repository.watchActiveNotes();
    expect(activeNotes, isEmpty);
  });

  test('todos repository inserts, reads, and soft deletes todos', () async {
    final database = _createMemoryDatabase();
    final repository = DriftTodosRepository(database);
    const todo = Todo(
      id: 'todo-1',
      title: 'Wire database',
      createdAt: 100,
      updatedAt: 100,
      deviceId: 'test-device',
      priority: TodoPriority.high,
    );

    await repository.upsert(todo);

    final todos = await repository.watchActiveTodos();
    expect(todos, hasLength(1));
    expect(todos.single.title, 'Wire database');
    expect(todos.single.priority, TodoPriority.high);

    await repository.softDelete('todo-1', 200);

    final activeTodos = await repository.watchActiveTodos();
    expect(activeTodos, isEmpty);
  });
}

AppDatabase _createMemoryDatabase() {
  final database = AppDatabase(NativeDatabase.memory());
  addTearDown(database.close);
  return database;
}
