import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_note/features/tasks/application/tasks_controller.dart';
import 'package:simple_note/features/tasks/domain/task_query.dart';
import 'package:simple_note/features/tasks/presentation/task_filter_editor.dart';

void main() {
  testWidgets('date range controls are active in the smart filter editor',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: TaskFilterEditor(
          state: TasksState(
            sources: const [],
            tasks: const [],
            lists: const [],
            tags: const [],
            filters: const [],
            tagIdsByTaskId: const {},
            query: TaskQuery.inbox(),
            searchText: '',
            subtasks: const [],
          ),
          onSave: ({required name, required rules, required sortMode}) async {},
        ),
      ),
    ));

    expect(find.byKey(const Key('task-filter-start-range-button')), findsOne);
    expect(find.byKey(const Key('task-filter-due-range-button')), findsOne);
    expect(find.textContaining('Phase 2'), findsNothing);

    final startRangeButton =
        find.byKey(const Key('task-filter-start-range-button'));
    await tester.ensureVisible(startRangeButton);
    await tester.pumpAndSettle();
    await tester.tap(startRangeButton);
    await tester.pumpAndSettle();

    expect(find.byType(DateRangePickerDialog), findsOneWidget);
  });
}
