class StreakTracker {
  static int calculateStreak(List<DateTime> playDates) {
    if (playDates.isEmpty) return 0;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final sorted = playDates.map((d) => DateTime(d.year, d.month, d.day)).toSet().toList()
      ..sort((a, b) => b.compareTo(a));

    // Streak only counts if the most recent play was today or yesterday
    if (!sorted[0].isAtSameMomentAs(today) && !sorted[0].isAtSameMomentAs(yesterday)) {
      return 0;
    }

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
}
