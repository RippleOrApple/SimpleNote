import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/routing/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'core/motion/app_motion.dart';
import 'features/appearance/application/appearance_controller.dart';
import 'features/appearance/domain/appearance_presets.dart';
import 'features/appearance/domain/appearance_settings.dart';
import 'features/appearance/domain/device_appearance_profile.dart';
import 'features/appearance/infrastructure/background_image_service.dart';
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
    final requiresCatalog = profile.localBackgroundImageId != null ||
        settings.background.kind == BackgroundKind.syncedImage;
    final catalog = requiresCatalog
        ? ref.watch(backgroundImageCatalogProvider).valueOrNull
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
      initialRoute: AppRoutes.home,
      onGenerateRoute: (routeSettings) => AppRoutes.onGenerateRoute(
        routeSettings,
        transitionDuration: routeDuration,
      ),
      builder: (context, child) {
        final accessibility = AppAccessibilityPolicy.of(context);
        final effectiveTheme = AppTheme.fromAppearance(
          settings,
          MediaQuery.platformBrightnessOf(context),
          reduceMotion: accessibility.reduceMotion,
        ).copyWith(visualDensity: AppTheme.visualDensityFor(profile.density));
        return Theme(
          data: effectiveTheme,
          child: AppBackground(
            settings: settings,
            deviceProfile: profile,
            backgroundImages: catalog?.availableImages ?? const [],
            unavailableImageIds: catalog?.unavailableImageIds ?? const {},
            brightness: effectiveTheme.brightness,
            onWarningChanged: (warning) {
              final current = ref.read(appBackgroundWarningProvider);
              if (current != warning) {
                ref.read(appBackgroundWarningProvider.notifier).state = warning;
              }
            },
            child: child ?? const SizedBox.shrink(),
          ),
        );
      },
    );
  }
}
