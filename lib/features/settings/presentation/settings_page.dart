import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/app_shell.dart';
import '../application/theme_controller.dart';
import '../domain/theme_scheme.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeControllerProvider);

    return AppShell(
      title: 'Settings',
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('Theme', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              ListTile(
                leading: CircleAvatar(backgroundColor: theme.primaryColor),
                title: Text(theme.name),
                subtitle: const Text('Background, button, and text colors'),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: FilledButton.icon(
                  onPressed: () => ref
                      .read(themeControllerProvider.notifier)
                      .applyTheme(AppThemeScheme.minimalLight),
                  icon: const Icon(Icons.restart_alt),
                  label: const Text('Restore default theme'),
                ),
              ),
              const Divider(height: 36),
              Text('Sync', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              const ListTile(
                leading: Icon(Icons.wifi_tethering_outlined),
                title: Text('LAN sync'),
                subtitle: Text('Server and client files are scaffolded.'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
