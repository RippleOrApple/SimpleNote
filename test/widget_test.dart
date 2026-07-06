import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_note/app.dart';

void main() {
  testWidgets('SimpleNote starts on the notes page', (tester) async {
    await _pumpApp(tester);

    expect(find.text('Notes'), findsWidgets);
    expect(find.text('No notes yet'), findsOneWidget);
    expect(find.text('New note'), findsWidgets);
  });

  testWidgets('bottom navigation opens todos and settings on compact screens',
      (tester) async {
    await _pumpApp(tester, surfaceSize: const Size(390, 844));

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);

    await tester.tap(find.text('Todos'));
    await tester.pumpAndSettle();

    expect(find.text('No todos yet'), findsOneWidget);
    expect(find.text('New todo'), findsWidgets);

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    expect(find.text('Theme'), findsOneWidget);
    expect(find.text('LAN sync'), findsOneWidget);
  });

  testWidgets('wide screens use side navigation', (tester) async {
    await _pumpApp(tester, surfaceSize: const Size(1024, 768));

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
    expect(find.text('No notes yet'), findsOneWidget);
  });
}

Future<void> _pumpApp(
  WidgetTester tester, {
  Size? surfaceSize,
}) async {
  if (surfaceSize != null) {
    await tester.binding.setSurfaceSize(surfaceSize);
    addTearDown(() => tester.binding.setSurfaceSize(null));
  }

  await tester.pumpWidget(const ProviderScope(child: SimpleNoteApp()));
  await tester.pumpAndSettle();
}
