import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../domain/app_module.dart';

IconData _iconFor(AppModuleKey module, {required bool selected}) {
  return switch (module) {
    AppModuleKey.today => selected
        ? PhosphorIconsFill.checkSquare
        : PhosphorIconsRegular.checkSquare,
    AppModuleKey.calendar =>
      selected ? PhosphorIconsFill.calendar : PhosphorIconsRegular.calendar,
    AppModuleKey.habits =>
      selected ? PhosphorIconsFill.flower : PhosphorIconsRegular.flower,
    AppModuleKey.notes =>
      selected ? PhosphorIconsFill.note : PhosphorIconsRegular.note,
    AppModuleKey.statistics =>
      selected ? PhosphorIconsFill.chartBar : PhosphorIconsRegular.chartBar,
    AppModuleKey.settings =>
      selected ? PhosphorIconsFill.gear : PhosphorIconsRegular.gear,
    AppModuleKey.more =>
      selected ? PhosphorIconsFill.dotsThree : PhosphorIconsRegular.dotsThree,
  };
}

class RoundedIconNavigationBar extends StatelessWidget {
  const RoundedIconNavigationBar({
    required this.modules,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final List<AppModuleKey> modules;
  final AppModuleKey selected;
  final ValueChanged<AppModuleKey> onSelected;

  @override
  Widget build(BuildContext context) {
    final selectedIndex =
        modules.indexOf(selected).clamp(0, modules.length - 1);
    return NavigationBar(
      selectedIndex: selectedIndex,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      onDestinationSelected: (index) => onSelected(modules[index]),
      destinations: [
        for (final module in modules)
          _IconNavigationDestination(
            key: Key('android-nav-${module.name}'),
            module: module,
            selected: module == selected,
            onPressed: () => onSelected(module),
          ),
      ],
    );
  }
}

class _IconNavigationDestination extends StatelessWidget {
  const _IconNavigationDestination({
    required this.module,
    required this.selected,
    required this.onPressed,
    super.key,
  });

  final AppModuleKey module;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: module.label,
      button: true,
      child: Tooltip(
        message: module.label,
        child: InkWell(
          onTap: onPressed,
          child: SizedBox.square(
            dimension: 48,
            child: Center(
              child: PhosphorIcon(
                _iconFor(module, selected: selected),
                size: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RoundedIconNavigationRail extends StatelessWidget {
  const RoundedIconNavigationRail({
    required this.modules,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final List<AppModuleKey> modules;
  final AppModuleKey selected;
  final ValueChanged<AppModuleKey> onSelected;

  @override
  Widget build(BuildContext context) {
    final selectedIndex =
        modules.indexOf(selected).clamp(0, modules.length - 1);
    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) => onSelected(modules[index]),
      labelType: NavigationRailLabelType.all,
      minWidth: 88,
      destinations: [
        for (final module in modules)
          NavigationRailDestination(
            icon: PhosphorIcon(_iconFor(module, selected: false), size: 24),
            selectedIcon:
                PhosphorIcon(_iconFor(module, selected: true), size: 24),
            label: Text(module.label),
          ),
      ],
    );
  }
}
