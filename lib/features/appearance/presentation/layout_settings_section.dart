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
        Text('布局与效果', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 10),
        DropdownButtonFormField<AppBrightnessMode>(
          key: const Key('appearance-brightness-mode'),
          initialValue: settings.brightnessMode,
          decoration: const InputDecoration(labelText: '明暗模式'),
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
          decoration: const InputDecoration(labelText: '布局密度'),
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
          label: '染色',
          value: settings.tintStrength,
          onChanged: onTintChanged,
        ),
        _EffectSlider(
          key: const Key('appearance-glass-slider'),
          label: '玻璃',
          value: settings.glassOpacity,
          onChanged: onGlassChanged,
        ),
        _EffectSlider(
          key: const Key('appearance-dark-overlay-slider'),
          label: '暗色遮罩',
          value: settings.darkOverlay,
          onChanged: onDarkOverlayChanged,
        ),
        DropdownButtonFormField<MotionLevel>(
          key: const Key('appearance-motion-level'),
          initialValue: settings.motion,
          decoration: const InputDecoration(labelText: '动效'),
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
          decoration: const InputDecoration(labelText: '触感'),
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
            child: Text('触感反馈仅在 Android 上可用。'),
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
  return switch (name) {
    'system' => '跟随系统',
    'light' => '浅色',
    'dark' => '深色',
    'compact' => '紧凑',
    'comfortable' => '舒适',
    'spacious' => '宽松',
    'relaxed' => '宽松',
    'reduced' => '减少',
    'standard' => '标准',
    'natural' => '自然',
    'expressive' => '丰富',
    _ => name,
  };
}

String _hapticsLabel(HapticsMode mode) {
  return switch (mode) {
    HapticsMode.off => '关闭',
    HapticsMode.keyActions => '关键操作',
    HapticsMode.rich => '丰富',
  };
}
