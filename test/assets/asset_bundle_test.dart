import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('approved fonts and wallpaper presets are bundled', () async {
    const paths = [
      'assets/fonts/ResourceHanRoundedCN-Regular.ttf',
      'assets/fonts/LXGWWenKai-Regular.ttf',
      'assets/backgrounds/presets/mist-morning.png',
      'assets/backgrounds/presets/berry-dusk.png',
      'assets/backgrounds/presets/lavender-moon.png',
      'assets/backgrounds/presets/eucalyptus-valley.png',
    ];

    for (final path in paths) {
      final data = await rootBundle.load(path);
      expect(data.lengthInBytes, greaterThan(1024), reason: path);
    }
  });
}
