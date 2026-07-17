import 'dart:io';
import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:crypto/crypto.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;

import '../../../core/utils/id_generator.dart';
import '../data/appearance_repository.dart';
import '../domain/background_image.dart';
import '../domain/rgb_color.dart';
import 'palette_extractor.dart';

final class BackgroundImageService {
  BackgroundImageService({
    required AppearanceRepository repository,
    required Directory rootDirectory,
    PaletteExtractor paletteExtractor = const PaletteExtractor(),
  })  : _repository = repository,
        _rootDirectory = rootDirectory,
        _paletteExtractor = paletteExtractor;

  static const maxByteSize = 20 * 1024 * 1024;

  final AppearanceRepository _repository;
  final Directory _rootDirectory;
  final PaletteExtractor _paletteExtractor;

  Future<BackgroundImage> importImage(
    XFile source, {
    required bool syncEnabled,
  }) async {
    final decoded = await _readSupportedImage(source);
    final contentHash = sha256.convert(decoded.bytes).toString();
    final fileName = '$contentHash.${decoded.extension}';
    final relativePath = p.join('backgrounds', fileName);
    final backgroundDirectory = Directory(
      p.join(_rootDirectory.path, 'backgrounds'),
    );
    final destination = File(p.join(backgroundDirectory.path, fileName));
    var createdDestination = false;

    if (!await destination.exists()) {
      await backgroundDirectory.create(recursive: true);
      final temporary = File(
        p.join(
          backgroundDirectory.path,
          '$contentHash.${IdGenerator.create()}.tmp',
        ),
      );
      RandomAccessFile? writer;
      try {
        writer = await temporary.open(mode: FileMode.write);
        await writer.writeFrom(decoded.bytes);
        await writer.flush();
        await writer.close();
        writer = null;
        try {
          await temporary.rename(destination.path);
          createdDestination = true;
        } on FileSystemException {
          if (!await destination.exists()) {
            rethrow;
          }
        }
      } finally {
        if (writer != null) {
          await writer.close();
        }
        if (await temporary.exists()) {
          await temporary.delete();
        }
      }
    }

    try {
      return await _repository.addOrReuseBackgroundImage(
        sha256: contentHash,
        mimeType: decoded.mimeType,
        byteSize: decoded.bytes.length,
        width: decoded.image.width,
        height: decoded.image.height,
        relativePath: relativePath,
        absolutePath: destination.absolute.path,
        syncEnabled: syncEnabled,
      );
    } catch (error, stackTrace) {
      if (createdDestination) {
        var referenced = true;
        try {
          referenced =
              await _repository.hasBackgroundImageWithSha256(contentHash);
        } catch (_) {
          // A failed reference check cannot prove that deletion is safe.
        }
        if (!referenced) {
          try {
            if (await destination.exists()) {
              await destination.delete();
            }
          } on FileSystemException {
            // Preserve the metadata error; cleanup can be retried later.
          }
        }
      }
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<List<RgbColor>> extractColors(XFile source) async {
    final decoded = await _readSupportedImage(source);
    return _paletteExtractor.extract(decoded.bytes);
  }

  Future<void> deleteImage(String id) {
    return _repository.deleteBackgroundImage(id);
  }

  Future<_DecodedImage> _readSupportedImage(XFile source) async {
    final reportedLength = await source.length();
    if (reportedLength > maxByteSize) {
      throw FileSystemException(
        'Background image exceeds the 20 MB limit.',
        source.path,
      );
    }

    final bytes = await source.readAsBytes();
    if (bytes.length > maxByteSize) {
      throw FileSystemException(
        'Background image exceeds the 20 MB limit.',
        source.path,
      );
    }

    final img.Decoder? decoder;
    try {
      decoder = img.findDecoderForData(bytes);
    } catch (error) {
      throw FormatException('Image data could not be decoded: $error');
    }
    final format = switch (decoder?.format) {
      img.ImageFormat.jpg => const _ImageFormat(
          mimeType: 'image/jpeg',
          extension: 'jpg',
        ),
      img.ImageFormat.png => const _ImageFormat(
          mimeType: 'image/png',
          extension: 'png',
        ),
      img.ImageFormat.webp => const _ImageFormat(
          mimeType: 'image/webp',
          extension: 'webp',
        ),
      _ => null,
    };
    if (format == null || decoder == null) {
      throw const FormatException(
        'Only decodable JPEG, PNG, and WebP images are supported.',
      );
    }

    try {
      final image = decoder.decode(bytes);
      if (image == null) {
        throw const FormatException('Image data could not be decoded.');
      }
      return _DecodedImage(
        bytes: bytes,
        image: image,
        mimeType: format.mimeType,
        extension: format.extension,
      );
    } on FormatException {
      rethrow;
    } catch (error) {
      throw FormatException('Image data could not be decoded: $error');
    }
  }
}

final class _DecodedImage {
  const _DecodedImage({
    required this.bytes,
    required this.image,
    required this.mimeType,
    required this.extension,
  });

  final Uint8List bytes;
  final img.Image image;
  final String mimeType;
  final String extension;
}

final class _ImageFormat {
  const _ImageFormat({
    required this.mimeType,
    required this.extension,
  });

  final String mimeType;
  final String extension;
}
