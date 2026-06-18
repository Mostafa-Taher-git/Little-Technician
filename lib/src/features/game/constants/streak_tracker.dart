class StreakTracker {
  static int calculateStreak(List<DateTime> playDates) {
    if (playDates.isEmpty) return 0;

    final sorted = playDates.map((d) => DateTime(d.year, d.month, d.day)).toSet().toList()
      ..sort((a, b) => b.compareTo(a));

    var streak = 1;
    for (var i = 0; i < sorted.length - 1; i++) {
      final diff = sorted[i].difference(sorted[i + 1]).inDays;
      if (diff == 1) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }

  static bool playedToday(List<DateTime> playDates, {DateTime? lastActiveDate}) {
    if (lastActiveDate != null) {
      final today = DateTime.now();
      return lastActiveDate.year == today.year &&
          lastActiveDate.month == today.month &&
          lastActiveDate.day == today.day;
    }
    final today = DateTime.now();
    return playDates.any((d) =>
        d.year == today.year && d.month == today.month && d.day == today.day);
  }
}
