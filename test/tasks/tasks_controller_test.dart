import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_note/database/app_database.dart';
import 'package:simple_note/features/appearance/domain/rgb_color.dart';
import 'package:simple_note/features/sync/data/sync_repository.dart';
import 'package:simple_note/features/sync/domain/device_info.dart';
import 'package:simple_note/features/tasks/application/tasks_controller.dart';
import 'package:simple_note/features/tasks/data/tasks_repository.dart';
import 'package:simple_note/features/tasks/domain/task.dart';
import 'package:simple_note/features/tasks/domain/task_query.dart';

void main() {
  test('runs the task, list, tag, subtask, and filter workflow', () async {
    final harness = await _Harness.create();
    addTearDown(harness.dispose);
    final controller = harness.controller;

    await controller.quickAdd('  Prepare release  ');
    var state = await harness.state;
    final taskId = state.tasks.single.id;
    expect(state.tasks.single.title, 'Prepare release');
    expect(state.selectedTaskId, taskId);

    await controller.createList(
      'Work',
      color: const RgbColor(0x4D8BB8),
      iconKey: 'briefcase',
    );
    var list = (await harness.state).lists.single;
    await controller.updateListStyle(
      list.id,
      color: const RgbColor(0x5E9D83),
      iconKey: 'folder-open',
    );
    list = (await harness.state).lists.single;
    expect(list.color, 0x5E9D83);
    expect(list.iconKey, 'folder-open');

    await controller.updateTask(
      taskId,
      listId: list.id,
      priority: TaskPriority.high,
      startAt: 1000,
      dueAt: 2000,
      allDay: true,
      recurrenceRule: 'FREQ=DAILY',
      recurrenceEndAt: 9000,
      recurrenceCount: 3,
    );
    await controller.createTag(
      'focus',
      color: const RgbColor(0x8A6FB0),
    );
    var tag = (await harness.state).tags.single;
    await controller.updateTag(
      tag.id,
      name: 'deep focus',
      color: const RgbColor(0xB66B86),
    );
    tag = (await harness.state).tags.single;
    expect(tag.name, 'deep focus');
    expect(tag.color, 0xB66B86);

    await controller.setTaskTags(taskId, {tag.id});
    await controller.addSubtask(taskId, 'Write checks');

    state = await harness.state;
    expect(state.selectedTask?.priority, TaskPriority.high);
    expect(state.selectedTask?.startAt, 1000);
    expect(state.selectedTask?.dueAt, 2000);
    expect(state.selectedTask?.allDay, isTrue);
    expect(state.selectedTask?.recurrenceRule, 'FREQ=DAILY');
    expect(state.selectedTask?.recurrenceEndAt, 9000);
    expect(state.selectedTask?.recurrenceCount, 3);
    expect(state.subtasks, hasLength(1));
    expect(state.tagIdsFor(taskId), {tag.id});

    await controller.saveSmartFilter(
      name: 'Focus',
      rules: TaskFilterRules(
        tagIds: {tag.id},
        startRange: const TaskDateRange(from: 1000, before: 2000),
      ),
      sortMode: TaskSortMode.priority,
    );
    final savedFilter = (await harness.state).filters.single;
    expect(savedFilter.name, 'Focus');
    expect(savedFilter.rules.startRange?.from, 1000);

    await controller.deleteTag(tag.id);
    state = await harness.state;
    expect(state.tags, isEmpty);
    expect(state.tagIdsFor(taskId), isEmpty);
  });

  test('blank quick add is ignored and all priorities survive reload',
      () async {
    final harness = await _Harness.create();
    addTearDown(harness.dispose);
    final controller = harness.controller;

    await controller.quickAdd('   ');
    expect((await harness.state).tasks, isEmpty);

    const priorities = TaskPriority.values;
    for (var index = 0; index < priorities.length; index++) {
      await controller.quickAdd('Task $index');
      final id = (await harness.state).selectedTaskId!;
      await controller.updateTask(id, priority: priorities[index]);
    }
    await controller.selectQuery(TaskQuery.all(includeCompleted: true));

    expect(
      (await harness.state).tasks.map((task) => task.priority).toSet(),
      priorities.toSet(),
    );
  });

  test('search restores the last source and selection stays valid', () async {
    final harness = await _Harness.create();
    addTearDown(harness.dispose);
    final controller = harness.controller;

    await controller.selectQuery(TaskQuery.inbox());
    await controller.quickAdd('Alpha release');
    final alphaId = (await harness.state).selectedTaskId!;
    await controller.quickAdd('Beta planning');
    controller.selectTask(alphaId);
    await Future<void>.delayed(Duration.zero);

    await controller.setSearchText('release');
    var state = await harness.state;
    expect(state.searchResults.map((task) => task.id), [alphaId]);

    await controller.setSearchText('');
    state = await harness.state;
    expect(state.query, isA<InboxTaskQuery>());
    expect(state.tasks, hasLength(2));

    await controller.selectQuery(TaskQuery.today(
      dayStart: 0,
      nextDayStart: 1,
    ));
    state = await harness.state;
    expect(state.selectedTaskId, isNull);
  });

  test('superseded search debounce completes and applies only latest text',
      () async {
    final harness = await _Harness.create();
    addTearDown(harness.dispose);
    final controller = harness.controller;
    await controller.selectQuery(TaskQuery.inbox());
    await controller.quickAdd('Alpha release');
    await controller.quickAdd('Beta planning');

    final first = controller.setSearchText('Alpha');
    final second = controller.setSearchText('Beta');
    await Future.wait([first, second]);

    final state = await harness.state;
    expect(state.searchText, 'Beta');
    expect(state.searchResults.single.title, 'Beta planning');
  });

  test('deleting a list moves its tasks to Inbox', () async {
    final harness = await _Harness.create();
    addTearDown(harness.dispose);
    final controller = harness.controller;

    await controller.createList(
      'Work',
      color: const RgbColor(0x4D8BB8),
      iconKey: 'briefcase',
    );
    final listId = (await harness.state).lists.single.id;
    await controller.selectQuery(TaskQuery.list(listId));
    await controller.quickAdd('Listed task');
    final taskId = (await harness.state).selectedTaskId!;

    await controller.deleteList(listId);
    final state = await harness.state;

    expect(state.query, isA<InboxTaskQuery>());
    expect(state.lists, isEmpty);
    expect(state.tasks.single.id, taskId);
    expect(state.tasks.single.listId, isNull);
  });

  test('toggle completion records a durable completion event', () async {
    final harness = await _Harness.create();
    addTearDown(harness.dispose);
    final controller = harness.controller;

    await controller.quickAdd('Done through controller');
    final taskId = (await harness.state).selectedTaskId!;

    await controller.toggleTask(taskId);

    final repository = DriftTasksRepository(harness.database);
    final task = await repository.findTask(taskId);
    final completions = await repository.listTaskCompletions(taskId);

    expect(task?.completed, isTrue);
    expect(completions, hasLength(1));
    expect(completions.single.taskId, taskId);
  });

  test('write failure preserves state and selection', () async {
    final database = AppDatabase(NativeDatabase.memory());
    final repository = _FailingTasksRepository(database);
    final container = ProviderContainer(overrides: [
      appDatabaseProvider.overrideWithValue(database),
      tasksRepositoryProvider.overrideWithValue(repository),
      deviceInfoProvider.overrideWithValue(_device),
    ]);
    addTearDown(() async {
      container.dispose();
      await database.close();
    });
    final controller = container.read(tasksControllerProvider.notifier);
    await container.read(tasksControllerProvider.future);

    await controller.quickAdd('Will fail');
    final state = await container.read(tasksControllerProvider.future);

    expect(state.tasks, isEmpty);
    expect(state.selectedTaskId, isNull);
    expect(state.saveStatus, TaskSaveStatus.failed);
    expect(state.errorMessage, contains('forced failure'));
  });
}

class _Harness {
  const _Harness(this.container, this.database);

  final ProviderContainer container;
  final AppDatabase database;

  TasksController get controller =>
      container.read(tasksControllerProvider.notifier);
  Future<TasksState> get state =>
      container.read(tasksControllerProvider.future);

  static Future<_Harness> create() async {
    final database = AppDatabase(NativeDatabase.memory());
    final container = ProviderContainer(overrides: [
      appDatabaseProvider.overrideWithValue(database),
      deviceInfoProvider.overrideWithValue(_device),
    ]);
    await container.read(tasksControllerProvider.future);
    return _Harness(container, database);
  }

  Future<void> dispose() async {
    container.dispose();
    await database.close();
  }
}

class _FailingTasksRepository extends DriftTasksRepository {
  const _FailingTasksRepository(super.database);

  @override
  Future<void> upsertTask(Task task) =>
      Future.error(StateError('forced failure'));
}

const _device = DeviceInfo(
  deviceId: 'task-controller-device',
  deviceName: 'Test device',
  platform: 'windows',
  appVersion: '1.0.0',
);
