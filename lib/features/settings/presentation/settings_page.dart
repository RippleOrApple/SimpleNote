import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/app_shell.dart';
import '../../sync/application/sync_controller.dart';
import '../../sync/domain/sync_result.dart';
import '../application/theme_controller.dart';
import '../domain/theme_scheme.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  final _themeNameController = TextEditingController();
  final _peerAddressController = TextEditingController();

  static const _backgroundSwatches = [
    Color(0xFFF8F8F6),
    Color(0xFFF4F7FA),
    Color(0xFFF3F8EF),
    Color(0xFFF8F5FF),
    Color(0xFF111318),
  ];

  static const _primarySwatches = [
    Color(0xFF4F46E5),
    Color(0xFF2563EB),
    Color(0xFF2F6F4E),
    Color(0xFF7C3AED),
    Color(0xFF8AB4F8),
  ];

  static const _textSwatches = [
    Color(0xFF202124),
    Color(0xFF1F2937),
    Color(0xFF203128),
    Color(0xFF2B213A),
    Color(0xFFE8EAED),
  ];

  static const _surfaceSwatches = [
    Color(0xFFFFFFFF),
    Color(0xFFF8FAFC),
    Color(0xFFF1F5F9),
    Color(0xFFEFF6FF),
    Color(0xFF1F232B),
  ];

  @override
  void dispose() {
    _themeNameController.dispose();
    _peerAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeControllerProvider);

    return AppShell(
      title: 'Settings',
      child: themeState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) =>
            Center(child: Text('Could not load theme settings: $error')),
        data: _buildContent,
      ),
    );
  }

  Widget _buildContent(ThemeState state) {
    final controller = ref.read(themeControllerProvider.notifier);
    final syncState = ref.watch(syncControllerProvider);
    final syncController = ref.read(syncControllerProvider.notifier);
    final activeTheme = state.activeTheme;

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 840),
        child: ListView(
          key: const Key('settings-list'),
          padding: const EdgeInsets.all(16),
          children: [
            Text('Theme', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            _ThemePreview(theme: activeTheme),
            const SizedBox(height: 20),
            Text('Presets', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final preset in AppThemeScheme.presets)
                  ChoiceChip(
                    label: Text(preset.name),
                    selected: activeTheme.id == preset.id,
                    onSelected: (_) => controller.applyTheme(preset),
                  ),
              ],
            ),
            const Divider(height: 36),
            Text('Customize', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            _ColorSwatchRow(
              keyPrefix: 'background',
              label: 'Background',
              colors: _backgroundSwatches,
              selectedColor: activeTheme.backgroundColor,
              onSelected: (color) =>
                  controller.updateDraft(backgroundColor: color),
            ),
            _ColorSwatchRow(
              keyPrefix: 'primary',
              label: 'Action button',
              colors: _primarySwatches,
              selectedColor: activeTheme.primaryColor,
              onSelected: (color) =>
                  controller.updateDraft(primaryColor: color),
            ),
            _ColorSwatchRow(
              keyPrefix: 'text',
              label: 'Text',
              colors: _textSwatches,
              selectedColor: activeTheme.textColor,
              onSelected: (color) => controller.updateDraft(textColor: color),
            ),
            _ColorSwatchRow(
              keyPrefix: 'surface',
              label: 'Surface',
              colors: _surfaceSwatches,
              selectedColor: activeTheme.surfaceColor,
              onSelected: (color) =>
                  controller.updateDraft(surfaceColor: color),
            ),
            const SizedBox(height: 8),
            SegmentedButton<Brightness>(
              segments: const [
                ButtonSegment(
                  value: Brightness.light,
                  icon: Icon(Icons.light_mode_outlined),
                  label: Text('Light'),
                ),
                ButtonSegment(
                  value: Brightness.dark,
                  icon: Icon(Icons.dark_mode_outlined),
                  label: Text('Dark'),
                ),
              ],
              selected: {activeTheme.brightness},
              onSelectionChanged: (values) =>
                  controller.updateDraft(brightness: values.first),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    key: const Key('custom-theme-name-field'),
                    controller: _themeNameController,
                    decoration: const InputDecoration(
                      labelText: 'Theme name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  key: const Key('save-custom-theme-button'),
                  onPressed: () {
                    controller.saveCustomTheme(
                      name: _themeNameController.text,
                    );
                    _themeNameController.clear();
                  },
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('Save'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: FilledButton.tonalIcon(
                onPressed: controller.restoreDefaultTheme,
                icon: const Icon(Icons.restart_alt),
                label: const Text('Restore default theme'),
              ),
            ),
            const Divider(height: 36),
            Text('Saved Themes',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            for (final savedTheme in state.savedThemes)
              ListTile(
                key: Key('saved-theme-${savedTheme.id}'),
                leading: CircleAvatar(backgroundColor: savedTheme.primaryColor),
                title: Text(savedTheme.name),
                subtitle: Text(
                  savedTheme.brightness == Brightness.dark ? 'Dark' : 'Light',
                ),
                selected: activeTheme.id == savedTheme.id,
                trailing: activeTheme.id == savedTheme.id
                    ? const Icon(Icons.check_circle)
                    : IconButton(
                        tooltip: 'Apply ${savedTheme.name}',
                        onPressed: () => controller.applyTheme(savedTheme),
                        icon: const Icon(Icons.check_circle_outline),
                      ),
              ),
            const Divider(height: 36),
            Text('Sync', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            _SyncPanel(
              state: syncState,
              peerAddressController: _peerAddressController,
              onPeerAddressChanged: syncController.updatePeerAddress,
              onStartServer: syncController.startServer,
              onStopServer: syncController.stopServer,
              onSync: () => syncController.syncWithPeer(),
            ),
          ],
        ),
      ),
    );
  }
}

class _SyncPanel extends StatelessWidget {
  const _SyncPanel({
    required this.state,
    required this.peerAddressController,
    required this.onPeerAddressChanged,
    required this.onStartServer,
    required this.onStopServer,
    required this.onSync,
  });

  final SyncState state;
  final TextEditingController peerAddressController;
  final ValueChanged<String> onPeerAddressChanged;
  final VoidCallback onStartServer;
  final VoidCallback onStopServer;
  final VoidCallback onSync;

  @override
  Widget build(BuildContext context) {
    if (peerAddressController.text != state.peerAddress) {
      peerAddressController.text = state.peerAddress;
    }
    final syncing = state.status == SyncStatus.syncing ||
        state.status == SyncStatus.startingServer;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.wifi_tethering_outlined),
          title: const Text('LAN sync'),
          subtitle: Text(
            state.serverUri == null
                ? 'Start a local server, then enter a peer address on another device.'
                : 'Server: ${state.serverUri}',
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FilledButton.icon(
              key: const Key('sync-start-server-button'),
              onPressed:
                  syncing || state.isServerRunning ? null : onStartServer,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Start server'),
            ),
            OutlinedButton.icon(
              key: const Key('sync-stop-server-button'),
              onPressed: state.isServerRunning ? onStopServer : null,
              icon: const Icon(Icons.stop),
              label: const Text('Stop server'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                key: const Key('sync-peer-address-field'),
                controller: peerAddressController,
                decoration: const InputDecoration(
                  labelText: 'Peer address',
                  hintText: 'http://192.168.1.10:8787',
                  border: OutlineInputBorder(),
                ),
                onChanged: onPeerAddressChanged,
              ),
            ),
            const SizedBox(width: 8),
            FilledButton.icon(
              key: const Key('sync-now-button'),
              onPressed: syncing ? null : onSync,
              icon: const Icon(Icons.sync),
              label: const Text('Sync'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (state.status == SyncStatus.syncing ||
            state.status == SyncStatus.startingServer)
          const LinearProgressIndicator(),
        if (state.errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              state.errorMessage!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        if (state.lastResult != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(_formatSyncResult(state.lastResult!)),
          ),
      ],
    );
  }

  String _formatSyncResult(SyncResult result) {
    return 'Synced: notes +${result.notesCreated}/${result.notesUpdated}, '
        'todos +${result.todosCreated}/${result.todosUpdated}.';
  }
}

class _ThemePreview extends StatelessWidget {
  const _ThemePreview({required this.theme});

  final AppThemeScheme theme;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.surfaceColor,
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(backgroundColor: theme.primaryColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    theme.name,
                    style: TextStyle(
                      color: theme.textColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Background, buttons, text, and surfaces',
                    style: TextStyle(color: theme.textColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorSwatchRow extends StatelessWidget {
  const _ColorSwatchRow({
    required this.keyPrefix,
    required this.label,
    required this.colors,
    required this.selectedColor,
    required this.onSelected,
  });

  final String keyPrefix;
  final String label;
  final List<Color> colors;
  final Color selectedColor;
  final ValueChanged<Color> onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 112,
            child: Text(label),
          ),
          Expanded(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final color in colors)
                  _ColorSwatch(
                    key: Key('$keyPrefix-swatch-${color.toARGB32()}'),
                    color: color,
                    selected: color.toARGB32() == selectedColor.toARGB32(),
                    onSelected: () => onSelected(color),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  const _ColorSwatch({
    required this.color,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final Color color;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    final borderColor =
        selected ? Theme.of(context).colorScheme.primary : Colors.black26;

    return Tooltip(
      message: '#${color.toARGB32().toRadixString(16).padLeft(8, '0')}',
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onSelected,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            border: Border.all(color: borderColor, width: selected ? 3 : 1),
          ),
          child: SizedBox.square(
            dimension: 36,
            child: selected
                ? Icon(
                    Icons.check,
                    color: ThemeData.estimateBrightnessForColor(color) ==
                            Brightness.dark
                        ? Colors.white
                        : Colors.black,
                    size: 18,
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
