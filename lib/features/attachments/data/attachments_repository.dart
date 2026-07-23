import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;

import '../../../database/app_database.dart';
import '../domain/content_attachment.dart';

abstract interface class AttachmentsRepository {
  Future<List<ContentAttachment>> forOwner(AttachmentOwner owner);

  Future<ContentAttachment?> findById(String id);

  Future<void> commitImport({
    required ContentAttachment attachment,
    required String markdown,
    required int updatedAt,
  });

  Future<String> deleteAndDetach({
    required AttachmentOwner owner,
    required String attachmentId,
    required String currentMarkdown,
    required int updatedAt,
  });
}

class DriftAttachmentsRepository implements AttachmentsRepository {
  DriftAttachmentsRepository({
    required AppDatabase database,
    required Directory rootDirectory,
  })  : _database = database,
        _rootDirectory = rootDirectory {
    if (!p.isAbsolute(rootDirectory.path)) {
      throw ArgumentError.value(
        rootDirectory.path,
        'rootDirectory',
        '必须是绝对路径的应用支持目录。',
      );
    }
  }

  final AppDatabase _database;
  final Directory _rootDirectory;

  @override
  Future<List<ContentAttachment>> forOwner(AttachmentOwner owner) async {
    final rows = await _database.attachmentsDao.activeForOwner(
      owner.type.name,
      owner.id,
    );
    return rows.map(_fromRow).toList();
  }

  @override
  Future<ContentAttachment?> findById(String id) async {
    final row = await _database.attachmentsDao.findById(id);
    return row == null ? null : _fromRow(row);
  }

  @override
  Future<void> commitImport({
    required ContentAttachment attachment,
    required String markdown,
    required int updatedAt,
  }) {
    return _database.transaction(() async {
      await _updateOwnerMarkdown(
        attachment.owner,
        markdown: markdown,
        updatedAt: updatedAt,
      );
      await _database.attachmentsDao.insertAttachment(
        ContentAttachmentsCompanion.insert(
          id: attachment.id,
          ownerType: attachment.owner.type.name,
          ownerId: attachment.owner.id,
          sha256: attachment.sha256,
          mimeType: attachment.mimeType,
          byteSize: attachment.byteSize,
          width: attachment.width,
          height: attachment.height,
          relativePath: attachment.relativePath,
          thumbnailRelativePath: attachment.thumbnailRelativePath,
          sortOrder: Value(attachment.sortOrder),
          createdAt: attachment.createdAt,
          updatedAt: updatedAt,
          deletedAt: Value(attachment.deletedAt),
          deviceId: attachment.deviceId,
          version: Value(attachment.version),
        ),
      );
    });
  }

  @override
  Future<String> deleteAndDetach({
    required AttachmentOwner owner,
    required String attachmentId,
    required String currentMarkdown,
    required int updatedAt,
  }) {
    return _database.transaction(() async {
      final row = await _database.attachmentsDao.findById(attachmentId);
      if (row == null || row.deletedAt != null) {
        throw StateError('附件不存在或已删除。');
      }
      if (row.ownerType != owner.type.name || row.ownerId != owner.id) {
        throw StateError('附件不属于当前内容。');
      }
      final markdown = _removeAttachmentNode(currentMarkdown, attachmentId);
      if (markdown == currentMarkdown) {
        throw StateError('正文中不存在对应的附件引用。');
      }
      await _updateOwnerMarkdown(
        owner,
        markdown: markdown,
        updatedAt: updatedAt,
      );
      await _database.attachmentsDao.softDelete(
        attachmentId,
        updatedAt,
        row.version + 1,
      );
      return markdown;
    });
  }

  Future<void> _updateOwnerMarkdown(
    AttachmentOwner owner, {
    required String markdown,
    required int updatedAt,
  }) async {
    switch (owner.type) {
      case AttachmentOwnerType.note:
        final note = await _database.notesDao.findById(owner.id);
        if (note == null || note.deletedAt != null) {
          throw StateError('附件所属笔记不存在或已删除。');
        }
        await _database.notesDao.upsertNote(NotesCompanion(
          id: Value(note.id),
          title: Value(note.title),
          content: Value(markdown),
          createdAt: Value(note.createdAt),
          updatedAt: Value(updatedAt),
          deletedAt: Value(note.deletedAt),
          pinned: Value(note.pinned),
          deviceId: Value(note.deviceId),
          version: Value(note.version + 1),
        ));
      case AttachmentOwnerType.task:
        final task = await _database.tasksV2Dao.findById(owner.id);
        if (task == null || task.deletedAt != null) {
          throw StateError('附件所属任务不存在或已删除。');
        }
        await _database.tasksV2Dao.upsertTask(TasksV2Companion(
          id: Value(task.id),
          parentId: Value(task.parentId),
          listId: Value(task.listId),
          title: Value(task.title),
          descriptionMarkdown: Value(markdown),
          completed: Value(task.completed),
          priority: Value(task.priority),
          startAt: Value(task.startAt),
          dueAt: Value(task.dueAt),
          allDay: Value(task.allDay),
          sortOrder: Value(task.sortOrder),
          recurrenceRule: Value(task.recurrenceRule),
          recurrenceEndAt: Value(task.recurrenceEndAt),
          recurrenceCount: Value(task.recurrenceCount),
          completedAt: Value(task.completedAt),
          createdAt: Value(task.createdAt),
          updatedAt: Value(updatedAt),
          deletedAt: Value(task.deletedAt),
          deviceId: Value(task.deviceId),
          version: Value(task.version + 1),
        ));
    }
  }

  ContentAttachment _fromRow(ContentAttachmentRow row) => ContentAttachment(
        id: row.id,
        owner: AttachmentOwner(
          AttachmentOwnerType.values.byName(row.ownerType),
          row.ownerId,
        ),
        sha256: row.sha256,
        mimeType: row.mimeType,
        byteSize: row.byteSize,
        width: row.width,
        height: row.height,
        relativePath: row.relativePath,
        thumbnailRelativePath: row.thumbnailRelativePath,
        absolutePath: p.join(_rootDirectory.path, row.relativePath),
        thumbnailAbsolutePath:
            p.join(_rootDirectory.path, row.thumbnailRelativePath),
        sortOrder: row.sortOrder,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
        deletedAt: row.deletedAt,
        deviceId: row.deviceId,
        version: row.version,
      );
}

String _removeAttachmentNode(String markdown, String attachmentId) {
  final escapedId = RegExp.escape(attachmentId);
  final pattern = RegExp(
    '!\\[[^\\]\\r\\n]*\\]\\(attachment://$escapedId(?:\\s+"[^"]*")?\\)',
  );
  return markdown.replaceFirst(pattern, '');
}
