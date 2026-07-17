part of '../app_database.dart';

@DriftAccessor(tables: [ContentAttachments])
class AttachmentsDao extends DatabaseAccessor<AppDatabase>
    with _$AttachmentsDaoMixin {
  AttachmentsDao(super.db);
}
