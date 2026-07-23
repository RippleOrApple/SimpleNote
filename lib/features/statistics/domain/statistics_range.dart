enum StatisticsRangeKind { week, month, year }

class StatisticsRange {
  const StatisticsRange({
    required this.kind,
    required this.anchorDay,
    required this.from,
    required this.before,
  });

  factory StatisticsRange.week({required int anchorDay}) {
    final day = _dayStart(anchorDay);
    final date = DateTime.fromMillisecondsSinceEpoch(day);
    final from = DateTime(date.year, date.month, date.day)
        .subtract(Duration(days: date.weekday - DateTime.monday))
        .millisecondsSinceEpoch;
    return StatisticsRange(
      kind: StatisticsRangeKind.week,
      anchorDay: day,
      from: from,
      before: from + const Duration(days: 7).inMilliseconds,
    );
  }

  factory StatisticsRange.month({required int anchorDay}) {
    final day = _dayStart(anchorDay);
    final date = DateTime.fromMillisecondsSinceEpoch(day);
    final from = DateTime(date.year, date.month).millisecondsSinceEpoch;
    final before = DateTime(date.year, date.month + 1).millisecondsSinceEpoch;
    return StatisticsRange(
      kind: StatisticsRangeKind.month,
      anchorDay: day,
      from: from,
      before: before,
    );
  }

  factory StatisticsRange.year({required int anchorDay}) {
    final day = _dayStart(anchorDay);
    final date = DateTime.fromMillisecondsSinceEpoch(day);
    final from = DateTime(date.year).millisecondsSinceEpoch;
    final before = DateTime(date.year + 1).millisecondsSinceEpoch;
    return StatisticsRange(
      kind: StatisticsRangeKind.year,
      anchorDay: day,
      from: from,
      before: before,
    );
  }

  final StatisticsRangeKind kind;
  final int anchorDay;
  final int from;
  final int before;

  String get label => switch (kind) {
        StatisticsRangeKind.week => '本周',
        StatisticsRangeKind.month => '本月',
        StatisticsRangeKind.year => '本年',
      };

  @override
  bool operator ==(Object other) {
    return other is StatisticsRange &&
        other.kind == kind &&
        other.anchorDay == anchorDay &&
        other.from == from &&
        other.before == before;
  }

  @override
  int get hashCode => Object.hash(kind, anchorDay, from, before);
}

int _dayStart(int value) {
  final date = DateTime.fromMillisecondsSinceEpoch(value);
  return DateTime(date.year, date.month, date.day).millisecondsSinceEpoch;
}
