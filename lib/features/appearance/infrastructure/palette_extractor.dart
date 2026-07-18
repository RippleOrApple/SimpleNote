import 'dart:math' as math;
import 'dart:typed_data';

import 'package:image/image.dart' as img;

import '../domain/appearance_presets.dart';
import '../domain/rgb_color.dart';

final class PaletteExtractor {
  const PaletteExtractor();

  List<RgbColor> extract(Uint8List bytes) {
    final img.Image decoded;
    try {
      final image = img.decodeImage(bytes);
      if (image == null) {
        throw const FormatException('Image data could not be decoded.');
      }
      decoded = image;
    } on FormatException {
      rethrow;
    } catch (error) {
      throw FormatException('Image data could not be decoded: $error');
    }

    final resized = _resize(decoded).convert(format: img.Format.uint8);
    final buckets = <int, _Bucket>{};
    for (final pixel in resized) {
      final alpha = pixel.a.toInt();
      final red = pixel.r.toInt();
      final green = pixel.g.toInt();
      final blue = pixel.b.toInt();
      final luminance = _relativeLuminance(red, green, blue);
      if (alpha < 128 || luminance > 0.96 || luminance < 0.04) {
        continue;
      }
      final key = ((red ~/ 32) << 6) | ((green ~/ 32) << 3) | (blue ~/ 32);
      final rgb = (red << 16) | (green << 8) | blue;
      (buckets[key] ??= _Bucket()).add(rgb);
    }

    final sortedBuckets = buckets.values.toList()
      ..sort((left, right) {
        final populationOrder = right.population.compareTo(left.population);
        if (populationOrder != 0) {
          return populationOrder;
        }
        return left.representative.compareTo(right.representative);
      });

    final accepted = <RgbColor>[];
    for (final bucket in sortedBuckets) {
      final candidate = RgbColor(bucket.representative);
      if (accepted.every(
        (existing) => _distance(candidate, existing) >= 48,
      )) {
        accepted.add(candidate);
        if (accepted.length == 5) {
          break;
        }
      }
    }

    if (accepted.length < 5) {
      for (final preset in AppearancePresets.accentColors) {
        if (!accepted.contains(preset)) {
          accepted.add(preset);
          if (accepted.length == 5) {
            break;
          }
        }
      }
    }
    return List.unmodifiable(accepted);
  }
}

img.Image _resize(img.Image source) {
  const targetLongestSide = 96;
  if (source.width >= source.height) {
    final height = math.max(
      1,
      (source.height * targetLongestSide / source.width).round(),
    );
    return img.copyResize(
      source,
      width: targetLongestSide,
      height: height,
      interpolation: img.Interpolation.nearest,
    );
  }
  final width = math.max(
    1,
    (source.width * targetLongestSide / source.height).round(),
  );
  return img.copyResize(
    source,
    width: width,
    height: targetLongestSide,
    interpolation: img.Interpolation.nearest,
  );
}

double _relativeLuminance(int red, int green, int blue) {
  double linearize(int channel) {
    final value = channel / 255;
    return value <= 0.04045
        ? value / 12.92
        : math.pow((value + 0.055) / 1.055, 2.4).toDouble();
  }

  return 0.2126 * linearize(red) +
      0.7152 * linearize(green) +
      0.0722 * linearize(blue);
}

double _distance(RgbColor left, RgbColor right) {
  final red = (left.value >> 16) - (right.value >> 16);
  final green = ((left.value >> 8) & 0xff) - ((right.value >> 8) & 0xff);
  final blue = (left.value & 0xff) - (right.value & 0xff);
  return math.sqrt(red * red + green * green + blue * blue);
}

final class _Bucket {
  int population = 0;
  int representative = 0;
  int _representativePopulation = 0;
  final Map<int, int> _colorPopulations = {};

  void add(int rgb) {
    population++;
    final colorPopulation = (_colorPopulations[rgb] ?? 0) + 1;
    _colorPopulations[rgb] = colorPopulation;
    if (colorPopulation > _representativePopulation ||
        (colorPopulation == _representativePopulation &&
            rgb < representative)) {
      representative = rgb;
      _representativePopulation = colorPopulation;
    }
  }
}
