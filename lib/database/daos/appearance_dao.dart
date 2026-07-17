part of '../app_database.dart';

@DriftAccessor(
  tables: [CustomColors, BackgroundImages, DeviceAppearanceProfiles],
)
class AppearanceDao extends DatabaseAccessor<AppDatabase>
    with _$AppearanceDaoMixin {
  AppearanceDao(super.db);
}
