import 'package:flutter_test/flutter_test.dart';
import 'package:simple_note/features/tasks/domain/smart_filter.dart';
import 'package:simple_note/features/tasks/domain/task.dart';
import 'package:simple_note/features/tasks/domain/task_query.dart';

void main() {
  test('Task JSON round-trips nullable fields and priority', () {
    const task = Task(
      id: 'task-1',
      title: 'Plan',
      descriptionMarkdown: '# Plan',
      priority: TaskPriority.high,
      createdAt: 100,
      updatedAt: 200,
      deviceId: 'device',
    );

    final restored = Task.fromJson(task.toJson());

    expect(restored.priority, TaskPriority.high);
    expect(restored.descriptionMarkdown, '# Plan');
    expect(restored.parentId, isNull);
    expect(restored.toJson(), task.toJson());
  });

  test('Task copyWith can explicitly clear nullable fields', () {
    const task = Task(
      id: 'task-1',
      title: 'Plan',
      parentId: 'parent',
      listId: 'list',
      dueAt: 1000,
      createdAt: 100,
      updatedAt: 200,
      deviceId: 'device',
    );

    final cleared = task.copyWith(
      clearParentId: true,
      clearListId: true,
      clearDueAt: true,
    );

    expect(cleared.parentId, isNull);
    expect(cleared.listId, isNull);
    expect(cleared.dueAt, isNull);
  });

  test('filter rules and smart filters round-trip deterministically', () {
    const filter = SmartFilter(
      id: 'filter-1',
      name: 'High priority',
      rules: TaskFilterRules(
        listIds: {'list-1'},
        tagIds: {'tag-1'},
        completed: false,
        priorities: {TaskPriority.high},
      ),
      sortMode: TaskSortMode.priority,
      createdAt: 1,
      updatedAt: 2,
      deviceId: 'device',
    );

    final restored = SmartFilter.fromJson(filter.toJson());

    expect(restored.rules.listIds, {'list-1'});
    expect(restored.rules.tagIds, {'tag-1'});
    expect(restored.rules.priorities, {TaskPriority.high});
    expect(restored.sortMode, TaskSortMode.priority);
  });

  test('query factories preserve their semantics and sort mode', () {
    final query = TaskQuery.today(
      dayStart: 1000,
      nextDayStart: 2000,
      sortMode: TaskSortMode.dueAt,
    );

    expect(query, isA<TodayTaskQuery>());
    expect((query as TodayTaskQuery).dayStart, 1000);
    expect(query.sortMode, TaskSortMode.dueAt);
  });
}
