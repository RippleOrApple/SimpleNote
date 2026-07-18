import 'package:flutter/material.dart';

class QuickAddTask extends StatefulWidget {
  const QuickAddTask({required this.onSubmit, super.key});

  final Future<void> Function(String title) onSubmit;

  @override
  State<QuickAddTask> createState() => _QuickAddTaskState();
}

class _QuickAddTaskState extends State<QuickAddTask> {
  final _controller = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final title = _controller.text.trim();
    if (title.isEmpty || _submitting) return;
    setState(() => _submitting = true);
    await widget.onSubmit(title);
    if (!mounted) return;
    _controller.clear();
    setState(() => _submitting = false);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: const Key('quick-add-task-field'),
      controller: _controller,
      enabled: !_submitting,
      textInputAction: TextInputAction.done,
      onSubmitted: (_) => _submit(),
      decoration: InputDecoration(
        hintText: '快速添加任务',
        prefixIcon: const Icon(Icons.add_task),
        suffixIcon: IconButton(
          tooltip: '添加任务',
          onPressed: _submitting ? null : _submit,
          icon: const Icon(Icons.arrow_upward),
        ),
      ),
    );
  }
}
