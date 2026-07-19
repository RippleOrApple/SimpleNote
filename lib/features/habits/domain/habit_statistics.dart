class HabitStatistics {
  const HabitStatistics({
    required this.habitId,
    required this.from,
    required this.before,
    required this.asOfDay,
    required this.plannedDays,
    required this.completedDays,
    required this.currentStreak,
    required this.longestStreak,
  });

  final String habitId;
  final int from;
  final int before;
  final int asOfDay;
  final int plannedDays;
  final int completedDays;
  final int currentStreak;
  final int longestStreak;

  double get completionRate {
    if (plannedDays == 0) return 0;
    return completedDays / plannedDays;
  }
}
