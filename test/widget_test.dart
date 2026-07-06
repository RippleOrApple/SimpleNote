import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_note/app.dart';
import 'package:simple_note/database/app_database.dart';

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

  testWidgets('notes page creates edits tags and previews markdown',
      (tester) async {
    await _pumpApp(tester, surfaceSize: const Size(1024, 768));

    await tester.tap(find.text('New note').first);
    await tester.pump(const Duration(milliseconds: 100));

    await tester.enterText(find.byKey(const Key('note-title-field')), 'Demo');
    await tester.pump(const Duration(milliseconds: 100));
    await tester.enterText(
      find.byKey(const Key('note-content-field')),
      '# Heading\n\n- item\n- [ ] task\n\n**bold** [link](https://example.com) `code`\n\n```dart\nvoid main() {}\n```\n\n> quote',
    );
    await tester.pump(const Duration(milliseconds: 100));

    await tester.enterText(find.byKey(const Key('new-tag-field')), 'work');
    await tester.tap(find.text('Add tag'));
    await tester.pump(const Duration(milliseconds: 100));

    await tester.tap(find.text('work').last);
    await tester.pump(const Duration(milliseconds: 100));
    await tester.tap(find.text('Preview'));
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byKey(const Key('markdown-preview')), findsOneWidget);
    expect(find.text('Heading'), findsOneWidget);
    expect(find.text('item'), findsOneWidget);
    expect(_richTextContaining('bold'), findsWidgets);
    expect(_richTextContaining('link'), findsWidgets);
    expect(_richTextContaining('code'), findsWidgets);
    expect(find.text('quote'), findsOneWidget);
  });
}

Finder _richTextContaining(String text) {
  return find.byWidgetPredicate(
    (widget) => widget is RichText && widget.text.toPlainText().contains(text),
  );
}

Future<void> _pumpApp(
  WidgetTester tester, {
  Size? surfaceSize,
}) async {
  if (surfaceSize != null) {
    await tester.binding.setSurfaceSize(surfaceSize);
    addTearDown(() => tester.binding.setSurfaceSize(null));
  }

  final database = AppDatabase(NativeDatabase.memory());
  addTearDown(database.close);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [appDatabaseProvider.overrideWithValue(database)],
      child: const SimpleNoteApp(),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 100));
}
