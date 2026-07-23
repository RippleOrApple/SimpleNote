import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/appearance/domain/appearance_presets.dart';
import '../../features/appearance/domain/appearance_settings.dart';
import '../../features/appearance/domain/device_appearance_profile.dart';

final appBackgroundWarningProvider = StateProvider<String?>((ref) => null);

class AppBackground extends StatefulWidget {
  const AppBackground({
    required this.settings,
    required this.deviceProfile,
    required this.brightness,
    required this.child,
    super.key,
    this.imageProviders = const {},
    this.unavailableImageIds = const {},
    this.onWarningChanged,
  });

  final AppearanceSettings settings;
  final DeviceAppearanceProfile deviceProfile;
  final Brightness brightness;
  final Widget child;
  final Map<String, ImageProvider<Object>> imageProviders;
  final Set<String> unavailableImageIds;
  final ValueChanged<String?>? onWarningChanged;

  static Alignment focusAlignment(double x, double y) {
    return Alignment(
      x.clamp(0.0, 1.0) * 2 - 1,
      y.clamp(0.0, 1.0) * 2 - 1,
    );
  }

  static String? metadataWarning(
    AppearanceSettings settings,
    DeviceAppearanceProfile profile,
    Map<String, ImageProvider<Object>> imageProviders,
    Set<String> unavailableImageIds,
  ) {
    final imageId = profile.localBackgroundImageId ??
        (settings.background.kind == BackgroundKind.syncedImage
            ? settings.background.imageId
            : null);
    if (imageId == null) {
      return null;
    }
    if (unavailableImageIds.contains(imageId) ||
        !imageProviders.containsKey(imageId)) {
      return '所选背景图片不可用，已改用上一次的纯色背景。';
    }
    return null;
  }

  @override
  State<AppBackground> createState() => _AppBackgroundState();
}

class _AppBackgroundState extends State<AppBackground> {
  String? _lastReportedWarning;

  @override
  Widget build(BuildContext context) {
    final metadataWarning = AppBackground.metadataWarning(
      widget.settings,
      widget.deviceProfile,
      widget.imageProviders,
      widget.unavailableImageIds,
    );
    _reportWarning(metadataWarning);
    final background = _buildBackground(metadataWarning);
    final blurSigma = widget.deviceProfile.backgroundBlur;
    final combinedOverlay = (widget.deviceProfile.backgroundOverlay +
            (widget.brightness == Brightness.dark
                ? widget.settings.darkOverlay
                : 0))
        .clamp(0.0, 1.0);

    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(child: background),
        if (blurSigma > 0)
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: blurSigma,
                sigmaY: blurSigma,
              ),
              child: const SizedBox.expand(),
            ),
          ),
        Positioned.fill(
          child: ColoredBox(
            color: Colors.black.withValues(alpha: combinedOverlay),
          ),
        ),
        widget.child,
      ],
    );
  }

  Widget _buildBackground(String? metadataWarning) {
    if (metadataWarning != null) {
      return _fallback(metadataWarning);
    }

    final localImageId = widget.deviceProfile.localBackgroundImageId;
    if (localImageId != null) {
      return _storedBackground(widget.imageProviders[localImageId]!);
    }

    return switch (widget.settings.background.kind) {
      BackgroundKind.presetColor || BackgroundKind.customColor => ColoredBox(
          color: widget.settings.background.color!.toColor(),
        ),
      BackgroundKind.bundledImage => _imageEffects(
          Image.asset(
            widget.settings.background.assetPath!,
            fit: BoxFit.cover,
            alignment: _focus,
            errorBuilder: (_, __, ___) => _fallback(
              '内置背景图片无法解码，已改用上一次的纯色背景。',
            ),
          ),
        ),
      BackgroundKind.syncedImage => _storedBackground(
          widget.imageProviders[widget.settings.background.imageId!]!,
        ),
    };
  }

  Widget _storedBackground(ImageProvider<Object> imageProvider) {
    return _imageEffects(
      Image(
        image: imageProvider,
        fit: BoxFit.cover,
        alignment: _focus,
        errorBuilder: (_, __, ___) => _fallback(
          '所选背景文件丢失或损坏，已改用上一次的纯色背景。',
        ),
      ),
    );
  }

  Widget _imageEffects(Widget image) {
    Widget result = Transform.scale(
      scale: widget.deviceProfile.backgroundZoom,
      alignment: _focus,
      child: image,
    );
    if (widget.brightness == Brightness.dark) {
      result = ColorFiltered(
        colorFilter: const ColorFilter.matrix(_darkDesaturationMatrix),
        child: result,
      );
    }
    return result;
  }

  Widget _fallback(String warning) {
    _reportWarning(warning);
    return Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(color: widget.settings.lastPureBackground.toColor()),
        const SizedBox.shrink(key: Key('app-background-warning')),
      ],
    );
  }

  Alignment get _focus => AppBackground.focusAlignment(
        widget.deviceProfile.backgroundFocusX,
        widget.deviceProfile.backgroundFocusY,
      );

  void _reportWarning(String? warning) {
    if (_lastReportedWarning == warning) {
      return;
    }
    _lastReportedWarning = warning;
    final callback = widget.onWarningChanged;
    if (callback == null) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        callback(warning);
      }
    });
  }
}

const _darkDesaturationMatrix = <double>[
  0.4486,
  0.5005,
  0.0509,
  0,
  0,
  0.1486,
  0.8005,
  0.0509,
  0,
  0,
  0.1486,
  0.5005,
  0.3509,
  0,
  0,
  0,
  0,
  0,
  1,
  0,
];
