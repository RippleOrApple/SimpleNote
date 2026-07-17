part of '../app_database.dart';

@DriftAccessor(
  tables: [CustomColors, BackgroundImages, DeviceAppearanceProfiles],
)
class AppearanceDao extends DatabaseAccessor<AppDatabase>
    with _$AppearanceDaoMixin {
  AppearanceDao(super.db);

  Future<List<CustomColorRow>> activeCustomColors() {
    return (select(customColors)
          ..where((entry) => entry.deletedAt.isNull())
          ..orderBy([
            (entry) => OrderingTerm.asc(entry.sortOrder),
            (entry) => OrderingTerm.asc(entry.createdAt),
            (entry) => OrderingTerm.asc(entry.id),
          ]))
        .get();
  }

  Future<CustomColorRow?> customColorById(String id) {
    return (select(customColors)..where((entry) => entry.id.equals(id)))
        .getSingleOrNull();
  }

  Future<void> upsertCustomColor(CustomColorsCompanion color) async {
    await into(customColors).insertOnConflictUpdate(color);
  }

  Future<List<BackgroundImageRow>> activeBackgroundImages() {
    return (select(backgroundImages)
          ..where((entry) => entry.deletedAt.isNull())
          ..orderBy([
            (entry) => OrderingTerm.asc(entry.createdAt),
            (entry) => OrderingTerm.asc(entry.id),
          ]))
        .get();
  }

  Future<BackgroundImageRow?> backgroundImageById(String id) {
    return (select(backgroundImages)..where((entry) => entry.id.equals(id)))
        .getSingleOrNull();
  }

  Future<BackgroundImageRow?> activeBackgroundImageByContent({
    required String sha256,
    required bool syncEnabled,
  }) {
    return (select(backgroundImages)
          ..where(
            (entry) =>
                entry.sha256.equals(sha256) &
                entry.syncEnabled.equals(syncEnabled) &
                entry.deletedAt.isNull(),
          ))
        .getSingleOrNull();
  }

  Future<List<BackgroundImageRow>> backgroundImagesBySha256(String sha256) {
    return (select(backgroundImages)
          ..where((entry) => entry.sha256.equals(sha256)))
        .get();
  }

  Future<void> upsertBackgroundImage(
    BackgroundImagesCompanion backgroundImage,
  ) async {
    await into(backgroundImages).insertOnConflictUpdate(backgroundImage);
  }

  Future<DeviceAppearanceProfileRow?> deviceProfileById(String id) {
    return (select(deviceAppearanceProfiles)
          ..where((profile) => profile.id.equals(id)))
        .getSingleOrNull();
  }

  Future<void> upsertDeviceProfile(
    DeviceAppearanceProfilesCompanion profile,
  ) async {
    await into(deviceAppearanceProfiles).insertOnConflictUpdate(profile);
  }
}
