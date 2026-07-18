import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/accessibility/transparency_preference.dart';
import 'core/routing/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'core/motion/app_motion.dart';
import 'features/appearance/application/appearance_controller.dart';
import 'features/appearance/domain/appearance_presets.dart';
import 'features/appearance/domain/appearance_settings.dart';
import 'features/appearance/domain/device_appearance_profile.dart';
import 'features/appearance/infrastructure/background_image_render_adapter.dart';
import 'features/attachments/presentation/pending_attachment_recovery_prompt.dart';
import 'features/navigation/presentation/adaptive_app_shell.dart';
import 'features/sync/data/sync_repository.dart';
import 'shared/widgets/app_background.dart';
import 'shared/widgets/frosted_surface.dart';

class SimpleNoteApp extends ConsumerWidget {
  const SimpleNoteApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appearance = ref.watch(appearanceControllerProvider).valueOrNull;
    final device = ref.watch(deviceInfoProvider);
    final settings = appearance?.portable ?? AppearanceSettings.defaults();
    final profile = appearance?.deviceProfile ??
        DeviceAppearanceProfile.defaults(
          id: '${device.deviceId}:${device.platform}',
          platform: device.platform,
          updatedAt: 0,
        );
    final transparencyPreference =
        ref.watch(transparencyPreferenceProvider).valueOrNull ??
            const TransparencyPreference.unsupported();
    final requiresCatalog = profile.localBackgroundImageId != null ||
        settings.background.kind == BackgroundKind.syncedImage;
    final catalog = requiresCatalog
        ? ref.watch(backgroundRenderCatalogProvider).valueOrNull
        : null;
    final platformDispatcher = WidgetsBinding.instance.platformDispatcher;
    final reduceMotion =
        platformDispatcher.accessibilityFeatures.disableAnimations;
    final platformBrightness = platformDispatcher.platformBrightness;
    final theme = AppTheme.fromAppearance(
      settings,
      platformBrightness,
      reduceMotion: reduceMotion,
    ).copyWith(visualDensity: AppTheme.visualDensityFor(profile.density));
    final routeDuration =
        theme.extension<AppMotionTheme>()?.routeDuration ?? AppMotion.standard;

    return MaterialApp(
      title: '简记',
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: const PendingAttachmentRecoveryPrompt(
        child: AdaptiveAppShell(),
      ),
      onGenerateRoute: (routeSettings) => AppRoutes.onGenerateRoute(
        routeSettings,
        transitionDuration: routeDuration,
      ),
      builder: (context, child) {
        final accessibility = AppAccessibilityPolicy.fromMediaQueryData(
          MediaQuery.of(context),
          transparencyPreference: transparencyPreference,
        );
        final effectiveTheme = AppTheme.fromAppearance(
          settings,
          MediaQuery.platformBrightnessOf(context),
          reduceMotion: accessibility.reduceMotion,
        ).copyWith(visualDensity: AppTheme.visualDensityFor(profile.density));
        return AppAccessibilityPolicyScope(
          policy: accessibility,
          child: Theme(
            data: effectiveTheme,
            child: AppBackground(
              settings: settings,
              deviceProfile: profile,
              imageProviders: catalog?.imageProviders ?? const {},
              unavailableImageIds: catalog?.unavailableImageIds ?? const {},
              brightness: effectiveTheme.brightness,
              onWarningChanged: (warning) {
                final current = ref.read(appBackgroundWarningProvider);
                if (current != warning) {
                  ref.read(appBackgroundWarningProvider.notifier).state =
                      warning;
                }
              },
              child: child ?? const SizedBox.shrink(),
            ),
          ),
        );
      },
    );
  }
}
