import 'task.dart';

enum TaskRecurrenceFrequency { daily, workdays, weekly, monthly, yearly }

class TaskRecurrenceRule {
  const TaskRecurrenceRule({
    required this.frequency,
    this.interval = 1,
    this.weekdays = const {},
  });

  final TaskRecurrenceFrequency frequency;
  final int interval;
  final Set<int> weekdays;

  factory TaskRecurrenceRule.parse(String value) {
    final fields = <String, String>{};
    for (final part in value.split(';')) {
      final trimmed = part.trim();
      if (trimmed.isEmpty) continue;
      final separator = trimmed.indexOf('=');
      if (separator <= 0 || separator == trimmed.length - 1) {
        throw FormatException('重复规则字段无效：$part');
      }
      fields[trimmed.substring(0, separator).trim().toUpperCase()] =
          trimmed.substring(separator + 1).trim().toUpperCase();
    }

    final frequency = switch (fields['FREQ']) {
      'DAILY' => TaskRecurrenceFrequency.daily,
      'WORKDAYS' => TaskRecurrenceFrequency.workdays,
      'WEEKLY' => TaskRecurrenceFrequency.weekly,
      'MONTHLY' => TaskRecurrenceFrequency.monthly,
      'YEARLY' => TaskRecurrenceFrequency.yearly,
      _ => throw const FormatException('不支持的重复频率。'),
    };
    final interval = int.tryParse(fields['INTERVAL'] ?? '1');
    if (interval == null || interval < 1) {
      throw const FormatException('重复间隔必须是正数。');
    }
    final weekdays = fields.containsKey('BYDAY')
        ? fields['BYDAY']!
            .split(',')
            .map((day) => _parseWeekday(day.trim()))
            .toSet()
        : const <int>{};
    if (weekdays.isNotEmpty && frequency != TaskRecurrenceFrequency.weekly) {
      throw const FormatException(
        'BYDAY 仅支持每周重复。',
      );
    }

    return TaskRecurrenceRule(
      frequency: frequency,
      interval: interval,
      weekdays: weekdays,
    );
  }

  int nextScheduledAt(int scheduledAt) {
    final date = DateTime.fromMillisecondsSinceEpoch(scheduledAt);
    final next = switch (frequency) {
      TaskRecurrenceFrequency.daily => date.add(Duration(days: interval)),
      TaskRecurrenceFrequency.workdays => _addWorkdays(date, interval),
      TaskRecurrenceFrequency.weekly => _nextWeekly(date),
      TaskRecurrenceFrequency.monthly => _addMonths(date, interval),
      TaskRecurrenceFrequency.yearly => _addYears(date, interval),
    };
    return next.millisecondsSinceEpoch;
  }

  DateTime _nextWeekly(DateTime date) {
    if (weekdays.isEmpty) {
      return date.add(Duration(days: 7 * interval));
    }
    final ordered = weekdays.toList()..sort();
    for (final weekday in ordered) {
      if (weekday > date.weekday) {
        return date.add(Duration(days: weekday - date.weekday));
      }
    }
    final weekStart = DateTime(
      date.year,
      date.month,
      date.day,
      date.hour,
      date.minute,
      date.second,
      date.millisecond,
      date.microsecond,
    ).subtract(Duration(days: date.weekday - DateTime.monday));
    return weekStart
        .add(Duration(days: 7 * interval + ordered.first - DateTime.monday));
  }
}

class TaskRecurrenceAdvance {
  const TaskRecurrenceAdvance({
    required this.scheduledAt,
    required this.nextTask,
    required this.shouldContinue,
  });

  final int scheduledAt;
  final Task nextTask;
  final bool shouldContinue;
}

TaskRecurrenceAdvance? advanceRecurringTask({
  required Task task,
  required int completedAt,
  required int completionCountAfterThis,
}) {
  final ruleText = task.recurrenceRule;
  if (ruleText == null || ruleText.trim().isEmpty) return null;

  final scheduledAt = task.dueAt ?? task.startAt;
  if (scheduledAt == null) {
    throw const FormatException('重复任务需要开始时间或截止时间。');
  }

  final rule = TaskRecurrenceRule.parse(ruleText);
  final nextScheduledAt = rule.nextScheduledAt(scheduledAt);
  final reachedEndDate =
      task.recurrenceEndAt != null && nextScheduledAt > task.recurrenceEndAt!;
  final reachedCount = task.recurrenceCount != null &&
      completionCountAfterThis >= task.recurrenceCount!;
  if (reachedEndDate || reachedCount) {
    return TaskRecurrenceAdvance(
      scheduledAt: scheduledAt,
      nextTask: task.copyWith(
        completed: true,
        completedAt: completedAt,
        updatedAt: completedAt,
        version: task.version + 1,
      ),
      shouldContinue: false,
    );
  }

  final delta = nextScheduledAt - scheduledAt;
  return TaskRecurrenceAdvance(
    scheduledAt: scheduledAt,
    nextTask: task.copyWith(
      completed: false,
      clearCompletedAt: true,
      startAt: task.startAt == null ? null : task.startAt! + delta,
      dueAt: task.dueAt == null ? null : task.dueAt! + delta,
      updatedAt: completedAt,
      version: task.version + 1,
    ),
    shouldContinue: true,
  );
}

int _parseWeekday(String value) {
  return switch (value) {
    'MO' => DateTime.monday,
    'TU' => DateTime.tuesday,
    'WE' => DateTime.wednesday,
    'TH' => DateTime.thursday,
    'FR' => DateTime.friday,
    'SA' => DateTime.saturday,
    'SU' => DateTime.sunday,
    _ => throw FormatException('重复规则星期无效：$value'),
  };
}

DateTime _addWorkdays(DateTime date, int count) {
  var result = date;
  var remaining = count;
  while (remaining > 0) {
    result = result.add(const Duration(days: 1));
    if (result.weekday <= DateTime.friday) remaining--;
  }
  return result;
}

DateTime _addMonths(DateTime date, int count) {
  final targetMonth = date.month + count;
  final year = date.year + (targetMonth - 1) ~/ 12;
  final month = (targetMonth - 1) % 12 + 1;
  final day = date.day.clamp(1, _daysInMonth(year, month));
  return DateTime(
    year,
    month,
    day,
    date.hour,
    date.minute,
    date.second,
    date.millisecond,
    date.microsecond,
  );
}

DateTime _addYears(DateTime date, int count) {
  final year = date.year + count;
  final day = date.day.clamp(1, _daysInMonth(year, date.month));
  return DateTime(
    year,
    date.month,
    day,
    date.hour,
    date.minute,
    date.second,
    date.millisecond,
    date.microsecond,
  );
}

int _daysInMonth(int year, int month) {
  return DateTime(year, month + 1, 0).day;
}
