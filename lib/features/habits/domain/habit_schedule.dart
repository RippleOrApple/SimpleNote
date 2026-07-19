enum HabitScheduleType { daily, weekdays, weekly, interval }

class HabitSchedule {
  const HabitSchedule._({
    required this.type,
    this.weekdays = const {},
    this.everyDays,
    this.anchorDay,
  });

  factory HabitSchedule.daily() {
    return const HabitSchedule._(type: HabitScheduleType.daily);
  }

  factory HabitSchedule.weekdays() {
    return const HabitSchedule._(type: HabitScheduleType.weekdays);
  }

  factory HabitSchedule.weekly(Set<int> weekdays) {
    final normalized = weekdays.toSet();
    _validateWeekdays(normalized);
    return HabitSchedule._(
      type: HabitScheduleType.weekly,
      weekdays: Set.unmodifiable(normalized),
    );
  }

  factory HabitSchedule.interval({
    required int everyDays,
    required int anchorDay,
  }) {
    if (everyDays < 1) {
      throw const FormatException('everyDays must be positive.');
    }
    return HabitSchedule._(
      type: HabitScheduleType.interval,
      everyDays: everyDays,
      anchorDay: anchorDay,
    );
  }

  factory HabitSchedule.fromJson(
    String type,
    Map<String, Object?> json,
  ) {
    final scheduleType = HabitScheduleType.values.byName(type);
    return switch (scheduleType) {
      HabitScheduleType.daily => HabitSchedule.daily(),
      HabitScheduleType.weekdays => HabitSchedule.weekdays(),
      HabitScheduleType.weekly => HabitSchedule.weekly(
          _intSet(json['weekdays']),
        ),
      HabitScheduleType.interval => HabitSchedule.interval(
          everyDays: _requiredInt(json, 'everyDays'),
          anchorDay: _requiredInt(json, 'anchorDay'),
        ),
    };
  }

  final HabitScheduleType type;
  final Set<int> weekdays;
  final int? everyDays;
  final int? anchorDay;

  Map<String, Object?> toJson() {
    return switch (type) {
      HabitScheduleType.daily => const <String, Object?>{},
      HabitScheduleType.weekdays => const <String, Object?>{},
      HabitScheduleType.weekly => {
          'weekdays': weekdays.toList()..sort(),
        },
      HabitScheduleType.interval => {
          'everyDays': everyDays,
          'anchorDay': anchorDay,
        },
    };
  }

  @override
  bool operator ==(Object other) {
    return other is HabitSchedule &&
        other.type == type &&
        _setEquals(other.weekdays, weekdays) &&
        other.everyDays == everyDays &&
        other.anchorDay == anchorDay;
  }

  @override
  int get hashCode => Object.hash(
        type,
        Object.hashAll(weekdays),
        everyDays,
        anchorDay,
      );
}

void _validateWeekdays(Set<int> weekdays) {
  if (weekdays.isEmpty) {
    throw const FormatException('weekly schedules need at least one day.');
  }
  for (final day in weekdays) {
    if (day < 1 || day > 7) {
      throw const FormatException('weekday must be between 1 and 7.');
    }
  }
}

Set<int> _intSet(Object? value) {
  if (value is! List) {
    throw const FormatException('weekdays must be a list.');
  }
  return {
    for (final item in value)
      if (item is int) item else throw const FormatException('bad weekday.'),
  };
}

int _requiredInt(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is! int) {
    throw FormatException('$key must be an integer.');
  }
  return value;
}

bool _setEquals(Set<int> left, Set<int> right) {
  if (left.length != right.length) return false;
  for (final value in left) {
    if (!right.contains(value)) return false;
  }
  return true;
}
