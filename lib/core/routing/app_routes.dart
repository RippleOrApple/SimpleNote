import 'package:flutter/material.dart';

import '../../features/navigation/domain/app_module.dart';
import '../../features/navigation/presentation/adaptive_app_shell.dart';
import '../motion/app_motion.dart';

class AppRoutes {
  const AppRoutes._();

  static const home = '/';
  static const todos = '/todos';
  static const notes = '/notes';
  static const settings = '/settings';

  static Map<String, WidgetBuilder> get routes => {
        todos: (_) => const AdaptiveAppShell(),
        notes: (_) => const AdaptiveAppShell(initialModule: AppModuleKey.notes),
        settings: (_) =>
            const AdaptiveAppShell(initialModule: AppModuleKey.settings),
      };

  static Route<void> onGenerateRoute(
    RouteSettings settings, {
    Duration transitionDuration = AppMotion.standard,
  }) {
    return PageRouteBuilder<void>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) {
        final initialModule = switch (settings.name) {
          AppRoutes.notes => AppModuleKey.notes,
          AppRoutes.settings => AppModuleKey.settings,
          _ => AppModuleKey.today,
        };
        return AdaptiveAppShell(
          initialModule: initialModule,
          key: ValueKey(initialModule),
        );
      },
      transitionDuration: transitionDuration,
      reverseTransitionDuration: transitionDuration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curve = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        return FadeTransition(opacity: curve, child: child);
      },
    );
  }
}
