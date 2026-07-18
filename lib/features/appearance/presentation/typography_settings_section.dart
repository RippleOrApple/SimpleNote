import 'package:flutter/material.dart';

import '../../../core/theme/typography_preferences.dart';
import '../domain/appearance_presets.dart';

class TypographySettingsSection extends StatelessWidget {
  const TypographySettingsSection({
    required this.typography,
    required this.onChanged,
    super.key,
  });

  final TypographyPreferences typography;
  final ValueChanged<TypographyPreferences> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Typography', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 10),
        const ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text('Interface: Resource Han Rounded CN'),
          subtitle: Text(
            'Noto Sans SC is used as a fallback. Notes use LXGW WenKai.',
          ),
        ),
        DropdownButtonFormField<UiScale>(
          key: const Key('appearance-ui-scale'),
          initialValue: typography.uiScale,
          decoration: const InputDecoration(labelText: 'Interface scale'),
          items: [
            for (final scale in UiScale.values)
              DropdownMenuItem(
                value: scale,
                child: Text(_label(scale.name)),
              ),
          ],
          onChanged: (value) {
            if (value != null) {
              onChanged(typography.copyWith(uiScale: value));
            }
          },
        ),
        _TypographySlider(
          key: const Key('appearance-note-size-slider'),
          label: 'Note size',
          value: typography.noteFontSize,
          min: 14,
          max: 28,
          onChanged: (value) => onChanged(
            typography.copyWith(noteFontSize: value),
          ),
        ),
        _TypographySlider(
          key: const Key('appearance-note-line-height-slider'),
          label: 'Line height',
          value: typography.noteLineHeight,
          min: 1.3,
          max: 2.2,
          onChanged: (value) => onChanged(
            typography.copyWith(noteLineHeight: value),
          ),
        ),
      ],
    );
  }
}

class _TypographySlider extends StatelessWidget {
  const _TypographySlider({
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
        SizedBox(width: 92, child: Text(label)),
        Expanded(
          child: Slider(
            value: value,
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ),
        SizedBox(width: 46, child: Text(value.toStringAsFixed(1))),
      ],
    );
  }
}

String _label(String name) {
  return '${name[0].toUpperCase()}${name.substring(1)}';
}
