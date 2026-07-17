import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_note/app.dart';
import 'package:simple_note/database/app_database.dart';
import 'package:simple_note/features/settings/domain/theme_scheme.dart';

void main() {
  testWidgets('SimpleNote starts on the notes page', (tester) async {
    await _pumpApp(tester);

    expect(find.text('笔记'), findsWidgets);
    expect(find.text('还没有笔记'), findsOneWidget);
    expect(find.text('新建笔记'), findsWidgets);
  });

  testWidgets('bottom navigation opens todos and settings on compact screens',
      (tester) async {
    await _pumpApp(tester, surfaceSize: const Size(390, 844));

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);

    await tester.tap(find.text('待办'));
    await tester.pumpAndSettle();

    expect(find.text('还没有待办'), findsOneWidget);
    expect(find.text('新建待办'), findsWidgets);

    await tester.tap(find.text('设置'));
    await tester.pumpAndSettle();

    expect(find.text('主题'), findsOneWidget);
    expect(find.text('预设主题'), findsOneWidget);
  });

  testWidgets('wide screens use side navigation', (tester) async {
    await _pumpApp(tester, surfaceSize: const Size(1024, 768));

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
    expect(find.text('还没有笔记'), findsOneWidget);
  });

  testWidgets('notes page creates edits tags and previews markdown',
      (tester) async {
    await _pumpApp(tester, surfaceSize: const Size(1024, 768));

    await tester.tap(find.text('新建笔记').first);
    await tester.pump(const Duration(milliseconds: 100));

    await tester.enterText(find.byKey(const Key('note-title-field')), 'Demo');
    await tester.pump(const Duration(milliseconds: 100));
    await tester.enterText(
      find.byKey(const Key('note-content-field')),
      '# Heading\n\n- item\n- [ ] task\n\n**bold** [link](https://example.com) `code`\n\n```dart\nvoid main() {}\n```\n\n> quote',
    );
    await tester.pump(const Duration(milliseconds: 100));

    await tester.enterText(find.byKey(const Key('new-tag-field')), 'work');
    await tester.tap(find.text('添加标签'));
    await tester.pump(const Duration(milliseconds: 100));

    await tester.tap(find.text('work').last);
    await tester.pump(const Duration(milliseconds: 100));
    await tester.tap(find.text('预览'));
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byKey(const Key('markdown-preview')), findsOneWidget);
    expect(find.text('Heading'), findsOneWidget);
    expect(find.text('item'), findsOneWidget);
    expect(_richTextContaining('bold'), findsWidgets);
    expect(_richTextContaining('link'), findsWidgets);
    expect(_richTextContaining('code'), findsWidgets);
    expect(find.text('quote'), findsOneWidget);
  });

  testWidgets('compact notes editor can go back and confirms delete',
      (tester) async {
    await _pumpApp(tester, surfaceSize: const Size(390, 844));

    await tester.tap(find.text('新建笔记').first);
    await tester.pump(const Duration(milliseconds: 300));

    await tester.enterText(find.byKey(const Key('note-title-field')), 'Temp');
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byKey(const Key('note-back-button')), findsOneWidget);
    await tester.tap(find.byKey(const Key('note-back-button')));
    await tester.pumpAndSettle();

    expect(find.text('Temp'), findsOneWidget);

    await tester.tap(find.text('Temp'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('删除笔记'));
    await tester.pumpAndSettle();

    expect(find.text('删除这篇笔记？'), findsOneWidget);
    await tester.tap(find.text('取消'));
    await tester.pumpAndSettle();
    expect(find.text('Temp'), findsOneWidget);

    await tester.tap(find.byTooltip('删除笔记'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('删除'));
    await tester.pumpAndSettle();

    expect(find.text('笔记已删除'), findsOneWidget);
  });

  testWidgets('todos page creates edits completes filters and prioritizes',
      (tester) async {
    await _pumpApp(tester, surfaceSize: const Size(1024, 768));

    Navigator.of(tester.element(find.byType(Scaffold).first))
        .pushReplacementNamed('/todos');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('还没有待办'), findsOneWidget);
    await tester.tap(find.text('新建待办').first);
    await tester.pump(const Duration(milliseconds: 300));

    await tester.enterText(find.byKey(const Key('todo-title-field')), 'Plan');
    await tester.pump(const Duration(milliseconds: 100));
    await tester.enterText(
      find.byKey(const Key('todo-description-field')),
      'Write tasks',
    );
    await tester.pump(const Duration(milliseconds: 100));
    await tester.tap(find.text('高'));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.tap(find.byType(SwitchListTile));
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Plan'), findsWidgets);
    expect(find.textContaining('优先级：高'), findsOneWidget);

    await tester.tap(find.text('进行中'));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('当前筛选下没有待办。'), findsOneWidget);

    await tester.tap(find.text('已完成'));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Plan'), findsWidgets);
  });

  testWidgets('compact todos editor can go back and confirms delete',
      (tester) async {
    await _pumpApp(tester, surfaceSize: const Size(390, 844));

    await tester.tap(find.text('待办'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('新建待办').first);
    await tester.pump(const Duration(milliseconds: 300));

    await tester.enterText(find.byKey(const Key('todo-title-field')), 'Errand');
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byKey(const Key('todo-back-button')), findsOneWidget);
    await tester.tap(find.byKey(const Key('todo-back-button')));
    await tester.pumpAndSettle();

    expect(find.text('Errand'), findsOneWidget);

    await tester.tap(find.byTooltip('编辑待办'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('删除待办'));
    await tester.pumpAndSettle();

    expect(find.text('删除这个待办？'), findsOneWidget);
    await tester.tap(find.text('取消'));
    await tester.pumpAndSettle();
    expect(find.text('Errand'), findsOneWidget);

    await tester.tap(find.byTooltip('删除待办'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('删除'));
    await tester.pumpAndSettle();

    expect(find.text('待办已删除'), findsOneWidget);
  });

  testWidgets('settings page applies presets and saves a custom theme',
      (tester) async {
    await _pumpApp(tester, surfaceSize: const Size(1024, 768));

    Navigator.of(tester.element(find.byType(Scaffold).first))
        .pushReplacementNamed('/settings');
    await tester.pumpAndSettle();

    expect(find.text('预设主题'), findsOneWidget);
    expect(find.text(AppThemeScheme.nightBlack.name), findsWidgets);
    expect(find.byKey(const Key('derived-colors-note')), findsOneWidget);

    await tester.tap(find.text(AppThemeScheme.nightBlack.name).first);
    await tester.pumpAndSettle();

    expect(find.text(AppThemeScheme.nightBlack.name), findsWidgets);

    await tester.tap(
      find.byKey(
        Key('primary-swatch-${AppThemeScheme.eyeComfortGreen.primaryColor.toARGB32()}'),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('custom-theme-name-field')),
      'Interview Demo',
    );
    await tester.tap(find.byKey(const Key('save-custom-theme-button')));
    await tester.pumpAndSettle();

    expect(find.text('Interview Demo'), findsWidgets);

    await tester.dragUntilVisible(
      find.byKey(const Key('sync-start-server-button')),
      find.byKey(const Key('settings-list')),
      const Offset(0, -320),
    );
    await tester.pumpAndSettle();
    expect(find.text('局域网同步'), findsOneWidget);
    expect(find.byKey(const Key('sync-start-server-button')), findsOneWidget);
    expect(find.byKey(const Key('sync-peer-address-field')), findsOneWidget);
    expect(find.byKey(const Key('sync-now-button')), findsOneWidget);
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
