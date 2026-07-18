import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../features/attachments/presentation/attachment_image.dart';

class EmbeddedMarkdownView extends StatelessWidget {
  const EmbeddedMarkdownView({
    required this.markdown,
    required this.resolveAttachment,
    this.onDeleteAttachment,
    this.styleSheet,
    super.key,
  });

  final String markdown;
  final AttachmentResolver resolveAttachment;
  final Future<void> Function(String attachmentId)? onDeleteAttachment;
  final MarkdownStyleSheet? styleSheet;

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: markdown,
      styleSheet: styleSheet,
      sizedImageBuilder: (config) {
        final uri = config.uri;
        if (uri.scheme != 'attachment') {
          return const _UnsupportedRemoteImage();
        }
        final id = uri.host.isNotEmpty
            ? uri.host
            : uri.path.replaceFirst(RegExp(r'^/+'), '');
        if (id.isEmpty) return const _UnsupportedRemoteImage();
        return AttachmentImage(
          key: Key('attachment-image-$id'),
          attachmentId: id,
          altText: config.alt ?? '图片',
          resolveAttachment: resolveAttachment,
          onDelete: onDeleteAttachment,
        );
      },
    );
  }
}

class _UnsupportedRemoteImage extends StatelessWidget {
  const _UnsupportedRemoteImage();

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('unsupported-remote-image'),
      padding: const EdgeInsets.all(12),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.link_off),
          SizedBox(width: 8),
          Text('不支持远程图片'),
        ],
      ),
    );
  }
}
