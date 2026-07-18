import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('AppBackground does not perform filesystem adaptation', () {
    final source = File(
      'lib/shared/widgets/app_background.dart',
    ).readAsStringSync();

    expect(source, isNot(contains("import 'dart:io'")));
    expect(source, isNot(contains('File(')));
    expect(source, isNot(contains('Image.file')));
  });

  test('Windows runner adapts the real transparency-effects registry value',
      () {
    final source = File('windows/runner/flutter_window.cpp').readAsStringSync();

    expect(source, contains('getReduceTransparency'));
    expect(source, contains('RegGetValueW'));
    expect(
      source,
      contains(
        r'Software\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize',
      ),
    );
    expect(source, contains('EnableTransparency'));
  });
}
