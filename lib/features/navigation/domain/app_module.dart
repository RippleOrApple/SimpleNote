enum AppModuleKey {
  today,
  calendar,
  habits,
  notes,
  statistics,
  settings,
  more,
}

abstract final class AppModuleCatalog {
  static const android = <AppModuleKey>[
    AppModuleKey.today,
    AppModuleKey.calendar,
    AppModuleKey.habits,
    AppModuleKey.notes,
    AppModuleKey.more,
  ];

  static const windows = <AppModuleKey>[
    AppModuleKey.today,
    AppModuleKey.calendar,
    AppModuleKey.habits,
    AppModuleKey.notes,
    AppModuleKey.statistics,
    AppModuleKey.settings,
  ];

  static List<AppModuleKey> forPlatform(String platform) {
    return platform.trim().toLowerCase() == 'windows' ? windows : android;
  }

  static List<AppModuleKey> normalizeOrder(
    String platform,
    Iterable<String> savedKeys,
  ) {
    final catalog = forPlatform(platform);
    final catalogSet = catalog.toSet();
    final seen = <AppModuleKey>{};
    final normalized = <AppModuleKey>[];
    for (final savedKey in savedKeys) {
      final module = AppModuleKeyX.tryParse(savedKey);
      if (module != null && catalogSet.contains(module) && seen.add(module)) {
        normalized.add(module);
      }
    }
    for (final module in catalog) {
      if (seen.add(module)) {
        normalized.add(module);
      }
    }
    return normalized;
  }
}

extension AppModuleKeyX on AppModuleKey {
  String get label => switch (this) {
        AppModuleKey.today => '今天',
        AppModuleKey.calendar => '日历',
        AppModuleKey.habits => '习惯',
        AppModuleKey.notes => '笔记',
        AppModuleKey.statistics => '统计',
        AppModuleKey.settings => '设置',
        AppModuleKey.more => '更多',
      };

  static AppModuleKey? tryParse(String value) {
    final normalized = value.trim();
    for (final module in AppModuleKey.values) {
      if (module.name == normalized) {
        return module;
      }
    }
    return null;
  }
}
