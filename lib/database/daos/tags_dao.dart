part of '../app_database.dart';

@DriftAccessor(tables: [Tags])
class TagsDao extends DatabaseAccessor<AppDatabase> with _$TagsDaoMixin {
  TagsDao(super.db);

  Future<List<TagRow>> activeTags() {
    return (select(tags)
          ..where((tag) => tag.deletedAt.isNull())
          ..orderBy([(tag) => OrderingTerm.asc(tag.name)]))
        .get();
  }

  Future<List<TagRow>> allTags() {
    return select(tags).get();
  }

  Future<TagRow?> findById(String id) {
    return (select(tags)..where((tag) => tag.id.equals(id))).getSingleOrNull();
  }

  Future<TagRow?> findByName(String name) {
    return (select(tags)
          ..where((tag) => tag.deletedAt.isNull() & tag.name.equals(name)))
        .getSingleOrNull();
  }

  Future<void> upsertTag(TagsCompanion tag) {
    return into(tags).insertOnConflictUpdate(tag);
  }

  Future<void> softDeleteTag(String id, int deletedAt) {
    return (update(tags)..where((tag) => tag.id.equals(id))).write(
      TagsCompanion(
        deletedAt: Value(deletedAt),
        updatedAt: Value(deletedAt),
      ),
    );
  }
}
