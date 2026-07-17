import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/app_background.dart';
import '../../../shared/widgets/frosted_surface.dart';
import '../application/appearance_controller.dart';
import '../application/appearance_image_picker.dart';
import '../domain/appearance_presets.dart';
import '../domain/appearance_settings.dart';
import '../domain/rgb_color.dart';
import '../infrastructure/background_image_render_adapter.dart';
import '../infrastructure/background_image_service.dart';
import 'background_settings_section.dart';
import 'color_settings_section.dart';
import 'layout_settings_section.dart';
import 'typography_settings_section.dart';

class AppearancePage extends ConsumerWidget {
  const AppearancePage({
    super.key,
    this.embedded = false,
  });

  final bool embedded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appearanceControllerProvider);
    return state.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Text('Appearance settings could not be loaded: $error'),
      ),
      data: (appearance) {
        final content = _AppearanceContent(
          state: appearance,
          ref: ref,
        );
        if (embedded) {
          return content;
        }
        return SingleChildScrollView(
          key: const Key('appearance-list'),
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 860),
              child: content,
            ),
          ),
        );
      },
    );
  }
}

class _AppearanceContent extends StatelessWidget {
  const _AppearanceContent({
    required this.state,
    required this.ref,
  });

  final AppearanceState state;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(appearanceControllerProvider.notifier);
    final portable = state.portable;
    final profile = state.deviceProfile;
    final warning = ref.watch(appBackgroundWarningProvider);
    final requiresCatalog = profile.localBackgroundImageId != null ||
        portable.background.kind == BackgroundKind.syncedImage;
    final catalog = requiresCatalog
        ? ref.watch(backgroundRenderCatalogProvider).valueOrNull
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FrostedSurface(
          glassOpacity: portable.glassOpacity,
          padding: const EdgeInsets.all(16),
          child: ColorSettingsSection(
            accent: portable.accent,
            background:
                portable.background.color ?? portable.lastPureBackground,
            notePaper: portable.notePaper,
            customColors: state.customColors,
            onApplyColor: (target, color) =>
                _applyColor(controller, target, color),
            onSaveCustomColor: (name, color) =>
                controller.addCustomColor(name: name, color: color),
            onRenameCustomColor: controller.renameCustomColor,
            onReorderCustomColors: controller.reorderCustomColors,
            onDeleteCustomColor: controller.deleteCustomColor,
            onExtractColors: () => _extractColors(ref),
          ),
        ),
        const SizedBox(height: 20),
        FrostedSurface(
          glassOpacity: portable.glassOpacity,
          padding: const EdgeInsets.all(16),
          child: BackgroundSettingsSection(
            settings: portable,
            profile: profile,
            platform: profile.platform,
            brightness: Theme.of(context).brightness,
            warning: warning,
            imageProviders: catalog?.imageProviders ?? const {},
            unavailableImageIds: catalog?.unavailableImageIds ?? const {},
            onSelectBundled: (assetPath) => _selectPortableBackground(
              controller,
              BackgroundSelection.bundledImage(assetPath),
            ),
            onImportImage: (source, syncEnabled) => _importBackground(
              ref,
              controller,
              source,
              syncEnabled,
            ),
            onPresentationChanged: controller.setBackgroundPresentation,
          ),
        ),
        const SizedBox(height: 20),
        FrostedSurface(
          glassOpacity: portable.glassOpacity,
          padding: const EdgeInsets.all(16),
          child: TypographySettingsSection(
            typography: portable.typography,
            onChanged: controller.setTypography,
          ),
        ),
        const SizedBox(height: 20),
        FrostedSurface(
          glassOpacity: portable.glassOpacity,
          padding: const EdgeInsets.all(16),
          child: LayoutSettingsSection(
            settings: portable,
            profile: profile,
            platform: profile.platform,
            onTintChanged: controller.setTintStrength,
            onGlassChanged: controller.setGlassOpacity,
            onDarkOverlayChanged: controller.setDarkOverlay,
            onDensityChanged: controller.setDensity,
            onMotionChanged: controller.setMotion,
            onHapticsChanged: controller.setHaptics,
            onBrightnessChanged: controller.setBrightnessMode,
          ),
        ),
      ],
    );
  }
}

Future<void> _applyColor(
  AppearanceController controller,
  AppearanceColorTarget target,
  RgbColor color,
) async {
  switch (target) {
    case AppearanceColorTarget.background:
      await _selectPortableBackground(
        controller,
        AppearancePresets.backgroundColors.contains(color)
            ? BackgroundSelection.presetColor(color)
            : BackgroundSelection.customColor(color),
      );
    case AppearanceColorTarget.accent:
      await controller.setAccent(color);
    case AppearanceColorTarget.notePaper:
      await controller.setNotePaper(color);
  }
}

Future<void> _selectPortableBackground(
  AppearanceController controller,
  BackgroundSelection background,
) async {
  await controller.setLocalBackgroundImage(null);
  await controller.setBackground(background);
}

Future<List<RgbColor>> _extractColors(WidgetRef ref) async {
  final source = await ref
      .read(appearanceImagePickerProvider)
      .pick(AppearanceImageSource.files);
  if (source == null) {
    return const [];
  }
  final service = await ref.read(backgroundImageServiceProvider.future);
  return service.extractColors(source);
}

Future<void> _importBackground(
  WidgetRef ref,
  AppearanceController controller,
  AppearanceImageSource source,
  bool syncEnabled,
) async {
  final selected = await ref.read(appearanceImagePickerProvider).pick(source);
  if (selected == null) {
    return;
  }
  final service = await ref.read(backgroundImageServiceProvider.future);
  final imported = await service.importImage(
    selected,
    syncEnabled: syncEnabled,
  );
  if (syncEnabled) {
    await controller.setLocalBackgroundImage(null);
    await controller.setBackground(
      BackgroundSelection.syncedImage(imported.id),
    );
  } else {
    await controller.setLocalBackgroundImage(imported.id);
  }
  ref.invalidate(backgroundImageCatalogProvider);
}
