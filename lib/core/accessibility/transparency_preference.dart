import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transparencyPreferenceSourceProvider =
    Provider<TransparencyPreferenceSource>((ref) {
  return PlatformTransparencyPreferenceSource();
});

final transparencyPreferenceProvider =
    FutureProvider<TransparencyPreference>((ref) {
  return ref.watch(transparencyPreferenceSourceProvider).read();
});

@immutable
final class TransparencyPreference {
  const TransparencyPreference.supported({
    required this.reduceTransparency,
  }) : isSupported = true;

  const TransparencyPreference.unsupported()
      : isSupported = false,
        reduceTransparency = false;

  final bool isSupported;
  final bool reduceTransparency;

  @override
  bool operator ==(Object other) {
    return other is TransparencyPreference &&
        other.isSupported == isSupported &&
        other.reduceTransparency == reduceTransparency;
  }

  @override
  int get hashCode => Object.hash(isSupported, reduceTransparency);
}

abstract interface class TransparencyPreferenceSource {
  Future<TransparencyPreference> read();
}

final class PlatformTransparencyPreferenceSource
    implements TransparencyPreferenceSource {
  PlatformTransparencyPreferenceSource({
    TargetPlatform? platform,
    MethodChannel channel = const MethodChannel(channelName),
  })  : _platform = platform ?? defaultTargetPlatform,
        _channel = channel;

  static const channelName = 'simple_note/accessibility';

  final TargetPlatform _platform;
  final MethodChannel _channel;

  @override
  Future<TransparencyPreference> read() async {
    if (_platform != TargetPlatform.windows) {
      return const TransparencyPreference.unsupported();
    }
    try {
      final reduceTransparency = await _channel.invokeMethod<bool>(
        'getReduceTransparency',
      );
      if (reduceTransparency == null) {
        return const TransparencyPreference.unsupported();
      }
      return TransparencyPreference.supported(
        reduceTransparency: reduceTransparency,
      );
    } on MissingPluginException {
      return const TransparencyPreference.unsupported();
    } on PlatformException {
      return const TransparencyPreference.unsupported();
    }
  }
}
