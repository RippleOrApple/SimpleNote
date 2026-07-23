import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/time.dart';
import '../../../database/app_database.dart';
import '../domain/smart_filter.dart';
import '../domain/task.dart';
import '../domain/task_completion.dart';
import '../domain/task_list.dart';
import '../domain/task_query.dart';
import '../domain/task_recurrence.dart';
import '../domain/task_reminder.dart';
import '../domain/task_reminder_schedule.dart';
import '../domain/task_tag.dart';

final tasksRepositoryProvider = Provider<TasksRepository>(
  (ref) => DriftTasksRepository(ref.watch(appDatabaseProvider)),
);

abstract class TasksRepository {
  Future<List<Task>> queryTasks(TaskQuery query);
  Future<List<Task>> searchTasks(
    String query, {
    TaskSortMode sortMode = TaskSortMode.manual,
    bool includeCompleted = false,
  });
  Future<Task?> findTask(String id);
  Future<List<Task>> listSubtasks(String parentId);
  Future<List<TaskCompletion>> listTaskCompletions(String taskId);
  Future<List<TaskReminder>> listTaskReminders(String taskId);
  Future<List<TaskReminderSchedule>> listPendingTaskReminderSchedules({
    required int now,
    required int before,
  });
  Future<Map<String, Set<String>>> taskTagIds(Iterable<String> taskIds);
  Future<void> upsertTask(Task task);
  Future<void> completeTaskOccurrence(
    String id, {
    required int completedAt,
    required String completionId,
  });
  Future<void> uncompleteTask(String id, int updatedAt);
  Future<void> upsertTaskReminder(TaskReminder reminder);
  Future<void> markTaskReminderFired(String id, int firedAt);
  Future<void> softDeleteTask(String id, int deletedAt);
  Future<void> softDeleteTaskReminder(String id, int deletedAt);
  Future<void> replaceTaskTags(String taskId, Iterable<String> tagIds);

  Future<List<TaskList>> listTaskLists();
  Future<void> upsertTaskList(TaskList list);
  Future<void> softDeleteTaskList(String id, int deletedAt);
  Future<void> deleteTaskListAndMoveTasksToInbox(String id, int deletedAt);
  Future<List<TaskTag>> listTaskTags();
  Future<void> upsertTaskTag(TaskTag tag);
  Future<void> softDeleteTaskTag(String id, int deletedAt);
  Future<List<SmartFilter>> listSmartFilters();
  Future<void> upsertSmartFilter(SmartFilter filter);
  Future<void> softDeleteSmartFilter(String id, int deletedAt);
}

class DriftTasksRepository implements TasksRepository {
  const DriftTasksRepository(this._database);

  final AppDatabase _database;

  @override
  Future<List<Task>> queryTasks(TaskQuery query) async {
    final table = _database.tasksV2;
    final rows = await (_database.select(table)
          ..where((task) => _queryPredicate(task, query))
          ..orderBy(_orderTerms(query.sortMode)))
        .get();
    if (query case FilteredTaskQuery(:final rules)) {
      return _filterByTags(rows, rules.tagIds).then(
        (filtered) => filtered
            .where((row) => _matchesRules(row, rules))
            .map(_fromRow)
            .toList(),
      );
    }
    return rows.map(_fromRow).toList();
  }

  @override
  Future<List<Task>> searchTasks(
    String query, {
    TaskSortMode sortMode = TaskSortMode.manual,
    bool includeCompleted = false,
  }) async {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) {
      return queryTasks(
        TaskQuery.all(
          includeCompleted: includeCompleted,
          sortMode: sortMode,
        ),
      );
    }
    final escaped = _escapeLike(normalized);
    final rows = await _database.customSelect(
      '''
      SELECT DISTINCT t.*
      FROM tasks_v2 t
      LEFT JOIN task_lists l
        ON l.id = t.list_id AND l.deleted_at IS NULL
      LEFT JOIN task_tag_links ttl
        ON ttl.task_id = t.id AND ttl.deleted_at IS NULL
      LEFT JOIN task_tags tg
        ON tg.id = ttl.tag_id AND tg.deleted_at IS NULL
      WHERE t.deleted_at IS NULL
        AND t.parent_id IS NULL
        AND (:includeCompleted = 1 OR t.completed = 0)
        AND (
          lower(t.title) LIKE :pattern ESCAPE '\\'
          OR lower(t.description_markdown) LIKE :pattern ESCAPE '\\'
          OR lower(coalesce(l.name, '')) LIKE :pattern ESCAPE '\\'
          OR lower(coalesce(tg.name, '')) LIKE :pattern ESCAPE '\\'
        )
      ''',
      variables: [
        Variable<int>(includeCompleted ? 1 : 0),
        Variable<String>('%$escaped%'),
      ],
      readsFrom: {
        _database.tasksV2,
        _database.taskLists,
        _database.taskTagLinks,
        _database.taskTags,
      },
    ).get();
    final mapped = rows.map((row) => _database.tasksV2.map(row.data)).toList()
      ..sort(_comparator(sortMode));
    return mapped.map(_fromRow).toList();
  }

  @override
  Future<Task?> findTask(String id) async {
    final row = await _database.tasksV2Dao.findById(id);
    return row == null ? null : _fromRow(row);
  }

  @override
  Future<List<Task>> listSubtasks(String parentId) async {
    final rows = await _database.tasksV2Dao.directChildren(parentId);
    return rows.where((row) => row.deletedAt == null).map(_fromRow).toList()
      ..sort((left, right) => left.sortOrder.compareTo(right.sortOrder));
  }

  @override
  Future<List<TaskReminder>> listTaskReminders(String taskId) async {
    final rows = await (_database.select(_database.taskReminders)
          ..where((row) => row.taskId.equals(taskId) & row.deletedAt.isNull()))
        .get();
    return rows.map(_fromReminderRow).toList()..sort(_reminderComparator);
  }

  @override
  Future<List<TaskReminderSchedule>> listPendingTaskReminderSchedules({
    required int now,
    required int before,
  }) async {
    if (before <= now) return const [];
    final reminderRows = await (_database.select(_database.taskReminders)
          ..where(
            (reminder) =>
                reminder.deletedAt.isNull() & reminder.firedAt.isNull(),
          ))
        .get();
    final schedules = <TaskReminderSchedule>[];
    for (final reminderRow in reminderRows) {
      final taskRow = await _database.tasksV2Dao.findById(reminderRow.taskId);
      if (taskRow == null || taskRow.deletedAt != null || taskRow.completed) {
        continue;
      }
      final fireAt = _resolveReminderFireAt(reminderRow, taskRow);
      if (fireAt == null || fireAt <= now || fireAt >= before) continue;
      schedules.add(TaskReminderSchedule(
        task: _fromRow(taskRow),
        reminder: _fromReminderRow(reminderRow),
        fireAt: fireAt,
      ));
    }
    schedules.sort(_scheduleComparator);
    return schedules;
  }

  @override
  Future<List<TaskCompletion>> listTaskCompletions(String taskId) async {
    final rows = await (_database.select(_database.taskCompletions)
          ..where((row) => row.taskId.equals(taskId) & row.deletedAt.isNull())
          ..orderBy([
            (row) => OrderingTerm.asc(row.scheduledAt),
            (row) => OrderingTerm.asc(row.completedAt),
          ]))
        .get();
    return rows.map(_fromCompletionRow).toList();
  }

  @override
  Future<Map<String, Set<String>>> taskTagIds(
    Iterable<String> taskIds,
  ) async {
    final ids = taskIds.toSet();
    final links = await _database.taskTaxonomyDao.activeLinksForTasks(ids);
    final activeTagIds = (await _database.taskTaxonomyDao.activeTags())
        .map((tag) => tag.id)
        .toSet();
    final result = <String, Set<String>>{
      for (final id in ids) id: <String>{},
    };
    for (final link in links) {
      if (activeTagIds.contains(link.tagId)) {
        result[link.taskId]?.add(link.tagId);
      }
    }
    return result;
  }

  @override
  Future<void> upsertTask(Task task) async {
    await _database.transaction(() async {
      var normalized = task;
      if (task.parentId != null) {
        if (task.parentId == task.id) {
          throw StateError('任务不能把自己设为父任务。');
        }
        final parent = await _database.tasksV2Dao.findById(task.parentId!);
        if (parent == null || parent.deletedAt != null) {
          throw StateError('父任务不存在或已删除。');
        }
        if (parent.parentId != null) {
          throw StateError('目前只支持一层子任务。');
        }
        normalized = task.copyWith(
          listId: parent.listId,
          clearListId: parent.listId == null,
        );
      }
      await _database.tasksV2Dao.upsertTask(_toCompanion(normalized));
    });
  }

  @override
  Future<void> completeTaskOccurrence(
    String id, {
    required int completedAt,
    required String completionId,
  }) async {
    final row = await _database.tasksV2Dao.findById(id);
    if (row == null || row.deletedAt != null) {
      throw StateError('无法完成不存在或已删除的任务。');
    }
    final task = _fromRow(row);
    final existingCompletions = await listTaskCompletions(id);
    final recurrence = advanceRecurringTask(
      task: task,
      completedAt: completedAt,
      completionCountAfterThis: existingCompletions.length + 1,
    );
    final scheduledAt =
        recurrence?.scheduledAt ?? task.dueAt ?? task.startAt ?? completedAt;
    final nextTask = recurrence?.nextTask ??
        task.copyWith(
          completed: true,
          completedAt: completedAt,
          updatedAt: completedAt,
          version: task.version + 1,
        );
    await _database.transaction(() async {
      await _database.into(_database.taskCompletions).insert(
            TaskCompletionsCompanion.insert(
              id: completionId,
              taskId: id,
              scheduledAt: scheduledAt,
              completedAt: completedAt,
              createdAt: completedAt,
              updatedAt: completedAt,
              deviceId: task.deviceId,
            ),
          );
      await _database.tasksV2Dao.upsertTask(_toCompanion(nextTask));
    });
  }

  @override
  Future<void> uncompleteTask(String id, int updatedAt) async {
    final row = await _database.tasksV2Dao.findById(id);
    if (row == null || row.deletedAt != null) {
      throw StateError('无法取消完成不存在或已删除的任务。');
    }
    await _database.transaction(() async {
      await _database.tasksV2Dao.upsertTask(_toCompanion(
        _fromRow(row).copyWith(
          completed: false,
          clearCompletedAt: true,
          updatedAt: updatedAt,
          version: row.version + 1,
        ),
      ));
      final latest = await (_database.select(_database.taskCompletions)
            ..where(
              (completion) =>
                  completion.taskId.equals(id) & completion.deletedAt.isNull(),
            )
            ..orderBy([
              (completion) => OrderingTerm.desc(completion.completedAt),
            ])
            ..limit(1))
          .getSingleOrNull();
      if (latest != null) {
        await (_database.update(_database.taskCompletions)
              ..where((completion) => completion.id.equals(latest.id)))
            .write(TaskCompletionsCompanion(
          deletedAt: Value(updatedAt),
          updatedAt: Value(updatedAt),
          version: Value(latest.version + 1),
        ));
      }
    });
  }

  @override
  Future<void> upsertTaskReminder(TaskReminder reminder) async {
    _validateReminderTrigger(reminder);
    await _database.transaction(() async {
      final task = await _database.tasksV2Dao.findById(reminder.taskId);
      if (task == null || task.deletedAt != null) {
        throw StateError('无法为不存在的任务创建提醒。');
      }
      await _database.into(_database.taskReminders).insertOnConflictUpdate(
            _toReminderCompanion(reminder),
          );
    });
  }

  @override
  Future<void> markTaskReminderFired(String id, int firedAt) async {
    final row = await (_database.select(_database.taskReminders)
          ..where((reminder) => reminder.id.equals(id)))
        .getSingleOrNull();
    if (row == null || row.deletedAt != null) return;
    await (_database.update(_database.taskReminders)
          ..where((reminder) => reminder.id.equals(id)))
        .write(TaskRemindersCompanion(
      firedAt: Value(firedAt),
      updatedAt: Value(firedAt),
      version: Value(row.version + 1),
    ));
  }

  @override
  Future<void> softDeleteTask(String id, int deletedAt) {
    return _database.transaction(() async {
      final children = await _database.tasksV2Dao.directChildren(id);
      final taskIds = [
        id,
        ...children.map((child) => child.id),
      ];
      await (_database.update(_database.tasksV2)
            ..where((task) => task.id.equals(id)))
          .write(
        TasksV2Companion(
          deletedAt: Value(deletedAt),
          updatedAt: Value(deletedAt),
        ),
      );
      await (_database.update(_database.tasksV2)
            ..where((task) => task.parentId.equals(id)))
          .write(
        TasksV2Companion(
          deletedAt: Value(deletedAt),
          updatedAt: Value(deletedAt),
        ),
      );
      await (_database.update(_database.taskCompletions)
            ..where(
              (completion) =>
                  completion.taskId.isIn(taskIds) &
                  completion.deletedAt.isNull(),
            ))
          .write(
        TaskCompletionsCompanion(
          deletedAt: Value(deletedAt),
          updatedAt: Value(deletedAt),
        ),
      );
      await (_database.update(_database.taskReminders)
            ..where(
              (reminder) =>
                  reminder.taskId.isIn(taskIds) & reminder.deletedAt.isNull(),
            ))
          .write(
        TaskRemindersCompanion(
          deletedAt: Value(deletedAt),
          updatedAt: Value(deletedAt),
        ),
      );
    });
  }

  @override
  Future<void> softDeleteTaskReminder(String id, int deletedAt) =>
      (_database.update(_database.taskReminders)
            ..where((row) => row.id.equals(id)))
          .write(TaskRemindersCompanion(
        deletedAt: Value(deletedAt),
        updatedAt: Value(deletedAt),
      ));

  @override
  Future<void> replaceTaskTags(String taskId, Iterable<String> tagIds) async {
    final ids = tagIds.toSet();
    await _database.transaction(() async {
      final task = await _database.tasksV2Dao.findById(taskId);
      if (task == null || task.deletedAt != null) {
        throw StateError('无法为不存在或已删除的任务设置标签。');
      }
      for (final tagId in ids) {
        final tag = await _database.taskTaxonomyDao.findTagById(tagId);
        if (tag == null || tag.deletedAt != null) {
          throw StateError('任务标签不存在或已删除。');
        }
      }
      final now = Clock.nowMillis();
      await _database.taskTaxonomyDao.replaceLinks(
        taskId,
        ids.map(
          (tagId) => TaskTagLinksCompanion(
            taskId: Value(taskId),
            tagId: Value(tagId),
            createdAt: Value(now),
            updatedAt: Value(now),
            deletedAt: const Value(null),
            deviceId: Value(task.deviceId),
            version: const Value(1),
          ),
        ),
        now,
      );
    });
  }

  @override
  Future<List<TaskList>> listTaskLists() async {
    final rows = await _database.taskTaxonomyDao.activeLists();
    return rows.map(_fromListRow).toList();
  }

  @override
  Future<void> upsertTaskList(TaskList list) =>
      _database.taskTaxonomyDao.upsertList(TaskListsCompanion(
        id: Value(list.id),
        name: Value(list.name),
        color: Value(list.color),
        iconKey: Value(list.iconKey),
        sortOrder: Value(list.sortOrder),
        archived: Value(list.archived),
        createdAt: Value(list.createdAt),
        updatedAt: Value(list.updatedAt),
        deletedAt: Value(list.deletedAt),
        deviceId: Value(list.deviceId),
        version: Value(list.version),
      ));

  @override
  Future<void> softDeleteTaskList(String id, int deletedAt) =>
      (_database.update(_database.taskLists)..where((row) => row.id.equals(id)))
          .write(TaskListsCompanion(
        deletedAt: Value(deletedAt),
        updatedAt: Value(deletedAt),
      ));

  @override
  Future<void> deleteTaskListAndMoveTasksToInbox(
    String id,
    int deletedAt,
  ) {
    return _database.transaction(() async {
      await (_database.update(_database.tasksV2)
            ..where((row) => row.listId.equals(id) & row.deletedAt.isNull()))
          .write(
        TasksV2Companion(
          listId: const Value(null),
          updatedAt: Value(deletedAt),
        ),
      );
      await softDeleteTaskList(id, deletedAt);
    });
  }

  @override
  Future<List<TaskTag>> listTaskTags() async {
    final rows = await _database.taskTaxonomyDao.activeTags();
    return rows.map(_fromTagRow).toList();
  }

  @override
  Future<void> upsertTaskTag(TaskTag tag) =>
      _database.taskTaxonomyDao.upsertTag(TaskTagsCompanion(
        id: Value(tag.id),
        name: Value(tag.name),
        color: Value(tag.color),
        createdAt: Value(tag.createdAt),
        updatedAt: Value(tag.updatedAt),
        deletedAt: Value(tag.deletedAt),
        deviceId: Value(tag.deviceId),
        version: Value(tag.version),
      ));

  @override
  Future<void> softDeleteTaskTag(String id, int deletedAt) =>
      (_database.update(_database.taskTags)..where((row) => row.id.equals(id)))
          .write(TaskTagsCompanion(
        deletedAt: Value(deletedAt),
        updatedAt: Value(deletedAt),
      ));

  @override
  Future<List<SmartFilter>> listSmartFilters() async {
    final rows = await _database.taskTaxonomyDao.activeFilters();
    return rows.map(_fromFilterRow).toList();
  }

  @override
  Future<void> upsertSmartFilter(SmartFilter filter) =>
      _database.taskTaxonomyDao.upsertFilter(SmartFiltersCompanion(
        id: Value(filter.id),
        name: Value(filter.name),
        rulesJson: Value(filter.rulesJson),
        sortMode: Value(filter.sortMode.name),
        sortOrder: Value(filter.sortOrder),
        pinned: Value(filter.pinned),
        createdAt: Value(filter.createdAt),
        updatedAt: Value(filter.updatedAt),
        deletedAt: Value(filter.deletedAt),
        deviceId: Value(filter.deviceId),
        version: Value(filter.version),
      ));

  @override
  Future<void> softDeleteSmartFilter(String id, int deletedAt) =>
      (_database.update(_database.smartFilters)
            ..where((row) => row.id.equals(id)))
          .write(SmartFiltersCompanion(
        deletedAt: Value(deletedAt),
        updatedAt: Value(deletedAt),
      ));

  Expression<bool> _queryPredicate($TasksV2Table task, TaskQuery query) {
    var expression = task.deletedAt.isNull() & task.parentId.isNull();
    switch (query) {
      case InboxTaskQuery():
        expression = expression &
            task.completed.equals(false) &
            task.listId.isNull() &
            task.startAt.isNull() &
            task.dueAt.isNull();
      case TodayTaskQuery(:final dayStart, :final nextDayStart):
        expression = expression &
            task.completed.equals(false) &
            (task.dueAt.isSmallerThanValue(nextDayStart) |
                _dateInRange(task.startAt, dayStart, nextDayStart));
      case NextSevenDaysTaskQuery(:final dayStart, :final eighthDayStart):
        expression = expression &
            task.completed.equals(false) &
            (_dateInRange(task.dueAt, dayStart, eighthDayStart) |
                _dateInRange(task.startAt, dayStart, eighthDayStart));
      case AllTaskQuery(:final includeCompleted):
        if (!includeCompleted) {
          expression = expression & task.completed.equals(false);
        }
      case ListTaskQuery(:final listId):
        expression = expression & task.listId.equals(listId);
      case FilteredTaskQuery(:final rules):
        if (rules.completed != null) {
          expression = expression & task.completed.equals(rules.completed!);
        }
        if (rules.listIds.isNotEmpty) {
          expression = expression & task.listId.isIn(rules.listIds);
        }
        if (rules.priorities.isNotEmpty) {
          expression = expression &
              task.priority.isIn(rules.priorities.map((item) => item.index));
        }
        if (rules.startRange != null) {
          expression =
              expression & _dateMatchesRule(task.startAt, rules.startRange!);
        }
        if (rules.dueRange != null) {
          expression =
              expression & _dateMatchesRule(task.dueAt, rules.dueRange!);
        }
    }
    return expression;
  }

  Expression<bool> _dateMatchesRule(
    GeneratedColumn<int> column,
    TaskDateRange range,
  ) {
    return _dateInRange(column, range.from, range.before);
  }

  Expression<bool> _dateInRange(
    GeneratedColumn<int> column,
    int? from,
    int? before,
  ) {
    var expression = column.isNotNull();
    if (from != null) {
      expression = expression & column.isBiggerOrEqualValue(from);
    }
    if (before != null) {
      expression = expression & column.isSmallerThanValue(before);
    }
    return expression;
  }

  List<OrderClauseGenerator<$TasksV2Table>> _orderTerms(
    TaskSortMode sortMode,
  ) {
    return switch (sortMode) {
      TaskSortMode.manual => [
          (item) => OrderingTerm.asc(item.sortOrder),
          (item) => OrderingTerm.asc(item.createdAt),
        ],
      TaskSortMode.dueAt => [
          (item) => OrderingTerm.asc(item.dueAt.isNull()),
          (item) => OrderingTerm.asc(item.dueAt),
          (item) => OrderingTerm.asc(item.sortOrder),
        ],
      TaskSortMode.priority => [
          (item) => OrderingTerm.desc(item.priority),
          (item) => OrderingTerm.asc(item.sortOrder),
        ],
      TaskSortMode.createdAt => [
          (item) => OrderingTerm.desc(item.createdAt),
        ],
    };
  }

  Future<List<TaskV2Row>> _filterByTags(
    List<TaskV2Row> rows,
    Set<String> tagIds,
  ) async {
    if (tagIds.isEmpty) return rows;
    final activeTagIds = (await _database.taskTaxonomyDao.activeTags())
        .map((tag) => tag.id)
        .toSet();
    if (!activeTagIds.containsAll(tagIds)) return const [];
    final links = await _database.taskTaxonomyDao.activeLinksForTasks(
      rows.map((row) => row.id),
    );
    final byTask = <String, Set<String>>{};
    for (final link in links) {
      (byTask[link.taskId] ??= {}).add(link.tagId);
    }
    return rows
        .where((row) => byTask[row.id]?.containsAll(tagIds) ?? false)
        .toList();
  }

  bool _matchesRules(TaskV2Row row, TaskFilterRules rules) {
    return (rules.listIds.isEmpty || rules.listIds.contains(row.listId)) &&
        (rules.completed == null || rules.completed == row.completed) &&
        (rules.priorities.isEmpty ||
            rules.priorities.contains(
              TaskPriority.values[row.priority],
            )) &&
        (rules.startRange == null || rules.startRange!.contains(row.startAt)) &&
        (rules.dueRange == null || rules.dueRange!.contains(row.dueAt));
  }

  Comparator<TaskV2Row> _comparator(TaskSortMode mode) {
    int compareNullable(int? a, int? b) {
      if (a == b) return 0;
      if (a == null) return 1;
      if (b == null) return -1;
      return a.compareTo(b);
    }

    return (left, right) => switch (mode) {
          TaskSortMode.manual => left.sortOrder.compareTo(right.sortOrder),
          TaskSortMode.dueAt => compareNullable(left.dueAt, right.dueAt),
          TaskSortMode.priority => right.priority.compareTo(left.priority),
          TaskSortMode.createdAt => right.createdAt.compareTo(left.createdAt),
        };
  }

  static String _escapeLike(String value) => value
      .replaceAll(r'\', r'\\')
      .replaceAll('%', r'\%')
      .replaceAll('_', r'\_');

  static TasksV2Companion _toCompanion(Task task) => TasksV2Companion(
        id: Value(task.id),
        parentId: Value(task.parentId),
        listId: Value(task.listId),
        title: Value(task.title),
        descriptionMarkdown: Value(task.descriptionMarkdown),
        completed: Value(task.completed),
        priority: Value(task.priority.index),
        startAt: Value(task.startAt),
        dueAt: Value(task.dueAt),
        allDay: Value(task.allDay),
        sortOrder: Value(task.sortOrder),
        recurrenceRule: Value(task.recurrenceRule),
        recurrenceEndAt: Value(task.recurrenceEndAt),
        recurrenceCount: Value(task.recurrenceCount),
        completedAt: Value(task.completedAt),
        createdAt: Value(task.createdAt),
        updatedAt: Value(task.updatedAt),
        deletedAt: Value(task.deletedAt),
        deviceId: Value(task.deviceId),
        version: Value(task.version),
      );

  static TaskRemindersCompanion _toReminderCompanion(
    TaskReminder reminder,
  ) =>
      TaskRemindersCompanion(
        id: Value(reminder.id),
        taskId: Value(reminder.taskId),
        triggerAt: Value(reminder.triggerAt),
        offsetMinutes: Value(reminder.offsetMinutes),
        firedAt: Value(reminder.firedAt),
        createdAt: Value(reminder.createdAt),
        updatedAt: Value(reminder.updatedAt),
        deletedAt: Value(reminder.deletedAt),
        deviceId: Value(reminder.deviceId),
        version: Value(reminder.version),
      );

  static Task _fromRow(TaskV2Row row) => Task(
        id: row.id,
        parentId: row.parentId,
        listId: row.listId,
        title: row.title,
        descriptionMarkdown: row.descriptionMarkdown,
        completed: row.completed,
        priority: TaskPriority.values[row.priority],
        startAt: row.startAt,
        dueAt: row.dueAt,
        allDay: row.allDay,
        sortOrder: row.sortOrder,
        recurrenceRule: row.recurrenceRule,
        recurrenceEndAt: row.recurrenceEndAt,
        recurrenceCount: row.recurrenceCount,
        completedAt: row.completedAt,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
        deletedAt: row.deletedAt,
        deviceId: row.deviceId,
        version: row.version,
      );

  static TaskCompletion _fromCompletionRow(TaskCompletionRow row) =>
      TaskCompletion(
        id: row.id,
        taskId: row.taskId,
        scheduledAt: row.scheduledAt,
        completedAt: row.completedAt,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
        deletedAt: row.deletedAt,
        deviceId: row.deviceId,
        version: row.version,
      );

  static TaskReminder _fromReminderRow(TaskReminderRow row) => TaskReminder(
        id: row.id,
        taskId: row.taskId,
        triggerAt: row.triggerAt,
        offsetMinutes: row.offsetMinutes,
        firedAt: row.firedAt,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
        deletedAt: row.deletedAt,
        deviceId: row.deviceId,
        version: row.version,
      );

  static int _reminderComparator(TaskReminder left, TaskReminder right) {
    final leftTime = left.triggerAt;
    final rightTime = right.triggerAt;
    if (leftTime != null && rightTime != null && leftTime != rightTime) {
      return leftTime.compareTo(rightTime);
    }
    if (leftTime != null && rightTime == null) return -1;
    if (leftTime == null && rightTime != null) return 1;
    final leftOffset = left.offsetMinutes ?? 0;
    final rightOffset = right.offsetMinutes ?? 0;
    if (leftOffset != rightOffset) {
      return leftOffset.compareTo(rightOffset);
    }
    return left.createdAt.compareTo(right.createdAt);
  }

  static int? _resolveReminderFireAt(
    TaskReminderRow reminder,
    TaskV2Row task,
  ) {
    final absolute = reminder.triggerAt;
    if (absolute != null) return absolute;
    final offset = reminder.offsetMinutes;
    final anchor = task.dueAt ?? task.startAt;
    if (offset == null || anchor == null) return null;
    return anchor + offset * 60 * 1000;
  }

  static int _scheduleComparator(
    TaskReminderSchedule left,
    TaskReminderSchedule right,
  ) {
    final time = left.fireAt.compareTo(right.fireAt);
    if (time != 0) return time;
    final reminderCreated =
        left.reminder.createdAt.compareTo(right.reminder.createdAt);
    if (reminderCreated != 0) return reminderCreated;
    return left.reminder.id.compareTo(right.reminder.id);
  }

  static void _validateReminderTrigger(TaskReminder reminder) {
    if ((reminder.triggerAt == null) == (reminder.offsetMinutes == null)) {
      throw StateError('提醒必须且只能使用一种触发方式。');
    }
  }

  static TaskList _fromListRow(TaskListRow row) => TaskList(
        id: row.id,
        name: row.name,
        color: row.color,
        iconKey: row.iconKey,
        sortOrder: row.sortOrder,
        archived: row.archived,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
        deletedAt: row.deletedAt,
        deviceId: row.deviceId,
        version: row.version,
      );

  static TaskTag _fromTagRow(TaskTagRow row) => TaskTag(
        id: row.id,
        name: row.name,
        color: row.color,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
        deletedAt: row.deletedAt,
        deviceId: row.deviceId,
        version: row.version,
      );

  static SmartFilter _fromFilterRow(SmartFilterRow row) => SmartFilter(
        id: row.id,
        name: row.name,
        rules: TaskFilterRules.fromJson(
          (jsonDecode(row.rulesJson) as Map).cast<String, Object?>(),
        ),
        sortMode: TaskSortMode.values.byName(row.sortMode),
        sortOrder: row.sortOrder,
        pinned: row.pinned,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
        deletedAt: row.deletedAt,
        deviceId: row.deviceId,
        version: row.version,
      );
}
