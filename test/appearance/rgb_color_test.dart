import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_note/features/appearance/domain/rgb_color.dart';

void main() {
  test('parses hex and comma RGB into the same normalized value', () {
    expect(RgbColor.parse('#5E9D83').value, 0x5E9D83);
    expect(RgbColor.parse('5e9d83').value, 0x5E9D83);
    expect(RgbColor.parse('94,157,131').value, 0x5E9D83);
    expect(() => RgbColor.parse('300,0,0'), throwsFormatException);
  });

  test('rejects malformed RGB and HEX input', () {
    expect(() => RgbColor.parse('1,2'), throwsFormatException);
    expect(() => RgbColor.parse('1,two,3'), throwsFormatException);
    expect(() => RgbColor.parse('#12345'), throwsFormatException);
    expect(() => RgbColor.parse('##5E9D83'), throwsFormatException);
  });

  test('normalizes output and compares by 24-bit value', () {
    expect(const RgbColor(0x00000A).toHex(), '#00000A');
    expect(const RgbColor(0x596790), RgbColor.parse('#596790'));
    expect(
      const RgbColor(0x596790).hashCode,
      RgbColor.parse('#596790').hashCode,
    );
  });

  test('converts to and from opaque Flutter colors', () {
    expect(
      const RgbColor(0x5E9D83).toColor(),
      const Color(0xFF5E9D83),
    );
    expect(
      RgbColor.fromColor(const Color(0x405E9D83)),
      const RgbColor(0x5E9D83),
    );
  });
}
