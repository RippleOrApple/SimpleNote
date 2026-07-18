import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../sync/data/sync_repository.dart';
import '../domain/content_attachment.dart';

final attachmentPickerProvider = Provider<AttachmentPicker>((ref) {
  return PluginAttachmentPicker();
});

final pendingAttachmentRecoveryProvider =
    FutureProvider<List<XFile>>((ref) async {
  final platform = ref.watch(deviceInfoProvider).platform.toLowerCase();
  if (platform != 'android') return const [];
  try {
    return await ref.watch(attachmentPickerProvider).recoverLostImages();
  } catch (_) {
    return const [];
  }
});

abstract interface class AttachmentPicker {
  Future<XFile?> pick(AttachmentPickSource source);
  Future<List<XFile>> recoverLostImages();
}

final class PluginAttachmentPicker implements AttachmentPicker {
  PluginAttachmentPicker({ImagePicker? imagePicker})
      : _imagePicker = imagePicker ?? ImagePicker();

  final ImagePicker _imagePicker;
  Future<List<XFile>>? _lostData;

  @override
  Future<XFile?> pick(AttachmentPickSource source) {
    return switch (source) {
      AttachmentPickSource.files => _pickFile(),
      AttachmentPickSource.gallery =>
        _imagePicker.pickImage(source: ImageSource.gallery),
      AttachmentPickSource.camera =>
        _imagePicker.pickImage(source: ImageSource.camera),
    };
  }

  @override
  Future<List<XFile>> recoverLostImages() {
    return _lostData ??= _retrieveLostImages();
  }

  Future<List<XFile>> _retrieveLostImages() async {
    final response = await _imagePicker.retrieveLostData();
    if (response.isEmpty) return const [];
    return List.unmodifiable(response.files ?? const <XFile>[]);
  }

  Future<XFile?> _pickFile() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['jpg', 'jpeg', 'png', 'webp'],
      allowMultiple: false,
      withData: false,
    );
    final selected = result?.files.singleOrNull;
    if (selected == null) return null;
    if (selected.path != null) {
      return XFile(selected.path!, name: selected.name);
    }
    final bytes = selected.bytes;
    return bytes == null ? null : XFile.fromData(bytes, name: selected.name);
  }
}
