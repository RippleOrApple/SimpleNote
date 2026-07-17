import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:simple_note/features/appearance/domain/appearance_presets.dart';
import 'package:simple_note/features/appearance/infrastructure/palette_extractor.dart';

void main() {
  test('extracts five separated candidates from a deterministic image', () {
    final image = img.Image(width: 50, height: 10);
    const colors = [0x596790, 0x4D8BB8, 0x5E9D83, 0xB66B86, 0x8A6FB0];
    for (var x = 0; x < image.width; x++) {
      final rgb = colors[x ~/ 10];
      for (var y = 0; y < image.height; y++) {
        image.setPixelRgb(
          x,
          y,
          rgb >> 16,
          (rgb >> 8) & 0xff,
          rgb & 0xff,
        );
      }
    }

    final result = const PaletteExtractor().extract(
      Uint8List.fromList(img.encodePng(image)),
    );

    expect(result, hasLength(5));
    expect(result.map((color) => color.value).toSet(), containsAll(colors));
  });

  test('rejects undecodable input', () {
    expect(
      () => const PaletteExtractor().extract(Uint8List.fromList([1, 2, 3])),
      throwsFormatException,
    );
  });

  test('filters transparent and extreme pixels then fills from presets', () {
    final image = img.Image(width: 3, height: 1, numChannels: 4);
    image.setPixelRgba(0, 0, 0, 0, 0, 255);
    image.setPixelRgba(1, 0, 255, 255, 255, 255);
    image.setPixelRgba(2, 0, 255, 0, 0, 127);

    final result = const PaletteExtractor().extract(
      Uint8List.fromList(img.encodePng(image)),
    );

    expect(
      result,
      AppearancePresets.accentColors.take(5).toList(),
    );
  });

  test('orders equally populated candidates by integer RGB value', () {
    final image = img.Image(width: 2, height: 1);
    image.setPixelRgb(0, 0, 0x80, 0x60, 0x40);
    image.setPixelRgb(1, 0, 0x40, 0x60, 0x80);

    final result = const PaletteExtractor().extract(
      Uint8List.fromList(img.encodePng(image)),
    );

    expect(result.first.value, 0x406080);
    expect(result[1].value, 0x806040);
  });
}
