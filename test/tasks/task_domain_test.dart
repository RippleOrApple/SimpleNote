import 'package:flutter_test/flutter_test.dart';
import 'package:simple_note/features/tasks/domain/smart_filter.dart';
import 'package:simple_note/features/tasks/domain/task.dart';
import 'package:simple_note/features/tasks/domain/task_completion.dart';
import 'package:simple_note/features/tasks/domain/task_query.dart';
import 'package:simple_note/features/tasks/domain/task_reminder.dart';

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

  test('TaskReminder JSON round-trips absolute and relative triggers', () {
    const absolute = TaskReminder(
      id: 'reminder-1',
      taskId: 'task-1',
      triggerAt: 1000,
      createdAt: 100,
      updatedAt: 200,
      deviceId: 'device',
    );
    const relative = TaskReminder(
      id: 'reminder-2',
      taskId: 'task-1',
      offsetMinutes: -30,
      firedAt: 1200,
      createdAt: 100,
      updatedAt: 200,
      deviceId: 'device',
    );

    expect(
        TaskReminder.fromJson(absolute.toJson()).toJson(), absolute.toJson());
    expect(
        TaskReminder.fromJson(relative.toJson()).toJson(), relative.toJson());
    expect(absolute.isAbsolute, isTrue);
    expect(relative.isRelative, isTrue);
  });

  test('TaskCompletion JSON round-trips sync fields', () {
    const completion = TaskCompletion(
      id: 'completion-1',
      taskId: 'task-1',
      scheduledAt: 1000,
      completedAt: 1500,
      createdAt: 1500,
      updatedAt: 1600,
      deviceId: 'device',
      version: 2,
    );

    final restored = TaskCompletion.fromJson(completion.toJson());

    expect(restored.toJson(), completion.toJson());
    expect(restored.isDeleted, isFalse);
  });

  test('TaskReminder copyWith can switch trigger type and clear fire state',
      () {
    const reminder = TaskReminder(
      id: 'reminder-1',
      taskId: 'task-1',
      triggerAt: 1000,
      firedAt: 1200,
      createdAt: 100,
      updatedAt: 200,
      deviceId: 'device',
    );

    final updated = reminder.copyWith(
      clearTriggerAt: true,
      offsetMinutes: -15,
      clearFiredAt: true,
    );

    expect(updated.triggerAt, isNull);
    expect(updated.offsetMinutes, -15);
    expect(updated.firedAt, isNull);
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
        startRange: TaskDateRange(from: 1000, before: 2000),
        dueRange: TaskDateRange(before: 3000),
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
    expect(restored.rules.startRange?.from, 1000);
    expect(restored.rules.startRange?.before, 2000);
    expect(restored.rules.dueRange?.before, 3000);
    expect(restored.sortMode, TaskSortMode.priority);
  });

  test('filter rules remain compatible without date ranges', () {
    final rules = TaskFilterRules.fromJson({
      'listIds': ['list-1'],
      'tagIds': const [],
      'completed': false,
      'priorities': ['high'],
    });

    expect(rules.listIds, {'list-1'});
    expect(rules.startRange, isNull);
    expect(rules.dueRange, isNull);
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
