import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../navigation/application/navigation_controller.dart';
import '../../navigation/domain/app_module.dart';

class NavigationSettingsSection extends ConsumerWidget {
  const NavigationSettingsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(navigationControllerProvider);
    final controller = ref.read(navigationControllerProvider.notifier);
    final visible = state.visibleModules;
    final hidden = state.order.where(state.hiddenModules.contains).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('导航', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        const Text('调整顺序、显示状态和默认打开模块。'),
        const SizedBox(height: 12),
        _NavigationGroup(
          title: '显示',
          modules: visible,
          state: state,
          controller: controller,
        ),
        const SizedBox(height: 16),
        _NavigationGroup(
          title: '隐藏',
          modules: hidden,
          state: state,
          controller: controller,
        ),
      ],
    );
  }
}

class _NavigationGroup extends StatelessWidget {
  const _NavigationGroup({
    required this.title,
    required this.modules,
    required this.state,
    required this.controller,
  });

  final String title;
  final List<AppModuleKey> modules;
  final NavigationState state;
  final NavigationController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 4),
        ReorderableListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: modules.length,
          onReorderItem: (oldIndex, newIndex) {
            final next = [...modules];
            next.insert(newIndex, next.removeAt(oldIndex));
            controller.reorder([
              ...next,
              ...state.order.where((module) => !next.contains(module)),
            ]);
          },
          itemBuilder: (context, index) {
            final module = modules[index];
            final isHidden = state.hiddenModules.contains(module);
            return ListTile(
              key: Key('nav-editor-${module.name}'),
              title: Text(module.label),
              leading: const Icon(Icons.drag_handle),
              trailing: Wrap(
                spacing: 4,
                children: [
                  IconButton(
                    key: Key('nav-default-${module.name}'),
                    tooltip: '设为默认',
                    onPressed: isHidden
                        ? null
                        : () => controller.setStartModule(module),
                    icon: Icon(state.startModule == module
                        ? Icons.star
                        : Icons.star_border),
                  ),
                  IconButton(
                    key: Key('nav-hide-${module.name}'),
                    tooltip: isHidden ? '显示模块' : '隐藏模块',
                    onPressed: module == AppModuleKey.today
                        ? null
                        : () => controller.setHidden(module, !isHidden),
                    icon: Icon(isHidden
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
