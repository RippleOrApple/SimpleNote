import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/feedback/app_haptics.dart';
import '../../appearance/application/appearance_controller.dart';
import '../../appearance/domain/appearance_presets.dart';
import '../../appearance/domain/device_appearance_profile.dart';
import '../../sync/data/sync_repository.dart';
import '../domain/app_module.dart';

final navigationControllerProvider =
    NotifierProvider<NavigationController, NavigationState>(
  NavigationController.new,
);

final class NavigationState {
  NavigationState({
    required this.platform,
    required Iterable<AppModuleKey> catalog,
    required Iterable<AppModuleKey> order,
    required Iterable<AppModuleKey> hiddenModules,
    required this.startModule,
    required this.selectedModule,
    required this.hapticsMode,
  })  : catalog = List.unmodifiable(catalog),
        order = List.unmodifiable(order),
        hiddenModules = Set.unmodifiable(hiddenModules);

  factory NavigationState.fromProfile(
    DeviceAppearanceProfile profile, {
    AppModuleKey? selectedModule,
  }) {
    final catalog = AppModuleCatalog.forPlatform(profile.platform);
    final order = AppModuleCatalog.normalizeOrder(
      profile.platform,
      profile.navOrder,
    );
    final hidden = {
      for (final key in profile.hiddenNav)
        if (AppModuleKeyX.tryParse(key) case final module?)
          if (catalog.contains(module) && module != AppModuleKey.today) module,
    };
    final savedStart = AppModuleKeyX.tryParse(profile.startModule);
    final start = savedStart != null &&
            catalog.contains(savedStart) &&
            !hidden.contains(savedStart)
        ? savedStart
        : AppModuleKey.today;
    final requestedSelection = selectedModule ?? start;
    final selected = catalog.contains(requestedSelection) &&
            hidden.contains(requestedSelection)
        ? start
        : requestedSelection;
    return NavigationState(
      platform: profile.platform,
      catalog: catalog,
      order: order,
      hiddenModules: hidden,
      startModule: start,
      selectedModule: selected,
      hapticsMode: profile.hapticsMode,
    );
  }

  final String platform;
  final List<AppModuleKey> catalog;
  final List<AppModuleKey> order;
  final Set<AppModuleKey> hiddenModules;
  final AppModuleKey startModule;
  final AppModuleKey selectedModule;
  final HapticsMode hapticsMode;

  List<AppModuleKey> get visibleModules => List.unmodifiable(
        order.where((module) => !hiddenModules.contains(module)),
      );

  AppModuleKey get navigationSelection {
    if (visibleModules.contains(selectedModule)) {
      return selectedModule;
    }
    if (visibleModules.contains(AppModuleKey.more)) {
      return AppModuleKey.more;
    }
    return startModule;
  }

  NavigationState copyWith({
    Iterable<AppModuleKey>? order,
    Iterable<AppModuleKey>? hiddenModules,
    AppModuleKey? startModule,
    AppModuleKey? selectedModule,
  }) {
    return NavigationState(
      platform: platform,
      catalog: catalog,
      order: order ?? this.order,
      hiddenModules: hiddenModules ?? this.hiddenModules,
      startModule: startModule ?? this.startModule,
      selectedModule: selectedModule ?? this.selectedModule,
      hapticsMode: hapticsMode,
    );
  }
}

final class NavigationController extends Notifier<NavigationState> {
  @override
  NavigationState build() {
    final device = ref.watch(deviceInfoProvider);
    final loadedProfile =
        ref.read(appearanceControllerProvider).valueOrNull?.deviceProfile;
    final profile = loadedProfile ??
        DeviceAppearanceProfile.defaults(
          id: '${device.deviceId}:${device.platform}',
          platform: device.platform,
          updatedAt: 0,
        );
    ref.listen<AsyncValue<AppearanceState>>(
      appearanceControllerProvider,
      (_, next) {
        final updatedProfile = next.valueOrNull?.deviceProfile;
        if (updatedProfile != null) {
          state = NavigationState.fromProfile(
            updatedProfile,
            selectedModule: state.selectedModule,
          );
        }
      },
    );
    return NavigationState.fromProfile(profile);
  }

  void select(AppModuleKey module) {
    if (state.selectedModule == module) {
      return;
    }
    state = state.copyWith(selectedModule: module);
    _trigger(HapticEvent.navigation);
  }

  Future<void> reorder(Iterable<AppModuleKey> requestedOrder) async {
    final catalogSet = state.catalog.toSet();
    final seen = <AppModuleKey>{};
    final normalized = <AppModuleKey>[];
    for (final module in requestedOrder) {
      if (catalogSet.contains(module) && seen.add(module)) {
        normalized.add(module);
      }
    }
    for (final module in state.order) {
      if (seen.add(module)) {
        normalized.add(module);
      }
    }
    if (_orderedEquals(normalized, state.order)) {
      return;
    }
    state = state.copyWith(order: normalized);
    _trigger(HapticEvent.reorder);
    await _persist();
  }

  Future<void> setHidden(AppModuleKey module, bool hidden) async {
    if (!state.catalog.contains(module) ||
        module == AppModuleKey.today ||
        (hidden && module == state.startModule)) {
      return;
    }
    final nextHidden = state.hiddenModules.toSet();
    final changed = hidden ? nextHidden.add(module) : nextHidden.remove(module);
    if (!changed) {
      return;
    }
    final selected = hidden && state.selectedModule == module
        ? state.startModule
        : state.selectedModule;
    state = state.copyWith(
      hiddenModules: nextHidden,
      selectedModule: selected,
    );
    _trigger(HapticEvent.selection);
    await _persist();
  }

  Future<void> setStartModule(AppModuleKey module) async {
    final nextStart =
        state.visibleModules.contains(module) ? module : AppModuleKey.today;
    if (nextStart == state.startModule) {
      return;
    }
    state = state.copyWith(startModule: nextStart);
    _trigger(HapticEvent.selection);
    await _persist();
  }

  Future<void> _persist() async {
    if (ref.read(appearanceControllerProvider).valueOrNull == null) {
      await ref.read(appearanceControllerProvider.future);
    }
    await ref.read(appearanceControllerProvider.notifier).setNavigation(
          order: state.order,
          hidden: state.hiddenModules,
          startModule: state.startModule,
        );
  }

  void _trigger(HapticEvent event) {
    unawaited(
      AppHaptics(
        platform: state.platform,
        mode: state.hapticsMode,
      ).trigger(event),
    );
  }
}

bool _orderedEquals(List<AppModuleKey> left, List<AppModuleKey> right) {
  if (left.length != right.length) {
    return false;
  }
  for (var index = 0; index < left.length; index++) {
    if (left[index] != right[index]) {
      return false;
    }
  }
  return true;
}
