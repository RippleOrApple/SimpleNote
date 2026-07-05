import 'package:flutter/material.dart';

import '../../core/routing/app_routes.dart';

class AppShell extends StatelessWidget {
  const AppShell({
    required this.title,
    required this.child,
    super.key,
    this.actions,
    this.floatingActionButton,
  });

  final String title;
  final Widget child;
  final List<Widget>? actions;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), actions: actions),
      body: child,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex(context),
        onDestinationSelected: (index) {
          final route = switch (index) {
            0 => AppRoutes.home,
            1 => AppRoutes.todos,
            _ => AppRoutes.settings,
          };
          if (ModalRoute.of(context)?.settings.name != route) {
            Navigator.of(context).pushReplacementNamed(route);
          }
        },
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.note_outlined), label: 'Notes'),
          NavigationDestination(
            icon: Icon(Icons.check_circle_outline),
            label: 'Todos',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  int _selectedIndex(BuildContext context) {
    return switch (ModalRoute.of(context)?.settings.name) {
      AppRoutes.todos => 1,
      AppRoutes.settings => 2,
      _ => 0,
    };
  }
}
