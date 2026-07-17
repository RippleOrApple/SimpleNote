import 'package:flutter/material.dart';

import '../motion/app_motion.dart';
import '../../features/notes/presentation/notes_page.dart';
import '../../features/settings/presentation/settings_page.dart';
import '../../features/todos/presentation/todos_page.dart';

class AppRoutes {
  const AppRoutes._();

  static const home = '/';
  static const todos = '/todos';
  static const settings = '/settings';

  static Map<String, WidgetBuilder> get routes => {
        home: (_) => const NotesPage(),
        todos: (_) => const TodosPage(),
        settings: (_) => const SettingsPage(),
      };

  static Route<void> onGenerateRoute(
    RouteSettings settings, {
    Duration transitionDuration = AppMotion.standard,
  }) {
    final builder = routes[settings.name] ?? routes[home]!;

    return PageRouteBuilder<void>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
      transitionDuration: transitionDuration,
      reverseTransitionDuration: transitionDuration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curve = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );

        return FadeTransition(
          opacity: curve,
          child: child,
        );
      },
    );
  }
}
