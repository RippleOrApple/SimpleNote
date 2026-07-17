import 'package:flutter/material.dart';

import '../../../shared/widgets/app_background.dart';
import '../application/appearance_image_picker.dart';
import '../domain/appearance_settings.dart';
import '../domain/background_image.dart';
import '../domain/device_appearance_profile.dart';

class BackgroundSettingsSection extends StatefulWidget {
  const BackgroundSettingsSection({
    required this.settings,
    required this.profile,
    required this.platform,
    required this.brightness,
    required this.warning,
    required this.onSelectBundled,
    required this.onImportImage,
    required this.onPresentationChanged,
    super.key,
    this.backgroundImages = const [],
    this.unavailableImageIds = const {},
  });

  final AppearanceSettings settings;
  final DeviceAppearanceProfile profile;
  final String platform;
  final Brightness brightness;
  final String? warning;
  final List<BackgroundImage> backgroundImages;
  final Set<String> unavailableImageIds;
  final ValueChanged<String> onSelectBundled;
  final Future<void> Function(
    AppearanceImageSource source,
    bool syncEnabled,
  ) onImportImage;
  final Future<void> Function({
    required double focusX,
    required double focusY,
    required double zoom,
    required double blur,
    required double overlay,
  }) onPresentationChanged;

  @override
  State<BackgroundSettingsSection> createState() =>
      _BackgroundSettingsSectionState();
}

class _BackgroundSettingsSectionState extends State<BackgroundSettingsSection> {
  final _previewKey = GlobalKey();
  late bool _syncEnabled;
  bool _importing = false;
  String? _operationError;

  static const _wallpapers = <(String, String)>[
    ('mist-morning', 'assets/backgrounds/presets/mist-morning.png'),
    ('eucalyptus-valley', 'assets/backgrounds/presets/eucalyptus-valley.png'),
    ('berry-dusk', 'assets/backgrounds/presets/berry-dusk.png'),
    ('lavender-moon', 'assets/backgrounds/presets/lavender-moon.png'),
  ];

  @override
  void initState() {
    super.initState();
    _syncEnabled = widget.profile.localBackgroundImageId == null;
  }

  @override
  void didUpdateWidget(covariant BackgroundSettingsSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.profile.localBackgroundImageId !=
        widget.profile.localBackgroundImageId) {
      _syncEnabled = widget.profile.localBackgroundImageId == null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = widget.profile;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Background', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final wallpaper in _wallpapers)
              ChoiceChip(
                key: Key('background-wallpaper-${wallpaper.$1}'),
                label: Text(_wallpaperLabel(wallpaper.$1)),
                selected: widget.settings.background.assetPath == wallpaper.$2,
                onSelected: (_) => widget.onSelectBundled(wallpaper.$2),
              ),
          ],
        ),
        const SizedBox(height: 10),
        SwitchListTile(
          key: const Key('appearance-background-sync-switch'),
          contentPadding: EdgeInsets.zero,
          title: const Text('Synchronize imported background'),
          subtitle: const Text(
            'Off keeps the imported image only on this device.',
          ),
          value: _syncEnabled,
          onChanged: (value) => setState(() => _syncEnabled = value),
        ),
        FilledButton.icon(
          key: const Key('appearance-background-image-button'),
          onPressed: _importing ? null : _chooseImage,
          icon: const Icon(Icons.image_outlined),
          label: Text(_importing ? 'Importing…' : 'Import background image'),
        ),
        if (widget.warning != null || _operationError != null)
          Padding(
            key: const Key('appearance-background-warning'),
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              _operationError ?? widget.warning!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        const SizedBox(height: 16),
        Text(
          'Crop focus',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        AspectRatio(
          aspectRatio: 16 / 7,
          child: ClipRRect(
            key: const Key('appearance-background-preview'),
            borderRadius: BorderRadius.circular(12),
            child: AppBackground(
              settings: widget.settings,
              deviceProfile: profile,
              brightness: widget.brightness,
              backgroundImages: widget.backgroundImages,
              unavailableImageIds: widget.unavailableImageIds,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).dividerColor),
                ),
                child: SizedBox.expand(
                  key: _previewKey,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment(
                          profile.backgroundFocusX * 2 - 1,
                          profile.backgroundFocusY * 2 - 1,
                        ),
                        child: LongPressDraggable<bool>(
                          key: const Key('appearance-background-focus'),
                          data: true,
                          feedback: const Material(
                            type: MaterialType.transparency,
                            child: Icon(Icons.control_camera, size: 30),
                          ),
                          childWhenDragging: const Opacity(
                            opacity: 0.35,
                            child: Icon(Icons.control_camera, size: 30),
                          ),
                          onDragEnd: _finishFocusDrag,
                          child: const Tooltip(
                            message: 'Long-press and drag to set crop focus',
                            child: Icon(
                              Icons.control_camera,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        _SettingSlider(
          key: const Key('appearance-background-zoom-slider'),
          label: 'Zoom',
          value: profile.backgroundZoom,
          min: 0.5,
          max: 3,
          onChanged: (value) => _update(zoom: value),
        ),
        _SettingSlider(
          key: const Key('appearance-background-blur-slider'),
          label: 'Blur',
          value: profile.backgroundBlur,
          min: 0,
          max: 40,
          onChanged: (value) => _update(blur: value),
        ),
        _SettingSlider(
          key: const Key('appearance-background-overlay-slider'),
          label: 'Overlay',
          value: profile.backgroundOverlay,
          min: 0,
          max: 1,
          onChanged: (value) => _update(overlay: value),
        ),
      ],
    );
  }

  Future<void> _chooseImage() async {
    AppearanceImageSource? source;
    if (widget.platform.toLowerCase() == 'android') {
      source = await showModalBottomSheet<AppearanceImageSource>(
        context: context,
        builder: (context) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.folder_open_outlined),
                title: const Text('Choose a file'),
                onTap: () => Navigator.of(context).pop(
                  AppearanceImageSource.files,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Gallery'),
                onTap: () => Navigator.of(context).pop(
                  AppearanceImageSource.gallery,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text('Camera'),
                onTap: () => Navigator.of(context).pop(
                  AppearanceImageSource.camera,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      source = AppearanceImageSource.files;
    }
    if (source == null) {
      return;
    }
    setState(() {
      _importing = true;
      _operationError = null;
    });
    try {
      await widget.onImportImage(source, _syncEnabled);
    } catch (error) {
      if (mounted) {
        setState(() => _operationError = error.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _importing = false);
      }
    }
  }

  void _finishFocusDrag(DraggableDetails details) {
    final preview =
        _previewKey.currentContext?.findRenderObject() as RenderBox?;
    if (preview == null) {
      return;
    }
    final position = preview.globalToLocal(
      details.offset + const Offset(15, 15),
    );
    _setFocus(position, preview.size);
  }

  void _setFocus(Offset position, Size size) {
    if (size.width <= 0 || size.height <= 0) {
      return;
    }
    _update(
      focusX: (position.dx / size.width).clamp(0.0, 1.0),
      focusY: (position.dy / size.height).clamp(0.0, 1.0),
    );
  }

  void _update({
    double? focusX,
    double? focusY,
    double? zoom,
    double? blur,
    double? overlay,
  }) {
    widget.onPresentationChanged(
      focusX: focusX ?? widget.profile.backgroundFocusX,
      focusY: focusY ?? widget.profile.backgroundFocusY,
      zoom: zoom ?? widget.profile.backgroundZoom,
      blur: blur ?? widget.profile.backgroundBlur,
      overlay: overlay ?? widget.profile.backgroundOverlay,
    );
  }
}

class _SettingSlider extends StatelessWidget {
  const _SettingSlider({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    super.key,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 88, child: Text(label)),
        Expanded(
          child: Slider(
            value: value,
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ),
        SizedBox(width: 48, child: Text(value.toStringAsFixed(1))),
      ],
    );
  }
}

String _wallpaperLabel(String id) {
  return id
      .split('-')
      .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
      .join(' ');
}
