import 'package:drift/drift.dart';

@DataClassName('NoteTagRow')
class NoteTags extends Table {
  @override
  String get tableName => 'note_tags';

  TextColumn get noteId => text().named('note_id')();
  TextColumn get tagId => text().named('tag_id')();
  IntColumn get createdAt => integer().named('created_at')();

  @override
  Set<Column> get primaryKey => {noteId, tagId};
}
