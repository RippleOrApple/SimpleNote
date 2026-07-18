import 'dart:io';
import 'dart:typed_data';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:simple_note/database/app_database.dart';
import 'package:simple_note/features/attachments/application/attachment_import_service.dart';
import 'package:simple_note/features/attachments/data/attachments_repository.dart';
import 'package:simple_note/features/attachments/domain/content_attachment.dart';
import 'package:simple_note/features/attachments/infrastructure/attachment_file_store.dart';
import 'package:simple_note/shared/models/markdown_edit.dart';

void main() {
  late Directory root;
  late AppDatabase database;
  late DriftAttachmentsRepository repository;
  late AttachmentImportService service;
  late Uint8List pngBytes;

  setUp(() async {
    root = await Directory.systemTemp.createTemp('simple-note-import-');
    database = AppDatabase(NativeDatabase.memory());
    repository = DriftAttachmentsRepository(
      database: database,
      rootDirectory: root,
    );
    service = AttachmentImportService(
      repository: repository,
      fileStore: AttachmentFileStore(rootDirectory: root),
      deviceId: 'attachment-device',
    );
    pngBytes = Uint8List.fromList(
      img.encodePng(img.Image(width: 80, height: 40)),
    );
  });

  tearDown(() async {
    await database.close();
    if (root.existsSync()) await root.delete(recursive: true);
  });

  test('imports a note image and commits Markdown plus metadata atomically',
      () async {
    await _insertNote(database, id: 'note-1', content: 'Before\nAfter');

    final result = await service.importAndAttach(
      owner: const AttachmentOwner(AttachmentOwnerType.note, 'note-1'),
      input: MemoryAttachmentInput(name: 'photo.png', bytes: pngBytes),
      currentMarkdown: 'Before\nAfter',
      selection: const MarkdownSelection(baseOffset: 7, extentOffset: 7),
      altText: 'photo',
    );

    expect(
      result.markdown,
      'Before\n![photo](attachment://${result.attachment.id})After',
    );
    expect(result.edit.markdown, result.markdown);
    expect(result.selection.baseOffset, result.markdown.indexOf('After'));
    expect(await repository.forOwner(result.attachment.owner), hasLength(1));
    expect(File(result.attachment.absolutePath).existsSync(), isTrue);
    expect(
      File(result.attachment.thumbnailAbsolutePath).existsSync(),
      isTrue,
    );
    final note = await database.notesDao.findById('note-1');
    expect(note?.content, result.markdown);
    expect(note?.version, 2);
  });

  test('imports into task description and increments task version', () async {
    await _insertTask(database, id: 'task-1', description: 'Task body');

    final result = await service.importAndAttach(
      owner: const AttachmentOwner(AttachmentOwnerType.task, 'task-1'),
      input: MemoryAttachmentInput(name: 'photo.png', bytes: pngBytes),
      currentMarkdown: 'Task body',
      selection: const MarkdownSelection(baseOffset: 9, extentOffset: 9),
      altText: 'task photo',
    );

    final task = await database.tasksV2Dao.findById('task-1');
    expect(task?.descriptionMarkdown, result.markdown);
    expect(task?.version, 2);
  });

  test('missing owner rolls back metadata, final files, and temporary files',
      () async {
    await expectLater(
      service.importAndAttach(
        owner: const AttachmentOwner(AttachmentOwnerType.note, 'missing'),
        input: MemoryAttachmentInput(name: 'photo.png', bytes: pngBytes),
        currentMarkdown: 'Unchanged',
        selection: const MarkdownSelection(baseOffset: 0, extentOffset: 0),
        altText: 'photo',
      ),
      throwsStateError,
    );

    expect(
      await repository.forOwner(
        const AttachmentOwner(AttachmentOwnerType.note, 'missing'),
      ),
      isEmpty,
    );
    final attachments =
        Directory('${root.path}${Platform.pathSeparator}attachments');
    expect(
      attachments.existsSync()
          ? attachments.listSync(recursive: true).whereType<File>()
          : const [],
      isEmpty,
    );
  });

  test('injected commit failure leaves owner, metadata, and files unchanged',
      () async {
    await _insertNote(database, id: 'note-1', content: 'Original');
    final failingService = AttachmentImportService(
      repository: _FailingCommitRepository(repository),
      fileStore: AttachmentFileStore(rootDirectory: root),
      deviceId: 'attachment-device',
    );

    await expectLater(
      failingService.importAndAttach(
        owner: const AttachmentOwner(AttachmentOwnerType.note, 'note-1'),
        input: MemoryAttachmentInput(name: 'photo.png', bytes: pngBytes),
        currentMarkdown: 'Original',
        selection: const MarkdownSelection(baseOffset: 8, extentOffset: 8),
        altText: 'photo',
      ),
      throwsStateError,
    );

    expect((await database.notesDao.findById('note-1'))?.content, 'Original');
    expect(
      await repository.forOwner(
        const AttachmentOwner(AttachmentOwnerType.note, 'note-1'),
      ),
      isEmpty,
    );
    final attachments =
        Directory('${root.path}${Platform.pathSeparator}attachments');
    expect(
      attachments.existsSync()
          ? attachments.listSync(recursive: true).whereType<File>()
          : const [],
      isEmpty,
    );
  });

  test('failed reuse never removes files referenced by a prior import',
      () async {
    await _insertNote(database, id: 'note-1', content: 'Body');
    final imported = await service.importAndAttach(
      owner: const AttachmentOwner(AttachmentOwnerType.note, 'note-1'),
      input: MemoryAttachmentInput(name: 'photo.png', bytes: pngBytes),
      currentMarkdown: 'Body',
      selection: const MarkdownSelection(baseOffset: 4, extentOffset: 4),
      altText: 'photo',
    );

    await expectLater(
      service.importAndAttach(
        owner: const AttachmentOwner(AttachmentOwnerType.task, 'missing'),
        input: MemoryAttachmentInput(name: 'same.png', bytes: pngBytes),
        currentMarkdown: '',
        selection: const MarkdownSelection(baseOffset: 0, extentOffset: 0),
        altText: 'same',
      ),
      throwsStateError,
    );

    expect(File(imported.attachment.absolutePath).existsSync(), isTrue);
    expect(
      File(imported.attachment.thumbnailAbsolutePath).existsSync(),
      isTrue,
    );
    expect(await repository.forOwner(imported.attachment.owner), hasLength(1));
  });

  test('delete detaches exactly one node and keeps physical files', () async {
    const original = 'A ![first](attachment://placeholder) B';
    await _insertNote(database, id: 'note-1', content: original);
    final imported = await service.importAndAttach(
      owner: const AttachmentOwner(AttachmentOwnerType.note, 'note-1'),
      input: MemoryAttachmentInput(name: 'photo.png', bytes: pngBytes),
      currentMarkdown: original,
      selection: const MarkdownSelection(baseOffset: 2, extentOffset: 2),
      altText: 'photo',
    );
    final duplicate =
        '${imported.markdown}\n![again](attachment://${imported.attachment.id})';
    await database.notesDao.upsertNote(
        (await database.notesDao.findById('note-1'))!
            .copyWith(content: duplicate)
            .toCompanion(false));

    final result = await service.deleteAndDetach(
      owner: imported.attachment.owner,
      attachmentId: imported.attachment.id,
      currentMarkdown: duplicate,
      selection: MarkdownSelection(
        baseOffset: duplicate.length,
        extentOffset: duplicate.length,
      ),
    );

    expect(
      RegExp('attachment://${imported.attachment.id}')
          .allMatches(result.markdown),
      hasLength(1),
    );
    expect(
      (await repository.findById(imported.attachment.id))?.deletedAt,
      isNotNull,
    );
    expect(File(imported.attachment.absolutePath).existsSync(), isTrue);
    expect(
      File(imported.attachment.thumbnailAbsolutePath).existsSync(),
      isTrue,
    );
  });

  test('delete rolls back when the Markdown node is already absent', () async {
    await _insertNote(database, id: 'note-1', content: 'Body');
    final imported = await service.importAndAttach(
      owner: const AttachmentOwner(AttachmentOwnerType.note, 'note-1'),
      input: MemoryAttachmentInput(name: 'photo.png', bytes: pngBytes),
      currentMarkdown: 'Body',
      selection: const MarkdownSelection(baseOffset: 4, extentOffset: 4),
      altText: 'photo',
    );

    await expectLater(
      service.deleteAndDetach(
        owner: imported.attachment.owner,
        attachmentId: imported.attachment.id,
        currentMarkdown: 'Body without image',
        selection: const MarkdownSelection(baseOffset: 0, extentOffset: 0),
      ),
      throwsStateError,
    );

    expect(
      (await repository.findById(imported.attachment.id))?.deletedAt,
      isNull,
    );
  });
}

Future<void> _insertNote(
  AppDatabase database, {
  required String id,
  required String content,
}) {
  return database.notesDao.upsertNote(NotesCompanion.insert(
    id: id,
    title: 'Note',
    content: content,
    createdAt: 1,
    updatedAt: 1,
    deviceId: 'attachment-device',
  ));
}

Future<void> _insertTask(
  AppDatabase database, {
  required String id,
  required String description,
}) {
  return database.tasksV2Dao.upsertTask(TasksV2Companion.insert(
    id: id,
    title: 'Task',
    descriptionMarkdown: Value(description),
    createdAt: 1,
    updatedAt: 1,
    deviceId: 'attachment-device',
  ));
}

class _FailingCommitRepository implements AttachmentsRepository {
  const _FailingCommitRepository(this.delegate);

  final AttachmentsRepository delegate;

  @override
  Future<void> commitImport({
    required ContentAttachment attachment,
    required String markdown,
    required int updatedAt,
  }) {
    return Future.error(StateError('forced commit failure'));
  }

  @override
  Future<String> deleteAndDetach({
    required AttachmentOwner owner,
    required String attachmentId,
    required String currentMarkdown,
    required int updatedAt,
  }) {
    return delegate.deleteAndDetach(
      owner: owner,
      attachmentId: attachmentId,
      currentMarkdown: currentMarkdown,
      updatedAt: updatedAt,
    );
  }

  @override
  Future<ContentAttachment?> findById(String id) => delegate.findById(id);

  @override
  Future<List<ContentAttachment>> forOwner(AttachmentOwner owner) =>
      delegate.forOwner(owner);
}
