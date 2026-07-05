import 'package:flutter/material.dart';

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
}
