import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_note/features/appearance/domain/custom_color.dart';
import 'package:simple_note/features/appearance/domain/rgb_color.dart';
import 'package:simple_note/features/appearance/presentation/color_settings_section.dart';

void main() {
  testWidgets('reorders a color upward using adjusted item indices',
      (tester) async {
    expect(await _invokeReorder(tester, 2, 0), ['c', 'a', 'b']);
  });

  testWidgets('reorders a color downward using adjusted item indices',
      (tester) async {
    expect(await _invokeReorder(tester, 0, 1), ['b', 'a', 'c']);
  });

  testWidgets('reorders a color to the end using adjusted item indices',
      (tester) async {
    expect(await _invokeReorder(tester, 0, 2), ['b', 'c', 'a']);
  });

  testWidgets('clamps a defensive insertion index to the list boundary',
      (tester) async {
    expect(await _invokeReorder(tester, 0, 99), ['b', 'c', 'a']);
  });
}

Future<List<String>> _invokeReorder(
  WidgetTester tester,
  int oldIndex,
  int newIndex,
) async {
  List<String>? reordered;
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: ColorSettingsSection(
            accent: const RgbColor(0x111111),
            background: const RgbColor(0x222222),
            notePaper: const RgbColor(0x333333),
            customColors: [
              _color('a', 0),
              _color('b', 1),
              _color('c', 2),
            ],
            onApplyColor: (_, __) async {},
            onSaveCustomColor: (_, __) async {},
            onRenameCustomColor: (_, __) async {},
            onReorderCustomColors: (ids) async => reordered = ids,
            onDeleteCustomColor: (_) async {},
            onExtractColors: () async => const [],
          ),
        ),
      ),
    ),
  );

  final list = tester.widget<ReorderableListView>(
    find.byType(ReorderableListView),
  );
  list.onReorderItem!(oldIndex, newIndex);
  await tester.pump();
  return reordered!;
}

CustomColor _color(String id, int order) {
  return CustomColor(
    id: id,
    name: id.toUpperCase(),
    color: RgbColor(order + 1),
    sortOrder: order,
    createdAt: 1,
    updatedAt: 1,
    deviceId: 'device',
    version: 1,
  );
}
