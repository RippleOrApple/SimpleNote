import 'package:flutter/material.dart';

/// Temporary page wrapper retained while feature pages move to AdaptiveAppShell.
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
    if (AppShellEmbedScope.maybeOf(context)) {
      return child;
    }
    return Scaffold(
      appBar: AppBar(title: Text(title), actions: actions),
      body: SafeArea(child: child),
      floatingActionButton: floatingActionButton,
    );
  }
}

class AppShellEmbedScope extends InheritedWidget {
  const AppShellEmbedScope({required super.child, super.key});

  static bool maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppShellEmbedScope>() !=
        null;
  }

  @override
  bool updateShouldNotify(AppShellEmbedScope oldWidget) => false;
}
