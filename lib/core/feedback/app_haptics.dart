import 'package:flutter/services.dart';

import '../../features/appearance/domain/appearance_presets.dart';

enum HapticEvent { complete, delete, navigation, selection, reorder }

abstract interface class HapticDriver {
  Future<void> lightImpact();
  Future<void> mediumImpact();
  Future<void> selectionClick();
}

final class FlutterHapticDriver implements HapticDriver {
  const FlutterHapticDriver();

  @override
  Future<void> lightImpact() => HapticFeedback.lightImpact();

  @override
  Future<void> mediumImpact() => HapticFeedback.mediumImpact();

  @override
  Future<void> selectionClick() => HapticFeedback.selectionClick();
}

final class AppHaptics {
  const AppHaptics({
    required this.platform,
    this.mode = HapticsMode.off,
    this.driver = const FlutterHapticDriver(),
  });

  final HapticsMode mode;
  final String platform;
  final HapticDriver driver;

  Future<void> trigger(HapticEvent event) async {
    if (platform.toLowerCase() != 'android' || mode == HapticsMode.off) {
      return;
    }
    if (mode == HapticsMode.keyActions &&
        event != HapticEvent.complete &&
        event != HapticEvent.delete) {
      return;
    }

    await switch (event) {
      HapticEvent.complete => driver.lightImpact(),
      HapticEvent.delete => driver.mediumImpact(),
      HapticEvent.navigation => driver.lightImpact(),
      HapticEvent.selection => driver.selectionClick(),
      HapticEvent.reorder => driver.mediumImpact(),
    };
  }
}
