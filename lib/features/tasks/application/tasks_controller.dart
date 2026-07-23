import 'dart:async';

import 'package:cross_file/cross_file.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/feedback/app_haptics.dart';
import '../../../core/utils/id_generator.dart';
import '../../../core/utils/time.dart';
import '../../../shared/models/markdown_edit.dart';
import '../../appearance/application/appearance_controller.dart';
import '../../appearance/domain/appearance_presets.dart';
import '../../appearance/domain/rgb_color.dart';
import '../../attachments/application/attachment_import_service.dart';
import '../../attachments/domain/content_attachment.dart';
import '../../attachments/infrastructure/attachment_picker.dart';
import '../../notifications/application/task_reminder_scheduler.dart';
import '../../sync/data/sync_repository.dart';
import '../data/tasks_repository.dart';
import '../domain/smart_filter.dart';
import '../domain/task.dart';
import '../domain/task_list.dart';
import '../domain/task_query.dart';
import '../domain/task_reminder.dart';
import '../domain/task_tag.dart';

final tasksControllerProvider =
    AsyncNotifierProvider<TasksController, TasksState>(TasksController.new);

enum TaskSaveStatus { idle, saving, saved, failed }

enum BuiltInTaskSource { inbox, today, nextSevenDays, all }

class TaskSource {
  const TaskSource({required this.key, required this.label});

  final BuiltInTaskSource key;
  final String label;
}

class TasksState {
  TasksState({
    required Iterable<TaskSource> sources,
    required Iterable<Task> tasks,
    required Iterable<TaskList> lists,
    required Iterable<TaskTag> tags,
    required Iterable<SmartFilter> filters,
    required Map<String, Set<String>> tagIdsByTaskId,
    required this.query,
    required this.searchText,
    required Iterable<Task> subtasks,
    required Iterable<TaskReminder> selectedTaskReminders,
    this.selectedTaskId,
    this.saveStatus = TaskSaveStatus.idle,
    this.errorMessage,
  })  : sources = List.unmodifiable(sources),
        tasks = List.unmodifiable(tasks),
        lists = List.unmodifiable(lists),
        tags = List.unmodifiable(tags),
        filters = List.unmodifiable(filters),
        tagIdsByTaskId = Map.unmodifiable({
          for (final entry in tagIdsByTaskId.entries)
            entry.key: Set.unmodifiable(entry.value),
        }),
        subtasks = List.unmodifiable(subtasks),
        selectedTaskReminders = List.unmodifiable(selectedTaskReminders);

  final List<TaskSource> sources;
  final List<Task> tasks;
  final List<TaskList> lists;
  final List<TaskTag> tags;
  final List<SmartFilter> filters;
  final Map<String, Set<String>> tagIdsByTaskId;
  final TaskQuery query;
  final String searchText;
  final List<Task> subtasks;
  final List<TaskReminder> selectedTaskReminders;
  final String? selectedTaskId;
  final TaskSaveStatus saveStatus;
  final String? errorMessage;

  List<Task> get visibleTasks => tasks;
  List<Task> get searchResults => searchText.trim().isEmpty ? const [] : tasks;

  Task? get selectedTask {
    for (final task in tasks) {
      if (task.id == selectedTaskId) return task;
    }
    return null;
  }

  Set<String> tagIdsFor(String taskId) =>
      tagIdsByTaskId[taskId] ?? const <String>{};

  TasksState copyWith({
    Iterable<TaskSource>? sources,
    Iterable<Task>? tasks,
    Iterable<TaskList>? lists,
    Iterable<TaskTag>? tags,
    Iterable<SmartFilter>? filters,
    Map<String, Set<String>>? tagIdsByTaskId,
    TaskQuery? query,
    String? searchText,
    Iterable<Task>? subtasks,
    Iterable<TaskReminder>? selectedTaskReminders,
    String? selectedTaskId,
    bool clearSelectedTaskId = false,
    TaskSaveStatus? saveStatus,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return TasksState(
      sources: sources ?? this.sources,
      tasks: tasks ?? this.tasks,
      lists: lists ?? this.lists,
      tags: tags ?? this.tags,
      filters: filters ?? this.filters,
      tagIdsByTaskId: tagIdsByTaskId ?? this.tagIdsByTaskId,
      query: query ?? this.query,
      searchText: searchText ?? this.searchText,
      subtasks: subtasks ?? this.subtasks,
      selectedTaskReminders:
          selectedTaskReminders ?? this.selectedTaskReminders,
      selectedTaskId:
          clearSelectedTaskId ? null : selectedTaskId ?? this.selectedTaskId,
      saveStatus: saveStatus ?? this.saveStatus,
      errorMessage:
          clearErrorMessage ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class TasksController extends AsyncNotifier<TasksState> {
  static const sources = [
    TaskSource(key: BuiltInTaskSource.inbox, label: '收集箱'),
    TaskSource(key: BuiltInTaskSource.today, label: '今天'),
    TaskSource(key: BuiltInTaskSource.nextSevenDays, label: '未来 7 天'),
    TaskSource(key: BuiltInTaskSource.all, label: '全部任务'),
  ];

  late TasksRepository _repository;
  late TaskReminderScheduler _reminderScheduler;
  late String _deviceId;
  late String _platform;
  Timer? _searchDebounce;
  Completer<void>? _searchCompleter;
  TaskQuery? _lastSourceQuery;
  int _searchRevision = 0;

  @override
  Future<TasksState> build() async {
    _repository = ref.watch(tasksRepositoryProvider);
    _reminderScheduler = ref.watch(taskReminderSchedulerProvider);
    final device = ref.watch(deviceInfoProvider);
    _deviceId = device.deviceId;
    _platform = device.platform;
    ref.onDispose(() {
      _searchDebounce?.cancel();
      if (!(_searchCompleter?.isCompleted ?? true)) {
        _searchCompleter!.complete();
      }
    });
    final query = _defaultTodayQuery();
    _lastSourceQuery = query;
    return _load(query: query);
  }

  Future<TasksState> _load({
    required TaskQuery query,
    String searchText = '',
    String? selectedTaskId,
    TaskSaveStatus saveStatus = TaskSaveStatus.idle,
    String? errorMessage,
  }) async {
    final normalizedSearch = searchText.trim();
    final tasks = normalizedSearch.isEmpty
        ? await _repository.queryTasks(query)
        : await _repository.searchTasks(
            normalizedSearch,
            sortMode: query.sortMode,
            includeCompleted: _includesCompleted(query),
          );
    final lists = await _repository.listTaskLists();
    final tags = await _repository.listTaskTags();
    final filters = await _repository.listSmartFilters();
    final tagIds = await _repository.taskTagIds(tasks.map((task) => task.id));
    final selection =
        selectedTaskId != null && tasks.any((task) => task.id == selectedTaskId)
            ? selectedTaskId
            : null;
    final subtasks = selection == null
        ? const <Task>[]
        : await _repository.listSubtasks(selection);
    final reminders = selection == null
        ? const <TaskReminder>[]
        : await _repository.listTaskReminders(selection);
    return TasksState(
      sources: sources,
      tasks: tasks,
      lists: lists,
      tags: tags,
      filters: filters,
      tagIdsByTaskId: tagIds,
      query: query,
      searchText: searchText,
      subtasks: subtasks,
      selectedTaskReminders: reminders,
      selectedTaskId: selection,
      saveStatus: saveStatus,
      errorMessage: errorMessage,
    );
  }

  Future<void> quickAdd(String title) async {
    final normalized = title.trim();
    if (normalized.isEmpty) return;
    final current = state.valueOrNull;
    if (current == null) return;
    final now = Clock.nowMillis();
    final listId = switch (current.query) {
      ListTaskQuery(:final listId) => listId,
      _ => null,
    };
    final task = Task(
      id: IdGenerator.create(),
      title: normalized,
      listId: listId,
      createdAt: now,
      updatedAt: now,
      deviceId: _deviceId,
    );
    await _write(
      () => _repository.upsertTask(task),
      selectedTaskId: task.id,
      queryOverride: _queryThatContainsNewTask(current.query),
    );
  }

  Future<void> updateTask(
    String id, {
    String? title,
    String? descriptionMarkdown,
    bool? completed,
    TaskPriority? priority,
    int? startAt,
    int? dueAt,
    bool? allDay,
    String? recurrenceRule,
    int? recurrenceEndAt,
    int? recurrenceCount,
    String? listId,
    bool clearStartAt = false,
    bool clearDueAt = false,
    bool clearRecurrenceRule = false,
    bool clearRecurrenceEndAt = false,
    bool clearRecurrenceCount = false,
    bool clearListId = false,
  }) async {
    final current = state.valueOrNull;
    final task = current == null ? null : _taskById(current, id);
    if (current == null || task == null) return;
    final normalizedTitle = title?.trim();
    final updated = task.copyWith(
      title: normalizedTitle == null || normalizedTitle.isEmpty
          ? null
          : normalizedTitle,
      descriptionMarkdown: descriptionMarkdown,
      completed: completed,
      completedAt: completed == true ? Clock.nowMillis() : null,
      clearCompletedAt: completed == false,
      priority: priority,
      startAt: startAt,
      dueAt: dueAt,
      allDay: allDay,
      recurrenceRule: recurrenceRule,
      recurrenceEndAt: recurrenceEndAt,
      recurrenceCount: recurrenceCount,
      clearStartAt: clearStartAt,
      clearDueAt: clearDueAt,
      clearRecurrenceRule: clearRecurrenceRule,
      clearRecurrenceEndAt: clearRecurrenceEndAt,
      clearRecurrenceCount: clearRecurrenceCount,
      listId: listId,
      clearListId: clearListId,
      updatedAt: Clock.nowMillis(),
      version: task.version + 1,
    );
    final queryOverride = switch (current.query) {
      InboxTaskQuery() when listId != null =>
        TaskQuery.list(listId, sortMode: current.query.sortMode),
      ListTaskQuery() when clearListId =>
        TaskQuery.inbox(sortMode: current.query.sortMode),
      _ => null,
    };
    await _write(
      () => _repository.upsertTask(updated),
      selectedTaskId: id,
      queryOverride: queryOverride,
      reconcileReminders: true,
    );
  }

  Future<void> toggleTask(String id) async {
    final current = state.valueOrNull;
    final task = current == null ? null : _taskById(current, id);
    if (task == null) return;
    final now = Clock.nowMillis();
    await _write(
      task.completed
          ? () => _repository.uncompleteTask(id, now)
          : () => _repository.completeTaskOccurrence(
                id,
                completedAt: now,
                completionId: IdGenerator.create(),
              ),
      selectedTaskId: id,
      reconcileReminders: true,
    );
    if (state.valueOrNull?.saveStatus == TaskSaveStatus.saved) {
      _triggerFeedback(HapticEvent.complete);
    }
  }

  Future<void> deleteTask(String id) async {
    await _write(
      () => _repository.softDeleteTask(id, Clock.nowMillis()),
      clearSelection: true,
      reconcileReminders: true,
    );
    if (state.valueOrNull?.saveStatus == TaskSaveStatus.saved) {
      _triggerFeedback(HapticEvent.delete);
    }
  }

  Future<void> createAbsoluteTaskReminder(
    String taskId, {
    required int triggerAt,
  }) async {
    final current = state.valueOrNull;
    final task = current == null ? null : _taskById(current, taskId);
    if (task == null) return;
    final now = Clock.nowMillis();
    await _write(
      () => _repository.upsertTaskReminder(TaskReminder(
        id: IdGenerator.create(),
        taskId: taskId,
        triggerAt: triggerAt,
        createdAt: now,
        updatedAt: now,
        deviceId: _deviceId,
      )),
      selectedTaskId: taskId,
      reconcileReminders: true,
    );
  }

  Future<void> createRelativeTaskReminder(
    String taskId, {
    required int offsetMinutes,
  }) async {
    final current = state.valueOrNull;
    final task = current == null ? null : _taskById(current, taskId);
    if (task == null) return;
    final now = Clock.nowMillis();
    await _write(
      () => _repository.upsertTaskReminder(TaskReminder(
        id: IdGenerator.create(),
        taskId: taskId,
        offsetMinutes: offsetMinutes,
        createdAt: now,
        updatedAt: now,
        deviceId: _deviceId,
      )),
      selectedTaskId: taskId,
      reconcileReminders: true,
    );
  }

  Future<void> deleteTaskReminder(String id) async {
    final current = state.valueOrNull;
    if (current == null) return;
    final reminder = current.selectedTaskReminders
        .where((reminder) => reminder.id == id)
        .firstOrNull;
    if (reminder == null) return;
    await _write(
      () => _repository.softDeleteTaskReminder(id, Clock.nowMillis()),
      selectedTaskId: reminder.taskId,
      reconcileReminders: true,
    );
  }

  Future<MarkdownEditResult?> insertImage(
    AttachmentPickSource source,
    MarkdownSelection selection, {
    required String altText,
  }) async {
    final current = state.valueOrNull;
    final task = current?.selectedTask;
    if (current == null || task == null) return null;
    final picked = await ref.read(attachmentPickerProvider).pick(source);
    if (picked == null) return null;
    return _attachImage(
      picked,
      selection,
      altText: altText,
    );
  }

  Future<void> importRecoveredImages(List<XFile> files) async {
    for (final file in files) {
      final task = state.valueOrNull?.selectedTask;
      if (task == null) return;
      final result = await _attachImage(
        file,
        MarkdownSelection(
          baseOffset: task.descriptionMarkdown.length,
          extentOffset: task.descriptionMarkdown.length,
        ),
        altText: _recoveredImageAlt(file),
      );
      if (result == null) return;
    }
  }

  Future<MarkdownEditResult?> _attachImage(
    XFile picked,
    MarkdownSelection selection, {
    required String altText,
  }) async {
    final current = state.valueOrNull;
    final task = current?.selectedTask;
    if (current == null || task == null) return null;
    state = AsyncData(current.copyWith(
      saveStatus: TaskSaveStatus.saving,
      clearErrorMessage: true,
    ));
    try {
      final service = await ref.read(attachmentImportServiceProvider.future);
      final result = await service.importAndAttach(
        owner: AttachmentOwner(AttachmentOwnerType.task, task.id),
        input: XFileAttachmentInput(picked),
        currentMarkdown: task.descriptionMarkdown,
        selection: selection,
        altText: altText,
      );
      state = AsyncData(await _load(
        query: current.query,
        searchText: current.searchText,
        selectedTaskId: task.id,
        saveStatus: TaskSaveStatus.saved,
      ));
      return result.edit;
    } catch (error) {
      state = AsyncData(current.copyWith(
        saveStatus: TaskSaveStatus.failed,
        errorMessage: error.toString(),
      ));
      return null;
    }
  }

  Future<void> deleteImage(String attachmentId) async {
    final current = state.valueOrNull;
    final task = current?.selectedTask;
    if (current == null || task == null) return;
    state = AsyncData(current.copyWith(
      saveStatus: TaskSaveStatus.saving,
      clearErrorMessage: true,
    ));
    try {
      final service = await ref.read(attachmentImportServiceProvider.future);
      await service.deleteAndDetach(
        owner: AttachmentOwner(AttachmentOwnerType.task, task.id),
        attachmentId: attachmentId,
        currentMarkdown: task.descriptionMarkdown,
        selection: MarkdownSelection(
          baseOffset: task.descriptionMarkdown.length,
          extentOffset: task.descriptionMarkdown.length,
        ),
      );
      state = AsyncData(await _load(
        query: current.query,
        searchText: current.searchText,
        selectedTaskId: task.id,
        saveStatus: TaskSaveStatus.saved,
      ));
    } catch (error) {
      state = AsyncData(current.copyWith(
        saveStatus: TaskSaveStatus.failed,
        errorMessage: error.toString(),
      ));
    }
  }

  Future<ContentAttachment?> resolveAttachment(String id) async {
    final service = await ref.read(attachmentImportServiceProvider.future);
    return service.resolveAttachment(id);
  }

  Future<void> addSubtask(String parentId, String title) async {
    final normalized = title.trim();
    if (normalized.isEmpty) return;
    final current = state.valueOrNull;
    final parent = current == null ? null : _taskById(current, parentId);
    if (parent == null) return;
    final now = Clock.nowMillis();
    await _write(
      () => _repository.upsertTask(Task(
        id: IdGenerator.create(),
        parentId: parentId,
        listId: parent.listId,
        title: normalized,
        createdAt: now,
        updatedAt: now,
        deviceId: _deviceId,
      )),
      selectedTaskId: parentId,
    );
  }

  Future<void> createList(
    String name, {
    required RgbColor color,
    required String iconKey,
  }) async {
    final normalized = name.trim();
    if (normalized.isEmpty) return;
    final now = Clock.nowMillis();
    await _write(() => _repository.upsertTaskList(TaskList(
          id: IdGenerator.create(),
          name: normalized,
          color: color.value,
          iconKey: iconKey,
          createdAt: now,
          updatedAt: now,
          deviceId: _deviceId,
        )));
  }

  Future<void> renameList(String id, String name) async {
    final current = state.valueOrNull;
    final list = current == null ? null : _findById(current.lists, id);
    final normalized = name.trim();
    if (list == null || normalized.isEmpty) return;
    await _write(() => _repository.upsertTaskList(list.copyWith(
          name: normalized,
          updatedAt: Clock.nowMillis(),
          version: list.version + 1,
        )));
  }

  Future<void> updateListStyle(
    String id, {
    required RgbColor color,
    required String iconKey,
  }) async {
    final current = state.valueOrNull;
    final list = current == null ? null : _findById(current.lists, id);
    if (list == null) return;
    await _write(() => _repository.upsertTaskList(list.copyWith(
          color: color.value,
          iconKey: iconKey,
          updatedAt: Clock.nowMillis(),
          version: list.version + 1,
        )));
  }

  Future<void> archiveList(String id) async {
    final current = state.valueOrNull;
    final list = current == null ? null : _findById(current.lists, id);
    if (list == null) return;
    await _write(() => _repository.upsertTaskList(list.copyWith(
          archived: true,
          updatedAt: Clock.nowMillis(),
          version: list.version + 1,
        )));
  }

  Future<void> deleteList(String id) async {
    final current = state.valueOrNull;
    if (current == null) return;
    final wasSelectedList = current.query is ListTaskQuery &&
        (current.query as ListTaskQuery).listId == id;
    await _write(
      () => _repository.deleteTaskListAndMoveTasksToInbox(
        id,
        Clock.nowMillis(),
      ),
      queryOverride: wasSelectedList ? TaskQuery.inbox() : null,
      clearSelection: wasSelectedList,
    );
  }

  Future<void> createTag(
    String name, {
    required RgbColor color,
  }) async {
    final normalized = name.trim();
    if (normalized.isEmpty) return;
    final now = Clock.nowMillis();
    await _write(() => _repository.upsertTaskTag(TaskTag(
          id: IdGenerator.create(),
          name: normalized,
          color: color.value,
          createdAt: now,
          updatedAt: now,
          deviceId: _deviceId,
        )));
  }

  Future<void> updateTag(
    String id, {
    required String name,
    required RgbColor color,
  }) async {
    final current = state.valueOrNull;
    final tag = current == null ? null : _findById(current.tags, id);
    final normalized = name.trim();
    if (tag == null || normalized.isEmpty) return;
    await _write(() => _repository.upsertTaskTag(tag.copyWith(
          name: normalized,
          color: color.value,
          updatedAt: Clock.nowMillis(),
          version: tag.version + 1,
        )));
  }

  Future<void> deleteTag(String id) {
    return _write(() => _repository.softDeleteTaskTag(id, Clock.nowMillis()));
  }

  Future<void> setTaskTags(String taskId, Set<String> tagIds) {
    return _write(
      () => _repository.replaceTaskTags(taskId, tagIds),
      selectedTaskId: taskId,
    );
  }

  Future<void> saveSmartFilter({
    required String name,
    required TaskFilterRules rules,
    required TaskSortMode sortMode,
  }) async {
    final normalized = name.trim();
    if (normalized.isEmpty) return;
    final now = Clock.nowMillis();
    await _write(() => _repository.upsertSmartFilter(SmartFilter(
          id: IdGenerator.create(),
          name: normalized,
          rules: rules,
          sortMode: sortMode,
          createdAt: now,
          updatedAt: now,
          deviceId: _deviceId,
        )));
  }

  Future<void> selectQuery(TaskQuery query) async {
    final current = state.valueOrNull;
    if (current == null) return;
    _lastSourceQuery = query;
    state = AsyncData(await _load(
      query: query,
      selectedTaskId: current.selectedTaskId,
      saveStatus: current.saveStatus,
    ));
  }

  Future<void> setSortMode(TaskSortMode value) async {
    final current = state.valueOrNull;
    if (current == null) return;
    final query = _withSortMode(current.query, value);
    _lastSourceQuery = query;
    state = AsyncData(await _load(
      query: query,
      searchText: current.searchText,
      selectedTaskId: current.selectedTaskId,
      saveStatus: current.saveStatus,
    ));
  }

  Future<void> setIncludeCompleted(bool value) async {
    final current = state.valueOrNull;
    if (current == null) return;
    final query = TaskQuery.all(
      includeCompleted: value,
      sortMode: current.query.sortMode,
    );
    await selectQuery(query);
  }

  Future<void> setSearchText(String value) async {
    final current = state.valueOrNull;
    if (current == null) return;
    _searchDebounce?.cancel();
    if (!(_searchCompleter?.isCompleted ?? true)) {
      _searchCompleter!.complete();
    }
    final revision = ++_searchRevision;
    state = AsyncData(current.copyWith(searchText: value));
    final completer = Completer<void>();
    _searchCompleter = completer;
    _searchDebounce = Timer(const Duration(milliseconds: 250), () async {
      try {
        if (revision != _searchRevision) return;
        final latest = state.valueOrNull;
        if (latest == null) return;
        final query = value.trim().isEmpty
            ? _lastSourceQuery ?? latest.query
            : latest.query;
        state = AsyncData(await _load(
          query: query,
          searchText: value,
          selectedTaskId: latest.selectedTaskId,
          saveStatus: latest.saveStatus,
        ));
      } finally {
        if (!completer.isCompleted) completer.complete();
        if (identical(_searchCompleter, completer)) {
          _searchCompleter = null;
        }
      }
    });
    await completer.future;
  }

  void selectTask(String id) {
    final current = state.valueOrNull;
    if (current == null || !current.tasks.any((task) => task.id == id)) return;
    unawaited(_selectTask(current, id));
  }

  Future<void> _selectTask(TasksState current, String id) async {
    final subtasks = await _repository.listSubtasks(id);
    final reminders = await _repository.listTaskReminders(id);
    if (state.valueOrNull != current) return;
    state = AsyncData(current.copyWith(
      selectedTaskId: id,
      subtasks: subtasks,
      selectedTaskReminders: reminders,
    ));
  }

  void clearSelection() {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(current.copyWith(
      clearSelectedTaskId: true,
      subtasks: const [],
      selectedTaskReminders: const [],
    ));
  }

  Future<void> _write(
    Future<void> Function() operation, {
    String? selectedTaskId,
    bool clearSelection = false,
    TaskQuery? queryOverride,
    bool reconcileReminders = false,
  }) async {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(current.copyWith(
      saveStatus: TaskSaveStatus.saving,
      clearErrorMessage: true,
    ));
    try {
      await operation();
      if (reconcileReminders) {
        await _reconcileReminders();
      }
      final query = queryOverride ?? current.query;
      if (queryOverride != null) _lastSourceQuery = queryOverride;
      state = AsyncData(await _load(
        query: query,
        searchText: current.searchText,
        selectedTaskId:
            clearSelection ? null : selectedTaskId ?? current.selectedTaskId,
        saveStatus: TaskSaveStatus.saved,
      ));
    } catch (error) {
      state = AsyncData(current.copyWith(
        saveStatus: TaskSaveStatus.failed,
        errorMessage: error.toString(),
      ));
    }
  }

  Future<void> _reconcileReminders() {
    final now = Clock.nowMillis();
    return _reminderScheduler.reconcile(
      now: now,
      before: now + const Duration(days: 30).inMilliseconds,
    );
  }

  TaskQuery _defaultTodayQuery() {
    final now = DateTime.now();
    final dayStart = DateTime(now.year, now.month, now.day);
    return TaskQuery.today(
      dayStart: dayStart.millisecondsSinceEpoch,
      nextDayStart:
          dayStart.add(const Duration(days: 1)).millisecondsSinceEpoch,
    );
  }

  TaskQuery _queryThatContainsNewTask(TaskQuery current) {
    return switch (current) {
      ListTaskQuery() => current,
      InboxTaskQuery() => current,
      _ => TaskQuery.inbox(sortMode: current.sortMode),
    };
  }

  TaskQuery _withSortMode(TaskQuery query, TaskSortMode sortMode) {
    return switch (query) {
      InboxTaskQuery() => TaskQuery.inbox(sortMode: sortMode),
      TodayTaskQuery(:final dayStart, :final nextDayStart) => TaskQuery.today(
          dayStart: dayStart,
          nextDayStart: nextDayStart,
          sortMode: sortMode,
        ),
      NextSevenDaysTaskQuery(:final dayStart, :final eighthDayStart) =>
        TaskQuery.nextSevenDays(
          dayStart: dayStart,
          eighthDayStart: eighthDayStart,
          sortMode: sortMode,
        ),
      AllTaskQuery(:final includeCompleted) => TaskQuery.all(
          includeCompleted: includeCompleted,
          sortMode: sortMode,
        ),
      ListTaskQuery(:final listId) =>
        TaskQuery.list(listId, sortMode: sortMode),
      FilteredTaskQuery(:final rules) =>
        TaskQuery.filter(rules, sortMode: sortMode),
    };
  }

  bool _includesCompleted(TaskQuery query) =>
      query is AllTaskQuery && query.includeCompleted;

  void _triggerFeedback(HapticEvent event) {
    final mode = ref
            .read(appearanceControllerProvider)
            .valueOrNull
            ?.deviceProfile
            .hapticsMode ??
        HapticsMode.off;
    unawaited(AppHaptics(platform: _platform, mode: mode).trigger(event));
  }

  Task? _taskById(TasksState state, String id) {
    for (final task in [...state.tasks, ...state.subtasks]) {
      if (task.id == id) return task;
    }
    return null;
  }
}

String _recoveredImageAlt(XFile file) {
  final name = file.name.trim();
  return name.isEmpty ? '恢复的图片' : name;
}

T? _findById<T>(Iterable<T> values, String id) {
  for (final value in values) {
    final valueId = switch (value) {
      TaskList(:final id) => id,
      TaskTag(:final id) => id,
      _ => null,
    };
    if (valueId == id) return value;
  }
  return null;
}
