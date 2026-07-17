import 'package:flutter/material.dart';

import '../domain/appearance_presets.dart';
import '../domain/appearance_settings.dart';
import '../domain/device_appearance_profile.dart';

class LayoutSettingsSection extends StatelessWidget {
  const LayoutSettingsSection({
    required this.settings,
    required this.profile,
    required this.platform,
    required this.onTintChanged,
    required this.onGlassChanged,
    required this.onDarkOverlayChanged,
    required this.onDensityChanged,
    required this.onMotionChanged,
    required this.onHapticsChanged,
    required this.onBrightnessChanged,
    super.key,
  });

  final AppearanceSettings settings;
  final DeviceAppearanceProfile profile;
  final String platform;
  final ValueChanged<double> onTintChanged;
  final ValueChanged<double> onGlassChanged;
  final ValueChanged<double> onDarkOverlayChanged;
  final ValueChanged<LayoutDensity> onDensityChanged;
  final ValueChanged<MotionLevel> onMotionChanged;
  final ValueChanged<HapticsMode> onHapticsChanged;
  final ValueChanged<AppBrightnessMode> onBrightnessChanged;

  @override
  Widget build(BuildContext context) {
    final isAndroid = platform.toLowerCase() == 'android';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Layout and effects',
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 10),
        DropdownButtonFormField<AppBrightnessMode>(
          key: const Key('appearance-brightness-mode'),
          initialValue: settings.brightnessMode,
          decoration: const InputDecoration(labelText: 'Brightness'),
          items: [
            for (final mode in AppBrightnessMode.values)
              DropdownMenuItem(
                value: mode,
                child: Text(_label(mode.name)),
              ),
          ],
          onChanged: (value) {
            if (value != null) {
              onBrightnessChanged(value);
            }
          },
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<LayoutDensity>(
          key: const Key('appearance-density'),
          initialValue: profile.density,
          decoration: const InputDecoration(labelText: 'Layout density'),
          items: [
            for (final density in LayoutDensity.values)
              DropdownMenuItem(
                value: density,
                child: Text(_label(density.name)),
              ),
          ],
          onChanged: (value) {
            if (value != null) {
              onDensityChanged(value);
            }
          },
        ),
        _EffectSlider(
          key: const Key('appearance-tint-slider'),
          label: 'Tint',
          value: settings.tintStrength,
          onChanged: onTintChanged,
        ),
        _EffectSlider(
          key: const Key('appearance-glass-slider'),
          label: 'Glass',
          value: settings.glassOpacity,
          onChanged: onGlassChanged,
        ),
        _EffectSlider(
          key: const Key('appearance-dark-overlay-slider'),
          label: 'Dark overlay',
          value: settings.darkOverlay,
          onChanged: onDarkOverlayChanged,
        ),
        DropdownButtonFormField<MotionLevel>(
          key: const Key('appearance-motion-level'),
          initialValue: settings.motion,
          decoration: const InputDecoration(labelText: 'Motion'),
          items: [
            for (final level in MotionLevel.values)
              DropdownMenuItem(
                value: level,
                child: Text(_label(level.name)),
              ),
          ],
          onChanged: (value) {
            if (value != null) {
              onMotionChanged(value);
            }
          },
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<HapticsMode>(
          key: const Key('appearance-haptics-mode'),
          initialValue: profile.hapticsMode,
          decoration: const InputDecoration(labelText: 'Haptics'),
          items: [
            for (final mode in HapticsMode.values)
              DropdownMenuItem(
                value: mode,
                child: Text(_hapticsLabel(mode)),
              ),
          ],
          onChanged: isAndroid
              ? (value) {
                  if (value != null) {
                    onHapticsChanged(value);
                  }
                }
              : null,
        ),
        if (!isAndroid)
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Text('Haptic feedback is available only on Android.'),
          ),
      ],
    );
  }
}

class _EffectSlider extends StatelessWidget {
  const _EffectSlider({
    required this.label,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final String label;
  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 102, child: Text(label)),
        Expanded(
          child: Slider(
            value: value,
            onChanged: onChanged,
          ),
        ),
        SizedBox(width: 44, child: Text('${(value * 100).round()}%')),
      ],
    );
  }
}

String _label(String name) {
  return '${name[0].toUpperCase()}${name.substring(1)}';
}

String _hapticsLabel(HapticsMode mode) {
  return switch (mode) {
    HapticsMode.off => 'Off',
    HapticsMode.keyActions => 'Key actions',
    HapticsMode.rich => 'Rich',
  };
}
