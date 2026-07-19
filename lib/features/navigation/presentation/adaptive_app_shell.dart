import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/app_shell_embed_scope.dart';
import '../../../shared/widgets/frosted_surface.dart';
import '../../calendar/presentation/calendar_page.dart';
import '../../habits/presentation/habits_page.dart';
import '../../notes/presentation/notes_page.dart';
import '../../settings/presentation/settings_page.dart';
import '../../statistics/presentation/statistics_page.dart';
import '../../sync/data/sync_repository.dart';
import '../../tasks/presentation/tasks_page.dart';
import '../application/navigation_controller.dart';
import '../domain/app_module.dart';
import 'rounded_icon_navigation.dart';

class AdaptiveAppShell extends ConsumerStatefulWidget {
  const AdaptiveAppShell(
      {this.initialModule, this.moduleBuilders = const {}, super.key});

  final AppModuleKey? initialModule;
  final Map<AppModuleKey, WidgetBuilder> moduleBuilders;

  @override
  ConsumerState<AdaptiveAppShell> createState() => _AdaptiveAppShellState();
}

class _AdaptiveAppShellState extends ConsumerState<AdaptiveAppShell> {
  @override
  void initState() {
    super.initState();
    if (widget.initialModule != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ref.read(navigationControllerProvider.notifier).select(
                widget.initialModule!,
              );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final navigation = ref.watch(navigationControllerProvider);
    final modules = navigation.visibleModules;
    final selected = navigation.navigationSelection;
    final device = ref.watch(deviceInfoProvider);
    final isWide =
        device.platform == 'windows' || MediaQuery.sizeOf(context).width >= 920;
    final pages = [
      for (final module in navigation.catalog) _modulePage(module)
    ];
    final selectedIndex = navigation.catalog.indexOf(selected);
    final onSelected = ref.read(navigationControllerProvider.notifier).select;

    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            if (isWide)
              Padding(
                padding: const EdgeInsets.all(12),
                child: FrostedSurface(
                  glassOpacity: 0.72,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Container(
                    key: const Key('windows-functional-rail'),
                    child: RoundedIconNavigationRail(
                      modules: modules,
                      selected: selected,
                      onSelected: onSelected,
                    ),
                  ),
                ),
              ),
            Expanded(
              child: AppShellEmbedScope(
                child: IndexedStack(
                  index: selectedIndex < 0 ? 0 : selectedIndex,
                  children: pages,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: isWide
          ? null
          : RoundedIconNavigationBar(
              modules: modules,
              selected: selected,
              onSelected: onSelected,
            ),
    );
  }

  Widget _modulePage(AppModuleKey module) {
    final builder = widget.moduleBuilders[module];
    if (builder != null) return Builder(builder: builder);
    return switch (module) {
      AppModuleKey.today => const TasksPage(),
      AppModuleKey.calendar => const CalendarPage(),
      AppModuleKey.habits => const HabitsPage(),
      AppModuleKey.notes => const NotesPage(),
      AppModuleKey.statistics => const StatisticsPage(),
      AppModuleKey.settings => const SettingsPage(),
      AppModuleKey.more => const SettingsPage(),
    };
  }
}
