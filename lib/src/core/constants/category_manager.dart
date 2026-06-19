import 'package:flutter/material.dart';

class CategoryDef {
  final String id;
  final String name;
  final IconData icon;
  final String description;
  final List<String> problemKeys;
  final int levelCount;
  final String bossName;
  final String bossLore;
  final Set<String> deviceTypes;
  final int bossHp;

  const CategoryDef({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
    required this.problemKeys,
    this.levelCount = 5,
    this.bossName = '',
    this.bossLore = '',
    this.deviceTypes = const {},
    this.bossHp = 5,
  });
}

class CategoryManager {
  static const List<CategoryDef> all = [
    CategoryDef(
      id: 'core_components',
      name: 'Core Components',
      icon: Icons.memory,
      description: 'CPU, motherboard, RAM basics',
      problemKeys: ['high cpu usage', 'cpu overheating', 'computer not turning on', 'beep codes on startup', 'cpu fan not spinning'],
      levelCount: 5,
      bossName: 'The Bone Colossus',
      bossLore: 'A towering skeleton giant assembled from broken PC cases and failed hardware.',
      deviceTypes: {'desktop', 'laptop'},
      bossHp: 5,
    ),
    CategoryDef(
      id: 'ram',
      name: 'RAM',
      icon: Icons.developer_board,
      description: 'Memory issues and upgrades',
      problemKeys: ['random crashes / bsod', 'insufficient memory warning', 'ram not detected', 'ram overheating', 'ram compatibility issues'],
      levelCount: 4,
      bossName: 'The Memory Wraith',
      bossLore: 'A ghostly entity that corrupts memory addresses and shreds data.',
      deviceTypes: {'desktop', 'laptop'},
      bossHp: 5,
    ),
    CategoryDef(
      id: 'operating_system',
      name: 'Operating System',
      icon: Icons.desktop_windows,
      description: 'Boot issues and OS problems',
      problemKeys: ["pc won't boot", 'boot loop', 'blue screen of death (bsod)', 'os running slow', 'windows not updating'],
      levelCount: 5,
      bossName: 'The Lich Lord',
      bossLore: 'An undead sorcerer of corrupted system files.',
      deviceTypes: {'desktop', 'laptop'},
      bossHp: 6,
    ),
    CategoryDef(
      id: 'audio',
      name: 'Audio',
      icon: Icons.volume_up,
      description: 'Sound and speaker issues',
      problemKeys: ['no sound output', 'distorted audio', 'audio device not found', 'microphone not working', 'audio lag / delay'],
      levelCount: 4,
      bossName: 'The Static Specter',
      bossLore: 'A ghost that feeds on audio frequencies and corrupts sound waves.',
      deviceTypes: {'desktop', 'laptop', 'phone', 'tablet'},
      bossHp: 5,
    ),
    CategoryDef(
      id: 'peripherals',
      name: 'Peripherals',
      icon: Icons.mouse,
      description: 'Mouse, keyboard, printer issues',
      problemKeys: ['mouse not responding', 'cursor lagging or stuttering', 'mouse double-click issue', 'keyboard not responding', 'printer not responding', 'paper jam'],
      levelCount: 6,
      bossName: 'The Goblin King',
      bossLore: 'A cunning goblin warlord that sabotages your peripherals.',
      deviceTypes: {'desktop', 'laptop', 'printer'},
      bossHp: 5,
    ),
    CategoryDef(
      id: 'software',
      name: 'Software',
      icon: Icons.apps,
      description: 'Program and application issues',
      problemKeys: ['program crashes on launch', 'software installation failed', 'program running slow', 'dll file missing error', 'program not compatible'],
      levelCount: 4,
      bossName: 'The Glitch',
      bossLore: 'A digital parasite that corrupts code and breaks installations.',
      deviceTypes: {'desktop', 'laptop'},
      bossHp: 5,
    ),
    CategoryDef(
      id: 'internet',
      name: 'Internet',
      icon: Icons.wifi,
      description: 'Network and connectivity issues',
      problemKeys: ['no internet connection', 'slow internet speed', 'wi-fi not detected', 'dns server not responding', 'vpn not connecting'],
      levelCount: 4,
      bossName: 'The Dragon Whelp',
      bossLore: 'A young crimson dragon that hoards network packets.',
      deviceTypes: {'desktop', 'laptop', 'phone', 'tablet', 'router'},
      bossHp: 6,
    ),
    CategoryDef(
      id: 'storage',
      name: 'Storage',
      icon: Icons.storage,
      description: 'Hard drive and storage issues',
      problemKeys: ['hard drive not detected', 'slow disk performance', 'disk full — no space', 'clicking or grinding noise', 'corrupted files / sectors'],
      levelCount: 4,
      bossName: 'The Void Disk',
      bossLore: 'An ancient data-destroyer that consumes files whole.',
      deviceTypes: {'desktop', 'laptop'},
      bossHp: 5,
    ),
    CategoryDef(
      id: 'display',
      name: 'Display',
      icon: Icons.monitor,
      description: 'Monitor and screen issues',
      problemKeys: ['no display output', 'flickering screen', 'black screen on boot', 'wrong resolution', 'dead pixels'],
      levelCount: 4,
      bossName: 'The Beholder',
      bossLore: 'A floating eye tyrant that corrupts displays.',
      deviceTypes: {'desktop', 'laptop', 'smart_tv', 'console'},
      bossHp: 7,
    ),
    CategoryDef(
      id: 'mobile',
      name: 'Mobile',
      icon: Icons.phone_android,
      description: 'Phone and tablet troubleshooting',
      problemKeys: ['battery draining too fast', 'phone overheating', 'apps crashing on phone', 'phone not charging', 'slow phone performance'],
      levelCount: 5,
      bossName: 'The Battery Wraith',
      bossLore: 'A ghostly energy-draining entity.',
      deviceTypes: {'phone', 'tablet'},
      bossHp: 5,
    ),
    CategoryDef(
      id: 'gaming',
      name: 'Gaming',
      icon: Icons.sports_esports,
      description: 'Gaming PC and console issues',
      problemKeys: ['game crashing on startup', 'low fps in games', 'controller not connecting', 'game audio stuttering', 'graphics driver crash'],
      levelCount: 5,
      bossName: 'The Lag Dragon',
      bossLore: 'A corrupted game entity that spawns frame drops.',
      deviceTypes: {'desktop', 'laptop', 'console', 'smart_tv'},
      bossHp: 6,
    ),
    CategoryDef(
      id: 'smart_home',
      name: 'Smart Home',
      icon: Icons.home_max,
      description: 'IoT devices and smart home',
      problemKeys: ['smart device offline', 'voice assistant not responding', 'smart light not connecting', 'home hub setup failed', 'automation not triggering'],
      levelCount: 5,
      bossName: 'The Static Specter',
      bossLore: 'A possessed smart home hub that rewrites firmware.',
      deviceTypes: {'smart_home'},
      bossHp: 5,
    ),
    CategoryDef(
      id: 'security',
      name: 'Security',
      icon: Icons.shield,
      description: 'Virus and security threats',
      problemKeys: ['virus or malware infection', 'suspicious pop-ups and browser redirects', 'firewall blocking legitimate apps', 'password not accepted after update', 'wi-fi network showing unauthorized devices'],
      levelCount: 5,
      bossName: 'The Malware Beast',
      bossLore: 'A shape-shifting virus that adapts to every defense.',
      deviceTypes: {'desktop', 'laptop', 'phone', 'tablet'},
      bossHp: 7,
    ),
  ];

  static CategoryDef? byId(String id) {
    for (final c in all) {
      if (c.id == id) return c;
    }
    return null;
  }

  static CategoryDef? byIndex(int index) {
    if (index < 0 || index >= all.length) return null;
    return all[index];
  }

  static int indexOf(String id) => all.indexWhere((c) => c.id == id);
}
