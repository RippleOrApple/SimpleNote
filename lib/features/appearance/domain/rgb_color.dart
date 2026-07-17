import 'package:flutter/material.dart';

final class RgbColor {
  const RgbColor(this.value) : assert(value >= 0 && value <= 0xFFFFFF);

  final int value;

  factory RgbColor.parse(String input) {
    final value = input.trim();
    if (value.contains(',')) {
      final segments = value.split(',').map((part) => part.trim()).toList();
      final decimal = RegExp(r'^[0-9]+$');
      if (segments.length != 3 ||
          segments.any((segment) => !decimal.hasMatch(segment))) {
        throw const FormatException(
          'RGB must contain three values from 0 to 255.',
        );
      }
      final parts = segments.map(int.parse).toList();
      if (parts.length != 3 || parts.any((part) => part < 0 || part > 255)) {
        throw const FormatException(
          'RGB must contain three values from 0 to 255.',
        );
      }
      return RgbColor((parts[0] << 16) | (parts[1] << 8) | parts[2]);
    }
    final match = RegExp(r'^#?([0-9a-fA-F]{6})$').firstMatch(value);
    if (match == null) {
      throw const FormatException(
        'HEX must contain exactly six hexadecimal digits.',
      );
    }
    return RgbColor(int.parse(match.group(1)!, radix: 16));
  }

  factory RgbColor.fromColor(Color color) {
    return RgbColor(color.toARGB32() & 0xFFFFFF);
  }

  Color toColor() => Color(0xFF000000 | value);

  String toHex() => '#${value.toRadixString(16).padLeft(6, '0').toUpperCase()}';

  @override
  bool operator ==(Object other) => other is RgbColor && other.value == value;

  @override
  int get hashCode => value.hashCode;
}
