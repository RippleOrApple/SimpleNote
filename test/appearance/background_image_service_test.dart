import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:simple_note/database/app_database.dart';
import 'package:simple_note/features/appearance/data/appearance_repository.dart';
import 'package:simple_note/features/appearance/domain/appearance_settings.dart';
import 'package:simple_note/features/appearance/domain/background_image.dart';
import 'package:simple_note/features/appearance/domain/rgb_color.dart';
import 'package:simple_note/features/appearance/infrastructure/background_image_service.dart';
import 'package:simple_note/features/sync/domain/device_info.dart';

void main() {
  late Directory rootDirectory;
  late AppDatabase database;
  late DriftAppearanceRepository repository;
  late BackgroundImageService service;
  late Uint8List pngBytes;

  setUp(() async {
    rootDirectory = await Directory.systemTemp.createTemp(
      'simple-note-background-test-',
    );
    database = AppDatabase(NativeDatabase.memory());
    repository = DriftAppearanceRepository(database, _windowsDevice);
    service = BackgroundImageService(
      repository: repository,
      rootDirectory: rootDirectory,
    );
    pngBytes = Uint8List.fromList(img.encodePng(_sourceImage()));
  });

  tearDown(() async {
    await database.close();
    if (rootDirectory.existsSync()) {
      await rootDirectory.delete(recursive: true);
    }
  });

  test('imports a decoded PNG into content-addressed storage', () async {
    final imported = await service.importImage(
      XFile.fromData(
        pngBytes,
        name: 'sample.png',
        mimeType: 'image/png',
      ),
      syncEnabled: false,
    );

    expect(imported.width, 64);
    expect(imported.height, 32);
    expect(imported.mimeType, 'image/png');
    expect(imported.byteSize, pngBytes.length);
    expect(imported.syncEnabled, isFalse);
    expect(
        imported.relativePath, p.join('backgrounds', '${imported.sha256}.png'));
    expect(File(imported.absolutePath).existsSync(), isTrue);
    expect(await File(imported.absolutePath).readAsBytes(), pngBytes);
    expect(
      await repository.listBackgroundImages(rootDirectory: rootDirectory),
      hasLength(1),
    );
    expect(
      Directory(p.join(rootDirectory.path, 'backgrounds'))
          .listSync()
          .whereType<File>()
          .map((file) => p.basename(file.path)),
      ['${imported.sha256}.png'],
    );
  });

  test('derives the format from decoded bytes rather than source metadata',
      () async {
    final imported = await service.importImage(
      XFile.fromData(
        pngBytes,
        name: 'misleading.jpg',
        mimeType: 'image/jpeg',
      ),
      syncEnabled: true,
    );

    expect(imported.mimeType, 'image/png');
    expect(imported.relativePath, endsWith('.png'));
    expect(imported.syncEnabled, isTrue);
  });

  test('rejects undecodable and unsupported image payloads', () async {
    expect(
      () => service.importImage(
        XFile.fromData(
          Uint8List.fromList([1, 2, 3, 4]),
          name: 'broken.png',
        ),
        syncEnabled: false,
      ),
      throwsFormatException,
    );

    final bmpBytes = Uint8List.fromList(img.encodeBmp(_sourceImage()));
    expect(
      () => service.importImage(
        XFile.fromData(bmpBytes, name: 'valid.bmp'),
        syncEnabled: false,
      ),
      throwsFormatException,
    );

    expect(
      await repository.listBackgroundImages(rootDirectory: rootDirectory),
      isEmpty,
    );
    expect(
      Directory(p.join(rootDirectory.path, 'backgrounds')).existsSync(),
      isFalse,
    );
  });

  test('rejects a reported length above 20 MB before reading bytes', () async {
    expect(
      () => service.importImage(
        _UnreadableOversizedXFile(),
        syncEnabled: false,
      ),
      throwsA(isA<FileSystemException>()),
    );

    expect(
      await repository.listBackgroundImages(rootDirectory: rootDirectory),
      isEmpty,
    );
  });

  test('extracts colors without retaining bytes or metadata', () async {
    final backgroundDirectory = Directory(
      p.join(rootDirectory.path, 'backgrounds'),
    )..createSync();
    final sentinel = File(p.join(backgroundDirectory.path, 'sentinel'))
      ..writeAsStringSync('unchanged');
    final before = backgroundDirectory
        .listSync()
        .map((entry) => p.basename(entry.path))
        .toList();

    final colors = await service.extractColors(
      XFile.fromData(pngBytes, name: 'palette.png'),
    );

    expect(colors, hasLength(5));
    expect(
      await repository.listBackgroundImages(rootDirectory: rootDirectory),
      isEmpty,
    );
    expect(
      backgroundDirectory
          .listSync()
          .map((entry) => p.basename(entry.path))
          .toList(),
      before,
    );
    expect(sentinel.readAsStringSync(), 'unchanged');
  });

  test('reuses an existing content file and active metadata', () async {
    final source = XFile.fromData(pngBytes, name: 'sample.png');
    final first = await service.importImage(source, syncEnabled: false);
    final storedFile = File(first.absolutePath);
    final preservedTimestamp = DateTime.utc(2001, 2, 3, 4, 5, 6);
    storedFile.setLastModifiedSync(preservedTimestamp);

    final second = await service.importImage(source, syncEnabled: false);

    expect(second.id, first.id);
    expect(
      storedFile.lastModifiedSync().millisecondsSinceEpoch,
      preservedTimestamp.millisecondsSinceEpoch,
    );
    expect(
      await repository.listBackgroundImages(rootDirectory: rootDirectory),
      hasLength(1),
    );
  });

  test('serializes same-SHA imports across services and releases after failure',
      () async {
    final failingRepository = _GatedMetadataRepository(
      delegate: repository,
      fail: true,
    );
    final succeedingRepository = _GatedMetadataRepository(
      delegate: repository,
      fail: false,
    );
    final failingService = BackgroundImageService(
      repository: failingRepository,
      rootDirectory: rootDirectory,
    );
    final succeedingService = BackgroundImageService(
      repository: succeedingRepository,
      rootDirectory: rootDirectory,
    );
    final failingImport = failingService.importImage(
      XFile.fromData(pngBytes, name: 'first.png'),
      syncEnabled: false,
    );
    await failingRepository.addStarted.future;

    final secondRead = Completer<void>();
    final succeedingImport = succeedingService.importImage(
      _SignalingXFile(pngBytes, bytesRead: secondRead),
      syncEnabled: false,
    );
    await secondRead.future;

    failingRepository.release.complete();
    await expectLater(failingImport, throwsStateError);
    await succeedingRepository.addStarted.future;
    succeedingRepository.release.complete();
    final imported = await succeedingImport;

    expect(File(imported.absolutePath).existsSync(), isTrue);
    expect(
      await repository.listBackgroundImages(rootDirectory: rootDirectory),
      hasLength(1),
    );
  });

  test('reloads absolute paths from an explicit root, never the CWD', () async {
    final imported = await service.importImage(
      XFile.fromData(pngBytes, name: 'sample.png'),
      syncEnabled: false,
    );
    final unrelatedDirectory = await Directory.systemTemp.createTemp(
      'simple-note-unrelated-cwd-',
    );
    final originalCurrentDirectory = Directory.current;
    try {
      Directory.current = unrelatedDirectory.path;
      final reloaded = await repository.listBackgroundImages(
        rootDirectory: rootDirectory,
      );
      final expectedPath = p.join(
        rootDirectory.path,
        imported.relativePath,
      );

      expect(reloaded.single.absolutePath, expectedPath);
      expect(File(reloaded.single.absolutePath).existsSync(), isTrue);
    } finally {
      Directory.current = originalCurrentDirectory.path;
      await unrelatedDirectory.delete(recursive: true);
    }
  });

  test('rolls back a newly-created unreferenced file on metadata failure',
      () async {
    final failingService = BackgroundImageService(
      repository: const _FailingMetadataRepository(referenced: false),
      rootDirectory: rootDirectory,
    );

    await expectLater(
      failingService.importImage(
        XFile.fromData(pngBytes, name: 'sample.png'),
        syncEnabled: false,
      ),
      throwsStateError,
    );

    final backgroundDirectory = Directory(
      p.join(rootDirectory.path, 'backgrounds'),
    );
    expect(backgroundDirectory.listSync(), isEmpty);
  });

  test('keeps a new file when metadata failure finds another reference',
      () async {
    final failingService = BackgroundImageService(
      repository: const _FailingMetadataRepository(referenced: true),
      rootDirectory: rootDirectory,
    );

    await expectLater(
      failingService.importImage(
        XFile.fromData(pngBytes, name: 'sample.png'),
        syncEnabled: false,
      ),
      throwsStateError,
    );

    final storedFiles = Directory(
      p.join(rootDirectory.path, 'backgrounds'),
    ).listSync();
    expect(storedFiles, hasLength(1));
    expect(storedFiles.single.path, endsWith('.png'));
  });

  test('never removes a pre-existing file on metadata failure', () async {
    final imported = await service.importImage(
      XFile.fromData(pngBytes, name: 'sample.png'),
      syncEnabled: false,
    );
    final failingService = BackgroundImageService(
      repository: const _FailingMetadataRepository(referenced: false),
      rootDirectory: rootDirectory,
    );

    await expectLater(
      failingService.importImage(
        XFile.fromData(pngBytes, name: 'sample.png'),
        syncEnabled: false,
      ),
      throwsStateError,
    );

    expect(File(imported.absolutePath).existsSync(), isTrue);
  });

  test('soft-deletes and atomically falls back active selections', () async {
    final imported = await service.importImage(
      XFile.fromData(pngBytes, name: 'synced.png'),
      syncEnabled: true,
    );
    final fallback = (await repository.loadPortable()).copyWith(
      background: BackgroundSelection.syncedImage(imported.id),
      lastPureBackground: const RgbColor(0x123456),
    );
    await repository.savePortable(fallback);
    final windows = await repository.loadDeviceProfile('windows');
    await repository.saveDeviceProfile(
      windows.copyWith(localBackgroundImageId: imported.id),
    );
    final android = await repository.loadDeviceProfile('android');
    await repository.saveDeviceProfile(
      android.copyWith(localBackgroundImageId: imported.id),
    );

    await service.deleteImage(imported.id);

    final portable = await repository.loadPortable();
    expect(
      portable.background,
      BackgroundSelection.customColor(fallback.lastPureBackground),
    );
    expect(
      (await repository.loadDeviceProfile('windows')).localBackgroundImageId,
      isNull,
    );
    expect(
      (await repository.loadDeviceProfile('android')).localBackgroundImageId,
      imported.id,
    );
    expect(
      await repository.listBackgroundImages(rootDirectory: rootDirectory),
      isEmpty,
    );
    final deletedRow =
        await database.appearanceDao.backgroundImageById(imported.id);
    expect(deletedRow?.deletedAt, isNotNull);
    expect(deletedRow?.version, 2);
    expect(File(imported.absolutePath).existsSync(), isTrue);
  });
}

img.Image _sourceImage() {
  final image = img.Image(width: 64, height: 32);
  for (final pixel in image) {
    pixel.setRgb(pixel.x * 4, pixel.y * 8, 120);
  }
  return image;
}

final class _UnreadableOversizedXFile extends XFile {
  _UnreadableOversizedXFile() : super('must-not-be-read');

  @override
  Future<int> length() async => 20 * 1024 * 1024 + 1;

  @override
  Future<Uint8List> readAsBytes() {
    throw StateError('readAsBytes must not be called for oversized input.');
  }
}

final class _SignalingXFile extends XFile {
  _SignalingXFile(
    super.bytes, {
    required this.bytesRead,
  }) : super.fromData(name: 'signaling.png');

  final Completer<void> bytesRead;

  @override
  Future<Uint8List> readAsBytes() async {
    final bytes = await super.readAsBytes();
    if (!bytesRead.isCompleted) {
      bytesRead.complete();
    }
    return bytes;
  }
}

final class _GatedMetadataRepository implements AppearanceRepository {
  _GatedMetadataRepository({
    required this.delegate,
    required this.fail,
  });

  final AppearanceRepository delegate;
  final bool fail;
  final Completer<void> addStarted = Completer<void>();
  final Completer<void> release = Completer<void>();

  @override
  Future<BackgroundImage> addOrReuseBackgroundImage({
    required String sha256,
    required String mimeType,
    required int byteSize,
    required int width,
    required int height,
    required String relativePath,
    required String absolutePath,
    required bool syncEnabled,
  }) async {
    if (!addStarted.isCompleted) {
      addStarted.complete();
    }
    await release.future;
    if (fail) {
      throw StateError('metadata insert failed');
    }
    return delegate.addOrReuseBackgroundImage(
      sha256: sha256,
      mimeType: mimeType,
      byteSize: byteSize,
      width: width,
      height: height,
      relativePath: relativePath,
      absolutePath: absolutePath,
      syncEnabled: syncEnabled,
    );
  }

  @override
  Future<bool> hasBackgroundImageWithSha256(String sha256) {
    return delegate.hasBackgroundImageWithSha256(sha256);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    throw UnsupportedError('Not used by this service test.');
  }
}

final class _FailingMetadataRepository implements AppearanceRepository {
  const _FailingMetadataRepository({required this.referenced});

  final bool referenced;

  @override
  Future<BackgroundImage> addOrReuseBackgroundImage({
    required String sha256,
    required String mimeType,
    required int byteSize,
    required int width,
    required int height,
    required String relativePath,
    required String absolutePath,
    required bool syncEnabled,
  }) {
    throw StateError('metadata insert failed');
  }

  @override
  Future<bool> hasBackgroundImageWithSha256(String sha256) async => referenced;

  @override
  dynamic noSuchMethod(Invocation invocation) {
    throw UnsupportedError('Not used by this service test.');
  }
}

const _windowsDevice = DeviceInfo(
  deviceId: 'test-device',
  deviceName: 'Test',
  platform: 'windows',
  appVersion: '1.0.0',
);
