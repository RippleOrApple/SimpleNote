import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/utils/id_generator.dart';
import '../../../core/utils/time.dart';
import '../../../database/app_database.dart';
import '../../../shared/models/markdown_edit.dart';
import '../../sync/data/sync_repository.dart';
import '../data/attachments_repository.dart';
import '../domain/content_attachment.dart';
import '../infrastructure/attachment_file_store.dart';

final attachmentSupportDirectoryProvider = FutureProvider<Directory>((ref) {
  return getApplicationSupportDirectory();
});

final attachmentImportServiceProvider =
    FutureProvider<AttachmentImportService>((ref) async {
  final root = await ref.watch(attachmentSupportDirectoryProvider.future);
  return AttachmentImportService(
    repository: DriftAttachmentsRepository(
      database: ref.watch(appDatabaseProvider),
      rootDirectory: root,
    ),
    fileStore: AttachmentFileStore(rootDirectory: root),
    deviceId: ref.watch(deviceInfoProvider).deviceId,
  );
});

final class AttachmentImportResult {
  const AttachmentImportResult({
    required this.attachment,
    required this.markdown,
    required this.selection,
  });

  final ContentAttachment attachment;
  final String markdown;
  final MarkdownSelection selection;

  MarkdownEditResult get edit => MarkdownEditResult(
        markdown: markdown,
        selection: selection,
      );
}

final class AttachmentImportService {
  const AttachmentImportService({
    required AttachmentsRepository repository,
    required AttachmentFileStore fileStore,
    required String deviceId,
  })  : _repository = repository,
        _fileStore = fileStore,
        _deviceId = deviceId;

  final AttachmentsRepository _repository;
  final AttachmentFileStore _fileStore;
  final String _deviceId;

  Future<ContentAttachment?> resolveAttachment(String id) {
    return _repository.findById(id);
  }

  Future<AttachmentImportResult> importAndAttach({
    required AttachmentOwner owner,
    required AttachmentInput input,
    required String currentMarkdown,
    required MarkdownSelection selection,
    required String altText,
  }) async {
    final staged = await _fileStore.stage(input);
    final now = Clock.nowMillis();
    final id = IdGenerator.create();
    final edit = _insertImage(
      currentMarkdown,
      selection,
      attachmentId: id,
      altText: altText,
    );
    try {
      final existing = await _repository.forOwner(owner);
      final attachment = ContentAttachment(
        id: id,
        owner: owner,
        sha256: staged.sha256,
        mimeType: staged.mimeType,
        byteSize: staged.byteSize,
        width: staged.width,
        height: staged.height,
        relativePath: staged.relativePath,
        thumbnailRelativePath: staged.thumbnailRelativePath,
        absolutePath: staged.absolutePath,
        thumbnailAbsolutePath: staged.thumbnailAbsolutePath,
        sortOrder: existing.length,
        createdAt: now,
        updatedAt: now,
        deviceId: _deviceId,
      );
      await _repository.commitImport(
        attachment: attachment,
        markdown: edit.markdown,
        updatedAt: now,
      );
      await staged.commit();
      return AttachmentImportResult(
        attachment: attachment,
        markdown: edit.markdown,
        selection: edit.selection,
      );
    } catch (error, stackTrace) {
      await staged.rollback();
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<MarkdownEditResult> deleteAndDetach({
    required AttachmentOwner owner,
    required String attachmentId,
    required String currentMarkdown,
    required MarkdownSelection selection,
  }) async {
    final markdown = await _repository.deleteAndDetach(
      owner: owner,
      attachmentId: attachmentId,
      currentMarkdown: currentMarkdown,
      updatedAt: Clock.nowMillis(),
    );
    return MarkdownEditResult(
      markdown: markdown,
      selection: selection.clamp(markdown.length),
    );
  }
}

MarkdownEditResult _insertImage(
  String markdown,
  MarkdownSelection selection, {
  required String attachmentId,
  required String altText,
}) {
  final clamped = selection.clamp(markdown.length);
  final start = clamped.baseOffset < clamped.extentOffset
      ? clamped.baseOffset
      : clamped.extentOffset;
  final end = clamped.baseOffset > clamped.extentOffset
      ? clamped.baseOffset
      : clamped.extentOffset;
  final safeAlt = altText.replaceAll(RegExp(r'[\]\r\n]'), ' ').trim();
  final node = '![$safeAlt](attachment://$attachmentId)';
  final updated = markdown.replaceRange(start, end, node);
  final caret = start + node.length;
  return MarkdownEditResult(
    markdown: updated,
    selection: MarkdownSelection(baseOffset: caret, extentOffset: caret),
  );
}
