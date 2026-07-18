import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../infrastructure/attachment_picker.dart';

class PendingAttachmentRecoveryPrompt extends ConsumerStatefulWidget {
  const PendingAttachmentRecoveryPrompt({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<PendingAttachmentRecoveryPrompt> createState() =>
      _PendingAttachmentRecoveryPromptState();
}

class _PendingAttachmentRecoveryPromptState
    extends ConsumerState<PendingAttachmentRecoveryPrompt> {
  bool _shown = false;

  @override
  Widget build(BuildContext context) {
    final pending = ref.watch(pendingAttachmentRecoveryProvider);
    final files = pending.valueOrNull ?? const [];
    if (!_shown && files.isNotEmpty) {
      _shown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
            key: const Key('pending-attachment-recovery-prompt'),
            title: const Text('待导入图片'),
            content: Text(
              '发现 ${files.length} 张上次选择但尚未导入的图片。打开编辑器后可继续处理。',
            ),
            actions: [
              FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('知道了'),
              ),
            ],
          ),
        );
      });
    }
    return widget.child;
  }
}
