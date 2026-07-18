import 'package:flutter_test/flutter_test.dart';
import 'package:simple_note/features/tasks/domain/task.dart';
import 'package:simple_note/features/tasks/domain/task_recurrence.dart';

void main() {
  test('daily recurrence advances start and due by interval', () {
    final task = _task(
      recurrenceRule: 'FREQ=DAILY;INTERVAL=2',
      startAt: _millis(2026, 7, 18, 9),
      dueAt: _millis(2026, 7, 18, 18),
    );

    final advance = advanceRecurringTask(
      task: task,
      completedAt: _millis(2026, 7, 18, 19),
      completionCountAfterThis: 1,
    )!;

    expect(advance.scheduledAt, _millis(2026, 7, 18, 18));
    expect(advance.nextTask.completed, isFalse);
    expect(advance.nextTask.startAt, _millis(2026, 7, 20, 9));
    expect(advance.nextTask.dueAt, _millis(2026, 7, 20, 18));
  });

  test('workday recurrence skips weekends', () {
    final friday = _task(
      recurrenceRule: 'FREQ=WORKDAYS',
      dueAt: _millis(2026, 7, 17, 18),
    );

    final advance = advanceRecurringTask(
      task: friday,
      completedAt: _millis(2026, 7, 17, 19),
      completionCountAfterThis: 1,
    )!;

    expect(advance.nextTask.dueAt, _millis(2026, 7, 20, 18));
  });

  test('weekly BYDAY recurrence uses the next selected weekday', () {
    final monday = _task(
      recurrenceRule: 'FREQ=WEEKLY;BYDAY=MO,WE;INTERVAL=2',
      dueAt: _millis(2026, 7, 20, 10),
    );
    final wednesday = _task(
      recurrenceRule: 'FREQ=WEEKLY;BYDAY=MO,WE;INTERVAL=2',
      dueAt: _millis(2026, 7, 22, 10),
    );

    expect(
      advanceRecurringTask(
        task: monday,
        completedAt: _millis(2026, 7, 20, 11),
        completionCountAfterThis: 1,
      )!
          .nextTask
          .dueAt,
      _millis(2026, 7, 22, 10),
    );
    expect(
      advanceRecurringTask(
        task: wednesday,
        completedAt: _millis(2026, 7, 22, 11),
        completionCountAfterThis: 1,
      )!
          .nextTask
          .dueAt,
      _millis(2026, 8, 3, 10),
    );
  });

  test('monthly and yearly recurrence clamp invalid days', () {
    final monthly = _task(
      recurrenceRule: 'FREQ=MONTHLY',
      dueAt: _millis(2026, 1, 31, 8),
    );
    final yearly = _task(
      recurrenceRule: 'FREQ=YEARLY',
      dueAt: _millis(2024, 2, 29, 8),
    );

    expect(
      advanceRecurringTask(
        task: monthly,
        completedAt: _millis(2026, 1, 31, 9),
        completionCountAfterThis: 1,
      )!
          .nextTask
          .dueAt,
      _millis(2026, 2, 28, 8),
    );
    expect(
      advanceRecurringTask(
        task: yearly,
        completedAt: _millis(2024, 2, 29, 9),
        completionCountAfterThis: 1,
      )!
          .nextTask
          .dueAt,
      _millis(2025, 2, 28, 8),
    );
  });

  test('end date and count stop recurrence advancement', () {
    final byDate = _task(
      recurrenceRule: 'FREQ=DAILY',
      dueAt: _millis(2026, 7, 18, 8),
      recurrenceEndAt: _millis(2026, 7, 18, 23),
    );
    final byCount = _task(
      recurrenceRule: 'FREQ=DAILY',
      dueAt: _millis(2026, 7, 18, 8),
      recurrenceCount: 2,
    );

    expect(
      advanceRecurringTask(
        task: byDate,
        completedAt: _millis(2026, 7, 18, 9),
        completionCountAfterThis: 1,
      )!
          .shouldContinue,
      isFalse,
    );
    expect(
      advanceRecurringTask(
        task: byCount,
        completedAt: _millis(2026, 7, 18, 9),
        completionCountAfterThis: 2,
      )!
          .shouldContinue,
      isFalse,
    );
  });

  test('invalid recurrence rules fail before producing an advance', () {
    expect(
      () => advanceRecurringTask(
        task: _task(recurrenceRule: 'FREQ=HOURLY', dueAt: 1),
        completedAt: 2,
        completionCountAfterThis: 1,
      ),
      throwsFormatException,
    );
    expect(
      () => advanceRecurringTask(
        task: _task(recurrenceRule: 'FREQ=DAILY'),
        completedAt: 2,
        completionCountAfterThis: 1,
      ),
      throwsFormatException,
    );
  });
}

Task _task({
  required String recurrenceRule,
  int? startAt,
  int? dueAt,
  int? recurrenceEndAt,
  int? recurrenceCount,
}) {
  return Task(
    id: 'task',
    title: 'Task',
    recurrenceRule: recurrenceRule,
    startAt: startAt,
    dueAt: dueAt,
    recurrenceEndAt: recurrenceEndAt,
    recurrenceCount: recurrenceCount,
    createdAt: 1,
    updatedAt: 1,
    deviceId: 'device',
  );
}

int _millis(int year, int month, int day, int hour) {
  return DateTime(year, month, day, hour).millisecondsSinceEpoch;
}
