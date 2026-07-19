import 'statistics_range.dart';

class StatisticsSummary {
  const StatisticsSummary({
    required this.range,
    required this.taskCompletions,
    required this.habitCheckins,
    required this.habitPlannedDays,
    required this.habitCompletedDays,
    required this.currentHabitStreak,
    required this.longestHabitStreak,
  });

  final StatisticsRange range;
  final int taskCompletions;
  final int habitCheckins;
  final int habitPlannedDays;
  final int habitCompletedDays;
  final int currentHabitStreak;
  final int longestHabitStreak;

  double get habitCompletionRate {
    if (habitPlannedDays == 0) return 0;
    return habitCompletedDays / habitPlannedDays;
  }
}
