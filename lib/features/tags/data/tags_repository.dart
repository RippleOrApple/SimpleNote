import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../database/app_database.dart';
import '../domain/tag.dart';

final tagsRepositoryProvider = Provider<TagsRepository>((ref) {
  return DriftTagsRepository(ref.watch(appDatabaseProvider));
});

abstract class TagsRepository {
  Future<List<Tag>> watchActiveTags();
  Future<void> upsert(Tag tag);
  Future<void> softDelete(String id, int deletedAt);
}

class DriftTagsRepository implements TagsRepository {
  const DriftTagsRepository(this._database);

  final AppDatabase _database;

  @override
  Future<List<Tag>> watchActiveTags() async {
    final rows = await _database.tagsDao.activeTags();
    return rows.map(_fromRow).toList();
  }

  @override
  Future<void> upsert(Tag tag) {
    return _database.tagsDao.upsertTag(_toCompanion(tag));
  }

  @override
  Future<void> softDelete(String id, int deletedAt) {
    return _database.tagsDao.softDeleteTag(id, deletedAt);
  }

  TagsCompanion _toCompanion(Tag tag) {
    return TagsCompanion(
      id: Value(tag.id),
      name: Value(tag.name),
      color: Value(tag.color),
      createdAt: Value(tag.createdAt),
      updatedAt: Value(tag.updatedAt),
      deletedAt: Value(tag.deletedAt),
      deviceId: Value(tag.deviceId),
    );
  }

  Tag _fromRow(TagRow row) {
    return Tag(
      id: row.id,
      name: row.name,
      color: row.color,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      deletedAt: row.deletedAt,
      deviceId: row.deviceId,
    );
  }
}
