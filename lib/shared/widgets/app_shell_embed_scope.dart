import 'package:flutter/widgets.dart';

class AppShellEmbedScope extends InheritedWidget {
  const AppShellEmbedScope({required super.child, super.key});

  static bool maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppShellEmbedScope>() !=
        null;
  }

  @override
  bool updateShouldNotify(AppShellEmbedScope oldWidget) => false;
}
