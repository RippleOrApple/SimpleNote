import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:simple_note/features/attachments/domain/content_attachment.dart';
import 'package:simple_note/shared/widgets/embedded_markdown_view.dart';

void main() {
  final roots = <Directory>[];
  late Directory root;
  late ContentAttachment attachment;

  setUp(() async {
    root = await Directory.systemTemp.createTemp('markdown-view-');
    roots.add(root);
    final bytes = Uint8List.fromList(
      img.encodePng(img.Image(width: 80, height: 40)),
    );
    final original = File('${root.path}${Platform.pathSeparator}original.png')
      ..writeAsBytesSync(bytes);
    final thumbnail = File('${root.path}${Platform.pathSeparator}thumb.png')
      ..writeAsBytesSync(bytes);
    attachment = ContentAttachment(
      id: 'att-1',
      owner: const AttachmentOwner(AttachmentOwnerType.note, 'note-1'),
      sha256: 'sha',
      mimeType: 'image/png',
      byteSize: bytes.length,
      width: 80,
      height: 40,
      relativePath: 'original.png',
      thumbnailRelativePath: 'thumb.png',
      absolutePath: original.path,
      thumbnailAbsolutePath: thumbnail.path,
      sortOrder: 0,
      createdAt: 1,
      updatedAt: 1,
      deviceId: 'device',
    );
  });

  tearDownAll(() async {
    for (final directory in roots) {
      if (directory.existsSync()) await directory.delete(recursive: true);
    }
  });

  testWidgets('renders attachment and opens original in a zoomable dialog',
      (tester) async {
    await _pumpView(tester, resolver: _resolver(attachment));
    await _pumpUi(tester);

    final image = find.byKey(const Key('attachment-image-att-1'));
    expect(image, findsOneWidget);
    await tester.tap(image);
    await _pumpUi(tester);

    expect(
      find.byKey(const Key('attachment-fullscreen-att-1')),
      findsOneWidget,
    );
    expect(find.byType(InteractiveViewer), findsOneWidget);
    await tester.tap(find.byTooltip('关闭预览'));
    await _pumpUi(tester);
  });

  testWidgets('resolver failure shows a placeholder', (tester) async {
    await _pumpView(tester, resolver: _resolver(null));
    await _pumpUi(tester);
    expect(
      find.byKey(const Key('attachment-missing-placeholder')),
      findsOneWidget,
    );
  });

  testWidgets('missing thumbnail shows a placeholder', (tester) async {
    File(attachment.thumbnailAbsolutePath).deleteSync();
    await _pumpView(tester, resolver: _resolver(attachment));
    await _pumpUi(tester);
    expect(
      find.byKey(const Key('attachment-missing-placeholder')),
      findsOneWidget,
    );
  });

  testWidgets('delete requires confirmation and forwards the attachment id',
      (tester) async {
    String? deletedId;
    await _pumpView(
      tester,
      resolver: _resolver(attachment),
      onDelete: (id) async => deletedId = id,
    );
    await _pumpUi(tester);

    await tester.tap(find.byKey(const Key('attachment-delete-att-1')));
    await _pumpUi(tester);
    expect(find.text('从正文中删除这张图片？'), findsOneWidget);
    await tester.tap(find.text('取消'));
    await _pumpUi(tester);
    expect(deletedId, isNull);

    await tester.tap(find.byKey(const Key('attachment-delete-att-1')));
    await _pumpUi(tester);
    await tester.tap(find.text('删除'));
    await _pumpUi(tester);
    expect(deletedId, 'att-1');
  });

  testWidgets('read-only images omit delete controls', (tester) async {
    await _pumpView(tester, resolver: _resolver(attachment));
    await _pumpUi(tester);

    expect(find.byKey(const Key('attachment-delete-att-1')), findsNothing);
  });

  testWidgets('remote images render an unsupported placeholder',
      (tester) async {
    _unmountAfterTest(tester);
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: EmbeddedMarkdownView(
          markdown: '![remote](https://example.com/image.png)',
          resolveAttachment: (_) async => attachment,
        ),
      ),
    ));
    await _pumpUi(tester);

    expect(find.byKey(const Key('unsupported-remote-image')), findsOneWidget);
  });
}

Future<void> _pumpView(
  WidgetTester tester, {
  required Future<ContentAttachment?> Function(String id) resolver,
  Future<void> Function(String id)? onDelete,
}) {
  _unmountAfterTest(tester);
  return tester.pumpWidget(MaterialApp(
    home: Scaffold(
      body: EmbeddedMarkdownView(
        markdown: 'Before\n![photo](attachment://att-1)\nAfter',
        resolveAttachment: resolver,
        onDeleteAttachment: onDelete,
      ),
    ),
  ));
}

void _unmountAfterTest(WidgetTester tester) {
  addTearDown(() async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
  });
}

Future<void> _pumpUi(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 350));
  await tester.pump();
}

Future<ContentAttachment?> Function(String id) _resolver(
  ContentAttachment? attachment,
) {
  final result = Future<ContentAttachment?>.value(attachment);
  return (_) => result;
}
