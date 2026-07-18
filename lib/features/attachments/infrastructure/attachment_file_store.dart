import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;

import '../../../core/utils/id_generator.dart';
import '../domain/content_attachment.dart';

final class AttachmentFileStore {
  AttachmentFileStore({required Directory rootDirectory})
      : _rootDirectory = rootDirectory {
    if (!p.isAbsolute(rootDirectory.path)) {
      throw ArgumentError.value(
        rootDirectory.path,
        'rootDirectory',
        'Must be an absolute application-support directory.',
      );
    }
  }

  static const maxByteSize = 20 * 1024 * 1024;
  static const thumbnailMaxSide = 720;

  final Directory _rootDirectory;

  Future<StagedAttachment> stage(AttachmentInput input) async {
    final reportedLength = await input.length();
    if (reportedLength > maxByteSize) {
      throw FileSystemException(
        'Attachment exceeds the 20 MB limit.',
        input.name,
      );
    }
    final bytes = await input.readAsBytes();
    if (bytes.length > maxByteSize) {
      throw FileSystemException(
        'Attachment exceeds the 20 MB limit.',
        input.name,
      );
    }
    final decoded = _decode(bytes);
    final contentHash = sha256.convert(bytes).toString();
    final stageKey = '${_rootDirectory.absolute.path}\u0000$contentHash';
    return _AttachmentStageLock.run(
      stageKey,
      () async {
        final active = _AttachmentStageRegistry.active(stageKey);
        if (active != null) return active.acquire(createdByLease: false);
        final persisted = await _persist(
          bytes: bytes,
          image: decoded.image,
          contentHash: contentHash,
          mimeType: decoded.mimeType,
          extension: decoded.extension,
        );
        return _AttachmentStageRegistry.register(stageKey, persisted)
            .acquire(createdByLease: true);
      },
    );
  }

  _DecodedAttachment _decode(Uint8List bytes) {
    final img.Decoder? decoder;
    try {
      decoder = img.findDecoderForData(bytes);
    } catch (error) {
      throw FormatException('Image data could not be decoded: $error');
    }
    final format = switch (decoder?.format) {
      img.ImageFormat.jpg => const _AttachmentFormat('image/jpeg', 'jpg'),
      img.ImageFormat.png => const _AttachmentFormat('image/png', 'png'),
      img.ImageFormat.webp => const _AttachmentFormat('image/webp', 'webp'),
      _ => null,
    };
    if (decoder == null || format == null) {
      throw const FormatException(
        'Only decodable JPEG, PNG, and WebP images are supported.',
      );
    }
    try {
      final image = decoder.decode(bytes);
      if (image == null) {
        throw const FormatException('Image data could not be decoded.');
      }
      return _DecodedAttachment(
        image,
        mimeType: format.mimeType,
        extension: format.extension,
      );
    } on FormatException {
      rethrow;
    } catch (error) {
      throw FormatException('Image data could not be decoded: $error');
    }
  }

  Future<_PersistedAttachment> _persist({
    required Uint8List bytes,
    required img.Image image,
    required String contentHash,
    required String mimeType,
    required String extension,
  }) async {
    final contentDirectory = Directory(
      p.join(_rootDirectory.path, 'attachments', 'content'),
    );
    final temporaryDirectory = Directory(
      p.join(_rootDirectory.path, 'attachments', 'tmp'),
    );
    await contentDirectory.create(recursive: true);
    await temporaryDirectory.create(recursive: true);

    final originalName = '$contentHash.$extension';
    final thumbnailName = '$contentHash.thumb.jpg';
    final original = File(p.join(contentDirectory.path, originalName));
    final thumbnail = File(p.join(contentDirectory.path, thumbnailName));
    final originalExisted = await original.exists();
    final thumbnailExisted = await thumbnail.exists();
    final token = IdGenerator.create();
    final originalTemporary = File(
      p.join(temporaryDirectory.path, '$contentHash.$token.original.tmp'),
    );
    final thumbnailTemporary = File(
      p.join(temporaryDirectory.path, '$contentHash.$token.thumbnail.tmp'),
    );
    var createdOriginal = false;
    var createdThumbnail = false;
    try {
      final thumbnailBytes = Uint8List.fromList(
        img.encodeJpg(_thumbnail(image), quality: 82),
      );
      await _writeAndFlush(originalTemporary, bytes);
      await _writeAndFlush(thumbnailTemporary, thumbnailBytes);
      if (!originalExisted) {
        createdOriginal = await _moveUnlessPresent(originalTemporary, original);
      }
      if (!thumbnailExisted) {
        createdThumbnail =
            await _moveUnlessPresent(thumbnailTemporary, thumbnail);
      }
      return _PersistedAttachment(
        sha256: contentHash,
        mimeType: mimeType,
        byteSize: bytes.length,
        width: image.width,
        height: image.height,
        relativePath: p.join('attachments', 'content', originalName),
        thumbnailRelativePath: p.join('attachments', 'content', thumbnailName),
        absolutePath: original.absolute.path,
        thumbnailAbsolutePath: thumbnail.absolute.path,
        createdOriginal: createdOriginal,
        createdThumbnail: createdThumbnail,
      );
    } catch (error, stackTrace) {
      await _deleteIfCreated(original, createdOriginal);
      await _deleteIfCreated(thumbnail, createdThumbnail);
      Error.throwWithStackTrace(error, stackTrace);
    } finally {
      await _deleteIfExists(originalTemporary);
      await _deleteIfExists(thumbnailTemporary);
    }
  }

  img.Image _thumbnail(img.Image source) {
    final longestSide =
        source.width > source.height ? source.width : source.height;
    if (longestSide <= thumbnailMaxSide) return img.Image.from(source);
    if (source.width >= source.height) {
      return img.copyResize(source, width: thumbnailMaxSide);
    }
    return img.copyResize(source, height: thumbnailMaxSide);
  }

  Future<void> _writeAndFlush(File file, Uint8List bytes) async {
    final writer = await file.open(mode: FileMode.write);
    try {
      await writer.writeFrom(bytes);
      await writer.flush();
    } finally {
      await writer.close();
    }
  }

  Future<bool> _moveUnlessPresent(File temporary, File destination) async {
    try {
      await temporary.rename(destination.path);
      return true;
    } on FileSystemException {
      if (!await destination.exists()) rethrow;
      return false;
    }
  }
}

final class StagedAttachment {
  StagedAttachment._(
    this._state, {
    required this.createdOriginal,
    required this.createdThumbnail,
  });

  final _SharedStageState _state;
  bool _resolved = false;

  String get sha256 => _state.data.sha256;
  String get mimeType => _state.data.mimeType;
  int get byteSize => _state.data.byteSize;
  int get width => _state.data.width;
  int get height => _state.data.height;
  String get relativePath => _state.data.relativePath;
  String get thumbnailRelativePath => _state.data.thumbnailRelativePath;
  String get absolutePath => _state.data.absolutePath;
  String get thumbnailAbsolutePath => _state.data.thumbnailAbsolutePath;
  final bool createdOriginal;
  final bool createdThumbnail;

  Future<void> commit() => _resolve(committed: true);

  Future<void> rollback() => _resolve(committed: false);

  Future<void> _resolve({required bool committed}) async {
    if (_resolved) return;
    _resolved = true;
    await _state.resolve(committed: committed);
  }
}

final class _PersistedAttachment {
  const _PersistedAttachment({
    required this.sha256,
    required this.mimeType,
    required this.byteSize,
    required this.width,
    required this.height,
    required this.relativePath,
    required this.thumbnailRelativePath,
    required this.absolutePath,
    required this.thumbnailAbsolutePath,
    required this.createdOriginal,
    required this.createdThumbnail,
  });

  final String sha256;
  final String mimeType;
  final int byteSize;
  final int width;
  final int height;
  final String relativePath;
  final String thumbnailRelativePath;
  final String absolutePath;
  final String thumbnailAbsolutePath;
  final bool createdOriginal;
  final bool createdThumbnail;
}

final class _SharedStageState {
  _SharedStageState(this.key, this.data);

  final String key;
  final _PersistedAttachment data;
  int _leases = 0;
  bool _committed = false;

  StagedAttachment acquire({required bool createdByLease}) {
    _leases++;
    return StagedAttachment._(
      this,
      createdOriginal: createdByLease && data.createdOriginal,
      createdThumbnail: createdByLease && data.createdThumbnail,
    );
  }

  Future<void> resolve({required bool committed}) async {
    if (committed) _committed = true;
    _leases--;
    if (_leases > 0) return;
    _AttachmentStageRegistry.remove(key, this);
    if (!_committed) {
      await _deleteIfCreated(File(data.absolutePath), data.createdOriginal);
      await _deleteIfCreated(
        File(data.thumbnailAbsolutePath),
        data.createdThumbnail,
      );
    }
  }
}

abstract final class _AttachmentStageRegistry {
  static final Map<String, _SharedStageState> _states = {};

  static _SharedStageState? active(String sha) => _states[sha];

  static _SharedStageState register(String key, _PersistedAttachment data) {
    final state = _SharedStageState(key, data);
    _states[key] = state;
    return state;
  }

  static void remove(String sha, _SharedStageState state) {
    if (identical(_states[sha], state)) _states.remove(sha);
  }
}

final class _DecodedAttachment {
  const _DecodedAttachment(
    this.image, {
    required this.mimeType,
    required this.extension,
  });

  final img.Image image;
  final String mimeType;
  final String extension;
}

final class _AttachmentFormat {
  const _AttachmentFormat(this.mimeType, this.extension);

  final String mimeType;
  final String extension;
}

abstract final class _AttachmentStageLock {
  static final Map<String, Future<void>> _tails = {};

  static Future<T> run<T>(String sha, Future<T> Function() operation) {
    final previous = _tails[sha] ?? Future<void>.value();
    final release = Completer<void>();
    _tails[sha] = release.future;
    return () async {
      await previous;
      try {
        return await operation();
      } finally {
        release.complete();
        if (identical(_tails[sha], release.future)) _tails.remove(sha);
      }
    }();
  }
}

Future<void> _deleteIfCreated(File file, bool created) async {
  if (created) await _deleteIfExists(file);
}

Future<void> _deleteIfExists(File file) async {
  try {
    if (await file.exists()) await file.delete();
  } on FileSystemException {
    // Cleanup is best effort; callers keep the original failure.
  }
}
