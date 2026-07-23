import 'dart:io';
import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:simple_note/database/app_database.dart';
import 'package:simple_note/features/attachments/application/attachment_import_service.dart';
import 'package:simple_note/features/attachments/data/attachments_repository.dart';
import 'package:simple_note/features/attachments/domain/content_attachment.dart';
import 'package:simple_note/features/attachments/infrastructure/attachment_file_store.dart';
import 'package:simple_note/features/attachments/infrastructure/attachment_picker.dart';
import 'package:simple_note/features/notes/application/notes_controller.dart';
import 'package:simple_note/shared/models/markdown_edit.dart';

void main() {
  late _Harness harness;

  setUp(() async {
    harness = await _Harness.create();
  });

  tearDown(() => harness.dispose());

  test('inserts and deletes an inline image without changing createdAt',
      () async {
    final controller = harness.controller;
    await controller.createNote();
    final before = (await harness.state).selectedNote!;

    harness.picker.result = _pngFile();
    final edit = await controller.insertImage(
      AttachmentPickSource.files,
      const MarkdownSelection(baseOffset: 0, extentOffset: 0),
      altText: 'diagram',
    );

    final inserted = (await harness.state).selectedNote!;
    expect(edit, isNotNull);
    expect(inserted.content, matches(r'^!\[diagram\]\(attachment://[^)]+\)$'));
    expect(edit!.markdown, inserted.content);
    expect(inserted.createdAt, before.createdAt);
    expect(inserted.updatedAt, greaterThanOrEqualTo(before.updatedAt));
    expect(inserted.version, before.version + 1);
    expect((await harness.state).saveStatus, NoteSaveStatus.saved);

    final attachments = await harness.repository.forOwner(
      AttachmentOwner(AttachmentOwnerType.note, inserted.id),
    );
    final attachment = attachments.single;
    expect(await controller.resolveAttachment(attachment.id), isNotNull);
    expect(File(attachment.absolutePath).existsSync(), isTrue);
    expect(File(attachment.thumbnailAbsolutePath).existsSync(), isTrue);

    await controller.deleteImage(attachment.id);

    final deleted = (await harness.state).selectedNote!;
    expect(deleted.content, isEmpty);
    expect(deleted.createdAt, before.createdAt);
    expect(deleted.version, inserted.version + 1);
    expect((await harness.state).saveStatus, NoteSaveStatus.saved);
    expect(
      (await harness.repository.findById(attachment.id))?.deletedAt,
      isNotNull,
    );
    expect(File(attachment.absolutePath).existsSync(), isTrue);
    expect(File(attachment.thumbnailAbsolutePath).existsSync(), isTrue);
  });

  test('picker cancellation leaves note state and timestamps unchanged',
      () async {
    final controller = harness.controller;
    await controller.createNote();
    final before = (await harness.state).selectedNote!;

    harness.picker.result = null;
    final edit = await controller.insertImage(
      AttachmentPickSource.files,
      const MarkdownSelection(baseOffset: 0, extentOffset: 0),
      altText: 'cancelled',
    );

    final state = await harness.state;
    final after = state.selectedNote!;
    expect(edit, isNull);
    expect(after.content, before.content);
    expect(after.createdAt, before.createdAt);
    expect(after.updatedAt, before.updatedAt);
    expect(after.version, before.version);
    expect(state.saveStatus, NoteSaveStatus.idle);
    expect(
      await harness.repository.forOwner(
        AttachmentOwner(AttachmentOwnerType.note, before.id),
      ),
      isEmpty,
    );
  });

  test('imports recovered images only after an explicit controller action',
      () async {
    final controller = harness.controller;
    await controller.createNote();

    await controller.importRecoveredImages([_pngFile()]);

    final state = await harness.state;
    expect(
      state.selectedNote!.content,
      matches(r'^!\[恢复的图片\]\(attachment://[^)]+\)$'),
    );
    expect(state.saveStatus, NoteSaveStatus.saved);
  });

  test('failed import preserves note content and exposes failed status',
      () async {
    final controller = harness.controller;
    await controller.createNote();
    final noteId = (await harness.state).selectedNote!.id;
    await controller.updateNote(noteId, content: 'Keep this text');
    final before = (await harness.state).selectedNote!;

    harness.picker.result = XFile.fromData(
      Uint8List.fromList([1, 2, 3]),
      name: 'invalid.png',
      mimeType: 'image/png',
    );
    final edit = await controller.insertImage(
      AttachmentPickSource.files,
      MarkdownSelection(
        baseOffset: before.content.length,
        extentOffset: before.content.length,
      ),
      altText: 'invalid',
    );

    final state = await harness.state;
    expect(edit, isNull);
    expect(state.selectedNote!.content, before.content);
    expect(state.selectedNote!.updatedAt, before.updatedAt);
    expect(state.selectedNote!.version, before.version);
    expect(state.saveStatus, NoteSaveStatus.failed);
    expect(state.errorMessage, isNotEmpty);
  });
}

class _Harness {
  const _Harness({
    required this.container,
    required this.database,
    required this.root,
    required this.repository,
    required this.picker,
  });

  final ProviderContainer container;
  final AppDatabase database;
  final Directory root;
  final DriftAttachmentsRepository repository;
  final _FakeAttachmentPicker picker;

  NotesController get controller =>
      container.read(notesControllerProvider.notifier);
  Future<NotesState> get state =>
      container.read(notesControllerProvider.future);

  static Future<_Harness> create() async {
    final database = AppDatabase(NativeDatabase.memory());
    final root = Directory.systemTemp.createTempSync('note-inline-image-');
    final repository = DriftAttachmentsRepository(
      database: database,
      rootDirectory: root,
    );
    final service = AttachmentImportService(
      repository: repository,
      fileStore: AttachmentFileStore(rootDirectory: root),
      deviceId: 'note-inline-image-device',
    );
    final picker = _FakeAttachmentPicker();
    final container = ProviderContainer(overrides: [
      appDatabaseProvider.overrideWithValue(database),
      attachmentPickerProvider.overrideWithValue(picker),
      attachmentImportServiceProvider.overrideWith((ref) async => service),
    ]);
    await container.read(notesControllerProvider.future);
    return _Harness(
      container: container,
      database: database,
      root: root,
      repository: repository,
      picker: picker,
    );
  }

  Future<void> dispose() async {
    container.dispose();
    await database.close();
    if (root.existsSync()) root.deleteSync(recursive: true);
  }
}

class _FakeAttachmentPicker implements AttachmentPicker {
  XFile? result;

  @override
  Future<XFile?> pick(AttachmentPickSource source) async => result;

  @override
  Future<List<XFile>> recoverLostImages() async => const [];
}

XFile _pngFile() => XFile.fromData(
      Uint8List.fromList(
        img.encodePng(img.Image(width: 80, height: 40)),
      ),
      name: 'diagram.png',
      mimeType: 'image/png',
    );
