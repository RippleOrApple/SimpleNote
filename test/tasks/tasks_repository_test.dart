import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_note/database/app_database.dart';
import 'package:simple_note/features/tasks/data/tasks_repository.dart';
import 'package:simple_note/features/tasks/domain/smart_filter.dart';
import 'package:simple_note/features/tasks/domain/task.dart';
import 'package:simple_note/features/tasks/domain/task_list.dart';
import 'package:simple_note/features/tasks/domain/task_query.dart';
import 'package:simple_note/features/tasks/domain/task_tag.dart';

void main() {
  late AppDatabase database;
  late DriftTasksRepository repository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = DriftTasksRepository(database);
  });

  tearDown(() => database.close());

  test('queries inbox, date sources, lists, filters, and completed state',
      () async {
    await repository.upsertTask(_task('inbox'));
    await repository.upsertTask(_task('overdue', dueAt: 500));
    await repository.upsertTask(_task('today', dueAt: 1500));
    await repository.upsertTask(_task('next', dueAt: 2500));
    await repository.upsertTask(_task('listed', listId: 'list-1'));
    await repository.upsertTask(_task('completed', completed: true));
    await repository.upsertTask(_task('child', parentId: 'listed'));

    expect(
      (await repository.queryTasks(TaskQuery.inbox())).map((task) => task.id),
      ['inbox'],
    );
    expect(
      (await repository.queryTasks(
        TaskQuery.today(dayStart: 1000, nextDayStart: 2000),
      ))
          .map((task) => task.id),
      containsAll(['overdue', 'today']),
    );
    expect(
      (await repository.queryTasks(
        TaskQuery.nextSevenDays(dayStart: 2000, eighthDayStart: 9000),
      ))
          .map((task) => task.id),
      contains('next'),
    );
    expect(
      (await repository.queryTasks(TaskQuery.list('list-1')))
          .map((task) => task.id),
      ['listed'],
    );
    expect(
      (await repository.queryTasks(TaskQuery.all())).map((task) => task.id),
      isNot(contains('completed')),
    );
    expect(
      (await repository.queryTasks(
        TaskQuery.all(includeCompleted: true),
      ))
          .map((task) => task.id),
      contains('completed'),
    );
  });

  test('search matches title, body, list, and tag once', () async {
    await repository.upsertTask(_task('title-match', title: 'Release plan'));
    await repository.upsertTask(
      _task('body-match', descriptionMarkdown: 'Prepare the release notes'),
    );
    await repository.upsertTask(_task('list-match', listId: 'release-list'));
    await repository.upsertTask(_task('tag-match'));
    await repository.upsertTask(_task('other'));
    await repository.upsertTaskList(_list('release-list', name: 'Release'));
    await repository.upsertTaskTag(_tag('release-tag', name: 'Release'));
    await repository.replaceTaskTags('tag-match', ['release-tag']);

    final result = await repository.searchTasks(' release ');

    expect(
      result.map((task) => task.id),
      containsAll(['title-match', 'body-match', 'list-match', 'tag-match']),
    );
    expect(result.map((task) => task.id).toSet().length, result.length);
  });

  test('search escapes SQL wildcard characters and preserves sorting',
      () async {
    await repository.upsertTask(
      _task('literal', title: 'Release 100%', dueAt: 2000),
    );
    await repository.upsertTask(
      _task('wildcard-decoy', title: 'Release 1000', dueAt: 1000),
    );

    final result = await repository.searchTasks(
      '100%',
      sortMode: TaskSortMode.dueAt,
    );

    expect(result.map((task) => task.id), ['literal']);
  });

  test('tag filters require every selected tag', () async {
    await repository.upsertTask(_task('tagged'));
    await repository.upsertTaskTag(_tag('one'));
    await repository.upsertTaskTag(_tag('two'));
    await repository.replaceTaskTags('tagged', ['one', 'two']);

    final result = await repository.queryTasks(
      TaskQuery.filter(
        const TaskFilterRules(tagIds: {'one', 'two'}),
        sortMode: TaskSortMode.manual,
      ),
    );

    expect(result.map((task) => task.id), ['tagged']);
  });

  test('enforces one subtask level and inherits parent list', () async {
    await repository.upsertTask(_task('parent', listId: 'list-1'));
    await repository.upsertTask(_task('child', parentId: 'parent'));

    expect((await repository.findTask('child'))?.listId, 'list-1');

    await expectLater(
      repository.upsertTask(_task('grandchild', parentId: 'child')),
      throwsA(isA<StateError>()),
    );
    await expectLater(
      repository.upsertTask(_task('parent', parentId: 'parent')),
      throwsA(isA<StateError>()),
    );
  });

  test('soft delete cascades direct children and rejects invalid tags',
      () async {
    await repository.upsertTask(_task('parent'));
    await repository.upsertTask(_task('child', parentId: 'parent'));
    await repository.softDeleteTask('parent', 9000);

    expect((await repository.findTask('parent'))?.deletedAt, 9000);
    expect((await repository.findTask('child'))?.deletedAt, 9000);

    await repository.upsertTask(_task('active'));
    await expectLater(
      repository.replaceTaskTags('active', ['missing']),
      throwsA(isA<StateError>()),
    );
    await repository.upsertTaskTag(_tag('deleted-tag'));
    await repository.softDeleteTaskTag('deleted-tag', 9010);
    await expectLater(
      repository.replaceTaskTags('active', ['deleted-tag']),
      throwsA(isA<StateError>()),
    );
  });

  test('taxonomy CRUD soft deletes records', () async {
    await repository.upsertTaskList(_list('list-1'));
    await repository.upsertTaskTag(_tag('tag-1'));
    await repository.upsertSmartFilter(_filter('filter-1'));

    expect((await repository.listTaskLists()).single.id, 'list-1');
    expect((await repository.listTaskTags()).single.id, 'tag-1');
    expect((await repository.listSmartFilters()).single.id, 'filter-1');

    await repository.softDeleteTaskList('list-1', 100);
    await repository.softDeleteTaskTag('tag-1', 101);
    await repository.softDeleteSmartFilter('filter-1', 102);

    expect(await repository.listTaskLists(), isEmpty);
    expect(await repository.listTaskTags(), isEmpty);
    expect(await repository.listSmartFilters(), isEmpty);
  });
}

Task _task(
  String id, {
  String? parentId,
  String? listId,
  String? title,
  String descriptionMarkdown = '',
  bool completed = false,
  int? dueAt,
}) {
  return Task(
    id: id,
    parentId: parentId,
    listId: listId,
    title: title ?? id,
    descriptionMarkdown: descriptionMarkdown,
    completed: completed,
    dueAt: dueAt,
    createdAt: 1,
    updatedAt: 1,
    deviceId: 'device',
  );
}

TaskList _list(String id, {String name = 'List'}) => TaskList(
      id: id,
      name: name,
      color: 0x596790,
      iconKey: 'list',
      createdAt: 1,
      updatedAt: 1,
      deviceId: 'device',
    );

TaskTag _tag(String id, {String? name}) => TaskTag(
      id: id,
      name: name ?? id,
      color: 0x596790,
      createdAt: 1,
      updatedAt: 1,
      deviceId: 'device',
    );

SmartFilter _filter(String id) => SmartFilter(
      id: id,
      name: id,
      rules: const TaskFilterRules(),
      sortMode: TaskSortMode.manual,
      createdAt: 1,
      updatedAt: 1,
      deviceId: 'device',
    );
