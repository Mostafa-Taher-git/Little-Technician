enum RewardType { icon, title, nickname, theme, skin }

enum RewardRarity { common, rare, epic, legendary }

class Reward {
  final String id;
  final RewardType type;
  final String value;
  final RewardRarity rarity;

  const Reward({
    required this.id,
    required this.type,
    required this.value,
    required this.rarity,
  });
}