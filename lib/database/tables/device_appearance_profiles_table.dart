// ignore_for_file: recursive_getters

import 'package:drift/drift.dart';

@DataClassName('DeviceAppearanceProfileRow')
class DeviceAppearanceProfiles extends Table {
  @override
  String get tableName => 'device_appearance_profiles';

  TextColumn get id => text()();
  TextColumn get platform => text()();
  TextColumn get density => text()();
  TextColumn get navOrderJson => text().named('nav_order_json')();
  TextColumn get hiddenNavJson => text().named('hidden_nav_json')();
  TextColumn get startModule => text().named('start_module')();
  TextColumn get localBackgroundImageId =>
      text().named('local_background_image_id').nullable()();
  RealColumn get backgroundFocusX => real()
      .named('background_focus_x')
      .check(backgroundFocusX.isBetweenValues(0, 1))();
  RealColumn get backgroundFocusY => real()
      .named('background_focus_y')
      .check(backgroundFocusY.isBetweenValues(0, 1))();
  RealColumn get backgroundZoom => real()
      .named('background_zoom')
      .check(backgroundZoom.isBiggerThanValue(0))();
  RealColumn get backgroundBlur => real()
      .named('background_blur')
      .check(backgroundBlur.isBiggerOrEqualValue(0))();
  RealColumn get backgroundOverlay => real().named('background_overlay')();
  TextColumn get hapticsMode => text().named('haptics_mode')();
  IntColumn get updatedAt => integer().named('updated_at')();

  @override
  Set<Column> get primaryKey => {id};
}
