import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';

enum AttachmentOwnerType { task, note }

enum AttachmentPickSource { files, gallery, camera }

final class AttachmentOwner {
  const AttachmentOwner(this.type, this.id);

  final AttachmentOwnerType type;
  final String id;

  @override
  bool operator ==(Object other) =>
      other is AttachmentOwner && other.type == type && other.id == id;

  @override
  int get hashCode => Object.hash(type, id);
}

abstract interface class AttachmentInput {
  String get name;
  Future<int> length();
  Future<Uint8List> readAsBytes();
}

final class XFileAttachmentInput implements AttachmentInput {
  XFileAttachmentInput(this.file);

  final XFile file;

  @override
  String get name => file.name;

  @override
  Future<int> length() => file.length();

  @override
  Future<Uint8List> readAsBytes() => file.readAsBytes();
}

final class MemoryAttachmentInput implements AttachmentInput {
  MemoryAttachmentInput({required this.name, required Uint8List bytes})
      : _bytes = bytes;

  @override
  final String name;
  final Uint8List _bytes;

  @override
  Future<int> length() async => _bytes.length;

  @override
  Future<Uint8List> readAsBytes() async => Uint8List.fromList(_bytes);
}

final class ContentAttachment {
  const ContentAttachment({
    required this.id,
    required this.owner,
    required this.sha256,
    required this.mimeType,
    required this.byteSize,
    required this.width,
    required this.height,
    required this.relativePath,
    required this.thumbnailRelativePath,
    required this.absolutePath,
    required this.thumbnailAbsolutePath,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
    required this.deviceId,
    this.deletedAt,
    this.version = 1,
  });

  final String id;
  final AttachmentOwner owner;
  final String sha256;
  final String mimeType;
  final int byteSize;
  final int width;
  final int height;
  final String relativePath;
  final String thumbnailRelativePath;
  final String absolutePath;
  final String thumbnailAbsolutePath;
  final int sortOrder;
  final int createdAt;
  final int updatedAt;
  final int? deletedAt;
  final String deviceId;
  final int version;

  bool get isDeleted => deletedAt != null;

  Map<String, Object?> toJson() => {
        'id': id,
        'ownerType': owner.type.name,
        'ownerId': owner.id,
        'sha256': sha256,
        'mimeType': mimeType,
        'byteSize': byteSize,
        'width': width,
        'height': height,
        'relativePath': relativePath,
        'thumbnailRelativePath': thumbnailRelativePath,
        'sortOrder': sortOrder,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'deletedAt': deletedAt,
        'deviceId': deviceId,
        'version': version,
      };

  factory ContentAttachment.fromJson(
    Map<String, Object?> json, {
    required String absolutePath,
    required String thumbnailAbsolutePath,
  }) {
    return ContentAttachment(
      id: json['id']! as String,
      owner: AttachmentOwner(
        AttachmentOwnerType.values.byName(json['ownerType']! as String),
        json['ownerId']! as String,
      ),
      sha256: json['sha256']! as String,
      mimeType: json['mimeType']! as String,
      byteSize: json['byteSize']! as int,
      width: json['width']! as int,
      height: json['height']! as int,
      relativePath: json['relativePath']! as String,
      thumbnailRelativePath: json['thumbnailRelativePath']! as String,
      absolutePath: absolutePath,
      thumbnailAbsolutePath: thumbnailAbsolutePath,
      sortOrder: json['sortOrder'] as int? ?? 0,
      createdAt: json['createdAt']! as int,
      updatedAt: json['updatedAt']! as int,
      deletedAt: json['deletedAt'] as int?,
      deviceId: json['deviceId']! as String,
      version: json['version'] as int? ?? 1,
    );
  }
}
