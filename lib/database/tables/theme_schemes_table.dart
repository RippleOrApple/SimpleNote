import 'package:drift/drift.dart';

@DataClassName('ThemeSchemeRow')
class ThemeSchemes extends Table {
  @override
  String get tableName => 'theme_schemes';

  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get backgroundColor => integer().named('background_color')();
  IntColumn get primaryColor => integer().named('primary_color')();
  IntColumn get textColor => integer().named('text_color')();
  IntColumn get surfaceColor => integer().named('surface_color')();
  TextColumn get brightness => text().withDefault(const Constant('light'))();
  IntColumn get createdAt => integer().named('created_at')();
  IntColumn get updatedAt => integer().named('updated_at')();
  BoolColumn get isActive =>
      boolean().named('is_active').withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
