import 'package:flutter/material.dart';
import 'package:littletech/src/features/game/constants/reward_pool.dart';

enum AchievementType { levels, bosses, points, rewards, streak, categories, weeklyBosses }

class AchievementReward {
  final String rewardId;
  final RewardType type;

  const AchievementReward({required this.rewardId, required this.type});
}

class Achievement {
  final String id;
  final String name;
  final String description;
  final AchievementType type;
  final int requirement;
  final IconData icon;
  final List<AchievementReward> rewards;

  const Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.requirement,
    required this.icon,
    this.rewards = const [],
  });
}

class AchievementManager {
  static const List<Achievement> all = [
    // ── Levels ──────────────────────────────────────────────────────────────
    Achievement(
      id: 'first_level',
      name: 'First Steps',
      description: 'Complete your first level',
      type: AchievementType.levels,
      requirement: 1,

      icon: Icons.star_border,
    ),
    Achievement(
      id: 'five_levels',
      name: 'Apprentice Technician',
      description: 'Complete 5 levels',
      type: AchievementType.levels,
      requirement: 5,

      icon: Icons.star_half,
    ),
    Achievement(
      id: 'ten_levels',
      name: 'Skilled Repairer',
      description: 'Complete 10 levels',
      type: AchievementType.levels,
      requirement: 10,

      icon: Icons.star,
      rewards: [AchievementReward(rewardId: 'title_fixer', type: RewardType.title)],
    ),
    Achievement(
      id: 'twenty_five_levels',
      name: 'Rising Technician',
      description: 'Complete 25 levels',
      type: AchievementType.levels,
      requirement: 25,

      icon: Icons.star,
      rewards: [AchievementReward(rewardId: 'frame_dotted', type: RewardType.nicknameFrame)],
    ),
    Achievement(
      id: 'fifty_levels',
      name: 'Veteran Technician',
      description: 'Complete 50 levels',
      type: AchievementType.levels,
      requirement: 50,

      icon: Icons.workspace_premium,
      rewards: [AchievementReward(rewardId: 'frame_simple', type: RewardType.nicknameFrame)],
    ),
    Achievement(
      id: 'hundred_levels',
      name: 'Century Technician',
      description: 'Complete 100 levels',
      type: AchievementType.levels,
      requirement: 100,

      icon: Icons.workspace_premium,
      rewards: [AchievementReward(rewardId: 'frame_tech', type: RewardType.nicknameFrame)],
    ),
    Achievement(
      id: 'fifteen_levels',
      name: 'Tech Savvy',
      description: 'Complete 15 levels',
      type: AchievementType.levels,
      requirement: 15,

      icon: Icons.star,
      rewards: [AchievementReward(rewardId: 'skin_cyber', type: RewardType.skin)],
    ),
    Achievement(
      id: 'forty_levels',
      name: 'Veteran Tech',
      description: 'Complete 40 levels',
      type: AchievementType.levels,
      requirement: 40,

      icon: Icons.workspace_premium,
      rewards: [AchievementReward(rewardId: 'skin_chrono', type: RewardType.skin)],
    ),

    // ── Category-specific levels ────────────────────────────────────────────
    Achievement(
      id: 'virus_hunter',
      name: 'Virus Hunter',
      description: 'Complete all security levels',
      type: AchievementType.levels,
      requirement: 29,

      icon: Icons.shield,
      rewards: [AchievementReward(rewardId: 'icon_robot', type: RewardType.icon)],
    ),
    Achievement(
      id: 'network_fixer',
      name: 'Network Fixer',
      description: 'Complete all networking levels',
      type: AchievementType.levels,
      requirement: 29,

      icon: Icons.wifi,
      rewards: [AchievementReward(rewardId: 'icon_wifi', type: RewardType.icon)],
    ),
    Achievement(
      id: 'boot_doctor',
      name: 'Boot Doctor',
      description: 'Complete all OS levels',
      type: AchievementType.levels,
      requirement: 29,

      icon: Icons.desktop_windows,
      rewards: [AchievementReward(rewardId: 'icon_server', type: RewardType.icon)],
    ),
    Achievement(
      id: 'memory_wizard',
      name: 'Memory Wizard',
      description: 'Complete all RAM levels',
      type: AchievementType.levels,
      requirement: 29,

      icon: Icons.memory,
      rewards: [AchievementReward(rewardId: 'icon_chip', type: RewardType.icon)],
    ),
    Achievement(
      id: 'storage_master',
      name: 'Storage Master',
      description: 'Complete all Storage levels',
      type: AchievementType.levels,
      requirement: 29,

      icon: Icons.storage,
      rewards: [AchievementReward(rewardId: 'icon_battery', type: RewardType.icon)],
    ),
    Achievement(
      id: 'display_guru',
      name: 'Display Guru',
      description: 'Complete all Display levels',
      type: AchievementType.levels,
      requirement: 29,

      icon: Icons.monitor,
      rewards: [AchievementReward(rewardId: 'icon_satellite', type: RewardType.icon)],
    ),
    Achievement(
      id: 'gaming_pro',
      name: 'Gaming Pro',
      description: 'Complete all Gaming levels',
      type: AchievementType.levels,
      requirement: 29,

      icon: Icons.sports_esports,
      rewards: [AchievementReward(rewardId: 'icon_laptop', type: RewardType.icon)],
    ),

    // ── Bosses ──────────────────────────────────────────────────────────────
    Achievement(
      id: 'first_boss',
      name: 'First Boss Down',
      description: 'Defeat your first boss',
      type: AchievementType.bosses,
      requirement: 1,

      icon: Icons.shield,
    ),
    Achievement(
      id: 'five_bosses',
      name: 'Boss Hunter',
      description: 'Defeat 5 bosses',
      type: AchievementType.bosses,
      requirement: 5,

      icon: Icons.shield_outlined,
      rewards: [AchievementReward(rewardId: 'icon_laptop', type: RewardType.icon)],
    ),
    Achievement(
      id: 'all_bosses',
      name: 'Overlord',
      description: 'Defeat a boss in every category',
      type: AchievementType.bosses,
      requirement: 14,

      icon: Icons.shield_moon,
      rewards: [AchievementReward(rewardId: 'skin_hacker', type: RewardType.skin)],
    ),
    Achievement(
      id: 'ten_bosses',
      name: 'Boss Slayer',
      description: 'Defeat 10 bosses',
      type: AchievementType.bosses,
      requirement: 10,

      icon: Icons.shield_moon,
      rewards: [AchievementReward(rewardId: 'skin_void', type: RewardType.skin)],
    ),
    Achievement(
      id: 'boss_crusher',
      name: 'Boss Crusher',
      description: 'Defeat 50 bosses',
      type: AchievementType.bosses,
      requirement: 50,

      icon: Icons.gpp_maybe,
      rewards: [AchievementReward(rewardId: 'title_specialist', type: RewardType.title)],
    ),
    Achievement(
      id: 'five_bosses_elite',
      name: 'Elite Hunter',
      description: 'Defeat 15 bosses',
      type: AchievementType.bosses,
      requirement: 15,

      icon: Icons.shield,
      rewards: [AchievementReward(rewardId: 'skin_shadow', type: RewardType.skin)],
    ),
    Achievement(
      id: 'monster_slayer',
      name: 'Monster Slayer',
      description: 'Defeat 100 bosses',
      type: AchievementType.bosses,
      requirement: 100,

      icon: Icons.local_fire_department,
      rewards: [AchievementReward(rewardId: 'skin_engineer', type: RewardType.skin)],
    ),
    Achievement(
      id: 'boss_conqueror',
      name: 'Boss Conqueror',
      description: 'Defeat 150 bosses',
      type: AchievementType.bosses,
      requirement: 150,

      icon: Icons.emoji_events,
      rewards: [
        AchievementReward(rewardId: 'skin_grandmaster', type: RewardType.skin),
        AchievementReward(rewardId: 'title_overlord', type: RewardType.title),
      ],
    ),
    Achievement(
      id: 'fifty_bosses',
      name: 'Spectre Admin',
      description: 'Defeat 50 bosses',
      type: AchievementType.bosses,
      requirement: 50,

      icon: Icons.admin_panel_settings,
      rewards: [AchievementReward(rewardId: 'skin_spectre', type: RewardType.skin)],
    ),

    // ── Weekly Bosses ───────────────────────────────────────────────────────
    Achievement(
      id: 'raider',
      name: 'Raider',
      description: 'Defeat your first weekly raid boss',
      type: AchievementType.weeklyBosses,
      requirement: 1,

      icon: Icons.shield,
    ),
    Achievement(
      id: 'weekly_veteran',
      name: 'Weekly Veteran',
      description: 'Defeat 5 weekly bosses',
      type: AchievementType.weeklyBosses,
      requirement: 5,

      icon: Icons.leaderboard,
      rewards: [AchievementReward(rewardId: 'title_debugger', type: RewardType.title)],
    ),
    Achievement(
      id: 'raid_champion',
      name: 'Raid Champion',
      description: 'Defeat all 14 weekly bosses',
      type: AchievementType.weeklyBosses,
      requirement: 14,

      icon: Icons.emoji_events,
      rewards: [
        AchievementReward(rewardId: 'frame_dragon', type: RewardType.nicknameFrame),
        AchievementReward(rewardId: 'title_overlord', type: RewardType.title),
      ],
    ),

    // ── Points ──────────────────────────────────────────────────────────────
    Achievement(
      id: 'hundred_points',
      name: 'Point Collector',
      description: 'Earn 100 points',
      type: AchievementType.points,
      requirement: 100,

      icon: Icons.monetization_on,
    ),
    Achievement(
      id: 'five_hundred_points',
      name: 'Point Gatherer',
      description: 'Earn 500 points',
      type: AchievementType.points,
      requirement: 500,

      icon: Icons.monetization_on,
      rewards: [AchievementReward(rewardId: 'theme_dark', type: RewardType.theme)],
    ),
    Achievement(
      id: 'thousand_points',
      name: 'Point Hoarder',
      description: 'Earn 1000 points',
      type: AchievementType.points,
      requirement: 1000,

      icon: Icons.monetization_on,
      rewards: [AchievementReward(rewardId: 'theme_amber', type: RewardType.theme)],
    ),
    Achievement(
      id: 'two_thousand_points',
      name: 'Point Baron',
      description: 'Earn 2000 points',
      type: AchievementType.points,
      requirement: 2000,

      icon: Icons.monetization_on,
      rewards: [AchievementReward(rewardId: 'skin_phoenix', type: RewardType.skin)],
    ),
    Achievement(
      id: 'five_thousand_points',
      name: 'Tech Tycoon',
      description: 'Earn 5000 points',
      type: AchievementType.points,
      requirement: 5000,

      icon: Icons.account_balance_wallet,
      rewards: [AchievementReward(rewardId: 'theme_ocean', type: RewardType.theme)],
    ),
    Achievement(
      id: 'ten_thousand_points',
      name: 'Point Magnate',
      description: 'Earn 10,000 points',
      type: AchievementType.points,
      requirement: 10000,

      icon: Icons.account_balance_wallet,
      rewards: [AchievementReward(rewardId: 'theme_medieval', type: RewardType.theme)],
    ),
    Achievement(
      id: 'twenty_five_thousand_points',
      name: 'Point Baron II',
      description: 'Earn 25,000 points',
      type: AchievementType.points,
      requirement: 25000,

      icon: Icons.account_balance_wallet,
      rewards: [AchievementReward(rewardId: 'theme_dungeon', type: RewardType.theme)],
    ),
    Achievement(
      id: 'fifty_thousand_points',
      name: 'Point Lord',
      description: 'Earn 50,000 points',
      type: AchievementType.points,
      requirement: 50000,

      icon: Icons.account_balance,
      rewards: [AchievementReward(rewardId: 'theme_arcane', type: RewardType.theme)],
    ),
    Achievement(
      id: 'hundred_thousand_points',
      name: 'Grand Tycoon',
      description: 'Earn 100,000 points',
      type: AchievementType.points,
      requirement: 100000,

      icon: Icons.account_balance,
      rewards: [
        AchievementReward(rewardId: 'theme_neon', type: RewardType.theme),
        AchievementReward(rewardId: 'title_grandmaster', type: RewardType.title),
      ],
    ),
    Achievement(
      id: 'two_fifty_thousand_points',
      name: 'Point God',
      description: 'Earn 250,000 points',
      type: AchievementType.points,
      requirement: 250000,

      icon: Icons.currency_bitcoin,
      rewards: [
        AchievementReward(rewardId: 'theme_dragon_fire', type: RewardType.theme),
        AchievementReward(rewardId: 'frame_dragon', type: RewardType.nicknameFrame),
      ],
    ),

    // ── Rewards ─────────────────────────────────────────────────────────────
    Achievement(
      id: 'first_reward',
      name: 'Lucky Draw',
      description: 'Earn your first reward',
      type: AchievementType.rewards,
      requirement: 1,

      icon: Icons.card_giftcard,
    ),
    Achievement(
      id: 'five_rewards',
      name: 'Reward Seeker',
      description: 'Earn 5 rewards',
      type: AchievementType.rewards,
      requirement: 5,

      icon: Icons.card_giftcard,
      rewards: [AchievementReward(rewardId: 'icon_wrench', type: RewardType.icon)],
    ),
    Achievement(
      id: 'fifteen_rewards',
      name: 'Treasure Hunter',
      description: 'Earn 15 rewards',
      type: AchievementType.rewards,
      requirement: 15,

      icon: Icons.inventory,
      rewards: [AchievementReward(rewardId: 'icon_robot', type: RewardType.icon)],
    ),
    Achievement(
      id: 'thirty_rewards',
      name: 'Loot Goblin',
      description: 'Earn 30 rewards',
      type: AchievementType.rewards,
      requirement: 30,

      icon: Icons.inventory_2,
      rewards: [AchievementReward(rewardId: 'icon_satellite', type: RewardType.icon)],
    ),
    Achievement(
      id: 'fifty_rewards',
      name: 'Reward Baron',
      description: 'Earn 50 rewards',
      type: AchievementType.rewards,
      requirement: 50,

      icon: Icons.account_balance,
      rewards: [AchievementReward(rewardId: 'icon_crown', type: RewardType.icon)],
    ),
    Achievement(
      id: 'hundred_rewards',
      name: 'Treasure Lord',
      description: 'Earn 100 rewards',
      type: AchievementType.rewards,
      requirement: 100,

      icon: Icons.savings,
      rewards: [AchievementReward(rewardId: 'icon_dragon', type: RewardType.icon)],
    ),
    Achievement(
      id: 'ten_rewards',
      name: 'Treasure Hunter II',
      description: 'Earn 10 rewards',
      type: AchievementType.rewards,
      requirement: 10,

      icon: Icons.inventory,
      rewards: [AchievementReward(rewardId: 'frame_legendary', type: RewardType.nicknameFrame)],
    ),
    Achievement(
      id: 'fifteen_rewards_loot',
      name: 'Loot Goblin II',
      description: 'Earn 15 rewards',
      type: AchievementType.rewards,
      requirement: 15,

      icon: Icons.inventory_2,
      rewards: [AchievementReward(rewardId: 'skin_glitch', type: RewardType.skin)],
    ),

    // ── Streak ──────────────────────────────────────────────────────────────
    Achievement(
      id: 'three_day_streak',
      name: 'Consistent',
      description: 'Achieve a 3-day streak',
      type: AchievementType.streak,
      requirement: 3,

      icon: Icons.local_fire_department,
      rewards: [AchievementReward(rewardId: 'frame_circuit', type: RewardType.nicknameFrame)],
    ),
    Achievement(
      id: 'seven_day_streak',
      name: 'Dedicated',
      description: 'Achieve a 7-day streak',
      type: AchievementType.streak,
      requirement: 7,

      icon: Icons.whatshot,
      rewards: [AchievementReward(rewardId: 'title_analyst', type: RewardType.title)],
    ),
    Achievement(
      id: 'fourteen_day_streak',
      name: 'Relentless',
      description: 'Achieve a 14-day streak',
      type: AchievementType.streak,
      requirement: 14,

      icon: Icons.local_fire_department,
      rewards: [AchievementReward(rewardId: 'title_debugger', type: RewardType.title)],
    ),
    Achievement(
      id: 'thirty_day_streak',
      name: 'Tech Legend',
      description: 'Achieve a 30-day streak',
      type: AchievementType.streak,
      requirement: 30,

      icon: Icons.auto_awesome,
      rewards: [AchievementReward(rewardId: 'title_sysadmin', type: RewardType.title)],
    ),
    Achievement(
      id: 'sixty_day_streak',
      name: 'Unstoppable',
      description: 'Achieve a 60-day streak',
      type: AchievementType.streak,
      requirement: 60,

      icon: Icons.local_fire_department,
      rewards: [AchievementReward(rewardId: 'icon_unicorn', type: RewardType.icon)],
    ),
    Achievement(
      id: 'hundred_day_streak',
      name: 'Eternal Flame',
      description: 'Achieve a 100-day streak',
      type: AchievementType.streak,
      requirement: 100,

      icon: Icons.whatshot,
      rewards: [
        AchievementReward(rewardId: 'title_grandmaster', type: RewardType.title),
        AchievementReward(rewardId: 'icon_dragon', type: RewardType.icon),
      ],
    ),

    // ── Categories ──────────────────────────────────────────────────────────
    Achievement(
      id: 'complete_world',
      name: 'World Explorer',
      description: 'Complete a category campaign',
      type: AchievementType.categories,
      requirement: 1,

      icon: Icons.public,
      rewards: [AchievementReward(rewardId: 'title_helper', type: RewardType.title)],
    ),
    Achievement(
      id: 'three_worlds',
      name: 'Adventurer',
      description: 'Complete 3 category campaigns',
      type: AchievementType.categories,
      requirement: 3,

      icon: Icons.travel_explore,
      rewards: [AchievementReward(rewardId: 'title_engineer', type: RewardType.title)],
    ),
    Achievement(
      id: 'five_worlds',
      name: 'Campaigner',
      description: 'Complete 5 category campaigns',
      type: AchievementType.categories,
      requirement: 5,

      icon: Icons.flag,
      rewards: [AchievementReward(rewardId: 'title_architect', type: RewardType.title)],
    ),
    Achievement(
      id: 'five_worlds_viper',
      name: 'Viper Security',
      description: 'Complete 5 category campaigns',
      type: AchievementType.categories,
      requirement: 5,

      icon: Icons.security,
      rewards: [AchievementReward(rewardId: 'skin_viper', type: RewardType.skin)],
    ),
    Achievement(
      id: 'seven_worlds',
      name: 'Half Conqueror',
      description: 'Complete 7 category campaigns',
      type: AchievementType.categories,
      requirement: 7,

      icon: Icons.public,
      rewards: [AchievementReward(rewardId: 'frame_circuit', type: RewardType.nicknameFrame)],
    ),
    Achievement(
      id: 'ten_worlds',
      name: 'World Beater',
      description: 'Complete 10 category campaigns',
      type: AchievementType.categories,
      requirement: 10,

      icon: Icons.language,
      rewards: [AchievementReward(rewardId: 'icon_chip', type: RewardType.icon)],
    ),
    Achievement(
      id: 'all_worlds',
      name: 'Conqueror',
      description: 'Complete all 14 category campaigns',
      type: AchievementType.categories,
      requirement: 14,

      icon: Icons.flag,
      rewards: [
        AchievementReward(rewardId: 'frame_legendary', type: RewardType.nicknameFrame),
        AchievementReward(rewardId: 'title_overlord', type: RewardType.title),
      ],
    ),
  ];

  static List<Achievement> checkNew({
    required int levelsCleared,
    required int bossesDefeated,
    required int points,
    required int rewardsEarned,
    required int streak,
    int categoriesCompleted = 0,
    int weeklyBossesDefeated = 0,
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
        AchievementType.categories => categoriesCompleted,
        AchievementType.weeklyBosses => weeklyBossesDefeated,
      };
      if (progress >= a.requirement) {
        newAchievements.add(a);
      }
    }
    return newAchievements;
  }
}
