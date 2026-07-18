import 'dart:io';

import 'package:flutter/material.dart';

import '../domain/content_attachment.dart';

typedef AttachmentResolver = Future<ContentAttachment?> Function(String id);

class AttachmentImage extends StatefulWidget {
  const AttachmentImage({
    required this.attachmentId,
    required this.altText,
    required this.resolveAttachment,
    this.onDelete,
    super.key,
  });

  final String attachmentId;
  final String altText;
  final AttachmentResolver resolveAttachment;
  final Future<void> Function(String attachmentId)? onDelete;

  @override
  State<AttachmentImage> createState() => _AttachmentImageState();
}

class _AttachmentImageState extends State<AttachmentImage> {
  late Future<ContentAttachment?> _attachment;

  @override
  void initState() {
    super.initState();
    _attachment = widget.resolveAttachment(widget.attachmentId);
  }

  @override
  void didUpdateWidget(covariant AttachmentImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.attachmentId != widget.attachmentId ||
        oldWidget.resolveAttachment != widget.resolveAttachment) {
      _attachment = widget.resolveAttachment(widget.attachmentId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 180,
      child: FutureBuilder<ContentAttachment?>(
        future: _attachment,
        builder: (context, snapshot) {
          final attachment = snapshot.data;
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError ||
              attachment == null ||
              !File(attachment.thumbnailAbsolutePath).existsSync()) {
            return _MissingAttachment(altText: widget.altText);
          }
          return Semantics(
            image: true,
            label: widget.altText,
            child: Stack(
              fit: StackFit.expand,
              children: [
                InkWell(
                  onTap: () => _showPreview(context, attachment),
                  child: Image.file(
                    File(attachment.thumbnailAbsolutePath),
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) =>
                        _MissingAttachment(altText: widget.altText),
                  ),
                ),
                if (widget.onDelete != null)
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton.filledTonal(
                      key: Key('attachment-delete-${widget.attachmentId}'),
                      tooltip: '从正文删除图片',
                      onPressed: () => _confirmDelete(context),
                      icon: const Icon(Icons.delete_outline),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _showPreview(
    BuildContext context,
    ContentAttachment attachment,
  ) {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) => Dialog.fullscreen(
        key: Key('attachment-fullscreen-${widget.attachmentId}'),
        backgroundColor: Colors.black,
        child: Stack(
          children: [
            Positioned.fill(
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 5,
                child: Center(
                  child: Image.file(
                    File(attachment.absolutePath),
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) =>
                        _MissingAttachment(altText: widget.altText),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: IconButton.filled(
                tooltip: '关闭预览',
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除图片'),
        content: const Text('从正文中删除这张图片？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('删除'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await widget.onDelete?.call(widget.attachmentId);
    }
  }
}

class _MissingAttachment extends StatelessWidget {
  const _MissingAttachment({required this.altText});

  final String altText;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('attachment-missing-placeholder'),
      constraints: const BoxConstraints(minHeight: 96, minWidth: 160),
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.broken_image_outlined),
          const SizedBox(height: 8),
          Text(
            altText.isEmpty ? '图片不可用' : '$altText · 图片不可用',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
