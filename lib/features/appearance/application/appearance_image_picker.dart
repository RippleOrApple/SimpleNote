import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

enum AppearanceImageSource { files, gallery, camera }

final appearanceImagePickerProvider = Provider<AppearanceImagePicker>((ref) {
  return PluginAppearanceImagePicker();
});

abstract interface class AppearanceImagePicker {
  Future<XFile?> pick(AppearanceImageSource source);
}

final class PluginAppearanceImagePicker implements AppearanceImagePicker {
  PluginAppearanceImagePicker({ImagePicker? imagePicker})
      : _imagePicker = imagePicker ?? ImagePicker();

  final ImagePicker _imagePicker;

  @override
  Future<XFile?> pick(AppearanceImageSource source) {
    return switch (source) {
      AppearanceImageSource.files => _pickFile(),
      AppearanceImageSource.gallery =>
        _imagePicker.pickImage(source: ImageSource.gallery),
      AppearanceImageSource.camera =>
        _imagePicker.pickImage(source: ImageSource.camera),
    };
  }

  Future<XFile?> _pickFile() async {
    final result = await FilePicker.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: false,
    );
    final selected = result?.files.singleOrNull;
    if (selected == null) {
      return null;
    }
    if (selected.path != null) {
      return XFile(
        selected.path!,
        name: selected.name,
      );
    }
    final bytes = selected.bytes;
    if (bytes == null) {
      return null;
    }
    return XFile.fromData(
      bytes,
      name: selected.name,
    );
  }
}
