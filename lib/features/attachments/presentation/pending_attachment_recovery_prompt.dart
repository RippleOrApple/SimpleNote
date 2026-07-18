import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../notes/application/notes_controller.dart';
import '../../tasks/application/tasks_controller.dart';
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
  bool _dismissed = false;

  @override
  Widget build(BuildContext context) {
    final pending = ref.watch(pendingAttachmentRecoveryProvider);
    final files = pending.valueOrNull ?? const <XFile>[];
    if (_dismissed || files.isEmpty) return widget.child;

    final notes = ref.watch(notesControllerProvider).valueOrNull;
    final tasks = ref.watch(tasksControllerProvider).valueOrNull;
    return Column(
      children: [
        MaterialBanner(
          key: const Key('pending-attachment-recovery-prompt'),
          content: Text('发现 ${files.length} 张待导入图片。请选择要附加的当前内容。'),
          actions: [
            if (notes?.selectedNote != null)
              TextButton(
                key: const Key('recover-images-to-note'),
                onPressed: () => _importToNote(files),
                child: Text('笔记：${notes!.selectedNote!.title}'),
              ),
            if (tasks?.selectedTask != null)
              TextButton(
                key: const Key('recover-images-to-task'),
                onPressed: () => _importToTask(files),
                child: Text('任务：${tasks!.selectedTask!.title}'),
              ),
            TextButton(
              key: const Key('dismiss-recovered-images'),
              onPressed: () => setState(() => _dismissed = true),
              child: const Text('稍后'),
            ),
          ],
        ),
        Expanded(child: widget.child),
      ],
    );
  }

  Future<void> _importToNote(List<XFile> files) async {
    setState(() => _dismissed = true);
    await ref
        .read(notesControllerProvider.notifier)
        .importRecoveredImages(files);
  }

  Future<void> _importToTask(List<XFile> files) async {
    setState(() => _dismissed = true);
    await ref
        .read(tasksControllerProvider.notifier)
        .importRecoveredImages(files);
  }
}
