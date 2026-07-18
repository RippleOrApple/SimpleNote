import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'database/app_database.dart';
import 'features/sync/data/device_identity_repository.dart';
import 'features/sync/data/sync_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = AppDatabase();
  final device = await DeviceIdentityRepository(database).loadOrCreate();
  runApp(
    ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(database),
        deviceInfoProvider.overrideWithValue(device),
      ],
      child: const SimpleNoteApp(),
    ),
  );
}
