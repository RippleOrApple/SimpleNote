import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:simple_note/features/attachments/domain/content_attachment.dart';
import 'package:simple_note/features/attachments/infrastructure/attachment_file_store.dart';

void main() {
  late Directory root;
  late AttachmentFileStore store;

  setUp(() async {
    root = await Directory.systemTemp.createTemp('simple-note-attachment-');
    store = AttachmentFileStore(rootDirectory: root);
  });

  tearDown(() async {
    if (root.existsSync()) await root.delete(recursive: true);
  });

  test('stores original and bounded JPEG thumbnail by content hash', () async {
    final image = img.Image(width: 1440, height: 800);
    img.fill(image, color: img.ColorRgb8(34, 120, 190));
    final bytes = Uint8List.fromList(img.encodePng(image));

    final staged = await store.stage(
      MemoryAttachmentInput(name: 'wide.png', bytes: bytes),
    );

    expect(staged.mimeType, 'image/png');
    expect(staged.width, 1440);
    expect(staged.height, 800);
    expect(staged.byteSize, bytes.length);
    expect(staged.relativePath, endsWith('${staged.sha256}.png'));
    expect(
      staged.thumbnailRelativePath,
      endsWith('${staged.sha256}.thumb.jpg'),
    );
    expect(await File(staged.absolutePath).readAsBytes(), bytes);
    final thumbnail = img.decodeJpg(
      await File(staged.thumbnailAbsolutePath).readAsBytes(),
    )!;
    expect(thumbnail.width, 720);
    expect(thumbnail.height, 400);
    expect(
      Directory(p.join(root.path, 'attachments', 'tmp')).listSync(),
      isEmpty,
    );
  });

  test('accepts JPEG, PNG, and WebP based on decoded bytes', () async {
    final image = img.Image(width: 20, height: 10);
    final encodings = <String, Uint8List>{
      'image/jpeg': Uint8List.fromList(img.encodeJpg(image)),
      'image/png': Uint8List.fromList(img.encodePng(image)),
      'image/webp': Uint8List.fromList(img.encodeWebP(image)),
    };

    for (final entry in encodings.entries) {
      final staged = await store.stage(
        MemoryAttachmentInput(name: 'misleading.bin', bytes: entry.value),
      );
      expect(staged.mimeType, entry.key);
    }
  });

  test('rejects oversized input before reading bytes', () async {
    final input = _OversizedInput();

    await expectLater(store.stage(input), throwsA(isA<FileSystemException>()));

    expect(input.wasRead, isFalse);
    expect(Directory(p.join(root.path, 'attachments')).existsSync(), isFalse);
  });

  test('rejects unsupported and malformed image data', () async {
    final bmp = Uint8List.fromList(
      img.encodeBmp(img.Image(width: 8, height: 8)),
    );
    await expectLater(
      store.stage(MemoryAttachmentInput(name: 'image.bmp', bytes: bmp)),
      throwsFormatException,
    );
    await expectLater(
      store.stage(MemoryAttachmentInput(
        name: 'broken.png',
        bytes: Uint8List.fromList([1, 2, 3]),
      )),
      throwsFormatException,
    );
  });

  test('rollback removes only files created by this stage', () async {
    final bytes = Uint8List.fromList(
      img.encodePng(img.Image(width: 80, height: 40)),
    );
    final first = await store.stage(
      MemoryAttachmentInput(name: 'first.png', bytes: bytes),
    );
    final second = await store.stage(
      MemoryAttachmentInput(name: 'second.png', bytes: bytes),
    );

    expect(first.createdOriginal, isTrue);
    expect(first.createdThumbnail, isTrue);
    expect(second.createdOriginal, isFalse);
    expect(second.createdThumbnail, isFalse);
    await second.rollback();
    expect(File(first.absolutePath).existsSync(), isTrue);
    expect(File(first.thumbnailAbsolutePath).existsSync(), isTrue);
    await first.rollback();
    expect(File(first.absolutePath).existsSync(), isFalse);
    expect(File(first.thumbnailAbsolutePath).existsSync(), isFalse);
  });
}

class _OversizedInput implements AttachmentInput {
  bool wasRead = false;

  @override
  String get name => 'large.png';

  @override
  Future<int> length() async => AttachmentFileStore.maxByteSize + 1;

  @override
  Future<Uint8List> readAsBytes() async {
    wasRead = true;
    throw StateError('Bytes must not be read.');
  }
}
