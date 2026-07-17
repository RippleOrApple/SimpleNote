import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/typography_preferences.dart';
import '../../../core/utils/time.dart';
import '../../sync/data/sync_repository.dart';
import '../data/appearance_repository.dart';
import '../domain/appearance_presets.dart';
import '../domain/appearance_settings.dart';
import '../domain/custom_color.dart';
import '../domain/device_appearance_profile.dart';
import '../domain/rgb_color.dart';

final appearanceControllerProvider =
    AsyncNotifierProvider<AppearanceController, AppearanceState>(
  AppearanceController.new,
);

final class AppearanceState {
  const AppearanceState({
    required this.portable,
    required this.deviceProfile,
    required this.customColors,
  });

  final AppearanceSettings portable;
  final DeviceAppearanceProfile deviceProfile;
  final List<CustomColor> customColors;

  AppearanceState copyWith({
    AppearanceSettings? portable,
    DeviceAppearanceProfile? deviceProfile,
    List<CustomColor>? customColors,
  }) {
    return AppearanceState(
      portable: portable ?? this.portable,
      deviceProfile: deviceProfile ?? this.deviceProfile,
      customColors: customColors ?? this.customColors,
    );
  }
}

final class AppearanceController extends AsyncNotifier<AppearanceState> {
  late AppearanceRepository _repository;
  late String _platform;
  Future<void> _mutationTail = Future<void>.value();
  int _buildEpoch = 0;
  int _mutationRevision = 0;

  @override
  Future<AppearanceState> build() async {
    _buildEpoch++;
    _repository = ref.watch(appearanceRepositoryProvider);
    _platform = ref.watch(deviceInfoProvider).platform;
    while (true) {
      final revisionBeforeRead = _mutationRevision;
      final portable = await _repository.loadPortable();
      final deviceProfile = await _repository.loadDeviceProfile(_platform);
      final customColors = await _repository.listCustomColors();
      final mutationsBeforeReturn = _mutationTail;
      await mutationsBeforeReturn;
      if (identical(mutationsBeforeReturn, _mutationTail) &&
          revisionBeforeRead == _mutationRevision) {
        return AppearanceState(
          portable: portable,
          deviceProfile: deviceProfile,
          customColors: customColors,
        );
      }
    }
  }

  Future<void> setAccent(RgbColor value) {
    return _updatePortable((portable) => portable.copyWith(accent: value));
  }

  Future<void> setBackground(BackgroundSelection value) {
    return _updatePortable((portable) {
      final pureColor = switch (value.kind) {
        BackgroundKind.presetColor || BackgroundKind.customColor => value.color,
        BackgroundKind.bundledImage || BackgroundKind.syncedImage => null,
      };
      return portable.copyWith(
        background: value,
        lastPureBackground: pureColor ?? portable.lastPureBackground,
      );
    });
  }

  Future<void> setLocalBackgroundImage(String? backgroundImageId) {
    return _updateDevice(
      (profile) => profile.copyWith(
        localBackgroundImageId: backgroundImageId,
        clearLocalBackgroundImageId: backgroundImageId == null,
      ),
    );
  }

  Future<void> setBackgroundPresentation({
    required double focusX,
    required double focusY,
    required double zoom,
    required double blur,
    required double overlay,
  }) {
    return _updateDevice(
      (profile) => profile.copyWith(
        backgroundFocusX: focusX,
        backgroundFocusY: focusY,
        backgroundZoom: zoom,
        backgroundBlur: blur,
        backgroundOverlay: overlay,
      ),
    );
  }

  Future<void> setNotePaper(RgbColor value) {
    return _updatePortable((portable) => portable.copyWith(notePaper: value));
  }

  Future<void> setTintStrength(double value) {
    return _updatePortable(
      (portable) => portable.copyWith(tintStrength: value),
    );
  }

  Future<void> setGlassOpacity(double value) {
    return _updatePortable(
      (portable) => portable.copyWith(glassOpacity: value),
    );
  }

  Future<void> setDarkOverlay(double value) {
    return _updatePortable(
      (portable) => portable.copyWith(darkOverlay: value),
    );
  }

  Future<void> setTypography(TypographyPreferences value) {
    return _updatePortable(
      (portable) => portable.copyWith(typography: value),
    );
  }

  Future<void> setMotion(MotionLevel value) {
    return _updatePortable((portable) => portable.copyWith(motion: value));
  }

  Future<void> setDensity(LayoutDensity value) {
    return _updateDevice((profile) => profile.copyWith(density: value));
  }

  Future<void> setHaptics(HapticsMode value) {
    return _updateDevice((profile) => profile.copyWith(hapticsMode: value));
  }

  Future<void> _updatePortable(
    AppearanceSettings Function(AppearanceSettings current) update,
  ) {
    return _enqueueMutation(() async {
      final epoch = _buildEpoch;
      final current = _requireState();
      final portable = update(current.portable);
      await _repository.savePortable(portable);
      _mutationRevision++;
      if (epoch == _buildEpoch) {
        state = AsyncData(current.copyWith(portable: portable));
      } else {
        ref.invalidateSelf();
      }
    });
  }

  Future<void> _updateDevice(
    DeviceAppearanceProfile Function(DeviceAppearanceProfile current) update,
  ) {
    return _enqueueMutation(() async {
      final epoch = _buildEpoch;
      final current = _requireState();
      final profile = update(current.deviceProfile).copyWith(
        updatedAt: Clock.nowMillis(),
      );
      await _repository.saveDeviceProfile(profile);
      _mutationRevision++;
      if (epoch == _buildEpoch) {
        state = AsyncData(current.copyWith(deviceProfile: profile));
      } else {
        ref.invalidateSelf();
      }
    });
  }

  Future<void> _enqueueMutation(Future<void> Function() operation) {
    final result = _mutationTail.then((_) => operation());
    _mutationTail = result.then<void>(
      (_) {},
      onError: (Object _, StackTrace __) {},
    );
    return result;
  }

  AppearanceState _requireState() {
    final current = state.valueOrNull;
    if (current == null) {
      throw StateError('Appearance settings are not loaded.');
    }
    return current;
  }
}
