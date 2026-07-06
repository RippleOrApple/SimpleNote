import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/routing/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'features/settings/application/theme_controller.dart';
import 'features/settings/domain/theme_scheme.dart';

class SimpleNoteApp extends ConsumerWidget {
  const SimpleNoteApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeScheme = ref.watch(themeControllerProvider);

    return MaterialApp(
      title: '简记',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.fromScheme(
        themeScheme.valueOrNull?.activeTheme ?? AppThemeScheme.minimalLight,
      ),
      initialRoute: AppRoutes.home,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
