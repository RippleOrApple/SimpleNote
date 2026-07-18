import 'package:flutter/material.dart';

import '../../features/attachments/domain/content_attachment.dart';
import '../models/markdown_edit.dart';

final class MarkdownEditingController extends TextEditingController {
  MarkdownEditingController({super.text});

  void wrapSelection(String prefix, String suffix) {
    final range = _normalizedSelection();
    final selected = text.substring(range.start, range.end);
    final updated = text.replaceRange(
      range.start,
      range.end,
      '$prefix$selected$suffix',
    );
    final selectedStart = range.start + prefix.length;
    value = TextEditingValue(
      text: updated,
      selection: TextSelection(
        baseOffset: selectedStart,
        extentOffset: selectedStart + selected.length,
      ),
    );
  }

  void insertAtSelection(String value) {
    final range = _normalizedSelection();
    final updated = text.replaceRange(range.start, range.end, value);
    final caret = range.start + value.length;
    this.value = TextEditingValue(
      text: updated,
      selection: TextSelection.collapsed(offset: caret),
    );
  }

  void prefixSelectedLines(String prefix) {
    final range = _normalizedSelection();
    final lineStart =
        range.start == 0 ? 0 : text.lastIndexOf('\n', range.start - 1) + 1;
    final lineEndIndex = text.indexOf('\n', range.end);
    final lineEnd = lineEndIndex < 0 ? text.length : lineEndIndex;
    final selectedLines = text.substring(lineStart, lineEnd);
    final replacement =
        selectedLines.split('\n').map((line) => '$prefix$line').join('\n');
    value = TextEditingValue(
      text: text.replaceRange(lineStart, lineEnd, replacement),
      selection: TextSelection(
        baseOffset: lineStart + prefix.length,
        extentOffset: lineStart + replacement.length,
      ),
    );
  }

  TextRange _normalizedSelection() {
    final safe = selection.isValid
        ? selection
        : TextSelection.collapsed(offset: text.length);
    final start = safe.start.clamp(0, text.length);
    final end = safe.end.clamp(0, text.length);
    return TextRange(start: start, end: end);
  }
}

class EmbeddedMarkdownEditor extends StatefulWidget {
  const EmbeddedMarkdownEditor({
    required this.initialValue,
    required this.onChanged,
    required this.onInsertImage,
    required this.textStyle,
    super.key,
  });

  final String initialValue;
  final ValueChanged<String> onChanged;
  final Future<MarkdownEditResult?> Function(
    AttachmentPickSource source,
    MarkdownSelection selection, {
    required String altText,
  }) onInsertImage;
  final TextStyle textStyle;

  @override
  State<EmbeddedMarkdownEditor> createState() => _EmbeddedMarkdownEditorState();
}

class _EmbeddedMarkdownEditorState extends State<EmbeddedMarkdownEditor> {
  late final MarkdownEditingController _controller;
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = MarkdownEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(covariant EmbeddedMarkdownEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue &&
        widget.initialValue != _controller.text) {
      final selection = _controller.selection;
      _controller.value = TextEditingValue(
        text: widget.initialValue,
        selection: TextSelection(
          baseOffset: selection.baseOffset.clamp(0, widget.initialValue.length),
          extentOffset:
              selection.extentOffset.clamp(0, widget.initialValue.length),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 48,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _tool(
                key: 'markdown-heading-button',
                tooltip: '标题',
                icon: Icons.title,
                action: () => _controller.prefixSelectedLines('# '),
              ),
              _tool(
                key: 'markdown-bold-button',
                tooltip: '粗体',
                icon: Icons.format_bold,
                action: () => _controller.wrapSelection('**', '**'),
              ),
              _tool(
                key: 'markdown-italic-button',
                tooltip: '斜体',
                icon: Icons.format_italic,
                action: () => _controller.wrapSelection('*', '*'),
              ),
              _tool(
                key: 'markdown-list-button',
                tooltip: '无序列表',
                icon: Icons.format_list_bulleted,
                action: () => _controller.prefixSelectedLines('- '),
              ),
              _tool(
                key: 'markdown-task-list-button',
                tooltip: '任务列表',
                icon: Icons.checklist,
                action: () => _controller.prefixSelectedLines('- [ ] '),
              ),
              _tool(
                key: 'markdown-quote-button',
                tooltip: '引用',
                icon: Icons.format_quote,
                action: () => _controller.prefixSelectedLines('> '),
              ),
              _tool(
                key: 'markdown-code-button',
                tooltip: '行内代码',
                icon: Icons.code,
                action: () => _controller.wrapSelection('`', '`'),
              ),
              _tool(
                key: 'markdown-code-block-button',
                tooltip: '代码块',
                icon: Icons.data_object,
                action: () => _controller.wrapSelection('```\n', '\n```'),
              ),
              _tool(
                key: 'markdown-link-button',
                tooltip: '链接',
                icon: Icons.link,
                action: () => _controller.wrapSelection('[', '](https://)'),
              ),
              IconButton(
                key: const Key('markdown-image-button'),
                tooltip: '插入图片',
                onPressed: _showImageMenu,
                icon: const Icon(Icons.image_outlined),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          key: const Key('embedded-markdown-text-field'),
          controller: _controller,
          focusNode: _focusNode,
          style: widget.textStyle,
          minLines: 10,
          maxLines: null,
          decoration: const InputDecoration(
            labelText: 'Markdown 内容',
            alignLabelWithHint: true,
            border: OutlineInputBorder(),
          ),
          onChanged: widget.onChanged,
        ),
      ],
    );
  }

  Widget _tool({
    required String key,
    required String tooltip,
    required IconData icon,
    required VoidCallback action,
  }) {
    return IconButton(
      key: Key(key),
      tooltip: tooltip,
      onPressed: () {
        action();
        widget.onChanged(_controller.text);
        _focusNode.requestFocus();
      },
      icon: Icon(icon),
    );
  }

  Future<void> _showImageMenu() async {
    final selection = _selectionSnapshot();
    final request = await showDialog<_ImageRequest>(
      context: context,
      builder: (context) => const _ImageSourceDialog(),
    );
    if (request == null || !mounted) return;
    final result = await widget.onInsertImage(
      request.source,
      selection,
      altText: request.altText,
    );
    if (result == null || !mounted) return;
    final resultSelection = result.selection.clamp(result.markdown.length);
    _controller.value = TextEditingValue(
      text: result.markdown,
      selection: TextSelection(
        baseOffset: resultSelection.baseOffset,
        extentOffset: resultSelection.extentOffset,
      ),
    );
    _focusNode.requestFocus();
  }

  MarkdownSelection _selectionSnapshot() {
    final selection = _controller.selection;
    final offset = _controller.text.length;
    return MarkdownSelection(
      baseOffset: selection.isValid ? selection.baseOffset : offset,
      extentOffset: selection.isValid ? selection.extentOffset : offset,
    );
  }
}

class _ImageSourceDialog extends StatefulWidget {
  const _ImageSourceDialog();

  @override
  State<_ImageSourceDialog> createState() => _ImageSourceDialogState();
}

class _ImageSourceDialogState extends State<_ImageSourceDialog> {
  final _altText = TextEditingController(text: '图片');

  @override
  void dispose() {
    _altText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final android = Theme.of(context).platform == TargetPlatform.android;
    return AlertDialog(
      title: const Text('插入图片'),
      content: TextField(
        key: const Key('markdown-image-alt-text'),
        controller: _altText,
        decoration: const InputDecoration(labelText: '替代文本'),
      ),
      actions: [
        TextButton.icon(
          key: const Key('markdown-image-files'),
          onPressed: () => _finish(context, AttachmentPickSource.files),
          icon: const Icon(Icons.folder_open),
          label: const Text('文件'),
        ),
        if (android)
          TextButton.icon(
            key: const Key('markdown-image-gallery'),
            onPressed: () => _finish(context, AttachmentPickSource.gallery),
            icon: const Icon(Icons.photo_library_outlined),
            label: const Text('相册'),
          ),
        if (android)
          TextButton.icon(
            key: const Key('markdown-image-camera'),
            onPressed: () => _finish(context, AttachmentPickSource.camera),
            icon: const Icon(Icons.camera_alt_outlined),
            label: const Text('相机'),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
      ],
    );
  }

  void _finish(BuildContext context, AttachmentPickSource source) {
    final alt = _altText.text.trim();
    Navigator.of(context).pop(_ImageRequest(
      source: source,
      altText: alt.isEmpty ? '图片' : alt,
    ));
  }
}

final class _ImageRequest {
  const _ImageRequest({required this.source, required this.altText});

  final AttachmentPickSource source;
  final String altText;
}
