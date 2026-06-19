import 'package:flutter/material.dart';

enum AchievementType { levels, bosses, points, rewards, streak, worlds, categories }

class Achievement {
  final String id;
  final String name;
  final String description;
  final AchievementType type;
  final int requirement;
  final int rewardPoints;
  final IconData icon;

  const Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.requirement,
    required this.rewardPoints,
    required this.icon,
  });
}

class AchievementManager {
  static const List<Achievement> all = [
    Achievement(
      id: 'first_level',
      name: 'First Steps',
      description: 'Complete your first level',
      type: AchievementType.levels,
      requirement: 1,
      rewardPoints: 10,
      icon: Icons.star_border,
    ),
    Achievement(
      id: 'five_levels',
      name: 'Apprentice Technician',
      description: 'Complete 5 levels',
      type: AchievementType.levels,
      requirement: 5,
      rewardPoints: 25,
      icon: Icons.star_half,
    ),
    Achievement(
      id: 'ten_levels',
      name: 'Skilled Repairer',
      description: 'Complete 10 levels',
      type: AchievementType.levels,
      requirement: 10,
      rewardPoints: 50,
      icon: Icons.star,
    ),
    Achievement(
      id: 'twenty_levels',
      name: 'Master Technician',
      description: 'Complete 20 levels',
      type: AchievementType.levels,
      requirement: 20,
      rewardPoints: 100,
      icon: Icons.workspace_premium,
    ),
    Achievement(
      id: 'first_boss',
      name: 'First Boss Down',
      description: 'Defeat your first boss',
      type: AchievementType.bosses,
      requirement: 1,
      rewardPoints: 20,
      icon: Icons.shield,
    ),
    Achievement(
      id: 'three_bosses',
      name: 'Boss Hunter',
      description: 'Defeat 3 bosses',
      type: AchievementType.bosses,
      requirement: 3,
      rewardPoints: 50,
      icon: Icons.shield_outlined,
    ),
    Achievement(
      id: 'all_bosses',
      name: 'Overlord',
      description: 'Defeat all bosses',
      type: AchievementType.bosses,
      requirement: 8,
      rewardPoints: 200,
      icon: Icons.shield_moon,
    ),
    Achievement(
      id: 'hundred_points',
      name: 'Point Collector',
      description: 'Earn 100 points',
      type: AchievementType.points,
      requirement: 100,
      rewardPoints: 10,
      icon: Icons.monetization_on,
    ),
    Achievement(
      id: 'thousand_points',
      name: 'Point Hoarder',
      description: 'Earn 1000 points',
      type: AchievementType.points,
      requirement: 1000,
      rewardPoints: 50,
      icon: Icons.monetization_on,
    ),
    Achievement(
      id: 'five_thousand_points',
      name: 'Tech Tycoon',
      description: 'Earn 5000 points',
      type: AchievementType.points,
      requirement: 5000,
      rewardPoints: 200,
      icon: Icons.account_balance_wallet,
    ),
    Achievement(
      id: 'first_reward',
      name: 'Lucky Draw',
      description: 'Earn your first reward',
      type: AchievementType.rewards,
      requirement: 1,
      rewardPoints: 10,
      icon: Icons.card_giftcard,
    ),
    Achievement(
      id: 'five_rewards',
      name: 'Reward Seeker',
      description: 'Earn 5 rewards',
      type: AchievementType.rewards,
      requirement: 5,
      rewardPoints: 30,
      icon: Icons.card_giftcard,
    ),
    Achievement(
      id: 'ten_rewards',
      name: 'Treasure Hunter',
      description: 'Earn 10 rewards',
      type: AchievementType.rewards,
      requirement: 10,
      rewardPoints: 75,
      icon: Icons.inventory,
    ),
    Achievement(
      id: 'three_day_streak',
      name: 'Consistent',
      description: 'Achieve a 3-day streak',
      type: AchievementType.streak,
      requirement: 3,
      rewardPoints: 30,
      icon: Icons.local_fire_department,
    ),
    Achievement(
      id: 'seven_day_streak',
      name: 'Dedicated',
      description: 'Achieve a 7-day streak',
      type: AchievementType.streak,
      requirement: 7,
      rewardPoints: 100,
      icon: Icons.whatshot,
    ),
    Achievement(
      id: 'thirty_day_streak',
      name: 'Tech Legend',
      description: 'Achieve a 30-day streak',
      type: AchievementType.streak,
      requirement: 30,
      rewardPoints: 500,
      icon: Icons.auto_awesome,
    ),
    Achievement(
      id: 'complete_world',
      name: 'World Explorer',
      description: 'Complete a category campaign',
      type: AchievementType.categories,
      requirement: 1,
      rewardPoints: 50,
      icon: Icons.public,
    ),
    Achievement(
      id: 'three_worlds',
      name: 'Adventurer',
      description: 'Complete 3 category campaigns',
      type: AchievementType.categories,
      requirement: 3,
      rewardPoints: 100,
      icon: Icons.travel_explore,
    ),
    Achievement(
      id: 'all_worlds',
      name: 'Conqueror',
      description: 'Complete all category campaigns',
      type: AchievementType.categories,
      requirement: 13,
      rewardPoints: 500,
      icon: Icons.flag,
    ),
    Achievement(
      id: 'virus_hunter',
      name: 'Virus Hunter',
      description: 'Complete all security-related levels',
      type: AchievementType.levels,
      requirement: 15,
      rewardPoints: 75,
      icon: Icons.shield,
    ),
    Achievement(
      id: 'network_fixer',
      name: 'Network Fixer',
      description: 'Complete all networking levels',
      type: AchievementType.levels,
      requirement: 10,
      rewardPoints: 75,
      icon: Icons.wifi,
    ),
    Achievement(
      id: 'boot_doctor',
      name: 'Boot Doctor',
      description: 'Complete all OS and boot-related levels',
      type: AchievementType.levels,
      requirement: 10,
      rewardPoints: 75,
      icon: Icons.desktop_windows,
    ),
  ];

  static List<Achievement> checkNew({
    required int levelsCleared,
    required int bossesDefeated,
    required int points,
    required int rewardsEarned,
    required int streak,
    required int worldsCompleted,
    int categoriesCompleted = 0,
    List<String> alreadyUnlockedIds = const [],
  }) {
    final newAchievements = <Achievement>[];

    for (final a in all) {
      if (alreadyUnlockedIds.contains(a.id)) continue;
      final progress = switch (a.type) {
        AchievementType.levels => levelsCleared,
        AchievementType.bosses => bossesDefeated,
        AchievementType.points => points,
        AchievementType.rewards => rewardsEarned,
        AchievementType.streak => streak,
        AchievementType.worlds => worldsCompleted,
        AchievementType.categories => categoriesCompleted,
      };
      if (progress >= a.requirement) {
        newAchievements.add(a);
      }
    }
    return newAchievements;
  }
}
