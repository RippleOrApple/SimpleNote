import 'package:flutter/material.dart';

class SyncUpgradeNotice extends StatelessWidget {
  const SyncUpgradeNotice({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Semantics(
      key: const Key('sync-upgrade-notice'),
      container: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surfaceContainerLow,
          border: Border(
            left: BorderSide(color: colors.primary, width: 4),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.sync_disabled_outlined, color: colors.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '局域网同步正在升级',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'V2 任务、外观和正文图片无法由旧协议安全识别。'
                      'Phase 4 完成前，本版本不会开启旧同步服务；'
                      '所有本地功能仍可离线使用。',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
