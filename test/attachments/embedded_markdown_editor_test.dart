import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_note/features/attachments/domain/content_attachment.dart';
import 'package:simple_note/shared/models/markdown_edit.dart';
import 'package:simple_note/shared/widgets/embedded_markdown_editor.dart';

void main() {
  test('controller wraps selection and preserves selected content range', () {
    final controller = MarkdownEditingController()
      ..text = 'alpha beta'
      ..selection = const TextSelection(baseOffset: 6, extentOffset: 10);
    addTearDown(controller.dispose);

    controller.wrapSelection('**', '**');

    expect(controller.text, 'alpha **beta**');
    expect(controller.selection.baseOffset, 8);
    expect(controller.selection.extentOffset, 12);
  });

  test('controller inserts at a reversed selection and collapses the caret',
      () {
    final controller = MarkdownEditingController(text: 'alpha beta')
      ..selection = const TextSelection(baseOffset: 10, extentOffset: 6);
    addTearDown(controller.dispose);

    controller.insertAtSelection('gamma');

    expect(controller.text, 'alpha gamma');
    expect(controller.selection, const TextSelection.collapsed(offset: 11));
  });

  testWidgets('toolbar applies Markdown syntax and emits the updated value',
      (tester) async {
    String? changed;
    await _pumpEditor(
      tester,
      initialValue: 'alpha beta',
      onChanged: (value) => changed = value,
    );
    final field = find.byKey(const Key('embedded-markdown-text-field'));
    await tester.tap(field);
    final editable = tester.state<EditableTextState>(find.byType(EditableText));
    editable.userUpdateTextEditingValue(
      const TextEditingValue(
        text: 'alpha beta',
        selection: TextSelection(baseOffset: 6, extentOffset: 10),
      ),
      SelectionChangedCause.tap,
    );

    await tester.tap(find.byKey(const Key('markdown-bold-button')));
    await tester.pump();

    expect(changed, 'alpha **beta**');
    expect(
      tester.widget<TextField>(field).controller?.selection,
      const TextSelection(baseOffset: 8, extentOffset: 12),
    );
  });

  testWidgets('image menu forwards source, selection, and trimmed alt text',
      (tester) async {
    AttachmentPickSource? source;
    MarkdownSelection? selection;
    String? receivedAltText;
    await _pumpEditor(
      tester,
      initialValue: 'alpha',
      platform: TargetPlatform.android,
      onInsertImage: (picked, selected, {required altText}) async {
        source = picked;
        selection = selected;
        receivedAltText = altText;
        return const MarkdownEditResult(
          markdown: 'alpha![diagram](attachment://att-1)',
          selection: MarkdownSelection(baseOffset: 35, extentOffset: 35),
        );
      },
    );
    final field = find.byKey(const Key('embedded-markdown-text-field'));
    await tester.tap(field);
    tester.widget<TextField>(field).controller?.selection =
        const TextSelection.collapsed(offset: 5);

    await tester.tap(find.byKey(const Key('markdown-image-button')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('markdown-image-alt-text')),
      '  diagram  ',
    );
    await tester.tap(find.byKey(const Key('markdown-image-gallery')));
    await tester.pumpAndSettle();

    expect(source, AttachmentPickSource.gallery);
    expect(selection?.baseOffset, 5);
    expect(selection?.extentOffset, 5);
    expect(receivedAltText, 'diagram');
    expect(tester.widget<TextField>(field).controller?.text,
        'alpha![diagram](attachment://att-1)');
    expect(
        tester.widget<TextField>(field).controller?.selection.baseOffset, 35);
  });

  testWidgets('blank alt falls back and cancellation preserves editor state',
      (tester) async {
    var callbackCount = 0;
    String? receivedAltText;
    await _pumpEditor(
      tester,
      initialValue: 'alpha',
      platform: TargetPlatform.android,
      onInsertImage: (_, __, {required altText}) async {
        callbackCount++;
        receivedAltText = altText;
        return null;
      },
    );
    final field = find.byKey(const Key('embedded-markdown-text-field'));

    await tester.tap(find.byKey(const Key('markdown-image-button')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('取消'));
    await tester.pumpAndSettle();
    expect(callbackCount, 0);
    expect(tester.widget<TextField>(field).controller?.text, 'alpha');

    await tester.tap(find.byKey(const Key('markdown-image-button')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('markdown-image-alt-text')),
      '   ',
    );
    await tester.tap(find.byKey(const Key('markdown-image-camera')));
    await tester.pumpAndSettle();
    expect(callbackCount, 1);
    expect(receivedAltText, '图片');
    expect(tester.widget<TextField>(field).controller?.text, 'alpha');
  });

  testWidgets('Windows image menu offers files only', (tester) async {
    await _pumpEditor(tester, initialValue: 'alpha');

    await tester.tap(find.byKey(const Key('markdown-image-button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('markdown-image-files')), findsOneWidget);
    expect(find.byKey(const Key('markdown-image-gallery')), findsNothing);
    expect(find.byKey(const Key('markdown-image-camera')), findsNothing);
  });
}

Future<void> _pumpEditor(
  WidgetTester tester, {
  required String initialValue,
  TargetPlatform platform = TargetPlatform.windows,
  ValueChanged<String>? onChanged,
  Future<MarkdownEditResult?> Function(
    AttachmentPickSource source,
    MarkdownSelection selection, {
    required String altText,
  })? onInsertImage,
}) {
  return tester.pumpWidget(MaterialApp(
    theme: ThemeData(platform: platform),
    home: Scaffold(
      body: EmbeddedMarkdownEditor(
        initialValue: initialValue,
        onChanged: onChanged ?? (_) {},
        onInsertImage:
            onInsertImage ?? (_, __, {required altText}) async => null,
        textStyle: const TextStyle(fontSize: 16),
      ),
    ),
  ));
}
