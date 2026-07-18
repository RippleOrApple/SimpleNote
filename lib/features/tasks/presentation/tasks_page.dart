import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/app_shell_embed_scope.dart';
import '../application/tasks_controller.dart';
import 'task_detail_pane.dart';
import 'task_list_pane.dart';
import 'task_sources_pane.dart';

const compactBreakpoint = 600.0;
const desktopBreakpoint = 920.0;
const fullWorkspaceBreakpoint = 1180.0;

class TasksPage extends ConsumerWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(tasksControllerProvider);
    return state.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('任务加载失败：$error')),
      data: (value) => _TasksWorkspace(
        state: value,
        controller: ref.read(tasksControllerProvider.notifier),
      ),
    );
  }
}

class _TasksWorkspace extends StatelessWidget {
  const _TasksWorkspace({required this.state, required this.controller});

  final TasksState state;
  final TasksController controller;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final workspaceWidth =
            width + (AppShellEmbedScope.maybeOf(context) ? 112 : 0);
        if (workspaceWidth >= fullWorkspaceBreakpoint) {
          return Row(
            children: [
              SizedBox(
                width: 248,
                child: TaskSourcesPane(state: state, controller: controller),
              ),
              const VerticalDivider(width: 1),
              SizedBox(
                width: 360,
                child: TaskListPane(state: state, controller: controller),
              ),
              const VerticalDivider(width: 1),
              Expanded(
                child: TaskDetailPane(state: state, controller: controller),
              ),
            ],
          );
        }

        if (width < compactBreakpoint && state.selectedTask != null) {
          return TaskDetailPane(
            state: state,
            controller: controller,
            onBack: controller.clearSelection,
          );
        }

        final list = TaskListPane(
          state: state,
          controller: controller,
          onOpenSources: () => _showSources(context),
        );
        if (width < compactBreakpoint) return list;
        return Row(
          children: [
            SizedBox(width: 360, child: list),
            const VerticalDivider(width: 1),
            Expanded(
              child: TaskDetailPane(state: state, controller: controller),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showSources(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) => SafeArea(
        child: SizedBox(
          height: MediaQuery.sizeOf(sheetContext).height * 0.78,
          child: TaskSourcesPane(state: state, controller: controller),
        ),
      ),
    );
  }
}
