enum CalendarEntrySource { task, note, habit }

enum CalendarEntryKind { taskStart, taskDue, noteCreated, habitPlanned }

class CalendarEntry {
  const CalendarEntry({
    required this.id,
    required this.sourceId,
    required this.source,
    required this.kind,
    required this.title,
    required this.scheduledAt,
    required this.dayStart,
    this.allDay = false,
    this.completed = false,
    this.color,
  });

  final String id;
  final String sourceId;
  final CalendarEntrySource source;
  final CalendarEntryKind kind;
  final String title;
  final int scheduledAt;
  final int dayStart;
  final bool allDay;
  final bool completed;
  final int? color;
}

class CalendarDay {
  const CalendarDay({
    required this.dayStart,
    required this.entries,
  });

  final int dayStart;
  final List<CalendarEntry> entries;

  int get taskCount => entries
      .where((entry) => entry.source == CalendarEntrySource.task)
      .map((entry) => entry.sourceId)
      .toSet()
      .length;

  int get noteCount => entries
      .where((entry) => entry.source == CalendarEntrySource.note)
      .map((entry) => entry.sourceId)
      .toSet()
      .length;

  int get habitCount => entries
      .where((entry) => entry.source == CalendarEntrySource.habit)
      .map((entry) => entry.sourceId)
      .toSet()
      .length;
}
