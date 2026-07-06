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

  static const _wideLayoutBreakpoint = 720.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= _wideLayoutBreakpoint;
        final selectedIndex = _selectedIndex(context);

        return Scaffold(
          appBar: AppBar(
            title: Text(title),
            actions: actions,
            centerTitle: !isWide,
          ),
          body: SafeArea(
            child: isWide
                ? Row(
                    children: [
                      NavigationRail(
                        selectedIndex: selectedIndex,
                        onDestinationSelected: (index) =>
                            _navigateToIndex(context, index),
                        labelType: NavigationRailLabelType.all,
                        minWidth: 96,
                        destinations: _railDestinations,
                      ),
                      const VerticalDivider(width: 1),
                      Expanded(child: child),
                    ],
                  )
                : child,
          ),
          floatingActionButton: floatingActionButton,
          bottomNavigationBar: isWide
              ? null
              : NavigationBar(
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (index) =>
                      _navigateToIndex(context, index),
                  destinations: _barDestinations,
                ),
        );
      },
    );
  }

  List<NavigationDestination> get _barDestinations => const [
        NavigationDestination(
          icon: Icon(Icons.note_outlined),
          selectedIcon: Icon(Icons.note),
          label: 'Notes',
        ),
        NavigationDestination(
          icon: Icon(Icons.check_circle_outline),
          selectedIcon: Icon(Icons.check_circle),
          label: 'Todos',
        ),
        NavigationDestination(
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ];

  List<NavigationRailDestination> get _railDestinations => const [
        NavigationRailDestination(
          icon: Icon(Icons.note_outlined),
          selectedIcon: Icon(Icons.note),
          label: Text('Notes'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.check_circle_outline),
          selectedIcon: Icon(Icons.check_circle),
          label: Text('Todos'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings),
          label: Text('Settings'),
        ),
      ];

  void _navigateToIndex(BuildContext context, int index) {
    final route = switch (index) {
      0 => AppRoutes.home,
      1 => AppRoutes.todos,
      _ => AppRoutes.settings,
    };
    if (ModalRoute.of(context)?.settings.name != route) {
      Navigator.of(context).pushReplacementNamed(route);
    }
  }

  int _selectedIndex(BuildContext context) {
    return switch (ModalRoute.of(context)?.settings.name) {
      AppRoutes.todos => 1,
      AppRoutes.settings => 2,
      _ => 0,
    };
  }
}