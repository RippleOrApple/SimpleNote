import 'package:flutter/material.dart';

import '../domain/app_module.dart';

class PlaceholderModulePage extends StatelessWidget {
  const PlaceholderModulePage({required this.module, super.key});

  final AppModuleKey module;

  @override
  Widget build(BuildContext context) {
    final title = module.label;
    final message = switch (module) {
      AppModuleKey.today => '任务工作区将在 Task 10 完成。',
      AppModuleKey.calendar => '日历模块将在后续阶段完成。',
      AppModuleKey.habits => '习惯模块将在后续阶段完成。',
      AppModuleKey.statistics => '统计模块将在后续阶段完成。',
      AppModuleKey.more => '可从这里打开外观或设置。',
      AppModuleKey.notes || AppModuleKey.settings => '',
    };
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.hourglass_empty_outlined,
                  size: 42, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 16),
              Text(title, style: Theme.of(context).textTheme.headlineSmall),
              if (message.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(message, textAlign: TextAlign.center),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
