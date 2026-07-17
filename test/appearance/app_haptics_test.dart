import 'package:flutter_test/flutter_test.dart';
import 'package:simple_note/core/feedback/app_haptics.dart';
import 'package:simple_note/features/appearance/domain/appearance_presets.dart';

void main() {
  test('default off mode emits no feedback', () async {
    final driver = _RecordingHapticDriver();
    final haptics = AppHaptics(platform: 'android', driver: driver);

    for (final event in HapticEvent.values) {
      await haptics.trigger(event);
    }

    expect(driver.calls, isEmpty);
  });

  test('never emits haptics outside Android', () async {
    final driver = _RecordingHapticDriver();
    final haptics = AppHaptics(
      mode: HapticsMode.rich,
      platform: 'windows',
      driver: driver,
    );

    for (final event in HapticEvent.values) {
      await haptics.trigger(event);
    }

    expect(driver.calls, isEmpty);
  });

  test('key actions only emit completion and deletion feedback', () async {
    final driver = _RecordingHapticDriver();
    final haptics = AppHaptics(
      mode: HapticsMode.keyActions,
      platform: 'android',
      driver: driver,
    );

    for (final event in HapticEvent.values) {
      await haptics.trigger(event);
    }

    expect(driver.calls, ['light', 'medium']);
  });

  test('rich mode maps every event to the approved driver operation', () async {
    final driver = _RecordingHapticDriver();
    final haptics = AppHaptics(
      mode: HapticsMode.rich,
      platform: 'android',
      driver: driver,
    );

    for (final event in HapticEvent.values) {
      await haptics.trigger(event);
    }

    expect(
      driver.calls,
      ['light', 'medium', 'light', 'selection', 'medium'],
    );
  });
}

final class _RecordingHapticDriver implements HapticDriver {
  final List<String> calls = [];

  @override
  Future<void> lightImpact() async => calls.add('light');

  @override
  Future<void> mediumImpact() async => calls.add('medium');

  @override
  Future<void> selectionClick() async => calls.add('selection');
}
