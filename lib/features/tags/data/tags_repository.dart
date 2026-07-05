import '../domain/tag.dart';

abstract class TagsRepository {
  Future<List<Tag>> watchActiveTags();
  Future<void> upsert(Tag tag);
  Future<void> softDelete(String id, int deletedAt);
}
