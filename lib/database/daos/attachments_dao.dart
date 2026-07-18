part of '../app_database.dart';

@DriftAccessor(tables: [ContentAttachments])
class AttachmentsDao extends DatabaseAccessor<AppDatabase>
    with _$AttachmentsDaoMixin {
  AttachmentsDao(super.db);

  Future<List<ContentAttachmentRow>> activeForOwner(
    String ownerType,
    String ownerId,
  ) {
    return (select(contentAttachments)
          ..where((row) =>
              row.ownerType.equals(ownerType) &
              row.ownerId.equals(ownerId) &
              row.deletedAt.isNull())
          ..orderBy([(row) => OrderingTerm.asc(row.sortOrder)]))
        .get();
  }

  Future<ContentAttachmentRow?> findById(String id) {
    return (select(contentAttachments)..where((row) => row.id.equals(id)))
        .getSingleOrNull();
  }

  Future<void> insertAttachment(ContentAttachmentsCompanion attachment) {
    return into(contentAttachments).insert(attachment);
  }

  Future<void> softDelete(String id, int deletedAt, int version) {
    return (update(contentAttachments)..where((row) => row.id.equals(id)))
        .write(ContentAttachmentsCompanion(
      deletedAt: Value(deletedAt),
      updatedAt: Value(deletedAt),
      version: Value(version),
    ));
  }
}
