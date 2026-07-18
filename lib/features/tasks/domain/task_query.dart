import 'smart_filter.dart';
import 'task_sort_mode.dart';

export 'smart_filter.dart' show TaskDateRange, TaskFilterRules;
export 'task_sort_mode.dart' show TaskSortMode;

sealed class TaskQuery {
  const TaskQuery({this.sortMode = TaskSortMode.manual});

  final TaskSortMode sortMode;

  factory TaskQuery.inbox({TaskSortMode sortMode = TaskSortMode.manual}) =>
      InboxTaskQuery(sortMode: sortMode);

  factory TaskQuery.today({
    required int dayStart,
    required int nextDayStart,
    TaskSortMode sortMode = TaskSortMode.manual,
  }) =>
      TodayTaskQuery(
        dayStart: dayStart,
        nextDayStart: nextDayStart,
        sortMode: sortMode,
      );

  factory TaskQuery.nextSevenDays({
    required int dayStart,
    required int eighthDayStart,
    TaskSortMode sortMode = TaskSortMode.manual,
  }) =>
      NextSevenDaysTaskQuery(
        dayStart: dayStart,
        eighthDayStart: eighthDayStart,
        sortMode: sortMode,
      );

  factory TaskQuery.all({
    bool includeCompleted = false,
    TaskSortMode sortMode = TaskSortMode.manual,
  }) =>
      AllTaskQuery(
        includeCompleted: includeCompleted,
        sortMode: sortMode,
      );

  factory TaskQuery.list(
    String listId, {
    TaskSortMode sortMode = TaskSortMode.manual,
  }) =>
      ListTaskQuery(listId, sortMode: sortMode);

  factory TaskQuery.filter(
    TaskFilterRules rules, {
    required TaskSortMode sortMode,
  }) =>
      FilteredTaskQuery(rules, sortMode: sortMode);
}

final class InboxTaskQuery extends TaskQuery {
  const InboxTaskQuery({super.sortMode});
}

final class TodayTaskQuery extends TaskQuery {
  const TodayTaskQuery({
    required this.dayStart,
    required this.nextDayStart,
    super.sortMode,
  });

  final int dayStart;
  final int nextDayStart;
}

final class NextSevenDaysTaskQuery extends TaskQuery {
  const NextSevenDaysTaskQuery({
    required this.dayStart,
    required this.eighthDayStart,
    super.sortMode,
  });

  final int dayStart;
  final int eighthDayStart;
}

final class AllTaskQuery extends TaskQuery {
  const AllTaskQuery({this.includeCompleted = false, super.sortMode});

  final bool includeCompleted;
}

final class ListTaskQuery extends TaskQuery {
  const ListTaskQuery(this.listId, {super.sortMode});

  final String listId;
}

final class FilteredTaskQuery extends TaskQuery {
  const FilteredTaskQuery(this.rules, {required super.sortMode});

  final TaskFilterRules rules;
}
