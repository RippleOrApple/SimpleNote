import 'package:flutter/material.dart';

import '../domain/appearance_presets.dart';
import '../domain/custom_color.dart';
import '../domain/rgb_color.dart';

enum AppearanceColorTarget { background, accent, notePaper }

class ColorSettingsSection extends StatefulWidget {
  const ColorSettingsSection({
    required this.accent,
    required this.background,
    required this.notePaper,
    required this.customColors,
    required this.onApplyColor,
    required this.onSaveCustomColor,
    required this.onRenameCustomColor,
    required this.onReorderCustomColors,
    required this.onDeleteCustomColor,
    required this.onExtractColors,
    super.key,
  });

  final RgbColor accent;
  final RgbColor background;
  final RgbColor notePaper;
  final List<CustomColor> customColors;
  final Future<void> Function(
    AppearanceColorTarget target,
    RgbColor color,
  ) onApplyColor;
  final Future<void> Function(String name, RgbColor color) onSaveCustomColor;
  final Future<void> Function(String id, String name) onRenameCustomColor;
  final Future<void> Function(List<String> orderedIds) onReorderCustomColors;
  final Future<void> Function(String id) onDeleteCustomColor;
  final Future<List<RgbColor>> Function() onExtractColors;

  @override
  State<ColorSettingsSection> createState() => _ColorSettingsSectionState();
}

class _ColorSettingsSectionState extends State<ColorSettingsSection> {
  final _rgbController = TextEditingController();
  AppearanceColorTarget _target = AppearanceColorTarget.accent;
  String? _validationError;
  String? _operationError;
  bool _extracting = false;

  @override
  void dispose() {
    _rgbController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Colors', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        _PresetRow(
          title: 'Background',
          keyPrefix: 'background-preset',
          colors: AppearancePresets.backgroundColors,
          selected: widget.background,
          onSelected: (color) => widget.onApplyColor(
            AppearanceColorTarget.background,
            color,
          ),
        ),
        _PresetRow(
          title: 'Accent',
          keyPrefix: 'accent-preset',
          colors: AppearancePresets.accentColors,
          selected: widget.accent,
          onSelected: (color) => widget.onApplyColor(
            AppearanceColorTarget.accent,
            color,
          ),
        ),
        _PresetRow(
          title: 'Note paper',
          keyPrefix: 'note-paper',
          colors: AppearancePresets.notePaperColors,
          selected: widget.notePaper,
          onSelected: (color) => widget.onApplyColor(
            AppearanceColorTarget.notePaper,
            color,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<AppearanceColorTarget>(
          key: const Key('appearance-color-target'),
          initialValue: _target,
          decoration: const InputDecoration(labelText: 'Color target'),
          items: const [
            DropdownMenuItem(
              value: AppearanceColorTarget.background,
              child: Text('Background'),
            ),
            DropdownMenuItem(
              value: AppearanceColorTarget.accent,
              child: Text('Accent'),
            ),
            DropdownMenuItem(
              value: AppearanceColorTarget.notePaper,
              child: Text('Note paper'),
            ),
          ],
          onChanged: (target) {
            if (target != null) {
              setState(() => _target = target);
            }
          },
        ),
        const SizedBox(height: 8),
        TextField(
          key: const Key('appearance-rgb-field'),
          controller: _rgbController,
          decoration: InputDecoration(
            labelText: 'RGB or HEX',
            hintText: '#5E9D83 or 94,157,131',
            errorText: _validationError,
          ),
          onSubmitted: (_) => _applyEnteredColor(),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FilledButton.icon(
              key: const Key('appearance-save-color-button'),
              onPressed: _applyEnteredColor,
              icon: const Icon(Icons.palette_outlined),
              label: const Text('Apply and save'),
            ),
            OutlinedButton.icon(
              key: const Key('appearance-extract-color-button'),
              onPressed: _extracting ? null : _extractColors,
              icon: const Icon(Icons.colorize_outlined),
              label: const Text('Extract from image'),
            ),
          ],
        ),
        if (_operationError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              _operationError!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Text(
                'My Colors',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Text('${widget.customColors.length}/24'),
          ],
        ),
        const SizedBox(height: 6),
        if (widget.customColors.isEmpty)
          const Text('Saved colors will appear here.')
        else
          ReorderableListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            buildDefaultDragHandles: false,
            itemCount: widget.customColors.length,
            onReorderItem: _reorder,
            itemBuilder: (context, index) {
              final entry = widget.customColors[index];
              return ListTile(
                key: ValueKey('custom-color-${entry.id}'),
                contentPadding: EdgeInsets.zero,
                leading: _ColorDot(color: entry.color, selected: false),
                title: Text(entry.name),
                subtitle: Text(entry.color.toHex()),
                onTap: () => widget.onApplyColor(_target, entry.color),
                trailing: Wrap(
                  spacing: 2,
                  children: [
                    IconButton(
                      tooltip: 'Rename ${entry.name}',
                      onPressed: () => _rename(entry),
                      icon: const Icon(Icons.edit_outlined),
                    ),
                    IconButton(
                      tooltip: 'Delete ${entry.name}',
                      onPressed: () => widget.onDeleteCustomColor(entry.id),
                      icon: const Icon(Icons.delete_outline),
                    ),
                    ReorderableDragStartListener(
                      index: index,
                      child: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Icon(Icons.drag_handle),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }

  Future<void> _applyEnteredColor() async {
    final RgbColor color;
    try {
      color = RgbColor.parse(_rgbController.text);
    } on FormatException catch (error) {
      setState(() => _validationError = error.message);
      return;
    }
    setState(() {
      _validationError = null;
      _operationError = null;
    });
    try {
      await widget.onApplyColor(_target, color);
      await widget.onSaveCustomColor('Custom ${color.toHex()}', color);
    } catch (error) {
      if (mounted) {
        setState(() => _operationError = error.toString());
      }
    }
  }

  Future<void> _extractColors() async {
    setState(() {
      _extracting = true;
      _operationError = null;
    });
    try {
      final colors = await widget.onExtractColors();
      if (!mounted || colors.isEmpty) {
        return;
      }
      await showModalBottomSheet<void>(
        context: context,
        builder: (context) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                for (final color in colors)
                  InkWell(
                    onTap: () async {
                      Navigator.of(context).pop();
                      await widget.onApplyColor(_target, color);
                    },
                    borderRadius: BorderRadius.circular(28),
                    child: _ColorDot(color: color, selected: false, size: 52),
                  ),
              ],
            ),
          ),
        ),
      );
    } catch (error) {
      if (mounted) {
        setState(() => _operationError = error.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _extracting = false);
      }
    }
  }

  Future<void> _rename(CustomColor entry) async {
    final controller = TextEditingController(text: entry.name);
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename color'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (name?.trim().isNotEmpty == true) {
      await widget.onRenameCustomColor(entry.id, name!.trim());
    }
  }

  Future<void> _reorder(int oldIndex, int newIndex) async {
    final entries = widget.customColors.toList();
    final moved = entries.removeAt(oldIndex);
    entries.insert(newIndex, moved);
    await widget.onReorderCustomColors(
      entries.map((entry) => entry.id).toList(),
    );
  }
}

class _PresetRow extends StatelessWidget {
  const _PresetRow({
    required this.title,
    required this.keyPrefix,
    required this.colors,
    required this.selected,
    required this.onSelected,
  });

  final String title;
  final String keyPrefix;
  final List<RgbColor> colors;
  final RgbColor selected;
  final ValueChanged<RgbColor> onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 104, child: Text(title)),
          Expanded(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final color in colors)
                  InkWell(
                    key: Key('$keyPrefix-${_hex(color)}'),
                    onTap: () => onSelected(color),
                    borderRadius: BorderRadius.circular(24),
                    child: _ColorDot(
                      color: color,
                      selected: color == selected,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ColorDot extends StatelessWidget {
  const _ColorDot({
    required this.color,
    required this.selected,
    this.size = 36,
  });

  final RgbColor color;
  final bool selected;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.toColor(),
        shape: BoxShape.circle,
        border: Border.all(
          color: selected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).dividerColor,
          width: selected ? 3 : 1,
        ),
      ),
      child: selected
          ? Icon(
              Icons.check,
              size: 18,
              color: ThemeData.estimateBrightnessForColor(color.toColor()) ==
                      Brightness.dark
                  ? Colors.white
                  : Colors.black,
            )
          : null,
    );
  }
}

String _hex(RgbColor color) {
  return color.value.toRadixString(16).padLeft(6, '0').toUpperCase();
}
