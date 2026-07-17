import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_note/core/accessibility/transparency_preference.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Windows source reads disabled transparency effects as reduce true',
      () async {
    const channel = MethodChannel(
      PlatformTransparencyPreferenceSource.channelName,
    );
    final calls = <MethodCall>[];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      calls.add(call);
      return true;
    });
    addTearDown(
      () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null),
    );

    final preference = await PlatformTransparencyPreferenceSource(
      platform: TargetPlatform.windows,
      channel: channel,
    ).read();

    expect(calls.single.method, 'getReduceTransparency');
    expect(preference.isSupported, isTrue);
    expect(preference.reduceTransparency, isTrue);
  });

  test('Windows source reads enabled transparency effects as reduce false',
      () async {
    const channel = MethodChannel(
      PlatformTransparencyPreferenceSource.channelName,
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (_) async => false);
    addTearDown(
      () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null),
    );

    final preference = await PlatformTransparencyPreferenceSource(
      platform: TargetPlatform.windows,
      channel: channel,
    ).read();

    expect(preference.isSupported, isTrue);
    expect(preference.reduceTransparency, isFalse);
  });

  test('Android reports the system transparency preference as unsupported',
      () async {
    const channel = MethodChannel(
      PlatformTransparencyPreferenceSource.channelName,
    );
    var channelCalled = false;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (_) async {
      channelCalled = true;
      return true;
    });
    addTearDown(
      () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null),
    );

    final preference = await PlatformTransparencyPreferenceSource(
      platform: TargetPlatform.android,
      channel: channel,
    ).read();

    expect(channelCalled, isFalse);
    expect(preference.isSupported, isFalse);
    expect(preference.reduceTransparency, isFalse);
  });

  test('preference provider accepts an injected source', () async {
    const expected = TransparencyPreference.supported(
      reduceTransparency: true,
    );
    final container = ProviderContainer(
      overrides: [
        transparencyPreferenceSourceProvider.overrideWithValue(
          const _FakeTransparencyPreferenceSource(expected),
        ),
      ],
    );
    addTearDown(container.dispose);

    expect(
      await container.read(transparencyPreferenceProvider.future),
      expected,
    );
  });
}

final class _FakeTransparencyPreferenceSource
    implements TransparencyPreferenceSource {
  const _FakeTransparencyPreferenceSource(this.value);

  final TransparencyPreference value;

  @override
  Future<TransparencyPreference> read() async => value;
}
