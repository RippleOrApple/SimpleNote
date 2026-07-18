import 'task.dart';
import 'task_reminder.dart';

class TaskReminderSchedule {
  const TaskReminderSchedule({
    required this.task,
    required this.reminder,
    required this.fireAt,
  });

  final Task task;
  final TaskReminder reminder;
  final int fireAt;
}
