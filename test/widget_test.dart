import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_note/app.dart';

void main() {
  testWidgets('SimpleNote starts on the notes page', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: SimpleNoteApp()));

    expect(find.text('Notes'), findsWidgets);
    expect(find.text('Create your first Markdown note.'), findsOneWidget);
  });
}
